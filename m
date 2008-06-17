From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCHv2] deliver events for conntracks created via ctnetlink
Date: Tue, 17 Jun 2008 14:08:25 +0200
Message-ID: <4857A939.6050701@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010006070507050106010600"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48837 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754922AbYFQMIb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Jun 2008 08:08:31 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010006070507050106010600
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

As for now, the creation and update of conntracks via ctnetlink do not
propagate an event to userspace. This can result in inconsistent
situations if several userspace processes modify the connection tracking
table by means of ctnetlink at the same time. Specifically, using the
conntrack command line tool and conntrackd at the same time can trigger
unconsistencies.

This patch fixes this inconsistent situation. Note that the deletion
does not suffer from this problem.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------010006070507050106010600
Content-Type: text/x-diff;
 name="05.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="05.patch"

[PATCH] deliver events for conntracks created via ctnetlink

As for now, the creation and update of conntracks via ctnetlink do not
propagate an event to userspace. This can result in inconsistent situations
if several userspace processes modify the connection tracking table by means
of ctnetlink at the same time. Specifically, using the conntrack command
line tool and conntrackd at the same time can trigger unconsistencies. 

This patch fixes this inconsistent situation. Note that the deletion does
not suffer from this problem.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6.git/net/netfilter/nf_conntrack_netlink.c
===================================================================
--- net-2.6.git.orig/net/netfilter/nf_conntrack_netlink.c	2008-06-08 20:26:36.000000000 +0200
+++ net-2.6.git/net/netfilter/nf_conntrack_netlink.c	2008-06-14 12:22:31.000000000 +0200
@@ -36,6 +36,7 @@
 #include <net/netfilter/nf_conntrack_l3proto.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
+#include <net/netfilter/nf_conntrack_ecache.h>
 #ifdef CONFIG_NF_NAT_NEEDED
 #include <net/netfilter/nf_nat_core.h>
 #include <net/netfilter/nf_nat_protocol.h>
@@ -933,6 +934,9 @@ ctnetlink_change_status(struct nf_conn *
 	 * so don't let users modify them directly if they don't pass
 	 * nf_nat_range. */
 	ct->status |= status & ~(IPS_NAT_DONE_MASK | IPS_NAT_MASK);
+
+	nf_conntrack_event_cache_ct(IPCT_STATUS, ct);
+
 	return 0;
 }
 
@@ -982,6 +986,8 @@ ctnetlink_change_helper(struct nf_conn *
 
 	rcu_assign_pointer(help->helper, helper);
 
+	nf_conntrack_event_cache_ct(IPCT_HELPER, ct);
+
 	return 0;
 }
 
@@ -996,6 +1002,8 @@ ctnetlink_change_timeout(struct nf_conn 
 	ct->timeout.expires = jiffies + timeout * HZ;
 	add_timer(&ct->timeout);
 
+	nf_conntrack_event_cache_ct(IPCT_REFRESH, ct);
+
 	return 0;
 }
 
