# TODO - SCS Demo 1: Post Purchase Order

This file tracks progress for the "Post Purchase Order" scripting project.

## Goal
Create a clean, reliable Business Central page script (YAML) that:
- Creates a Purchase Order header
- Adds one or more lines
- Sets any dependent fields (e.g., Location Code) correctly
- Posts the Purchase Order

---

## Checklist / Milestones
- [ ] Gather reference recordings (raw + clean) for: create PO, add lines, set dependencies, post PO
- [ ] Create a single clean reference script (YAML) covering the entire workflow
- [ ] Create a test CSV with one variation and generate one test script
- [ ] Validate by running the test script and collect results
- [ ] Generate full batch variations (if required)
- [ ] Finalize scripts and add to `Generated Scripts/`

---

## Notes / Guidance
Follow the patterns in `README.md`: use `set-current-row` for new lines, avoid `isFilterAsYouType`, remove lookup page events, and ensure field visibility dependencies are set before accessing dependent fields.

If any required reference recording is missing, please provide a recording (raw is OK but a clean recording is preferred). See "What I need from you" below.

---

## What I need from you next
1. Reference recording(s) showing the full PO workflow:
   - Creating a Purchase Order header (Vendor, Document Date, Posting Date, Ship-to/Location dependency if used)
   - Adding at least one line (Item No., Quantity, Location Code if applicable)
   - Posting the Purchase Order (the Post action)

   Preferably provide both a raw recording and a cleaned example if you already have one. If you only have one, that's fine — I can work from it.

2. (Optional now) A small CSV with 1-3 rows of sample values for: VendorNo, ItemNo, Quantity, LocationCode (if used). This lets me produce a test variation.

3. Tell me whether you want me to: (A) generate the clean reference script next, or (B) wait until you attach recordings. I recommend (A) only if you attach a recording now.

---

## Owner
- Assigned to: Project (you and me while we collaborate)


---

I'll start by creating the reference script once I have the recording(s).