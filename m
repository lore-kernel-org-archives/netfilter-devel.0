From: Jan Engelhardt <jengelh@inai.de>
Subject: Fwd: One issue in the xt_hashlimit.c
Date: Mon, 3 Dec 2012 03:00:55 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1212030259450.5002@nerf07.vanv.qr>
Reply-To: Netfilter Developer Mailing List
	  <netfilter-devel@vger.kernel.org>, FGao@a10networks.com,
	  jengelh@inai.de
Mime-Version: 1.0
Content-Type: MULTIPART/Mixed; BOUNDARY=_004_160B5DCC41754649A37CE908E63173FCECF716SJMB02corpa10netw_
Cc: Feng Gao <FGao@a10networks.com>
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:44514 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754277Ab2LCCA6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 2 Dec 2012 21:00:58 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--_004_160B5DCC41754649A37CE908E63173FCECF716SJMB02corpa10netw_
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT

Should be cc'ed to netfilter-devel; now done.

---------- Forwarded message ----------
Date: Sun, 2 Dec 2012 08:21:08
From: Feng Gao <FGao@a10networks.com>
To: laforge, jengelh
Subject: One issue in the xt_hashlimit.c

Hi Harald & Jan,

I am a programmer in China. I read the codes of netfilter recently, and find
one potent issue in the funciton "hashlimit_mt", file "xt_hashlimit.c".

