From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] nfsim TCP related fixes
Date: Mon, 21 Feb 2005 20:16:16 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0502212015190.1542@blackhole.kfki.hu>
References: <Pine.LNX.4.58.0502210859300.834@blackhole.kfki.hu>
	<1108999481.16083.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="110391808-415917836-1109013376=:1542"
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <1108999481.16083.1.camel@localhost.localdomain>
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

--110391808-415917836-1109013376=:1542
Content-Type: TEXT/PLAIN; charset=US-ASCII

On Tue, 22 Feb 2005, Rusty Russell wrote:

> On Mon, 2005-02-21 at 09:07 +0100, Jozsef Kadlecsik wrote:
> > Hi,
> >
> > I discovered two TCP related bugs in gen_ip: TCP SEQ and ACK numbers were
> > converted from string to u_int16_t instead of u_int32_t and full length
> > TCP options could not be specified.
>
> Don't think so: string_to_number uses int.  You couldn't specify >
> 2billion though.  We should just make string_to_number() use unsigned
> since noone wants -ve numbers anyway.  Other fix looks fine: feel free
> to simply commit.

Yes, you are right. What about the attached patch?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
--110391808-415917836-1109013376=:1542
Content-Type: TEXT/PLAIN; charset=US-ASCII; name="nfsim.patch"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.58.0502212016160.1542@blackhole.kfki.hu>
Content-Description: nfsim.patch
Content-Disposition: attachment; filename="nfsim.patch"

