From: Nicolas Bareil <nico@chdir.org>
Subject: scrubbing support in Netfilter
Date: Tue, 27 May 2008 17:11:27 +0200
Message-ID: <87lk1vdbog.fsf@chdir.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: nicolas.bareil@eads.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moog.chdir.org ([88.191.42.160]:45322 "EHLO moog.chdir.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756288AbYE0PLe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 May 2008 11:11:34 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



Hi!


I developped a Netfilter module which performs packet normalization, the
"scrubbing" feature of OpenBSD[1]. Normalized trafic offers the
following possibilities :

 * Just before an IDS, we can make its works easier  by feeding it
   normalized trafic : there is no TTL trick used to escape detection
   anymore.
            
 * Minimize OS fingerprinting, Even through the "Application Layer" will
   give hints to an attacker (User-Agent in HTTP header or mail
   enveloppe), not every protocol has this "flaw" : DNS, IKE, SMTP, etc.
    Furthermore, there is not only the fingerprinting issue : an
   administrator can  wish to hide the fact he is running a farm of
   DNATed
   servers.

 * Misshapen trafic can be discarded, the time of "Ping of death" is not
   over! Last year, there were (simple) major vulnerabilities in
   missshapen packets : the IPv6 routing header issues, old school
   flaws in pre-beta of Microsoft Windows Vista.

 * Protection, or interface with embedded equipment : some legacy
   equipment in end of life could still have TCP ISN vulnerability
   without any update possible.

Performing normalization should be harmless as long as we stick to two
rules :
 * Stay RFC compliant
 * Keep in mind the consequences of a change : we can lower a TTL but
 never rise it!
   

The current patch achieves the following transformations :

* IPv4
  - Random IP ID
  - Zeroify ToS
  - TTL normalization

* TCP
 - Random TCP Sequence
 - TCP Options
   - Random Timestamp
   - Sanity checks on MSS
 - TTL seal : The TTL cannot be modified within a TCP connection
   It means that you must make sure there is only one only route to
   the destination (there cannot be two paths with different distances).
   This feature is disabled by default because of this issue.

There isn't any IPv6 transformations yet but there should be more soon
(Routing Headers issues).

The following patch is "self-contained" : only nf_conntrack_proto_tcp.c is
modified, the other files are new. The iptables patch is following this
email. 

This work has been done at EADS Innovation Works.

Signed-off-by: Nicolas Bareil <nico@chdir.org>


diff --git a/include/linux/netfilter/nf_conntrack_common.h b/include/linux/netfilter/nf_conntrack_common.h
index bad1eb7..4a03f56 100644
--- a/include/linux/netfilter/nf_conntrack_common.h
+++ b/include/linux/netfilter/nf_conntrack_common.h
@@ -175,4 +175,28 @@ extern void need_conntrack(void);
 
 #endif /* __KERNEL__ */
 
+enum nf_scrub_transformations {
+	/* scrub tcp sequence adjusting */
+	SCRUB_TCP_SEQ_ADJUST_BIT = 1,
+	SCRUB_TCP_SEQ_ADJUST = (1 << SCRUB_TCP_SEQ_ADJUST_BIT),
+
+	SCRUB_IP_RAND_ID_ADJUST_BIT = 2,
+	SCRUB_IP_RAND_ID_ADJUST = (1 << SCRUB_IP_RAND_ID_ADJUST_BIT),
+
+	SCRUB_IP_TTL_ADJUST_BIT = 3,
+	SCRUB_IP_TTL_ADJUST = (1 << SCRUB_IP_TTL_ADJUST_BIT),
+
+	SCRUB_IP_TOS_ADJUST_BIT = 4,
+	SCRUB_IP_TOS_ADJUST = (1 << SCRUB_IP_TOS_ADJUST_BIT),
+
+	SCRUB_TCP_OPT_MSS_ADJUST_BIT = 5,
+	SCRUB_TCP_OPT_MSS_ADJUST = (1 << SCRUB_TCP_OPT_MSS_ADJUST_BIT),
+
+	SCRUB_TCP_OPT_TIMESTAMP_ADJUST_BIT = 6,
+	SCRUB_TCP_OPT_TIMESTAMP_ADJUST = (1 << SCRUB_TCP_OPT_TIMESTAMP_ADJUST_BIT),
+
+	SCRUB_IP_SEALED_TTL_ADJUST_BIT = 7,
+	SCRUB_IP_SEALED_TTL_ADJUST = (1 << SCRUB_IP_SEALED_TTL_ADJUST_BIT),
+};
+
 #endif /* _NF_CONNTRACK_COMMON_H */
diff --git a/include/linux/netfilter_ipv4/ipt_SCRUB.h b/include/linux/netfilter_ipv4/ipt_SCRUB.h
new file mode 100644
index 0000000..31492cf
--- /dev/null
+++ b/include/linux/netfilter_ipv4/ipt_SCRUB.h
@@ -0,0 +1,19 @@
+/*
+ * (C) 2007 by Nicolas Bareil <nico@chdir.org>
+ */
+
+#ifndef _IPT_SCRUB_H
+#define _IPT_SCRUB_H
+
+static unsigned int
+ipt_scrub_target(struct sk_buff *skb,
+		 const struct net_device *in, const struct net_device *out,
+		 unsigned int hooknum, const struct xt_target *target,
+		 const void *targinfo);
+
+static bool ipt_scrub_checkentry(const char *tablename,
+				const void *e,
+				const struct xt_target *target,
+				void *targinfo,
+				unsigned int hook_mask);
+#endif
diff --git a/include/linux/netfilter_ipv4/nf_scrub.h b/include/linux/netfilter_ipv4/nf_scrub.h
new file mode 100644
index 0000000..14de9b2
--- /dev/null
+++ b/include/linux/netfilter_ipv4/nf_scrub.h
@@ -0,0 +1,19 @@
+#ifndef _NF_SCRUB_V4_H
+#define _NF_SCRUB_V4_H
+
+#include <net/netfilter/nf_conntrack_extend.h>
+
+extern bool nf_scrub_ipv4_adjust(struct sk_buff *skb
+				 , struct nf_conn *ct
+				 , enum ip_conntrack_info ctinfo);
+
+extern void nf_scrub_ip_tos_adjust(struct iphdr *iph, struct nf_conn *ct);
+extern bool nf_scrub_ip_rand_id_adjust(struct iphdr *iph, struct nf_conn *ct);
+extern bool nf_scrub_ip_sealed_ttl_adjust(struct iphdr *iph, struct nf_conn *ct);
+extern bool nf_scrub_ip_ttl_adjust(struct iphdr *iph, struct nf_conn *ct);
+
+extern bool nf_scrub_ipv4_setup(const struct sk_buff *skb
+				, struct nf_conn *ct
+				, enum ip_conntrack_info ctinfo
+				, struct ipt_scrub_info *info);
+#endif
diff --git a/include/linux/netfilter_ipv6/nf_scrub.h b/include/linux/netfilter_ipv6/nf_scrub.h
new file mode 100644
index 0000000..a473180
--- /dev/null
+++ b/include/linux/netfilter_ipv6/nf_scrub.h
@@ -0,0 +1,14 @@
+#ifndef _NF_SCRUB_V6_H
+#define _NF_SCRUB_V6_H
+
+#include <net/netfilter/nf_conntrack_extend.h>
+
+extern bool nf_scrub_ipv6_adjust(struct sk_buff *skb
+				 , struct nf_conn *ct
+				 , enum ip_conntrack_info ctinfo);
+
+extern bool nf_scrub_ipv6_setup(const struct sk_buff *skb
+				, struct nf_conn *ct
+				, enum ip_conntrack_info ctinfo
+				, struct ipt_scrub_info *info);
+#endif
diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 2dbd6c0..7481f54 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -124,6 +124,10 @@ struct nf_conn
 	u_int32_t secmark;
 #endif
 
+#ifdef CONFIG_NF_SCRUB_NEEDED
+	u_int32_t scrub;
+#endif
+
 	/* Storage reserved for other modules: */
 	union nf_conntrack_proto proto;
 
diff --git a/include/net/netfilter/nf_conntrack_extend.h b/include/net/netfilter/nf_conntrack_extend.h
index f736e84..3eb03af 100644
--- a/include/net/netfilter/nf_conntrack_extend.h
+++ b/include/net/netfilter/nf_conntrack_extend.h
@@ -7,11 +7,13 @@ enum nf_ct_ext_id
 {
 	NF_CT_EXT_HELPER,
 	NF_CT_EXT_NAT,
+	NF_CT_EXT_SCRUB,
 	NF_CT_EXT_NUM,
 };
 
 #define NF_CT_EXT_HELPER_TYPE struct nf_conn_help
 #define NF_CT_EXT_NAT_TYPE struct nf_conn_nat
+#define NF_CT_EXT_SCRUB_TYPE struct nf_conn_scrub
 
 /* Extensions: optional stuff which isn't permanently in struct. */
 struct nf_ct_ext {
diff --git a/include/net/netfilter/nf_scrub.h b/include/net/netfilter/nf_scrub.h
new file mode 100644
index 0000000..b9776a0
--- /dev/null
+++ b/include/net/netfilter/nf_scrub.h
@@ -0,0 +1,53 @@
+#ifndef _NF_SCRUB_H
+#define _NF_SCRUB_H
+
+#include <net/netfilter/nf_conntrack_extend.h>
+#include <linux/tcp.h>
+
+struct ipt_scrub_ttl {
+	__u8 scrubbing_default;             /* default ttl */
+	__u8 modifying_threshold; /* never generate ttl lower than */
+	__u8 dropping_threshold;  /* drop if the ttl is lower than */
+};
+
+struct nf_conn_scrub { /* XXX: check the alignment */
+	union {
+		struct {
+			unsigned int seqoffset;
+			unsigned int tstampoff;
+			__u32 fixedmss;
+			__u8 sealedttl;
+		} tcp;
+	} proto;
+	struct ipt_scrub_ttl ttl;
+};
+
+
+struct ipt_scrub_info {
+	u_int32_t  flags;
+	 struct ipt_scrub_ttl ttl;
+};
+
+extern inline struct nf_conn_scrub *nfct_scrub(const struct nf_conn *ct)
+{
+	return nf_ct_ext_find(ct, NF_CT_EXT_SCRUB);
+}
+
+extern unsigned int nf_scrub_adjust(unsigned int hooknum
+				    , struct sk_buff *pskb
+				    , const struct net_device *in
+				    , const struct net_device *out
+				    , int (*okfn)(struct sk_buff *));
+
+extern unsigned int nf_scrub_setup(const struct sk_buff *skb
+				   , struct nf_conn *ct
+				   , enum ip_conntrack_info ctinfo
+				   , struct ipt_scrub_info *info);
+
+/** constants **/
+#define SCRUB_NORMALIZE_TTL IPDEFTTL /* 64 on Linux */
+#define SCRUB_TTL_LOW_THRESHOLD 10 /* a normalized packet will not have a
+				      ttl lower than this constant */
+#define SCRUB_TTL_DROP_IF_LOWER 10
+
+#endif
diff --git a/include/net/netfilter/nf_scrub_tcp.h b/include/net/netfilter/nf_scrub_tcp.h
new file mode 100644
index 0000000..5e028c7
--- /dev/null
+++ b/include/net/netfilter/nf_scrub_tcp.h
@@ -0,0 +1,56 @@
+#ifndef _NF_SCRUB_TCP_H
+#define _NF_SCRUB_TCP_H
+
+#include <net/netfilter/nf_conntrack_extend.h>
+#include <linux/tcp.h>
+
+#define SCRUB_TCP_OPTIONS (SCRUB_TCP_OPT_TIMESTAMP_ADJUST \
+			   | SCRUB_TCP_OPT_MSS_ADJUST)
+
+struct tcpopt {
+	unsigned char kind;
+	unsigned char length;
+};
+
+/*** tcp options ***/
+
+extern bool nf_scrub_tcp_opt_mss(struct tcphdr *tcphdr
+				, struct nf_conn *ct, __u16 *mss
+				 , enum ip_conntrack_dir dir);
+extern bool nf_scrub_tcp_opt_timestamp(struct tcphdr *tcphdr
+				       , struct nf_conn *ct
+				       , __u32 *base_tstamp
+				       , enum ip_conntrack_dir dir);
+
+
+extern void nf_scrub_tcp_sack_adjust_block(struct tcphdr *tcphdr
+					   , struct tcp_sack_block *block
+					   , unsigned char len
+					   , unsigned int offset);
+
+/*** the following symbols are EXPORTED ***/
+
+extern bool nf_scrub_tcp_parse_options(struct tcphdr *tcphdr
+				       , struct nf_conn *ct
+				       , enum ip_conntrack_info ctinfo);
+
+/*** sequence number stuff ***/
+
+extern bool nf_scrub_tcp_seq_adjust(struct tcphdr *tcphdr
+				    , struct nf_conn *ct
+				    , enum ip_conntrack_info ctinfo);
+
+extern bool nf_scrub_tcp_sack_adjust(struct tcphdr *tcphdr
+				     , struct nf_conn *ct
+				     , enum ip_conntrack_info ctinfo);
+
+extern bool nf_scrub_tcp_ack_adjust(struct tcphdr *tcphdr
+				    , struct nf_conn *ct
+				    , enum ip_conntrack_info ctinfo);
+
+extern void nf_scrub_tcp_setup(const struct sk_buff *skb
+			       , struct tcphdr *tcphdr
+			       , struct nf_conn *ct
+			       , enum ip_conntrack_info ctinfo);
+
+#endif
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index d9b92fb..cd2a1f2 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -34,6 +34,10 @@ obj-$(CONFIG_NF_NAT_PROTO_GRE) += nf_nat_proto_gre.o
 obj-$(CONFIG_NF_NAT_PROTO_UDPLITE) += nf_nat_proto_udplite.o
 obj-$(CONFIG_NF_NAT_PROTO_SCTP) += nf_nat_proto_sctp.o
 
+# SCRUB
+obj-$(CONFIG_NF_SCRUB) += nf_scrub_ipv4.o
+obj-$(CONFIG_IP_NF_TARGET_SCRUB) += ipt_SCRUB.o
+
 # generic IP tables 
 obj-$(CONFIG_IP_NF_IPTABLES) += ip_tables.o
 
diff --git a/net/ipv4/netfilter/ipt_SCRUB.c b/net/ipv4/netfilter/ipt_SCRUB.c
new file mode 100644
index 0000000..1f36aa0
--- /dev/null
+++ b/net/ipv4/netfilter/ipt_SCRUB.c
@@ -0,0 +1,91 @@
+/* Normalization for netfilter. */
+
+/* (C) 2008 Nicolas Bareil <nico@chdir.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <net/ip.h>
+#include <linux/ip.h>
+#include <linux/tcp.h>
+#include <linux/skbuff.h>
+#include <linux/module.h>
+#include <linux/random.h>
+
+#include <linux/netfilter/x_tables.h>
+#include <net/netfilter/nf_conntrack.h>
+#include <linux/netfilter/nf_conntrack_common.h>
+#include <linux/netfilter_ipv4/ipt_SCRUB.h>
+#include <net/netfilter/nf_scrub.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Nicolas Bareil <nico@chdir.org>");
+MODULE_DESCRIPTION("scrubbing module");
+
+#ifdef CONFIG_NETFILTER_DEBUG
+#define DEBUGP printk
+#else
+#define DEBUGP(format, args...)
+#endif
+
+static struct xt_target ipt_scrub_reg = {
+	.name		= "SCRUB",
+	.family		= AF_INET,
+	.target		= ipt_scrub_target,
+	.targetsize	= sizeof(struct ipt_scrub_info),
+	.table		= "mangle",
+	.checkentry	= ipt_scrub_checkentry,
+	.me		= THIS_MODULE,
+};
+
+static unsigned int
+ipt_scrub_target(struct sk_buff *skb
+		 , const struct net_device *in
+		 , const struct net_device *out
+		 , unsigned int hooknum
+		 , const struct xt_target *target
+		 , const void *targinfo)
+{
+	struct nf_conn_scrub *nfscrub;
+	struct ipt_scrub_info *info = (struct ipt_scrub_info *)targinfo;
+	struct nf_conn *ct;
+	enum ip_conntrack_info ctinfo; /* XXX */
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (!ct) {
+		DEBUGP("ipt_SCRUB: No conntrack matching this packet.\n");
+		return XT_CONTINUE;
+	}
+	nfscrub = nfct_scrub(ct);
+	if (!nfscrub)
+		nf_scrub_setup(skb, ct, ctinfo, info);
+
+	return XT_CONTINUE; /* XXX final decision: NF_ACCEPT ou XT_CONTINUE ? */
+}
+
+static bool ipt_scrub_checkentry(const char *tablename,
+				 const void *e,
+				 const struct xt_target *target,
+				 void *targinfo,
+				 unsigned int hook_mask)
+{
+	return 1; /* There should be no invalid configuration possible */
+}
+
+/**********************/
+
+static int __init ip_scrub_init(void)
+{
+	int ret = xt_register_target(&ipt_scrub_reg);
+	return ret;
+}
+
+static void __exit ip_scrub_cleanup(void)
+{
+	xt_unregister_target(&ipt_scrub_reg);
+}
+
+module_init(ip_scrub_init);
+module_exit(ip_scrub_cleanup);
diff --git a/net/ipv4/netfilter/nf_scrub_ipv4.c b/net/ipv4/netfilter/nf_scrub_ipv4.c
new file mode 100644
index 0000000..9a4f98b
--- /dev/null
+++ b/net/ipv4/netfilter/nf_scrub_ipv4.c
@@ -0,0 +1,244 @@
+/* (C) 2008 Nicolas Bareil <nico@chdir.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/netfilter.h>
+#include <linux/netfilter_ipv4.h>
+#include <net/netfilter/nf_scrub.h>
+#include <net/netfilter/nf_scrub_tcp.h>
+#include <linux/netfilter_ipv4/nf_scrub.h>
+#include <linux/netfilter/nf_conntrack_common.h>
+
+#include <net/ip.h>
+#include <net/tcp.h>
+#include <linux/ip.h>
+#include <linux/tcp.h>
+#include <linux/skbuff.h>
+#include <linux/module.h>
+#include <linux/random.h>
+
+#include <linux/netfilter/x_tables.h>
+
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Nicolas Bareil <nico@chdir.org>");
+MODULE_DESCRIPTION("ipv4 scrubbing module");
+
+#if CONFIG_NETFILTER_DEBUG
+#define DEBUGP printk
+#else
+#define DEBUGP(format, args...)
+#endif
+
+/*
+ * nf_scrub_ip_ttl_adjust()
+ *
+ * Normalize the TTL, each operating system has a different
+ * default value, it's easy to guess what is running a remote
+ * host thanks to this trick.
+ *
+ * We assume it is always ok to decrement TTL (the worst case is
+ * to received icmp time expired), but we will never increment it
+ * by phear of loop.
+ *
+ * We implemented the feature like this :
+ *
+ * If the packet has a TTL greater than 100 (sign of a Microsoft Windows
+ * or Solaris host), then we assign a default TTL (the Linux's default)
+ * and in order to be more discreet, we try to guess the distance between
+ * the host and the scrubbing gateway.
+ *
+ * Then we apply this distance to the default value by choosing a random
+ * value between 0 and the distance (to prevent passive network discovery).
+ *
+ * If the resulting TTL is lower than a threshold, we let the initial value.
+ *
+ * Finally, if the TTL is lower than a limit, we drop the packet! No traceroute
+ * is allowed.
+ */
+bool nf_scrub_ip_ttl_adjust(struct iphdr *iph, struct nf_conn *ct)
+{
+	struct nf_conn_scrub *scrub = nfct_scrub(ct);
+	__u8 ttl, deltattl = 0, randval = 0;
+
+	NF_CT_ASSERT(ct);
+	NF_CT_ASSERT(scrub);
+	NF_CT_ASSERT(iph);
+
+	ttl = iph->ttl;
+	if (ttl > 100) { /* windows, solaris, etc. */
+		ttl = scrub->ttl.scrubbing_default;
+
+		if (iph->ttl > 200) {
+			/* according to the p0f database, originalttl > 200 is
+			 * "always" equal to 255 */
+			deltattl = 255 - iph->ttl;
+		} else if (iph->ttl > 100) {
+			/* p0f tells us that original ttl could be 150 (linksys)
+			 * or 128 (most likely) */
+			deltattl = 128 - iph->ttl;
+		}
+
+		get_random_bytes(&randval, sizeof(randval));
+		if (deltattl)
+			ttl -= randval % abs(deltattl);
+
+		if (ttl > scrub->ttl.modifying_threshold) {
+			csum_replace2(&iph->check, htons(iph->ttl << 8), htons(ttl << 8));
+			iph->ttl = ttl;
+		} else {
+			DEBUGP("nf_scrub_core: ERR: the original ttl (%d) was too lowered, now ttl=%d!\n"
+			       , iph->ttl, ttl);
+		}
+	} /* ttl > 100 */
+
+	if (ttl <= scrub->ttl.dropping_threshold) {
+		DEBUGP("nf_scrub_core: dropping packets! TTL (%d) too low!\n", iph->ttl);
+		return false;
+	}
+	return true;
+}
+/*
+ * nf_scrub_ip_sealed_ttl_adjust()
+ *
+ * Seals the TTL : it cannot be lowered during a connection.
+ * That means that it will break if a connection can be routed
+ * via more than one path with different numbers of hops.
+ *
+ * By default, we should not enable this feature. This feature
+ * should only be used on local network.
+ */
+bool nf_scrub_ip_sealed_ttl_adjust(struct iphdr *iph
+				   , struct nf_conn *ct)
+{
+	struct nf_conn_scrub *scrub = nfct_scrub(ct);
+	__u8 current_ttl;
+
+	NF_CT_ASSERT(ct && scrub && iph);
+
+	current_ttl = ntohs(iph->ttl);
+	if (current_ttl < scrub->proto.tcp.sealedttl) {
+		scrub->proto.tcp.sealedttl = current_ttl;
+	} else {
+		if (current_ttl == scrub->proto.tcp.sealedttl)
+			return true;
+		else
+			return false; /* trying to reduce the TTL */
+	}
+	return true;
+}
+
+/*
+ * nf_scrub_ip_rand_id_adjust()
+ *
+ * Randomizes IP ID only if there is no fragmentation involved.
+ *
+ * XXX: Do we consumme too much randomness ? 16 random bits are
+ * get for each packet.
+ */
+bool nf_scrub_ip_rand_id_adjust(struct iphdr *iph
+				, struct nf_conn *ct)
+{
+	__be16 oldid;
+
+	NF_CT_ASSERT(iph);
+
+	oldid = iph->id;
+	if (!(ntohs(iph->frag_off) & IP_DF)
+	    || ((ntohs(iph->frag_off) & (IP_MF|IP_OFFSET)) != 0))
+		/* it is a fragment, we can't change the IP ID */
+		return false;
+
+	get_random_bytes(&iph->id, sizeof(iph->id));
+	csum_replace2(&iph->check, oldid, iph->id);
+
+	return true;
+}
+
+/*
+ * nf_scrub_ip_tos_adjust()
+ *
+ * Overwrite the IP ToS with 0. Things like SSH, telnet use
+ * this field (in vain on Internet ?).
+ *
+ */
+void nf_scrub_ip_tos_adjust(struct iphdr *iph
+			    , struct nf_conn *ct)
+{
+	NF_CT_ASSERT(iph);
+	csum_replace2(&iph->check, ntohs(iph->tos), 0);
+	iph->tos = 0;
+}
+
+/*
+ * nf_scrub_ipv4_adjust() [EXPORTED]
+ *
+ * Dispatches transformations according to the ones selected
+ * in nf_scrub_ipv4_adjust().
+ *
+ */
+bool nf_scrub_ipv4_adjust(struct sk_buff *skb
+			  , struct nf_conn *ct
+			  , enum ip_conntrack_info ctinfo)
+{
+	struct iphdr *iph = ip_hdr(skb);
+	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
+	struct tcphdr *th;
+	NF_CT_ASSERT(iph && ct);
+
+	if (ct->scrub & SCRUB_TCP_OPTIONS) {
+		th = (struct tcphdr *) (((caddr_t)iph)+iph->ihl*4);
+		if (!nf_scrub_tcp_parse_options(th, ct, ctinfo))
+			return NF_DROP;
+	}
+
+	if (test_bit(SCRUB_IP_SEALED_TTL_ADJUST_BIT, &ct->scrub)) {
+		if (!nf_scrub_ip_sealed_ttl_adjust(iph, ct))
+			return false;
+	}
+
+	if (dir == IP_CT_DIR_ORIGINAL) {
+		if (test_bit(SCRUB_IP_TTL_ADJUST_BIT, &ct->scrub)) {
+			if (!nf_scrub_ip_ttl_adjust(iph, ct))
+				return false;
+		}
+
+		if (test_bit(SCRUB_IP_RAND_ID_ADJUST_BIT, &ct->scrub)) {
+			if (!nf_scrub_ip_rand_id_adjust(iph, ct))
+				return false;
+		}
+
+		if (test_bit(SCRUB_IP_TOS_ADJUST_BIT, &ct->scrub))
+			nf_scrub_ip_tos_adjust(iph, ct);
+
+		return true;
+	}
+}
+EXPORT_SYMBOL(nf_scrub_ipv4_adjust);
+
+/*
+ * nf_scub_ipv4_setup() [EXPORTED]
+ *
+ *
+ */
+bool nf_scrub_ipv4_setup(const struct sk_buff *skb
+			 , struct nf_conn *ct
+			 , enum ip_conntrack_info ctinfo
+			 , struct ipt_scrub_info *info)
+{
+	struct iphdr *iph = ip_hdr(skb);
+	struct tcphdr *th;
+
+	NF_CT_ASSERT(iph && ct);
+
+	if (iph->protocol == IPPROTO_TCP) {
+		th = (struct tcphdr *)(((caddr_t)iph) + iph->ihl*4); /* XXX: shouldn't we use skb pointer/functions? */
+		nf_scrub_tcp_setup(skb, th, ct,  ctinfo);
+	}
+
+	return true;
+}
+EXPORT_SYMBOL(nf_scrub_ipv4_setup);
diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
index fbf2c14..278a49b 100644
--- a/net/ipv6/netfilter/Makefile
+++ b/net/ipv6/netfilter/Makefile
@@ -29,3 +29,7 @@ obj-$(CONFIG_IP6_NF_MATCH_RT) += ip6t_rt.o
 obj-$(CONFIG_IP6_NF_TARGET_HL) += ip6t_HL.o
 obj-$(CONFIG_IP6_NF_TARGET_LOG) += ip6t_LOG.o
 obj-$(CONFIG_IP6_NF_TARGET_REJECT) += ip6t_REJECT.o
+
+# SCRUB
+obj-$(CONFIG_NF_SCRUB) += nf_scrub_ipv6.o
+obj-$(CONFIG_NF_SCRUB) += ip6t_SCRUB.o
diff --git a/net/ipv6/netfilter/ip6t_SCRUB.c b/net/ipv6/netfilter/ip6t_SCRUB.c
new file mode 100644
index 0000000..9a64aaf
--- /dev/null
+++ b/net/ipv6/netfilter/ip6t_SCRUB.c
@@ -0,0 +1,91 @@
+/* Normalization for netfilter. */
+
+/* (C) 2008 Nicolas Bareil <nico@chdir.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <net/ip.h>
+#include <linux/ip.h>
+#include <linux/tcp.h>
+#include <linux/skbuff.h>
+#include <linux/module.h>
+#include <linux/random.h>
+
+#include <linux/netfilter/x_tables.h>
+#include <net/netfilter/nf_conntrack.h>
+#include <linux/netfilter/nf_conntrack_common.h>
+#include <linux/netfilter_ipv4/ipt_SCRUB.h>
+#include <net/netfilter/nf_scrub.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Nicolas Bareil <nico@chdir.org>");
+MODULE_DESCRIPTION("scrubbing module");
+
+#ifdef CONFIG_NETFILTER_DEBUG
+#define DEBUGP printk
+#else
+#define DEBUGP(format, args...)
+#endif
+
+static struct xt_target ipt_scrub_reg = {
+	.name		= "SCRUB",
+	.family		= AF_INET6,
+	.target		= ipt_scrub_target,
+	.targetsize	= sizeof(struct ipt_scrub_info),
+	.table		= "mangle",
+	.checkentry	= ipt_scrub_checkentry,
+	.me		= THIS_MODULE,
+};
+
+static unsigned int
+ipt_scrub_target(struct sk_buff *skb
+		 , const struct net_device *in
+		 , const struct net_device *out
+		 , unsigned int hooknum
+		 , const struct xt_target *target
+		 , const void *targinfo)
+{
+	struct nf_conn_scrub *nfscrub;
+	struct ipt_scrub_info *info = (struct ipt_scrub_info *)targinfo;
+	struct nf_conn *ct;
+	enum ip_conntrack_info ctinfo; /* XXX */
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (!ct) {
+		DEBUGP("ipt_SCRUB: No conntrack matching this packet.\n");
+		return XT_CONTINUE;
+	}
+	nfscrub = nfct_scrub(ct);
+	if (!nfscrub)
+		nf_scrub_setup(skb, ct, ctinfo, info);
+
+	return XT_CONTINUE; /* XXX final decision: NF_ACCEPT ou XT_CONTINUE ? */
+}
+
+static bool ipt_scrub_checkentry(const char *tablename,
+				 const void *e,
+				 const struct xt_target *target,
+				 void *targinfo,
+				 unsigned int hook_mask)
+{
+	return 1; /* There should be no invalid configuration possible */
+}
+
+/**********************/
+
+static int __init ip_scrub_init(void)
+{
+	int ret = xt_register_target(&ipt_scrub_reg);
+	return ret;
+}
+
+static void __exit ip_scrub_cleanup(void)
+{
+	xt_unregister_target(&ipt_scrub_reg);
+}
+
+module_init(ip_scrub_init);
+module_exit(ip_scrub_cleanup);
diff --git a/net/ipv6/netfilter/nf_scrub_ipv6.c b/net/ipv6/netfilter/nf_scrub_ipv6.c
new file mode 100644
index 0000000..982bc10
--- /dev/null
+++ b/net/ipv6/netfilter/nf_scrub_ipv6.c
@@ -0,0 +1,88 @@
+/* (C) 2007 Nicolas Bareil <nico@chdir.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/netfilter.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+
+#include <net/netfilter/nf_scrub.h>
+#include <net/netfilter/nf_scrub_tcp.h>
+#include <net/netfilter/nf_conntrack_l3proto.h>
+#include <linux/netfilter_ipv6/nf_scrub.h>
+#include <linux/netfilter/nf_conntrack_common.h>
+
+#include <net/tcp.h>
+#include <net/ipv6.h>
+#include <linux/ipv6.h>
+#include <linux/ip.h>
+#include <linux/tcp.h>
+#include <linux/skbuff.h>
+#include <linux/module.h>
+#include <linux/random.h>
+
+#include <linux/netfilter/x_tables.h>
+
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Nicolas Bareil <nico@chdir.org>");
+MODULE_DESCRIPTION("ipv6 scrubbing module");
+
+#ifdef CONFIG_NETFILTER_DEBUG
+#define DEBUGP printk
+#else
+#define DEBUGP(format, args...)
+#endif
+
+bool nf_scrub_ipv6_adjust(struct sk_buff *skb
+			  , struct nf_conn *ct
+			  , enum ip_conntrack_info ctinfo)
+{
+	struct ipv6hdr *ip6h;
+	struct tcphdr *tcp;
+	unsigned int tcpoff;
+	u_int8_t nexthdr;
+
+	ip6h = ipv6_hdr(skb);
+	NF_CT_ASSERT(ip6h);
+	
+	nexthdr = ip6h->nexthdr;
+	tcpoff = ipv6_skip_exthdr(skb, sizeof(*ip6h), &nexthdr);
+	if (tcpoff < 0)
+		return false;
+
+	if ((nexthdr == IPPROTO_TCP) && (ct->scrub & SCRUB_TCP_OPTIONS)) {
+		tcp = (struct tcphdr *)(skb_network_header(skb)+tcpoff);
+		return nf_scrub_tcp_parse_options(tcp, ct, ctinfo);
+	}
+	return true;
+}
+EXPORT_SYMBOL(nf_scrub_ipv6_adjust);
+
+bool nf_scrub_ipv6_setup(const struct sk_buff *skb
+			 , struct nf_conn *ct
+			 , enum ip_conntrack_info ctinfo
+			 , struct ipt_scrub_info *info)
+{
+	struct ipv6hdr *ip6h;
+	struct tcphdr *tcp;
+	unsigned int tcpoff;
+	u_int8_t nexthdr;
+
+	ip6h = ipv6_hdr(skb);
+	NF_CT_ASSERT(ip6h);
+		
+	nexthdr = ip6h->nexthdr;
+	tcpoff = ipv6_skip_exthdr(skb, sizeof(*ip6h), &nexthdr);
+	if (tcpoff < 0)
+		return false;
+
+	if (nexthdr == IPPROTO_TCP) {
+		tcp = (struct tcphdr *)(skb_network_header(skb)+tcpoff);
+		nf_scrub_tcp_setup(skb, tcp, ct, ctinfo);
+	}
+	return true;
+}
+EXPORT_SYMBOL(nf_scrub_ipv6_setup);
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index aa8d80c..4b7d205 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -828,5 +828,23 @@ config NETFILTER_XT_MATCH_HASHLIMIT
 	  destination address' or `500pps from any given source address'
 	  with a single rule.
 
+config NF_SCRUB
+	tristate "Packet normalization"
+	depends on NF_CONNTRACK
+	default n
+	help
+	   Packet's field are normalized by Netfilter.
+
+config NF_SCRUB_NEEDED
+	bool
+	depends on NF_SCRUB
+	default y
+
+config IP_NF_TARGET_SCRUB
+       tristate "SCRUB target"
+       depends on NF_SCRUB && IP_NF_IPTABLES && NF_CONNTRACK
+       help
+          Scrubbing is the process of packet normalization.
+
 endmenu
 
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 5c4b183..3d025f8 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -83,3 +83,7 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_STRING) += xt_string.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_TCPMSS) += xt_tcpmss.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_TIME) += xt_time.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_U32) += xt_u32.o
+
+# SCRUB
+obj-$(CONFIG_NF_SCRUB) += nf_scrub_core.o
+obj-$(CONFIG_NF_SCRUB) += nf_scrub_core_tcp.o
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index ba94004..3c000b9 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -26,6 +26,10 @@
 #include <net/netfilter/nf_conntrack_ecache.h>
 #include <net/netfilter/nf_log.h>
 
+#ifdef CONFIG_NF_SCRUB_NEEDED
+#   include <net/netfilter/nf_scrub_tcp.h>
+#endif
+
 /* Protects ct->proto.tcp */
 static DEFINE_RWLOCK(tcp_lock);
 
@@ -819,6 +823,20 @@ static int tcp_packet(struct nf_conn *ct,
 	new_state = tcp_conntracks[dir][index][old_state];
 	tuple = &ct->tuplehash[dir].tuple;
 
+#ifdef CONFIG_NF_SCRUB_NEEDED
+	/*
+	 * we don't care if the scrubbing code is compiled but the
+	 * module is not loaded because the test_bit() test will
+	 * fail.
+	 */
+
+	if (test_bit(SCRUB_TCP_SEQ_ADJUST_BIT, &ct->scrub)
+	    && dir == IP_CT_DIR_ORIGINAL) {
+		if (!nf_scrub_tcp_seq_adjust((struct tcphdr *)th, ct, ctinfo))
+			return -NF_ACCEPT;
+	}
+#endif
+
 	switch (new_state) {
 	case TCP_CONNTRACK_SYN_SENT:
 		if (old_state < TCP_CONNTRACK_TIME_WAIT)
@@ -930,6 +948,17 @@ static int tcp_packet(struct nf_conn *ct,
 		write_unlock_bh(&tcp_lock);
 		return -NF_ACCEPT;
 	}
+#ifdef CONFIG_NF_SCRUB_NEEDED
+	if (test_bit(SCRUB_TCP_SEQ_ADJUST_BIT, &ct->scrub)
+	    && dir == IP_CT_DIR_REPLY) {
+		if (!nf_scrub_tcp_ack_adjust((struct tcphdr *)th, ct, ctinfo))
+			return -NF_ACCEPT;
+
+		if (!nf_scrub_tcp_sack_adjust((struct tcphdr *)th, ct, ctinfo))
+			return -NF_ACCEPT;
+	}
+#endif
+
      in_window:
 	/* From now on we have got in-window packets */
 	ct->proto.tcp.last_index = index;
diff --git a/net/netfilter/nf_scrub_core.c b/net/netfilter/nf_scrub_core.c
new file mode 100644
index 0000000..abcf23e
--- /dev/null
+++ b/net/netfilter/nf_scrub_core.c
@@ -0,0 +1,216 @@
+/* (C) 2007 Nicolas Bareil <nico@chdir.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/netfilter.h>
+#include <net/netfilter/nf_scrub.h>
+#include <net/netfilter/nf_scrub_tcp.h>
+#include <linux/netfilter_ipv4/nf_scrub.h>
+#include <linux/netfilter_ipv6/nf_scrub.h>
+#include <linux/netfilter/nf_conntrack_common.h>
+#include <linux/netfilter_ipv4.h>
+
+#include <net/ip.h>
+#include <net/tcp.h>
+#include <linux/ip.h>
+#include <linux/tcp.h>
+#include <linux/skbuff.h>
+#include <linux/module.h>
+#include <linux/random.h>
+
+#include <linux/netfilter/x_tables.h>
+
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Nicolas Bareil <nico@chdir.org>");
+MODULE_DESCRIPTION("scrubbing module");
+
+#ifdef CONFIG_NETFILTER_DEBUG
+#define DEBUGP printk
+#else
+#define DEBUGP(format, args...)
+#endif
+
+
+/**********************/
+
+static struct nf_ct_ext_type scrub_extend __read_mostly = {
+	.len		= sizeof(struct nf_conn_scrub),
+	.align		= __alignof__(struct nf_conn_scrub),
+	.destroy	= NULL, /* XXX */
+	.move		= NULL, /* XXX */
+	.id		= NF_CT_EXT_SCRUB,
+	.flags		= NF_CT_EXT_F_PREALLOC,
+};
+
+static struct nf_hook_ops nf_scrub_ops[] = {
+	/* After conntrack, adjust sequence number */
+	{
+		.hook		= nf_scrub_adjust,
+		.owner		= THIS_MODULE,
+		.pf		= PF_INET,
+		.hooknum	= NF_INET_PRE_ROUTING,
+		.priority	= NF_IP_PRI_LAST - 1, /* XXX */
+	},
+	/* After conntrack, adjust sequence number */
+	{
+		.hook		= nf_scrub_adjust,
+		.owner		= THIS_MODULE,
+		.pf		= PF_INET6,
+		.hooknum	= NF_INET_PRE_ROUTING,
+		.priority	= NF_IP_PRI_LAST - 1, /* XXX */
+	},
+	/* After conntrack, adjust sequence number */
+	{
+		.hook		= nf_scrub_adjust,
+		.owner		= THIS_MODULE,
+		.pf		= PF_INET6,
+		.hooknum	= NF_INET_LOCAL_IN,
+		.priority	= NF_IP_PRI_LAST - 1, /* XXX */
+	},
+	/* After conntrack, adjust sequence number */
+	{
+		.hook		= nf_scrub_adjust,
+		.owner		= THIS_MODULE,
+		.pf		= PF_INET,
+		.hooknum	= NF_INET_LOCAL_IN,
+		.priority	= NF_IP_PRI_LAST - 1, /* XXX */
+	},
+};
+
+/**********************/
+
+unsigned int nf_scrub_adjust(unsigned int hooknum
+			     , struct sk_buff *skb
+			     , const struct net_device *in
+			     , const struct net_device *out
+			     , int (*okfn)(struct sk_buff *))
+{
+	struct nf_conn *ct;
+	struct iphdr *iph = ip_hdr(skb);
+	enum ip_conntrack_info ctinfo;
+
+	NF_CT_ASSERT(skb && iph);
+	if (!skb || !iph)
+		return NF_DROP;
+
+	if (!skb_make_writable(skb, skb->len))
+		return NF_DROP;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (!ct)
+		return NF_ACCEPT;
+
+	switch (iph->version) {
+	case 4:
+		if (!nf_scrub_ipv4_adjust(skb, ct, ctinfo))
+			return NF_DROP;
+		break;
+
+	case 6:
+		if (!nf_scrub_ipv6_adjust(skb, ct, ctinfo))
+			return NF_DROP;
+		break;
+
+	default:
+		/* it's not our task to perform filtering
+		 * so we let it pass */
+		return NF_ACCEPT;
+	}
+
+	return	NF_ACCEPT;
+}
+
+/***********************/
+
+/*
+ * nf_scrub_setup will do all initialization like the TCP sequence
+ * the TTL, etc.
+ * This function must be called by the ipt_SCRUB.c
+ */
+
+unsigned int nf_scrub_setup(const struct sk_buff *skb
+			    , struct nf_conn *ct
+			    , enum ip_conntrack_info ctinfo
+			    , struct ipt_scrub_info *info)
+{
+	struct nf_conn_scrub *scrub;
+	struct iphdr *iph = ip_hdr(skb);
+
+	if (!skb_make_writable(skb, skb->len))
+		return NF_DROP;
+
+	scrub = nfct_scrub(ct);
+	if (!scrub) {
+		scrub = nf_ct_ext_add(ct, NF_CT_EXT_SCRUB, GFP_ATOMIC);
+		if (scrub == NULL) {
+			DEBUGP("nf_scrub_core: failed to add scrub extension\n");
+			return NF_DROP;
+		}
+
+		ct->scrub = info->flags;
+
+		switch (iph->version) {
+		case 4:
+			memcpy(&(scrub->ttl), &(info->ttl), sizeof(info->ttl));
+			if (!nf_scrub_ipv4_setup(skb, ct, ctinfo, info))
+				return NF_DROP;
+			break;
+
+		case 6:
+			if (!nf_scrub_ipv6_setup(skb, ct, ctinfo, info))
+				return NF_DROP;
+			break;
+
+		default:
+			/* it's not our task to perform filtering
+			 * so we let it pass */
+			return NF_ACCEPT;
+		}
+	} else
+		DEBUGP("nf_scrub_core: Already a nf_conn_scrub, WTF?\n");
+	return NF_ACCEPT;
+}
+EXPORT_SYMBOL(nf_scrub_setup);
+
+/**********************/
+
+static int __init nf_scrub_init(void)
+{
+	int ret;
+
+	need_conntrack();
+
+	ret = nf_ct_extend_register(&scrub_extend);
+	if (ret < 0) {
+		printk(KERN_ERR "nf_scrub_core: Unable to register extension\n");
+		return ret;
+	}
+
+	ret = nf_register_hooks(nf_scrub_ops, ARRAY_SIZE(nf_scrub_ops));
+	if (ret < 0) {
+		printk(KERN_ERR "nf_scrub_init: can't register hooks.\n");
+		goto cleanup_extend;
+	}
+
+	return ret;
+
+cleanup_extend:
+	nf_ct_extend_unregister(&scrub_extend);
+
+	return ret;
+}
+
+static void __exit nf_scrub_fini(void)
+{
+	nf_unregister_hooks(nf_scrub_ops, ARRAY_SIZE(nf_scrub_ops));
+	nf_ct_extend_unregister(&scrub_extend);
+}
+
+/**********************/
+
+module_init(nf_scrub_init);
+module_exit(nf_scrub_fini);
diff --git a/net/netfilter/nf_scrub_core_tcp.c b/net/netfilter/nf_scrub_core_tcp.c
new file mode 100644
index 0000000..0e691f8
--- /dev/null
+++ b/net/netfilter/nf_scrub_core_tcp.c
@@ -0,0 +1,358 @@
+/* Normalization for netfilter. */
+
+/* (C) 2008 Nicolas Bareil <nico@chdir.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/netfilter.h>
+#include <net/netfilter/nf_scrub.h>
+#include <net/netfilter/nf_scrub_tcp.h>
+#include <linux/netfilter/nf_conntrack_common.h>
+#include <linux/netfilter_ipv4.h>
+
+#include <net/ip.h>
+#include <net/tcp.h>
+#include <linux/ip.h>
+#include <linux/tcp.h>
+#include <linux/skbuff.h>
+#include <linux/module.h>
+#include <linux/random.h>
+
+#include <linux/netfilter/x_tables.h>
+
+#ifdef CONFIG_NETFILTER_DEBUG
+#define DEBUGP printk
+#else
+#define DEBUGP(format, args...)
+#endif
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Nicolas Bareil <nico@chdir.org>");
+MODULE_DESCRIPTION("scrubbing module");
+
+/*
+ * nf_scrub_tcp_seq_adjust() [EXPORTED]
+ *
+ * Adjusts the sequence number in a TCP packet, or in the inner TCP packet of an
+ * ICMP message.
+ *
+ * We do not do any check of validity of the sequence number, this is the job
+ * of tcp_in_window() which will be tested later in tcp_pkt().
+ *
+ * The goal is to be transparent for the tcp_in_window() : it only works with
+ * the values non transformed. So tcp_pkt() looks like :
+ *
+ * 1. nf_scrub_tcp_seq_adjust()
+ * 2. tcp_in_window()
+ * 3. nf_scrub_tcp_ack_adjust()
+ *
+ */
+bool nf_scrub_tcp_seq_adjust(struct tcphdr *th
+			    , struct nf_conn *ct
+			    , enum ip_conntrack_info ctinfo)
+{
+	struct nf_conn_scrub *scrub = nfct_scrub(ct);
+	__u32 newseq;
+
+	NF_CT_ASSERT(scrub && ct && th && scrub->proto.tcp.seqoffset);
+	newseq = ntohl(th->seq) + scrub->proto.tcp.seqoffset;
+	csum_replace4(&th->check, th->seq, htonl(newseq));
+	th->seq = htonl(newseq);
+
+	return true;
+}
+EXPORT_SYMBOL(nf_scrub_tcp_seq_adjust);
+
+/*
+ * nf_scrub_tcp_ack_adjust() [EXPORTED]
+ *
+ * Like nf_scrub_tcp_seq_adjust(), but for ACK in the REPLY direction.
+ */
+bool nf_scrub_tcp_ack_adjust(struct tcphdr *th
+			     , struct nf_conn *ct
+			     , enum ip_conntrack_info ctinfo)
+{
+	struct nf_conn_scrub *scrub = nfct_scrub(ct);
+	__u32 newseq;
+
+	NF_CT_ASSERT(scrub && th && ct && scrub->proto.tcp.seqoffset);
+
+	if (th->ack) {
+		/* modify ack instead of seq */
+		newseq = htonl(th->ack_seq) - scrub->proto.tcp.seqoffset;
+		csum_replace4(&th->check, th->ack_seq, htonl(newseq));
+		th->ack_seq = htonl(newseq);
+	}
+
+	return true;
+}
+EXPORT_SYMBOL(nf_scrub_tcp_ack_adjust);
+
+/*
+ * nf_scrub_tcp_sack_adjust() [EXPORTED]
+ *
+ * Like nf_scrub_tcp_ack_adjust(), but for SACK in the REPLY direction.
+ *
+ * We have to parse TCP options to look for the TCPOPT_SACK field and
+ * adjust it with nf_scrub_tcp_sack_adjust_block()
+ *
+ */
+bool nf_scrub_tcp_sack_adjust(struct tcphdr *th
+			      , struct nf_conn *ct
+			      , enum ip_conntrack_info ctinfo)
+{
+	struct nf_conn_scrub *scrub = nfct_scrub(ct);
+	struct tcpopt *opt;
+	int len;
+
+
+	NF_CT_ASSERT(scrub && th && scrub->proto.tcp.seqoffset);
+	opt = (struct tcpopt *)(th+1);
+
+	len = (th->doff << 2) - sizeof(struct tcphdr);
+	while (len > 0) {
+		int off = 0;
+		switch (opt->kind) {
+		case TCPOPT_EOL:
+			if (len > 1)
+				return false;
+			else
+				return true;
+
+		case TCPOPT_NOP:
+			off++;
+			break;
+
+		case TCPOPT_SACK:
+			nf_scrub_tcp_sack_adjust_block(th
+						       , (struct tcp_sack_block *)(opt+1)
+						       , opt->length - sizeof(struct tcpopt)
+						       , scrub->proto.tcp.seqoffset);
+			off = opt->length;
+			break;
+
+		default:
+			off = opt->length;
+		}
+
+		opt = (struct tcpopt *) (((caddr_t)opt) + off);
+		len -= off;
+	}
+	return true;
+}
+EXPORT_SYMBOL(nf_scrub_tcp_sack_adjust);
+
+/*
+ * A SACK block looks like this :
+ *
+ *               --------------
+ *               |Kind=5| Len |
+ *  ---------------------------
+ *  | Left  Edge | Right Edge |
+ *  ---------------------------
+ *  | Left  Edge | Right Edge |
+ *  ---------------------------
+ *  \                         /
+ *  /       <Length>          \
+ *  \                         /
+ *  ---------------------------
+ *
+ * Left Edge of Block   This is the first sequence number of this block.
+ * Right Edge of Block  This is the sequence number immediately following
+ *                      the last sequence number of this block.
+ */
+void nf_scrub_tcp_sack_adjust_block(struct tcphdr *th
+				    , struct tcp_sack_block *block
+				    , unsigned char len
+				    , unsigned int offset)
+{
+	unsigned int tmp;
+
+	while (len >= sizeof(*block)) {
+		tmp = htonl(ntohl(block->start_seq) - offset);
+		csum_replace4(&th->check, block->start_seq, tmp);
+		block->start_seq = htonl(ntohl(block->start_seq) - offset);
+
+		tmp = htonl(ntohl(block->end_seq) - offset);
+		csum_replace4(&th->check, block->end_seq, tmp);
+		block->end_seq = htonl(ntohl(block->end_seq) - offset);
+
+		block = block+1;
+		len -= sizeof(*block);
+	}
+}
+
+/*
+ * nf_scrub_tcp_parse_options() [EXPORTED]
+ *
+ * Parse TCP options and apply needed transformations. We can't mutualize
+ * nf_scrub_tcp_parse_options() and nf_scrub_tcp_sack_adjust() because they
+ * are called at different time.
+ */
+bool nf_scrub_tcp_parse_options(struct tcphdr *th
+				, struct nf_conn *ct
+				, enum ip_conntrack_info ctinfo)
+{
+	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
+	struct tcpopt *opt;
+	int len;
+
+	NF_CT_ASSERT(th);
+
+	opt = (struct tcpopt *)(th+1);
+	len = (th->doff << 2) - sizeof(struct tcphdr);
+	while (len > 0) {
+		int off = 0;
+
+		switch (opt->kind) {
+		case TCPOPT_EOL:
+			if (len > 1)
+				/*
+				 * there should not be trailing option
+				 * after TCPOPT_EOL
+				 */
+				return false;
+			else
+				return true;
+
+		case TCPOPT_NOP:
+			off++;
+			break;
+
+		case TCPOPT_TIMESTAMP:
+			if (test_bit(SCRUB_TCP_OPT_TIMESTAMP_ADJUST_BIT, &ct->scrub)) {
+				if (!nf_scrub_tcp_opt_timestamp(th, ct, (__u32 *)(opt+1), dir))
+					return false;
+			}
+			off = opt->length;
+			break;
+
+		case TCPOPT_MSS:
+			if (!nf_scrub_tcp_opt_mss(th, ct, (__u16 *)(opt+1), dir))
+				return false;
+			off = opt->length;
+			break;
+
+		case TCPOPT_SACK:
+		case TCPOPT_SACK_PERM:
+		case TCPOPT_WINDOW:
+		case TCPOPT_MD5SIG:
+			off = opt->length;
+			break;
+		default:
+			off = opt->length;
+			printk(KERN_ERR "nf_scrub: Invalid TCP Options [kind=%d], dropping", opt->kind);
+			return false;
+		}
+		opt = (struct tcpopt *) (((caddr_t)opt) + off);
+		len -= off;
+	}
+
+	return true;
+}
+EXPORT_SYMBOL(nf_scrub_tcp_parse_options);
+
+/*
+ * nf_scrub_tcp_opt_mss()
+ *
+ * Performs basic validity tests, we make sure the MSS option
+ * is not null and only present in SYN packet.
+ *
+ */
+bool nf_scrub_tcp_opt_mss(struct tcphdr *th
+			  , struct nf_conn *ct
+			  , __u16 *mss
+			  , enum ip_conntrack_dir dir)
+{
+	NF_CT_ASSERT(th);
+
+	/* MSS is only valid in SYN packets */
+	if (!th->syn)
+		return false;
+
+	/* MSS=0 is non-sense! divide by 0 attack? */
+	if (*mss == 0)
+		return false;
+
+	return true;
+}
+
+/*
+ * nf_scrub_tcp_opt_timestamp()
+ *
+ * We derive the timestamp sent with a 32 random bits (sorted in nf_scrub_tcp_setup())
+ *
+ * The format of the Timestamp option is :
+ *
+ *    +-------+-------+---------------------+---------------------+
+ *    |Kind=8 |  10   |   TS Value (TSval)  |TS Echo Reply (TSecr)|
+ *    +-------+-------+---------------------+---------------------+
+*/
+bool nf_scrub_tcp_opt_timestamp(struct tcphdr *th
+				, struct nf_conn *ct
+				, __u32 *base_tstamp
+				, enum ip_conntrack_dir dir)
+{
+	struct nf_conn_scrub *scrub = nfct_scrub(ct);
+	__u32 new_timestamp;
+
+	NF_CT_ASSERT(scrub && th && scrub->proto.tcp.tstampoff && base_tstamp);
+
+	if (dir == IP_CT_DIR_ORIGINAL) {
+		new_timestamp = htonl(ntohl(*base_tstamp) - ntohl(scrub->proto.tcp.tstampoff));
+
+	} else {
+		base_tstamp += 1; /* go to the next block (the sent timestamp) */
+		new_timestamp = htonl(ntohl(*base_tstamp) + ntohl(scrub->proto.tcp.tstampoff));
+	}
+	csum_replace4(&th->check, *base_tstamp, new_timestamp);
+	*base_tstamp = new_timestamp;
+
+	return true;
+}
+
+/*
+ * nf_scrub_tcp_setup() [EXPORTED]
+ *
+ * Initialize the TCP scrubbing options accordingly to the options
+ * given by the iptables rules.
+ *
+ * We chose random value for the sequence number and timestamp offset,
+ */
+void nf_scrub_tcp_setup(const struct sk_buff *skb
+			, struct tcphdr *th
+			, struct nf_conn *ct
+			, enum ip_conntrack_info ctinfo)
+{
+	struct nf_conn_scrub *scrub;
+	u32 newseq;
+
+	NF_CT_ASSERT(th && ct);
+	scrub = nfct_scrub(ct);
+	NF_CT_ASSERT(scrub);
+
+	if (test_bit(SCRUB_TCP_SEQ_ADJUST_BIT, &ct->scrub)) {
+		newseq = 0;
+		get_random_bytes(&newseq, sizeof(newseq));
+
+		/* the following difference can overwrap, nevermind */
+		scrub->proto.tcp.seqoffset = newseq - ntohl(th->seq);
+		nf_scrub_tcp_seq_adjust(th, ct, ctinfo);
+		ct->proto.tcp.last_end = newseq+1;
+		if (after(newseq, ct->proto.tcp.seen[IP_CT_DIR_ORIGINAL].td_end))
+			ct->proto.tcp.seen[IP_CT_DIR_ORIGINAL].td_end = newseq+1;
+		ct->proto.tcp.seen[IP_CT_DIR_ORIGINAL].td_end	 = newseq+1;
+		ct->proto.tcp.seen[IP_CT_DIR_ORIGINAL].td_maxend = newseq+1;
+	}
+
+	if (test_bit(SCRUB_TCP_OPT_TIMESTAMP_ADJUST_BIT, &ct->scrub))
+		get_random_bytes(&scrub->proto.tcp.tstampoff
+				 , sizeof(scrub->proto.tcp.tstampoff));
+
+	if (test_bit(SCRUB_IP_SEALED_TTL_ADJUST_BIT, &ct->scrub))
+		scrub->proto.tcp.sealedttl = 0;
+}
+EXPORT_SYMBOL(nf_scrub_tcp_setup);




