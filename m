From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] simplify the code to dump the conntrack table
Date: Thu, 07 Sep 2006 15:15:46 +0200
Message-ID: <45001B82.4000504@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060404050208020103070000"
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

This is a multi-part message in MIME format.
--------------060404050208020103070000
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Merge the bits to dump the conntrack table and the ones to dump and
zero counters in a single piece of code. This patch does not change
the default behaviour if accounting is not enabled.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

--------------060404050208020103070000
Content-Type: text/plain;
 name="dump.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dump.patch"

[PATCH] Simplify the code to dump the conntrack table

Merge the bits to dump the conntrack table and the ones to dump and
zero counters in a single piece of code. This patch does not change
the default behaviour if accounting is not enabled.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- net-2.6.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2006-09-03 14:22:05.000000000 +0200
+++ net-2.6/net/ipv4/netfilter/ip_conntrack_netlink.c	2006-09-07 15:13:35.000000000 +0200
@@ -436,6 +436,9 @@ restart:
 				cb->args[1] = (unsigned long)ct;
 				goto out;
 			}
+			if (NFNL_MSG_TYPE(cb->nlh->nlmsg_type) == 
+						IPCTNL_MSG_CT_GET_CTRZERO)
+				memset(&ct->counters, 0, sizeof(ct->counters));
 		}
 		if (cb->args[1]) {
 			cb->args[1] = 0;
@@ -451,46 +454,6 @@ out:
 	return skb->len;
 }
 
-#ifdef CONFIG_IP_NF_CT_ACCT
-static int
-ctnetlink_dump_table_w(struct sk_buff *skb, struct netlink_callback *cb)
-{
-	struct ip_conntrack *ct = NULL;
-	struct ip_conntrack_tuple_hash *h;
-	struct list_head *i;
-	u_int32_t *id = (u_int32_t *) &cb->args[1];
-
-	DEBUGP("entered %s, last bucket=%u id=%u\n", __FUNCTION__, 
-			cb->args[0], *id);
-
-	write_lock_bh(&ip_conntrack_lock);
-	for (; cb->args[0] < ip_conntrack_htable_size; cb->args[0]++, *id = 0) {
-		list_for_each_prev(i, &ip_conntrack_hash[cb->args[0]]) {
-			h = (struct ip_conntrack_tuple_hash *) i;
-			if (DIRECTION(h) != IP_CT_DIR_ORIGINAL)
-				continue;
-			ct = tuplehash_to_ctrack(h);
-			if (ct->id <= *id)
-				continue;
-			if (ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).pid,
-		                        	cb->nlh->nlmsg_seq,
-						IPCTNL_MSG_CT_NEW,
-						1, ct) < 0)
-				goto out;
-			*id = ct->id;
-
-			memset(&ct->counters, 0, sizeof(ct->counters));
-		}
-	}
-out:	
-	write_unlock_bh(&ip_conntrack_lock);
-
-	DEBUGP("leaving, last bucket=%lu id=%u\n", cb->args[0], *id);
-
-	return skb->len;
-}
-#endif
-
 static const size_t cta_min_ip[CTA_IP_MAX] = {
 	[CTA_IP_V4_SRC-1]	= sizeof(u_int32_t),
 	[CTA_IP_V4_DST-1]	= sizeof(u_int32_t),
@@ -775,22 +738,14 @@ ctnetlink_get_conntrack(struct sock *ctn
 		if (msg->nfgen_family != AF_INET)
 			return -EAFNOSUPPORT;
 
-		if (NFNL_MSG_TYPE(nlh->nlmsg_type) ==
-					IPCTNL_MSG_CT_GET_CTRZERO) {
-#ifdef CONFIG_IP_NF_CT_ACCT
-			if ((*errp = netlink_dump_start(ctnl, skb, nlh,
-						ctnetlink_dump_table_w,
-						ctnetlink_done)) != 0)
-				return -EINVAL;
-#else
+#ifndef CONFIG_IP_NF_CT_ACCT
+		if (NFNL_MSG_TYPE(nlh->nlmsg_type) == IPCTNL_MSG_CT_GET_CTRZERO)
 			return -ENOTSUPP;
 #endif
-		} else {
-			if ((*errp = netlink_dump_start(ctnl, skb, nlh,
-		      		                        ctnetlink_dump_table,
-		                                	ctnetlink_done)) != 0)
+		if ((*errp = netlink_dump_start(ctnl, skb, nlh,
+	      		                        ctnetlink_dump_table,
+	                                	ctnetlink_done)) != 0)
 			return -EINVAL;
-		}
 
 		rlen = NLMSG_ALIGN(nlh->nlmsg_len);
 		if (rlen > skb->len)
Index: net-2.6/net/netfilter/nf_conntrack_netlink.c
===================================================================
--- net-2.6.orig/net/netfilter/nf_conntrack_netlink.c	2006-09-03 17:40:25.000000000 +0200
+++ net-2.6/net/netfilter/nf_conntrack_netlink.c	2006-09-03 17:44:51.000000000 +0200
@@ -455,6 +455,9 @@ restart:
 				cb->args[1] = (unsigned long)ct;
 				goto out;
 			}
+			if (NFNL_MSG_TYPE(cb->nlh->nlmsg_type) ==
+						IPCTNL_MSG_CT_GET_CTRZERO)
+				memset(&ct->counters, 0, sizeof(ct->counters));	
 		}
 		if (cb->args[1]) {
 			cb->args[1] = 0;
@@ -470,50 +473,6 @@ out:
 	return skb->len;
 }
 
