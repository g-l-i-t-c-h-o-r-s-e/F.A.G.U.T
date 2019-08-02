#NoEnv
SetBatchLines, -1

#Include Socket.ahk


RandomUInt64() {
    return ("", VarSetCapacity(CSPHandle, 8, 0), VarSetCapacity(RandomBuffer, 8, 0), DllCall("advapi32.dll\CryptAcquireContextA", "Ptr", &CSPHandle, "UInt", 0, "UInt", 0, "UInt", PROV_RSA_AES := 0x00000018,"UInt", CRYPT_VERIFYCONTEXT := 0xF0000000), DllCall("advapi32.dll\CryptGenRandom", "Ptr", NumGet(&CSPHandle, 0, "UInt64"), "UInt", 8, "Ptr", &RandomBuffer), DllCall("advapi32.dll\CryptReleaseContext", "Ptr", NumGet(&CSPHandle, 0, "UInt64"), "UInt", 0)) (Abs(NumGet(&RandomBuffer, 0, "UInt64")))
}

VarSetCapacity(RandomData, 64, 0) ; Allocate a buffer for us to put data into that UDP.Send will read, and send over UDP

loop, 10 {
    NumPut(RandomUInt64(), &RandomData, A_Index - 1, "UInt64") ; Just stuff the buffer with some random garbage
}
UDP := new SocketUDP()
UDP.Connect(["127.0.0.1", "1337"])
; The following line has seemingly no effect
; UDP.SetBroadcast(True)

;msgbox, %RandomData%
amount := 1
while amount < 2
{
UDP.Send(&RandomData, 64) ; Call UDP.Send, give it the address of the buffer, and the length of the buffer
amount +=1
sleep, 100
}

if (amount = 2) {
ExitApp
}