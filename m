From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nft PATCH 2/3] src/evaluate.c: improve rule management checks
Date: Mon, 28 Mar 2016 13:32:41 +0200
Message-ID: <CAOkSjBgH5PVfRisRXb3gqTi1Feaf+gVn=AFHVEFvH-zsBn1ZSA@mail.gmail.com>
References: <145873749309.10004.11477358360509958985.stgit@nfdev2.cica.es>
 <145873749855.10004.10666252455830923605.stgit@nfdev2.cica.es> <20160323160834.GA6981@salvia>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=089e010d852e7983f5052f1a46d0
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35988 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbcC1LdD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Mar 2016 07:33:03 -0400
Received: by mail-wm0-f66.google.com with SMTP id 20so2987351wmh.3
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Mar 2016 04:33:02 -0700 (PDT)
In-Reply-To: <20160323160834.GA6981@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--089e010d852e7983f5052f1a46d0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 23 March 2016 at 17:08, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Mar 23, 2016 at 01:51:38PM +0100, Arturo Borrero Gonzalez wrote:
>> Improve checks (and error reporting) for basic rule management operation=
s.
>>
>> This includes a fix for netfilter bug #965.
>
> Thanks for working on this.
>
> With a bit more work we can achieve better error reporting:
>
> # nft insert rule x y handle 10 position 10 ip saddr 1.1.1.1
> <cmdline>:1:17-25: Error: Wrong combination, use `position' instead
> insert rule x y handle 10 position 10 ip saddr 1.1.1.1
>                 ^^^^^^^^^ ~~~~~~~~~~~
>
> # nft insert rule x y handle 10 ip saddr 1.1.1.1
> <cmdline>:1:17-25: Error: Cannot use this, use `position' instead
> insert rule x y handle 10 ip saddr 1.1.1.1
>                 ^^^^^^^^^
>
> You will need to rework this patch applying this patch in first place:
>
> http://patchwork.ozlabs.org/patch/601270/
>
> I'm also attaching a quick patch for the two examples, but remaining
> spots are left unchanges. Please feel free to follow up on this.
>
> Thanks.

Hi,

I completed the patch, amended a bit the error messages.

Find it attached.

The applies in in this order:
 * http://patchwork.ozlabs.org/patch/601270/ (src: store parser
location for handle and position IDs)
 * http://patchwork.ozlabs.org/patch/601216/ (src/rule.c: don't print
trailing statement whitespace)
 * the attached patch
 * http://patchwork.ozlabs.org/patch/601218/ (tests/shell: add
testcases for Netfilter bug #965)


best regards.

--=20
Arturo Borrero Gonz=C3=A1lez

--089e010d852e7983f5052f1a46d0
Content-Type: text/x-patch; charset=US-ASCII;
	name="nft-2-3-src-evaluate.c-improve-rule-management-checks.patch"
Content-Disposition: attachment;
	filename="nft-2-3-src-evaluate.c-improve-rule-management-checks.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_imbwwl9q1

