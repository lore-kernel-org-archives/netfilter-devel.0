From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset timeout problem
Date: Tue, 17 May 2011 13:43:59 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1105171333550.31927@blackhole.kfki.hu>
References: <4DD22A6B.9080904@metu.edu.tr>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="110391808-1172078584-1305632639=:31927"
Cc: netfilter-devel@vger.kernel.org
To: Lutfi <lutfio@metu.edu.tr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:40012 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570Ab1EQLoD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 May 2011 07:44:03 -0400
In-Reply-To: <4DD22A6B.9080904@metu.edu.tr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110391808-1172078584-1305632639=:31927
Content-Type: TEXT/PLAIN; charset=US-ASCII

On Tue, 17 May 2011, Lutfi wrote:

> I am using ipset v. 6.2 on my Debian 6.0 64 bit box with kernel verison
> 2.6.37.2 #12. I used the command  "ipset create test iptree  --timeout
> 10800" for creating  the set and add the ip addresses by using "ipset
> add test x.x.x.x". At beginning there seems no problem but after a while
> timeout values increases for ip addresses. Moreover I use a script to
> add those ip addresses to this set.  The output of "ipset
> list test" is below:
> 
> Name: test
> Type: hash:ip
> Header: family inet hashsize 8192 maxelem 65536 timeout 10800
> Size in memory: 733184
> References: 3
> Members:
> 82.192.209.168 timeout 14134968

I have tried to reproduce it with ipset-6.5 and was unsuccessful. However, 
there are some problems with the timeout conversions in the kernel. Could 
you try the attached patch and report back whether it solves the issue?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
--110391808-1172078584-1305632639=:31927
Content-Type: TEXT/x-diff; name=timeout2.patch
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.2.00.1105171343590.31927@blackhole.kfki.hu>
Content-Description: timeout.patch
Content-Disposition: attachment; filename=timeout2.patch

