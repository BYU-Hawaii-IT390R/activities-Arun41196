# build-vbox.ps1 – Automate Windows 10 VM creation in VirtualBox

$VBoxManage = "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"
$vmName = "AutomatedWin10"
$vdiPath = "C:\ISO Folder\AutomatedWin10.vdi"
$windowsISO = "C:\ISO Folder\en-us_windows_10_consumer_editions_version_22h2_x64_dvd_8da72ab3.iso"
$answerISO = "C:\ISO Folder\answer.iso"

# Create VM
& $VBoxManage createvm --name $vmName --register

# Set memory, CPU, and OS type
& $VBoxManage modifyvm $vmName --memory 4096 --cpus 2 --ostype "Windows10_64"

# Create a 40 GB virtual disk
& $VBoxManage createmedium disk --filename $vdiPath --size 40000

# Create SATA controller and attach the virtual disk
& $VBoxManage storagectl $vmName --name "SATA Controller" --add sata --controller IntelAhci
& $VBoxManage storageattach $vmName --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium $vdiPath

# Create IDE controller for ISO files
& $VBoxManage storagectl $vmName --name "IDE Controller" --add ide
& $VBoxManage storageattach $vmName --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium $windowsISO
& $VBoxManage storageattach $vmName --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium $answerISO

# Enable NAT networking
& $VBoxManage modifyvm $vmName --nic1 nat

# Start the VM
& $VBoxManage startvm $vmName
