From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] nefilter: eache: reduce struct size from 32 to 24 byte
Date: Tue, 18 Apr 2017 17:27:32 +0200
Message-ID: <20170418152732.19759-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:36804 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751032AbdDRP1P (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Apr 2017 11:27:15 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Only "cache" needs to use ulong (its used with set_bit()), missed can use
u16.  Also add build-time assertion to ensure event bits fit.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack_ecache.h        | 4 ++--
 include/uapi/linux/netfilter/nf_conntrack_common.h | 3 +++
 net/netfilter/nf_conntrack_ecache.c                | 3 +++
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/netfilter/nf_conntrack_ecache.h
index 12d967b58726..2a10c6570fcc 100644
--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -20,11 +20,11 @@ enum nf_ct_ecache_state {
 
 struct nf_conntrack_ecache {
 	unsigned long cache;		/* bitops want long */
-	unsigned long missed;		/* missed events */
+	u16 missed;			/* missed events */
 	u16 ctmask;			/* bitmask of ct events to be delivered */
 	u16 expmask;			/* bitmask of expect events to be delivered */
+	enum nf_ct_ecache_state state:8;/* ecache state */
 	u32 portid;			/* netlink portid of destroyer */
-	enum nf_ct_ecache_state state;	/* ecache state */
 };
 
 static inline struct nf_conntrack_ecache *
diff --git a/include/uapi/linux/netfilter/nf_conntrack_common.h b/include/uapi/linux/netfilter/nf_conntrack_common.h
index 6a8e33dd4ecb..8039d00d986b 100644
--- a/include/uapi/linux/netfilter/nf_conntrack_common.h
+++ b/include/uapi/linux/netfilter/nf_conntrack_common.h
@@ -117,6 +117,9 @@ enum ip_conntrack_events {
 	IPCT_NATSEQADJ = IPCT_SEQADJ,
 	IPCT_SECMARK,		/* new security mark has been set */
 	IPCT_LABEL,		/* new connlabel has been set */
+#ifdef __KERNEL__
+	__IPCT_MAX
+#endif
 };
 
 enum ip_conntrack_expect_events {
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 94b6c2e39346..757b60fc083e 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -434,6 +434,9 @@ int nf_conntrack_ecache_init(void)
 	int ret = nf_ct_extend_register(&event_extend);
 	if (ret < 0)
 		pr_err("nf_ct_event: Unable to register event extension.\n");
+
+	BUILD_BUG_ON(__IPCT_MAX >= 16);	/* ctmask, missed use u16 */
+
 	return ret;
 }
 
-- 
2.10.2

