From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 62/79: remove redundant casts from Ebtables
Date: Wed,  8 Oct 2008 12:47:44 +0200 (MEST)
Message-ID: <20081008104744.10423.87876.sendpatchset@x2.localnet>
References: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46051 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788AbYJHKrq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 06:47:46 -0400
In-Reply-To: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit f7277f8d3aa4d3f99a9bdb48b27a2344a637a4b2
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Oct 8 11:35:16 2008 +0200

    netfilter: remove redundant casts from Ebtables
    
    Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/bridge/netfilter/ebt_arpreply.c b/net/bridge/netfilter/ebt_arpreply.c
index 0e51c8d..baf5510 100644
--- a/net/bridge/netfilter/ebt_arpreply.c
+++ b/net/bridge/netfilter/ebt_arpreply.c
@@ -20,7 +20,7 @@ ebt_arpreply_tg(struct sk_buff *skb, const struct net_device *in,
 		const struct net_device *out, unsigned int hook_nr,
 		const struct xt_target *target, const void *data)
 {
-	struct ebt_arpreply_info *info = (void *)data;
+	const struct ebt_arpreply_info *info = data;
 	const __be32 *siptr, *diptr;
 	__be32 _sip, _dip;
 	const struct arphdr *ap;
diff --git a/net/bridge/netfilter/ebt_ip6.c b/net/bridge/netfilter/ebt_ip6.c
index 317e624..7bd9831 100644
--- a/net/bridge/netfilter/ebt_ip6.c
+++ b/net/bridge/netfilter/ebt_ip6.c
@@ -32,7 +32,7 @@ ebt_ip6_mt(const struct sk_buff *skb, const struct net_device *in,
 	   const struct net_device *out, const struct xt_match *match,
 	   const void *data, int offset, unsigned int protoff, bool *hotdrop)
 {
-	const struct ebt_ip6_info *info = (struct ebt_ip6_info *)data;
+	const struct ebt_ip6_info *info = data;
 	const struct ipv6hdr *ih6;
 	struct ipv6hdr _ip6h;
 	const struct tcpudphdr *pptr;
@@ -98,7 +98,7 @@ ebt_ip6_mt_check(const char *table, const void *entry,
 		 unsigned int hook_mask)
 {
 	const struct ebt_entry *e = entry;
-	struct ebt_ip6_info *info = (struct ebt_ip6_info *)data;
+	struct ebt_ip6_info *info = data;
 
 	if (e->ethproto != htons(ETH_P_IPV6) || e->invflags & EBT_IPROTO)
 		return false;
diff --git a/net/bridge/netfilter/ebt_limit.c b/net/bridge/netfilter/ebt_limit.c
index 43d9a50..58aaaa1 100644
--- a/net/bridge/netfilter/ebt_limit.c
+++ b/net/bridge/netfilter/ebt_limit.c
@@ -35,7 +35,7 @@ ebt_limit_mt(const struct sk_buff *skb, const struct net_device *in,
 	     const struct net_device *out, const struct xt_match *match,
 	     const void *data, int offset, unsigned int protoff, bool *hotdrop)
 {
-	struct ebt_limit_info *info = (struct ebt_limit_info *)data;
+	struct ebt_limit_info *info = (void *)data;
 	unsigned long now = jiffies;
 
 	spin_lock_bh(&limit_lock);
diff --git a/net/bridge/netfilter/ebt_nflog.c b/net/bridge/netfilter/ebt_nflog.c
index 917ac36..74b4fa0 100644
--- a/net/bridge/netfilter/ebt_nflog.c
+++ b/net/bridge/netfilter/ebt_nflog.c
@@ -24,7 +24,7 @@ ebt_nflog_tg(struct sk_buff *skb, const struct net_device *in,
 	     const struct net_device *out, unsigned int hooknr,
 	     const struct xt_target *target, const void *data)
 {
-	struct ebt_nflog_info *info = (struct ebt_nflog_info *)data;
+	const struct ebt_nflog_info *info = data;
 	struct nf_loginfo li;
 
 	li.type = NF_LOG_TYPE_ULOG;
@@ -41,7 +41,7 @@ ebt_nflog_tg_check(const char *table, const void *e,
 		   const struct xt_target *target, void *data,
 		   unsigned int hookmask)
 {
-	struct ebt_nflog_info *info = (struct ebt_nflog_info *)data;
+	struct ebt_nflog_info *info = data;
 
 	if (info->flags & ~EBT_NFLOG_MASK)
 		return false;
