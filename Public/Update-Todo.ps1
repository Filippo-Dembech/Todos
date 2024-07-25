<#
.SYNOPSIS
    Updates an active TODO item with new text or category.

.DESCRIPTION
    This function updates an active TODO item based on the specified parameters. It allows you to update the text and/or category of a TODO item by specifying its ID. 
    You can also update all items, amend the last item, or filter items by category.

.PARAMETER Id
    The ID of the active TODO item to update. This parameter is required unless using the '-Amend' switch.

.PARAMETER NewText
    The new text for the active TODO item. If this is not provided, the text remains unchanged.

.PARAMETER NewCategory
    The new category for the active TODO item. If this is not provided, the category remains unchanged.

.PARAMETER Category
    Updates the active TODO item within a specific category. This parameter is required when using the 'Category' parameter set.

.PARAMETER All
    Updates all active TODO items. This switch is required when using the 'All' parameter set.

.PARAMETER Amend
    Updates the last active TODO item in the list. If '-Amend' is used
    items can't be updated by '-Id'.

.EXAMPLE
    Update-Todo -Id 2 -NewText "Buy groceries" -Category "Home"

    Updates the TODO item with ID 2 in the "Home" category with the new text "Buy groceries".

.EXAMPLE
    Update-Todo -All -NewCategory "Work"

    Updates the category of all TODO items to "Work".

.EXAMPLE
    Update-Todo -Amend -NewText "Finish report"

    Updates the text of the last TODO item in the list to "Finish report".

#>
function Update-Todo {
    param(
        [Parameter(ParameterSetName = "Category")]
        [Parameter(ParameterSetName = "All")]
        [string]$Id,
        [string]$NewText,
        [string]$NewCategory,
        [Parameter(
            ParameterSetName = "Category"
        )]
        [string]$Category,
        [Parameter(
            ParameterSetName = "All"
        )]
        [switch]$All,
        [Parameter(
            ParameterSetName = "Amend"
        )]
        [switch]$Amend
    )

    $Todos = Get-Todo -All -Raw

    if ($Category) {
        $CategoryId = 0
        for ($i = 0; $i -lt $Todos.count; $i++) {
            if ($Todos[$i].Category -eq $Category) {
                if ($CategoryId -eq $Id) {
                    if ($NewText) {
                        $Todos[$i].Text = $NewText
                    }
                    if ($NewCategory) {
                        $Todos[$i].Category = $NewCategory
                    }
                }
                $CategoryId++
            }
        }
    } elseif ($All) {
        for ($i = 0; $i -lt $Todos.count; $i++) {
            if ($i -eq $Id) {
                if ($NewText) {
                    $Todos[$i].Text = $NewText
                }
                if ($NewCategory) {
                    $Todos[$i].Category = $NewCategory
                }
            }
        }
    } elseif ($Amend) {

        if ($NewText) {
            $Todos[$Todos.count - 1].Text = $NewText
        }
        if ($NewCategory) {
            $Todos[$Todos.count - 1].Category = $NewCategory
        }
    } else {
        $CurrentCategory = Get-CurrentTodoCategory
        $CategoryId = 0
        for ($i = 0; $i -lt $Todos.count; $i++) {
            if ($Todos[$i].Category -eq $CurrentCategory) {
                if ($CategoryId -eq $Id) {
                    if ($NewText) {
                        $Todos[$i].Text = $NewText
                    }
                    if ($NewCategory) {
                        $Todos[$i].Category = $NewCategory
                    }
                }
            }
        }
    }

    $Todos | Export-Csv -Path "$PSScriptRoot\..\Utils\active_todos.csv"

}