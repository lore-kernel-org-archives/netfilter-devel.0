From: Nepenthes Development Team <nepenthesdev@gmail.com>
Subject: socket match - add wildcard option [4/4]
Date: Sun, 25 Jul 2010 16:53:17 +0200
Message-ID: <AANLkTik21whM96aCB6OTedr20QxNkWoxc8EGzmWy5Ede@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016363b9a58a79428048c376d66
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:47808 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab0GYOxT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 Jul 2010 10:53:19 -0400
Received: by wwf26 with SMTP id 26so2118940wwf.1
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Jul 2010 07:53:17 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--0016363b9a58a79428048c376d66
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

linux-netfilter-socket-wildcard.diff
=A0- extend xt_socket by --wildcard option

Yes, I just noticed each reply to my own mail is a new thread, sorry,
but I did not get my own mail from majordomo to reply to.

--0016363b9a58a79428048c376d66
Content-Type: text/x-diff; charset=US-ASCII; name="linux-netfilter-socket-wildcard.diff"
Content-Disposition: attachment;
	filename="linux-netfilter-socket-wildcard.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gc20cm5k0

ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvbmV0ZmlsdGVyL3h0X3NvY2tldC5oIGIvaW5jbHVk
ZS9saW51eC9uZXRmaWx0ZXIveHRfc29ja2V0LmgKaW5kZXggNmY0NzViOC4uOWRmODc0NyAxMDA2
NDQKLS0tIGEvaW5jbHVkZS9saW51eC9uZXRmaWx0ZXIveHRfc29ja2V0LmgKKysrIGIvaW5jbHVk
ZS9saW51eC9uZXRmaWx0ZXIveHRfc29ja2V0LmgKQEAgLTMsNiArMyw3IEBACiAKIGVudW0gewog
CVhUX1NPQ0tFVF9UUkFOU1BBUkVOVCA9IDEgPDwgMCwKKwlYVF9TT0NLRVRfV0lMRENBUkQgPSAx
IDw8IDEsCiB9OwogCiBzdHJ1Y3QgeHRfc29ja2V0X210aW5mbzEgewpkaWZmIC0tZ2l0IGEvbmV0
L25ldGZpbHRlci94dF9zb2NrZXQuYyBiL25ldC9uZXRmaWx0ZXIveHRfc29ja2V0LmMKaW5kZXgg
M2Q1NGMyMy4uNmNhNDYyMiAxMDA2NDQKLS0tIGEvbmV0L25ldGZpbHRlci94dF9zb2NrZXQuYwor
KysgYi9uZXQvbmV0ZmlsdGVyL3h0X3NvY2tldC5jCkBAIC0xNDQsMTIgKzE0NCwxNCBAQCBzb2Nr
ZXRfbWF0Y2goY29uc3Qgc3RydWN0IHNrX2J1ZmYgKnNrYiwgc3RydWN0IHh0X2FjdGlvbl9wYXJh
bSAqcGFyLAogCXNrID0gbmZfdHByb3h5X2dldF9zb2NrX3Y0KGRldl9uZXQoc2tiLT5kZXYpLCBw
cm90b2NvbCwKIAkJCQkgICBzYWRkciwgZGFkZHIsIHNwb3J0LCBkcG9ydCwgcGFyLT5pbiwgZmFs
c2UpOwogCWlmIChzayAhPSBOVUxMKSB7Ci0JCWJvb2wgd2lsZGNhcmQ7CisJCWJvb2wgd2lsZGNh
cmQgPSBmYWxzZTsKIAkJYm9vbCB0cmFuc3BhcmVudCA9IHRydWU7CiAKLQkJLyogSWdub3JlIHNv
Y2tldHMgbGlzdGVuaW5nIG9uIElOQUREUl9BTlkgKi8KLQkJd2lsZGNhcmQgPSAoc2stPnNrX3N0
YXRlICE9IFRDUF9USU1FX1dBSVQgJiYKLQkJCSAgICBpbmV0X3NrKHNrKS0+aW5ldF9yY3Zfc2Fk
ZHIgPT0gMCk7CisJCS8qIElnbm9yZSBzb2NrZXRzIGxpc3RlbmluZyBvbiBJTkFERFJfQU5ZIAor
CQkgICBpZiBub3Qgc3BlY2lmaWVkIG90aGVyd2lzZSAqLworCQlpZiAoIWluZm8gfHwgIShpbmZv
LT5mbGFncyAmIFhUX1NPQ0tFVF9XSUxEQ0FSRCkpCisJCQl3aWxkY2FyZCA9IChzay0+c2tfc3Rh
dGUgIT0gVENQX1RJTUVfV0FJVCAmJgorCQkJCQlpbmV0X3NrKHNrKS0+aW5ldF9yY3Zfc2FkZHIg
PT0gMCk7CiAKIAkJLyogSWdub3JlIG5vbi10cmFuc3BhcmVudCBzb2NrZXRzLAogCQkgICBpZiBY
VF9TT0NLRVRfVFJBTlNQQVJFTlQgaXMgdXNlZCAqLwo=
--0016363b9a58a79428048c376d66--
