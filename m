From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [2/2] osf: fixed /proc reading bug
Date: Sun, 22 Aug 2004 01:03:58 +0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040822010358.79048eda@zanzibar.2ka.mipt.ru>
Reply-To: johnpol@2ka.mipt.ru
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Sun__22_Aug_2004_01_03_58_+0400_V4XlUrVC=eCdGEmk"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.

--Multipart=_Sun__22_Aug_2004_01_03_58_+0400_V4XlUrVC=eCdGEmk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Fixed buffer overflow when reading rules from /proc file.

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

	Evgeniy Polyakov ( s0mbre )

Only failure makes us experts. -- Theo de Raadt


--Multipart=_Sun__22_Aug_2004_01_03_58_+0400_V4XlUrVC=eCdGEmk
Content-Type: application/octet-stream;
 name="ipt_osf.diff.1"
Content-Disposition: attachment;
 filename="ipt_osf.diff.1"
Content-Transfer-Encoding: base64

LS0tIG5ldGZpbHRlcl9jdnMvcGF0Y2gtby1tYXRpYy1uZy9vc2YvbGludXgtMi42L25ldC9pcHY0
L25ldGZpbHRlci9pcHRfb3NmLmMJMjAwNC0wOC0yMiAwMDo1NDo0NC4wMDAwMDAwMDAgKzA0MDAK
KysrIG5ldGZpbHRlcl9jdnMvcGF0Y2gtby1tYXRpYy1uZy9vc2YvbGludXgtMi42L25ldC9pcHY0
L25ldGZpbHRlci9pcHRfb3NmLmMJMjAwNC0wOC0yMCAyMjozNjoyNC4wMDAwMDAwMDAgKzA0MDAK
QEAgLTE4Miw3ICsxODUsNiBAQAogCQlvcHRzaXplID0gdGNwLT5kb2ZmKjQgLSBzaXplb2Yoc3Ry
dWN0IHRjcGhkcik7CiAJfQogCi0JCiAJLyogQWN0dWFsbHkgd2UgY2FuIGNyZWF0ZSBoYXNoL3Rh
YmxlIG9mIGFsbCBnZW5yZXMgYW5kIHNlYXJjaAogCSAqIG9ubHkgaW4gYXBwcm9wcmlhdGUgcGFy
dCwgYnV0IGhlcmUgaXMgaW5pdGlhbCB2YXJpYW50LAogCSAqIHNvIHdpbGwgdXNlIHNsb3cgcGF0
aC4KQEAgLTYwMSw5ICs2MDMsMTAgQEAKIHsKIAlzdHJ1Y3QgbGlzdF9oZWFkICplbnQ7CiAJc3Ry
dWN0IG9zZl9maW5nZXIgKmYgPSBOVUxMOwotCWludCBpOworCWludCBpLCBfX2NvdW50LCBlcnI7
CiAJCiAJKmVvZiA9IDE7CisJX19jb3VudCA9IGNvdW50OwogCWNvdW50ID0gMDsKIAogCXJlYWRf
bG9ja19iaCgmb3NmX2xvY2spOwpAQCAtNjEzLDEwICs2MTYsMTMgQEAKIAogCQlsb2coIiVzIFsl
c10iLCBmLT5nZW5yZSwgZi0+ZGV0YWlscyk7CiAJCQotCQljb3VudCArPSBzcHJpbnRmKGJ1Zitj
b3VudCwgIiVzIC0gJXNbJXNdIDogJXMiLCAKKwkJZXJyID0gc25wcmludGYoYnVmK2NvdW50LCBf
X2NvdW50LWNvdW50LCAiJXMgLSAlc1slc10gOiAlcyIsIAogCQkJCQlmLT5nZW5yZSwgZi0+dmVy
c2lvbiwKIAkJCQkJZi0+c3VidHlwZSwgZi0+ZGV0YWlscyk7Ci0JCQorCQlpZiAoZXJyIDwgMCkK
KwkJCWJyZWFrOworCQllbHNlCisJCQljb3VudCArPSBlcnI7CiAJCWlmIChmLT5vcHRfbnVtKQog
CQl7CiAJCQlsb2dhKCIgT1BUOiAiKTsKQEAgLTYzMCw3ICs2MzYsMTEgQEAKIAkJCX0KIAkJfQog
CQlsb2dhKCJcbiIpOwotCQljb3VudCArPSBzcHJpbnRmKGJ1Zitjb3VudCwgIlxuIik7CisJCWVy
ciA9IHNucHJpbnRmKGJ1Zitjb3VudCwgX19jb3VudC1jb3VudCwgIlxuIik7CisJCWlmIChlcnIg
PCAwKQorCQkJYnJlYWs7CisJCWVsc2UKKwkJCWNvdW50ICs9IGVycjsKIAl9CiAJcmVhZF91bmxv
Y2tfYmgoJm9zZl9sb2NrKTsKIAo=

--Multipart=_Sun__22_Aug_2004_01_03_58_+0400_V4XlUrVC=eCdGEmk--
