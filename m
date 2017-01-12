From: fgao@ikuai8.com
Subject: [PATCH nf-next 1/1] netfilter: nf_tables: Remove the rcu lock for dump functions
Date: Thu, 12 Jan 2017 18:37:54 +0800
Message-ID: <1484217474-122356-1-git-send-email-fgao@ikuai8.com>
Cc: gfree.wind@gmail.com, Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbg340.qq.com ([14.17.44.35]:53459 "EHLO smtpbg340.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750755AbdALKqh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Jan 2017 05:46:37 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Feng <fgao@ikuai8.com>

The rcu lock protect is added 3 years ago with the commit
e688a7f8c6cb7a18aae7e55ccdd175f0ad9e69c0. But I find the dump
operation is protected by the nfnl_lock in the current codes. The
dump is a synchronization opertion in the netlink callback function
which is protected by the nfnl_lock.

BTW, I made some tests for this issue. I used the lockdep_nfnl_is_held
to check if the dump functions hold the lock at the entry and exit.
It shows all dump functions holds the nfnl_lock with subsystem id
NFNL_SUBSYS_NFTABLES.

Signed-off-by: Feng <fgao@ikuai8.com>
---
 net/netfilter/nf_tables_api.c | 42 +++++++++++++++---------------------------
 1 file changed, 15 insertions(+), 27 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a019a87..23a3be5c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -498,14 +498,13 @@ static int nf_tables_dump_tables(struct sk_buff *skb,
 	struct net *net = sock_net(skb->sk);
 	int family = nfmsg->nfgen_family;
 
-	rcu_read_lock();
 	cb->seq = net->nft.base_seq;
 
-	list_for_each_entry_rcu(afi, &net->nft.af_info, list) {
+	list_for_each_entry(afi, &net->nft.af_info, list) {
 		if (family != NFPROTO_UNSPEC && family != afi->family)
 			continue;
 
-		list_for_each_entry_rcu(table, &afi->tables, list) {
+		list_for_each_entry(table, &afi->tables, list) {
 			if (idx < s_idx)
 				goto cont;
 			if (idx > s_idx)
@@ -527,7 +526,6 @@ static int nf_tables_dump_tables(struct sk_buff *skb,
 		}
 	}
 done:
-	rcu_read_unlock();
 	cb->args[0] = idx;
 	return skb->len;
 }
@@ -1089,15 +1087,14 @@ static int nf_tables_dump_chains(struct sk_buff *skb,
 	struct net *net = sock_net(skb->sk);
 	int family = nfmsg->nfgen_family;
 
-	rcu_read_lock();
 	cb->seq = net->nft.base_seq;
 
-	list_for_each_entry_rcu(afi, &net->nft.af_info, list) {
+	list_for_each_entry(afi, &net->nft.af_info, list) {
 		if (family != NFPROTO_UNSPEC && family != afi->family)
 			continue;
 
-		list_for_each_entry_rcu(table, &afi->tables, list) {
-			list_for_each_entry_rcu(chain, &table->chains, list) {
+		list_for_each_entry(table, &afi->tables, list) {
+			list_for_each_entry(chain, &table->chains, list) {
 				if (idx < s_idx)
 					goto cont;
 				if (idx > s_idx)
@@ -1120,7 +1117,6 @@ static int nf_tables_dump_chains(struct sk_buff *skb,
 		}
 	}
 done:
-	rcu_read_unlock();
 	cb->args[0] = idx;
 	return skb->len;
 }
@@ -1981,24 +1977,23 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 	struct net *net = sock_net(skb->sk);
 	int family = nfmsg->nfgen_family;
 
-	rcu_read_lock();
 	cb->seq = net->nft.base_seq;
 
-	list_for_each_entry_rcu(afi, &net->nft.af_info, list) {
+	list_for_each_entry(afi, &net->nft.af_info, list) {
 		if (family != NFPROTO_UNSPEC && family != afi->family)
 			continue;
 
-		list_for_each_entry_rcu(table, &afi->tables, list) {
+		list_for_each_entry(table, &afi->tables, list) {
 			if (ctx && ctx->table[0] &&
 			    strcmp(ctx->table, table->name) != 0)
 				continue;
 
-			list_for_each_entry_rcu(chain, &table->chains, list) {
+			list_for_each_entry(chain, &table->chains, list) {
 				if (ctx && ctx->chain[0] &&
 				    strcmp(ctx->chain, chain->name) != 0)
 					continue;
 
-				list_for_each_entry_rcu(rule, &chain->rules, list) {
+				list_for_each_entry(rule, &chain->rules, list) {
 					if (!nft_is_active(net, rule))
 						goto cont;
 					if (idx < s_idx)
@@ -2021,8 +2016,6 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 		}
 	}
 done:
-	rcu_read_unlock();
-
 	cb->args[0] = idx;
 	return skb->len;
 }
@@ -2699,10 +2692,9 @@ static int nf_tables_dump_sets(struct sk_buff *skb, struct netlink_callback *cb)
 	if (cb->args[1])
 		return skb->len;
 
-	rcu_read_lock();
 	cb->seq = net->nft.base_seq;
 
-	list_for_each_entry_rcu(afi, &net->nft.af_info, list) {
+	list_for_each_entry(afi, &net->nft.af_info, list) {
 		if (ctx->afi && ctx->afi != afi)
 			continue;
 
@@ -2712,7 +2704,7 @@ static int nf_tables_dump_sets(struct sk_buff *skb, struct netlink_callback *cb)
 
 			cur_family = 0;
 		}
-		list_for_each_entry_rcu(table, &afi->tables, list) {
+		list_for_each_entry(table, &afi->tables, list) {
 			if (ctx->table && ctx->table != table)
 				continue;
 
@@ -2723,7 +2715,7 @@ static int nf_tables_dump_sets(struct sk_buff *skb, struct netlink_callback *cb)
 				cur_table = NULL;
 			}
 			idx = 0;
-			list_for_each_entry_rcu(set, &table->sets, list) {
+			list_for_each_entry(set, &table->sets, list) {
 				if (idx < s_idx)
 					goto cont;
 				if (!nft_is_active(net, set))
@@ -2750,7 +2742,6 @@ static int nf_tables_dump_sets(struct sk_buff *skb, struct netlink_callback *cb)
 	}
 	cb->args[1] = 1;
 done:
-	rcu_read_unlock();
 	return skb->len;
 }
 
@@ -4246,15 +4237,14 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 	if (NFNL_MSG_TYPE(cb->nlh->nlmsg_type) == NFT_MSG_GETOBJ_RESET)
 		reset = true;
 
-	rcu_read_lock();
 	cb->seq = net->nft.base_seq;
 
-	list_for_each_entry_rcu(afi, &net->nft.af_info, list) {
+	list_for_each_entry(afi, &net->nft.af_info, list) {
 		if (family != NFPROTO_UNSPEC && family != afi->family)
 			continue;
 
-		list_for_each_entry_rcu(table, &afi->tables, list) {
-			list_for_each_entry_rcu(obj, &table->objects, list) {
+		list_for_each_entry(table, &afi->tables, list) {
+			list_for_each_entry(obj, &table->objects, list) {
 				if (!nft_is_active(net, obj))
 					goto cont;
 				if (idx < s_idx)
@@ -4283,8 +4273,6 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 		}
 	}
 done:
-	rcu_read_unlock();
-
 	cb->args[0] = idx;
 	return skb->len;
 }
-- 
1.9.1

