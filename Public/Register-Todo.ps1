<#
    .SYNOPSIS
    Registers an active TODO item by its Id within a specific category or from all TODO items.

    .DESCRIPTION
    The 'Register-Todo' function registers an active TODO item by moving it to a registered TODOs list. The function can filter active TODO items by category or register any item by its Id.

    .PARAMETER Id
    The Id of the active TODO item to be registered. This parameter is mandatory.

    .PARAMETER Category
    Specifies the category of the active TODO item to be registered. This parameter is part of the "Category" parameter set. Use this parameter if you want to register
    an active TODO by using its category id.

    .PARAMETER All
    Indicates that the function should consider all active TODO items regardless of category. This parameter is part of the "All" parameter set.

    .EXAMPLE
    Register-Todo -Id 2 -Category "Work"

    Registers the active TODO item with Id 2 in the "Work" category.

    .EXAMPLE
    Register-Todo -Id 5 -All

    Registers the active TODO item with Id 5 from all TODO items.

    .EXAMPLE
    Register-Todo -Id 1

    Registers the active TODO item with Id 1 from the current category.

#>
function Register-Todo {
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

    $RegisteredTodoDirectory = "$PSScriptRoot\..\Utils\registered_todos.csv"

    $Todos = Get-Todo -All -Raw
    $RegisteredId = (Import-Csv -Path $RegisteredTodoDirectory).count

    #Write-Host "-Id is $Id"
    if ($Category) {
        #Write-Host "-Category has been specified"
        $CategoryId = 0
        for ($i = 0; $i -lt $Todos.count; $i++) {
            if ($Todos[$i].Category -eq $Category) {
                #Write-Host "CurrentTodo: $($Todos[$i])"
                if ($CategoryId -eq $Id) {
                    $RegisteredTodo = $Todos[$i]
                    $RegisteredTodo.Id = $RegisteredId
                    $RegisteredTodo | Export-Csv -Path $RegisteredTodoDirectory -Append
                    Remove-Todo -Id $i -All
                }
                $CategoryId++
            }
        }
    } elseif ($All) {
        #Write-Host "-All has been specified"
        for ($i = 0; $i -lt $Todos.length; $i++) {
            #Write-Host "CurrentTodo: $($Todos[$i])"
            if ($i -eq $Id) {
                $RegisteredTodo = $Todos[$i]
                $RegisteredTodo.Id = $RegisteredId
                $RegisteredTodo | Export-Csv -Path $RegisteredTodoDirectory -Append
                Remove-Todo -Id $i -All
            }
        }
    } else {
        $CurrentCategory = Get-CurrentTodoCategory
        $CategoryId = 0
        #Write-Host "CurrentCategory is being used"
        for ($i = 0; $i -lt $Todos.count; $i++) {
            #Write-Host "CurrentTodo: $($Todos[$i])"
            if ($Todos[$i].Category -eq $CurrentCategory) {
                if ($CategoryId -eq $Id) {
                    $RegisteredTodo = $Todos[$i]
                    $RegisteredTodo.Id = $RegisteredId
                    $RegisteredTodo | Export-Csv -Path $RegisteredTodoDirectory -Append
                    Remove-Todo -Id $i -All
                }
                $CategoryId++
            }
        }
    }
    
    if ($All) {
        Write-Host "Todo $Id has been registered successfully from all!"
    }
    
    if ($Category) {
        Write-Host "Todo $Id has been registered successfully from $Category!"
    }
}