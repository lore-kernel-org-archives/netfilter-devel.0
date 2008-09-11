From: Jan Engelhardt <jengelh@medozas.de>
Subject: 11/11 [NETFILTER]: Remove redundant casts from Ebtables extensions
Date: Wed, 10 Sep 2008 22:46:21 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0809102246080.8838@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0809102242180.8838@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36417 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbYIKCqW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Sep 2008 22:46:22 -0400
In-Reply-To: <alpine.LNX.1.10.0809102242180.8838@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 07f89c4687ada3347c454fc8ff2d078256019eb6
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Sep 10 22:39:32 2008 -0400

[NETFILTER]: Remove redundant casts from Ebtables extensions

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/bridge/netfilter/ebt_arpreply.c |    2 +-
 net/bridge/netfilter/ebt_ip6.c      |    4 ++--
 net/bridge/netfilter/ebt_limit.c    |    2 +-
 net/bridge/netfilter/ebt_nflog.c    |    4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/bridge/netfilter/ebt_arpreply.c b/net/bridge/netfilter/ebt_arpreply.c
index 8071b64..732a126 100644
--- a/net/bridge/netfilter/ebt_arpreply.c
+++ b/net/bridge/netfilter/ebt_arpreply.c
@@ -20,7 +20,7 @@ ebt_arpreply_tg(struct sk_buff *skb, const struct net_device *in,
 		const struct net_device *out, unsigned int hook_nr,
 		const struct xt_target *target, const void *data)
 {
-	struct ebt_arpreply_info *info = (void *)data;
+	struct ebt_arpreply_info *info = data;
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
index 43d9a50..e67b679 100644
--- a/net/bridge/netfilter/ebt_limit.c
+++ b/net/bridge/netfilter/ebt_limit.c
@@ -35,7 +35,7 @@ ebt_limit_mt(const struct sk_buff *skb, const struct net_device *in,
 	     const struct net_device *out, const struct xt_match *match,
 	     const void *data, int offset, unsigned int protoff, bool *hotdrop)
 {
-	struct ebt_limit_info *info = (struct ebt_limit_info *)data;
+	struct ebt_limit_info *info = data;
 	unsigned long now = jiffies;
 
 	spin_lock_bh(&limit_lock);
diff --git a/net/bridge/netfilter/ebt_nflog.c b/net/bridge/netfilter/ebt_nflog.c
index 917ac36..34bc619 100644
--- a/net/bridge/netfilter/ebt_nflog.c
+++ b/net/bridge/netfilter/ebt_nflog.c
@@ -24,7 +24,7 @@ ebt_nflog_tg(struct sk_buff *skb, const struct net_device *in,
 	     const struct net_device *out, unsigned int hooknr,
 	     const struct xt_target *target, const void *data)
 {
-	struct ebt_nflog_info *info = (struct ebt_nflog_info *)data;
+	struct ebt_nflog_info *info = data;
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