The following codes are from function "hashlimit_mt".
dh = dsthash_find(hinfo, &dst);
if (dh == NULL) {
dh = dsthash_alloc_init(hinfo, &dst);

When two or more threads invoke dsthash_find(hinfo, &dst) at the same time
and fail to find the dh, then all of them will enter the dsthash_alloc_init
to create one new node.
As a result, it will casue that these multiple threads create multle nodes
with same IP. It is not expected behavior.

we should add the check in the fucntion "dsthash_alloc_init" to if the node
has been already created in the function  to fix it.
The attachment is my fix. 


Best Regards
Feng

--_004_160B5DCC41754649A37CE908E63173FCECF716SJMB02corpa10netw_
Content-Type: APPLICATION/OCTET-STREAM; NAME=xt_hashlimit.diff
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.LNX.2.01.1212030259451.5002@nerf07.vanv.qr>
Content-Description: xt_hashlimit.diff
Content-Disposition: ATTACHMENT; FILENAME=xt_hashlimit.diff; SIZE=1944; CREATION-DATE="Sun, 02 Dec 2012 07:21:02 GMT"; MODIFICATION-DATE="Sun, 02 Dec 2012 07:21:02 GMT"

LS0tIG5ldC9uZXRmaWx0ZXIveHRfaGFzaGxpbWl0LmMub3JpZwkyMDEyLTEyLTAyIDEzOjU0OjQ1
LjM3NjM4MjE2NSArMDgwMAorKysgbmV0L25ldGZpbHRlci94dF9oYXNobGltaXQuYwkyMDEyLTEy
LTAyIDEzOjU5OjMyLjA4MzM4MTE0MiArMDgwMApAQCAtMTU3LDExICsxNTcsMjAgQEAgZHN0aGFz
aF9maW5kKGNvbnN0IHN0cnVjdCB4dF9oYXNobGltaXRfaAogLyogYWxsb2NhdGUgZHN0aGFzaF9l
bnQsIGluaXRpYWxpemUgZHN0LCBwdXQgaW4gaHRhYmxlIGFuZCBsb2NrIGl0ICovCiBzdGF0aWMg
c3RydWN0IGRzdGhhc2hfZW50ICoKIGRzdGhhc2hfYWxsb2NfaW5pdChzdHJ1Y3QgeHRfaGFzaGxp
bWl0X2h0YWJsZSAqaHQsCi0JCSAgIGNvbnN0IHN0cnVjdCBkc3RoYXNoX2RzdCAqZHN0KQorCQkg
ICBjb25zdCBzdHJ1Y3QgZHN0aGFzaF9kc3QgKmRzdCwKKwkJICAgYm9vbCAqbmV3X25vZGUpCiB7
CiAJc3RydWN0IGRzdGhhc2hfZW50ICplbnQ7CiAKIAlzcGluX2xvY2soJmh0LT5sb2NrKTsKKwor
CWVudCA9IGRzdGhhc2hfZmluZChodCwgZHN0KTsKKwlpZiAoZW50KSB7ICAgICAgICAKKwkJc3Bp
bl91bmxvY2soJmh0LT5sb2NrKTsKKwkJKm5ld19ub2RlID0gZmFsc2U7CisJCXJldHVybiBlbnQ7
CisJfQorCQogCS8qIGluaXRpYWxpemUgaGFzaCB3aXRoIHJhbmRvbSB2YWwgYXQgdGhlIHRpbWUg
d2UgYWxsb2NhdGUKIAkgKiB0aGUgZmlyc3QgaGFzaHRhYmxlIGVudHJ5ICovCiAJaWYgKHVubGlr
ZWx5KCFodC0+cm5kX2luaXRpYWxpemVkKSkgewpAQCAtMTg1LDYgKzE5NCw3IEBAIGRzdGhhc2hf
YWxsb2NfaW5pdChzdHJ1Y3QgeHRfaGFzaGxpbWl0X2gKIAkJaHQtPmNvdW50Kys7CiAJfQogCXNw
aW5fdW5sb2NrKCZodC0+bG9jayk7CisJKm5ld19ub2RlID0gdHJ1ZTsKIAlyZXR1cm4gZW50Owog
fQogCkBAIC01MTUsNiArNTI1LDcgQEAgaGFzaGxpbWl0X210KGNvbnN0IHN0cnVjdCBza19idWZm
ICpza2IsIAogCXVuc2lnbmVkIGxvbmcgbm93ID0gamlmZmllczsKIAlzdHJ1Y3QgZHN0aGFzaF9l
bnQgKmRoOwogCXN0cnVjdCBkc3RoYXNoX2RzdCBkc3Q7CisJYm9vbCBuZXdfbm9kZTsKIAogCWlm
IChoYXNobGltaXRfaW5pdF9kc3QoaGluZm8sICZkc3QsIHNrYiwgcGFyLT50aG9mZikgPCAwKQog
CQlnb3RvIGhvdGRyb3A7CkBAIC01MjIsMTEgKzUzMywxNiBAQCBoYXNobGltaXRfbXQoY29uc3Qg
c3RydWN0IHNrX2J1ZmYgKnNrYiwgCiAJcmN1X3JlYWRfbG9ja19iaCgpOwogCWRoID0gZHN0aGFz
aF9maW5kKGhpbmZvLCAmZHN0KTsKIAlpZiAoZGggPT0gTlVMTCkgewotCQlkaCA9IGRzdGhhc2hf
YWxsb2NfaW5pdChoaW5mbywgJmRzdCk7CisJCWRoID0gZHN0aGFzaF9hbGxvY19pbml0KGhpbmZv
LCAmZHN0LCAmbmV3X25vZGUpOwogCQlpZiAoZGggPT0gTlVMTCkgewogCQkJcmN1X3JlYWRfdW5s
b2NrX2JoKCk7CiAJCQlnb3RvIGhvdGRyb3A7CiAJCX0KKwl9IGVsc2UgeworCQluZXdfbm9kZSA9
IGZhbHNlOworCX0KKworCWlmIChuZXdfbm9kZSkgewogCQlkaC0+ZXhwaXJlcyA9IGppZmZpZXMg
KyBtc2Vjc190b19qaWZmaWVzKGhpbmZvLT5jZmcuZXhwaXJlKTsKIAkJZGgtPnJhdGVpbmZvLnBy
ZXYgPSBqaWZmaWVzOwogCQlkaC0+cmF0ZWluZm8uY3JlZGl0ID0gdXNlcjJjcmVkaXRzKGhpbmZv
LT5jZmcuYXZnICoKQEAgLTUzOSw3ICs1NTUsNyBAQCBoYXNobGltaXRfbXQoY29uc3Qgc3RydWN0
IHNrX2J1ZmYgKnNrYiwgCiAJCWRoLT5leHBpcmVzID0gbm93ICsgbXNlY3NfdG9famlmZmllcyho
aW5mby0+Y2ZnLmV4cGlyZSk7CiAJCXJhdGVpbmZvX3JlY2FsYyhkaCwgbm93KTsKIAl9Ci0KKwkK
IAlpZiAoZGgtPnJhdGVpbmZvLmNyZWRpdCA+PSBkaC0+cmF0ZWluZm8uY29zdCkgewogCQkvKiBi
ZWxvdyB0aGUgbGltaXQgKi8KIAkJZGgtPnJhdGVpbmZvLmNyZWRpdCAtPSBkaC0+cmF0ZWluZm8u
Y29zdDsK

--_004_160B5DCC41754649A37CE908E63173FCECF716SJMB02corpa10netw_--
