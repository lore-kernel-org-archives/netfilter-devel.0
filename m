From: "Hann-Huei Chiou" <koala@ascenvision.com>
Subject: [PATCH] Couldn't load/find match `u32'
Date: Fri, 28 Sep 2007 16:02:01 +0800
Message-ID: <20070928075459.M24408@ascenvision.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=OPENWEBMAIL_ATT_0.385969629511237"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from gateway1-2.ascenvision.com ([61.64.195.149]:3969 "EHLO
	mail.ascenvision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756746AbXI1JGl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Sep 2007 05:06:41 -0400
Received: from ascenvision.com (localhost [127.0.0.1])
	by mail.ascenvision.com (8.12.11/8.12.11) with ESMTP id l8S826wX026177
	for <netfilter-devel@vger.kernel.org>; Fri, 28 Sep 2007 16:02:06 +0800 (CST)
	(envelope-from koala@ascenvision.com)
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.

------=OPENWEBMAIL_ATT_0.385969629511237
Content-Type: text/plain;
	charset=iso-8859-1

Sorry if op, since I can't find list archives and can't connect
to bugzilla.

iptables (up to 0927 snapshot) keeps complaining of "Couldn't
load (or find, if NO_SHARED_LIBS=1) match `u32'. After comparing
with other libxt_*.c, I found that there's no member ".family"
in the "u32_reg" structure, while ".family = AF_INET6" exists
in "u32_reg6"

Patch is enclosed and attached.

Index: extensions/libxt_u32.c
===================================================================
--- extensions/libxt_u32.c	(revision 7050)
+++ extensions/libxt_u32.c	(working copy)
@@ -274,6 +274,7 @@
 
 static struct xtables_match u32_reg = {
 	.name          = "u32",
+	.family        = AF_INET,
 	.version       = IPTABLES_VERSION,
 	.size          = XT_ALIGN(sizeof(struct xt_u32)),
 	.userspacesize = XT_ALIGN(sizeof(struct xt_u32)),

------=OPENWEBMAIL_ATT_0.385969629511237
Content-Type: text/x-patch;
	name="u32.patch"
Content-Disposition: attachment; filename="u32.patch"
Content-Transfer-Encoding: base64

SW5kZXg6IGV4dGVuc2lvbnMvbGlieHRfdTMyLmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gZXh0ZW5zaW9ucy9s
aWJ4dF91MzIuYwkocmV2aXNpb24gNzA1MCkKKysrIGV4dGVuc2lvbnMvbGlieHRfdTMyLmMJKHdv
cmtpbmcgY29weSkKQEAgLTI3NCw2ICsyNzQsNyBAQAogCiBzdGF0aWMgc3RydWN0IHh0YWJsZXNf
bWF0Y2ggdTMyX3JlZyA9IHsKIAkubmFtZSAgICAgICAgICA9ICJ1MzIiLAorCS5mYW1pbHkgICAg
ICAgID0gQUZfSU5FVCwKIAkudmVyc2lvbiAgICAgICA9IElQVEFCTEVTX1ZFUlNJT04sCiAJLnNp
emUgICAgICAgICAgPSBYVF9BTElHTihzaXplb2Yoc3RydWN0IHh0X3UzMikpLAogCS51c2Vyc3Bh
Y2VzaXplID0gWFRfQUxJR04oc2l6ZW9mKHN0cnVjdCB4dF91MzIpKSwK

------=OPENWEBMAIL_ATT_0.385969629511237--
