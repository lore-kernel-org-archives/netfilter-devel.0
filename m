From: Michael Schwendt <rh0209ms@arcor.de>
Subject: [PATCH] save inverted MAC match
Date: Wed, 6 Nov 2002 17:21:19 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021106172119.609b16f8.rh0209ms@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart_Wed__6_Nov_2002_17:21:19_+0100_082520a8"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Multipart_Wed__6_Nov_2002_17:21:19_+0100_082520a8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

The "mac" userspace extension contains a minor bug for both IPv4 and
IPv6. Upon printing/saving a rule which matches inverted MAC
addresses, a space character is missing between the '!' prefix and
the MAC address. Hence iptables-restore fails to parse the output of
iptables-save. iptables 1.2.5, 1.2.6a, 1.2.7a and CVS are affected.

Steps to reproduce:

  iptables -N test
  iptables -I test -m mac --mac-source ! 01:02:03:04:05:06
  iptables-save | iptables-restore

Further reference:

  https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=77337

- -- 
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)

iD8DBQE9yUF+0iMVcrivHFQRAoq1AJ44yEEvEBrsCcmVmKsOT1ouMgkZVACggArR
Wor0AECzGmXPdLCpo8qmwZQ=
=jYEu
-----END PGP SIGNATURE-----

--Multipart_Wed__6_Nov_2002_17:21:19_+0100_082520a8
Content-Type: application/octet-stream;
 name="iptables-1.2.7a-invertmac.patch"
Content-Disposition: attachment;
 filename="iptables-1.2.7a-invertmac.patch"
Content-Transfer-Encoding: base64

UmVkIEhhdCBMaW51eCBidWcgIzc3MzM3OiBBZGQgbWlzc2luZyBzcGFjZSBiZXR3ZWVuICchJyBh
bmQgTUFDCmFkZHJlc3MgdXBvbiBwcmludGluZy9zYXZpbmcgcnVsZXMuCgpkaWZmIC1OYXVyIGlw
dGFibGVzLTEuMi43YS1vcmlnL2V4dGVuc2lvbnMvbGliaXA2dF9tYWMuYyBpcHRhYmxlcy0xLjIu
N2EvZXh0ZW5zaW9ucy9saWJpcDZ0X21hYy5jCi0tLSBpcHRhYmxlcy0xLjIuN2Etb3JpZy9leHRl
bnNpb25zL2xpYmlwNnRfbWFjLmMJV2VkIE1heSAyOSAxNTowODoxNiAyMDAyCisrKyBpcHRhYmxl
cy0xLjIuN2EvZXh0ZW5zaW9ucy9saWJpcDZ0X21hYy5jCVdlZCBOb3YgIDYgMTY6NTA6MTcgMjAw
MgpAQCAtOTAsNyArOTAsNyBAQAogewogCXVuc2lnbmVkIGludCBpOwogCi0JcHJpbnRmKCIlcyUw
MlgiLCBpbnZlcnQgPyAiISIgOiAiIiwgbWFjYWRkcmVzc1swXSk7CisJcHJpbnRmKCIlcyUwMlgi
LCBpbnZlcnQgPyAiISAiIDogIiIsIG1hY2FkZHJlc3NbMF0pOwogCWZvciAoaSA9IDE7IGkgPCBF
VEhfQUxFTjsgaSsrKQogCQlwcmludGYoIjolMDJYIiwgbWFjYWRkcmVzc1tpXSk7CiAJcHJpbnRm
KCIgIik7CmRpZmYgLU5hdXIgaXB0YWJsZXMtMS4yLjdhLW9yaWcvZXh0ZW5zaW9ucy9saWJpcHRf
bWFjLmMgaXB0YWJsZXMtMS4yLjdhL2V4dGVuc2lvbnMvbGliaXB0X21hYy5jCi0tLSBpcHRhYmxl
cy0xLjIuN2Etb3JpZy9leHRlbnNpb25zL2xpYmlwdF9tYWMuYwlXZWQgTWF5IDI5IDE1OjA4OjE2
IDIwMDIKKysrIGlwdGFibGVzLTEuMi43YS9leHRlbnNpb25zL2xpYmlwdF9tYWMuYwlXZWQgTm92
ICA2IDE2OjUwOjMwIDIwMDIKQEAgLTkwLDcgKzkwLDcgQEAKIHsKIAl1bnNpZ25lZCBpbnQgaTsK
IAotCXByaW50ZigiJXMlMDJYIiwgaW52ZXJ0ID8gIiEiIDogIiIsIG1hY2FkZHJlc3NbMF0pOwor
CXByaW50ZigiJXMlMDJYIiwgaW52ZXJ0ID8gIiEgIiA6ICIiLCBtYWNhZGRyZXNzWzBdKTsKIAlm
b3IgKGkgPSAxOyBpIDwgRVRIX0FMRU47IGkrKykKIAkJcHJpbnRmKCI6JTAyWCIsIG1hY2FkZHJl
c3NbaV0pOwogCXByaW50ZigiICIpOwo=

--Multipart_Wed__6_Nov_2002_17:21:19_+0100_082520a8--
