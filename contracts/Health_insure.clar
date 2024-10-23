;; Contract: health-insurance.clar
;; This contract is designed to verify health insurance coverage and automate claims processing.

;; Constants
(define-constant ERR_INSURANCE_NOT_FOUND (err u100)) ;; Error code for when insurance is not found.
(define-constant ERR_CLAIM_EXCEEDS_COVERAGE (err u101)) ;; Error when the claim exceeds coverage or insurance is inactive.
(define-constant ERR_CLAIM_NOT_FOUND (err u102)) ;; Error for when a claim is not found.
(define-constant ERR_SELF_APPROVE (err u103)) ;; Error for when an insurer attempts to approve their own claim.
(define-constant ERR_INVALID_COVERAGE (err u104)) ;; Error for invalid coverage amount.
(define-constant ERR_INVALID_CLAIM_ID (err u105)) ;; Error for invalid claim ID.

;; Data Variables
(define-data-var insurance-plans-counter uint u0)
(define-data-var claims-counter uint u1)

;; Define an insurance plan for a user
(define-map insurance-plans principal { coverage-amount: uint, is-active: bool })
(define-map claims uint { patient: principal, claim-amount: uint, approved: bool })

;; Define an insurance plan for a user
(define-public (register-insurance (coverage-amount uint))
  (begin
    ;; Check for a valid coverage amount (non-zero)
    (if (<= coverage-amount u0)
      ERR_INVALID_COVERAGE
      (begin
        (map-set insurance-plans tx-sender { coverage-amount: coverage-amount, is-active: true })
        (ok "Insurance registered successfully")
      )
    )
  )
)

;; Verify if a user's insurance is active and their coverage amount
(define-read-only (get-insurance-status (user principal))
  (match (map-get? insurance-plans user)
    insurance-data (ok insurance-data)
    ERR_INSURANCE_NOT_FOUND
  )
)
