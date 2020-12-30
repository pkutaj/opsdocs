#aim: script that is used as entry-point for creating a KB article for Snowplow Analytics and offers to push all new/modified docs to Zendesk

$intro = @"

          %%%%%%%%%%%%%%        
        %%%%           %%       
       %%  %%/          %%%     SNOWPLOW'S OPSDOCS 
     #%(     %%           %%    ~~~~~~~~~~~~~~~~~~~
    %%        %%/          %%   
   %%          /%%%%%%%%%%%%%   CREATE NEW ONE OR  
    %%.       %%,          %%   ... PUSH THEM ALL TO ZD 
     (%%    .%%          ,%%    
       %%. %%*          %%(  
        %%%%           %%    
          %%%%%%%%%%%%%% 

"@

function convertTo-fileName ($docTitle) {
    #aim: convert "Document Title" into "Document-Title.md"
    $fileName = ("$docTitle" -replace "\s", "-") -replace ".+", "$&.md"
    return $fileName
}
function create-NewDoc($filename) {
    #aim: populate the newly created file with a template
    $templatePath = ".\template.md"
    $filePath = "..\demo\$filename"
    $template = Get-Content $templatePath
    Set-Content $filePath -Value  $template
    Invoke-Item $filePath
}
function update-configFile($docTitle, $fileName) {
    #aim: create a new node in the config.yaml and populate it with doc title and file path
    $conf = ".\config.yaml"
    $existingDocs = gc $conf | ConvertFrom-Yaml -Ordered
    $newDoc = @([ordered]@{
            id      = $null; 
            title   = "$docTitle"; 
            file    = "../demo/$fileName"; 
            hash    = $null 
            webLink = $null
        })
    
    $articlesHelper = $existingDocs.sections.articles
    $articlesHelper += $newDoc
    
    $existingDocs.sections[0].remove('articles')
    $existingDocs.sections[0].add('articles', $articlesHelper)
    
    ConvertTo-Yaml $existingDocs -OutFile $conf -Force
    Invoke-Item $conf
}

function publish-toZendesk {
    #aim: run the publish.js script that publishes new and updated docs to zendesk
    $scriptFolder = ".\"
    $scriptFile = "publish.js"
    Start-Process node $scriptFile -WorkingDirectory $scriptFolder 
    Write-Host "new opsdocs pushed to zendesk"
}

Write-Host $intro
$userSelection = Read-Host "ENTER TITLE OR WRITE 'PUSH' TO SEND TO ZENDESK"
switch ($userSelection) {
    "push" { 
        publish-toZendesk
    }
    default { 
        $docTitle = $userSelection
        $fileName = convertTo-fileName -docTitle $docTitle
        create-NewDoc -filename $fileName
        update-configFile -docTitle $docTitle -fileName $fileName
    }
    
}