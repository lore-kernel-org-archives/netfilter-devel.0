From: pablo@eurodev.net
Subject: Re: Any known issues with iptables-1.3.0 from cvs/svn ?
Date: Fri, 22 Oct 2004 14:15:49 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <33413.150.214.142.17.1098447349.squirrel@150.214.142.17>
References: <20041022080913.GV3551@sunbeam.de.gnumonks.org>
	<Pine.LNX.4.58.0410221020590.17044@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20041022141549_46789"
Cc: Harald Welte <laforge@netfilter.org>, Rusty Russell <rusty@rustcorp.com.au>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.58.0410221020590.17044@tux.rsn.bth.se>
To: "Martin Josefsson" <gandalf@wlug.westbo.se>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

------=_20041022141549_46789
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

> On Fri, 22 Oct 2004, Harald Welte wrote:
>
>> Hi!
>>
>> I want to release iptables-1.3.0 (including the libiptc speedup rewrite)
>> soon.
>>
>> If anyone has any issues (bugs, changed functionality from 1.2.11, ...)
>> with the current svn code or a recent snapshot, this is the time to step
>> up :)
>
> I've been running it for a while and havn't noticed any problems except
> this:
> delete-by-specifying-the-complete-rule doesn't work.

I've been using this patch to workaround this, I used it on my test
machine. Don't know how correct it is though.

> I think Rusty did some work on that in Erlangen (libiptc internals worked
> but the rule-management was a bit screwed up back then). Rusty, did you
> finish something or should I take a look at it?
>
> /Martin
>
>

------=_20041022141549_46789
Content-Type: application/octet-stream; name="iptables.patch.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="iptables.patch.patch"

SW5kZXg6IGxpYmlwdGMvbGliaXB0Yy5jCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KUkNTIGZpbGU6IC9jdnNwdWJsaWMv
aXB0YWJsZXMvbGliaXB0Yy9saWJpcHRjLmMsdgpyZXRyaWV2aW5nIHJldmlzaW9uIDEuNTkKZGlm
ZiAtdSAtcjEuNTkgbGliaXB0Yy5jCi0tLSBsaWJpcHRjL2xpYmlwdGMuYwkyMyBTZXAgMjAwNCAx
OToyNTowNiAtMDAwMAkxLjU5CisrKyBsaWJpcHRjL2xpYmlwdGMuYwkzMCBTZXAgMjAwNCAxNjo1
ODoxOCAtMDAwMApAQCAtMTQzNSw4ICsxNDM1LDggQEAKIAkJVENfSEFORExFX1QgKmhhbmRsZSkK
IHsKIAlzdHJ1Y3QgY2hhaW5faGVhZCAqYzsKLQlzdHJ1Y3QgcnVsZV9oZWFkICpyOwotCVNUUlVD
VF9FTlRSWSAqZSwgKmZ3OworCXN0cnVjdCBydWxlX2hlYWQgKnIsICpycjsKKwlTVFJVQ1RfRU5U
UlkgKmU7CiAKIAlpcHRjX2ZuID0gVENfREVMRVRFX0VOVFJZOwogCWlmICghKGMgPSBpcHRjY19m
aW5kX2xhYmVsKGNoYWluLCAqaGFuZGxlKSkpIHsKQEAgLTE0NDQsMTUgKzE0NDQsMTggQEAKIAkJ
cmV0dXJuIDA7CiAJfQogCi0JZncgPSBtYWxsb2Mob3JpZ2Z3LT5uZXh0X29mZnNldCk7Ci0JaWYg
KGZ3ID09IE5VTEwpIHsKKwlpZiAoIShyciA9IGlwdGNjX2FsbG9jX3J1bGUoYywgb3JpZ2Z3LT5u
ZXh0X29mZnNldCkpKSB7CiAJCWVycm5vID0gRU5PTUVNOwogCQlyZXR1cm4gMDsKIAl9CiAKIAls
aXN0X2Zvcl9lYWNoX2VudHJ5KHIsICZjLT5ydWxlcywgbGlzdCkgewogCi0JCW1lbWNweShmdywg
b3JpZ2Z3LCBvcmlnZnctPm5leHRfb2Zmc2V0KTsKKwkJbWVtY3B5KHJyLT5lbnRyeSwgb3JpZ2Z3
LCBvcmlnZnctPm5leHRfb2Zmc2V0KTsKKwkJaWYgKCFpcHRjY19tYXBfdGFyZ2V0KCpoYW5kbGUs
IHJyKSl7CisJCQlmcmVlKHJyKTsKKwkJCXJldHVybiAwOworCQl9CiAKICNpZiAwCiAJCS8qIEZJ
WE1FOiBoYW5kbGUgdGhpcyBpbiBpc19zYW1lIC0tUlIgKi8KQEAgLTE0NjQsNyArMTQ2Nyw3IEBA
CiAKIAkJZSA9IHItPmVudHJ5OwogCi0JCWlmIChpc19zYW1lKGUsIGZ3LCBtYXRjaG1hc2spKSB7
CisJCWlmIChpc19zYW1lKGUsIHJyLT5lbnRyeSwgbWF0Y2htYXNrKSkgewogCQkJLyogSWYgd2Ug
YXJlIGFib3V0IHRvIGRlbGV0ZSB0aGUgcnVsZSB0aGF0IGlzIHRoZQogCQkJICogY3VycmVudCBp
dGVyYXRvciwgbW92ZSBydWxlIGl0ZXJhdG9yIGJhY2suICBuZXh0CiAJCQkgKiBwb2ludGVyIHdp
bGwgdGhlbiBwb2ludCB0byByZWFsIG5leHQgbm9kZSAqLwpAQCAtMTQ3OCwxMSArMTQ4MSwxMiBA
QAogCQkJaXB0Y2NfZGVsZXRlX3J1bGUocik7CiAKIAkJCXNldF9jaGFuZ2VkKCpoYW5kbGUpOwor
CQkJZnJlZShycik7CiAJCQlyZXR1cm4gMTsKIAkJfQogCX0KIAotCWZyZWUoZncpOworCWZyZWUo
cnIpOwogCWVycm5vID0gRU5PRU5UOwogCXJldHVybiAwOwogfQo=
------=_20041022141549_46789--
