From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/7] netfilter: xtables: reduce holes in struct xt_target
Date: Thu, 18 Mar 2010 15:09:46 +0100
Message-ID: <1268921390-30296-5-git-send-email-jengelh@medozas.de>
References: <1268921390-30296-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:37316 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753860Ab0CROJ5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Mar 2010 10:09:57 -0400
In-Reply-To: <1268921390-30296-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This will save one full padding chunk (8 bytes on x86_64) per target.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index cf91473..f8f5551 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -331,6 +331,7 @@ struct xt_target {
 	struct list_head list;
 
 	const char name[XT_FUNCTION_MAXNAMELEN-1];
+	u_int8_t revision;
 
 	/* Returns verdict. Argument order changed since 2.6.9, as this
 	   must now handle non-linear skbs, using skb_copy_bits and
@@ -363,7 +364,6 @@ struct xt_target {
 	unsigned short proto;
 
 	unsigned short family;
-	u_int8_t revision;
 };
 
 /* Furniture shopping... */
-- 
1.7.0.2

