From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH] nfsim TCP related fixes
Date: Mon, 21 Feb 2005 09:07:05 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0502210859300.834@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="110391808-670326762-1108973015=:834"
Cc: netfilter-devel@lists.netfilter.org
To: jk@ozlabs.org, Rusty Russell <rusty@rustcorp.com.au>
Content-ID: <Pine.LNX.4.58.0502210904330.839@blackhole.kfki.hu>
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
  Send mail to mime@docserver.cac.washington.edu for more info.

--110391808-670326762-1108973015=:834
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <Pine.LNX.4.58.0502210904331.839@blackhole.kfki.hu>

Hi,

I discovered two TCP related bugs in gen_ip: TCP SEQ and ACK numbers were
converted from string to u_int16_t instead of u_int32_t and full length
TCP options could not be specified.

The attached patch fixes both, please review and apply.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
--110391808-670326762-1108973015=:834
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; NAME="nfsim.patch"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.58.0502210903350.834@blackhole.kfki.hu>
Content-Description: nfsim.patch
Content-Disposition: ATTACHMENT; FILENAME="nfsim.patch"

ZGlmZiAtdXJOIC0tZXhjbHVkZS1mcm9tPS91c3Ivc3JjL2RpZmYuZXhjbHVk


ZSBuZnNpbS5vcmlnL3Rvb2xzL2dlbl9pcC5jIG5mc2ltL3Rvb2xzL2dlbl9p


cC5jDQotLS0gbmZzaW0ub3JpZy90b29scy9nZW5faXAuYwkyMDA1LTAxLTE5


IDE0OjA2OjMyLjAwMDAwMDAwMCArMDEwMA0KKysrIG5mc2ltL3Rvb2xzL2dl


bl9pcC5jCTIwMDUtMDItMTkgMTc6MzU6MTAuMDAwMDAwMDAwICswMTAwDQpA


QCAtNzMsNiArNzMsMjQgQEANCiAJCXJldHVybiAtMTsNCiB9DQogDQorc3Rh


dGljIHVuc2lnbmVkIGxvbmcgaW50IA0KK3N0cmluZ190b191bG9uZyhjb25z


dCBjaGFyICpzLCB1bnNpZ25lZCBsb25nIGludCBtaW4sIHVuc2lnbmVkIGxv


bmcgaW50IG1heCkNCit7DQorCXVuc2lnbmVkIGxvbmcgaW50IG51bWJlcjsN


CisJY2hhciAqZW5kOw0KKw0KKwkvKiBIYW5kbGUgaGV4LCBvY3RhbCwgZXRj


LiAqLw0KKwludW1iZXIgPSBzdHJ0b3VsKHMsICZlbmQsIDApOw0KKwlpZiAo


KmVuZCA9PSAnXDAnICYmIGVuZCAhPSBzKSB7DQorCQkvKiB3ZSBwYXJzZWQg


YSBudW1iZXIsIGxldCdzIHNlZSBpZiB3ZSB3YW50IHRoaXMgKi8NCisJCWlm


IChtaW4gPD0gbnVtYmVyICYmIG51bWJlciA8PSBtYXgpDQorCQkJcmV0dXJu


IG51bWJlcjsNCisJCWVsc2UNCisJCQlyZXR1cm4gLTE7DQorCX0gZWxzZQ0K


KwkJcmV0dXJuIC0xOw0KK30NCisNCiAvKiBzdGF0aWMgdV9pbnQxNl90Ki8N


CiBzdGF0aWMgaW50DQogcGFyc2VfcHJvdG9jb2woY29uc3QgY2hhciAqcykN


CkBAIC0zOTQsMTEgKzQxMiwxMyBAQA0KIAlzaXplX3QgaTsNCiANCiAJLyog


T3B0aW9ucyBhcmUgc2ltcGxlIGNvbW1hLXNlcGFyYXRlZCBudW1iZXIgbGlz


dC4gKi8NCi0JZm9yIChpID0gMCwgdG9rPXN0cnRvayhvcHRzLCAiLCIpOyB0


b2s7IHRvaz1zdHJ0b2soTlVMTCwgIiwiKSwgaSsrKQ0KKwlmb3IgKGkgPSAw


LCB0b2s9c3RydG9rKG9wdHMsICIsIik7IA0KKwkgICAgIHRvayAmJiBpIDwg


c2l6ZW9mKG9wdGlvbnMpOw0KKwkgICAgIHRvaz1zdHJ0b2soTlVMTCwgIiwi


KSwgaSsrKQ0KIAkJb3B0aW9uc1tpXSA9IGF0b2wodG9rKTsNCiANCi0JaWYg


KGkgPj0gc2l6ZW9mKG9wdGlvbnMpKSB7DQotCQluZnNpbV9sb2coTE9HX1VJ


LCAiVG9vIG1hbnkgVENQIG9wdGlvbnMgYCVzJyIsIG9wdHMpOw0KKwlpZiAo


dG9rKSB7DQorCQluZnNpbV9sb2coTE9HX1VJLCAiVG9vIG1hbnkgVENQIG9w


dGlvbnM6ICVzIiwgb3B0cyk7DQogCQlyZXR1cm4gMTsNCiAJfQ0KIAlpZiAo


aSAlIDQgIT0gMCkgew0KQEAgLTQxMyw5ICs0MzMsOSBAQA0KIHN0YXRpYyBp


bnQNCiBwYXJzZV90Y3BudW1iZXIoY29uc3QgY2hhciAqbnVtYmVyLCB1X2lu


dDMyX3QgKnZhbCkNCiB7DQotCWludCBpOw0KKwl1bnNpZ25lZCBsb25nIGlu


dCBpOw0KIA0KLQlpID0gc3RyaW5nX3RvX251bWJlcihudW1iZXIsIDAsIElO


VF9NQVgpOw0KKwlpID0gc3RyaW5nX3RvX3Vsb25nKG51bWJlciwgMCwgVUxP


TkdfTUFYKTsNCiAJaWYgKGkgPCAwKSB7DQogCQluZnNpbV9sb2coTE9HX1VJ


LCAiSW52YWxpZCB0Y3AgbnVtYmVyIGAlcyciLCBudW1iZXIpOw0KIAkJcmV0


dXJuIDE7DQo=



--110391808-670326762-1108973015=:834--
