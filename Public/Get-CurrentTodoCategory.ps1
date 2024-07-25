<#
.SYNOPSIS
    Retrieves the current TODO category.

.DESCRIPTION
    The 'Get-CurrentTodoCategory' function returns the current TODO category. This category can be used to filter or categorize TODO items.

.OUTPUTS
    The current TODO category as a string.

.EXAMPLE
    $currentCategory = Get-CurrentTodoCategory

    Retrieves the current TODO category and stores it in the $currentCategory variable.

.NOTES
    Ensure that the path to the current_category.json file is correctly defined in your script environment.
    The JSON file should contain a property named 'CurrentCategory'.
#>
function Get-CurrentTodoCategory {
    $CurrentCategoryJson = Get-Content "$PSScriptRoot\..\Utils\current_category.json" -Raw | ConvertFrom-Json
    return $CurrentCategoryJson.CurrentCategory
}