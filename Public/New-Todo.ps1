<#
.SYNOPSIS
    Creates a new active TODO item.

.DESCRIPTION
    The 'New-Todo' function adds a new active TODO item to the list.
    You can specify the text and optionally the category for the new item.
    If the category is not provided, the function assigns the current TODO category to the new item.
    To get the current TODO category use the 'Get-CurrentTodoCategory' command.

.PARAMETER Text
    The text for the new active TODO item. This parameter is mandatory.

.PARAMETER Category
    The category for the new active TODO item. If this is not provided, the current TODO category will be used.
    To get the current TODO category use the 'Get-CurrentTodoCategory' command.

.EXAMPLE
    New-Todo -Text "Buy groceries"

    Creates a new active TODO item with the text "Buy groceries" and assigns it to the current category.

.EXAMPLE
    New-Todo -Text "Prepare presentation" -Category "Work"

    Creates a new active TODO item with the text "Prepare presentation" in the "Work" category.

#>
function New-Todo {
    param(
        [Parameter(
            Mandatory,
            Position = 0
        )]
        [string]$Text,
        [Parameter(
            Position = 1
        )]
        [string]$Category
    )

    $ActiveTodosDirectory = "$PSScriptRoot\..\Utils\active_todos.csv"

    $Todos = Import-Csv $ActiveTodosDirectory

    $Id = $todos.count + 1

    if ($Category) {
        $TodoCategory = $Category
    } else {
        $TodoCategory = Get-CurrentTodoCategory
    }

    $Todo = [PSCustomObject]@{
        Id = $Id
        Text = $Text
        Category = $TodoCategory
    }

    $TodoCSV = @{
        InputObject = $Todo
        Path = $ActiveTodosDirectory
        Append = $true
    }

    Export-Csv @TodoCSV

}