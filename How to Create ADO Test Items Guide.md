# How to Create Azure DevOps Test Items Guide

This guide covers how to create and manage Azure DevOps Test Cases using the MCP (Model Context Protocol) connection.

## 📋 Overview

Azure DevOps Test Cases have specific fields and structures that need to be populated correctly for proper test execution and management.

## 🏗️ Test Case Structure

### Key Fields
- **System.Title** - Test case title
- **System.Description** - Overall test description, objectives, and prerequisites 
- **Microsoft.VSTS.TCM.Steps** - Individual test steps with actions and expected results
- **System.Tags** - Tags for categorization and filtering
- **Microsoft.VSTS.TCM.AutomationStatus** - Automation status (Not Automated, Automated, etc.)

## 🔧 Creating Test Cases

### 1. Basic Test Case Creation

```javascript
mcp_ado_wit_create_work_item({
  "project": "ProjectName",
  "workItemType": "Test Case",
  "fields": [
    {"name": "System.Title", "value": "Test Case Title"},
    {"name": "System.Description", "value": "Test description"},
    {"name": "System.Tags", "value": "tag1; tag2; tag3"}
  ]
})
```

### 2. Adding Detailed Description

The Description field should include:
- **Test Objective** - What is being tested
- **Prerequisites** - Required setup conditions
- **Expected Results** - High-level success criteria
- **Test Script Reference** - Link to automation scripts if applicable

Example Description format:
```html
<div>
<strong>Test Objective:</strong><br/>
Clear statement of what functionality is being tested<br/><br/>

<strong>Prerequisites:</strong><br/>
- System is accessible<br/>
- Required data exists<br/>
- User has appropriate permissions<br/><br/>

<strong>Expected Results:</strong><br/>
- All operations complete successfully<br/>
- Data is correctly processed<br/>
- No errors occur<br/><br/>

<strong>Test Script Reference:</strong> filename.yml
</div>
```

## 📝 Test Steps Structure

### Understanding the Steps Field

The `Microsoft.VSTS.TCM.Steps` field uses a specific XML format:

```xml
<steps id="0" last="[number_of_steps]">
  <step id="1" type="ActionStep">
    <parameterizedString isformatted="true">[ACTION TO PERFORM]</parameterizedString>
    <parameterizedString isformatted="true">[EXPECTED RESULT]</parameterizedString>
    <description/>
  </step>
  <!-- Repeat for each step -->
</steps>
```

### Step Components

Each step contains:
1. **Action** (first parameterizedString) - What the tester should do
2. **Expected Result** (second parameterizedString) - What should happen
3. **Description** - Additional notes (usually empty)

### 🚨 Common Issues and Solutions

#### Issue: Actions not showing in Steps tab
**Problem**: The XML format is incorrect or the parameterizedString elements are in wrong order

**Solution**: Ensure proper XML structure:
- First `<parameterizedString>` = Action to perform
- Second `<parameterizedString>` = Expected result
- Use `isformatted="true"` for HTML formatting
- Use `<br/>` for line breaks

#### Issue: Steps appear as single line
**Problem**: Missing HTML formatting or line breaks

**Solution**: Use HTML formatting in the parameterizedString:
```xml
<parameterizedString isformatted="true">
Step Action:<br/>
- Detailed action 1<br/>
- Detailed action 2<br/>
- Detailed action 3
</parameterizedString>
```

## 📊 Test Step Examples

### Simple Step
```xml
<step id="1" type="ActionStep">
  <parameterizedString isformatted="true">Click the 'New' button</parameterizedString>
  <parameterizedString isformatted="true">New item dialog opens</parameterizedString>
  <description/>
</step>
```

### Complex Step with Multiple Actions
```xml
<step id="2" type="ActionStep">
  <parameterizedString isformatted="true">
    Set Vendor Information:<br/>
    - Focus on 'Vendor No.' field<br/>
    - Enter '1000' in the Vendor No. field<br/>
    - Focus on 'Vendor Name' field to confirm vendor selection
  </parameterizedString>
  <parameterizedString isformatted="true">
    Vendor information populates automatically and vendor name is displayed
  </parameterizedString>
  <description/>
</step>
```

