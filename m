From: Nepenthes Development Team <nepenthesdev@gmail.com>
Subject: socket match - add wildcard option [1/4]
Date: Sun, 25 Jul 2010 16:49:18 +0200
Message-ID: <AANLkTimmYB92z3J5cysm7-RcQ4oS+-=ZmTCc_9VYQoRf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016363ba63a66e9d9048c375ff9
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47645 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab0GYOtT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 Jul 2010 10:49:19 -0400
Received: by wyf19 with SMTP id 19so1516238wyf.19
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Jul 2010 07:49:18 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--0016363ba63a66e9d9048c375ff9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

iptables-socket-match-empty-options.diff
 =A0- revert removing the empty options from extensions/xt_socket.c

--0016363ba63a66e9d9048c375ff9
Content-Type: text/x-diff; charset=US-ASCII;
	name="iptables-socket-match-empty-options.diff"
Content-Disposition: attachment;
	filename="iptables-socket-match-empty-options.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gc208ajs0

ZGlmZiAtLWdpdCBhL2V4dGVuc2lvbnMvbGlieHRfc29ja2V0LmMgYi9leHRlbnNpb25zL2xpYnh0
X3NvY2tldC5jCmluZGV4IDE0OTA0NzMuLmVlYmM3YzUgMTAwNjQ0Ci0tLSBhL2V4dGVuc2lvbnMv
bGlieHRfc29ja2V0LmMKKysrIGIvZXh0ZW5zaW9ucy9saWJ4dF9zb2NrZXQuYwpAQCAtMywxNCAr
MywzNCBAQAogICoKICAqIENvcHlyaWdodCAoQykgMjAwNyBCYWxhQml0IElUIEx0ZC4KICAqLwor
I2luY2x1ZGUgPHN0ZGlvLmg+CisjaW5jbHVkZSA8Z2V0b3B0Lmg+CiAjaW5jbHVkZSA8eHRhYmxl
cy5oPgogCitzdGF0aWMgdm9pZCBzb2NrZXRfbXRfaGVscCh2b2lkKQoreworCXByaW50Zigic29j
a2V0IHYlcyBoYXMgbm8gb3B0aW9uc1xuXG4iLCBYVEFCTEVTX1ZFUlNJT04pOworfQorCitzdGF0
aWMgaW50IHNvY2tldF9tdF9wYXJzZShpbnQgYywgY2hhciAqKmFyZ3YsIGludCBpbnZlcnQsIHVu
c2lnbmVkIGludCAqZmxhZ3MsCisJCQljb25zdCB2b2lkICplbnRyeSwgc3RydWN0IHh0X2VudHJ5
X21hdGNoICoqbWF0Y2gpCit7CisJcmV0dXJuIDA7Cit9CisKK3N0YXRpYyB2b2lkIHNvY2tldF9t
dF9jaGVjayh1bnNpZ25lZCBpbnQgZmxhZ3MpCit7Cit9CisKIHN0YXRpYyBzdHJ1Y3QgeHRhYmxl
c19tYXRjaCBzb2NrZXRfbXRfcmVnID0gewogCS5uYW1lCSAgICAgICA9ICJzb2NrZXQiLAogCS52
ZXJzaW9uICAgICAgID0gWFRBQkxFU19WRVJTSU9OLAogCS5mYW1pbHkJICAgICAgID0gTkZQUk9U
T19JUFY0LAogCS5zaXplCSAgICAgICA9IFhUX0FMSUdOKDApLAogCS51c2Vyc3BhY2VzaXplID0g
WFRfQUxJR04oMCksCisJLnBhcnNlCSAgICAgICA9IHNvY2tldF9tdF9wYXJzZSwKKwkuZmluYWxf
Y2hlY2sgICA9IHNvY2tldF9tdF9jaGVjaywKKwkuaGVscAkgICAgICAgPSBzb2NrZXRfbXRfaGVs
cCwKIH07CiAKIHZvaWQgX2luaXQodm9pZCkK
--0016363ba63a66e9d9048c375ff9--
