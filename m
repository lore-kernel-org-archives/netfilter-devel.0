From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 19/20] ipvs: add full ipv6 support to nfct
Date: Sat,  2 Jun 2018 02:22:58 +0200
Message-ID: <20180602002259.4024-20-pablo@netfilter.org>
References: <20180602002259.4024-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180602002259.4024-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Julian Anastasov <ja@ssi.bg>

Prepare NFCT to support IPv6 for FTP:

- Do not restrict the expectation callback to PF_INET

- Split the debug messages, so that the 160-byte limitation
in IP_VS_DBG_BUF is not exceeded when printing many IPv6
addresses. This means no more than 3 addresses in one message,
i.e. 1 tuple with 2 addresses or 1 connection with 3 addresses.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_nfct.c | 101 +++++++++++++++++++---------------------
 1 file changed, 49 insertions(+), 52 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_nfct.c b/net/netfilter/ipvs/ip_vs_nfct.c
index 6cf3fd81a5ec..eb8b9c883889 100644
--- a/net/netfilter/ipvs/ip_vs_nfct.c
+++ b/net/netfilter/ipvs/ip_vs_nfct.c
@@ -67,15 +67,20 @@
 #include <net/netfilter/nf_conntrack_zones.h>
 
 
-#define FMT_TUPLE	"%pI4:%u->%pI4:%u/%u"
-#define ARG_TUPLE(T)	&(T)->src.u3.ip, ntohs((T)->src.u.all), \
-			&(T)->dst.u3.ip, ntohs((T)->dst.u.all), \
+#define FMT_TUPLE	"%s:%u->%s:%u/%u"
+#define ARG_TUPLE(T)	IP_VS_DBG_ADDR((T)->src.l3num, &(T)->src.u3),	\
+			ntohs((T)->src.u.all),				\
+			IP_VS_DBG_ADDR((T)->src.l3num, &(T)->dst.u3),	\
+			ntohs((T)->dst.u.all),				\
 			(T)->dst.protonum
 
-#define FMT_CONN	"%pI4:%u->%pI4:%u->%pI4:%u/%u:%u"
-#define ARG_CONN(C)	&((C)->caddr.ip), ntohs((C)->cport), \
-			&((C)->vaddr.ip), ntohs((C)->vport), \
-			&((C)->daddr.ip), ntohs((C)->dport), \
+#define FMT_CONN	"%s:%u->%s:%u->%s:%u/%u:%u"
+#define ARG_CONN(C)	IP_VS_DBG_ADDR((C)->af, &((C)->caddr)),		\
+			ntohs((C)->cport),				\
+			IP_VS_DBG_ADDR((C)->af, &((C)->vaddr)),		\
+			ntohs((C)->vport),				\
+			IP_VS_DBG_ADDR((C)->daf, &((C)->daddr)),	\
+			ntohs((C)->dport),				\
 			(C)->protocol, (C)->state
 
 void
@@ -127,13 +132,17 @@ ip_vs_update_conntrack(struct sk_buff *skb, struct ip_vs_conn *cp, int outin)
 		    new_tuple.dst.protonum != IPPROTO_ICMPV6)
 			new_tuple.dst.u.tcp.port = cp->vport;
 	}
-	IP_VS_DBG(7, "%s: Updating conntrack ct=%p, status=0x%lX, "
-		  "ctinfo=%d, old reply=" FMT_TUPLE
-		  ", new reply=" FMT_TUPLE ", cp=" FMT_CONN "\n",
-		  __func__, ct, ct->status, ctinfo,
-		  ARG_TUPLE(&ct->tuplehash[IP_CT_DIR_REPLY].tuple),
-		  ARG_TUPLE(&new_tuple), ARG_CONN(cp));
+	IP_VS_DBG_BUF(7, "%s: Updating conntrack ct=%p, status=0x%lX, "
+		      "ctinfo=%d, old reply=" FMT_TUPLE "\n",
+		      __func__, ct, ct->status, ctinfo,
+		      ARG_TUPLE(&ct->tuplehash[IP_CT_DIR_REPLY].tuple));
+	IP_VS_DBG_BUF(7, "%s: Updating conntrack ct=%p, status=0x%lX, "
+		      "ctinfo=%d, new reply=" FMT_TUPLE "\n",
+		      __func__, ct, ct->status, ctinfo,
+		      ARG_TUPLE(&new_tuple));
 	nf_conntrack_alter_reply(ct, &new_tuple);
