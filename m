From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 02/13] IP set core support
Date: Wed, 2 Feb 2011 20:46:14 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1102022044440.29552@blackhole.kfki.hu>
References: <1296514388-20900-1-git-send-email-kadlec@blackhole.kfki.hu> <1296514388-20900-2-git-send-email-kadlec@blackhole.kfki.hu> <1296514388-20900-3-git-send-email-kadlec@blackhole.kfki.hu> <4D482817.7090407@trash.net> <alpine.DEB.2.00.1102012002430.24267@blackhole.kfki.hu>
 <alpine.DEB.2.00.1102012154130.24580@blackhole.kfki.hu> <alpine.DEB.2.00.1102012225080.24657@blackhole.kfki.hu> <4D48FEC6.5080701@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="110391808-891225599-1296675948=:29552"
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:44855 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585Ab1BBTqP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Feb 2011 14:46:15 -0500
In-Reply-To: <4D48FEC6.5080701@trash.net>
Content-ID: <alpine.DEB.2.00.1102022046110.29563@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110391808-891225599-1296675948=:29552
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <alpine.DEB.2.00.1102022046111.29563@blackhole.kfki.hu>

On Wed, 2 Feb 2011, Patrick McHardy wrote:

> On 01.02.2011 22:28, Jozsef Kadlecsik wrote:
> > On Tue, 1 Feb 2011, Jozsef Kadlecsik wrote:
> > 
> >>>> I guess you're relying on that the original message is appended to a
> >>>> nlmsgerr message. That doesn't seem right though, if you want to return
> >>>> something to userspace, you should construct a new message.
> >>>
> >>> The message we are processing here carried multiple commands (each having 
> >>> an attribute with the line number of the given command) and one failed 
> >>> from some reason. We have to notify the userspace which command, at what 
> >>> line failed. For this reason the multi-command messages have got an 
> >>> attribute, which can be filled out with the line number - that happens 
> >>> here. The attribute is already there, the message is not enlarged, just
> >>> the empty value is overwritten with the proper value.
> >>>
> >>> The line number reporting works this way, tested in the testsuite too.
> >>>
> >>> If I had to construct a completely new message and sent it, that'd be more 
> >>> or less the duplication of netlink_ack. Additionally I had to suppress 
> >>> netlink from sending an errmsg/ack too.
> >>
> >> Hm, if I lie -EINTR to netlink, then I can construct and send the error 
> >> message manually and keep NLM_F_ACK at the same time. What do you think?
> >> Please have a look at the attached patch.
> > 
> > Oops, mistypeing fixed, here follow the hopefully good version.
> 
> This looks fine to me. A comment about why it returns -EINTR would
> probably be a good idea though.

Attached is the patch with a comment line added why -EINTR is returned.
Please apply.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
--110391808-891225599-1296675948=:29552
Content-Type: TEXT/X-DIFF; NAME=errline.patch
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.2.00.1102022045480.29552@blackhole.kfki.hu>
Content-Description: errline.patch
Content-Disposition: ATTACHMENT; FILENAME=errline.patch

