From: Florian Westphal <fw@strlen.de>
Subject: [PATCH next] netfilter: xt_hashlimit: use _ALL macro to reject unknown flag bits
Date: Fri, 11 May 2012 10:11:54 +0200
Message-ID: <1336723914-3074-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:60108 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751952Ab2EKIKA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 May 2012 04:10:00 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

David Miller says:
     The canonical way to validate if the set bits are in a valid
     range is to have a "_ALL" macro, and test:
     if (val & ~XT_HASHLIMIT_ALL)
         goto err;"

make it so.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter/xt_hashlimit.h |    6 ++++--
 net/netfilter/xt_hashlimit.c           |    2 +-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/linux/netfilter/xt_hashlimit.h b/include/linux/netfilter/xt_hashlimit.h
index 05fe799..c42e52f 100644
--- a/include/linux/netfilter/xt_hashlimit.h
+++ b/include/linux/netfilter/xt_hashlimit.h
@@ -22,10 +22,12 @@ enum {
 	XT_HASHLIMIT_HASH_SPT = 1 << 3,
 	XT_HASHLIMIT_INVERT   = 1 << 4,
 	XT_HASHLIMIT_BYTES    = 1 << 5,
+};
 #ifdef __KERNEL__
-	XT_HASHLIMIT_MAX      = 1 << 6,
+#define XT_HASHLIMIT_ALL (XT_HASHLIMIT_HASH_DIP | XT_HASHLIMIT_HASH_DPT | \
+			  XT_HASHLIMIT_HASH_SIP | XT_HASHLIMIT_HASH_SPT | \
+			  XT_HASHLIMIT_INVERT | XT_HASHLIMIT_BYTES)
 #endif
-};
 
 struct hashlimit_cfg {
 	__u32 mode;	  /* bitmask of XT_HASHLIMIT_HASH_* */
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index d0424f9..f0e8839 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -648,7 +648,7 @@ static int hashlimit_mt_check(const struct xt_mtchk_param *par)
 			return -EINVAL;
 	}
 
-	if (info->cfg.mode >= XT_HASHLIMIT_MAX) {
+	if (info->cfg.mode & ~XT_HASHLIMIT_ALL) {
 		pr_info("Unknown mode mask %X, kernel too old?\n",
 						info->cfg.mode);
 		return -EINVAL;
-- 
1.7.3.4

