Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A543C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Oct 2021 15:16:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D8FF60EE9
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Oct 2021 15:16:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234741AbhJKPSn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Oct 2021 11:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233712AbhJKPSm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Oct 2021 11:18:42 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA753C06161C
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Oct 2021 08:16:42 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mZx2f-0001r0-7q; Mon, 11 Oct 2021 17:16:41 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/4] netfilter: arp_tables: allow use of arpt_do_table as hookfn
Date:   Mon, 11 Oct 2021 17:15:12 +0200
Message-Id: <20211011151514.6580-4-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211011151514.6580-1-fw@strlen.de>
References: <20211011151514.6580-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is possible now that the xt_table structure is passed in via *priv.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter_arp/arp_tables.h |  5 ++---
 net/ipv4/netfilter/arp_tables.c          |  7 ++++---
 net/ipv4/netfilter/arptable_filter.c     | 10 +---------
 3 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
index 4f9a4b3c5892..a40aaf645fa4 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -54,9 +54,8 @@ int arpt_register_table(struct net *net, const struct xt_table *table,
 			const struct nf_hook_ops *ops);
 void arpt_unregister_table(struct net *net, const char *name);
 void arpt_unregister_table_pre_exit(struct net *net, const char *name);
-extern unsigned int arpt_do_table(struct sk_buff *skb,
-				  const struct nf_hook_state *state,
-				  struct xt_table *table);
+extern unsigned int arpt_do_table(void *priv, struct sk_buff *skb,
+				  const struct nf_hook_state *state);
 
 #ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 #include <net/compat.h>
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index c53f14b94356..ffc0cab7cf18 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -179,10 +179,11 @@ struct arpt_entry *arpt_next_entry(const struct arpt_entry *entry)
 	return (void *)entry + entry->next_offset;
 }
 
-unsigned int arpt_do_table(struct sk_buff *skb,
-			   const struct nf_hook_state *state,
-			   struct xt_table *table)
+unsigned int arpt_do_table(void *priv,
+			   struct sk_buff *skb,
+			   const struct nf_hook_state *state)
 {
+	const struct xt_table *table = priv;
 	unsigned int hook = state->hook;
 	static const char nulldevname[IFNAMSIZ] __attribute__((aligned(sizeof(long))));
 	unsigned int verdict = NF_DROP;
diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index 3de78416ec76..78cd5ee24448 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -26,14 +26,6 @@ static const struct xt_table packet_filter = {
 	.priority	= NF_IP_PRI_FILTER,
 };
 
-/* The work comes in here from netfilter.c */
-static unsigned int
-arptable_filter_hook(void *priv, struct sk_buff *skb,
-		     const struct nf_hook_state *state)
-{
-	return arpt_do_table(skb, state, priv);
-}
-
 static struct nf_hook_ops *arpfilter_ops __read_mostly;
 
 static int arptable_filter_table_init(struct net *net)
@@ -72,7 +64,7 @@ static int __init arptable_filter_init(void)
 	if (ret < 0)
 		return ret;
 
-	arpfilter_ops = xt_hook_ops_alloc(&packet_filter, arptable_filter_hook);
+	arpfilter_ops = xt_hook_ops_alloc(&packet_filter, arpt_do_table);
 	if (IS_ERR(arpfilter_ops)) {
 		xt_unregister_template(&packet_filter);
 		return PTR_ERR(arpfilter_ops);
-- 
2.32.0

