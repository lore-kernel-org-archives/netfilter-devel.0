From: bloodman@gmail.com
Subject: xtables-addons: ipp2p: bittorrent commands patch
Date: Mon, 1 Feb 2010 05:39:45 +0100
Message-ID: <1356434297.20100201053945@gmail.com>
Reply-To: bloodman@gmail.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="----------ACAB653F6B2AD4"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:56449 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab0BAEju (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 31 Jan 2010 23:39:50 -0500
Received: by fxm20 with SMTP id 20so3836115fxm.21
        for <netfilter-devel@vger.kernel.org>; Sun, 31 Jan 2010 20:39:48 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

------------ACAB653F6B2AD4
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hello guys,

After testing I decide to write my patch to bittorrent
GET commands from xt_ipp2p.c because old procedure is
useless for modified and/or private trackers. teh new
works fine but maybe someone can rewrite it to better C
(yeah, im C/C++ n00b ;)
btw. info_hash may be 3rd argument, passkey (private trackers)
may be 1st argument (or not) etc. etc. so we need to search.


---
--- xtables-addons-1.22.old/extensions/xt_ipp2p.c       2010-01-22 20:14:37.000000000 +0100
+++ xtables-addons-1.22/extensions/xt_ipp2p.c   2010-01-26 06:05:47.000000000 +0100
@@ -505,19 +505,18 @@
  if (payload[0] == 0x13)
    if (memcmp(payload + 1, "BitTorrent protocol", 19) == 0)
      return IPP2P_BIT * 100;
-
    /*
-    * get tracker commandos, all starts with GET /
-    * then it can follow: scrape| announce
-    * and then ?hash_info=
+    * any tracker command starts with GET / then *may be* some file on web server
+    * (eg. announce.php or dupa.pl or whatever.cgi or NOTHING for tracker on root dir)
+    * but *must have* one (or more) of strings listed below (true for scrape and announce)
     */
    if (memcmp(payload, "GET /", 5) == 0) {
-     /* message scrape */
-     if (memcmp(payload + 5, "scrape?info_hash=", 17) == 0)
-       return IPP2P_BIT * 100 + 1;
-     /* message announce */
-     if (memcmp(payload + 5, "announce?info_hash=", 19) == 0)
-       return IPP2P_BIT * 100 + 2;
+     if(strstr(payload, "info_hash=") != NULL)
+       return IPP2P_BIT * 100 + 1;
+     if(strstr(payload, "peer_id=") != NULL)
+       return IPP2P_BIT * 100 + 2;
+     if(strstr(payload, "passkey=") != NULL)
+       return IPP2P_BIT * 100 + 4;
    }
  } else {
    /* bitcomet encryptes the first packet, so we have to detect another
---

-- 
Tomasz 'BloodMan' Tomkowiak
------------ACAB653F6B2AD4
Content-Type: APPLICATION/OCTET-STREAM;
 name="xt_ipp2p.patch"
Content-transfer-encoding: base64
Content-Disposition: attachment;
 filename="xt_ipp2p.patch"

LS0tIHh0YWJsZXMtYWRkb25zLTEuMjIub2xkL2V4dGVuc2lvbnMveHRfaXBwMnAuYwkyMDEw
LTAxLTIyIDIwOjE0OjM3LjAwMDAwMDAwMCArMDEwMAorKysgeHRhYmxlcy1hZGRvbnMtMS4y
Mi9leHRlbnNpb25zL3h0X2lwcDJwLmMJMjAxMC0wMS0yNiAwNjowNTo0Ny4wMDAwMDAwMDAg
KzAxMDAKQEAgLTUwNSwxOSArNTA1LDE4IEBACiAJCWlmIChwYXlsb2FkWzBdID09IDB4MTMp
CiAJCQlpZiAobWVtY21wKHBheWxvYWQgKyAxLCAiQml0VG9ycmVudCBwcm90b2NvbCIsIDE5
KSA9PSAwKQogCQkJCXJldHVybiBJUFAyUF9CSVQgKiAxMDA7Ci0KIAkJLyoKLQkJICogZ2V0
IHRyYWNrZXIgY29tbWFuZG9zLCBhbGwgc3RhcnRzIHdpdGggR0VUIC8KLQkJICogdGhlbiBp
dCBjYW4gZm9sbG93OiBzY3JhcGV8IGFubm91bmNlCi0JCSAqIGFuZCB0aGVuID9oYXNoX2lu
Zm89CisJCSAqIGFueSB0cmFja2VyIGNvbW1hbmQgc3RhcnRzIHdpdGggR0VUIC8gdGhlbiAq
bWF5IGJlKiBzb21lIGZpbGUgb24gd2ViIHNlcnZlcgorCQkgKiAoZWcuIGFubm91bmNlLnBo
cCBvciBkdXBhLnBsIG9yIHdoYXRldmVyLmNnaSBvciBOT1RISU5HIGZvciB0cmFja2VyIG9u
IHJvb3QgZGlyKQorCQkgKiBidXQgKm11c3QgaGF2ZSogb25lIChvciBtb3JlKSBvZiBzdHJp
bmdzIGxpc3RlZCBiZWxvdyAodHJ1ZSBmb3Igc2NyYXBlIGFuZCBhbm5vdW5jZSkKIAkJICov
CiAJCWlmIChtZW1jbXAocGF5bG9hZCwgIkdFVCAvIiwgNSkgPT0gMCkgewotCQkJLyogbWVz
c2FnZSBzY3JhcGUgKi8KLQkJCWlmIChtZW1jbXAocGF5bG9hZCArIDUsICJzY3JhcGU/aW5m
b19oYXNoPSIsIDE3KSA9PSAwKQotCQkJCXJldHVybiBJUFAyUF9CSVQgKiAxMDAgKyAxOwot
CQkJLyogbWVzc2FnZSBhbm5vdW5jZSAqLwotCQkJaWYgKG1lbWNtcChwYXlsb2FkICsgNSwg
ImFubm91bmNlP2luZm9faGFzaD0iLCAxOSkgPT0gMCkKLQkJCQlyZXR1cm4gSVBQMlBfQklU
ICogMTAwICsgMjsKKwkJCWlmKHN0cnN0cihwYXlsb2FkLCAiaW5mb19oYXNoPSIpICE9IE5V
TEwpCisJCQkgICAgcmV0dXJuIElQUDJQX0JJVCAqIDEwMCArIDE7CisJCQlpZihzdHJzdHIo
cGF5bG9hZCwgInBlZXJfaWQ9IikgIT0gTlVMTCkKKwkJCSAgICByZXR1cm4gSVBQMlBfQklU
ICogMTAwICsgMjsKKwkJCWlmKHN0cnN0cihwYXlsb2FkLCAicGFzc2tleT0iKSAhPSBOVUxM
KQorCQkJICAgIHJldHVybiBJUFAyUF9CSVQgKiAxMDAgKyA0OwogCQl9CiAJfSBlbHNlIHsK
IAkgICAgCS8qIGJpdGNvbWV0IGVuY3J5cHRlcyB0aGUgZmlyc3QgcGFja2V0LCBzbyB3ZSBo
YXZlIHRvIGRldGVjdCBhbm90aGVyCg==
------------ACAB653F6B2AD4--

