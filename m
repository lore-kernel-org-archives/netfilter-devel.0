From: Jonh Wendell <jonh.wendell@vexcorp.com>
Subject: Re: patch in bugzilla
Date: Thu, 1 Mar 2012 17:07:57 -0300
Message-ID: <CAO88JF-=PTq2ZXaNWhE6mLKZY96y_fqCqxetNy-6h-Dwv3Ph3Q@mail.gmail.com>
References: <CAO88JF9FcBkjEs345hK4bOhQa1q-RuckkrLN9SKUUt3cWaLJKw@mail.gmail.com>
	<alpine.LNX.2.01.1202281409020.10284@frira.zrqbmnf.qr>
	<20120229125052.GA1115@1984>
	<20120229232739.GB3817@1984>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=bcaec554e12029a29904ba34040b
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47930 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856Ab2CAUH7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Mar 2012 15:07:59 -0500
Received: by bkcik5 with SMTP id ik5so903998bkc.19
        for <netfilter-devel@vger.kernel.org>; Thu, 01 Mar 2012 12:07:57 -0800 (PST)
In-Reply-To: <20120229232739.GB3817@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--bcaec554e12029a29904ba34040b
Content-Type: text/plain; charset=ISO-8859-1

Sorry, guys. In fact, I had tested only libiptc itself, not the iptables binary.

Here is the complete patch, modifying all callers of iptc_append_entry().

I tried it here and it worked fine.

Thanks!

2012/2/29 Pablo Neira Ayuso <pablo@netfilter.org>:
> On Wed, Feb 29, 2012 at 01:50:52PM +0100, Pablo Neira Ayuso wrote:
>> On Tue, Feb 28, 2012 at 04:20:10PM +0100, Jan Engelhardt wrote:
>> > On Tuesday 2012-02-28 13:48, Jonh Wendell wrote:
>> >
>> > >hi, folks. a while ago I filled a bug with a simple patch attached:
>> > >http://bugzilla.netfilter.org/show_bug.cgi?id=768
>> > >
>> > >what's the right place to post things like that? here in this mailing
>> > >list or the bugzilla?
>> >
>> > [Someone still has not pointed the bugzilla automatic notification to
>> > post to the netfilter-devel mailing list :) ]
>> >
>> > Certainly the choice of mailing list makes it more visible. No
>> > objections to the patch.
>>
>> Applied, thanks.
>
> I'm going to revert this patch, it's breaking my iptables script:
>
> # iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
> iptables: Incompatible with this kernel.
>
> Please, test patches before posting them.



-- 
Jonh Wendell
www.vexcorp.com

--bcaec554e12029a29904ba34040b
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-libiptc-Returns-the-position-the-entry-was-inserted.patch"
Content-Disposition: attachment;
	filename="0001-libiptc-Returns-the-position-the-entry-was-inserted.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gza86rvb0

