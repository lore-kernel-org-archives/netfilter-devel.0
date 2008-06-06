From: Lutz Jaenicke <ljaenicke@innominate.com>
Subject: Resend: [PATCH] Fix iptables-save output of libxt_owner match
Date: Fri, 6 Jun 2008 13:42:15 +0200
Message-ID: <20080606114215.GA4474@innominate.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="gBBFr7Ir9EOA20Yy"
Content-Transfer-Encoding: 8bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.innominate.com ([77.245.32.75]:55055 "EHLO
	home.innominate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405AbYFFLyH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jun 2008 07:54:07 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by home.innominate.com (Postfix) with ESMTP id BD63323141
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Jun 2008 13:42:17 +0200 (CEST)
Received: from home.innominate.com ([127.0.0.1])
	by localhost (localhost.localdomain [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id d4a2twyCRI3s for <netfilter-devel@vger.kernel.org>;
	Fri,  6 Jun 2008 13:42:17 +0200 (CEST)
Received: from lutz.bln.innominate.local (gw-dev-ext.bln.innominate.local [10.10.0.1])
	by home.innominate.com (Postfix) with ESMTP id 336102312D
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Jun 2008 13:42:17 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi,

please find attached the re-post of a patch wrt iptables-save output
of xt_owner patch.

Best regards,
	Lutz
-- 
Dr.-Ing. Lutz Jänicke
CTO
Innominate Security Technologies AG  /protecting industrial networks/
tel: +49.30.6392-3308
fax: +49.30.6392-3307
Albert-Einstein-Str. 14
D-12489 Berlin, Germany
www.innominate.com

Register Court: AG Charlottenburg, HR B 81603
Management Board: Dirk Seewald
Chairman of the Supervisory Board: Volker Bibelhausen

--gBBFr7Ir9EOA20Yy
Content-Type: message/rfc822
Content-Disposition: inline

Return-Path: <ljaenicke@devpad>
X-Original-To: ljaenicke@innominate.com
Delivered-To: ljaenicke@innominate.com
Received: from home.bln.innominate.local [10.10.0.240]
	by localhost with IMAP (fetchmail-6.2.5)
	for ljaenicke@localhost (single-drop); Tue, 27 May 2008 09:37:26 +0200 (CEST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by home.innominate.com (Postfix) with ESMTP id 350CA232ED;
	Tue, 27 May 2008 09:35:51 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at innominate.com
Received: from home.innominate.com ([127.0.0.1])
	by localhost (localhost.localdomain [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zd5Rohd9bYzh; Tue, 27 May 2008 09:35:51 +0200 (CEST)
Received: from devpad (gw-dev-ext.bln.innominate.local [10.10.0.1])
	by home.innominate.com (Postfix) with ESMTP id DFEA623121;
	Tue, 27 May 2008 09:35:50 +0200 (CEST)
Received: by devpad (Postfix, from userid 1001)
	id 87B6D88102; Tue, 27 May 2008 09:35:49 +0200 (CEST)
From: Lutz Jaenicke <ljaenicke@innominate.com>
To: netfilter-devel@vger.kernel.org
Cc: Lutz Jaenicke <ljaenicke@innominate.com>
Subject: [PATCH] Fix iptables-save output of libxt_owner match
Date: Tue, 27 May 2008 09:35:50 +0200
Message-Id: <1211873750-16590-1-git-send-email-ljaenicke@innominate.com>
X-Mailer: git-send-email 1.5.5.GIT

The _save functions need to use the same syntax that is used for parsing
the input instead of "user readable" output.
---
 extensions/libxt_owner.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/extensions/libxt_owner.c b/extensions/libxt_owner.c
index 85c9602..55666e9 100644
--- a/extensions/libxt_owner.c
+++ b/extensions/libxt_owner.c
@@ -498,12 +498,12 @@ owner_mt_save_v0(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_owner_info *info = (void *)match->data;
 
-	owner_mt_print_item_v0(info, "owner UID match ", IPT_OWNER_UID, true);
-	owner_mt_print_item_v0(info, "owner GID match ", IPT_OWNER_GID, true);
-	owner_mt_print_item_v0(info, "owner PID match ", IPT_OWNER_PID, true);
-	owner_mt_print_item_v0(info, "owner SID match ", IPT_OWNER_SID, true);
+	owner_mt_print_item_v0(info, "--uid-owner ", IPT_OWNER_UID, true);
+	owner_mt_print_item_v0(info, "--gid-owner ", IPT_OWNER_GID, true);
+	owner_mt_print_item_v0(info, "--pid-owner ", IPT_OWNER_PID, true);
+	owner_mt_print_item_v0(info, "--sid-owner ", IPT_OWNER_SID, true);
 #ifdef IPT_OWNER_COMM
-	owner_mt_print_item_v0(info, "owner CMD match ", IPT_OWNER_COMM, true);
+	owner_mt_print_item_v0(info, "--cmd-owner ", IPT_OWNER_COMM, true);
 #endif
 }
 
@@ -512,10 +512,10 @@ owner_mt6_save_v0(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ip6t_owner_info *info = (void *)match->data;
 
-	owner_mt6_print_item_v0(info, "owner UID match ", IPT_OWNER_UID, true);
-	owner_mt6_print_item_v0(info, "owner GID match ", IPT_OWNER_GID, true);
-	owner_mt6_print_item_v0(info, "owner PID match ", IPT_OWNER_PID, true);
-	owner_mt6_print_item_v0(info, "owner SID match ", IPT_OWNER_SID, true);
+	owner_mt6_print_item_v0(info, "--uid-owner ", IPT_OWNER_UID, true);
+	owner_mt6_print_item_v0(info, "--gid-owner ", IPT_OWNER_GID, true);
+	owner_mt6_print_item_v0(info, "--pid-owner ", IPT_OWNER_PID, true);
+	owner_mt6_print_item_v0(info, "--sid-owner ", IPT_OWNER_SID, true);
 }
 
 static void owner_mt_save(const void *ip, const struct xt_entry_match *match)
-- 
1.5.5.GIT


--gBBFr7Ir9EOA20Yy--
