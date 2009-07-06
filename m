From: Claudio Cuqui <claudio@c3systems.com.br>
Subject: Stopping console logging - tried everything :-/
Date: Mon, 06 Jul 2009 20:07:01 -0300
Message-ID: <4A528395.5020805@c3systems.com.br>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg=sha1; boundary="------------ms070809030402090306040109"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.c3systems.com.br ([200.161.147.67]:51286 "EHLO
	smtp.c3systems.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187AbZGFXNI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jul 2009 19:13:08 -0400
Received: from smtp.c3systems.com.br (HELO [200.161.147.67]) (zc3E182/0qXHnNrH4t2doahOmKieZpVy@[200.161.147.67])
          (envelope-sender <claudio@c3systems.com.br>)
          by smtp.c3systems.com.br (qmail-ldap-1.03) with SMTP
          for <netfilter-devel@vger.kernel.org>; 6 Jul 2009 23:07:01 -0000
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms070809030402090306040109
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Hi there !

I running kernel 2.6.30.1 (vanilla - custom build) and iptables v1.4.1.1 =

(tried iptables v.1.4.3.2 without success either) on a Fedora 10 x86_64=20
distro.
I really don=B4t know what is wrong here. I tried the following actions=20
(and all failed :-/):
- comment out /dev/console lines from /etc/rsyslog.conf;
- stop rsyslog completely;
- echo 6 4 1 7 > /proc/sys/kernel/printk;
- echo 1 1 1 1 > /proc/sys/kernel/printk;
- dmesg -n 1;

Below is my iptables log line:
-A LOGANDBLOCK -j LOG --log-level=3D7
-A LOGANDBLOCK -j LOG --log-prefix "iptables "
-A LOGANDBLOCK -j DROP

Even trying all the above, everytime that a run dmesg I see lots of new=20
logs showing up.

I=B4m really stuck here. Any ideas ?

TIA

Claudio Cuqui


--------------ms070809030402090306040109
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIJHzCC
AuowggJToAMCAQICEAK5VIvDU+ZjBtSPcmI7vVswDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UE
BhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMT
I1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA4MDkwMzE3NDUzNFoX
DTA5MDkwMzE3NDUzNFowSjEfMB0GA1UEAxMWVGhhd3RlIEZyZWVtYWlsIE1lbWJlcjEnMCUG
CSqGSIb3DQEJARYYY2xhdWRpb0BjM3N5c3RlbXMuY29tLmJyMIIBIjANBgkqhkiG9w0BAQEF
AAOCAQ8AMIIBCgKCAQEAp/patAA4yVwSXNt6wEJg3CNkEreB6KyfZrOwf1d9RkP+rdCKS01i
BmQlbtW9SMFy8PUEYpRlPSj7CFEA6uRVB7s0KDU99otZbCCyzlHPkBQWCnnrVQlFDtapcQc6
yHv4xKtBNmMW/No0zRckTv1YJNRLlOTtkUOKWUe+xs49czxhPQbEXAiSBn20CG+Wr6eYdkSj
f8HwuqpB8uEuJGrRELE7o1cf+nLAvVfdlbbw4d+aw1utpflS2pRWZYQCg8ZWX4V/DJO0ZGKi
AokfyoxvjPcTyAbW3ffqfXEv1SD1iXcEpuIuA2MNxzpSauD22iJYn4L4bAYCJD6qdRHUrf+c
GQIDAQABozUwMzAjBgNVHREEHDAagRhjbGF1ZGlvQGMzc3lzdGVtcy5jb20uYnIwDAYDVR0T
AQH/BAIwADANBgkqhkiG9w0BAQUFAAOBgQAvNEI/JstCLcRJsk/kZBwUJai31H4Q+o83xw+L
s4Enm87ubOlLcm7kEOzgkzgDoLtk2ybENjEqu0tGKc32PX2cwXFChyP4C3KjHD2IZ5zYHaF3
8zsHuTSNHabVXhmH/td4z6kOEtSJpSNYmD8M3cxtppZSOukoGS5Ksrgd40DtSTCCAuowggJT
oAMCAQICEAK5VIvDU+ZjBtSPcmI7vVswDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UEBhMCWkEx
JTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0
ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA4MDkwMzE3NDUzNFoXDTA5MDkw
MzE3NDUzNFowSjEfMB0GA1UEAxMWVGhhd3RlIEZyZWVtYWlsIE1lbWJlcjEnMCUGCSqGSIb3
DQEJARYYY2xhdWRpb0BjM3N5c3RlbXMuY29tLmJyMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A
MIIBCgKCAQEAp/patAA4yVwSXNt6wEJg3CNkEreB6KyfZrOwf1d9RkP+rdCKS01iBmQlbtW9
SMFy8PUEYpRlPSj7CFEA6uRVB7s0KDU99otZbCCyzlHPkBQWCnnrVQlFDtapcQc6yHv4xKtB
NmMW/No0zRckTv1YJNRLlOTtkUOKWUe+xs49czxhPQbEXAiSBn20CG+Wr6eYdkSjf8HwuqpB
8uEuJGrRELE7o1cf+nLAvVfdlbbw4d+aw1utpflS2pRWZYQCg8ZWX4V/DJO0ZGKiAokfyoxv
jPcTyAbW3ffqfXEv1SD1iXcEpuIuA2MNxzpSauD22iJYn4L4bAYCJD6qdRHUrf+cGQIDAQAB
ozUwMzAjBgNVHREEHDAagRhjbGF1ZGlvQGMzc3lzdGVtcy5jb20uYnIwDAYDVR0TAQH/BAIw
ADANBgkqhkiG9w0BAQUFAAOBgQAvNEI/JstCLcRJsk/kZBwUJai31H4Q+o83xw+Ls4Enm87u
bOlLcm7kEOzgkzgDoLtk2ybENjEqu0tGKc32PX2cwXFChyP4C3KjHD2IZ5zYHaF38zsHuTSN
HabVXhmH/td4z6kOEtSJpSNYmD8M3cxtppZSOukoGS5Ksrgd40DtSTCCAz8wggKooAMCAQIC
AQ0wDQYJKoZIhvcNAQEFBQAwgdExCzAJBgNVBAYTAlpBMRUwEwYDVQQIEwxXZXN0ZXJuIENh
cGUxEjAQBgNVBAcTCUNhcGUgVG93bjEaMBgGA1UEChMRVGhhd3RlIENvbnN1bHRpbmcxKDAm
BgNVBAsTH0NlcnRpZmljYXRpb24gU2VydmljZXMgRGl2aXNpb24xJDAiBgNVBAMTG1RoYXd0
ZSBQZXJzb25hbCBGcmVlbWFpbCBDQTErMCkGCSqGSIb3DQEJARYccGVyc29uYWwtZnJlZW1h
aWxAdGhhd3RlLmNvbTAeFw0wMzA3MTcwMDAwMDBaFw0xMzA3MTYyMzU5NTlaMGIxCzAJBgNV
BAYTAlpBMSUwIwYDVQQKExxUaGF3dGUgQ29uc3VsdGluZyAoUHR5KSBMdGQuMSwwKgYDVQQD
EyNUaGF3dGUgUGVyc29uYWwgRnJlZW1haWwgSXNzdWluZyBDQTCBnzANBgkqhkiG9w0BAQEF
AAOBjQAwgYkCgYEAxKY8VXNV+065yplaHmjAdQRwnd/p/6Me7L3N9VvyGna9fww6YfK/Uc4B
1OVQCjDXAmNaLIkVcI7dyfArhVqqP3FWy688Cwfn8R+RNiQqE88r1fOCdz0Dviv+uxg+B79A
gAJk16emu59l0cUqVIUPSAR/p7bRPGEEQB5kGXJgt/sCAwEAAaOBlDCBkTASBgNVHRMBAf8E
CDAGAQH/AgEAMEMGA1UdHwQ8MDowOKA2oDSGMmh0dHA6Ly9jcmwudGhhd3RlLmNvbS9UaGF3
dGVQZXJzb25hbEZyZWVtYWlsQ0EuY3JsMAsGA1UdDwQEAwIBBjApBgNVHREEIjAgpB4wHDEa
MBgGA1UEAxMRUHJpdmF0ZUxhYmVsMi0xMzgwDQYJKoZIhvcNAQEFBQADgYEASIzRUIPqCy7M
DaNmrGcPf6+svsIXoUOWlJ1/TCG4+DYfqi2fNi/A9BxQIJNwPP2t4WFiw9k6GX6EsZkbAMUa
C4J0niVQlGLH2ydxVyWN3amcOY6MIE9lX5Xa9/eH1sYITq726jTlEBpbNU1341YheILcIRk1
3iSx0x1G/11fZU8xggNkMIIDYAIBATB2MGIxCzAJBgNVBAYTAlpBMSUwIwYDVQQKExxUaGF3
dGUgQ29uc3VsdGluZyAoUHR5KSBMdGQuMSwwKgYDVQQDEyNUaGF3dGUgUGVyc29uYWwgRnJl
ZW1haWwgSXNzdWluZyBDQQIQArlUi8NT5mMG1I9yYju9WzAJBgUrDgMCGgUAoIIBwzAYBgkq
hkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0wOTA3MDYyMzA3MDFaMCMG
CSqGSIb3DQEJBDEWBBQ9VDU55WxBG/XBr7A3nX3KPmDEZDBSBgkqhkiG9w0BCQ8xRTBDMAoG
CCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDCBhQYJKwYBBAGCNxAEMXgwdjBiMQswCQYDVQQGEwJaQTElMCMGA1UEChMc
VGhhd3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFs
IEZyZWVtYWlsIElzc3VpbmcgQ0ECEAK5VIvDU+ZjBtSPcmI7vVswgYcGCyqGSIb3DQEJEAIL
MXigdjBiMQswCQYDVQQGEwJaQTElMCMGA1UEChMcVGhhd3RlIENvbnN1bHRpbmcgKFB0eSkg
THRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFsIEZyZWVtYWlsIElzc3VpbmcgQ0ECEAK5
VIvDU+ZjBtSPcmI7vVswDQYJKoZIhvcNAQEBBQAEggEAHhrYW+cLQcYDObVzSbB8Kx7OsWyU
PSK32CuS/4/ngqbVWGFGckEiPNXDq8W7WNHSN7zUDQxl8gTkaJ5J+5mKwYR7zvAshGkyLttN
02ugVCDoX86QFSahz/GNhpkJCULR6T8qMvGbpbwwR/l0EFJdtCTzaJ1ICa3utWQXNduL4XuZ
LiLaeZrKhkSOTPdMOu98hEyx6OmOW0ElwvCiye8L5GyifC4ZW1VfwS4Ioqo2Ausdiy4eqNGd
k6Qfum0EvT260OWorkJsnHEdodxuPrFcRaEhwiAvTzHnfVb19+KzGSEUz4rc76icFPjScdrx
FxwUj+NcCExWMcuAqLocvCt1UQAAAAAAAA==
--------------ms070809030402090306040109--