+	IP_VS_DBG_BUF(7, "%s: Updated conntrack ct=%p for cp=" FMT_CONN "\n",
+		      __func__, ct, ARG_CONN(cp));
 }
 
 int ip_vs_confirm_conntrack(struct sk_buff *skb)
@@ -152,9 +161,6 @@ static void ip_vs_nfct_expect_callback(struct nf_conn *ct,
 	struct ip_vs_conn_param p;
 	struct net *net = nf_ct_net(ct);
 
-	if (exp->tuple.src.l3num != PF_INET)
-		return;
-
 	/*
 	 * We assume that no NF locks are held before this callback.
 	 * ip_vs_conn_out_get and ip_vs_conn_in_get should match their
@@ -171,19 +177,15 @@ static void ip_vs_nfct_expect_callback(struct nf_conn *ct,
 	cp = ip_vs_conn_out_get(&p);
 	if (cp) {
 		/* Change reply CLIENT->RS to CLIENT->VS */
+		IP_VS_DBG_BUF(7, "%s: for ct=%p, status=0x%lX found inout cp="
+			      FMT_CONN "\n",
+			      __func__, ct, ct->status, ARG_CONN(cp));
 		new_reply = ct->tuplehash[IP_CT_DIR_REPLY].tuple;
-		IP_VS_DBG(7, "%s: ct=%p, status=0x%lX, tuples=" FMT_TUPLE ", "
-			  FMT_TUPLE ", found inout cp=" FMT_CONN "\n",
-			  __func__, ct, ct->status,
-			  ARG_TUPLE(orig), ARG_TUPLE(&new_reply),
-			  ARG_CONN(cp));
+		IP_VS_DBG_BUF(7, "%s: ct=%p before alter: reply tuple="
+			      FMT_TUPLE "\n",
+			      __func__, ct, ARG_TUPLE(&new_reply));
 		new_reply.dst.u3 = cp->vaddr;
 		new_reply.dst.u.tcp.port = cp->vport;
-		IP_VS_DBG(7, "%s: ct=%p, new tuples=" FMT_TUPLE ", " FMT_TUPLE
-			  ", inout cp=" FMT_CONN "\n",
-			  __func__, ct,
-			  ARG_TUPLE(orig), ARG_TUPLE(&new_reply),
-			  ARG_CONN(cp));
 		goto alter;
 	}
 
@@ -191,25 +193,21 @@ static void ip_vs_nfct_expect_callback(struct nf_conn *ct,
 	cp = ip_vs_conn_in_get(&p);
 	if (cp) {
 		/* Change reply VS->CLIENT to RS->CLIENT */
+		IP_VS_DBG_BUF(7, "%s: for ct=%p, status=0x%lX found outin cp="
+			      FMT_CONN "\n",
+			      __func__, ct, ct->status, ARG_CONN(cp));
 		new_reply = ct->tuplehash[IP_CT_DIR_REPLY].tuple;
-		IP_VS_DBG(7, "%s: ct=%p, status=0x%lX, tuples=" FMT_TUPLE ", "
-			  FMT_TUPLE ", found outin cp=" FMT_CONN "\n",
-			  __func__, ct, ct->status,
-			  ARG_TUPLE(orig), ARG_TUPLE(&new_reply),
-			  ARG_CONN(cp));
+		IP_VS_DBG_BUF(7, "%s: ct=%p before alter: reply tuple="
+			      FMT_TUPLE "\n",
+			      __func__, ct, ARG_TUPLE(&new_reply));
 		new_reply.src.u3 = cp->daddr;
 		new_reply.src.u.tcp.port = cp->dport;
-		IP_VS_DBG(7, "%s: ct=%p, new tuples=" FMT_TUPLE ", "
-			  FMT_TUPLE ", outin cp=" FMT_CONN "\n",
-			  __func__, ct,
-			  ARG_TUPLE(orig), ARG_TUPLE(&new_reply),
-			  ARG_CONN(cp));
 		goto alter;
 	}
 
-	IP_VS_DBG(7, "%s: ct=%p, status=0x%lX, tuple=" FMT_TUPLE
-		  " - unknown expect\n",
-		  __func__, ct, ct->status, ARG_TUPLE(orig));
+	IP_VS_DBG_BUF(7, "%s: ct=%p, status=0x%lX, tuple=" FMT_TUPLE
+		      " - unknown expect\n",
+		      __func__, ct, ct->status, ARG_TUPLE(orig));
 	return;
 
 alter:
@@ -247,8 +245,8 @@ void ip_vs_nfct_expect_related(struct sk_buff *skb, struct nf_conn *ct,
 
 	exp->expectfn = ip_vs_nfct_expect_callback;
 
-	IP_VS_DBG(7, "%s: ct=%p, expect tuple=" FMT_TUPLE "\n",
-		__func__, ct, ARG_TUPLE(&exp->tuple));
+	IP_VS_DBG_BUF(7, "%s: ct=%p, expect tuple=" FMT_TUPLE "\n",
+		      __func__, ct, ARG_TUPLE(&exp->tuple));
 	nf_ct_expect_related(exp);
 	nf_ct_expect_put(exp);
 }
@@ -274,26 +272,25 @@ void ip_vs_conn_drop_conntrack(struct ip_vs_conn *cp)
 	tuple.dst.u3 = cp->vaddr;
 	tuple.dst.u.all = cp->vport;
 
-	IP_VS_DBG(7, "%s: dropping conntrack with tuple=" FMT_TUPLE
-		" for conn " FMT_CONN "\n",
-		__func__, ARG_TUPLE(&tuple), ARG_CONN(cp));
+	IP_VS_DBG_BUF(7, "%s: dropping conntrack for conn " FMT_CONN "\n",
+		      __func__, ARG_CONN(cp));
 
 	h = nf_conntrack_find_get(cp->ipvs->net, &nf_ct_zone_dflt, &tuple);
 	if (h) {
 		ct = nf_ct_tuplehash_to_ctrack(h);
 		if (nf_ct_kill(ct)) {
-			IP_VS_DBG(7, "%s: ct=%p, deleted conntrack for tuple="
-				FMT_TUPLE "\n",
-				__func__, ct, ARG_TUPLE(&tuple));
+			IP_VS_DBG_BUF(7, "%s: ct=%p deleted for tuple="
+				      FMT_TUPLE "\n",
+				      __func__, ct, ARG_TUPLE(&tuple));
 		} else {
-			IP_VS_DBG(7, "%s: ct=%p, no conntrack timer for tuple="
-				FMT_TUPLE "\n",
-				__func__, ct, ARG_TUPLE(&tuple));
+			IP_VS_DBG_BUF(7, "%s: ct=%p, no conntrack for tuple="
+				      FMT_TUPLE "\n",
+				      __func__, ct, ARG_TUPLE(&tuple));
 		}
 		nf_ct_put(ct);
 	} else {
-		IP_VS_DBG(7, "%s: no conntrack for tuple=" FMT_TUPLE "\n",
-			__func__, ARG_TUPLE(&tuple));
+		IP_VS_DBG_BUF(7, "%s: no conntrack for tuple=" FMT_TUPLE "\n",
+			      __func__, ARG_TUPLE(&tuple));
 	}
 }
 
-- 
2.11.0
