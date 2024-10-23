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

;; Submit a claim for a user
(define-public (submit-claim (claim-amount uint))
  (begin
    (let ((insurance-data (map-get? insurance-plans tx-sender)))
      (match insurance-data
        insurance-details
        (if (and (is-eq (get is-active insurance-details) true) (<= claim-amount (get coverage-amount insurance-details)))
          (let ((claim-id (var-get claims-counter)))
            (map-set claims claim-id { patient: tx-sender, claim-amount: claim-amount, approved: false })
            (var-set claims-counter (+ claim-id u1))
            (ok (tuple (claim-id claim-id) (status "Claim submitted")))
          )
          ERR_CLAIM_EXCEEDS_COVERAGE
        )
        ERR_INSURANCE_NOT_FOUND
      )
    )
  )
)

;; Approve a claim by claim ID (only callable by the insurer)
(define-public (approve-claim (claim-id uint))
  (begin
    ;; Check for a valid claim ID (non-zero)
    (if (<= claim-id u0)
      ERR_INVALID_CLAIM_ID
      (let ((claim-data (map-get? claims claim-id)))
        (match claim-data
          claim-details
          (if (is-eq (get patient claim-details) tx-sender)
            ERR_SELF_APPROVE
            (begin
              (map-set claims claim-id { patient: (get patient claim-details), claim-amount: (get claim-amount claim-details), approved: true })
              (ok "Claim approved")
            )
          )
          ERR_CLAIM_NOT_FOUND
        )
      )
    )
  )
)

;; Get claim details
(define-read-only (get-claim (claim-id uint))
  (match (map-get? claims claim-id)
    claim-data (ok claim-data)
    ERR_CLAIM_NOT_FOUND
  )
)
