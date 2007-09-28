From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 11/19]: nf_conntrack_expect: kill unique ID
Date: Fri, 28 Sep 2007 18:30:52 +0200 (MEST)
Message-ID: <20070928163052.8394.76353.sendpatchset@localhost.localdomain>
References: <20070928163036.8394.36374.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55953 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758972AbXI1Qay (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Sep 2007 12:30:54 -0400
In-Reply-To: <20070928163036.8394.36374.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: nf_conntrack_expect: kill unique ID

Similar to the conntrack ID, the per-expectation ID is not needed anymore,
kill it.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit e4c32368714870c516b5ec7abbb22c1fe8a80feb
tree 16e24d94bfa360db24e731c17ed6970070cd1c1b
parent 02887778f4c84cff4b5d5526307552bda8673e2a
author Patrick McHardy <kaber@trash.net> Fri, 28 Sep 2007 18:09:16 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 28 Sep 2007 18:09:16 +0200

 include/net/netfilter/nf_conntrack_expect.h |    3 ---
 net/netfilter/nf_conntrack_expect.c         |    2 --
 net/netfilter/nf_conntrack_netlink.c        |    6 +++---
 3 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index cae1a0d..b47c04f 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -38,9 +38,6 @@ struct nf_conntrack_expect
 	/* Usage count. */
 	atomic_t use;
 
-	/* Unique ID */
-	unsigned int id;
-
 	/* Flags */
 	unsigned int flags;
 
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 8a3e3af..7a0ae36 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -41,7 +41,6 @@ static int nf_ct_expect_hash_rnd_initted __read_mostly;
 static int nf_ct_expect_vmalloc;
 
 static struct kmem_cache *nf_ct_expect_cachep __read_mostly;
-static unsigned int nf_ct_expect_next_id;
 
 /* nf_conntrack_expect helper functions */
 void nf_ct_unlink_expect(struct nf_conntrack_expect *exp)
@@ -302,7 +301,6 @@ static void nf_ct_expect_insert(struct nf_conntrack_expect *exp)
 	exp->timeout.expires = jiffies + master_help->helper->timeout * HZ;
 	add_timer(&exp->timeout);
 
-	exp->id = ++nf_ct_expect_next_id;
 	atomic_inc(&exp->use);
 	NF_CT_STAT_INC(expect_create);
 }
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 8406aee..2abd648 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1160,7 +1160,7 @@ ctnetlink_exp_dump_expect(struct sk_buff *skb,
 {
 	struct nf_conn *master = exp->master;
 	__be32 timeout = htonl((exp->timeout.expires - jiffies) / HZ);
-	__be32 id = htonl(exp->id);
+	__be32 id = htonl((unsigned long)exp);
 
 	if (ctnetlink_exp_dump_tuple(skb, &exp->tuple, CTA_EXPECT_TUPLE) < 0)
 		goto nla_put_failure;
@@ -1346,7 +1346,7 @@ ctnetlink_get_expect(struct sock *ctnl, struct sk_buff *skb,
 
 	if (cda[CTA_EXPECT_ID]) {
 		__be32 id = *(__be32 *)nla_data(cda[CTA_EXPECT_ID]);
-		if (exp->id != ntohl(id)) {
+		if (ntohl(id) != (u32)(unsigned long)exp) {
 			nf_ct_expect_put(exp);
 			return -ENOENT;
 		}
@@ -1400,7 +1400,7 @@ ctnetlink_del_expect(struct sock *ctnl, struct sk_buff *skb,
 
 		if (cda[CTA_EXPECT_ID]) {
 			__be32 id = *(__be32 *)nla_data(cda[CTA_EXPECT_ID]);
-			if (exp->id != ntohl(id)) {
+			if (ntohl(id) != (u32)(unsigned long)exp) {
 				nf_ct_expect_put(exp);
 				return -ENOENT;
 			}
