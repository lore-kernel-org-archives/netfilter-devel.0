From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 05/20]: nf_conntrack_expect: function naming unification
Date: Fri, 29 Jun 2007 02:45:03 +0200 (MEST)
Message-ID: <20070629004401.25566.25041.sendpatchset@localhost.localdomain>
References: <20070629004354.25566.59266.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070629004354.25566.59266.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack_expect: function naming unification

Currently there is a wild mix of nf_conntrack_expect_, nf_ct_exp_,
expect_, exp_, ...

Consistently use nf_ct_ as prefix for exported functions.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 2919009f4300baa6593e729d1267bb4442dea224
tree 2adf563ed31334a9b51692a2a4e7058c64266e9e
parent 7599a8b2b7da30aadebe9ca6233cb54be3d927c8
author Patrick McHardy <kaber@trash.net> Fri, 29 Jun 2007 02:04:25 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 29 Jun 2007 02:04:25 +0200

 include/net/netfilter/nf_conntrack_core.h          |    2 
 include/net/netfilter/nf_conntrack_ecache.h        |   17 +--
 include/net/netfilter/nf_conntrack_expect.h        |   28 ++--
 .../netfilter/nf_conntrack_l3proto_ipv4_compat.c   |    6 +
 net/ipv4/netfilter/nf_nat_amanda.c                 |    4 -
 net/ipv4/netfilter/nf_nat_ftp.c                    |    4 -
 net/ipv4/netfilter/nf_nat_h323.c                   |   26 ++--
 net/ipv4/netfilter/nf_nat_irc.c                    |    4 -
 net/ipv4/netfilter/nf_nat_pptp.c                   |    6 -
 net/ipv4/netfilter/nf_nat_sip.c                    |    4 -
 net/ipv4/netfilter/nf_nat_tftp.c                   |    2 
 net/netfilter/nf_conntrack_amanda.c                |   11 +-
 net/netfilter/nf_conntrack_core.c                  |   12 +-
 net/netfilter/nf_conntrack_ecache.c                |   16 +--
 net/netfilter/nf_conntrack_expect.c                |   93 +++++++--------
 net/netfilter/nf_conntrack_ftp.c                   |    6 -
 net/netfilter/nf_conntrack_h323_main.c             |  127 ++++++++++----------
 net/netfilter/nf_conntrack_helper.c                |    4 -
 net/netfilter/nf_conntrack_irc.c                   |   12 +-
 net/netfilter/nf_conntrack_netbios_ns.c            |    6 -
 net/netfilter/nf_conntrack_netlink.c               |   40 +++---
 net/netfilter/nf_conntrack_pptp.c                  |   44 +++----
 net/netfilter/nf_conntrack_sane.c                  |   12 +-
 net/netfilter/nf_conntrack_sip.c                   |   12 +-
 net/netfilter/nf_conntrack_tftp.c                  |   12 +-
 25 files changed, 251 insertions(+), 259 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index 2fa3a1b..a18f79c 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -84,7 +84,7 @@ print_tuple(struct seq_file *s, const struct nf_conntrack_tuple *tuple,
 	    struct nf_conntrack_l4proto *proto);
 
 extern struct hlist_head *nf_conntrack_hash;
-extern struct list_head nf_conntrack_expect_list;
+extern struct list_head nf_ct_expect_list;
 extern rwlock_t nf_conntrack_lock ;
 extern struct hlist_head unconfirmed;
 
diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/netfilter/nf_conntrack_ecache.h
index 811c907..f0b9078 100644
--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -49,15 +49,15 @@ static inline void nf_conntrack_event(enum ip_conntrack_events event,
 		atomic_notifier_call_chain(&nf_conntrack_chain, event, ct);
 }
 
-extern struct atomic_notifier_head nf_conntrack_expect_chain;
-extern int nf_conntrack_expect_register_notifier(struct notifier_block *nb);
-extern int nf_conntrack_expect_unregister_notifier(struct notifier_block *nb);
+extern struct atomic_notifier_head nf_ct_expect_chain;
+extern int nf_ct_expect_register_notifier(struct notifier_block *nb);
+extern int nf_ct_expect_unregister_notifier(struct notifier_block *nb);
 
 static inline void
-nf_conntrack_expect_event(enum ip_conntrack_expect_events event,
-			  struct nf_conntrack_expect *exp)
+nf_ct_expect_event(enum ip_conntrack_expect_events event,
+		   struct nf_conntrack_expect *exp)
 {
-	atomic_notifier_call_chain(&nf_conntrack_expect_chain, event, exp);
+	atomic_notifier_call_chain(&nf_ct_expect_chain, event, exp);
 }
 
 #else /* CONFIG_NF_CONNTRACK_EVENTS */
