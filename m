Return-Path: <SRS0=SfI0=TX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61C7EC282DD
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 May 2019 13:44:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37E7520881
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 May 2019 13:44:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730681AbfEWNoB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 May 2019 09:44:01 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:48846 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730549AbfEWNoA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 May 2019 09:44:00 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hTo0k-0007kJ-82; Thu, 23 May 2019 15:43:58 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH nf-next 8/8] netfilter: replace skb_make_writable with skb_ensure_writable
Date:   Thu, 23 May 2019 15:44:12 +0200
Message-Id: <20190523134412.3295-9-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523134412.3295-1-fw@strlen.de>
References: <20190523134412.3295-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This converts all remaining users and then removes skb_make_writable.

Suggested-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter.h        |  5 -----
 net/netfilter/core.c             | 22 ----------------------
 net/netfilter/nf_synproxy_core.c |  2 +-
 net/netfilter/nfnetlink_queue.c  |  2 +-
 net/netfilter/xt_DSCP.c          |  8 ++++----
 5 files changed, 6 insertions(+), 33 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 996bc247ef6e..049aeb40fa35 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -336,11 +336,6 @@ int compat_nf_getsockopt(struct sock *sk, u_int8_t pf, int optval,
 		char __user *opt, int *len);
 #endif
 
-/* Call this before modifying an existing packet: ensures it is
-   modifiable and linear to the point you care about (writable_len).
-   Returns true or false. */
-int skb_make_writable(struct sk_buff *skb, unsigned int writable_len);
-
 struct flowi;
 struct nf_queue_entry;
 
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index b96fd3f54705..817a9e5d16e4 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -536,28 +536,6 @@ int nf_hook_slow(struct sk_buff *skb, struct nf_hook_state *state,
 }
 EXPORT_SYMBOL(nf_hook_slow);
 
-
-int skb_make_writable(struct sk_buff *skb, unsigned int writable_len)
-{
-	if (writable_len > skb->len)
-		return 0;
-
-	/* Not exclusive use of packet?  Must copy. */
-	if (!skb_cloned(skb)) {
-		if (writable_len <= skb_headlen(skb))
-			return 1;
-	} else if (skb_clone_writable(skb, writable_len))
-		return 1;
-
-	if (writable_len <= skb_headlen(skb))
-		writable_len = 0;
-	else
-		writable_len -= skb_headlen(skb);
-
-	return !!__pskb_pull_tail(skb, writable_len);
-}
-EXPORT_SYMBOL(skb_make_writable);
-
 /* This needs to be compiled in any case to avoid dependencies between the
  * nfnetlink_queue code and nf_conntrack.
  */
diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index 8ff4d22f10b2..3d58a9e93e5a 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -196,7 +196,7 @@ unsigned int synproxy_tstamp_adjust(struct sk_buff *skb,
 	optoff = protoff + sizeof(struct tcphdr);
 	optend = protoff + th->doff * 4;
 
-	if (!skb_make_writable(skb, optend))
+	if (skb_ensure_writable(skb, optend))
 		return 0;
 
 	while (optoff < optend) {
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 27dac47b29c2..831f57008d78 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -863,7 +863,7 @@ nfqnl_mangle(void *data, int data_len, struct nf_queue_entry *e, int diff)
 		}
 		skb_put(e->skb, diff);
 	}
-	if (!skb_make_writable(e->skb, data_len))
+	if (skb_ensure_writable(e->skb, data_len))
 		return -ENOMEM;
 	skb_copy_to_linear_data(e->skb, data, data_len);
 	e->skb->ip_summed = CHECKSUM_NONE;
diff --git a/net/netfilter/xt_DSCP.c b/net/netfilter/xt_DSCP.c
index 098ed851b7a7..30d554d6c213 100644
--- a/net/netfilter/xt_DSCP.c
+++ b/net/netfilter/xt_DSCP.c
@@ -34,7 +34,7 @@ dscp_tg(struct sk_buff *skb, const struct xt_action_param *par)
 	u_int8_t dscp = ipv4_get_dsfield(ip_hdr(skb)) >> XT_DSCP_SHIFT;
 
 	if (dscp != dinfo->dscp) {
-		if (!skb_make_writable(skb, sizeof(struct iphdr)))
+		if (skb_ensure_writable(skb, sizeof(struct iphdr)))
 			return NF_DROP;
 
 		ipv4_change_dsfield(ip_hdr(skb),
@@ -52,7 +52,7 @@ dscp_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 	u_int8_t dscp = ipv6_get_dsfield(ipv6_hdr(skb)) >> XT_DSCP_SHIFT;
 
 	if (dscp != dinfo->dscp) {
-		if (!skb_make_writable(skb, sizeof(struct ipv6hdr)))
+		if (skb_ensure_writable(skb, sizeof(struct ipv6hdr)))
 			return NF_DROP;
 
 		ipv6_change_dsfield(ipv6_hdr(skb),
@@ -82,7 +82,7 @@ tos_tg(struct sk_buff *skb, const struct xt_action_param *par)
 	nv   = (orig & ~info->tos_mask) ^ info->tos_value;
 
 	if (orig != nv) {
-		if (!skb_make_writable(skb, sizeof(struct iphdr)))
+		if (skb_ensure_writable(skb, sizeof(struct iphdr)))
 			return NF_DROP;
 		iph = ip_hdr(skb);
 		ipv4_change_dsfield(iph, 0, nv);
@@ -102,7 +102,7 @@ tos_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 	nv   = (orig & ~info->tos_mask) ^ info->tos_value;
 
 	if (orig != nv) {
-		if (!skb_make_writable(skb, sizeof(struct iphdr)))
+		if (skb_ensure_writable(skb, sizeof(struct iphdr)))
 			return NF_DROP;
 		iph = ipv6_hdr(skb);
 		ipv6_change_dsfield(iph, 0, nv);
-- 
2.21.0

