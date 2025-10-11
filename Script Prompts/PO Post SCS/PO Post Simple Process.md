# Business Process Test Definition

## Purpose
This document describes a base business process (happy path) encapsulates in a series of test scripts. The base script has been used to generate a library of scripts to test all permutations in scope of the test suite. Testing is carried out in a suitable instance of **Microsoft Dynamics 365 Business Central** with the test automaton tool playwright.  

## Test Family
This family of tests cover the simple creation and posting of a Purchase Order. 

## Preconditions / Test Setup 

### Technical Setup

- A specific service account **Test-Runner** must be created with no requirement for MFA or self-service password reset.
-  Test-Runner permissions and D365 BC Environment & company access must be configured prior to test automation processing.

### Test Company Data State

- Test vendor record exists (Vendor No: 1000 - The Cannon Group PLC)
- Test item records exist (Items: 1896-S, 1900-S, 1906-S)
- Test location records exist (Locations: BLUE, EAST, MAIN)
- No approval workflows enabled (for simple testing scenario)

## Expected Test Outputs

- Purchase Order successfully posted
- Posted Purchase Invoice
- One posted purchase line with the specified item, quantity 1, and system-calculated unit cost
- Corresponding posted purchase receipt and vendor ledger entries created

---

## Step-by-step Business Central Process

### 1. Navigate to Purchase Orders
   - **Action**: From Business Manager Role Center, select "Purchase Orders"
   - **Result**: Purchase Order List page opens

### 2. Create New Purchase Order
   - **Action**: Click "New" button on Purchase Order List
   - **Result**: New Purchase Order page opens

### 3. Set Vendor Information
   - **Action**: Click in "Buy-from Vendor No." field
   - **Input**: Enter "1000" (The Cannon Group PLC)
   - **Result**: Vendor details auto-populate (name, currency, payment terms)

### 4. Configure Ship-to Location
   - **Action**: Set "Ship-to" option to "Location" (value: 1)
   - **Purpose**: Enables Location Code field for input

### 5. Set Location Code
   - **Action**: Click in "Location Code" field
   - **Input**: Select location (BLUE, EAST, or MAIN)
   - **Result**: Location lookup opens, select from list

### 6. Add Item Line
   - **Action**: Navigate to Lines section, click in "No." field
   - **Input**: Enter item number (1896-S, 1900-S, or 1906-S)
   - **Result**: Item lookup opens, select item, details auto-populate

### 7. Set Quantity
   - **Action**: Click in "Quantity" field on the line
   - **Input**: Enter "1"
   - **Result**: Line amounts calculate automatically

### 8. Post Purchase Order
   - **Action**: Click "Post..." button
   - **Dialog**: Post confirmation dialog appears
   - **Action**: Click "OK" to confirm posting
   - **Result**: PO is posted, page closes, returns to list

---

## Test Data Variations

The process will be tested across multiple combinations:

### Vendor
- **Fixed**: 1000 (The Cannon Group PLC)

### Items (3 variations)
- 1896-S (ATHENS Desk)
- 1900-S (ANTWERP Conference Table)  
- 1906-S (MEXICO Swivel Chair)

### Locations (3 variations)
- BLUE (Blue Warehouse)
- EAST (East Location)
- MAIN (Main Location)

### Total Test Matrix
- **9 test variations** (3 items × 3 locations)
- Each test covers the complete process end-to-end

---

## Business Process Validation

After successful process completion, verify in BC:
- Purchase Order number series had incremented correctly.
- Posted Purchase lines show correct item, quantity, and calculated amounts  
- Document status shows as "Posted" 
- Posted Purchase Receipt created with same document number
- Vendor Ledger Entry created for the purchase amount
- Item Ledger Entry created for inventory receipt
- Appropriate posting to G/L 
