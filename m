From: Donato Diaz <donatodd@itcsoluciones.com>
Subject: NAT Server, SMP box or Single CPU box?
Date: Mon, 27 Dec 2004 10:04:59 -0300
Message-ID: <41D0087B.2060600@itcsoluciones.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature";
	micalg=sha1; boundary="------------ms060200040409050305030701"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms060200040409050305030701
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I have read in different lists that some people are having problem doing 
NAT with SMP Servers, due to the way the kernel manage conntrack with 
two or more CPUs.
Can anyone tell me if it's true that NAT runs slower on SMP servers ?
Is it better a Server with one faster CPU than a server with two CPUs?
I need to buy a NAT Server for +1500 users. I would like to know if an 
SMP Server with two CPUs is the best choice.

Any help would be really appreciated.
Thanks all,
Donato.

--------------ms060200040409050305030701
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAMYICvzCC
ArsCAQEwgawwgaYxCzAJBgNVBAYTAkFSMRAwDgYDVQQIEwdNZW5kb3phMRAwDgYDVQQHEwdN
ZW5kb3phMRYwFAYDVQQKEw1JVENTb2x1Y2lvbmVzMRAwDgYDVQQLEwdEZXZMYWJzMR4wHAYD
VQQDExV3d3cuaXRjc29sdWNpb25lcy5jb20xKTAnBgkqhkiG9w0BCQEWGmRvbmF0b2RkQGl0
Y3NvbHVjaW9uZXMuY29tAgEBMAkGBSsOAwIaBQCgggH0MBwGCSqGSIb3DQEJBTEPFw0wNDEy
MjcxMzA0NTlaMFIGCSqGSIb3DQEJDzFFMEMwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCA
MA0GCCqGSIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIG/BgsqhkiG9w0BCRAC
CzGBr6CBrDCBpjELMAkGA1UEBhMCQVIxEDAOBgNVBAgTB01lbmRvemExEDAOBgNVBAcTB01l
bmRvemExFjAUBgNVBAoTDUlUQ1NvbHVjaW9uZXMxEDAOBgNVBAsTB0RldkxhYnMxHjAcBgNV
BAMTFXd3dy5pdGNzb2x1Y2lvbmVzLmNvbTEpMCcGCSqGSIb3DQEJARYaZG9uYXRvZGRAaXRj
c29sdWNpb25lcy5jb20CAQEwgb0GCSsGAQQBgjcQBDGBrzCBrDCBpjELMAkGA1UEBhMCQVIx
EDAOBgNVBAgTB01lbmRvemExEDAOBgNVBAcTB01lbmRvemExFjAUBgNVBAoTDUlUQ1NvbHVj
aW9uZXMxEDAOBgNVBAsTB0RldkxhYnMxHjAcBgNVBAMTFXd3dy5pdGNzb2x1Y2lvbmVzLmNv
bTEpMCcGCSqGSIb3DQEJARYaZG9uYXRvZGRAaXRjc29sdWNpb25lcy5jb20CAQEwAgYABAAA
AAAAAAA=
--------------ms060200040409050305030701--