CgpGcm9tOiBBcnR1cm8gQm9ycmVybyBHb256YWxleiA8YXJ0dXJvLmJvcnJlcm8uZ2xlekBnbWFp
bC5jb20+CgoKLS0tCiBzcmMvZXZhbHVhdGUuYyB8ICAgODYgKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0KIDEgZmlsZSBjaGFuZ2VkLCA4NSBp
bnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvc3JjL2V2YWx1YXRlLmMg
Yi9zcmMvZXZhbHVhdGUuYwppbmRleCA0NzNmMDE0Li5jZjE1N2Y3IDEwMDY0NAotLS0gYS9zcmMv
ZXZhbHVhdGUuYworKysgYi9zcmMvZXZhbHVhdGUuYwpAQCAtNjUsNiArNjUsMTIgQEAgc3RhdGlj
IGludCBfX2ZtdHN0cmluZyg0LCA1KSBfX3N0bXRfYmluYXJ5X2Vycm9yKHN0cnVjdCBldmFsX2N0
eCAqY3R4LAogCV9fc3RtdF9iaW5hcnlfZXJyb3IoY3R4LCAmKHMxKS0+bG9jYXRpb24sIE5VTEws
IGZtdCwgIyMgYXJncykKICNkZWZpbmUgY21kX2Vycm9yKGN0eCwgZm10LCBhcmdzLi4uKSBcCiAJ
X19zdG10X2JpbmFyeV9lcnJvcihjdHgsICYoY3R4LT5jbWQpLT5sb2NhdGlvbiwgTlVMTCwgZm10
LCAjIyBhcmdzKQorI2RlZmluZSBoYW5kbGVfZXJyb3IoY3R4LCBmbXQsIGFyZ3MuLi4pIFwKKwlf
X3N0bXRfYmluYXJ5X2Vycm9yKGN0eCwgJmN0eC0+Y21kLT5oYW5kbGUuaGFuZGxlLmxvY2F0aW9u
LCBOVUxMLCBmbXQsICMjIGFyZ3MpCisjZGVmaW5lIHBvc2l0aW9uX2Vycm9yKGN0eCwgZm10LCBh
cmdzLi4uKSBcCisJX19zdG10X2JpbmFyeV9lcnJvcihjdHgsICZjdHgtPmNtZC0+aGFuZGxlLnBv
c2l0aW9uLmxvY2F0aW9uLCBOVUxMLCBmbXQsICMjIGFyZ3MpCisjZGVmaW5lIGhhbmRsZV9wb3Np
dGlvbl9lcnJvcihjdHgsIGZtdCwgYXJncy4uLikgXAorCV9fc3RtdF9iaW5hcnlfZXJyb3IoY3R4
LCAmY3R4LT5jbWQtPmhhbmRsZS5oYW5kbGUubG9jYXRpb24sICZjdHgtPmNtZC0+aGFuZGxlLnBv
c2l0aW9uLmxvY2F0aW9uLCBmbXQsICMjIGFyZ3MpCiAKIHN0YXRpYyBpbnQgX19mbXRzdHJpbmco
MywgNCkgc2V0X2Vycm9yKHN0cnVjdCBldmFsX2N0eCAqY3R4LAogCQkJCSAgICAgICBjb25zdCBz
dHJ1Y3Qgc2V0ICpzZXQsCkBAIC0yMTYwLDExICsyMTY2LDg2IEBAIHN0YXRpYyBpbnQgc2V0X2V2
YWx1YXRlKHN0cnVjdCBldmFsX2N0eCAqY3R4LCBzdHJ1Y3Qgc2V0ICpzZXQpCiAJcmV0dXJuIDA7
CiB9CiAKK3N0YXRpYyBpbnQgcnVsZV9ldmFsdWF0ZV9jbWQoc3RydWN0IGV2YWxfY3R4ICpjdHgp
Cit7CisJc3RydWN0IGhhbmRsZSAqaGFuZGxlID0gJmN0eC0+Y21kLT5oYW5kbGU7CisKKwkvKiBh
bGxvd2VkOgorCSAqIC0gaW5zZXJ0IFtwb3NpdGlvbl0gKG5vIGhhbmRsZSkKKwkgKiAtIGFkZCBb
cG9zaXRpb25dIChubyBoYW5kbGUpCisJICogLSByZXBsYWNlIDxoYW5kbGU+IChubyBwb3NpdGlv
bikKKwkgKiAtIGRlbGV0ZSA8aGFuZGxlPiAobm8gcG9zaXRpb24pCisJICovCisKKwlzd2l0Y2gg
KGN0eC0+Y21kLT5vcCkgeworCWNhc2UgQ01EX0lOU0VSVDoKKwkJaWYgKGhhbmRsZS0+aGFuZGxl
LmlkICYmIGhhbmRsZS0+cG9zaXRpb24uaWQpCisJCQlyZXR1cm4gaGFuZGxlX3Bvc2l0aW9uX2Vy
cm9yKGN0eCwgIkNvdWxkIG5vdCBpbnNlcnQgIgorCQkJCQkJICAgICAicnVsZTogd3JvbmcgY29t
YmluYXRpb24iCisJCQkJCQkgICAgICIsIHVzZSBvbmx5IGBwb3NpdGlvbicgIgorCQkJCQkJICAg
ICAiaW5zdGVhZCIpOworCisJCWlmIChoYW5kbGUtPmhhbmRsZS5pZCkKKwkJCXJldHVybiBoYW5k
bGVfZXJyb3IoY3R4LCAiQ291bGQgbm90IGluc2VydCBydWxlOiAiCisJCQkJCSAgICAiY2Fubm90
IHVzZSB0aGlzLCB1c2UgIgorCQkJCQkgICAgImBwb3NpdGlvbicgaW5zdGVhZCIpOworCQlicmVh
azsKKwljYXNlIENNRF9BREQ6CisJCWlmIChoYW5kbGUtPmhhbmRsZS5pZCAmJiBoYW5kbGUtPnBv
c2l0aW9uLmlkKQorCQkJcmV0dXJuIGhhbmRsZV9wb3NpdGlvbl9lcnJvcihjdHgsICJDb3VsZCBu
b3QgYWRkICIKKwkJCQkJCSAgICAgInJ1bGU6IHdyb25nIGNvbWJpbmF0aW9uIgorCQkJCQkJICAg
ICAiLCB1c2Ugb25seSBgcG9zaXRpb24nICIKKwkJCQkJCSAgICAgImluc3RlYWQiKTsKKworCQlp
ZiAoaGFuZGxlLT5oYW5kbGUuaWQpCisJCQlyZXR1cm4gaGFuZGxlX2Vycm9yKGN0eCwgIkNvdWxk
IG5vdCBhZGQgcnVsZTogIgorCQkJCQkgICAgImNhbm5vdCB1c2UgdGhpcywgdXNlICIKKwkJCQkJ
ICAgICJgcG9zaXRpb24nIGluc3RlYWQiKTsKKworCQlicmVhazsKKwljYXNlIENNRF9SRVBMQUNF
OgorCQlpZiAoaGFuZGxlLT5oYW5kbGUuaWQgJiYgaGFuZGxlLT5wb3NpdGlvbi5pZCkKKwkJCXJl
dHVybiBoYW5kbGVfcG9zaXRpb25fZXJyb3IoY3R4LCAiQ291bGQgbm90IHJlcGxhY2UgIgorCQkJ
CQkJICAgICAicnVsZTogd3JvbmcgY29tYmluYXRpb24iCisJCQkJCQkgICAgICIsIHVzZSBvbmx5
IGBoYW5kbGUnICIKKwkJCQkJCSAgICAgImluc3RlYWQiKTsKKwkJaWYgKGhhbmRsZS0+cG9zaXRp
b24uaWQpCisJCQlyZXR1cm4gcG9zaXRpb25fZXJyb3IoY3R4LCAiQ291bGQgbm90IHJlcGxhY2Ug
cnVsZTogIgorCQkJCQkgICAgICAiY2Fubm90IHVzZSB0aGlzLCB1c2UgYGhhbmRsZScgIgorCQkJ
CQkgICAgICAiaW5zdGVhZCIpOworCQlpZiAoIWhhbmRsZS0+aGFuZGxlLmlkKQorCQkJcmV0dXJu
IGNtZF9lcnJvcihjdHgsICJDb3VsZCBub3QgcmVwbGFjZSBydWxlOiBtaXNzaW5nIgorCQkJCQkg
IiBgaGFuZGxlJy4iKTsKKwkJYnJlYWs7CisJY2FzZSBDTURfREVMRVRFOgorCQlpZiAoaGFuZGxl
LT5oYW5kbGUuaWQgJiYgaGFuZGxlLT5wb3NpdGlvbi5pZCkKKwkJCXJldHVybiBoYW5kbGVfcG9z
aXRpb25fZXJyb3IoY3R4LCAiQ291bGQgbm90IHJlcGxhY2UgIgorCQkJCQkJICAgICAicnVsZTog
d3JvbmcgY29tYmluYXRpb24iCisJCQkJCQkgICAgICIsIHVzZSBvbmx5IGBoYW5kbGUnICIKKwkJ
CQkJCSAgICAgImluc3RlYWQiKTsKKwkJaWYgKGhhbmRsZS0+cG9zaXRpb24uaWQpCisJCQlyZXR1
cm4gcG9zaXRpb25fZXJyb3IoY3R4LCAiQ291bGQgbm90IHJlcGxhY2UgcnVsZTogIgorCQkJCQkg
ICAgICAiY2Fubm90IHVzZSB0aGlzLCB1c2UgYGhhbmRsZScgIgorCQkJCQkgICAgICAiaW5zdGVh
ZCIpOworCQlpZiAoIWhhbmRsZS0+aGFuZGxlLmlkKQorCQkJcmV0dXJuIGNtZF9lcnJvcihjdHgs
ICJDb3VsZCBub3QgcmVwbGFjZSBydWxlOiBtaXNzaW5nIgorCQkJCQkgIiBgaGFuZGxlJy4iKTsK
KwkJYnJlYWs7CisJZGVmYXVsdDoKKwkJQlVHKCJ1bmtvd24gY29tbWFuZCB0eXBlICV1XG4iLCBj
dHgtPmNtZC0+b3ApOworCX0KKworCXJldHVybiAwOworfQorCiBzdGF0aWMgaW50IHJ1bGVfZXZh
bHVhdGUoc3RydWN0IGV2YWxfY3R4ICpjdHgsIHN0cnVjdCBydWxlICpydWxlKQogewogCXN0cnVj
dCBzdG10ICpzdG10LCAqdHN0bXQgPSBOVUxMOwogCXN0cnVjdCBlcnJvcl9yZWNvcmQgKmVyZWM7
CiAKKwlpZiAocnVsZV9ldmFsdWF0ZV9jbWQoY3R4KSA8IDApCisJCXJldHVybiAtMTsKKwogCXBy
b3RvX2N0eF9pbml0KCZjdHgtPnBjdHgsIHJ1bGUtPmhhbmRsZS5mYW1pbHkpOwogCW1lbXNldCgm
Y3R4LT5lY3R4LCAwLCBzaXplb2YoY3R4LT5lY3R4KSk7CiAKQEAgLTIzNDUsOCArMjQyNiwxMSBA
QCBzdGF0aWMgaW50IGNtZF9ldmFsdWF0ZV9kZWxldGUoc3RydWN0IGV2YWxfY3R4ICpjdHgsIHN0
cnVjdCBjbWQgKmNtZCkKIAkJCXJldHVybiByZXQ7CiAKIAkJcmV0dXJuIHNldGVsZW1fZXZhbHVh
dGUoY3R4LCAmY21kLT5leHByKTsKLQljYXNlIENNRF9PQkpfU0VUOgogCWNhc2UgQ01EX09CSl9S
VUxFOgorCQlpZiAocnVsZV9ldmFsdWF0ZV9jbWQoY3R4KSA8IDApCisJCQlyZXR1cm4gLTE7CisJ
CS8qIGZhbGwgdGhyb3VnaCAqLworCWNhc2UgQ01EX09CSl9TRVQ6CiAJY2FzZSBDTURfT0JKX0NI
QUlOOgogCWNhc2UgQ01EX09CSl9UQUJMRToKIAkJcmV0dXJuIDA7Cg==
--089e010d852e7983f5052f1a46d0--
