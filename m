From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 55/64]: constify nf_afinfo
Date: Tue, 18 Dec 2007 00:47:28 +0100 (MET)
Message-ID: <20071217234727.23601.51358.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39052 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760395AbXLQXr3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:47:29 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: constify nf_afinfo

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 6ca04829cbe594b37035da22f809445c31d58f8a
tree 33d3630448c059efcf037bd0af8f5e1a662d4215
parent 50a04a644a2d717be1306a9b6121c12180b66dd1
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:58:48 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:24:59 +0100

 include/linux/netfilter.h              |   10 +++++-----
 net/ipv4/netfilter.c                   |    2 +-
 net/ipv6/netfilter.c                   |    2 +-
 net/netfilter/core.c                   |    6 +++---
 net/netfilter/nf_conntrack_h323_main.c |    2 +-
 net/netfilter/nf_queue.c               |    4 ++--
 6 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index bd4a2dd..0947424 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -226,8 +226,8 @@ struct nf_afinfo {
 	int		route_key_size;
 };
 
-extern struct nf_afinfo *nf_afinfo[];
-static inline struct nf_afinfo *nf_get_afinfo(unsigned short family)
+extern const struct nf_afinfo *nf_afinfo[NPROTO];
+static inline const struct nf_afinfo *nf_get_afinfo(unsigned short family)
 {
 	return rcu_dereference(nf_afinfo[family]);
 }
@@ -236,7 +236,7 @@ static inline __sum16
 nf_checksum(struct sk_buff *skb, unsigned int hook, unsigned int dataoff,
 	    u_int8_t protocol, unsigned short family)
 {
-	struct nf_afinfo *afinfo;
+	const struct nf_afinfo *afinfo;
 	__sum16 csum = 0;
 
 	rcu_read_lock();
@@ -247,8 +247,8 @@ nf_checksum(struct sk_buff *skb, unsigned int hook, unsigned int dataoff,
 	return csum;
 }
 
-extern int nf_register_afinfo(struct nf_afinfo *afinfo);
-extern void nf_unregister_afinfo(struct nf_afinfo *afinfo);
+extern int nf_register_afinfo(const struct nf_afinfo *afinfo);
+extern void nf_unregister_afinfo(const struct nf_afinfo *afinfo);
 
 #include <net/flow.h>
 extern void (*ip_nat_decode_session)(struct sk_buff *, struct flowi *);
diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
index 7bf5e4a..4011f8f 100644
--- a/net/ipv4/netfilter.c
+++ b/net/ipv4/netfilter.c
@@ -190,7 +190,7 @@ static int nf_ip_route(struct dst_entry **dst, struct flowi *fl)
 	return ip_route_output_key((struct rtable **)dst, fl);
 }
 
-static struct nf_afinfo nf_ip_afinfo = {
+static const struct nf_afinfo nf_ip_afinfo = {
 	.family		= AF_INET,
 	.checksum	= nf_ip_checksum,
 	.route		= nf_ip_route,
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 945e6ae..2e06724 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -124,7 +124,7 @@ __sum16 nf_ip6_checksum(struct sk_buff *skb, unsigned int hook,
 
 EXPORT_SYMBOL(nf_ip6_checksum);
 
-static struct nf_afinfo nf_ip6_afinfo = {
+static const struct nf_afinfo nf_ip6_afinfo = {
 	.family		= AF_INET6,
 	.checksum	= nf_ip6_checksum,
 	.route		= nf_ip6_route,
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 95e1863..e026344 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -26,10 +26,10 @@
 
 static DEFINE_MUTEX(afinfo_mutex);
 
-struct nf_afinfo *nf_afinfo[NPROTO] __read_mostly;
+const struct nf_afinfo *nf_afinfo[NPROTO] __read_mostly;
 EXPORT_SYMBOL(nf_afinfo);
 
-int nf_register_afinfo(struct nf_afinfo *afinfo)
+int nf_register_afinfo(const struct nf_afinfo *afinfo)
 {
 	int err;
 
@@ -42,7 +42,7 @@ int nf_register_afinfo(struct nf_afinfo *afinfo)
 }
 EXPORT_SYMBOL_GPL(nf_register_afinfo);
 
-void nf_unregister_afinfo(struct nf_afinfo *afinfo)
+void nf_unregister_afinfo(const struct nf_afinfo *afinfo)
 {
 	mutex_lock(&afinfo_mutex);
 	rcu_assign_pointer(nf_afinfo[afinfo->family], NULL);
diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index c550257..b636ca6 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -708,7 +708,7 @@ static int callforward_do_filter(union nf_conntrack_address *src,
 				 union nf_conntrack_address *dst,
 				 int family)
 {
-	struct nf_afinfo *afinfo;
+	const struct nf_afinfo *afinfo;
 	struct flowi fl1, fl2;
 	int ret = 0;
 
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 7796511..bfc2928 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -119,7 +119,7 @@ static int __nf_queue(struct sk_buff *skb,
 	struct net_device *physindev;
 	struct net_device *physoutdev;
 #endif
-	struct nf_afinfo *afinfo;
+	const struct nf_afinfo *afinfo;
 	const struct nf_queue_handler *qh;
 
 	/* QUEUE == DROP if noone is waiting, to be safe. */
@@ -233,7 +233,7 @@ void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 {
 	struct sk_buff *skb = entry->skb;
 	struct list_head *elem = &entry->elem->list;
-	struct nf_afinfo *afinfo;
+	const struct nf_afinfo *afinfo;
 
 	rcu_read_lock();
 