RnJvbSAwODBmYjczNjM1MTNkZjEzMDhiMTNlY2M2NThiYmM1ZTVjYTVkZjM3
IE1vbiBTZXAgMTcgMDA6MDA6MDAgMjAwMQ0KRnJvbTogSm96c2VmIEthZGxl
Y3NpayA8a2FkbGVjQGJsYWNraG9sZS5rZmtpLmh1Pg0KRGF0ZTogV2VkLCAy
IEZlYiAyMDExIDIwOjI5OjQ0ICswMTAwDQpTdWJqZWN0OiBbUEFUQ0hdIG5l
dGZpbHRlcjogaXBzZXQ6IHNlbmQgZXJyb3IgbWVzc2FnZSBtYW51YWxseQ0K
DQpXaGVuIGEgbWVzc2FnZSBjYXJyaWVzIG11bHRpcGxlIGNvbW1hbmRzIGFu
ZCBvbmUgb2YgdGhlbSB0cmlnZ2Vycw0KYW4gZXJyb3IsIHdlIGhhdmUgdG8g
cmVwb3J0IHRvIHRoZSB1c2Vyc3BhY2Ugd2hpY2ggb25lIHdhcyB0aGF0Lg0K
VGhlIGxpbmUgbnVtYmVyIG9mIHRoZSBjb21tYW5kIHBsYXlzIHRoaXMgcm9s
ZSBhbmQgdGhlcmUncyBhbiBhdHRyaWJ1dGUNCnJlc2VydmVkIGluIHRoZSBo
ZWFkZXIgcGFydCBvZiB0aGUgbWVzc2FnZSB0byBiZSBmaWxsZWQgb3V0IHdp
dGggdGhlIGVycm9yDQpsaW5lIG51bWJlci4gSW4gb3JkZXIgbm90IHRvIG1v
ZGlmeSB0aGUgb3JpZ2luYWwgbWVzc2FnZSByZWNlaXZlZCBmcm9tDQp0aGUg
dXNlcnNwYWNlLCB3ZSBjb25zdHJ1Y3QgYSBuZXcsIGNvbXBsZXRlIG5ldGxp
bmsgZXJyb3IgbWVzc2FnZSBhbmQNCm1vZGlmaWVzIHRoZSBhdHRyaWJ1dGUg
dGhlcmUsIHRoZW4gc2VuZCBpdC4NCk5ldGxpbmsgaXMgbm90aWZpZWQgbm90
IHRvIHNlbmQgaXRzIEFDSy9lcnJvciBtZXNzYWdlLg0KDQpTaWduZWQtb2Zm
LWJ5OiBKb3pzZWYgS2FkbGVjc2lrIDxrYWRsZWNAYmxhY2tob2xlLmtma2ku
aHUNCi0tLQ0KIG5ldC9uZXRmaWx0ZXIvaXBzZXQvaXBfc2V0X2NvcmUuYyB8
ICAgMzMgKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tDQogMSBm
aWxlcyBjaGFuZ2VkLCAyNiBpbnNlcnRpb25zKCspLCA3IGRlbGV0aW9ucygt
KQ0KDQpkaWZmIC0tZ2l0IGEvbmV0L25ldGZpbHRlci9pcHNldC9pcF9zZXRf
Y29yZS5jIGIvbmV0L25ldGZpbHRlci9pcHNldC9pcF9zZXRfY29yZS5jDQpp
bmRleCBhZTBmOGI1Li44YjFhNTRjIDEwMDY0NA0KLS0tIGEvbmV0L25ldGZp
bHRlci9pcHNldC9pcF9zZXRfY29yZS5jDQorKysgYi9uZXQvbmV0ZmlsdGVy
L2lwc2V0L2lwX3NldF9jb3JlLmMNCkBAIC0xMDk4LDcgKzEwOTgsNyBAQCBz
dGF0aWMgY29uc3Qgc3RydWN0IG5sYV9wb2xpY3kgaXBfc2V0X2FkdF9wb2xp
Y3lbSVBTRVRfQVRUUl9DTURfTUFYICsgMV0gPSB7DQogfTsNCiANCiBzdGF0
aWMgaW50DQotY2FsbF9hZChzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCBzdHJ1Y3Qg
aXBfc2V0ICpzZXQsDQorY2FsbF9hZChzdHJ1Y3Qgc29jayAqY3RubCwgc3Ry
dWN0IHNrX2J1ZmYgKnNrYiwgc3RydWN0IGlwX3NldCAqc2V0LA0KIAlzdHJ1
Y3QgbmxhdHRyICp0YltdLCBlbnVtIGlwc2V0X2FkdCBhZHQsDQogCXUzMiBm
bGFncywgYm9vbCB1c2VfbGluZW5vKQ0KIHsNCkBAIC0xMTE4LDEyICsxMTE4
LDI1IEBAIGNhbGxfYWQoc3RydWN0IHNrX2J1ZmYgKnNrYiwgc3RydWN0IGlw
X3NldCAqc2V0LA0KIAkJcmV0dXJuIDA7DQogCWlmIChsaW5lbm8gJiYgdXNl
X2xpbmVubykgew0KIAkJLyogRXJyb3IgaW4gcmVzdG9yZS9iYXRjaCBtb2Rl
OiBzZW5kIGJhY2sgbGluZW5vICovDQotCQlzdHJ1Y3Qgbmxtc2doZHIgKm5s
aCA9IG5sbXNnX2hkcihza2IpOw0KKwkJc3RydWN0IG5sbXNnaGRyICpyZXAs
ICpubGggPSBubG1zZ19oZHIoc2tiKTsNCisJCXN0cnVjdCBza19idWZmICpz
a2IyOw0KKwkJc3RydWN0IG5sbXNnZXJyICplcnJtc2c7DQorCQlzaXplX3Qg
cGF5bG9hZCA9IHNpemVvZigqZXJybXNnKSArIG5sbXNnX2xlbihubGgpOw0K
IAkJaW50IG1pbl9sZW4gPSBOTE1TR19TUEFDRShzaXplb2Yoc3RydWN0IG5m
Z2VubXNnKSk7DQogCQlzdHJ1Y3QgbmxhdHRyICpjZGFbSVBTRVRfQVRUUl9D
TURfTUFYKzFdOw0KLQkJc3RydWN0IG5sYXR0ciAqY21kYXR0ciA9ICh2b2lk
ICopbmxoICsgbWluX2xlbjsNCisJCXN0cnVjdCBubGF0dHIgKmNtZGF0dHI7
DQogCQl1MzIgKmVycmxpbmU7DQogDQorCQlza2IyID0gbmxtc2dfbmV3KHBh
eWxvYWQsIEdGUF9LRVJORUwpOw0KKwkJaWYgKHNrYjIgPT0gTlVMTCkNCisJ
CQlyZXR1cm4gLUVOT01FTTsNCisJCXJlcCA9IF9fbmxtc2dfcHV0KHNrYjIs
IE5FVExJTktfQ0Ioc2tiKS5waWQsDQorCQkJCSAgbmxoLT5ubG1zZ19zZXEs
IE5MTVNHX0VSUk9SLCBwYXlsb2FkLCAwKTsNCisJCWVycm1zZyA9IG5sbXNn
X2RhdGEocmVwKTsNCisJCWVycm1zZy0+ZXJyb3IgPSByZXQ7DQorCQltZW1j
cHkoJmVycm1zZy0+bXNnLCBubGgsIG5saC0+bmxtc2dfbGVuKTsNCisJCWNt
ZGF0dHIgPSAodm9pZCAqKSZlcnJtc2ctPm1zZyArIG1pbl9sZW47DQorDQog
CQlubGFfcGFyc2UoY2RhLCBJUFNFVF9BVFRSX0NNRF9NQVgsDQogCQkJICBj
bWRhdHRyLCBubGgtPm5sbXNnX2xlbiAtIG1pbl9sZW4sDQogCQkJICBpcF9z
ZXRfYWR0X3BvbGljeSk7DQpAQCAtMTEzMSw2ICsxMTQ0LDEwIEBAIGNhbGxf
YWQoc3RydWN0IHNrX2J1ZmYgKnNrYiwgc3RydWN0IGlwX3NldCAqc2V0LA0K
IAkJZXJybGluZSA9IG5sYV9kYXRhKGNkYVtJUFNFVF9BVFRSX0xJTkVOT10p
Ow0KIA0KIAkJKmVycmxpbmUgPSBsaW5lbm87DQorDQorCQluZXRsaW5rX3Vu
aWNhc3QoY3RubCwgc2tiMiwgTkVUTElOS19DQihza2IpLnBpZCwgTVNHX0RP
TlRXQUlUKTsNCisJCS8qIFNpZ25hbCBuZXRsaW5rIG5vdCB0byBzZW5kIGl0
cyBBQ0svZXJybXNnLiAgKi8NCisJCXJldHVybiAtRUlOVFI7DQogCX0NCiAN
CiAJcmV0dXJuIHJldDsNCkBAIC0xMTY5LDcgKzExODYsOCBAQCBpcF9zZXRf
dWFkZChzdHJ1Y3Qgc29jayAqY3RubCwgc3RydWN0IHNrX2J1ZmYgKnNrYiwN
CiAJCQkJICAgICBhdHRyW0lQU0VUX0FUVFJfREFUQV0sDQogCQkJCSAgICAg
c2V0LT50eXBlLT5hZHRfcG9saWN5KSkNCiAJCQlyZXR1cm4gLUlQU0VUX0VS
Ul9QUk9UT0NPTDsNCi0JCXJldCA9IGNhbGxfYWQoc2tiLCBzZXQsIHRiLCBJ
UFNFVF9BREQsIGZsYWdzLCB1c2VfbGluZW5vKTsNCisJCXJldCA9IGNhbGxf
YWQoY3RubCwgc2tiLCBzZXQsIHRiLCBJUFNFVF9BREQsIGZsYWdzLA0KKwkJ
CSAgICAgIHVzZV9saW5lbm8pOw0KIAl9IGVsc2Ugew0KIAkJaW50IG5sYV9y
ZW07DQogDQpAQCAtMTE4MCw3ICsxMTk4LDcgQEAgaXBfc2V0X3VhZGQoc3Ry
dWN0IHNvY2sgKmN0bmwsIHN0cnVjdCBza19idWZmICpza2IsDQogCQkJICAg
IG5sYV9wYXJzZV9uZXN0ZWQodGIsIElQU0VUX0FUVFJfQURUX01BWCwgbmxh
LA0KIAkJCQkJICAgICBzZXQtPnR5cGUtPmFkdF9wb2xpY3kpKQ0KIAkJCQly
ZXR1cm4gLUlQU0VUX0VSUl9QUk9UT0NPTDsNCi0JCQlyZXQgPSBjYWxsX2Fk
KHNrYiwgc2V0LCB0YiwgSVBTRVRfQURELA0KKwkJCXJldCA9IGNhbGxfYWQo
Y3RubCwgc2tiLCBzZXQsIHRiLCBJUFNFVF9BREQsDQogCQkJCSAgICAgIGZs
YWdzLCB1c2VfbGluZW5vKTsNCiAJCQlpZiAocmV0IDwgMCkNCiAJCQkJcmV0
dXJuIHJldDsNCkBAIC0xMjIyLDcgKzEyNDAsOCBAQCBpcF9zZXRfdWRlbChz
dHJ1Y3Qgc29jayAqY3RubCwgc3RydWN0IHNrX2J1ZmYgKnNrYiwNCiAJCQkJ
ICAgICBhdHRyW0lQU0VUX0FUVFJfREFUQV0sDQogCQkJCSAgICAgc2V0LT50
eXBlLT5hZHRfcG9saWN5KSkNCiAJCQlyZXR1cm4gLUlQU0VUX0VSUl9QUk9U
T0NPTDsNCi0JCXJldCA9IGNhbGxfYWQoc2tiLCBzZXQsIHRiLCBJUFNFVF9E
RUwsIGZsYWdzLCB1c2VfbGluZW5vKTsNCisJCXJldCA9IGNhbGxfYWQoY3Ru
bCwgc2tiLCBzZXQsIHRiLCBJUFNFVF9ERUwsIGZsYWdzLA0KKwkJCSAgICAg
IHVzZV9saW5lbm8pOw0KIAl9IGVsc2Ugew0KIAkJaW50IG5sYV9yZW07DQog
DQpAQCAtMTIzMyw3ICsxMjUyLDcgQEAgaXBfc2V0X3VkZWwoc3RydWN0IHNv
Y2sgKmN0bmwsIHN0cnVjdCBza19idWZmICpza2IsDQogCQkJICAgIG5sYV9w
YXJzZV9uZXN0ZWQodGIsIElQU0VUX0FUVFJfQURUX01BWCwgbmxhLA0KIAkJ
CQkJICAgICBzZXQtPnR5cGUtPmFkdF9wb2xpY3kpKQ0KIAkJCQlyZXR1cm4g
LUlQU0VUX0VSUl9QUk9UT0NPTDsNCi0JCQlyZXQgPSBjYWxsX2FkKHNrYiwg
c2V0LCB0YiwgSVBTRVRfREVMLA0KKwkJCXJldCA9IGNhbGxfYWQoY3RubCwg
c2tiLCBzZXQsIHRiLCBJUFNFVF9ERUwsDQogCQkJCSAgICAgIGZsYWdzLCB1
c2VfbGluZW5vKTsNCiAJCQlpZiAocmV0IDwgMCkNCiAJCQkJcmV0dXJuIHJl
dDsNCi0tIA0KMS43LjAuNA0KDQo=

--110391808-891225599-1296675948=:29552--