ZGlmZiAtdXJOIC0tZXhjbHVkZS1mcm9tPS91c3Ivc3JjL2RpZmYuZXhjbHVk
ZSBuZnNpbS5vcmlnL3Rvb2xzL2dlbl9pcC5jIG5mc2ltL3Rvb2xzL2dlbl9p
cC5jDQotLS0gbmZzaW0ub3JpZy90b29scy9nZW5faXAuYwkyMDA1LTAxLTE5
IDE0OjA2OjMyLjAwMDAwMDAwMCArMDEwMA0KKysrIG5mc2ltL3Rvb2xzL2dl
bl9pcC5jCTIwMDUtMDItMjEgMTg6MTc6MDQuMDAwMDAwMDAwICswMTAwDQpA
QCAtNTYsMTMgKzU2LDEzIEBADQogCXswfQ0KIH07DQogDQotaW50IHN0cmlu
Z190b19udW1iZXIoY29uc3QgY2hhciAqcywgaW50IG1pbiwgaW50IG1heCkN
Cit1bnNpZ25lZCBpbnQgc3RyaW5nX3RvX251bWJlcihjb25zdCBjaGFyICpz
LCB1bnNpZ25lZCBpbnQgbWluLCB1bnNpZ25lZCBpbnQgbWF4KQ0KIHsNCi0J
aW50IG51bWJlcjsNCisJdW5zaWduZWQgaW50IG51bWJlcjsNCiAJY2hhciAq
ZW5kOw0KIA0KIAkvKiBIYW5kbGUgaGV4LCBvY3RhbCwgZXRjLiAqLw0KLQlu
dW1iZXIgPSAoaW50KXN0cnRvbChzLCAmZW5kLCAwKTsNCisJbnVtYmVyID0g
KHVuc2lnbmVkIGludClzdHJ0b3VsKHMsICZlbmQsIDApOw0KIAlpZiAoKmVu
ZCA9PSAnXDAnICYmIGVuZCAhPSBzKSB7DQogCQkvKiB3ZSBwYXJzZWQgYSBu
dW1iZXIsIGxldCdzIHNlZSBpZiB3ZSB3YW50IHRoaXMgKi8NCiAJCWlmICht
aW4gPD0gbnVtYmVyICYmIG51bWJlciA8PSBtYXgpDQpAQCAtMzk0LDExICsz
OTQsMTMgQEANCiAJc2l6ZV90IGk7DQogDQogCS8qIE9wdGlvbnMgYXJlIHNp
bXBsZSBjb21tYS1zZXBhcmF0ZWQgbnVtYmVyIGxpc3QuICovDQotCWZvciAo
aSA9IDAsIHRvaz1zdHJ0b2sob3B0cywgIiwiKTsgdG9rOyB0b2s9c3RydG9r
KE5VTEwsICIsIiksIGkrKykNCisJZm9yIChpID0gMCwgdG9rPXN0cnRvayhv
cHRzLCAiLCIpOyANCisJICAgICB0b2sgJiYgaSA8IHNpemVvZihvcHRpb25z
KTsNCisJICAgICB0b2s9c3RydG9rKE5VTEwsICIsIiksIGkrKykNCiAJCW9w
dGlvbnNbaV0gPSBhdG9sKHRvayk7DQogDQotCWlmIChpID49IHNpemVvZihv
cHRpb25zKSkgew0KLQkJbmZzaW1fbG9nKExPR19VSSwgIlRvbyBtYW55IFRD
UCBvcHRpb25zIGAlcyciLCBvcHRzKTsNCisJaWYgKHRvaykgew0KKwkJbmZz
aW1fbG9nKExPR19VSSwgIlRvbyBtYW55IFRDUCBvcHRpb25zOiAlcyIsIG9w
dHMpOw0KIAkJcmV0dXJuIDE7DQogCX0NCiAJaWYgKGkgJSA0ICE9IDApIHsN
CkBAIC00MTMsOSArNDE1LDkgQEANCiBzdGF0aWMgaW50DQogcGFyc2VfdGNw
bnVtYmVyKGNvbnN0IGNoYXIgKm51bWJlciwgdV9pbnQzMl90ICp2YWwpDQog
ew0KLQlpbnQgaTsNCisJdW5zaWduZWQgaW50IGk7DQogDQotCWkgPSBzdHJp
bmdfdG9fbnVtYmVyKG51bWJlciwgMCwgSU5UX01BWCk7DQorCWkgPSBzdHJp
bmdfdG9fbnVtYmVyKG51bWJlciwgMCwgVUlOVF9NQVgpOw0KIAlpZiAoaSA8
IDApIHsNCiAJCW5mc2ltX2xvZyhMT0dfVUksICJJbnZhbGlkIHRjcCBudW1i
ZXIgYCVzJyIsIG51bWJlcik7DQogCQlyZXR1cm4gMTsNCmRpZmYgLXVyTiAt
LWV4Y2x1ZGUtZnJvbT0vdXNyL3NyYy9kaWZmLmV4Y2x1ZGUgbmZzaW0ub3Jp
Zy90b29scy9nZW5faXAuaCBuZnNpbS90b29scy9nZW5faXAuaA0KLS0tIG5m
c2ltLm9yaWcvdG9vbHMvZ2VuX2lwLmgJMjAwNS0wMS0xOSAxNDowNjozMi4w
MDAwMDAwMDAgKzAxMDANCisrKyBuZnNpbS90b29scy9nZW5faXAuaAkyMDA1
LTAyLTIxIDE4OjE4OjE4LjAwMDAwMDAwMCArMDEwMA0KQEAgLTI1LDcgKzI1
LDcgQEANCiAJCSBjaGFyICpkdW1wX2ZsYWdzKTsNCiANCiAvKiBDb252ZXJ0
IHN0cmluZyB0byBudW1iZXIgaW4gdGhpcyByYW5nZTogLTEgZm9yIGZhaWwu
ICovDQotaW50IHN0cmluZ190b19udW1iZXIoY29uc3QgY2hhciAqcywgaW50
IG1pbiwgaW50IG1heCk7DQordW5zaWduZWQgaW50IHN0cmluZ190b19udW1i
ZXIoY29uc3QgY2hhciAqcywgdW5zaWduZWQgaW50IG1pbiwgdW5zaWduZWQg
aW50IG1heCk7DQogDQogLyogQ29udmVydCBzdHJpbmcgb2YgZm9ybSB3Lngu
eS56IHRvIGFuIGFkZHJlc3MuICBOVUxMIG9uIGZhaWwuICovDQogc3RydWN0
IGluX2FkZHIgKmRvdHRlZF90b19hZGRyKGNvbnN0IGNoYXIgKmRvdHRlZCk7
DQo=

--110391808-415917836-1109013376=:1542--
