From: Bernd Kohler <kohler@umic.rwth-aachen.de>
Subject: Re: filter IP protocol with ip6tables
Date: Thu, 31 May 2012 11:19:00 +0200
Message-ID: <4FC73784.4030206@umic.rwth-aachen.de>
References: <856i5i0.8d94641ae92b968dc968d4a2d41e077f@obelix.schillstrom.com>
Reply-To: kohler@umic.rwth-aachen.de
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature";
 micalg=sha1; boundary=------------ms050208050006020906090004
Cc: netfilter-devel@vger.kernel.org
To: Hans Schillstrom <hans@schillstrom.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mta-1.ms.rz.rwth-aachen.de ([134.130.7.72]:46463 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751876Ab2EaJTC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 May 2012 05:19:02 -0400
Received: from mx-out-1.rwth-aachen.de ([134.130.5.186])
 by mta-1.ms.rz.RWTH-Aachen.de
 (Sun Java(tm) System Messaging Server 6.3-7.04 (built Sep 26 2008))
 with ESMTP id <0M4V00CNMR7OI600@mta-1.ms.rz.RWTH-Aachen.de> for
 netfilter-devel@vger.kernel.org; Thu, 31 May 2012 11:19:00 +0200 (CEST)
Received: from [137.226.154.136] ([unknown] [137.226.154.136])
 by relay-auth-2.ms.rz.rwth-aachen.de
 (Sun Java(tm) System Messaging Server 7.0-3.01 64bit (built Dec  9 2008))
 with ESMTPA id <0M4V003VZR7O0290@relay-auth-2.ms.rz.rwth-aachen.de> for
 netfilter-devel@vger.kernel.org; Thu, 31 May 2012 11:19:00 +0200 (CEST)
In-reply-to: <856i5i0.8d94641ae92b968dc968d4a2d41e077f@obelix.schillstrom.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms050208050006020906090004
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi.
On 05/30/2012 06:59 PM, Hans Schillstrom wrote:
> ..
> Btw read you uploaded file,
>=20
> Next header   0 is Hop-by-hop option header=20
> Next header 41 is IPv6 in IPv6
> ...

my fault :(

Tried "-p ip" first and ip6tables -nvL listed "all", so I tried "0" as
listed in /etc/protocols (though I should have know better, should have
trust my knowing).

In case I use "-p 4" my icmpv6 etc. works just fine.

Thx for the helpful hint but sorry for this "stupid" questions.

Regards

Bernd Kohler


p.s.: "0" ist listed in /etc/protocosl on Debian and Ubuntu but not on
       webpage [1]



[1]
https://www.iana.org/assignments/protocol-numbers/protocol-numbers.txt
--=20
UMIC - RWTH Aachen
http://www.umic.rwth-aachen.de

Mies-van-der-Rohe Str. 15
52074 Aachen

Tel.:   +49 241 80 20791
Fax:    +49 241 80 22731
E-Mail: kohler@umic.rwth-aachen.de

RIP Dennis Ritchie (*09.09.1941 =E2=80=A009.10.2011)
Thx 4 UNIX and all the ><(((('>


--------------ms050208050006020906090004
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIOGzCC
BCEwggMJoAMCAQICAgDHMA0GCSqGSIb3DQEBBQUAMHExCzAJBgNVBAYTAkRFMRwwGgYDVQQK
ExNEZXV0c2NoZSBUZWxla29tIEFHMR8wHQYDVQQLExZULVRlbGVTZWMgVHJ1c3QgQ2VudGVy
MSMwIQYDVQQDExpEZXV0c2NoZSBUZWxla29tIFJvb3QgQ0EgMjAeFw0wNjEyMTkxMDI5MDBa
Fw0xOTA2MzAyMzU5MDBaMFoxCzAJBgNVBAYTAkRFMRMwEQYDVQQKEwpERk4tVmVyZWluMRAw
DgYDVQQLEwdERk4tUEtJMSQwIgYDVQQDExtERk4tVmVyZWluIFBDQSBHbG9iYWwgLSBHMDEw
ggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDpm8NnhfkNrvWNVMOWUDU9YuluTO2U
1wBblSJ01CDrNI/W7MAxBAuZgeKmFNJSoCgjhIt0iQReW+DieMF4yxbLKDU5ey2QRdDtoAB6
fL9KDhsAw4bpXCsxEXsM84IkQ4wcOItqaACa7txPeKvSxhObdq3u3ibo7wGvdA/BCaL2a869
080UME/15eOkyGKbghoDJzANAmVgTe3RCSMqljVYJ9N2xnG2kB3E7f81hn1vM7PbD8URwoqD
oZRdQWvY0hD1TP3KUazZve+Sg7va64sWVlZDz+HVEz2mHycwzUlU28kTNJpxdcVs6qcLmPkh
nSevPqM5OUhqjK3JmfvDEvK9AgMBAAGjgdkwgdYwcAYDVR0fBGkwZzBloGOgYYZfaHR0cDov
L3BraS50ZWxlc2VjLmRlL2NnaS1iaW4vc2VydmljZS9hZl9Eb3dubG9hZEFSTC5jcmw/LWNy
bF9mb3JtYXQ9WF81MDkmLWlzc3Vlcj1EVF9ST09UX0NBXzIwHQYDVR0OBBYEFEm3xs/oPR9/
6kR7Eyn38QpwPt5kMB8GA1UdIwQYMBaAFDHDeRu69VPXF+CJei0XbAqzK50zMA4GA1UdDwEB
/wQEAwIBBjASBgNVHRMBAf8ECDAGAQH/AgECMA0GCSqGSIb3DQEBBQUAA4IBAQA74Vp3wEgX
3KkY7IGvWonwvSiSpspZGBJw7Cjy565/lizn8l0ZMfYTK3S9vYCyufdnyTmieTvhERHua3iR
M347XyYndVNljjNj7s9zw7CSI0khUHUjoR8Y4pSFPT8z6XcgjaK95qGFKUD2P3MyWA0Ja6ba
hWzAP7uNZmRWJE6uDT8yNQFb6YyC2XJZT7GGhfF0hVblw/hc843uR7NTBXDn5U2KaYMo4RMJ
hp5eyOpYHgwf+aTUWgRo/Sg+iwK2WLX2oSw3VwBnqyNojWOl75lrXP1LVvarQIc01BGSbOyH
xQoLBzNytG8MHVQs2FHHzL8w00Ny8TK/jM5JY6gA9/IcMIIE6DCCA9CgAwIBAgIECfJ04DAN
BgkqhkiG9w0BAQUFADBaMQswCQYDVQQGEwJERTETMBEGA1UEChMKREZOLVZlcmVpbjEQMA4G
A1UECxMHREZOLVBLSTEkMCIGA1UEAxMbREZOLVZlcmVpbiBQQ0EgR2xvYmFsIC0gRzAxMB4X
DTA3MDIxNDExNDkzOFoXDTE5MDIxMzAwMDAwMFowXjELMAkGA1UEBhMCREUxFDASBgNVBAoT
C1JXVEggQWFjaGVuMRcwFQYDVQQDEw5SV1RIIEFhY2hlbiBDQTEgMB4GCSqGSIb3DQEJARYR
Y2FAcnd0aC1hYWNoZW4uZGUwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC4MAhk
48jcelLfNUI5kvMv+CF54xJnL4x/cJQnN2NId6CJ3fqs0siO2exIACfzdjxOUpQ6ZFOn5pdT
vTi7stnk8WAaP/d9LFd8k9Gbxjh7xh3L+0a3ac+/tHJcX564ntUxGtVGMuShEoUaZUT5fw97
TL36UJ8OqXLrqpdAKcFKaJ+pgRp2gTLj4MNUMPjA4GlstpjoLnT++qFm7t/ZS92/E3OqNJUw
HH6C35vSroVscmg+a7XxT6U4JO99MYxNcTIMzhPS9Ytp+302w7i51daBjr0hFGPK0nLSV6gv
77zBSFJ7AVGJJxBSUzDn0xkDLYvZwqaeYkj8kDB2oSeRyfGjAgMBAAGjggGwMIIBrDAPBgNV
HRMBAf8EBTADAQH/MAsGA1UdDwQEAwIBBjAdBgNVHQ4EFgQUbtU+wBwvcck8v0lO72pVSOzR
8jgwHwYDVR0jBBgwFoAUSbfGz+g9H3/qRHsTKffxCnA+3mQwHAYDVR0RBBUwE4ERY2FAcnd0
aC1hYWNoZW4uZGUwgYgGA1UdHwSBgDB+MD2gO6A5hjdodHRwOi8vY2RwMS5wY2EuZGZuLmRl
L2dsb2JhbC1yb290LWNhL3B1Yi9jcmwvY2FjcmwuY3JsMD2gO6A5hjdodHRwOi8vY2RwMi5w
Y2EuZGZuLmRlL2dsb2JhbC1yb290LWNhL3B1Yi9jcmwvY2FjcmwuY3JsMIGiBggrBgEFBQcB
AQSBlTCBkjBHBggrBgEFBQcwAoY7aHR0cDovL2NkcDEucGNhLmRmbi5kZS9nbG9iYWwtcm9v
dC1jYS9wdWIvY2FjZXJ0L2NhY2VydC5jcnQwRwYIKwYBBQUHMAKGO2h0dHA6Ly9jZHAyLnBj
YS5kZm4uZGUvZ2xvYmFsLXJvb3QtY2EvcHViL2NhY2VydC9jYWNlcnQuY3J0MA0GCSqGSIb3
DQEBBQUAA4IBAQAXh37GLAscIHrVqQYrG5P/dYULxAseU6xuXKnSpVTnMWVFf1TtN/p2D+8X
TKtl/A4WlYa9np+ONblWcS1nJsuYf7N9wrO4zCEcVBNLIAHCY3ZXG+IoNHwgXqSYqXHzrAQZ
jkSJr1RfbFE4njUy0nNhtC51HX0ongWfqODc6z7aF9we20615Mh8Kk8uox4XgjLLV/UjPVlw
RAnuYIeF0wycvQ6jz/PJMuOrXShpqejpaiRXqKx8oPXAlCcnoqRLlQc1L0iwQHBn0Em6tDmM
Hcahbf9SBOWiZ8+O0av4ly8CQ95okz9hto9UErXUIzNea2AQXBtlIyLLKgVuYPf4i3IyMIIF
BjCCA+6gAwIBAgIHEsixbM/zMDANBgkqhkiG9w0BAQUFADBeMQswCQYDVQQGEwJERTEUMBIG
A1UEChMLUldUSCBBYWNoZW4xFzAVBgNVBAMTDlJXVEggQWFjaGVuIENBMSAwHgYJKoZIhvcN
AQkBFhFjYUByd3RoLWFhY2hlbi5kZTAeFw0xMTEwMjcxMDM1MDhaFw0xNDEwMjYxMDM1MDha
MGUxCzAJBgNVBAYTAkRFMRQwEgYDVQQKEwtSV1RIIEFhY2hlbjEpMCcGA1UECxMgVU1JQyBS
ZXNlYXJjaCBDZW50cmUgUldUSCBBYWNoZW4xFTATBgNVBAMTDEJlcm5kIEtvaGxlcjCCASIw
DQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBANJtMwFqmb/1e+ZomvsMQeXmenSpu5Lutgpw
UHwRdbiCHl6/qyycwJGsbBYkrc798FETwbxa/DLrSktk+QbgG/IorKIC1XnlmAtcUlQN4dP1
9ggKTXjSy36BolgyonjLdXIR3iWOGrNHIR6N0vc8aoRVpeCK2b/j/XMkt8VKTCTlDxPZ1PWj
Pxoxmtcqu+4e6EMkxSiG/34zND2qXAQgNfLzK3kZzbFIo8xq8SKQvy8Ofwdki2Ce3eurgRI3
Ultj17GBKJqD7zlT51rntJXiVdZ9Bj19IQ2pyXaCX+DAKKGCSxvMr+Dj2L8rAmG+YHAz1y6s
4dVwrV2E9qFiLul5pJUCAwEAAaOCAcAwggG8MAkGA1UdEwQCMAAwCwYDVR0PBAQDAgXgMCkG
A1UdJQQiMCAGCCsGAQUFBwMCBggrBgEFBQcDBAYKKwYBBAGCNxQCAjAdBgNVHQ4EFgQUFMTE
XPFwMM5VaCsH9KlcdzvYjNUwHwYDVR0jBBgwFoAUbtU+wBwvcck8v0lO72pVSOzR8jgwJQYD
VR0RBB4wHIEaa29obGVyQHVtaWMucnd0aC1hYWNoZW4uZGUweQYDVR0fBHIwcDA2oDSgMoYw
aHR0cDovL2NkcDEucGNhLmRmbi5kZS9yd3RoLWNhL3B1Yi9jcmwvY2FjcmwuY3JsMDagNKAy
hjBodHRwOi8vY2RwMi5wY2EuZGZuLmRlL3J3dGgtY2EvcHViL2NybC9jYWNybC5jcmwwgZQG
CCsGAQUFBwEBBIGHMIGEMEAGCCsGAQUFBzAChjRodHRwOi8vY2RwMS5wY2EuZGZuLmRlL3J3
dGgtY2EvcHViL2NhY2VydC9jYWNlcnQuY3J0MEAGCCsGAQUFBzAChjRodHRwOi8vY2RwMi5w
Y2EuZGZuLmRlL3J3dGgtY2EvcHViL2NhY2VydC9jYWNlcnQuY3J0MA0GCSqGSIb3DQEBBQUA
A4IBAQCPpwZ22zQ8fxDyeHwvq8sypO58qJf7ZBfRptJi0HMdhAZV9xwzbd+Fz/g13dt0ktm2
4Ha5d2vulFqGDP4RfoNadXQLWpa1ZSOuDmFmsIzIPcL1FAan0Q4A9llTKfG8fda+bosqI76n
T0QMMltEc5Tg5/HSZvfR/zDtwaqDru6XQzyvUbVp52c9Ga0LNoxqKOSx+z9vTOciroyqknwF
Mige8o/qfVk2Asmqno48DdFp+M1qtqNovrlN/YCPVipeRjl53rfFalneOP6sXCZsZIgF3gX+
onMvosdZCilqQ7Jdu0PZ0+kDzI/WDEzXuhIO4pyZfIHS9EHjrDbPqWE89y9DMYIDSDCCA0QC
AQEwaTBeMQswCQYDVQQGEwJERTEUMBIGA1UEChMLUldUSCBBYWNoZW4xFzAVBgNVBAMTDlJX
VEggQWFjaGVuIENBMSAwHgYJKoZIhvcNAQkBFhFjYUByd3RoLWFhY2hlbi5kZQIHEsixbM/z
MDAJBgUrDgMCGgUAoIIBtDAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJ
BTEPFw0xMjA1MzEwOTE5MDBaMCMGCSqGSIb3DQEJBDEWBBTIx2JndIl3Ul6qx2gRjqkXYi2h
lDBfBgkqhkiG9w0BCQ8xUjBQMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0D
AgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgweAYJKwYBBAGC
NxAEMWswaTBeMQswCQYDVQQGEwJERTEUMBIGA1UEChMLUldUSCBBYWNoZW4xFzAVBgNVBAMT
DlJXVEggQWFjaGVuIENBMSAwHgYJKoZIhvcNAQkBFhFjYUByd3RoLWFhY2hlbi5kZQIHEsix
bM/zMDB6BgsqhkiG9w0BCRACCzFroGkwXjELMAkGA1UEBhMCREUxFDASBgNVBAoTC1JXVEgg
QWFjaGVuMRcwFQYDVQQDEw5SV1RIIEFhY2hlbiBDQTEgMB4GCSqGSIb3DQEJARYRY2FAcnd0
aC1hYWNoZW4uZGUCBxLIsWzP8zAwDQYJKoZIhvcNAQEBBQAEggEAtSIiz8LY4nnq40BVEOdS
+y+NGgCxz9S3vzt54wcIJoI9nfxW2vnhpsRW5fFOCu30PQdx8awT9KhODC5vp77s0UDzVjWu
x6IrjZUJKDeNZZRNIEod5TATqnuuEBpuCElyAB0Hmm8S4QixV78dTKeRCG/p2drh4c/GiWRh
Uny0zYcQr3LCqtqUFG1Z/hfGKCV829rdy3juWvTSrACuoQ9cNf6eSOETPPbdS6CXrvbPWxiA
6460WDnvajm5wMNq6wiLF7OjG4hvmP6mIfW4V7L8kuWexlUddFHS4quG1UQ37oYkBvHffX+N
9QEdbd8J4y9XcWYYBu+kG5SNgLu7WZ8U0gAAAAAAAA==
--------------ms050208050006020906090004--
