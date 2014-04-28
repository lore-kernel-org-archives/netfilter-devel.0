From: Dmitry Korzhevin <dmitry.korzhevin@stidia.com>
Subject: Iptables udp ports advice
Date: Mon, 28 Apr 2014 11:55:14 +0300
Message-ID: <535E1772.2010907@stidia.com>
Reply-To: dmitry.korzhevin@stidia.com
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms070508090002000804090504"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from tanzanite.stidia.com ([176.28.52.97]:41239 "EHLO
	tanzanite.stidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbaD1JVh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Apr 2014 05:21:37 -0400
Received: from [83.142.232.85] (helo=[192.168.100.195])
	by tanzanite.stidia.com with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.72)
	(envelope-from <dmitry.korzhevin@stidia.com>)
	id 1WehJq-0003eo-Id
	for netfilter-devel@vger.kernel.org; Mon, 28 Apr 2014 10:53:47 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms070508090002000804090504
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable


Hi,

Thank you for answer! Can you please advice the best way to:

I have next services, working with udp:

netstat -ulpn
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address=20
State       PID/Program name
udp        0      0 0.0.0.0:500             0.0.0.0:*=20
         22822/charon
udp        0      0 0.0.0.0:1701            0.0.0.0:*=20
         3023/xl2tpd
udp        0      0 162.243.246.152:6000    0.0.0.0:*=20
         22931/openvpn
udp        0      0 0.0.0.0:4500            0.0.0.0:*=20
         22822/charon
udp6       0      0 :::500                  :::*=20
         22822/charon
udp6       0      0 :::4500                 :::*=20
         22822/charon


Can you please advice best option to allow this services and block all=20
other upd?

I use next rules:

iptables -I OUTPUT 2 -p udp --dport 53 -j ACCEPT
iptables -I OUTPUT 2 -p udp --dport 1701 -j ACCEPT
iptables -I OUTPUT 3 -p udp -m udp --dport 1812 -j ACCEPT
iptables -I OUTPUT 4 -p udp -m udp --dport 1813 -j ACCEPT
iptables -I OUTPUT 5 -p udp -m udp --dport 1813 -j ACCEPT
iptables -I OUTPUT 5 -p udp -m udp --dport 6000 -j ACCEPT
iptables -I OUTPUT 5 -p udp -m udp --dport 500 -j ACCEPT
iptables -I OUTPUT 5 -p udp -m udp --dport 4500 -j ACCEPT
iptables -I OUTPUT 10 -p udp -j DROP


Best Regards,
Dmitry

---
Dmitry KORZHEVIN


