<#
.SYNOPSIS
    Retrieves TODO items based on specified parameters.

.DESCRIPTION
    The 'Get-Todo' function fetches TODO items.
    You can retrieve all items, items within a specific category, or items in the current category.
    Optionally, the function can return the raw data without formatting.

.PARAMETER Category
    Specifies the category of active TODO items to retrieve. This parameter is used when the 'Category' parameter set is specified.

.PARAMETER All
    Retrieves all active TODO items. This switch is used when the 'All' parameter set is specified.

.PARAMETER Raw
    Returns the raw CSV data without formatting. This switch is used when operations need be performed on todos items.

.PARAMETER Registered
    Returns all the registered TODO items.

.EXAMPLE
    Get-Todo -Category "Home"

    Retrieves TODO items in the "Home" category.

.EXAMPLE
    Get-Todo -All

    Retrieves all TODO items.

.EXAMPLE
    Get-Todo

    Retrieves TODO items in the current category.

.EXAMPLE
    Get-Todo -Raw

    Retrieves the raw TODO items data without formatting.

.NOTES
    This function imports TODO items from a CSV file located at "$PSScriptRoot\..\Utils\todos.csv".
    Ensure that the CSV file path and the Get-CurrentTodoCategory function are correctly defined in your script environment.
#>
function Get-Todo {

    [CmdletBinding(DefaultParameterSetName="Category")]
    param(
        [Parameter(
            ParameterSetName="Category"
        )]
        [string]$Category,
        [Parameter(
            ParameterSetName="All"
        )]
        [switch]$All,
        [switch]$Raw,
        [Parameter(
            ParameterSetName="Registered"
        )]
        [switch]$Registered
    )

    $ActiveTodosDirectory = "$PSScriptRoot\..\Utils\active_todos.csv"
    $RegisteredTodosDirectory = "$PSScriptRoot\..\Utils\registered_todos.csv"


    if ($All) {
        $Result = Import-Csv $ActiveTodosDirectory
    } elseif ($Category) {
        $Todos = Import-Csv $ActiveTodosDirectory
        $Result = $Todos | Where-Object { $_.Category -eq $Category }
    } elseif ($Registered) {
        $Result = Import-Csv $RegisteredTodosDirectory
    } else {
        $Todos = Import-Csv $ActiveTodosDirectory
        $CurrentCategory = Get-CurrentTodoCategory
        $Result = $Todos | Where-Object { $_.Category -eq $CurrentCategory }
    }

    $global:i = -1

    if ($Raw) {
        return $Result
    }

    $Result | Format-Table @{
                                Name = "Id";
                                Expression={$global:i++;"($global:i)"}; 
                                Width = 7;
                                Alignment = "center" 
                            },
                            @{
                                Name = "Text";
                                Expression={$_.Text};
                                Width = 50
                            },
                            @{
                                Name = "Category";
                                Expression={$_.Category};
                                Width=25
                            } -Wrap


}