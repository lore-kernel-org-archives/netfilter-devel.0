From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 10/19]: nf_conntrack: kill unique ID
Date: Fri, 28 Sep 2007 18:30:51 +0200 (MEST)
Message-ID: <20070928163051.8394.70580.sendpatchset@localhost.localdomain>
References: <20070928163036.8394.36374.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55950 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758998AbXI1Qaw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Sep 2007 12:30:52 -0400
In-Reply-To: <20070928163036.8394.36374.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: nf_conntrack: kill unique ID

Remove the per-conntrack ID, its not necessary anymore for dumping.
For compatiblity reasons we send the address of the conntrack to
userspace as ID.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 02887778f4c84cff4b5d5526307552bda8673e2a
tree c47227f9ebbe036489392d2beab8be262835a963
parent 3dd95b7cdecd16519f2e76e2439953d6b50330c3
author Patrick McHardy <kaber@trash.net> Fri, 28 Sep 2007 18:09:16 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 28 Sep 2007 18:09:16 +0200

 include/net/netfilter/nf_conntrack.h |    3 ---
 net/netfilter/nf_conntrack_core.c    |    2 --
 net/netfilter/nf_conntrack_netlink.c |    4 ++--
 3 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 810020e..90fb66d 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -116,9 +116,6 @@ struct nf_conn
 	struct ip_conntrack_counter counters[IP_CT_DIR_MAX];
 #endif
 
-	/* Unique ID that identifies this conntrack*/
-	unsigned int id;
-
 #if defined(CONFIG_NF_CONNTRACK_MARK)
 	u_int32_t mark;
 #endif
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index f9d36ca..83c30b4 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -63,7 +63,6 @@ unsigned int nf_ct_log_invalid __read_mostly;
 HLIST_HEAD(unconfirmed);
 static int nf_conntrack_vmalloc __read_mostly;
 static struct kmem_cache *nf_conntrack_cachep __read_mostly;
-static unsigned int nf_conntrack_next_id;
 
 DEFINE_PER_CPU(struct ip_conntrack_stat, nf_conntrack_stat);
 EXPORT_PER_CPU_SYMBOL(nf_conntrack_stat);
@@ -287,7 +286,6 @@ static void __nf_conntrack_hash_insert(struct nf_conn *ct,
 				       unsigned int hash,
 				       unsigned int repl_hash)
 {
-	ct->id = ++nf_conntrack_next_id;
 	hlist_add_head(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnode,
 		       &nf_conntrack_hash[hash]);
 	hlist_add_head(&ct->tuplehash[IP_CT_DIR_REPLY].hnode,
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index ce35812..8406aee 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -257,7 +257,7 @@ nla_put_failure:
 static inline int
 ctnetlink_dump_id(struct sk_buff *skb, const struct nf_conn *ct)
 {
-	__be32 id = htonl(ct->id);
+	__be32 id = htonl((unsigned long)ct);
 	NLA_PUT(skb, CTA_ID, sizeof(u_int32_t), &id);
 	return 0;
 
@@ -723,7 +723,7 @@ ctnetlink_del_conntrack(struct sock *ctnl, struct sk_buff *skb,
 
 	if (cda[CTA_ID]) {
 		u_int32_t id = ntohl(*(__be32 *)nla_data(cda[CTA_ID]));
-		if (ct->id != id) {
+		if (id != (u32)(unsigned long)ct) {
 			nf_ct_put(ct);
 			return -ENOENT;
 		}
