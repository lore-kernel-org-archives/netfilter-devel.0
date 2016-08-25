From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v3 nf-next 7/7] netfilter: remove __nf_ct_kill_acct helper
Date: Thu, 25 Aug 2016 15:33:35 +0200
Message-ID: <1472132015-10264-8-git-send-email-fw@strlen.de>
References: <1472132015-10264-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:50006 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933975AbcHYNdt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Aug 2016 09:33:49 -0400
In-Reply-To: <1472132015-10264-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

After timer removal this just calls nf_ct_delete so remove the __ prefix
version and make nf_ct_kill a shorthand for nf_ct_delete.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack.h | 13 +++----------
 net/netfilter/nf_conntrack_core.c    | 12 +++++-------
 2 files changed, 8 insertions(+), 17 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 7277751..5041805 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -219,21 +219,14 @@ static inline void nf_ct_refresh(struct nf_conn *ct,
 	__nf_ct_refresh_acct(ct, 0, skb, extra_jiffies, 0);
 }
 
-bool __nf_ct_kill_acct(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
-		       const struct sk_buff *skb, int do_acct);
-
 /* kill conntrack and do accounting */
-static inline bool nf_ct_kill_acct(struct nf_conn *ct,
-				   enum ip_conntrack_info ctinfo,
-				   const struct sk_buff *skb)
-{
-	return __nf_ct_kill_acct(ct, ctinfo, skb, 1);
-}
+bool nf_ct_kill_acct(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
+		     const struct sk_buff *skb);
 
 /* kill conntrack without accounting */
 static inline bool nf_ct_kill(struct nf_conn *ct)
 {
-	return __nf_ct_kill_acct(ct, 0, NULL, 0);
+	return nf_ct_delete(ct, 0, 0);
 }
 
 /* These are for NAT.  Icky. */
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 7c66ce40..ac1db40 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1430,17 +1430,15 @@ acct:
 }
 EXPORT_SYMBOL_GPL(__nf_ct_refresh_acct);
 
-bool __nf_ct_kill_acct(struct nf_conn *ct,
-		       enum ip_conntrack_info ctinfo,
-		       const struct sk_buff *skb,
-		       int do_acct)
+bool nf_ct_kill_acct(struct nf_conn *ct,
+		     enum ip_conntrack_info ctinfo,
+		     const struct sk_buff *skb)
 {
-	if (do_acct)
-		nf_ct_acct_update(ct, ctinfo, skb->len);
+	nf_ct_acct_update(ct, ctinfo, skb->len);
 
 	return nf_ct_delete(ct, 0, 0);
 }
-EXPORT_SYMBOL_GPL(__nf_ct_kill_acct);
+EXPORT_SYMBOL_GPL(nf_ct_kill_acct);
 
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 
-- 
2.7.3

