From: "Samuel Jean" <jix@bugmachine.ca>
Subject: [PATCH] IMPORTANT: trivial fix for bug introduced by hlist change
Date: Sun, 27 Mar 2005 00:52:22 -0000
Message-ID: <twig.1111884742.85179@bugmachine.ca>
Reply-To: jix@bugmachine.ca
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="--------part424603c6ca3fc"
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
To: <laforge@netfilter.org>
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

This is a multi-part message in MIME format.

----------part424603c6ca3fc
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi Harald,

I've introduced a really annoying bug with the hlist change.. *sigh*
__dsthash_find() will return junk as soon as there's something in the bucket.

Patch's attached.

Sorry for the inconveniant, please apply ASAP.


----------part424603c6ca3fc
Content-Type: application/octet-stream; name="hashlimit-corrupt.patch"
Content-Transfer-Encoding: base64

LS0tIGEvbmV0L2lwdjQvbmV0ZmlsdGVyL2lwdF9oYXNobGltaXQuYwkyMDA1LTAzLTI2IDE5OjMz
OjA2LjAwMDAwMDAwMCAtMDUwMAorKysgYi9uZXQvaXB2NC9uZXRmaWx0ZXIvaXB0X2hhc2hsaW1p
dC5jCTIwMDUtMDMtMjYgMTk6Mzg6MjYuMDAwMDAwMDAwIC0wNTAwCkBAIC0xMTYsMTggKzExNiwx
OCBAQCBoYXNoX2RzdChjb25zdCBzdHJ1Y3QgaXB0X2hhc2hsaW1pdF9odGFiCiBzdGF0aWMgaW5s
aW5lIHN0cnVjdCBkc3RoYXNoX2VudCAqCiBfX2RzdGhhc2hfZmluZChjb25zdCBzdHJ1Y3QgaXB0
X2hhc2hsaW1pdF9odGFibGUgKmh0LCBzdHJ1Y3QgZHN0aGFzaF9kc3QgKmRzdCkKIHsKLQlzdHJ1
Y3QgZHN0aGFzaF9lbnQgKmVudCA9IE5VTEw7CisJc3RydWN0IGRzdGhhc2hfZW50ICplbnQ7CiAJ
c3RydWN0IGhsaXN0X25vZGUgKnBvczsKIAl1X2ludDMyX3QgaGFzaCA9IGhhc2hfZHN0KGh0LCBk
c3QpOwogCiAJaWYgKCFobGlzdF9lbXB0eSgmaHQtPmhhc2hbaGFzaF0pKQogCQlobGlzdF9mb3Jf
ZWFjaF9lbnRyeShlbnQsIHBvcywgJmh0LT5oYXNoW2hhc2hdLCBub2RlKSB7CiAJCQlpZiAoZHN0
X2NtcChlbnQsIGRzdCkpIHsKLQkJCQlicmVhazsKKwkJCQlyZXR1cm4gZW50OwogCQkJfQogCQl9
CiAJCi0JcmV0dXJuIGVudDsKKwlyZXR1cm4gTlVMTDsKIH0KIAogLyogYWxsb2NhdGUgZHN0aGFz
aF9lbnQsIGluaXRpYWxpemUgZHN0LCBwdXQgaW4gaHRhYmxlIGFuZCBsb2NrIGl0ICovCg==

----------part424603c6ca3fc--
