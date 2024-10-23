# Health Insurance Smart Contract
A decentralized Clarity-based smart contract to verify health insurance coverage, automate claims processing, and manage insurance plans. This project aims to reduce administrative costs and prevent fraud in the health insurance industry by using blockchain technology for transparency and automation.

Features
Insurance Registration: Users can register their insurance plans with a specified coverage amount.
Insurance Verification: Retrieve the status of a user’s insurance to check coverage and activity status.
Claim Submission: Users can submit claims based on their insurance status.
Claim Approval: Claims can be approved by authorized entities, ensuring the process remains secure and transparent.
Claim Retrieval: Retrieve details of claims using claim IDs.
Contract Structure
The project is implemented in Clarity, a language specifically designed for writing smart contracts on the Stacks blockchain. The codebase is divided into several functions, each responsible for a different aspect of the health insurance and claims lifecycle.

Functions Overview
Constants:

ERR_INSURANCE_NOT_FOUND: Error when an insurance plan is not found.
ERR_CLAIM_EXCEEDS_COVERAGE: Error when a claim amount exceeds the coverage or insurance is inactive.
ERR_CLAIM_NOT_FOUND: Error when a claim is not found.
ERR_SELF_APPROVE: Error when a user attempts to approve their own claim.
ERR_INVALID_COVERAGE: Error for invalid coverage amounts.
ERR_INVALID_CLAIM_ID: Error for invalid claim IDs.
Data Variables:

insurance-plans-counter: Tracks the number of insurance plans registered.
claims-counter: Tracks the number of claims submitted.
Mapping:

insurance-plans: Maps users (principals) to their insurance plan details (coverage amount and active status).
claims: Maps claim IDs to claim details (patient, claim amount, and approval status).
Core Functions
register-insurance (coverage-amount: uint): Registers an insurance plan for a user with the specified coverage-amount.

Validates that the coverage amount is greater than zero.
Stores insurance details using the map-set function.
get-insurance-status (user: principal): Retrieves the status of a user’s insurance, including their coverage amount and whether it is active.

Returns an error if no insurance is found for the user.
submit-claim (claim-amount: uint): Allows users to submit claims.

Checks that the claim amount does not exceed the user's coverage.
Only processes claims for users with active insurance.
Stores claim details using map-set and increments claims-counter.
approve-claim (claim-id: uint): Approves a submitted claim by its ID.

Prevents users from approving their own claims.
Validates that the claim-id is valid.
Updates claim status using map-set to indicate that the claim has been approved.
get-claim (claim-id: uint): Retrieves the details of a claim using the provided claim-id.

Returns an error if the claim does not exist.
Project Setup
Prerequisites
Clarinet: A development tool for Clarity smart contracts.
Stacks CLI: To interact with the Stacks blockchain.
Installation
Clone the Repository:

bash
Copy code
git clone https://github.com/henryno111/health-insurance-contract.git
cd health-insurance-contract
Install Clarinet: Follow the instructions here to install Clarinet.

Run Tests: To ensure the contract works as expected:

bash
Copy code
clarinet test
Usage
Register Insurance:

Call the register-insurance function with a positive coverage-amount to register a new insurance plan.
Check Insurance Status:

Use the get-insurance-status function to verify if a user's insurance plan is active and view their coverage.
Submit a Claim:

Call the submit-claim function with the desired claim-amount to file a claim against the user's coverage.
Approve a Claim:

Authorized entities can approve claims using the approve-claim function by providing a valid claim-id.
View Claim Details:

Retrieve information on a specific claim using the get-claim function.
Development Workflow
The contract is split into six commits to ensure a smooth development process:

- Commit 1: Define constants and data variables.
- Commit 2: Add insurance plan registration logic.
- Commit 3: Implement insurance status retrieval.
- Commit 4: Implement claim submission logic.
- Commit 5: Add claim approval logic.
- Commit 6: Implement claim retrieval functionality.


Joint PRs
PR 1: Contains commits 1-3, which focus on setting up the foundational components of the contract, including constants, data variables, and the core insurance registration functionality.
PR 2: Contains commits 4-6, which extend the contract's capabilities by adding claim submission, approval, and retrieval functionalities.
Future Enhancements
Enhanced Claim Validation: Implement checks for duplicate claims.
Multi-Signature Approvals: Allow multiple entities to approve high-value claims.
Insurance Plan Upgrades: Enable users to update their insurance plans to increase coverage.
License


This project is licensed under the MIT License. See the LICENSE file for details.