RnJvbSBhNWNmZDNiZDQwMDBmYTcxNTJjNTJhYjJlYTc5MWVmY2U3ZDIxNzAwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKb25oIFdlbmRlbGwgPGpvbmgud2VuZGVsbEB2ZXhjb3JwLmNv
bT4KRGF0ZTogVGh1LCAxIE1hciAyMDEyIDE3OjA0OjIyIC0wMzAwClN1YmplY3Q6IFtQQVRDSF0g
bGliaXB0YzogUmV0dXJucyB0aGUgcG9zaXRpb24gdGhlIGVudHJ5IHdhcyBpbnNlcnRlZAoKLS0t
CiBpbmNsdWRlL2xpYmlwdGMvbGliaXB0Yy5oIHwgICAgMyArKy0KIGlwdGFibGVzL2lwNnRhYmxl
cy5jICAgICAgfCAgICAzICsrLQogaXB0YWJsZXMvaXB0YWJsZXMuYyAgICAgICB8ICAgIDMgKyst
CiBsaWJpcHRjL2xpYmlwdGMuYyAgICAgICAgIHwgICAgNSArKystLQogNCBmaWxlcyBjaGFuZ2Vk
LCA5IGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9s
aWJpcHRjL2xpYmlwdGMuaCBiL2luY2x1ZGUvbGliaXB0Yy9saWJpcHRjLmgKaW5kZXggMjRjZGJk
Yi4uYjlhNDJjOSAxMDA2NDQKLS0tIGEvaW5jbHVkZS9saWJpcHRjL2xpYmlwdGMuaAorKysgYi9p
bmNsdWRlL2xpYmlwdGMvbGliaXB0Yy5oCkBAIC03NCw3ICs3NCw4IEBAIGludCBpcHRjX3JlcGxh
Y2VfZW50cnkoY29uc3QgeHRfY2hhaW5sYWJlbCBjaGFpbiwKIAkJICAgICAgIHN0cnVjdCB4dGNf
aGFuZGxlICpoYW5kbGUpOwogCiAvKiBBcHBlbmQgZW50cnkgYGUnIHRvIGNoYWluIGBjaGFpbicu
ICBFcXVpdmFsZW50IHRvIGluc2VydCB3aXRoCi0gICBydWxlbnVtID0gbGVuZ3RoIG9mIGNoYWlu
LiAqLworICAgcnVsZW51bSA9IGxlbmd0aCBvZiBjaGFpbi4gUmV0dXJucyB0aGUgcG9zaXRpb24g
dGhlIGVudHJ5IHdhcworICAgaW5zZXJ0ZWQgb3IgMCBpZiBhbiBlcnJvciBvY2N1cnMgKi8KIGlu
dCBpcHRjX2FwcGVuZF9lbnRyeShjb25zdCB4dF9jaGFpbmxhYmVsIGNoYWluLAogCQkgICAgICBj
b25zdCBzdHJ1Y3QgaXB0X2VudHJ5ICplLAogCQkgICAgICBzdHJ1Y3QgeHRjX2hhbmRsZSAqaGFu
ZGxlKTsKZGlmZiAtLWdpdCBhL2lwdGFibGVzL2lwNnRhYmxlcy5jIGIvaXB0YWJsZXMvaXA2dGFi
bGVzLmMKaW5kZXggYjE5MWQ1ZC4uOGRmMDZkNiAxMDA2NDQKLS0tIGEvaXB0YWJsZXMvaXA2dGFi
bGVzLmMKKysrIGIvaXB0YWJsZXMvaXA2dGFibGVzLmMKQEAgLTY5OCw3ICs2OTgsOCBAQCBhcHBl
bmRfZW50cnkoY29uc3QgeHRfY2hhaW5sYWJlbCBjaGFpbiwKIAkJCWZ3LT5pcHY2LmRtc2sgPSBk
bWFza3Nbal07CiAJCQlpZiAodmVyYm9zZSkKIAkJCQlwcmludF9maXJld2FsbF9saW5lKGZ3LCBo
YW5kbGUpOwotCQkJcmV0ICY9IGlwNnRjX2FwcGVuZF9lbnRyeShjaGFpbiwgZncsIGhhbmRsZSk7
CisJCQlpZiAoIWlwNnRjX2FwcGVuZF9lbnRyeShjaGFpbiwgZncsIGhhbmRsZSkpCisJCQkJcmV0
ID0gMDsKIAkJfQogCX0KIApkaWZmIC0tZ2l0IGEvaXB0YWJsZXMvaXB0YWJsZXMuYyBiL2lwdGFi
bGVzL2lwdGFibGVzLmMKaW5kZXggMDNhYzYzYi4uMTBmMzBkMyAxMDA2NDQKLS0tIGEvaXB0YWJs
ZXMvaXB0YWJsZXMuYworKysgYi9pcHRhYmxlcy9pcHRhYmxlcy5jCkBAIC03MDAsNyArNzAwLDgg
QEAgYXBwZW5kX2VudHJ5KGNvbnN0IHh0X2NoYWlubGFiZWwgY2hhaW4sCiAJCQlmdy0+aXAuZG1z
ay5zX2FkZHIgPSBkbWFza3Nbal0uc19hZGRyOwogCQkJaWYgKHZlcmJvc2UpCiAJCQkJcHJpbnRf
ZmlyZXdhbGxfbGluZShmdywgaGFuZGxlKTsKLQkJCXJldCAmPSBpcHRjX2FwcGVuZF9lbnRyeShj
aGFpbiwgZncsIGhhbmRsZSk7CisJCQlpZiAoIWlwdGNfYXBwZW5kX2VudHJ5KGNoYWluLCBmdywg
aGFuZGxlKSkKKwkJCQlyZXQgPSAwOwogCQl9CiAJfQogCmRpZmYgLS1naXQgYS9saWJpcHRjL2xp
YmlwdGMuYyBiL2xpYmlwdGMvbGliaXB0Yy5jCmluZGV4IDYzZmNmYzIuLmRkYWVlMTIgMTAwNjQ0
Ci0tLSBhL2xpYmlwdGMvbGliaXB0Yy5jCisrKyBiL2xpYmlwdGMvbGliaXB0Yy5jCkBAIC0xODM2
LDcgKzE4MzYsOCBAQCBUQ19SRVBMQUNFX0VOVFJZKGNvbnN0IElQVF9DSEFJTkxBQkVMIGNoYWlu
LAogfQogCiAvKiBBcHBlbmQgZW50cnkgYGZ3JyB0byBjaGFpbiBgY2hhaW4nLiAgRXF1aXZhbGVu
dCB0byBpbnNlcnQgd2l0aAotICAgcnVsZW51bSA9IGxlbmd0aCBvZiBjaGFpbi4gKi8KKyAgIHJ1
bGVudW0gPSBsZW5ndGggb2YgY2hhaW4uIFJldHVybnMgdGhlIHBvc2l0aW9uIHRoZSBlbnRyeSB3
YXMKKyAgIGluc2VydGVkIG9yIDAgaWYgYW4gZXJyb3Igb2NjdXJzICovCiBpbnQKIFRDX0FQUEVO
RF9FTlRSWShjb25zdCBJUFRfQ0hBSU5MQUJFTCBjaGFpbiwKIAkJY29uc3QgU1RSVUNUX0VOVFJZ
ICplLApAQCAtMTg3Miw3ICsxODczLDcgQEAgVENfQVBQRU5EX0VOVFJZKGNvbnN0IElQVF9DSEFJ
TkxBQkVMIGNoYWluLAogCiAJc2V0X2NoYW5nZWQoaGFuZGxlKTsKIAotCXJldHVybiAxOworCXJl
dHVybiBjLT5udW1fcnVsZXM7CiB9CiAKIHN0YXRpYyBpbmxpbmUgaW50Ci0tIAoxLjcuNS40Cgo=
--bcaec554e12029a29904ba34040b--
