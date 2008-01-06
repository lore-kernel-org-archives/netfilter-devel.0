From: Peter Warasin <peter@endian.com>
Subject: [PATCH] Fix CONNMARK mask value demolition
Date: Sun, 06 Jan 2008 04:04:46 +0100
Message-ID: <4780454E.3050803@endian.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050309000908000901000106"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from solaria.endian.it ([80.190.199.145]:50969 "EHLO
	solaria.endian.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbYAFDaR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Jan 2008 22:30:17 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by solaria.endian.it (Postfix) with ESMTP id F29D8598323
	for <netfilter-devel@vger.kernel.org>; Sun,  6 Jan 2008 04:04:48 +0100 (CET)
Received: from solaria.endian.it ([127.0.0.1])
	by localhost (solaria.endian.it [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vq6NZ97i2cBH for <netfilter-devel@vger.kernel.org>;
	Sun,  6 Jan 2008 04:04:48 +0100 (CET)
Received: from [10.139.200.197] (host134-110-dynamic.5-87-r.retail.telecomitalia.it [87.5.110.134])
	by solaria.endian.it (Postfix) with ESMTP id 21AE6598320
	for <netfilter-devel@vger.kernel.org>; Sun,  6 Jan 2008 04:04:48 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050309000908000901000106
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

This patch fixes the problem that the CONNMARK mask value
has been set to 0 whenever the CONNMARK target options has not
been the last options to be processed.

Signed-off-by: Peter Warasin <peter@endian.com>

---


--------------050309000908000901000106
Content-Type: text/x-patch;
 name="fix_CONNMARK_mask_demolition.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fix_CONNMARK_mask_demolition.patch"

Index: iptables/extensions/libxt_CONNMARK.c
===================================================================
--- iptables.orig/extensions/libxt_CONNMARK.c	2008-01-06 03:08:18.000000000 +0100
+++ iptables/extensions/libxt_CONNMARK.c	2008-01-06 03:09:54.000000000 +0100
@@ -64,13 +64,12 @@
 	struct xt_connmark_target_info *markinfo
 		= (struct xt_connmark_target_info *)(*target)->data;
 
-	markinfo->mask = 0xffffffffUL;
-
 	switch (c) {
 		char *end;
 	case '1':
 		markinfo->mode = XT_CONNMARK_SET;
 
+		markinfo->mask = 0xffffffffUL;
 		markinfo->mark = strtoul(optarg, &end, 0);
 		if (*end == '/' && end[1] != '\0')
 		    markinfo->mask = strtoul(end+1, &end, 0);

--------------050309000908000901000106--
