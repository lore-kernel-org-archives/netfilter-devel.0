From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 10/17]: ctnetlink: change table dumping not to require
	an unique ID
Date: Tue, 30 May 2006 00:34:24 +0200 (MEST)
Message-ID: <20060529223423.24834.38846.sendpatchset@localhost.localdomain>
References: <20060529223404.24834.30808.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060529223404.24834.30808.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: ctnetlink: change table dumping not to require an unique ID

Instead of using the ID to find out where to continue dumping, take a
reference to the last entry dumped and try to continue there.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 33f076517f429291fcd71b128d3f14b141e3cbdc
tree c6a25b377807ac039ce5290692778b04f7df78c6
parent 614914402a6a25f37b4cc0840e29aa1808d3426e
author Patrick McHardy <kaber@trash.net> Tue, 30 May 2006 00:04:33 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 30 May 2006 00:04:33 +0200

 net/ipv4/netfilter/ip_conntrack_netlink.c |   32 ++++++++++++++++++++++-------
 net/netfilter/nf_conntrack_netlink.c      |   32 ++++++++++++++++++++++-------
 2 files changed, 48 insertions(+), 16 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter/ip_conntrack_netlink.c
index af152e3..33891bb 100644
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -399,38 +399,54 @@ #endif /* CONFIG_IP_NF_CONNTRACK_EVENTS 
 static int ctnetlink_done(struct netlink_callback *cb)
 {
 	DEBUGP("entered %s\n", __FUNCTION__);
+	if (cb->args[1])
+		ip_conntrack_put((struct ip_conntrack *)cb->args[1]);
 	return 0;
 }
 
 static int
 ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 {
-	struct ip_conntrack *ct = NULL;
+	struct ip_conntrack *ct, *last;
 	struct ip_conntrack_tuple_hash *h;
 	struct list_head *i;
-	u_int32_t *id = (u_int32_t *) &cb->args[1];
 
 	DEBUGP("entered %s, last bucket=%lu id=%u\n", __FUNCTION__, 
 			cb->args[0], *id);
 
 	read_lock_bh(&ip_conntrack_lock);
-	for (; cb->args[0] < ip_conntrack_htable_size; cb->args[0]++, *id = 0) {
+	for (; cb->args[0] < ip_conntrack_htable_size; cb->args[0]++) {
+restart:
+		last = (struct ip_conntrack *)cb->args[1];
 		list_for_each_prev(i, &ip_conntrack_hash[cb->args[0]]) {
 			h = (struct ip_conntrack_tuple_hash *) i;
 			if (DIRECTION(h) != IP_CT_DIR_ORIGINAL)
 				continue;
 			ct = tuplehash_to_ctrack(h);
-			if (ct->id <= *id)
-				continue;
+			if (last != NULL) {
+				if (ct == last) {
+					ip_conntrack_put(last);
+					cb->args[1] = 0;
+					last = NULL;
+				} else
+					continue;
+			}
 			if (ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).pid,
 		                        	cb->nlh->nlmsg_seq,
 						IPCTNL_MSG_CT_NEW,
-						1, ct) < 0)
+						1, ct) < 0) {
+				nf_conntrack_get(&ct->ct_general);
+				cb->args[1] = (unsigned long)ct;
 				goto out;
-			*id = ct->id;
+			}
+		}
+		if (last != NULL) {
+			ip_conntrack_put(last);
+			cb->args[1] = 0;
+			goto restart;
 		}
 	}
-out:	
+out:
 	read_unlock_bh(&ip_conntrack_lock);
 
 	DEBUGP("leaving, last bucket=%lu id=%u\n", cb->args[0], *id);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 8f27fe9..b8c7c56 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -407,6 +407,8 @@ #endif /* CONFIG_NF_CONNTRACK_EVENTS */
 
 static int ctnetlink_done(struct netlink_callback *cb)
 {
+	if (cb->args[1])
+		nf_ct_put((struct nf_conn *)cb->args[1]);
 	DEBUGP("entered %s\n", __FUNCTION__);
 	return 0;
 }
@@ -416,10 +418,9 @@ #define L3PROTO(ct) ct->tuplehash[IP_CT_
 static int
 ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 {
-	struct nf_conn *ct = NULL;
+	struct nf_conn *ct, *last;
 	struct nf_conntrack_tuple_hash *h;
 	struct list_head *i;
-	u_int32_t *id = (u_int32_t *) &cb->args[1];
 	struct nfgenmsg *nfmsg = NLMSG_DATA(cb->nlh);
 	u_int8_t l3proto = nfmsg->nfgen_family;
 
@@ -427,7 +428,9 @@ ctnetlink_dump_table(struct sk_buff *skb
 			cb->args[0], *id);
 
 	read_lock_bh(&nf_conntrack_lock);
-	for (; cb->args[0] < nf_conntrack_htable_size; cb->args[0]++, *id = 0) {
+	for (; cb->args[0] < nf_conntrack_htable_size; cb->args[0]++) {
+restart:
+		last = (struct nf_conn *)cb->args[1];
 		list_for_each_prev(i, &nf_conntrack_hash[cb->args[0]]) {
 			h = (struct nf_conntrack_tuple_hash *) i;
 			if (DIRECTION(h) != IP_CT_DIR_ORIGINAL)
@@ -438,17 +441,30 @@ ctnetlink_dump_table(struct sk_buff *skb
 			 * then dump everything. */
 			if (l3proto && L3PROTO(ct) != l3proto)
 				continue;
-			if (ct->id <= *id)
-				continue;
+			if (last != NULL) {
+				if (ct == last) {
+					nf_ct_put(last);
+					cb->args[1] = 0;
+					last = NULL;
+				} else
+					continue;
+			}
 			if (ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).pid,
 		                        	cb->nlh->nlmsg_seq,
 						IPCTNL_MSG_CT_NEW,
-						1, ct) < 0)
+						1, ct) < 0) {
+				nf_conntrack_get(&ct->ct_general);
+				cb->args[1] = (unsigned long)ct;
 				goto out;
-			*id = ct->id;
+			}
+		}
+		if (last != NULL) {
+			nf_ct_put(last);
+			cb->args[1] = 0;
+			goto restart;
 		}
 	}
-out:	
+out:
 	read_unlock_bh(&nf_conntrack_lock);
 
 	DEBUGP("leaving, last bucket=%lu id=%u\n", cb->args[0], *id);