## 🔄 Updating Test Cases

### Update Existing Test Case
```javascript
mcp_ado_wit_update_work_item({
  "id": [work_item_id],
  "updates": [
    {
      "op": "replace",
      "path": "/fields/Microsoft.VSTS.TCM.Steps",
      "value": "[complete_steps_xml]"
    }
  ]
})
```

### Batch Updates
```javascript
mcp_ado_wit_update_work_items_batch({
  "updates": [
    {
      "id": [work_item_id_1],
      "op": "Replace",
      "path": "/fields/Microsoft.VSTS.TCM.Steps",
      "value": "[steps_xml_1]"
    },
    {
      "id": [work_item_id_2],
      "op": "Replace", 
      "path": "/fields/Microsoft.VSTS.TCM.Steps",
      "value": "[steps_xml_2]"
    }
  ]
})
```

## 🏷️ Tagging Strategy

### Effective Tags
- **Technology**: BC, Dynamics365, AL
- **Module**: Purchase Order, Sales, Inventory
- **Function**: Posting, Creation, Update
- **Item/Location**: Item-1896S, Location-BLUE
- **Test Type**: Smoke, Regression, Integration

Example: `"BC; Purchase Order; Posting; Item-1896S; Location-BLUE"`

## 🔍 Troubleshooting

### Check Test Case Fields
```javascript
mcp_ado_wit_get_work_item({
  "id": [work_item_id],
  "project": "ProjectName",
  "expand": "all"
})
```

### Common Field Issues
1. **Steps not visible**: Check XML format and ensure `type="ActionStep"`
2. **Formatting lost**: Ensure `isformatted="true"` is set
3. **Updates not saving**: Verify field paths are correct
4. **Characters not displaying**: Use HTML entities for special characters

## 📚 Best Practices

### 1. Consistent Naming
- Use descriptive, consistent test case titles
- Include key variables (item codes, locations) in titles
- Follow project naming conventions

### 2. Comprehensive Steps
- Break complex actions into smaller steps
- Include verification points
- Specify exact values to enter
- Describe expected system responses

### 3. Maintainable Tests
- Keep prerequisites up to date
- Reference automation scripts when available
- Use parameterization for reusable tests
- Tag appropriately for easy filtering

### 4. Quality Assurance
- Review test cases before execution
- Validate steps make sense to other testers
- Ensure expected results are specific and measurable
- Test the test steps manually before automation

## 📖 Reference Links

- [Azure DevOps Test Case Fields](https://docs.microsoft.com/en-us/azure/devops/boards/work-items/guidance/manage-test-suites)
- [Work Item Field Reference](https://docs.microsoft.com/en-us/azure/devops/boards/work-items/field-reference)
- [Test Case XML Schema](https://docs.microsoft.com/en-us/azure/devops/test/manual-testing)

---

## 🚀 Quick Start Template

```javascript
// 1. Create basic test case
mcp_ado_wit_create_work_item({
  "project": "YourProject",
  "workItemType": "Test Case", 
  "fields": [
    {"name": "System.Title", "value": "Your Test Title"},
    {"name": "System.Tags", "value": "YourTags"}
  ]
})

// 2. Add detailed steps  
mcp_ado_wit_update_work_item({
  "id": [returned_id],
  "updates": [
    {
      "op": "replace",
      "path": "/fields/Microsoft.VSTS.TCM.Steps",
      "value": "<steps id=\"0\" last=\"2\"><step id=\"1\" type=\"ActionStep\"><parameterizedString isformatted=\"true\">Your Action</parameterizedString><parameterizedString isformatted=\"true\">Expected Result</parameterizedString><description/></step><step id=\"2\" type=\"ActionStep\"><parameterizedString isformatted=\"true\">Next Action</parameterizedString><parameterizedString isformatted=\"true\">Next Expected Result</parameterizedString><description/></step></steps>"
    }
  ]
})
```