<#
.SYNOPSIS
    Removes a TODO item based on its ID.

.DESCRIPTION
    The 'Remove-Todo' function deletes an active TODO item specified by its ID. It can remove the item from a specific category, from all categories, or from the current category if none are specified.

.PARAMETER Id
    The ID of the active TODO item to be removed. This parameter is mandatory.

.PARAMETER Category
    Specifies the category from which to remove the active TODO item. If this is not provided and the '-All' switch is not used, the item will be removed from the current category.

.PARAMETER All
    Removes the active TODO item from all the active TODO items regardless its category id.

.EXAMPLE
    Remove-Todo -Id 2 -Category "Home"

    Removes the active TODO item with ID 2 from the "Home" category.

.EXAMPLE
    Remove-Todo -Id 2 -All

    Removes the active TODO item with ID 2 from all categories.

.EXAMPLE
    Remove-Todo -Id 2

    Removes the active TODO item with ID 2 from the current category.

#>
function Remove-Todo {
    param(
        [Parameter(
            Mandatory
        )]
        [string]$Id,
        [Parameter(
            ParameterSetName = "Category"
        )]
        [string]$Category,
        [Parameter(
            ParameterSetName = "All"
        )]
        [switch]$All
    )

    $Result = @()

    if ($Category) {
        $Result += Delete-Todo -Id $Id -From $Category 
    } elseif ($All) {
        $Result += Delete-Todo -Id $Id -FromAll 
    } else {
        $CurrentCategory = Get-CurrentTodoCategory
        $Result += Delete-Todo -Id $Id -From $CurrentCategory
    }

    $Result | Export-Csv -Path "$PSScriptRoot\..\Utils\active_todos.csv"

}