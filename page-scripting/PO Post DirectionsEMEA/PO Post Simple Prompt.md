**Instructions:**
- You are an expert BC page script generator. I need you to create/modify Business Central (BC) page automation scripts in YAML format following proven patterns.
- You must ALWAYS request reference recordings before implementing any new BC actions. Never guess or improvise - follow exact patterns from examples.
- Do not generate new steps in scripts unless you have been provided an example that shows the exact pattern.
- You must be provided with an explanation of the business processes we are following in MD format so you can understand the steps and help to use this language when debugging issues
- The main task is to help me create a series of scrip files based on the happy path using the additional data I have provided in CSV format for alternative field values. 


**Steps:**
1. **Verify Prerequisites:** Check if I've provided reference recordings for all requested actions in the business process. If any actions lack examples, STOP and request recordings before proceeding.
1. **Test Reference Script:** Ask me if I have tested the base script and it work for the test-runner account before proceeding to variations.
1. **Plan Data Integration:** Review all CSV files containing field values and plan how to create script variations using this data.
1. **Create Test Iteration:** Generate ONE test script variation using CSV data, validate it works completely.
1. **Generate Full Series:** Only after validating the pattern works, create the complete series of script iterations using all CSV data for field values.
1. **Final Quality Check:** Ensure all scripts follow known patterns (i.e. tested examples have been provided ), and include clear documentation.


**Format:**
- Use YAML page script format for Business Central
- Follow the known patterns shown in example scripts or this file

**Example:**
Base all work on proven patterns added to the project folders once we start working  

**Notes:**
- CRITICAL: Request recording examples if you don't have them
- Test dependencies before accessing dependent fields
- Build complexity gradually with tested patterns

**Current task:** 
The PO POST TEST family of tests will test a simple PO process across a series of Items and Locations.

Reference Patterns for the field to change in the variants 

### Item
- type: input
    target:
      - page: Purchase Order
        runtimeRef: b3ej
      - part: PurchLines
      - page: Purchase Order Subform
      - repeater: Control1
      - field: No.
    value: 1964-S
    isFilterAsYouType: true
    description: Input <value>1964-S</value> into <caption>No.</caption>
  - type: close-page
    target:
      - page: lookup:No.
        runtimeRef: b3yi
    description: Close page <caption>Select</caption>
  - type: input
    target:
      - page: Purchase Order
        runtimeRef: b3ej
      - part: PurchLines
      - page: Purchase Order Subform
      - repeater: Control1
      - field: No.
    value: 1964-S
    description: Input <value>1964-S</value> into <caption>No.</caption>

### Location
- type: input
    target:
      - page: Purchase Order
        runtimeRef: b3ej
      - field: Location Code
    value: MAIN
    isFilterAsYouType: true
    description: Input <value>MAIN</value> into <caption>Location Code</caption>
  - type: close-page
    target:
      - page: lookup:Location Code
        runtimeRef: b3zb
    description: Close page <caption>Select</caption>
  - type: input
    target:
      - page: Purchase Order
        runtimeRef: b3ej
      - field: Location Code
    value: MAIN
    description: Input <value>MAIN</value> into <caption>Location Code</caption>
  - type: page-closed
    source:
      page: lookup:Location Code
    runtimeId: b3zb
    description: Page <caption>Select</caption> was closed.


In the first variant script please use alternative values from the Items and Location files provided as context. Start off by creating a single variant script for me to test, I will confirm this then we can move onto using a PowerShell script to create a larger volume of variant test files.