ZGlmZiAtLWdpdCBhL2tlcm5lbC9pbmNsdWRlL2xpbnV4L25ldGZpbHRlci9p
cHNldC9pcF9zZXRfdGltZW91dC5oIGIva2VybmVsL2luY2x1ZGUvbGludXgv
bmV0ZmlsdGVyL2lwc2V0L2lwX3NldF90aW1lb3V0LmgNCmluZGV4IGI5YTBj
MjYuLmJhZTA4NmEgMTAwNjQ0DQotLS0gYS9rZXJuZWwvaW5jbHVkZS9saW51
eC9uZXRmaWx0ZXIvaXBzZXQvaXBfc2V0X3RpbWVvdXQuaA0KKysrIGIva2Vy
bmVsL2luY2x1ZGUvbGludXgvbmV0ZmlsdGVyL2lwc2V0L2lwX3NldF90aW1l
b3V0LmgNCkBAIC00OCw3ICs0OCw3IEBAIGlwX3NldF90aW1lb3V0X3Rlc3Qo
dW5zaWduZWQgbG9uZyB0aW1lb3V0KQ0KIHsNCiAJcmV0dXJuIHRpbWVvdXQg
IT0gSVBTRVRfRUxFTV9VTlNFVCAmJg0KIAkgICAgICAgKHRpbWVvdXQgPT0g
SVBTRVRfRUxFTV9QRVJNQU5FTlQgfHwNCi0JCXRpbWVfYWZ0ZXIodGltZW91
dCwgamlmZmllcykpOw0KKwkJdGltZV9pc19hZnRlcl9qaWZmaWVzKHRpbWVv
dXQpKTsNCiB9DQogDQogc3RhdGljIGlubGluZSBib29sDQpAQCAtNTYsNyAr
NTYsNyBAQCBpcF9zZXRfdGltZW91dF9leHBpcmVkKHVuc2lnbmVkIGxvbmcg
dGltZW91dCkNCiB7DQogCXJldHVybiB0aW1lb3V0ICE9IElQU0VUX0VMRU1f
VU5TRVQgJiYNCiAJICAgICAgIHRpbWVvdXQgIT0gSVBTRVRfRUxFTV9QRVJN
QU5FTlQgJiYNCi0JICAgICAgIHRpbWVfYmVmb3JlKHRpbWVvdXQsIGppZmZp
ZXMpOw0KKwkgICAgICAgdGltZV9pc19iZWZvcmVfamlmZmllcyh0aW1lb3V0
KTsNCiB9DQogDQogc3RhdGljIGlubGluZSB1bnNpZ25lZCBsb25nDQpAQCAt
NjcsNyArNjcsNyBAQCBpcF9zZXRfdGltZW91dF9zZXQodTMyIHRpbWVvdXQp
DQogCWlmICghdGltZW91dCkNCiAJCXJldHVybiBJUFNFVF9FTEVNX1BFUk1B
TkVOVDsNCiANCi0JdCA9IHRpbWVvdXQgKiBIWiArIGppZmZpZXM7DQorCXQg
PSBtc2Vjc190b19qaWZmaWVzKHRpbWVvdXQgKiAxMDAwKSArIGppZmZpZXM7
DQogCWlmICh0ID09IElQU0VUX0VMRU1fVU5TRVQgfHwgdCA9PSBJUFNFVF9F
TEVNX1BFUk1BTkVOVCkNCiAJCS8qIEJpbmdvISAqLw0KIAkJdCsrOw0KQEAg
LTc4LDcgKzc4LDggQEAgaXBfc2V0X3RpbWVvdXRfc2V0KHUzMiB0aW1lb3V0
KQ0KIHN0YXRpYyBpbmxpbmUgdTMyDQogaXBfc2V0X3RpbWVvdXRfZ2V0KHVu
c2lnbmVkIGxvbmcgdGltZW91dCkNCiB7DQotCXJldHVybiB0aW1lb3V0ID09
IElQU0VUX0VMRU1fUEVSTUFORU5UID8gMCA6ICh0aW1lb3V0IC0gamlmZmll
cykvSFo7DQorCXJldHVybiB0aW1lb3V0ID09IElQU0VUX0VMRU1fUEVSTUFO
RU5UID8gMCA6IA0KKwkJamlmZmllc190b19tc2Vjcyh0aW1lb3V0IC0gamlm
ZmllcykvMTAwMDsNCiB9DQogDQogI2Vsc2UNCkBAIC05MiwxNCArOTMsMTQg
QEAgc3RhdGljIGlubGluZSBib29sDQogaXBfc2V0X3RpbWVvdXRfdGVzdCh1
bnNpZ25lZCBsb25nIHRpbWVvdXQpDQogew0KIAlyZXR1cm4gdGltZW91dCA9
PSBJUFNFVF9FTEVNX1BFUk1BTkVOVCB8fA0KLQkgICAgICAgdGltZV9hZnRl
cih0aW1lb3V0LCBqaWZmaWVzKTsNCisJICAgICAgIHRpbWVfaXNfYWZ0ZXJf
amlmZmllcyh0aW1lb3V0KTsNCiB9DQogDQogc3RhdGljIGlubGluZSBib29s
DQogaXBfc2V0X3RpbWVvdXRfZXhwaXJlZCh1bnNpZ25lZCBsb25nIHRpbWVv
dXQpDQogew0KIAlyZXR1cm4gdGltZW91dCAhPSBJUFNFVF9FTEVNX1BFUk1B
TkVOVCAmJg0KLQkgICAgICAgdGltZV9iZWZvcmUodGltZW91dCwgamlmZmll
cyk7DQorCSAgICAgICB0aW1lX2lzX2JlZm9yZV9qaWZmaWVzKHRpbWVvdXQp
Ow0KIH0NCiANCiBzdGF0aWMgaW5saW5lIHVuc2lnbmVkIGxvbmcNCkBAIC0x
MTAsNyArMTExLDcgQEAgaXBfc2V0X3RpbWVvdXRfc2V0KHUzMiB0aW1lb3V0
KQ0KIAlpZiAoIXRpbWVvdXQpDQogCQlyZXR1cm4gSVBTRVRfRUxFTV9QRVJN
QU5FTlQ7DQogDQotCXQgPSB0aW1lb3V0ICogSFogKyBqaWZmaWVzOw0KKwl0
ID0gbXNlY3NfdG9famlmZmllcyh0aW1lb3V0ICogMTAwMCkgKyBqaWZmaWVz
Ow0KIAlpZiAodCA9PSBJUFNFVF9FTEVNX1BFUk1BTkVOVCkNCiAJCS8qIEJp
bmdvISA6LSkgKi8NCiAJCXQrKzsNCkBAIC0xMjEsNyArMTIyLDggQEAgaXBf
c2V0X3RpbWVvdXRfc2V0KHUzMiB0aW1lb3V0KQ0KIHN0YXRpYyBpbmxpbmUg
dTMyDQogaXBfc2V0X3RpbWVvdXRfZ2V0KHVuc2lnbmVkIGxvbmcgdGltZW91
dCkNCiB7DQotCXJldHVybiB0aW1lb3V0ID09IElQU0VUX0VMRU1fUEVSTUFO
RU5UID8gMCA6ICh0aW1lb3V0IC0gamlmZmllcykvSFo7DQorCXJldHVybiB0
aW1lb3V0ID09IElQU0VUX0VMRU1fUEVSTUFORU5UID8gMCA6DQorCQlqaWZm
aWVzX3RvX21zZWNzKHRpbWVvdXQgLSBqaWZmaWVzKS8xMDAwOw0KIH0NCiAj
ZW5kaWYgLyogISBJUF9TRVRfQklUTUFQX1RJTUVPVVQgKi8NCiANCg==

--110391808-1172078584-1305632639=:31927--