--------------ms070508090002000804090504
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: Криптографическая подпись S/MIME

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIINWzCC
BkIwggUqoAMCAQICEDirAC//rpa3Vv85Wvtd5xswDQYJKoZIhvcNAQEFBQAwgcoxCzAJBgNV
BAYTAlVTMRcwFQYDVQQKEw5WZXJpU2lnbiwgSW5jLjEfMB0GA1UECxMWVmVyaVNpZ24gVHJ1
c3QgTmV0d29yazE6MDgGA1UECxMxKGMpIDE5OTkgVmVyaVNpZ24sIEluYy4gLSBGb3IgYXV0
aG9yaXplZCB1c2Ugb25seTFFMEMGA1UEAxM8VmVyaVNpZ24gQ2xhc3MgMSBQdWJsaWMgUHJp
bWFyeSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eSAtIEczMB4XDTExMDkwMTAwMDAwMFoXDTIx
MDgzMTIzNTk1OVowgaYxCzAJBgNVBAYTAlVTMR0wGwYDVQQKExRTeW1hbnRlYyBDb3Jwb3Jh
dGlvbjEfMB0GA1UECxMWU3ltYW50ZWMgVHJ1c3QgTmV0d29yazEeMBwGA1UECxMVUGVyc29u
YSBOb3QgVmFsaWRhdGVkMTcwNQYDVQQDEy5TeW1hbnRlYyBDbGFzcyAxIEluZGl2aWR1YWwg
U3Vic2NyaWJlciBDQSAtIEc0MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxuwn
/R1j9DsdisHTHMjIgoa2uEqGkqqBXHLKMA0vnkEiVzAhJZCao/SsKsaIF4ZhchN2LuwDyyeb
jyCAN+DkitpVplAP/LlcI2mJQqG6H6/vDvmkyQrx+DeyxtmSSq5937hEH5u6P4wG/tgjT0hR
I2pghKjuJy9g35byGiqMPI8AzE/L+iCOvDX24fCatgXz/B0/xhR7DtryBeTTgwKmxWlwtKnk
VunbHVz0pjbia7UeKi3cvrvuOgSwMAitX2hsxr0GloiE5+apZC28ODC7iCbDZ2ZmtLR3+cCh
xw5y72bi5bnK4POFdzWY3tQcsP5mceI4y258T0BV65fZqBge7QIDAQABo4ICRDCCAkAwOAYI
KwYBBQUHAQEELDAqMCgGCCsGAQUFBzABhhxodHRwOi8vcGtpLW9jc3AudmVyaXNpZ24uY29t
MBIGA1UdEwEB/wQIMAYBAf8CAQAwbAYDVR0gBGUwYzBhBgtghkgBhvhFAQcXATBSMCYGCCsG
AQUFBwIBFhpodHRwOi8vd3d3LnN5bWF1dGguY29tL2NwczAoBggrBgEFBQcCAjAcGhpodHRw
Oi8vd3d3LnN5bWF1dGguY29tL3JwYTA0BgNVHR8ELTArMCmgJ6AlhiNodHRwOi8vY3JsLnZl
cmlzaWduLmNvbS9wY2ExLWczLmNybDAOBgNVHQ8BAf8EBAMCAQYwKQYDVR0RBCIwIKQeMBwx
GjAYBgNVBAMTEVZlcmlTaWduTVBLSS0yLTk3MB0GA1UdDgQWBBSt+cOTci21uShh5KTXYNXE
Cl4aATCB8QYDVR0jBIHpMIHmoYHQpIHNMIHKMQswCQYDVQQGEwJVUzEXMBUGA1UEChMOVmVy
aVNpZ24sIEluYy4xHzAdBgNVBAsTFlZlcmlTaWduIFRydXN0IE5ldHdvcmsxOjA4BgNVBAsT
MShjKSAxOTk5IFZlcmlTaWduLCBJbmMuIC0gRm9yIGF1dGhvcml6ZWQgdXNlIG9ubHkxRTBD
BgNVBAMTPFZlcmlTaWduIENsYXNzIDEgUHVibGljIFByaW1hcnkgQ2VydGlmaWNhdGlvbiBB
dXRob3JpdHkgLSBHM4IRAItbdVaEVIULAM+vOEjOsaQwDQYJKoZIhvcNAQEFBQADggEBANaP
wdqbiPKzbE0fWC+6AVFddMFG6MO4e5/WQPHv/zK6iWvADjRDn6SZ5qTwXUgzYoWFYf4jiCKM
YJsrnGVJlMSiOCRIpVylUEto6WIip5PomSJuPVu7EEIOH0x1RzRWCY/4vYw881y70pZwVHBi
Te/REL6dSCxe7IZrB4LwPeElJygs4BZ2HrP95WKW0oo9Xyuu+1zCE7dlY8s0dkOf1oeZq26t
lcEAP0Yngf813iMOQ9wUXzL5yinvwlIw9ZnduYH4OiUgjYJo8rkhhXRmBOGGORYy8i3WKqjJ
3tkAAk/jGCDFpYFWtpXe04Kt+HslvmR8LqC6cCz4+XXidE0HbYQwggcRMIIF+aADAgECAhA1
NsjTwUTrE6wu/lHZVl0iMA0GCSqGSIb3DQEBBQUAMIGmMQswCQYDVQQGEwJVUzEdMBsGA1UE
ChMUU3ltYW50ZWMgQ29ycG9yYXRpb24xHzAdBgNVBAsTFlN5bWFudGVjIFRydXN0IE5ldHdv
cmsxHjAcBgNVBAsTFVBlcnNvbmEgTm90IFZhbGlkYXRlZDE3MDUGA1UEAxMuU3ltYW50ZWMg
Q2xhc3MgMSBJbmRpdmlkdWFsIFN1YnNjcmliZXIgQ0EgLSBHNDAeFw0xMzA1MzEwMDAwMDBa
Fw0xNDA2MDIyMzU5NTlaMIHNMS4wLAYDVQQDDCVQZXJzb25hIE5vdCBWYWxpZGF0ZWQgLSAx
MzY5OTk3MzE2NjY1MSowKAYJKoZIhvcNAQkBFhtkbWl0cnkua29yemhldmluQHN0aWRpYS5j
b20xDzANBgNVBAsMBlMvTUlNRTEeMBwGA1UECwwVUGVyc29uYSBOb3QgVmFsaWRhdGVkMR8w
HQYDVQQLDBZTeW1hbnRlYyBUcnVzdCBOZXR3b3JrMR0wGwYDVQQKDBRTeW1hbnRlYyBDb3Jw
b3JhdGlvbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKVw/c/gmTA3nN3K1epI
xkeu53lpWtUD12g54kxWBkkjLZyvwF3vxjH6XRo6pq40rHTW/2sk1/0MWBY3RjX02577E9jy
NS5K3nZ+VYeMK4bBf5CPY3Fjy/OMeDrCrXvNKzYEakG9tWSnSIkUoAGcy8ZMQvL+T/0vQbof
Iiwaf755BBHg8bAh+5pgG7JbTy5q4rJZbHFaVi/SBPYZ5suPU7WvqaSmG2WUB6lqalIbXrn+
fsbAue3TaLTyRktEZwz8yaMfVmuuElLQr4uzBqdKa8X4KdLiQTY140AU3VovQ0Z9BxGkI+9N
0vw4LgiugZh2pQOd5jeAbyz5hE9i0VgdFMkCAwEAAaOCAxAwggMMMAwGA1UdEwEB/wQCMAAw
DgYDVR0PAQH/BAQDAgWgMCAGA1UdJQEB/wQWMBQGCCsGAQUFBwMEBggrBgEFBQcDAjAdBgNV
HQ4EFgQUya/tcvMZ9yoyYFzZsvNwHEgu1b8wJgYDVR0RBB8wHYEbZG1pdHJ5LmtvcnpoZXZp
bkBzdGlkaWEuY29tMB8GA1UdIwQYMBaAFK35w5NyLbW5KGHkpNdg1cQKXhoBMIIBKwYIKwYB
BQUHAQEEggEdMIIBGTCCARUGCCsGAQUFBzAChoIBB2xkYXA6Ly9kaXJlY3RvcnkudmVyaXNp
Z24uY29tL0NOJTIwJTNEJTIwU3ltYW50ZWMlMjBDbGFzcyUyMDElMjBJbmRpdmlkdWFsJTIw
U3Vic2NyaWJlciUyMENBJTIwLSUyMEc0JTJDJTIwT1UlMjAlM0QlMjBQZXJzb25hJTIwTm90
JTIwVmFsaWRhdGVkJTJDJTIwT1UlMjAlM0QlMjBTeW1hbnRlYyUyMFRydXN0JTIwTmV0d29y
ayUyQyUyME8lMjAlM0QlMjBTeW1hbnRlYyUyMENvcnBvcmF0aW9uJTJDJTIwQyUyMCUzRCUy
MFVTP2NBQ2VydGlmaWNhdGU7YmluYXJ5MF0GA1UdHwRWMFQwUqBQoE6GTGh0dHA6Ly9wa2kt
Y3JsLnN5bWF1dGguY29tL2NhXzU2MWMxMDM2OTBjOTdhNjkyNDdhMGVmMDcxYWM4MWFmL0xh
dGVzdENSTC5jcmwwbAYDVR0gBGUwYzBhBgtghkgBhvhFAQcXATBSMCYGCCsGAQUFBwIBFhpo
dHRwOi8vd3d3LnN5bWF1dGguY29tL2NwczAoBggrBgEFBQcCAjAcGhpodHRwOi8vd3d3LnN5
bWF1dGguY29tL3JwYTArBgpghkgBhvhFARADBB0wGwYSYIZIAYb4RQEQAQICBAGGx85vFgUx
MDkyMjA5BgpghkgBhvhFARAFBCswKQIBABYkYUhSMGNITTZMeTl3YTJrdGNtRXVjM2x0WVhW
MGFDNWpiMjA9MA0GCSqGSIb3DQEBBQUAA4IBAQBOR2Px45LznpldAjLkHI1biEgxp/jT/xZ4
6ExQ3S388OlobO0WpL0hKKJ0OCXcOeoxunaX60ccd8GoY8nOESism8ijSPWciqOCwUuMylyU
s0ZAfpqXGsU0yKyFnbdG7UuoaKmoOBziM4tB/O7vv4ZW3QNNdv/8hMX+tj+s/HH5bxxTxzmQ
Hl62pf47I+o0BX5jzwroLNyaYQoxnh7NYZtGusNGhngYst4aep4jLiaa9wIGvHoYKOfY4nDc
DMgJf5+ZPVrxlRbaGrtuIDrJeoIzf304zIMQ7YhE436/8jJBJhAeabJoKIIfKzwu7zDCp7ms
ZH+yfJbNuh32oGpFmio3MYIEUjCCBE4CAQEwgbswgaYxCzAJBgNVBAYTAlVTMR0wGwYDVQQK
ExRTeW1hbnRlYyBDb3Jwb3JhdGlvbjEfMB0GA1UECxMWU3ltYW50ZWMgVHJ1c3QgTmV0d29y
azEeMBwGA1UECxMVUGVyc29uYSBOb3QgVmFsaWRhdGVkMTcwNQYDVQQDEy5TeW1hbnRlYyBD
bGFzcyAxIEluZGl2aWR1YWwgU3Vic2NyaWJlciBDQSAtIEc0AhA1NsjTwUTrE6wu/lHZVl0i
MAkGBSsOAwIaBQCgggJrMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTE0MDQyODA4NTUxNFowIwYJKoZIhvcNAQkEMRYEFL0j9pxTM0FWmeZawuiR3RTMre+0
MGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0D
BzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwIC
ASgwgcwGCSsGAQQBgjcQBDGBvjCBuzCBpjELMAkGA1UEBhMCVVMxHTAbBgNVBAoTFFN5bWFu
dGVjIENvcnBvcmF0aW9uMR8wHQYDVQQLExZTeW1hbnRlYyBUcnVzdCBOZXR3b3JrMR4wHAYD
VQQLExVQZXJzb25hIE5vdCBWYWxpZGF0ZWQxNzA1BgNVBAMTLlN5bWFudGVjIENsYXNzIDEg
SW5kaXZpZHVhbCBTdWJzY3JpYmVyIENBIC0gRzQCEDU2yNPBROsTrC7+UdlWXSIwgc4GCyqG
SIb3DQEJEAILMYG+oIG7MIGmMQswCQYDVQQGEwJVUzEdMBsGA1UEChMUU3ltYW50ZWMgQ29y
cG9yYXRpb24xHzAdBgNVBAsTFlN5bWFudGVjIFRydXN0IE5ldHdvcmsxHjAcBgNVBAsTFVBl
cnNvbmEgTm90IFZhbGlkYXRlZDE3MDUGA1UEAxMuU3ltYW50ZWMgQ2xhc3MgMSBJbmRpdmlk
dWFsIFN1YnNjcmliZXIgQ0EgLSBHNAIQNTbI08FE6xOsLv5R2VZdIjANBgkqhkiG9w0BAQEF
AASCAQBhN0KC0WqZcHRPDGZGwtGqxZQDMQ/uVC5L7vxO7HHd0yv9Z30l+54sOAjrSXE7bmUy
oXjSaIflXdywO60TNugo0NOcRpcywOTMxGn8KHuCnc+tOeVxSmGF7hf7Uw/cqJvi9oXsZuIR
5Cu0Js6ZVp6RP7q2iiGxh4TaPs1Hi/QhOtMbhwM/03kqrwVffiRFXOVtZqQVe3fZCT5nvm4X
SGhCbE+HyzXAAZNrqwkFL0ScxxdWbADWtYfG8H9Sgr0jDLA79CRyoqU0DqB4q4Q+Ec7MGcwu
oBqBVAFMdl+qU6p9FxDDM+RBZDGjFFDg4gr/T9Wq3JHjjGguW0yQVkxDFlofAAAAAAAA
--------------ms070508090002000804090504--
