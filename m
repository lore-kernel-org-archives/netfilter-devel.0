From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/3] libxt_devgroup: option whitespace update following v1.4.10-49-g7386635
Date: Wed, 16 Feb 2011 03:18:55 +0100
Message-ID: <1297822737-11204-3-git-send-email-jengelh@medozas.de>
References: <1297822737-11204-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:36204 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756488Ab1BPCTB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Feb 2011 21:19:01 -0500
In-Reply-To: <1297822737-11204-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_devgroup.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/extensions/libxt_devgroup.c b/extensions/libxt_devgroup.c
index 893a2fa..2624868 100644
--- a/extensions/libxt_devgroup.c
+++ b/extensions/libxt_devgroup.c
@@ -225,14 +225,14 @@ print_devgroup(unsigned int id, unsigned int mask, int numeric)
 	const char *name = NULL;
 
 	if (mask != 0xffffffff)
-		printf("0x%x/0x%x ", id, mask);
+		printf("0x%x/0x%x", id, mask);
 	else {
 		if (numeric == 0)
 			name = devgroup_id2name(id);
 		if (name)
-			printf("%s ", name);
+			printf("%s", name);
 		else
-			printf("0x%x ", id);
+			printf("0x%x", id);
 	}
 }
 
@@ -241,15 +241,15 @@ static void devgroup_show(const char *pfx, const struct xt_devgroup_info *info,
 {
 	if (info->flags & XT_DEVGROUP_MATCH_SRC) {
 		if (info->flags & XT_DEVGROUP_INVERT_SRC)
-			printf("! ");
-		printf("%ssrc-group ", pfx);
+			printf(" !");
+		printf(" %ssrc-group ", pfx);
 		print_devgroup(info->src_group, info->src_mask, numeric);
 	}
 
 	if (info->flags & XT_DEVGROUP_MATCH_DST) {
 		if (info->flags & XT_DEVGROUP_INVERT_DST)
-			printf("! ");
-		printf("%sdst-group ", pfx);
+			printf(" !");
+		printf(" %sdst-group ", pfx);
 		print_devgroup(info->src_group, info->src_mask, numeric);
 	}
 }
-- 
1.7.1