@@ -1009,8 +1017,11 @@ ctnetlink_change_protoinfo(struct nf_con
 	nla_parse_nested(tb, CTA_PROTOINFO_MAX, attr, NULL);
 
 	l4proto = nf_ct_l4proto_find_get(nf_ct_l3num(ct), nf_ct_protonum(ct));
-	if (l4proto->from_nlattr)
+	if (l4proto->from_nlattr) {
 		err = l4proto->from_nlattr(tb, ct);
+		if (err == 0)
+			nf_conntrack_event_cache_ct(IPCT_PROTOINFO, ct);
+	}
 	nf_ct_l4proto_put(l4proto);
 
 	return err;
@@ -1061,6 +1072,8 @@ ctnetlink_change_nat_seq_adj(struct nf_c
 			return ret;
 
 		ct->status |= IPS_SEQ_ADJUST;
+
+		nf_conntrack_event_cache_ct(IPCT_NATSEQADJ, ct);
 	}
 
 	if (cda[CTA_NAT_SEQ_ADJ_REPLY]) {
@@ -1070,6 +1083,8 @@ ctnetlink_change_nat_seq_adj(struct nf_c
 			return ret;
 
 		ct->status |= IPS_SEQ_ADJUST;
+
+		nf_conntrack_event_cache_ct(IPCT_NATSEQADJ, ct);
 	}
 
 	return 0;
@@ -1106,8 +1121,10 @@ ctnetlink_change_conntrack(struct nf_con
 	}
 
 #if defined(CONFIG_NF_CONNTRACK_MARK)
-	if (cda[CTA_MARK])
+	if (cda[CTA_MARK]) {
 		ct->mark = ntohl(nla_get_be32(cda[CTA_MARK]));
+		nf_conntrack_event_cache_ct(IPCT_MARK, ct);
+	}
 #endif
 
 #ifdef CONFIG_NF_NAT_NEEDED
@@ -1156,8 +1173,10 @@ ctnetlink_create_conntrack(struct nlattr
 	}
 
 #if defined(CONFIG_NF_CONNTRACK_MARK)
-	if (cda[CTA_MARK])
+	if (cda[CTA_MARK]) {
 		ct->mark = ntohl(nla_get_be32(cda[CTA_MARK]));
+		nf_conntrack_event_cache_ct(IPCT_MARK, ct);
+	}
 #endif
 
 	rcu_read_lock();
@@ -1171,18 +1190,27 @@ ctnetlink_create_conntrack(struct nlattr
 		}
 		/* not in hash table yet so not strictly necessary */
 		rcu_assign_pointer(help->helper, helper);
+		nf_conntrack_event_cache_ct(IPCT_HELPER, ct);
 	}
 
 	/* setup master conntrack: this is a confirmed expectation */
 	if (master_ct) {
 		__set_bit(IPS_EXPECTED_BIT, &ct->status);
 		ct->master = master_ct;
-	}
+		nf_conntrack_event_cache_ct(IPCT_RELATED, ct);
+	} else
+		nf_conntrack_event_cache_ct(IPCT_NEW, ct);
+
+	atomic_inc(&ct->ct_general.use);
 
 	add_timer(&ct->timeout);
 	nf_conntrack_hash_insert(ct);
 	rcu_read_unlock();
 
+	nf_ct_deliver_cached_events(ct);
+
+	nf_ct_put(ct);
+
 	return 0;
 
 err:
@@ -1258,6 +1286,8 @@ ctnetlink_new_conntrack(struct sock *ctn
 	 * so there's no need to increase the refcount */
 	err = -EEXIST;
 	if (!(nlh->nlmsg_flags & NLM_F_EXCL)) {
+		struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(h);
+
 		/* we only allow nat config for new conntracks */
 		if (cda[CTA_NAT_SRC] || cda[CTA_NAT_DST]) {
 			err = -EOPNOTSUPP;
@@ -1268,8 +1298,17 @@ ctnetlink_new_conntrack(struct sock *ctn
 			err = -EOPNOTSUPP;
 			goto out_unlock;
 		}
-		err = ctnetlink_change_conntrack(nf_ct_tuplehash_to_ctrack(h),
-						 cda);
+
+		err = ctnetlink_change_conntrack(ct, cda);
+		if (err == 0) {
+			atomic_inc(&ct->ct_general.use);
+			spin_unlock_bh(&nf_conntrack_lock);
+			nf_ct_deliver_cached_events(ct);
+			nf_ct_put(ct);
+		} else
+			spin_unlock(&nf_conntrack_lock);
+
+		return err;
 	}
 
 out_unlock:
Index: net-2.6.git/include/net/netfilter/nf_conntrack_ecache.h
===================================================================
--- net-2.6.git.orig/include/net/netfilter/nf_conntrack_ecache.h	2008-06-08 20:26:30.000000000 +0200
+++ net-2.6.git/include/net/netfilter/nf_conntrack_ecache.h	2008-06-14 12:16:14.000000000 +0200
@@ -28,10 +28,9 @@ extern void __nf_ct_event_cache_init(str
 extern void nf_ct_event_cache_flush(void);
 
 static inline void
-nf_conntrack_event_cache(enum ip_conntrack_events event,
-			 const struct sk_buff *skb)
+nf_conntrack_event_cache_ct(enum ip_conntrack_events event,
+			    struct nf_conn *ct)
 {
-	struct nf_conn *ct = (struct nf_conn *)skb->nfct;
 	struct nf_conntrack_ecache *ecache;
 
 	local_bh_disable();
@@ -42,6 +41,13 @@ nf_conntrack_event_cache(enum ip_conntra
 	local_bh_enable();
 }
 
+static inline void
+nf_conntrack_event_cache(enum ip_conntrack_events event,
+			 const struct sk_buff *skb)
+{
+	nf_conntrack_event_cache_ct(event, (struct nf_conn *)skb->nfct);
+}
+
 static inline void nf_conntrack_event(enum ip_conntrack_events event,
 				      struct nf_conn *ct)
 {

--------------010006070507050106010600--