@@ -67,9 +67,8 @@ static inline void nf_conntrack_event_cache(enum ip_conntrack_events event,
 static inline void nf_conntrack_event(enum ip_conntrack_events event,
 				      struct nf_conn *ct) {}
 static inline void nf_ct_deliver_cached_events(const struct nf_conn *ct) {}
-static inline void
-nf_conntrack_expect_event(enum ip_conntrack_expect_events event,
-			  struct nf_conntrack_expect *exp) {}
+static inline void nf_ct_expect_event(enum ip_conntrack_expect_events event,
+				      struct nf_conntrack_expect *exp) {}
 static inline void nf_ct_event_cache_flush(void) {}
 #endif /* CONFIG_NF_CONNTRACK_EVENTS */
 
diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index 173c7c1..c0b1d1f 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -6,8 +6,8 @@
 #define _NF_CONNTRACK_EXPECT_H
 #include <net/netfilter/nf_conntrack.h>
 
-extern struct list_head nf_conntrack_expect_list;
-extern struct kmem_cache *nf_conntrack_expect_cachep;
+extern struct list_head nf_ct_expect_list;
+extern struct kmem_cache *nf_ct_expect_cachep;
 extern const struct file_operations exp_file_ops;
 
 struct nf_conntrack_expect
@@ -54,27 +54,27 @@ struct nf_conntrack_expect
 
 
 struct nf_conntrack_expect *
-__nf_conntrack_expect_find(const struct nf_conntrack_tuple *tuple);
+__nf_ct_expect_find(const struct nf_conntrack_tuple *tuple);
 
 struct nf_conntrack_expect *
-nf_conntrack_expect_find_get(const struct nf_conntrack_tuple *tuple);
+nf_ct_expect_find_get(const struct nf_conntrack_tuple *tuple);
 
 struct nf_conntrack_expect *
-find_expectation(const struct nf_conntrack_tuple *tuple);
+nf_ct_find_expectation(const struct nf_conntrack_tuple *tuple);
 
 void nf_ct_unlink_expect(struct nf_conntrack_expect *exp);
 void nf_ct_remove_expectations(struct nf_conn *ct);
-void nf_conntrack_unexpect_related(struct nf_conntrack_expect *exp);
+void nf_ct_unexpect_related(struct nf_conntrack_expect *exp);
 
 /* Allocate space for an expectation: this is mandatory before calling
-   nf_conntrack_expect_related.  You will have to call put afterwards. */
-struct nf_conntrack_expect *nf_conntrack_expect_alloc(struct nf_conn *me);
-void nf_conntrack_expect_init(struct nf_conntrack_expect *, int,
-			      union nf_conntrack_address *,
-			      union nf_conntrack_address *,
-			      u_int8_t, __be16 *, __be16 *);
-void nf_conntrack_expect_put(struct nf_conntrack_expect *exp);
-int nf_conntrack_expect_related(struct nf_conntrack_expect *expect);
+   nf_ct_expect_related.  You will have to call put afterwards. */
+struct nf_conntrack_expect *nf_ct_expect_alloc(struct nf_conn *me);
+void nf_ct_expect_init(struct nf_conntrack_expect *, int,
+		       union nf_conntrack_address *,
+		       union nf_conntrack_address *,
+		       u_int8_t, __be16 *, __be16 *);
+void nf_ct_expect_put(struct nf_conntrack_expect *exp);
+int nf_ct_expect_related(struct nf_conntrack_expect *expect);
 
 #endif /*_NF_CONNTRACK_EXPECT_H*/
 
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
index 888f27f..12d6a63 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
@@ -209,7 +209,7 @@ static const struct file_operations ct_file_ops = {
 /* expects */
 static void *exp_seq_start(struct seq_file *s, loff_t *pos)
 {
-	struct list_head *e = &nf_conntrack_expect_list;
+	struct list_head *e = &nf_ct_expect_list;
 	loff_t i;
 
 	/* strange seq_file api calls stop even if we fail,
@@ -221,7 +221,7 @@ static void *exp_seq_start(struct seq_file *s, loff_t *pos)
 
 	for (i = 0; i <= *pos; i++) {
 		e = e->next;
-		if (e == &nf_conntrack_expect_list)
+		if (e == &nf_ct_expect_list)
 			return NULL;
 	}
 	return e;
@@ -234,7 +234,7 @@ static void *exp_seq_next(struct seq_file *s, void *v, loff_t *pos)
 	++*pos;
 	e = e->next;
 
-	if (e == &nf_conntrack_expect_list)
+	if (e == &nf_ct_expect_list)
 		return NULL;
 
 	return e;
diff --git a/net/ipv4/netfilter/nf_nat_amanda.c b/net/ipv4/netfilter/nf_nat_amanda.c
index 0f17098..bd93a1d 100644
--- a/net/ipv4/netfilter/nf_nat_amanda.c
+++ b/net/ipv4/netfilter/nf_nat_amanda.c
@@ -45,7 +45,7 @@ static unsigned int help(struct sk_buff **pskb,
 	/* Try to get same port: if not, try to change it. */
 	for (port = ntohs(exp->saved_proto.tcp.port); port != 0; port++) {
 		exp->tuple.dst.u.tcp.port = htons(port);
-		if (nf_conntrack_expect_related(exp) == 0)
+		if (nf_ct_expect_related(exp) == 0)
 			break;
 	}
 
@@ -57,7 +57,7 @@ static unsigned int help(struct sk_buff **pskb,
 				       matchoff, matchlen,
 				       buffer, strlen(buffer));
 	if (ret != NF_ACCEPT)
-		nf_conntrack_unexpect_related(exp);
+		nf_ct_unexpect_related(exp);
 	return ret;
 }
 
diff --git a/net/ipv4/netfilter/nf_nat_ftp.c b/net/ipv4/netfilter/nf_nat_ftp.c
index e6bc8e5..cae4b46 100644
--- a/net/ipv4/netfilter/nf_nat_ftp.c
+++ b/net/ipv4/netfilter/nf_nat_ftp.c
@@ -131,7 +131,7 @@ static unsigned int nf_nat_ftp(struct sk_buff **pskb,
 	/* Try to get same port: if not, try to change it. */
 	for (port = ntohs(exp->saved_proto.tcp.port); port != 0; port++) {
 		exp->tuple.dst.u.tcp.port = htons(port);
-		if (nf_conntrack_expect_related(exp) == 0)
+		if (nf_ct_expect_related(exp) == 0)
 			break;
 	}
 
@@ -139,7 +139,7 @@ static unsigned int nf_nat_ftp(struct sk_buff **pskb,
 		return NF_DROP;
 
 	if (!mangle[type](pskb, newip, port, matchoff, matchlen, ct, ctinfo)) {
-		nf_conntrack_unexpect_related(exp);
+		nf_ct_unexpect_related(exp);
 		return NF_DROP;
 	}
 	return NF_ACCEPT;
diff --git a/net/ipv4/netfilter/nf_nat_h323.c b/net/ipv4/netfilter/nf_nat_h323.c
index c5d2a2d..3d760dd 100644
--- a/net/ipv4/netfilter/nf_nat_h323.c
+++ b/net/ipv4/netfilter/nf_nat_h323.c
@@ -237,12 +237,12 @@ static int nat_rtp_rtcp(struct sk_buff **pskb, struct nf_conn *ct,
 	for (nated_port = ntohs(rtp_exp->tuple.dst.u.udp.port);
 	     nated_port != 0; nated_port += 2) {
 		rtp_exp->tuple.dst.u.udp.port = htons(nated_port);
-		if (nf_conntrack_expect_related(rtp_exp) == 0) {
+		if (nf_ct_expect_related(rtp_exp) == 0) {
 			rtcp_exp->tuple.dst.u.udp.port =
 			    htons(nated_port + 1);
-			if (nf_conntrack_expect_related(rtcp_exp) == 0)
+			if (nf_ct_expect_related(rtcp_exp) == 0)
 				break;
-			nf_conntrack_unexpect_related(rtp_exp);
+			nf_ct_unexpect_related(rtp_exp);
 		}
 	}
 
@@ -261,8 +261,8 @@ static int nat_rtp_rtcp(struct sk_buff **pskb, struct nf_conn *ct,
 		info->rtp_port[i][dir] = rtp_port;
 		info->rtp_port[i][!dir] = htons(nated_port);
 	} else {
-		nf_conntrack_unexpect_related(rtp_exp);
-		nf_conntrack_unexpect_related(rtcp_exp);
+		nf_ct_unexpect_related(rtp_exp);
+		nf_ct_unexpect_related(rtcp_exp);
 		return -1;
 	}
 
@@ -299,7 +299,7 @@ static int nat_t120(struct sk_buff **pskb, struct nf_conn *ct,
 	/* Try to get same port: if not, try to change it. */
 	for (; nated_port != 0; nated_port++) {
 		exp->tuple.dst.u.tcp.port = htons(nated_port);
-		if (nf_conntrack_expect_related(exp) == 0)
+		if (nf_ct_expect_related(exp) == 0)
 			break;
 	}
 
@@ -313,7 +313,7 @@ static int nat_t120(struct sk_buff **pskb, struct nf_conn *ct,
 	if (set_h245_addr(pskb, data, dataoff, taddr,
 			  &ct->tuplehash[!dir].tuple.dst.u3,
 			  htons(nated_port)) < 0) {
-		nf_conntrack_unexpect_related(exp);
+		nf_ct_unexpect_related(exp);
 		return -1;
 	}
 
@@ -347,7 +347,7 @@ static int nat_h245(struct sk_buff **pskb, struct nf_conn *ct,
 	/* Try to get same port: if not, try to change it. */
 	for (; nated_port != 0; nated_port++) {
 		exp->tuple.dst.u.tcp.port = htons(nated_port);
-		if (nf_conntrack_expect_related(exp) == 0)
+		if (nf_ct_expect_related(exp) == 0)
 			break;
 	}
 
@@ -365,7 +365,7 @@ static int nat_h245(struct sk_buff **pskb, struct nf_conn *ct,
 		info->sig_port[dir] = port;
 		info->sig_port[!dir] = htons(nated_port);
 	} else {
-		nf_conntrack_unexpect_related(exp);
+		nf_ct_unexpect_related(exp);
 		return -1;
 	}
 
@@ -433,7 +433,7 @@ static int nat_q931(struct sk_buff **pskb, struct nf_conn *ct,
 	/* Try to get same port: if not, try to change it. */
 	for (; nated_port != 0; nated_port++) {
 		exp->tuple.dst.u.tcp.port = htons(nated_port);
-		if (nf_conntrack_expect_related(exp) == 0)
+		if (nf_ct_expect_related(exp) == 0)
 			break;
 	}
 
@@ -460,7 +460,7 @@ static int nat_q931(struct sk_buff **pskb, struct nf_conn *ct,
 				      info->sig_port[!dir]);
 		}
 	} else {
-		nf_conntrack_unexpect_related(exp);
+		nf_ct_unexpect_related(exp);
 		return -1;
 	}
 
@@ -517,7 +517,7 @@ static int nat_callforwarding(struct sk_buff **pskb, struct nf_conn *ct,
 	/* Try to get same port: if not, try to change it. */
 	for (nated_port = ntohs(port); nated_port != 0; nated_port++) {
 		exp->tuple.dst.u.tcp.port = htons(nated_port);
-		if (nf_conntrack_expect_related(exp) == 0)
+		if (nf_ct_expect_related(exp) == 0)
 			break;
 	}
 
@@ -531,7 +531,7 @@ static int nat_callforwarding(struct sk_buff **pskb, struct nf_conn *ct,
 	if (!set_h225_addr(pskb, data, dataoff, taddr,
 			   &ct->tuplehash[!dir].tuple.dst.u3,
 			   htons(nated_port)) == 0) {
-		nf_conntrack_unexpect_related(exp);
+		nf_ct_unexpect_related(exp);
 		return -1;
 	}
 
diff --git a/net/ipv4/netfilter/nf_nat_irc.c b/net/ipv4/netfilter/nf_nat_irc.c
index 9b8c0da..db7fbf6 100644
--- a/net/ipv4/netfilter/nf_nat_irc.c
+++ b/net/ipv4/netfilter/nf_nat_irc.c
@@ -55,7 +55,7 @@ static unsigned int help(struct sk_buff **pskb,
 	/* Try to get same port: if not, try to change it. */
 	for (port = ntohs(exp->saved_proto.tcp.port); port != 0; port++) {
 		exp->tuple.dst.u.tcp.port = htons(port);
-		if (nf_conntrack_expect_related(exp) == 0)
+		if (nf_ct_expect_related(exp) == 0)
 			break;
 	}
 
@@ -71,7 +71,7 @@ static unsigned int help(struct sk_buff **pskb,
 				       matchoff, matchlen, buffer,
 				       strlen(buffer));
 	if (ret != NF_ACCEPT)
-		nf_conntrack_unexpect_related(exp);
+		nf_ct_unexpect_related(exp);
 	return ret;
 }
 
diff --git a/net/ipv4/netfilter/nf_nat_pptp.c b/net/ipv4/netfilter/nf_nat_pptp.c
index a668887..deb80ae 100644
--- a/net/ipv4/netfilter/nf_nat_pptp.c
+++ b/net/ipv4/netfilter/nf_nat_pptp.c
@@ -81,10 +81,10 @@ static void pptp_nat_expected(struct nf_conn *ct,
 
 	DEBUGP("trying to unexpect other dir: ");
 	NF_CT_DUMP_TUPLE(&t);
-	other_exp = nf_conntrack_expect_find_get(&t);
+	other_exp = nf_ct_expect_find_get(&t);
 	if (other_exp) {
-		nf_conntrack_unexpect_related(other_exp);
-		nf_conntrack_expect_put(other_exp);
+		nf_ct_unexpect_related(other_exp);
+		nf_ct_expect_put(other_exp);
 		DEBUGP("success\n");
 	} else {
 		DEBUGP("not found!\n");
diff --git a/net/ipv4/netfilter/nf_nat_sip.c b/net/ipv4/netfilter/nf_nat_sip.c
index a32d746..940cdfc 100644
--- a/net/ipv4/netfilter/nf_nat_sip.c
+++ b/net/ipv4/netfilter/nf_nat_sip.c
@@ -278,7 +278,7 @@ static unsigned int ip_nat_sdp(struct sk_buff **pskb,
 	/* Try to get same port: if not, try to change it. */
 	for (port = ntohs(exp->saved_proto.udp.port); port != 0; port++) {
 		exp->tuple.dst.u.udp.port = htons(port);
-		if (nf_conntrack_expect_related(exp) == 0)
+		if (nf_ct_expect_related(exp) == 0)
 			break;
 	}
 
@@ -286,7 +286,7 @@ static unsigned int ip_nat_sdp(struct sk_buff **pskb,
 		return NF_DROP;
 
 	if (!mangle_sdp(pskb, ctinfo, ct, newip, port, dptr)) {
-		nf_conntrack_unexpect_related(exp);
+		nf_ct_unexpect_related(exp);
 		return NF_DROP;
 	}
 	return NF_ACCEPT;
diff --git a/net/ipv4/netfilter/nf_nat_tftp.c b/net/ipv4/netfilter/nf_nat_tftp.c
index 2566b79..04dfeae 100644
--- a/net/ipv4/netfilter/nf_nat_tftp.c
+++ b/net/ipv4/netfilter/nf_nat_tftp.c
@@ -30,7 +30,7 @@ static unsigned int help(struct sk_buff **pskb,
 		= ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.udp.port;
 	exp->dir = IP_CT_DIR_REPLY;
 	exp->expectfn = nf_nat_follow_master;
-	if (nf_conntrack_expect_related(exp) != 0)
+	if (nf_ct_expect_related(exp) != 0)
 		return NF_DROP;
 	return NF_ACCEPT;
 }
diff --git a/net/netfilter/nf_conntrack_amanda.c b/net/netfilter/nf_conntrack_amanda.c
index 0568f2e..d21359e 100644
--- a/net/netfilter/nf_conntrack_amanda.c
+++ b/net/netfilter/nf_conntrack_amanda.c
@@ -142,23 +142,22 @@ static int amanda_help(struct sk_buff **pskb,
 		if (port == 0 || len > 5)
 			break;
 
-		exp = nf_conntrack_expect_alloc(ct);
+		exp = nf_ct_expect_alloc(ct);
 		if (exp == NULL) {
 			ret = NF_DROP;
 			goto out;
 		}
 		tuple = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
-		nf_conntrack_expect_init(exp, family,
-					 &tuple->src.u3, &tuple->dst.u3,
-					 IPPROTO_TCP, NULL, &port);
+		nf_ct_expect_init(exp, family, &tuple->src.u3, &tuple->dst.u3,
+				  IPPROTO_TCP, NULL, &port);
 
 		nf_nat_amanda = rcu_dereference(nf_nat_amanda_hook);
 		if (nf_nat_amanda && ct->status & IPS_NAT_MASK)
 			ret = nf_nat_amanda(pskb, ctinfo, off - dataoff,
 					    len, exp);
-		else if (nf_conntrack_expect_related(exp) != 0)
+		else if (nf_ct_expect_related(exp) != 0)
 			ret = NF_DROP;
-		nf_conntrack_expect_put(exp);
+		nf_ct_expect_put(exp);
 	}
 
 out:
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index f4c3039..793f12f 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -494,7 +494,7 @@ init_conntrack(const struct nf_conntrack_tuple *tuple,
 	}
 
 	write_lock_bh(&nf_conntrack_lock);
-	exp = find_expectation(tuple);
+	exp = nf_ct_find_expectation(tuple);
 	if (exp) {
 		DEBUGP("conntrack: expectation arrives ct=%p exp=%p\n",
 			conntrack, exp);
@@ -544,7 +544,7 @@ init_conntrack(const struct nf_conntrack_tuple *tuple,
 	if (exp) {
 		if (exp->expectfn)
 			exp->expectfn(conntrack, exp);
-		nf_conntrack_expect_put(exp);
+		nf_ct_expect_put(exp);
 	}
 
 	return &conntrack->tuplehash[IP_CT_DIR_ORIGINAL];
@@ -961,7 +961,7 @@ void nf_conntrack_cleanup(void)
 	rcu_assign_pointer(nf_ct_destroy, NULL);
 
 	kmem_cache_destroy(nf_conntrack_cachep);
-	kmem_cache_destroy(nf_conntrack_expect_cachep);
+	kmem_cache_destroy(nf_ct_expect_cachep);
 	nf_ct_free_hashtable(nf_conntrack_hash, nf_conntrack_vmalloc,
 			     nf_conntrack_htable_size);
 
@@ -1088,10 +1088,10 @@ int __init nf_conntrack_init(void)
 		goto err_free_hash;
 	}
 
-	nf_conntrack_expect_cachep = kmem_cache_create("nf_conntrack_expect",
+	nf_ct_expect_cachep = kmem_cache_create("nf_conntrack_expect",
 					sizeof(struct nf_conntrack_expect),
 					0, 0, NULL, NULL);
-	if (!nf_conntrack_expect_cachep) {
+	if (!nf_ct_expect_cachep) {
 		printk(KERN_ERR "Unable to create nf_expect slab cache\n");
 		goto err_free_conntrack_slab;
 	}
@@ -1119,7 +1119,7 @@ int __init nf_conntrack_init(void)
 out_fini_proto:
 	nf_conntrack_proto_fini();
 out_free_expect_slab:
-	kmem_cache_destroy(nf_conntrack_expect_cachep);
+	kmem_cache_destroy(nf_ct_expect_cachep);
 err_free_conntrack_slab:
 	kmem_cache_destroy(nf_conntrack_cachep);
 err_free_hash:
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 6bd421d..83c41ac 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -26,8 +26,8 @@
 ATOMIC_NOTIFIER_HEAD(nf_conntrack_chain);
 EXPORT_SYMBOL_GPL(nf_conntrack_chain);
 
-ATOMIC_NOTIFIER_HEAD(nf_conntrack_expect_chain);
-EXPORT_SYMBOL_GPL(nf_conntrack_expect_chain);
+ATOMIC_NOTIFIER_HEAD(nf_ct_expect_chain);
+EXPORT_SYMBOL_GPL(nf_ct_expect_chain);
 
 DEFINE_PER_CPU(struct nf_conntrack_ecache, nf_conntrack_ecache);
 EXPORT_PER_CPU_SYMBOL_GPL(nf_conntrack_ecache);
@@ -103,14 +103,14 @@ int nf_conntrack_unregister_notifier(struct notifier_block *nb)
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_unregister_notifier);
 
-int nf_conntrack_expect_register_notifier(struct notifier_block *nb)
+int nf_ct_expect_register_notifier(struct notifier_block *nb)
 {
-	return atomic_notifier_chain_register(&nf_conntrack_expect_chain, nb);
+	return atomic_notifier_chain_register(&nf_ct_expect_chain, nb);
 }
-EXPORT_SYMBOL_GPL(nf_conntrack_expect_register_notifier);
+EXPORT_SYMBOL_GPL(nf_ct_expect_register_notifier);
 
-int nf_conntrack_expect_unregister_notifier(struct notifier_block *nb)
+int nf_ct_expect_unregister_notifier(struct notifier_block *nb)
 {
-	return atomic_notifier_chain_unregister(&nf_conntrack_expect_chain, nb);
+	return atomic_notifier_chain_unregister(&nf_ct_expect_chain, nb);
 }
-EXPORT_SYMBOL_GPL(nf_conntrack_expect_unregister_notifier);
+EXPORT_SYMBOL_GPL(nf_ct_expect_unregister_notifier);
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 504fb6c..4130ea6 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -26,11 +26,11 @@
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
 
-LIST_HEAD(nf_conntrack_expect_list);
-EXPORT_SYMBOL_GPL(nf_conntrack_expect_list);
+LIST_HEAD(nf_ct_expect_list);
+EXPORT_SYMBOL_GPL(nf_ct_expect_list);
 
-struct kmem_cache *nf_conntrack_expect_cachep __read_mostly;
-static unsigned int nf_conntrack_expect_next_id;
+struct kmem_cache *nf_ct_expect_cachep __read_mostly;
+static unsigned int nf_ct_expect_next_id;
 
 /* nf_conntrack_expect helper functions */
 void nf_ct_unlink_expect(struct nf_conntrack_expect *exp)
@@ -43,57 +43,57 @@ void nf_ct_unlink_expect(struct nf_conntrack_expect *exp)
 	list_del(&exp->list);
 	NF_CT_STAT_INC(expect_delete);
 	master_help->expecting--;
-	nf_conntrack_expect_put(exp);
+	nf_ct_expect_put(exp);
 }
 EXPORT_SYMBOL_GPL(nf_ct_unlink_expect);
 
-static void expectation_timed_out(unsigned long ul_expect)
+static void nf_ct_expectation_timed_out(unsigned long ul_expect)
 {
 	struct nf_conntrack_expect *exp = (void *)ul_expect;
 
 	write_lock_bh(&nf_conntrack_lock);
 	nf_ct_unlink_expect(exp);
 	write_unlock_bh(&nf_conntrack_lock);
-	nf_conntrack_expect_put(exp);
+	nf_ct_expect_put(exp);
 }
 
 struct nf_conntrack_expect *
-__nf_conntrack_expect_find(const struct nf_conntrack_tuple *tuple)
+__nf_ct_expect_find(const struct nf_conntrack_tuple *tuple)
 {
 	struct nf_conntrack_expect *i;
 
-	list_for_each_entry(i, &nf_conntrack_expect_list, list) {
+	list_for_each_entry(i, &nf_ct_expect_list, list) {
 		if (nf_ct_tuple_mask_cmp(tuple, &i->tuple, &i->mask))
 			return i;
 	}
 	return NULL;
 }
-EXPORT_SYMBOL_GPL(__nf_conntrack_expect_find);
+EXPORT_SYMBOL_GPL(__nf_ct_expect_find);
 
 /* Just find a expectation corresponding to a tuple. */
 struct nf_conntrack_expect *
-nf_conntrack_expect_find_get(const struct nf_conntrack_tuple *tuple)
+nf_ct_expect_find_get(const struct nf_conntrack_tuple *tuple)
 {
 	struct nf_conntrack_expect *i;
 
 	read_lock_bh(&nf_conntrack_lock);
-	i = __nf_conntrack_expect_find(tuple);
+	i = __nf_ct_expect_find(tuple);
 	if (i)
 		atomic_inc(&i->use);
 	read_unlock_bh(&nf_conntrack_lock);
 
 	return i;
 }
-EXPORT_SYMBOL_GPL(nf_conntrack_expect_find_get);
+EXPORT_SYMBOL_GPL(nf_ct_expect_find_get);
 
 /* If an expectation for this connection is found, it gets delete from
  * global list then returned. */
 struct nf_conntrack_expect *
-find_expectation(const struct nf_conntrack_tuple *tuple)
+nf_ct_find_expectation(const struct nf_conntrack_tuple *tuple)
 {
 	struct nf_conntrack_expect *exp;
 
-	exp = __nf_conntrack_expect_find(tuple);
+	exp = __nf_ct_expect_find(tuple);
 	if (!exp)
 		return NULL;
 
@@ -126,10 +126,10 @@ void nf_ct_remove_expectations(struct nf_conn *ct)
 	if (!help || help->expecting == 0)
 		return;
 
-	list_for_each_entry_safe(i, tmp, &nf_conntrack_expect_list, list) {
+	list_for_each_entry_safe(i, tmp, &nf_ct_expect_list, list) {
 		if (i->master == ct && del_timer(&i->timeout)) {
 			nf_ct_unlink_expect(i);
-			nf_conntrack_expect_put(i);
+			nf_ct_expect_put(i);
 		}
 	}
 }
@@ -172,32 +172,32 @@ static inline int expect_matches(const struct nf_conntrack_expect *a,
 }
 
 /* Generally a bad idea to call this: could have matched already. */
-void nf_conntrack_unexpect_related(struct nf_conntrack_expect *exp)
+void nf_ct_unexpect_related(struct nf_conntrack_expect *exp)
 {
 	struct nf_conntrack_expect *i;
 
 	write_lock_bh(&nf_conntrack_lock);
 	/* choose the oldest expectation to evict */
-	list_for_each_entry_reverse(i, &nf_conntrack_expect_list, list) {
+	list_for_each_entry_reverse(i, &nf_ct_expect_list, list) {
 		if (expect_matches(i, exp) && del_timer(&i->timeout)) {
 			nf_ct_unlink_expect(i);
 			write_unlock_bh(&nf_conntrack_lock);
-			nf_conntrack_expect_put(i);
+			nf_ct_expect_put(i);
 			return;
 		}
 	}
 	write_unlock_bh(&nf_conntrack_lock);
 }
-EXPORT_SYMBOL_GPL(nf_conntrack_unexpect_related);
+EXPORT_SYMBOL_GPL(nf_ct_unexpect_related);
 
 /* We don't increase the master conntrack refcount for non-fulfilled
  * conntracks. During the conntrack destruction, the expectations are
  * always killed before the conntrack itself */
-struct nf_conntrack_expect *nf_conntrack_expect_alloc(struct nf_conn *me)
+struct nf_conntrack_expect *nf_ct_expect_alloc(struct nf_conn *me)
 {
 	struct nf_conntrack_expect *new;
 
-	new = kmem_cache_alloc(nf_conntrack_expect_cachep, GFP_ATOMIC);
+	new = kmem_cache_alloc(nf_ct_expect_cachep, GFP_ATOMIC);
 	if (!new)
 		return NULL;
 
@@ -205,12 +205,12 @@ struct nf_conntrack_expect *nf_conntrack_expect_alloc(struct nf_conn *me)
 	atomic_set(&new->use, 1);
 	return new;
 }
-EXPORT_SYMBOL_GPL(nf_conntrack_expect_alloc);
+EXPORT_SYMBOL_GPL(nf_ct_expect_alloc);
 
-void nf_conntrack_expect_init(struct nf_conntrack_expect *exp, int family,
-			      union nf_conntrack_address *saddr,
-			      union nf_conntrack_address *daddr,
-			      u_int8_t proto, __be16 *src, __be16 *dst)
+void nf_ct_expect_init(struct nf_conntrack_expect *exp, int family,
+		       union nf_conntrack_address *saddr,
+		       union nf_conntrack_address *daddr,
+		       u_int8_t proto, __be16 *src, __be16 *dst)
 {
 	int len;
 
@@ -273,28 +273,29 @@ void nf_conntrack_expect_init(struct nf_conntrack_expect *exp, int family,
 		exp->mask.dst.u.all = 0;
 	}
 }
-EXPORT_SYMBOL_GPL(nf_conntrack_expect_init);
+EXPORT_SYMBOL_GPL(nf_ct_expect_init);
 
-void nf_conntrack_expect_put(struct nf_conntrack_expect *exp)
+void nf_ct_expect_put(struct nf_conntrack_expect *exp)
 {
 	if (atomic_dec_and_test(&exp->use))
-		kmem_cache_free(nf_conntrack_expect_cachep, exp);
+		kmem_cache_free(nf_ct_expect_cachep, exp);
 }
-EXPORT_SYMBOL_GPL(nf_conntrack_expect_put);
+EXPORT_SYMBOL_GPL(nf_ct_expect_put);
 
-static void nf_conntrack_expect_insert(struct nf_conntrack_expect *exp)
+static void nf_ct_expect_insert(struct nf_conntrack_expect *exp)
 {
 	struct nf_conn_help *master_help = nfct_help(exp->master);
 
 	atomic_inc(&exp->use);
 	master_help->expecting++;
-	list_add(&exp->list, &nf_conntrack_expect_list);
+	list_add(&exp->list, &nf_ct_expect_list);
 
-	setup_timer(&exp->timeout, expectation_timed_out, (unsigned long)exp);
+	setup_timer(&exp->timeout, nf_ct_expectation_timed_out,
+		    (unsigned long)exp);
 	exp->timeout.expires = jiffies + master_help->helper->timeout * HZ;
 	add_timer(&exp->timeout);
 
-	exp->id = ++nf_conntrack_expect_next_id;
+	exp->id = ++nf_ct_expect_next_id;
 	atomic_inc(&exp->use);
 	NF_CT_STAT_INC(expect_create);
 }
@@ -304,11 +305,11 @@ static void evict_oldest_expect(struct nf_conn *master)
 {
 	struct nf_conntrack_expect *i;
 
-	list_for_each_entry_reverse(i, &nf_conntrack_expect_list, list) {
+	list_for_each_entry_reverse(i, &nf_ct_expect_list, list) {
 		if (i->master == master) {
 			if (del_timer(&i->timeout)) {
 				nf_ct_unlink_expect(i);
-				nf_conntrack_expect_put(i);
+				nf_ct_expect_put(i);
 			}
 			break;
 		}
@@ -327,7 +328,7 @@ static inline int refresh_timer(struct nf_conntrack_expect *i)
 	return 1;
 }
 
-int nf_conntrack_expect_related(struct nf_conntrack_expect *expect)
+int nf_ct_expect_related(struct nf_conntrack_expect *expect)
 {
 	struct nf_conntrack_expect *i;
 	struct nf_conn *master = expect->master;
@@ -341,7 +342,7 @@ int nf_conntrack_expect_related(struct nf_conntrack_expect *expect)
 		ret = -ESHUTDOWN;
 		goto out;
 	}
-	list_for_each_entry(i, &nf_conntrack_expect_list, list) {
+	list_for_each_entry(i, &nf_ct_expect_list, list) {
 		if (expect_matches(i, expect)) {
 			/* Refresh timer: if it's dying, ignore.. */
 			if (refresh_timer(i)) {
@@ -358,19 +359,19 @@ int nf_conntrack_expect_related(struct nf_conntrack_expect *expect)
 	    master_help->expecting >= master_help->helper->max_expected)
 		evict_oldest_expect(master);
 
-	nf_conntrack_expect_insert(expect);
-	nf_conntrack_expect_event(IPEXP_NEW, expect);
+	nf_ct_expect_insert(expect);
+	nf_ct_expect_event(IPEXP_NEW, expect);
 	ret = 0;
 out:
 	write_unlock_bh(&nf_conntrack_lock);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(nf_conntrack_expect_related);
+EXPORT_SYMBOL_GPL(nf_ct_expect_related);
 
 #ifdef CONFIG_PROC_FS
 static void *exp_seq_start(struct seq_file *s, loff_t *pos)
 {
-	struct list_head *e = &nf_conntrack_expect_list;
+	struct list_head *e = &nf_ct_expect_list;
 	loff_t i;
 
 	/* strange seq_file api calls stop even if we fail,
@@ -382,7 +383,7 @@ static void *exp_seq_start(struct seq_file *s, loff_t *pos)
 
 	for (i = 0; i <= *pos; i++) {
 		e = e->next;
-		if (e == &nf_conntrack_expect_list)
+		if (e == &nf_ct_expect_list)
 			return NULL;
 	}
 	return e;
@@ -395,7 +396,7 @@ static void *exp_seq_next(struct seq_file *s, void *v, loff_t *pos)
 	++*pos;
 	e = e->next;
 
-	if (e == &nf_conntrack_expect_list)
+	if (e == &nf_ct_expect_list)
 		return NULL;
 
 	return e;
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 82db2aa..5efe65d 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -445,7 +445,7 @@ static int help(struct sk_buff **pskb,
 	       (int)matchlen, fb_ptr + matchoff,
 	       matchlen, ntohl(th->seq) + matchoff);
 
-	exp = nf_conntrack_expect_alloc(ct);
+	exp = nf_ct_expect_alloc(ct);
 	if (exp == NULL) {
 		ret = NF_DROP;
 		goto out;
@@ -523,14 +523,14 @@ static int help(struct sk_buff **pskb,
 				 matchoff, matchlen, exp);
 	else {
 		/* Can't expect this?  Best to drop packet now. */
-		if (nf_conntrack_expect_related(exp) != 0)
+		if (nf_ct_expect_related(exp) != 0)
 			ret = NF_DROP;
 		else
 			ret = NF_ACCEPT;
 	}
 
 out_put_expect:
-	nf_conntrack_expect_put(exp);
+	nf_ct_expect_put(exp);
 
 out_update_nl:
 	/* Now if this ends in \n, update ftp info.  Seq may have been
diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index a1b95ac..61ae90f 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -282,22 +282,22 @@ static int expect_rtp_rtcp(struct sk_buff **pskb, struct nf_conn *ct,
 	rtcp_port = htons(ntohs(port) + 1);
 
 	/* Create expect for RTP */
-	if ((rtp_exp = nf_conntrack_expect_alloc(ct)) == NULL)
+	if ((rtp_exp = nf_ct_expect_alloc(ct)) == NULL)
 		return -1;
-	nf_conntrack_expect_init(rtp_exp, ct->tuplehash[!dir].tuple.src.l3num,
-				 &ct->tuplehash[!dir].tuple.src.u3,
-				 &ct->tuplehash[!dir].tuple.dst.u3,
-				 IPPROTO_UDP, NULL, &rtp_port);
+	nf_ct_expect_init(rtp_exp, ct->tuplehash[!dir].tuple.src.l3num,
+			  &ct->tuplehash[!dir].tuple.src.u3,
+			  &ct->tuplehash[!dir].tuple.dst.u3,
+			  IPPROTO_UDP, NULL, &rtp_port);
 
 	/* Create expect for RTCP */
-	if ((rtcp_exp = nf_conntrack_expect_alloc(ct)) == NULL) {
-		nf_conntrack_expect_put(rtp_exp);
+	if ((rtcp_exp = nf_ct_expect_alloc(ct)) == NULL) {
+		nf_ct_expect_put(rtp_exp);
 		return -1;
 	}
-	nf_conntrack_expect_init(rtcp_exp, ct->tuplehash[!dir].tuple.src.l3num,
-				 &ct->tuplehash[!dir].tuple.src.u3,
-				 &ct->tuplehash[!dir].tuple.dst.u3,
-				 IPPROTO_UDP, NULL, &rtcp_port);
+	nf_ct_expect_init(rtcp_exp, ct->tuplehash[!dir].tuple.src.l3num,
+			  &ct->tuplehash[!dir].tuple.src.u3,
+			  &ct->tuplehash[!dir].tuple.dst.u3,
+			  IPPROTO_UDP, NULL, &rtcp_port);
 
 	if (memcmp(&ct->tuplehash[dir].tuple.src.u3,
 		   &ct->tuplehash[!dir].tuple.dst.u3,
@@ -308,22 +308,22 @@ static int expect_rtp_rtcp(struct sk_buff **pskb, struct nf_conn *ct,
 		ret = nat_rtp_rtcp(pskb, ct, ctinfo, data, dataoff,
 				   taddr, port, rtp_port, rtp_exp, rtcp_exp);
 	} else {		/* Conntrack only */
-		if (nf_conntrack_expect_related(rtp_exp) == 0) {
-			if (nf_conntrack_expect_related(rtcp_exp) == 0) {
+		if (nf_ct_expect_related(rtp_exp) == 0) {
+			if (nf_ct_expect_related(rtcp_exp) == 0) {
 				DEBUGP("nf_ct_h323: expect RTP ");
 				NF_CT_DUMP_TUPLE(&rtp_exp->tuple);
 				DEBUGP("nf_ct_h323: expect RTCP ");
 				NF_CT_DUMP_TUPLE(&rtcp_exp->tuple);
 			} else {
-				nf_conntrack_unexpect_related(rtp_exp);
+				nf_ct_unexpect_related(rtp_exp);
 				ret = -1;
 			}
 		} else
 			ret = -1;
 	}
 
-	nf_conntrack_expect_put(rtp_exp);
-	nf_conntrack_expect_put(rtcp_exp);
+	nf_ct_expect_put(rtp_exp);
+	nf_ct_expect_put(rtcp_exp);
 
 	return ret;
 }
@@ -349,12 +349,12 @@ static int expect_t120(struct sk_buff **pskb,
 		return 0;
 
 	/* Create expect for T.120 connections */
-	if ((exp = nf_conntrack_expect_alloc(ct)) == NULL)
+	if ((exp = nf_ct_expect_alloc(ct)) == NULL)
 		return -1;
-	nf_conntrack_expect_init(exp, ct->tuplehash[!dir].tuple.src.l3num,
-				 &ct->tuplehash[!dir].tuple.src.u3,
-				 &ct->tuplehash[!dir].tuple.dst.u3,
-				 IPPROTO_TCP, NULL, &port);
+	nf_ct_expect_init(exp, ct->tuplehash[!dir].tuple.src.l3num,
+			  &ct->tuplehash[!dir].tuple.src.u3,
+			  &ct->tuplehash[!dir].tuple.dst.u3,
+			  IPPROTO_TCP, NULL, &port);
 	exp->flags = NF_CT_EXPECT_PERMANENT;	/* Accept multiple channels */
 
 	if (memcmp(&ct->tuplehash[dir].tuple.src.u3,
@@ -366,14 +366,14 @@ static int expect_t120(struct sk_buff **pskb,
 		ret = nat_t120(pskb, ct, ctinfo, data, dataoff, taddr,
 			       port, exp);
 	} else {		/* Conntrack only */
-		if (nf_conntrack_expect_related(exp) == 0) {
+		if (nf_ct_expect_related(exp) == 0) {
 			DEBUGP("nf_ct_h323: expect T.120 ");
 			NF_CT_DUMP_TUPLE(&exp->tuple);
 		} else
 			ret = -1;
 	}
 
-	nf_conntrack_expect_put(exp);
+	nf_ct_expect_put(exp);
 
 	return ret;
 }
@@ -684,12 +684,12 @@ static int expect_h245(struct sk_buff **pskb, struct nf_conn *ct,
 		return 0;
 
 	/* Create expect for h245 connection */
-	if ((exp = nf_conntrack_expect_alloc(ct)) == NULL)
+	if ((exp = nf_ct_expect_alloc(ct)) == NULL)
 		return -1;
-	nf_conntrack_expect_init(exp, ct->tuplehash[!dir].tuple.src.l3num,
-				 &ct->tuplehash[!dir].tuple.src.u3,
-				 &ct->tuplehash[!dir].tuple.dst.u3,
-				 IPPROTO_TCP, NULL, &port);
+	nf_ct_expect_init(exp, ct->tuplehash[!dir].tuple.src.l3num,
+			  &ct->tuplehash[!dir].tuple.src.u3,
+			  &ct->tuplehash[!dir].tuple.dst.u3,
+			  IPPROTO_TCP, NULL, &port);
 	exp->helper = &nf_conntrack_helper_h245;
 
 	if (memcmp(&ct->tuplehash[dir].tuple.src.u3,
@@ -701,14 +701,14 @@ static int expect_h245(struct sk_buff **pskb, struct nf_conn *ct,
 		ret = nat_h245(pskb, ct, ctinfo, data, dataoff, taddr,
 			       port, exp);
 	} else {		/* Conntrack only */
-		if (nf_conntrack_expect_related(exp) == 0) {
+		if (nf_ct_expect_related(exp) == 0) {
 			DEBUGP("nf_ct_q931: expect H.245 ");
 			NF_CT_DUMP_TUPLE(&exp->tuple);
 		} else
 			ret = -1;
 	}
 
-	nf_conntrack_expect_put(exp);
+	nf_ct_expect_put(exp);
 
 	return ret;
 }
@@ -796,11 +796,11 @@ static int expect_callforwarding(struct sk_buff **pskb,
 	}
 
 	/* Create expect for the second call leg */
-	if ((exp = nf_conntrack_expect_alloc(ct)) == NULL)
+	if ((exp = nf_ct_expect_alloc(ct)) == NULL)
 		return -1;
-	nf_conntrack_expect_init(exp, ct->tuplehash[!dir].tuple.src.l3num,
-				 &ct->tuplehash[!dir].tuple.src.u3, &addr,
-				 IPPROTO_TCP, NULL, &port);
+	nf_ct_expect_init(exp, ct->tuplehash[!dir].tuple.src.l3num,
+			  &ct->tuplehash[!dir].tuple.src.u3, &addr,
+			  IPPROTO_TCP, NULL, &port);
 	exp->helper = nf_conntrack_helper_q931;
 
 	if (memcmp(&ct->tuplehash[dir].tuple.src.u3,
@@ -812,14 +812,14 @@ static int expect_callforwarding(struct sk_buff **pskb,
 		ret = nat_callforwarding(pskb, ct, ctinfo, data, dataoff,
 					 taddr, port, exp);
 	} else {		/* Conntrack only */
-		if (nf_conntrack_expect_related(exp) == 0) {
+		if (nf_ct_expect_related(exp) == 0) {
 			DEBUGP("nf_ct_q931: expect Call Forwarding ");
 			NF_CT_DUMP_TUPLE(&exp->tuple);
 		} else
 			ret = -1;
 	}
 
-	nf_conntrack_expect_put(exp);
+	nf_ct_expect_put(exp);
 
 	return ret;
 }
@@ -1225,7 +1225,7 @@ static struct nf_conntrack_expect *find_expect(struct nf_conn *ct,
 	tuple.dst.u.tcp.port = port;
 	tuple.dst.protonum = IPPROTO_TCP;
 
-	exp = __nf_conntrack_expect_find(&tuple);
+	exp = __nf_ct_expect_find(&tuple);
 	if (exp && exp->master == ct)
 		return exp;
 	return NULL;
@@ -1271,14 +1271,13 @@ static int expect_q931(struct sk_buff **pskb, struct nf_conn *ct,
 		return 0;
 
 	/* Create expect for Q.931 */
-	if ((exp = nf_conntrack_expect_alloc(ct)) == NULL)
+	if ((exp = nf_ct_expect_alloc(ct)) == NULL)
 		return -1;
-	nf_conntrack_expect_init(exp, ct->tuplehash[!dir].tuple.src.l3num,
-				 gkrouted_only ? /* only accept calls from GK? */
-					&ct->tuplehash[!dir].tuple.src.u3 :
-					NULL,
-				 &ct->tuplehash[!dir].tuple.dst.u3,
-				 IPPROTO_TCP, NULL, &port);
+	nf_ct_expect_init(exp, ct->tuplehash[!dir].tuple.src.l3num,
+			  gkrouted_only ? /* only accept calls from GK? */
+				&ct->tuplehash[!dir].tuple.src.u3 : NULL,
+			  &ct->tuplehash[!dir].tuple.dst.u3,
+			  IPPROTO_TCP, NULL, &port);
 	exp->helper = nf_conntrack_helper_q931;
 	exp->flags = NF_CT_EXPECT_PERMANENT;	/* Accept multiple calls */
 
@@ -1286,7 +1285,7 @@ static int expect_q931(struct sk_buff **pskb, struct nf_conn *ct,
 	if (nat_q931 && ct->status & IPS_NAT_MASK) {	/* Need NAT */
 		ret = nat_q931(pskb, ct, ctinfo, data, taddr, i, port, exp);
 	} else {		/* Conntrack only */
-		if (nf_conntrack_expect_related(exp) == 0) {
+		if (nf_ct_expect_related(exp) == 0) {
 			DEBUGP("nf_ct_ras: expect Q.931 ");
 			NF_CT_DUMP_TUPLE(&exp->tuple);
 
@@ -1296,7 +1295,7 @@ static int expect_q931(struct sk_buff **pskb, struct nf_conn *ct,
 			ret = -1;
 	}
 
-	nf_conntrack_expect_put(exp);
+	nf_ct_expect_put(exp);
 
 	return ret;
 }
@@ -1343,20 +1342,20 @@ static int process_gcf(struct sk_buff **pskb, struct nf_conn *ct,
 		return 0;
 
 	/* Need new expect */
-	if ((exp = nf_conntrack_expect_alloc(ct)) == NULL)
+	if ((exp = nf_ct_expect_alloc(ct)) == NULL)
 		return -1;
-	nf_conntrack_expect_init(exp, ct->tuplehash[!dir].tuple.src.l3num,
-				 &ct->tuplehash[!dir].tuple.src.u3, &addr,
-				 IPPROTO_UDP, NULL, &port);
+	nf_ct_expect_init(exp, ct->tuplehash[!dir].tuple.src.l3num,
+			  &ct->tuplehash[!dir].tuple.src.u3, &addr,
+			  IPPROTO_UDP, NULL, &port);
 	exp->helper = nf_conntrack_helper_ras;
 
-	if (nf_conntrack_expect_related(exp) == 0) {
+	if (nf_ct_expect_related(exp) == 0) {
 		DEBUGP("nf_ct_ras: expect RAS ");
 		NF_CT_DUMP_TUPLE(&exp->tuple);
 	} else
 		ret = -1;
 
-	nf_conntrack_expect_put(exp);
+	nf_ct_expect_put(exp);
 
 	return ret;
 }
@@ -1548,21 +1547,21 @@ static int process_acf(struct sk_buff **pskb, struct nf_conn *ct,
 	}
 
 	/* Need new expect */
-	if ((exp = nf_conntrack_expect_alloc(ct)) == NULL)
+	if ((exp = nf_ct_expect_alloc(ct)) == NULL)
 		return -1;
-	nf_conntrack_expect_init(exp, ct->tuplehash[!dir].tuple.src.l3num,
-				 &ct->tuplehash[!dir].tuple.src.u3, &addr,
-				 IPPROTO_TCP, NULL, &port);
+	nf_ct_expect_init(exp, ct->tuplehash[!dir].tuple.src.l3num,
+			  &ct->tuplehash[!dir].tuple.src.u3, &addr,
+			  IPPROTO_TCP, NULL, &port);
 	exp->flags = NF_CT_EXPECT_PERMANENT;
 	exp->helper = nf_conntrack_helper_q931;
 
-	if (nf_conntrack_expect_related(exp) == 0) {
+	if (nf_ct_expect_related(exp) == 0) {
 		DEBUGP("nf_ct_ras: expect Q.931 ");
 		NF_CT_DUMP_TUPLE(&exp->tuple);
 	} else
 		ret = -1;
 
-	nf_conntrack_expect_put(exp);
+	nf_ct_expect_put(exp);
 
 	return ret;
 }
@@ -1601,21 +1600,21 @@ static int process_lcf(struct sk_buff **pskb, struct nf_conn *ct,
 		return 0;
 
 	/* Need new expect for call signal */
-	if ((exp = nf_conntrack_expect_alloc(ct)) == NULL)
+	if ((exp = nf_ct_expect_alloc(ct)) == NULL)
 		return -1;
-	nf_conntrack_expect_init(exp, ct->tuplehash[!dir].tuple.src.l3num,
-				 &ct->tuplehash[!dir].tuple.src.u3, &addr,
-				 IPPROTO_TCP, NULL, &port);
+	nf_ct_expect_init(exp, ct->tuplehash[!dir].tuple.src.l3num,
+			  &ct->tuplehash[!dir].tuple.src.u3, &addr,
+			  IPPROTO_TCP, NULL, &port);
 	exp->flags = NF_CT_EXPECT_PERMANENT;
 	exp->helper = nf_conntrack_helper_q931;
 
-	if (nf_conntrack_expect_related(exp) == 0) {
+	if (nf_ct_expect_related(exp) == 0) {
 		DEBUGP("nf_ct_ras: expect Q.931 ");
 		NF_CT_DUMP_TUPLE(&exp->tuple);
 	} else
 		ret = -1;
 
-	nf_conntrack_expect_put(exp);
+	nf_ct_expect_put(exp);
 
 	/* Ignore rasAddress */
 
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 3fc6e9f..89a5f73 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -123,12 +123,12 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
 	list_del(&me->list);
 
 	/* Get rid of expectations */
-	list_for_each_entry_safe(exp, tmp, &nf_conntrack_expect_list, list) {
+	list_for_each_entry_safe(exp, tmp, &nf_ct_expect_list, list) {
 		struct nf_conn_help *help = nfct_help(exp->master);
 		if ((help->helper == me || exp->helper == me) &&
 		    del_timer(&exp->timeout)) {
 			nf_ct_unlink_expect(exp);
-			nf_conntrack_expect_put(exp);
+			nf_ct_expect_put(exp);
 		}
 	}
 
diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index 43ccd0e..79da93e 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -184,16 +184,16 @@ static int help(struct sk_buff **pskb, unsigned int protoff,
 				continue;
 			}
 
-			exp = nf_conntrack_expect_alloc(ct);
+			exp = nf_ct_expect_alloc(ct);
 			if (exp == NULL) {
 				ret = NF_DROP;
 				goto out;
 			}
 			tuple = &ct->tuplehash[!dir].tuple;
 			port = htons(dcc_port);
-			nf_conntrack_expect_init(exp, tuple->src.l3num,
-						 NULL, &tuple->dst.u3,
-						 IPPROTO_TCP, NULL, &port);
+			nf_ct_expect_init(exp, tuple->src.l3num,
+					  NULL, &tuple->dst.u3,
+					  IPPROTO_TCP, NULL, &port);
 
 			nf_nat_irc = rcu_dereference(nf_nat_irc_hook);
 			if (nf_nat_irc && ct->status & IPS_NAT_MASK)
@@ -201,9 +201,9 @@ static int help(struct sk_buff **pskb, unsigned int protoff,
 						 addr_beg_p - ib_ptr,
 						 addr_end_p - addr_beg_p,
 						 exp);
-			else if (nf_conntrack_expect_related(exp) != 0)
+			else if (nf_ct_expect_related(exp) != 0)
 				ret = NF_DROP;
-			nf_conntrack_expect_put(exp);
+			nf_ct_expect_put(exp);
 			goto out;
 		}
 	}
diff --git a/net/netfilter/nf_conntrack_netbios_ns.c b/net/netfilter/nf_conntrack_netbios_ns.c
index 1093478..ea585c7 100644
--- a/net/netfilter/nf_conntrack_netbios_ns.c
+++ b/net/netfilter/nf_conntrack_netbios_ns.c
@@ -74,7 +74,7 @@ static int help(struct sk_buff **pskb, unsigned int protoff,
 	if (mask == 0)
 		goto out;
 
-	exp = nf_conntrack_expect_alloc(ct);
+	exp = nf_ct_expect_alloc(ct);
 	if (exp == NULL)
 		goto out;
 
@@ -91,8 +91,8 @@ static int help(struct sk_buff **pskb, unsigned int protoff,
 	exp->flags                = NF_CT_EXPECT_PERMANENT;
 	exp->helper               = NULL;
 
-	nf_conntrack_expect_related(exp);
-	nf_conntrack_expect_put(exp);
+	nf_ct_expect_related(exp);
+	nf_ct_expect_put(exp);
 
 	nf_ct_refresh(ct, *pskb, timeout * HZ);
 out:
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index d310ec8..954cc58 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1239,7 +1239,7 @@ ctnetlink_exp_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 	u_int8_t l3proto = nfmsg->nfgen_family;
 
 	read_lock_bh(&nf_conntrack_lock);
-	list_for_each_prev(i, &nf_conntrack_expect_list) {
+	list_for_each_prev(i, &nf_ct_expect_list) {
 		exp = (struct nf_conntrack_expect *) i;
 		if (l3proto && exp->tuple.src.l3num != l3proto)
 			continue;
@@ -1291,14 +1291,14 @@ ctnetlink_get_expect(struct sock *ctnl, struct sk_buff *skb,
 	if (err < 0)
 		return err;
 
-	exp = nf_conntrack_expect_find_get(&tuple);
+	exp = nf_ct_expect_find_get(&tuple);
 	if (!exp)
 		return -ENOENT;
 
 	if (cda[CTA_EXPECT_ID-1]) {
 		__be32 id = *(__be32 *)NFA_DATA(cda[CTA_EXPECT_ID-1]);
 		if (exp->id != ntohl(id)) {
-			nf_conntrack_expect_put(exp);
+			nf_ct_expect_put(exp);
 			return -ENOENT;
 		}
 	}
@@ -1314,14 +1314,14 @@ ctnetlink_get_expect(struct sock *ctnl, struct sk_buff *skb,
 	if (err <= 0)
 		goto free;
 
-	nf_conntrack_expect_put(exp);
+	nf_ct_expect_put(exp);
 
 	return netlink_unicast(ctnl, skb2, NETLINK_CB(skb).pid, MSG_DONTWAIT);
 
 free:
 	kfree_skb(skb2);
 out:
-	nf_conntrack_expect_put(exp);
+	nf_ct_expect_put(exp);
 	return err;
 }
 
@@ -1346,23 +1346,23 @@ ctnetlink_del_expect(struct sock *ctnl, struct sk_buff *skb,
 			return err;
 
 		/* bump usage count to 2 */
-		exp = nf_conntrack_expect_find_get(&tuple);
+		exp = nf_ct_expect_find_get(&tuple);
 		if (!exp)
 			return -ENOENT;
 
 		if (cda[CTA_EXPECT_ID-1]) {
 			__be32 id = *(__be32 *)NFA_DATA(cda[CTA_EXPECT_ID-1]);
 			if (exp->id != ntohl(id)) {
-				nf_conntrack_expect_put(exp);
+				nf_ct_expect_put(exp);
 				return -ENOENT;
 			}
 		}
 
 		/* after list removal, usage count == 1 */
-		nf_conntrack_unexpect_related(exp);
+		nf_ct_unexpect_related(exp);
 		/* have to put what we 'get' above.
 		 * after this line usage count == 0 */
-		nf_conntrack_expect_put(exp);
+		nf_ct_expect_put(exp);
 	} else if (cda[CTA_EXPECT_HELP_NAME-1]) {
 		char *name = NFA_DATA(cda[CTA_EXPECT_HELP_NAME-1]);
 
@@ -1373,24 +1373,22 @@ ctnetlink_del_expect(struct sock *ctnl, struct sk_buff *skb,
 			write_unlock_bh(&nf_conntrack_lock);
 			return -EINVAL;
 		}
-		list_for_each_entry_safe(exp, tmp, &nf_conntrack_expect_list,
-					 list) {
+		list_for_each_entry_safe(exp, tmp, &nf_ct_expect_list, list) {
 			struct nf_conn_help *m_help = nfct_help(exp->master);
 			if (m_help->helper == h
 			    && del_timer(&exp->timeout)) {
 				nf_ct_unlink_expect(exp);
-				nf_conntrack_expect_put(exp);
+				nf_ct_expect_put(exp);
 			}
 		}
 		write_unlock_bh(&nf_conntrack_lock);
 	} else {
 		/* This basically means we have to flush everything*/
 		write_lock_bh(&nf_conntrack_lock);
-		list_for_each_entry_safe(exp, tmp, &nf_conntrack_expect_list,
-					 list) {
+		list_for_each_entry_safe(exp, tmp, &nf_ct_expect_list, list) {
 			if (del_timer(&exp->timeout)) {
 				nf_ct_unlink_expect(exp);
-				nf_conntrack_expect_put(exp);
+				nf_ct_expect_put(exp);
 			}
 		}
 		write_unlock_bh(&nf_conntrack_lock);
@@ -1438,7 +1436,7 @@ ctnetlink_create_expect(struct nfattr *cda[], u_int8_t u3)
 		goto out;
 	}
 
-	exp = nf_conntrack_expect_alloc(ct);
+	exp = nf_ct_expect_alloc(ct);
 	if (!exp) {
 		err = -ENOMEM;
 		goto out;
@@ -1451,8 +1449,8 @@ ctnetlink_create_expect(struct nfattr *cda[], u_int8_t u3)
 	memcpy(&exp->tuple, &tuple, sizeof(struct nf_conntrack_tuple));
 	memcpy(&exp->mask, &mask, sizeof(struct nf_conntrack_tuple));
 
-	err = nf_conntrack_expect_related(exp);
-	nf_conntrack_expect_put(exp);
+	err = nf_ct_expect_related(exp);
+	nf_ct_expect_put(exp);
 
 out:
 	nf_ct_put(nf_ct_tuplehash_to_ctrack(h));
@@ -1482,7 +1480,7 @@ ctnetlink_new_expect(struct sock *ctnl, struct sk_buff *skb,
 		return err;
 
 	write_lock_bh(&nf_conntrack_lock);
-	exp = __nf_conntrack_expect_find(&tuple);
+	exp = __nf_ct_expect_find(&tuple);
 
 	if (!exp) {
 		write_unlock_bh(&nf_conntrack_lock);
@@ -1572,7 +1570,7 @@ static int __init ctnetlink_init(void)
 		goto err_unreg_exp_subsys;
 	}
 
-	ret = nf_conntrack_expect_register_notifier(&ctnl_notifier_exp);
+	ret = nf_ct_expect_register_notifier(&ctnl_notifier_exp);
 	if (ret < 0) {
 		printk("ctnetlink_init: cannot expect register notifier.\n");
 		goto err_unreg_notifier;
@@ -1598,7 +1596,7 @@ static void __exit ctnetlink_exit(void)
 	printk("ctnetlink: unregistering from nfnetlink.\n");
 
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
-	nf_conntrack_expect_unregister_notifier(&ctnl_notifier_exp);
+	nf_ct_expect_unregister_notifier(&ctnl_notifier_exp);
 	nf_conntrack_unregister_notifier(&ctnl_notifier);
 #endif
 
diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index da36c48..916e106 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -124,12 +124,12 @@ static void pptp_expectfn(struct nf_conn *ct,
 		DEBUGP("trying to unexpect other dir: ");
 		NF_CT_DUMP_TUPLE(&inv_t);
 
-		exp_other = nf_conntrack_expect_find_get(&inv_t);
+		exp_other = nf_ct_expect_find_get(&inv_t);
 		if (exp_other) {
 			/* delete other expectation.  */
 			DEBUGP("found\n");
-			nf_conntrack_unexpect_related(exp_other);
-			nf_conntrack_expect_put(exp_other);
+			nf_ct_unexpect_related(exp_other);
+			nf_ct_expect_put(exp_other);
 		} else {
 			DEBUGP("not found\n");
 		}
@@ -157,11 +157,11 @@ static int destroy_sibling_or_exp(const struct nf_conntrack_tuple *t)
 		nf_ct_put(sibling);
 		return 1;
 	} else {
-		exp = nf_conntrack_expect_find_get(t);
+		exp = nf_ct_expect_find_get(t);
 		if (exp) {
 			DEBUGP("unexpect_related of expect %p\n", exp);
-			nf_conntrack_unexpect_related(exp);
-			nf_conntrack_expect_put(exp);
+			nf_ct_unexpect_related(exp);
+			nf_ct_expect_put(exp);
 			return 1;
 		}
 	}
@@ -201,36 +201,36 @@ static int exp_gre(struct nf_conn *ct, __be16 callid, __be16 peer_callid)
 	int ret = 1;
 	typeof(nf_nat_pptp_hook_exp_gre) nf_nat_pptp_exp_gre;
 
-	exp_orig = nf_conntrack_expect_alloc(ct);
+	exp_orig = nf_ct_expect_alloc(ct);
 	if (exp_orig == NULL)
 		goto out;
 
-	exp_reply = nf_conntrack_expect_alloc(ct);
+	exp_reply = nf_ct_expect_alloc(ct);
 	if (exp_reply == NULL)
 		goto out_put_orig;
 
 	/* original direction, PNS->PAC */
 	dir = IP_CT_DIR_ORIGINAL;
-	nf_conntrack_expect_init(exp_orig, ct->tuplehash[dir].tuple.src.l3num,
-				 &ct->tuplehash[dir].tuple.src.u3,
-				 &ct->tuplehash[dir].tuple.dst.u3,
-				 IPPROTO_GRE, &peer_callid, &callid);
+	nf_ct_expect_init(exp_orig, ct->tuplehash[dir].tuple.src.l3num,
+			  &ct->tuplehash[dir].tuple.src.u3,
+			  &ct->tuplehash[dir].tuple.dst.u3,
+			  IPPROTO_GRE, &peer_callid, &callid);
 	exp_orig->expectfn = pptp_expectfn;
 
 	/* reply direction, PAC->PNS */
 	dir = IP_CT_DIR_REPLY;
-	nf_conntrack_expect_init(exp_reply, ct->tuplehash[dir].tuple.src.l3num,
-				 &ct->tuplehash[dir].tuple.src.u3,
-				 &ct->tuplehash[dir].tuple.dst.u3,
-				 IPPROTO_GRE, &callid, &peer_callid);
+	nf_ct_expect_init(exp_reply, ct->tuplehash[dir].tuple.src.l3num,
+			  &ct->tuplehash[dir].tuple.src.u3,
+			  &ct->tuplehash[dir].tuple.dst.u3,
+			  IPPROTO_GRE, &callid, &peer_callid);
 	exp_reply->expectfn = pptp_expectfn;
 
 	nf_nat_pptp_exp_gre = rcu_dereference(nf_nat_pptp_hook_exp_gre);
 	if (nf_nat_pptp_exp_gre && ct->status & IPS_NAT_MASK)
 		nf_nat_pptp_exp_gre(exp_orig, exp_reply);
-	if (nf_conntrack_expect_related(exp_orig) != 0)
+	if (nf_ct_expect_related(exp_orig) != 0)
 		goto out_put_both;
-	if (nf_conntrack_expect_related(exp_reply) != 0)
+	if (nf_ct_expect_related(exp_reply) != 0)
 		goto out_unexpect_orig;
 
 	/* Add GRE keymap entries */
@@ -243,16 +243,16 @@ static int exp_gre(struct nf_conn *ct, __be16 callid, __be16 peer_callid)
 	ret = 0;
 
 out_put_both:
-	nf_conntrack_expect_put(exp_reply);
+	nf_ct_expect_put(exp_reply);
 out_put_orig:
-	nf_conntrack_expect_put(exp_orig);
+	nf_ct_expect_put(exp_orig);
 out:
 	return ret;
 
 out_unexpect_both:
-	nf_conntrack_unexpect_related(exp_reply);
+	nf_ct_unexpect_related(exp_reply);
 out_unexpect_orig:
-	nf_conntrack_unexpect_related(exp_orig);
+	nf_ct_unexpect_related(exp_orig);
 	goto out_put_both;
 }
 
diff --git a/net/netfilter/nf_conntrack_sane.c b/net/netfilter/nf_conntrack_sane.c
index eb2d1dc..28ed303 100644
--- a/net/netfilter/nf_conntrack_sane.c
+++ b/net/netfilter/nf_conntrack_sane.c
@@ -141,27 +141,25 @@ static int help(struct sk_buff **pskb,
 	if (reply->zero != 0)
 		goto out;
 
-	exp = nf_conntrack_expect_alloc(ct);
+	exp = nf_ct_expect_alloc(ct);
 	if (exp == NULL) {
 		ret = NF_DROP;
 		goto out;
 	}
 
 	tuple = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
-	nf_conntrack_expect_init(exp, family,
-				 &tuple->src.u3, &tuple->dst.u3,
-				 IPPROTO_TCP,
-				 NULL, &reply->port);
+	nf_ct_expect_init(exp, family, &tuple->src.u3, &tuple->dst.u3,
+			  IPPROTO_TCP, NULL, &reply->port);
 
 	DEBUGP("nf_ct_sane: expect: ");
 	NF_CT_DUMP_TUPLE(&exp->tuple);
 	NF_CT_DUMP_TUPLE(&exp->mask);
 
 	/* Can't expect this?  Best to drop packet now. */
-	if (nf_conntrack_expect_related(exp) != 0)
+	if (nf_ct_expect_related(exp) != 0)
 		ret = NF_DROP;
 
-	nf_conntrack_expect_put(exp);
+	nf_ct_expect_put(exp);
 
 out:
 	spin_unlock_bh(&nf_sane_lock);
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 1b5c6c1..1f17f80 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -378,23 +378,23 @@ static int set_expected_rtp(struct sk_buff **pskb,
 	int ret;
 	typeof(nf_nat_sdp_hook) nf_nat_sdp;
 
-	exp = nf_conntrack_expect_alloc(ct);
+	exp = nf_ct_expect_alloc(ct);
 	if (exp == NULL)
 		return NF_DROP;
-	nf_conntrack_expect_init(exp, family,
-				 &ct->tuplehash[!dir].tuple.src.u3, addr,
-				 IPPROTO_UDP, NULL, &port);
+	nf_ct_expect_init(exp, family,
+			  &ct->tuplehash[!dir].tuple.src.u3, addr,
+			  IPPROTO_UDP, NULL, &port);
 
 	nf_nat_sdp = rcu_dereference(nf_nat_sdp_hook);
 	if (nf_nat_sdp && ct->status & IPS_NAT_MASK)
 		ret = nf_nat_sdp(pskb, ctinfo, exp, dptr);
 	else {
-		if (nf_conntrack_expect_related(exp) != 0)
+		if (nf_ct_expect_related(exp) != 0)
 			ret = NF_DROP;
 		else
 			ret = NF_ACCEPT;
 	}
-	nf_conntrack_expect_put(exp);
+	nf_ct_expect_put(exp);
 
 	return ret;
 }
diff --git a/net/netfilter/nf_conntrack_tftp.c b/net/netfilter/nf_conntrack_tftp.c
index 37c4542..53d57b4 100644
--- a/net/netfilter/nf_conntrack_tftp.c
+++ b/net/netfilter/nf_conntrack_tftp.c
@@ -66,14 +66,12 @@ static int tftp_help(struct sk_buff **pskb,
 		NF_CT_DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
 		NF_CT_DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
 
-		exp = nf_conntrack_expect_alloc(ct);
+		exp = nf_ct_expect_alloc(ct);
 		if (exp == NULL)
 			return NF_DROP;
 		tuple = &ct->tuplehash[IP_CT_DIR_REPLY].tuple;
-		nf_conntrack_expect_init(exp, family,
-					 &tuple->src.u3, &tuple->dst.u3,
-					 IPPROTO_UDP,
-					 NULL, &tuple->dst.u.udp.port);
+		nf_ct_expect_init(exp, family, &tuple->src.u3, &tuple->dst.u3,
+				  IPPROTO_UDP, NULL, &tuple->dst.u.udp.port);
 
 		DEBUGP("expect: ");
 		NF_CT_DUMP_TUPLE(&exp->tuple);
@@ -82,9 +80,9 @@ static int tftp_help(struct sk_buff **pskb,
 		nf_nat_tftp = rcu_dereference(nf_nat_tftp_hook);
 		if (nf_nat_tftp && ct->status & IPS_NAT_MASK)
 			ret = nf_nat_tftp(pskb, ctinfo, exp);
-		else if (nf_conntrack_expect_related(exp) != 0)
+		else if (nf_ct_expect_related(exp) != 0)
 			ret = NF_DROP;
-		nf_conntrack_expect_put(exp);
+		nf_ct_expect_put(exp);
 		break;
 	case TFTP_OPCODE_DATA:
 	case TFTP_OPCODE_ACK:
