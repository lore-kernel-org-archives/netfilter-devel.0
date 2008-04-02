From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 22/24] [NETFILTER]: Replace NF_CT_DUMP_TUPLE macro indrection by function call
Date: Wed,  2 Apr 2008 13:12:04 +0200
Message-ID: <d07d35f76c5bb767582657884e1684a82da76307.1207134547.git.jengelh@computergmbh.de>
References: <1207134726-28689-1-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:43173 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756081AbYDBLMM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Apr 2008 07:12:12 -0400
In-Reply-To: <1207134726-28689-1-git-send-email-jengelh@computergmbh.de>
In-Reply-To: <455b3b0ee249d17dff621933f163b8d5e377eb8f.1207134547.git.jengelh@computergmbh.de>
References: <455b3b0ee249d17dff621933f163b8d5e377eb8f.1207134547.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Directly call IPv4 and IPv6 variants where the address family is
easily known.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 include/net/netfilter/nf_conntrack_tuple.h     |    2 -
 net/ipv4/netfilter/ipt_CLUSTERIP.c             |    2 +-
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |    2 +-
 net/ipv4/netfilter/nf_nat_pptp.c               |    2 +-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |    2 +-
 net/netfilter/nf_conntrack_core.c              |    2 +-
 net/netfilter/nf_conntrack_h323_main.c         |   26 ++++++++--------
 net/netfilter/nf_conntrack_pptp.c              |    4 +-
 net/netfilter/nf_conntrack_proto_gre.c         |    6 ++--
 net/netfilter/nf_conntrack_proto_tcp.c         |    6 ++--
 net/netfilter/nf_conntrack_sane.c              |    2 +-
 net/netfilter/nf_conntrack_tftp.c              |    6 ++--
 12 files changed, 30 insertions(+), 32 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_tuple.h b/include/net/netfilter/nf_conntrack_tuple.h
index 6db3df6..405bea8 100644
--- a/include/net/netfilter/nf_conntrack_tuple.h
+++ b/include/net/netfilter/nf_conntrack_tuple.h
@@ -131,8 +131,6 @@ static inline void nf_ct_dump_tuple(const struct nf_conntrack_tuple *t)
 	}
 }
 
-#define NF_CT_DUMP_TUPLE(tp)	nf_ct_dump_tuple(tp)
-
 /* If we're the first tuple, it's the original dir. */
 #define NF_CT_DIRECTION(h)						\
 	((enum ip_conntrack_dir)(h)->tuple.dst.dir)
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 64663e2..a20b6b5 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -331,7 +331,7 @@ clusterip_tg(struct sk_buff *skb, const struct net_device *in,
 	}
 
 #ifdef DEBUG
-	NF_CT_DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
+	nf_ct_dump_tuple_ip(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
 #endif
 	pr_debug("hash=%u ct_hash=%u ", hash, ct->mark);
 	if (!clusterip_responsible(cipinfo->config, hash)) {
diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index 3b0591f..5f37cf6 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -115,7 +115,7 @@ static bool icmp_new(struct nf_conn *ct, const struct sk_buff *skb,
 		/* Can't create a new ICMP `conn' with this. */
 		pr_debug("icmp: can't create new conn with type %u\n",
 			 ct->tuplehash[0].tuple.dst.u.icmp.type);
-		NF_CT_DUMP_TUPLE(&ct->tuplehash[0].tuple);
+		nf_ct_dump_tuple_ip(&ct->tuplehash[0].tuple);
 		return false;
 	}
 	atomic_set(&ct->proto.icmp.count, 0);
diff --git a/net/ipv4/netfilter/nf_nat_pptp.c b/net/ipv4/netfilter/nf_nat_pptp.c
index 3a1e6d6..da3d91a 100644
--- a/net/ipv4/netfilter/nf_nat_pptp.c
+++ b/net/ipv4/netfilter/nf_nat_pptp.c
@@ -72,7 +72,7 @@ static void pptp_nat_expected(struct nf_conn *ct,
 	}
 
 	pr_debug("trying to unexpect other dir: ");
-	NF_CT_DUMP_TUPLE(&t);
+	nf_ct_dump_tuple_ip(&t);
 	other_exp = nf_ct_expect_find_get(&t);
 	if (other_exp) {
 		nf_ct_unexpect_related(other_exp);
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index 7b88299..b0b1efb 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -115,7 +115,7 @@ static bool icmpv6_new(struct nf_conn *ct, const struct sk_buff *skb,
 		/* Can't create a new ICMPv6 `conn' with this. */
 		pr_debug("icmpv6: can't create new conn with type %u\n",
 			 type + 128);
-		NF_CT_DUMP_TUPLE(&ct->tuplehash[0].tuple);
+		nf_ct_dump_tuple_ipv6(&ct->tuplehash[0].tuple);
 		return false;
 	}
 	atomic_set(&ct->proto.icmp.count, 0);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index b7ba7af..4800c98 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -764,7 +764,7 @@ void nf_conntrack_alter_reply(struct nf_conn *ct,
 	NF_CT_ASSERT(!nf_ct_is_confirmed(ct));
 
 	pr_debug("Altering reply tuple of %p to ", ct);
-	NF_CT_DUMP_TUPLE(newreply);
+	nf_ct_dump_tuple(newreply);
 
 	ct->tuplehash[IP_CT_DIR_REPLY].tuple = *newreply;
 	if (ct->master || (help && help->expecting != 0))
diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index a8f2267..10b429f 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -306,9 +306,9 @@ static int expect_rtp_rtcp(struct sk_buff *skb, struct nf_conn *ct,
 		if (nf_ct_expect_related(rtp_exp) == 0) {
 			if (nf_ct_expect_related(rtcp_exp) == 0) {
 				pr_debug("nf_ct_h323: expect RTP ");
-				NF_CT_DUMP_TUPLE(&rtp_exp->tuple);
+				nf_ct_dump_tuple(&rtp_exp->tuple);
 				pr_debug("nf_ct_h323: expect RTCP ");
-				NF_CT_DUMP_TUPLE(&rtcp_exp->tuple);
+				nf_ct_dump_tuple(&rtcp_exp->tuple);
 			} else {
 				nf_ct_unexpect_related(rtp_exp);
 				ret = -1;
@@ -364,7 +364,7 @@ static int expect_t120(struct sk_buff *skb,
 	} else {		/* Conntrack only */
 		if (nf_ct_expect_related(exp) == 0) {
 			pr_debug("nf_ct_h323: expect T.120 ");
-			NF_CT_DUMP_TUPLE(&exp->tuple);
+			nf_ct_dump_tuple(&exp->tuple);
 		} else
 			ret = -1;
 	}
@@ -586,7 +586,7 @@ static int h245_help(struct sk_buff *skb, unsigned int protoff,
 	while (get_tpkt_data(skb, protoff, ct, ctinfo,
 			     &data, &datalen, &dataoff)) {
 		pr_debug("nf_ct_h245: TPKT len=%d ", datalen);
-		NF_CT_DUMP_TUPLE(&ct->tuplehash[CTINFO2DIR(ctinfo)].tuple);
+		nf_ct_dump_tuple(&ct->tuplehash[CTINFO2DIR(ctinfo)].tuple);
 
 		/* Decode H.245 signal */
 		ret = DecodeMultimediaSystemControlMessage(data, datalen,
@@ -701,7 +701,7 @@ static int expect_h245(struct sk_buff *skb, struct nf_conn *ct,
 	} else {		/* Conntrack only */
 		if (nf_ct_expect_related(exp) == 0) {
 			pr_debug("nf_ct_q931: expect H.245 ");
-			NF_CT_DUMP_TUPLE(&exp->tuple);
+			nf_ct_dump_tuple(&exp->tuple);
 		} else
 			ret = -1;
 	}
@@ -818,7 +818,7 @@ static int expect_callforwarding(struct sk_buff *skb,
 	} else {		/* Conntrack only */
 		if (nf_ct_expect_related(exp) == 0) {
 			pr_debug("nf_ct_q931: expect Call Forwarding ");
-			NF_CT_DUMP_TUPLE(&exp->tuple);
+			nf_ct_dump_tuple(&exp->tuple);
 		} else
 			ret = -1;
 	}
@@ -1138,7 +1138,7 @@ static int q931_help(struct sk_buff *skb, unsigned int protoff,
 	while (get_tpkt_data(skb, protoff, ct, ctinfo,
 			     &data, &datalen, &dataoff)) {
 		pr_debug("nf_ct_q931: TPKT len=%d ", datalen);
-		NF_CT_DUMP_TUPLE(&ct->tuplehash[CTINFO2DIR(ctinfo)].tuple);
+		nf_ct_dump_tuple(&ct->tuplehash[CTINFO2DIR(ctinfo)].tuple);
 
 		/* Decode Q.931 signal */
 		ret = DecodeQ931(data, datalen, &q931);
@@ -1288,7 +1288,7 @@ static int expect_q931(struct sk_buff *skb, struct nf_conn *ct,
 	} else {		/* Conntrack only */
 		if (nf_ct_expect_related(exp) == 0) {
 			pr_debug("nf_ct_ras: expect Q.931 ");
-			NF_CT_DUMP_TUPLE(&exp->tuple);
+			nf_ct_dump_tuple(&exp->tuple);
 
 			/* Save port for looking up expect in processing RCF */
 			info->sig_port[dir] = port;
@@ -1353,7 +1353,7 @@ static int process_gcf(struct sk_buff *skb, struct nf_conn *ct,
 
 	if (nf_ct_expect_related(exp) == 0) {
 		pr_debug("nf_ct_ras: expect RAS ");
-		NF_CT_DUMP_TUPLE(&exp->tuple);
+		nf_ct_dump_tuple(&exp->tuple);
 	} else
 		ret = -1;
 
@@ -1437,7 +1437,7 @@ static int process_rcf(struct sk_buff *skb, struct nf_conn *ct,
 			pr_debug("nf_ct_ras: set Q.931 expect "
 				 "timeout to %u seconds for",
 				 info->timeout);
-			NF_CT_DUMP_TUPLE(&exp->tuple);
+			nf_ct_dump_tuple(&exp->tuple);
 			set_expect_timeout(exp, info->timeout);
 		}
 		spin_unlock_bh(&nf_conntrack_lock);
@@ -1559,7 +1559,7 @@ static int process_acf(struct sk_buff *skb, struct nf_conn *ct,
 
 	if (nf_ct_expect_related(exp) == 0) {
 		pr_debug("nf_ct_ras: expect Q.931 ");
-		NF_CT_DUMP_TUPLE(&exp->tuple);
+		nf_ct_dump_tuple(&exp->tuple);
 	} else
 		ret = -1;
 
@@ -1613,7 +1613,7 @@ static int process_lcf(struct sk_buff *skb, struct nf_conn *ct,
 
 	if (nf_ct_expect_related(exp) == 0) {
 		pr_debug("nf_ct_ras: expect Q.931 ");
-		NF_CT_DUMP_TUPLE(&exp->tuple);
+		nf_ct_dump_tuple(&exp->tuple);
 	} else
 		ret = -1;
 
@@ -1717,7 +1717,7 @@ static int ras_help(struct sk_buff *skb, unsigned int protoff,
 	if (data == NULL)
 		goto accept;
 	pr_debug("nf_ct_ras: RAS message len=%d ", datalen);
-	NF_CT_DUMP_TUPLE(&ct->tuplehash[CTINFO2DIR(ctinfo)].tuple);
+	nf_ct_dump_tuple(&ct->tuplehash[CTINFO2DIR(ctinfo)].tuple);
 
 	/* Decode RAS message */
 	ret = DecodeRasMessage(data, datalen, &ras);
diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index 8fd8347..bfd3adf 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -119,7 +119,7 @@ static void pptp_expectfn(struct nf_conn *ct,
 		/* obviously this tuple inversion only works until you do NAT */
 		nf_ct_invert_tuplepr(&inv_t, &exp->tuple);
 		pr_debug("trying to unexpect other dir: ");
-		NF_CT_DUMP_TUPLE(&inv_t);
+		nf_ct_dump_tuple(&inv_t);
 
 		exp_other = nf_ct_expect_find_get(&inv_t);
 		if (exp_other) {
@@ -141,7 +141,7 @@ static int destroy_sibling_or_exp(const struct nf_conntrack_tuple *t)
 	struct nf_conn *sibling;
 
 	pr_debug("trying to timeout ct or exp for tuple ");
-	NF_CT_DUMP_TUPLE(t);
+	nf_ct_dump_tuple(t);
 
 	h = nf_conntrack_find_get(t);
 	if (h)  {
diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index 7f82933..2fa8ea2 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -82,7 +82,7 @@ static __be16 gre_keymap_lookup(struct nf_conntrack_tuple *t)
 	read_unlock_bh(&nf_ct_gre_lock);
 
 	pr_debug("lookup src key 0x%x for ", key);
-	NF_CT_DUMP_TUPLE(t);
+	nf_ct_dump_tuple(t);
 
 	return key;
 }
@@ -113,7 +113,7 @@ int nf_ct_gre_keymap_add(struct nf_conn *ct, enum ip_conntrack_dir dir,
 	*kmp = km;
 
 	pr_debug("adding new entry %p: ", km);
-	NF_CT_DUMP_TUPLE(&km->tuple);
+	nf_ct_dump_tuple(&km->tuple);
 
 	write_lock_bh(&nf_ct_gre_lock);
 	list_add_tail(&km->list, &gre_keymap_list);
@@ -238,7 +238,7 @@ static bool gre_new(struct nf_conn *ct, const struct sk_buff *skb,
                     unsigned int dataoff)
 {
 	pr_debug(": ");
-	NF_CT_DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
+	nf_ct_dump_tuple(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
 
 	/* initialize to sane value.  Ideally a conntrack helper
 	 * (e.g. in case of pptp) is increasing them */
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 67caddc..635f9cf 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -501,7 +501,7 @@ static bool tcp_in_window(const struct nf_conn *ct, struct ip_ct_tcp *state,
 
 	pr_debug("tcp_in_window: START\n");
 	pr_debug("tcp_in_window: ");
-	NF_CT_DUMP_TUPLE(tuple);
+	nf_ct_dump_tuple(tuple);
 	pr_debug("seq=%u ack=%u sack=%u win=%u end=%u\n",
 		 seq, ack, sack, win, end);
 	pr_debug("tcp_in_window: sender end=%u maxend=%u maxwin=%u scale=%i "
@@ -588,7 +588,7 @@ static bool tcp_in_window(const struct nf_conn *ct, struct ip_ct_tcp *state,
 		seq = end = sender->td_end;
 
 	pr_debug("tcp_in_window: ");
-	NF_CT_DUMP_TUPLE(tuple);
+	nf_ct_dump_tuple(tuple);
 	pr_debug("seq=%u ack=%u sack =%u win=%u end=%u\n",
 		 seq, ack, sack, win, end);
 	pr_debug("tcp_in_window: sender end=%u maxend=%u maxwin=%u scale=%i "
@@ -932,7 +932,7 @@ static int tcp_packet(struct nf_conn *ct,
 	ct->proto.tcp.last_dir = dir;
 
 	pr_debug("tcp_conntracks: ");
-	NF_CT_DUMP_TUPLE(tuple);
+	nf_ct_dump_tuple(tuple);
 	pr_debug("syn=%i ack=%i fin=%i rst=%i old=%i new=%i\n",
 		 (th->syn ? 1 : 0), (th->ack ? 1 : 0),
 		 (th->fin ? 1 : 0), (th->rst ? 1 : 0),
diff --git a/net/netfilter/nf_conntrack_sane.c b/net/netfilter/nf_conntrack_sane.c
index 4f3d0cb..bb8bb49 100644
--- a/net/netfilter/nf_conntrack_sane.c
+++ b/net/netfilter/nf_conntrack_sane.c
@@ -148,7 +148,7 @@ static int help(struct sk_buff *skb,
 			  IPPROTO_TCP, NULL, &reply->port);
 
 	pr_debug("nf_ct_sane: expect: ");
-	NF_CT_DUMP_TUPLE(&exp->tuple);
+	nf_ct_dump_tuple(&exp->tuple);
 
 	/* Can't expect this?  Best to drop packet now. */
 	if (nf_ct_expect_related(exp) != 0)
diff --git a/net/netfilter/nf_conntrack_tftp.c b/net/netfilter/nf_conntrack_tftp.c
index 95d1743..5666495 100644
--- a/net/netfilter/nf_conntrack_tftp.c
+++ b/net/netfilter/nf_conntrack_tftp.c
@@ -56,8 +56,8 @@ static int tftp_help(struct sk_buff *skb,
 	case TFTP_OPCODE_READ:
 	case TFTP_OPCODE_WRITE:
 		/* RRQ and WRQ works the same way */
-		NF_CT_DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
-		NF_CT_DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
+		nf_ct_dump_tuple(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
+		nf_ct_dump_tuple(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
 
 		exp = nf_ct_expect_alloc(ct);
 		if (exp == NULL)
@@ -68,7 +68,7 @@ static int tftp_help(struct sk_buff *skb,
 				  IPPROTO_UDP, NULL, &tuple->dst.u.udp.port);
 
 		pr_debug("expect: ");
-		NF_CT_DUMP_TUPLE(&exp->tuple);
+		nf_ct_dump_tuple(&exp->tuple);
 
 		nf_nat_tftp = rcu_dereference(nf_nat_tftp_hook);
 		if (nf_nat_tftp && ct->status & IPS_NAT_MASK)
-- 
1.5.4.4