-#ifdef CONFIG_NF_CT_ACCT
-static int
-ctnetlink_dump_table_w(struct sk_buff *skb, struct netlink_callback *cb)
-{
-	struct nf_conn *ct = NULL;
-	struct nf_conntrack_tuple_hash *h;
-	struct list_head *i;
-	u_int32_t *id = (u_int32_t *) &cb->args[1];
-	struct nfgenmsg *nfmsg = NLMSG_DATA(cb->nlh);
-	u_int8_t l3proto = nfmsg->nfgen_family;	
-
-	DEBUGP("entered %s, last bucket=%u id=%u\n", __FUNCTION__, 
-			cb->args[0], *id);
-
-	write_lock_bh(&nf_conntrack_lock);
-	for (; cb->args[0] < nf_conntrack_htable_size; cb->args[0]++, *id = 0) {
-		list_for_each_prev(i, &nf_conntrack_hash[cb->args[0]]) {
-			h = (struct nf_conntrack_tuple_hash *) i;
-			if (DIRECTION(h) != IP_CT_DIR_ORIGINAL)
-				continue;
-			ct = nf_ct_tuplehash_to_ctrack(h);
-			if (l3proto && L3PROTO(ct) != l3proto)
-				continue;
-			if (ct->id <= *id)
-				continue;
-			if (ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).pid,
-		                        	cb->nlh->nlmsg_seq,
-						IPCTNL_MSG_CT_NEW,
-						1, ct) < 0)
-				goto out;
-			*id = ct->id;
-
-			memset(&ct->counters, 0, sizeof(ct->counters));
-		}
-	}
-out:	
-	write_unlock_bh(&nf_conntrack_lock);
-
-	DEBUGP("leaving, last bucket=%lu id=%u\n", cb->args[0], *id);
-
-	return skb->len;
-}
-#endif
-
 static inline int
 ctnetlink_parse_tuple_ip(struct nfattr *attr, struct nf_conntrack_tuple *tuple)
 {
@@ -788,22 +747,14 @@ ctnetlink_get_conntrack(struct sock *ctn
 	if (nlh->nlmsg_flags & NLM_F_DUMP) {
 		u32 rlen;
 
-		if (NFNL_MSG_TYPE(nlh->nlmsg_type) ==
-					IPCTNL_MSG_CT_GET_CTRZERO) {
-#ifdef CONFIG_NF_CT_ACCT
-			if ((*errp = netlink_dump_start(ctnl, skb, nlh,
-						ctnetlink_dump_table_w,
-						ctnetlink_done)) != 0)
-				return -EINVAL;
-#else
+#ifndef CONFIG_NF_CT_ACCT
+		if (NFNL_MSG_TYPE(nlh->nlmsg_type) == IPCTNL_MSG_CT_GET_CTRZERO)
 			return -ENOTSUPP;
 #endif
-		} else {
-			if ((*errp = netlink_dump_start(ctnl, skb, nlh,
-		      		                        ctnetlink_dump_table,
-		                                	ctnetlink_done)) != 0)
+		if ((*errp = netlink_dump_start(ctnl, skb, nlh,
+						ctnetlink_dump_table,
+						ctnetlink_done)) != 0)
 			return -EINVAL;
-		}
 
 		rlen = NLMSG_ALIGN(nlh->nlmsg_len);
 		if (rlen > skb->len)

--------------060404050208020103070000--
