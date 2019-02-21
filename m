Return-Path: <SRS0=37uZ=Q4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09DD6C43381
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Feb 2019 14:54:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7FEF2075A
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Feb 2019 14:54:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727525AbfBUOy1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Feb 2019 09:54:27 -0500
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:49410 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726155AbfBUOy1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Feb 2019 09:54:27 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1gwpk1-0008Qa-4e; Thu, 21 Feb 2019 15:54:25 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: conntrack: avoid same-timeout update
Date:   Thu, 21 Feb 2019 15:38:29 +0100
Message-Id: <20190221143829.7252-1-fw@strlen.de>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

No need to dirty a cache line if timeout is unchanged.
Also, WARN() is useless here: we crash on 'skb->len' access
if skb is NULL.

Last, ct->timeout is u32, not 'unsigned long' so adapt the
function prototype accordingly.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack.h | 10 +++++-----
 net/netfilter/nf_conntrack_core.c    |  9 ++++-----
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index b5aac5ae5129..2270ee5202e3 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -190,23 +190,23 @@ bool nf_ct_get_tuplepr(const struct sk_buff *skb, unsigned int nhoff,
 
 void __nf_ct_refresh_acct(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
 			  const struct sk_buff *skb,
-			  unsigned long extra_jiffies, int do_acct);
+			  u32, bool do_acct);
 
 /* Refresh conntrack for this many jiffies and do accounting */
 static inline void nf_ct_refresh_acct(struct nf_conn *ct,
 				      enum ip_conntrack_info ctinfo,
 				      const struct sk_buff *skb,
-				      unsigned long extra_jiffies)
+				      u32 extra_jiffies)
 {
-	__nf_ct_refresh_acct(ct, ctinfo, skb, extra_jiffies, 1);
+	__nf_ct_refresh_acct(ct, ctinfo, skb, extra_jiffies, true);
 }
 
 /* Refresh conntrack for this many jiffies */
 static inline void nf_ct_refresh(struct nf_conn *ct,
 				 const struct sk_buff *skb,
-				 unsigned long extra_jiffies)
+				 u32 extra_jiffies)
 {
-	__nf_ct_refresh_acct(ct, 0, skb, extra_jiffies, 0);
+	__nf_ct_refresh_acct(ct, 0, skb, extra_jiffies, false);
 }
 
 /* kill conntrack and do accounting */
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index e139c256e269..a6488d53b7d3 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1752,11 +1752,9 @@ EXPORT_SYMBOL_GPL(nf_conntrack_alter_reply);
 void __nf_ct_refresh_acct(struct nf_conn *ct,
 			  enum ip_conntrack_info ctinfo,
 			  const struct sk_buff *skb,
-			  unsigned long extra_jiffies,
-			  int do_acct)
+			  u32 extra_jiffies,
+			  bool do_acct)
 {
-	WARN_ON(!skb);
-
 	/* Only update if this is not a fixed timeout */
 	if (test_bit(IPS_FIXED_TIMEOUT_BIT, &ct->status))
 		goto acct;
@@ -1765,7 +1763,8 @@ void __nf_ct_refresh_acct(struct nf_conn *ct,
 	if (nf_ct_is_confirmed(ct))
 		extra_jiffies += nfct_time_stamp;
 
-	ct->timeout = extra_jiffies;
+	if (ct->timeout != extra_jiffies)
+		ct->timeout = extra_jiffies;
 acct:
 	if (do_acct)
 		nf_ct_acct_update(ct, ctinfo, skb->len);
-- 
2.19.2

