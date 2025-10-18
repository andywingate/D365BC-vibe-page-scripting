## Test Name
This family of tests are called: PO POST TEST

## Purpose

This document describes a simple, repeatable business process for creating a Purchase Order (PO), adding a single item line, and posting the PO in Business Central (or equivalent ERP). It is written as step-by-step actions for a user or for automation scripting.

## Preconditions / Inputs

- Valid user account with procurement permissions (create PO, change lines, post posting rights)
- Supplier/Vendor master record exists (supplier name, vendor no, currency, payment terms)
- Item master record exists (item number, description, unit of measure, standard/unit cost)
- Approved budget available or approval thresholds known (if approvals required)

## Expected Outputs

- A saved Purchase Order visible in the PO list
- One PO line for the requested item with the correct quantity and unit price
- A posted Purchase Order document and corresponding ledger entries (inventory, AP) depending on posting setup

---

## Step-by-step process (Draft, Add One Item, Post)

1. Start a new Purchase Order (Draft)
   - Action: Navigate to Purchase Orders > New (or Create Purchase Order)
   - Input: Select Vendor (search by vendor number or name)
   - Check: Vendor terms and currency displayed on the header
   - Result: Blank PO header created (Status = Open / Draft)

2. Complete PO header details
   - Action: Fill in mandatory header fields
     - Document Date (default: today)
     - Posting Date (as required)
     - Vendor Invoice No (optional at draft time)
     - Location Code (if multi-location inventory)
     - Ship-to address / Contact (if required)
   - Check: Mandatory fields are not empty and currency matches vendor

3. Add a single item line
   - Action: On the Lines section click Add Line > Item
   - Input: Enter Item No (or search), Quantity, and Unit Cost (or allow default)
   - Optional: Add Description, Requested Receipt Date, and any Line Dimension(s)
   - Check: Line totals calculate correctly (Quantity * Unit Cost + any line discounts)
   - Result: PO now has exactly one line with correct amounts

4. Validate pricing, inventory and vendor data
   - Action: Review the line and header for pricing/currency mismatches
   - Check: Item unit cost matches expected cost or has an approved variance
   - Optional: Confirm available inventory at Location or lead time if required for planning

5. Save the Purchase Order (Draft Save)
   - Action: Click Save / OK
   - Result: PO record persisted with a PO No (if system sequences automatically)

6. Obtain approvals (if applicable)
   - Action: Submit PO for approval per company workflow, or route to approver
   - Check: Approval status changes to Approved (or Released) before posting if required by policy

7. Post the Purchase Order
   - Pre-check: Ensure PO status is Approved/Released (if approval workflow exists)
   - Action: Select the PO > Posting > Post as Purchase Order (or Post and Print)
   - Input: Choose whether to print or send (optional), and confirm posting date
   - Result: System posts the PO. Posting generates related entries (Inventory Received, AP Invoice documents depend on your posting setup and whether you use separate receipt/invoice posting)

8. Confirm posting and reconcile
   - Action: View the Posted Purchase Order / Purchase Invoice or related entries in ledger
   - Check: AP aging and inventory valuation updated; PO status marked as Posted or Closed

---

## Quick Checklist (Happy path)

- Vendor exists and currency correct
- Item exists and unit cost is correct
- Single line quantity and totals validated
- Approval completed (if required)
- PO saved and posted without errors

## Common edge cases and how to handle them

- Missing supplier record: Create supplier first or assign a temporary one following procurement policy.
- Item not in master: Create the item with minimal required fields or order as a non-inventory item if allowed.
- Currency or price mismatch: Verify vendor pricing and exchange rates before posting; raise price variance for approval if exceeding tolerance.
- Approval required but not complete: Do not post until approved; follow escalation for urgent POs.
- Posting blocked by inventory setup or dimensions: Check location, inventory posting groups, and dimensions; correct and retry.
- Duplicate PO prevention: Verify recent POs to same supplier for same items before posting.

## Acceptance criteria

- New PO can be created, saved and assigned a PO number
- One line added with correct quantity and price and visible on the PO
- PO can be posted and results in expected ledger changes (inventory/AP)
- No blocking errors during save/post

## Notes and implementation tips

- For automation, ensure the automation script authenticates with a service account that has create/post permissions and handle UI/dialog confirmations.
- If using API integration, map the fields in this script to the API payload: vendorId, documentDate, postingDate, location, lines[{itemId, quantity, unitPrice, description}].
- Keep the happy path simple in training and document exception handling in separate runbooks.
