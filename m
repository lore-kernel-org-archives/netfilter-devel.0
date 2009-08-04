From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 070/103] netfilter: xtables: use compat_u64 inside struct compat_xt_counters
Date: Tue,  4 Aug 2009 09:25:54 +0200
Message-ID: <1249370787-17583-71-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56949 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932600AbZHDH1s (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:27:48 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It is better for the xt1_perproto.c "template" code when the fields
have the same name as struct xt_counters. To that end, we can just
use compat_u64 instead of having to hack with uint32_t.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index dda97db..7e88120 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -856,11 +856,7 @@ struct compat_xt_entry_target
 
 struct compat_xt_counters
 {
-#if defined(CONFIG_X86_64) || defined(CONFIG_IA64)
-	u_int32_t cnt[4];
-#else
-	u_int64_t cnt[2];
-#endif
+	compat_u64 bcnt, pcnt;
 };
 
 struct compat_xt_counters_info
-- 
1.6.3.3

