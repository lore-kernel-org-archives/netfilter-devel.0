From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH] Clean up makefile
Date: Sat, 20 Oct 2007 13:44:22 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710201344080.1997@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38282 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757340AbXJTLoX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Oct 2007 07:44:23 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Sort matches and targets in the NF makefiles.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 net/ipv4/netfilter/Makefile |   20 ++++++++++----------
 net/ipv6/netfilter/Makefile |   28 ++++++++++++++++------------
 net/netfilter/Makefile      |   14 +++++++-------
 3 files changed, 33 insertions(+), 29 deletions(-)

Index: gitone/net/ipv4/netfilter/Makefile
===================================================================
--- gitone.orig/net/ipv4/netfilter/Makefile
+++ gitone/net/ipv4/netfilter/Makefile
@@ -41,27 +41,27 @@ obj-$(CONFIG_NF_NAT) += iptable_nat.o
 obj-$(CONFIG_IP_NF_RAW) += iptable_raw.o
 
 # matches
+obj-$(CONFIG_IP_NF_MATCH_ADDRTYPE) += ipt_addrtype.o
+obj-$(CONFIG_IP_NF_MATCH_AH) += ipt_ah.o
+obj-$(CONFIG_IP_NF_MATCH_ECN) += ipt_ecn.o
 obj-$(CONFIG_IP_NF_MATCH_IPRANGE) += ipt_iprange.o
 obj-$(CONFIG_IP_NF_MATCH_OWNER) += ipt_owner.o
-obj-$(CONFIG_IP_NF_MATCH_TOS) += ipt_tos.o
 obj-$(CONFIG_IP_NF_MATCH_RECENT) += ipt_recent.o
-obj-$(CONFIG_IP_NF_MATCH_ECN) += ipt_ecn.o
-obj-$(CONFIG_IP_NF_MATCH_AH) += ipt_ah.o
+obj-$(CONFIG_IP_NF_MATCH_TOS) += ipt_tos.o
 obj-$(CONFIG_IP_NF_MATCH_TTL) += ipt_ttl.o
-obj-$(CONFIG_IP_NF_MATCH_ADDRTYPE) += ipt_addrtype.o
 
 # targets
-obj-$(CONFIG_IP_NF_TARGET_REJECT) += ipt_REJECT.o
-obj-$(CONFIG_IP_NF_TARGET_TOS) += ipt_TOS.o
+obj-$(CONFIG_IP_NF_TARGET_CLUSTERIP) += ipt_CLUSTERIP.o
 obj-$(CONFIG_IP_NF_TARGET_ECN) += ipt_ECN.o
+obj-$(CONFIG_IP_NF_TARGET_LOG) += ipt_LOG.o
 obj-$(CONFIG_IP_NF_TARGET_MASQUERADE) += ipt_MASQUERADE.o
-obj-$(CONFIG_IP_NF_TARGET_REDIRECT) += ipt_REDIRECT.o
 obj-$(CONFIG_IP_NF_TARGET_NETMAP) += ipt_NETMAP.o
+obj-$(CONFIG_IP_NF_TARGET_REDIRECT) += ipt_REDIRECT.o
+obj-$(CONFIG_IP_NF_TARGET_REJECT) += ipt_REJECT.o
 obj-$(CONFIG_IP_NF_TARGET_SAME) += ipt_SAME.o
-obj-$(CONFIG_IP_NF_TARGET_LOG) += ipt_LOG.o
-obj-$(CONFIG_IP_NF_TARGET_ULOG) += ipt_ULOG.o
-obj-$(CONFIG_IP_NF_TARGET_CLUSTERIP) += ipt_CLUSTERIP.o
+obj-$(CONFIG_IP_NF_TARGET_TOS) += ipt_TOS.o
 obj-$(CONFIG_IP_NF_TARGET_TTL) += ipt_TTL.o
+obj-$(CONFIG_IP_NF_TARGET_ULOG) += ipt_ULOG.o
 
 # generic ARP tables
 obj-$(CONFIG_IP_NF_ARPTABLES) += arp_tables.o
Index: gitone/net/ipv6/netfilter/Makefile
===================================================================
--- gitone.orig/net/ipv6/netfilter/Makefile
+++ gitone/net/ipv6/netfilter/Makefile
@@ -4,25 +4,29 @@
 
 # Link order matters here.
 obj-$(CONFIG_IP6_NF_IPTABLES) += ip6_tables.o
-obj-$(CONFIG_IP6_NF_MATCH_RT) += ip6t_rt.o
-obj-$(CONFIG_IP6_NF_MATCH_OPTS) += ip6t_hbh.o
-obj-$(CONFIG_IP6_NF_MATCH_IPV6HEADER) += ip6t_ipv6header.o
-obj-$(CONFIG_IP6_NF_MATCH_FRAG) += ip6t_frag.o
-obj-$(CONFIG_IP6_NF_MATCH_AH) += ip6t_ah.o
-obj-$(CONFIG_IP6_NF_MATCH_EUI64) += ip6t_eui64.o
-obj-$(CONFIG_IP6_NF_MATCH_OWNER) += ip6t_owner.o
 obj-$(CONFIG_IP6_NF_FILTER) += ip6table_filter.o
 obj-$(CONFIG_IP6_NF_MANGLE) += ip6table_mangle.o
-obj-$(CONFIG_IP6_NF_TARGET_HL) += ip6t_HL.o
 obj-$(CONFIG_IP6_NF_QUEUE) += ip6_queue.o
-obj-$(CONFIG_IP6_NF_TARGET_LOG) += ip6t_LOG.o
 obj-$(CONFIG_IP6_NF_RAW) += ip6table_raw.o
-obj-$(CONFIG_IP6_NF_MATCH_HL) += ip6t_hl.o
-obj-$(CONFIG_IP6_NF_TARGET_REJECT) += ip6t_REJECT.o
-obj-$(CONFIG_IP6_NF_MATCH_MH) += ip6t_mh.o
 
 # objects for l3 independent conntrack
 nf_conntrack_ipv6-objs  :=  nf_conntrack_l3proto_ipv6.o nf_conntrack_proto_icmpv6.o nf_conntrack_reasm.o
 
 # l3 independent conntrack
 obj-$(CONFIG_NF_CONNTRACK_IPV6) += nf_conntrack_ipv6.o
+
+# matches
+obj-$(CONFIG_IP6_NF_MATCH_AH) += ip6t_ah.o
+obj-$(CONFIG_IP6_NF_MATCH_EUI64) += ip6t_eui64.o
+obj-$(CONFIG_IP6_NF_MATCH_FRAG) += ip6t_frag.o
+obj-$(CONFIG_IP6_NF_MATCH_HL) += ip6t_hl.o
+obj-$(CONFIG_IP6_NF_MATCH_IPV6HEADER) += ip6t_ipv6header.o
+obj-$(CONFIG_IP6_NF_MATCH_MH) += ip6t_mh.o
+obj-$(CONFIG_IP6_NF_MATCH_OPTS) += ip6t_hbh.o
+obj-$(CONFIG_IP6_NF_MATCH_OWNER) += ip6t_owner.o
+obj-$(CONFIG_IP6_NF_MATCH_RT) += ip6t_rt.o
+
+# targets
+obj-$(CONFIG_IP6_NF_TARGET_HL) += ip6t_HL.o
+obj-$(CONFIG_IP6_NF_TARGET_LOG) += ip6t_LOG.o
+obj-$(CONFIG_IP6_NF_TARGET_REJECT) += ip6t_REJECT.o
Index: gitone/net/netfilter/Makefile
===================================================================
--- gitone.orig/net/netfilter/Makefile
+++ gitone/net/netfilter/Makefile
@@ -40,15 +40,15 @@ obj-$(CONFIG_NETFILTER_XTABLES) += x_tab
 # targets
 obj-$(CONFIG_NETFILTER_XT_TARGET_CLASSIFY) += xt_CLASSIFY.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_CONNMARK) += xt_CONNMARK.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_CONNSECMARK) += xt_CONNSECMARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_DSCP) += xt_DSCP.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_MARK) += xt_MARK.o
-obj-$(CONFIG_NETFILTER_XT_TARGET_NFQUEUE) += xt_NFQUEUE.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NFLOG) += xt_NFLOG.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_NFQUEUE) += xt_NFQUEUE.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NOTRACK) += xt_NOTRACK.o
-obj-$(CONFIG_NETFILTER_XT_TARGET_TRACE) += xt_TRACE.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_SECMARK) += xt_SECMARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TCPMSS) += xt_TCPMSS.o
-obj-$(CONFIG_NETFILTER_XT_TARGET_CONNSECMARK) += xt_CONNSECMARK.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_TRACE) += xt_TRACE.o
 
 # matches
 obj-$(CONFIG_NETFILTER_XT_MATCH_COMMENT) += xt_comment.o
@@ -59,22 +59,22 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_CONNTRAC
 obj-$(CONFIG_NETFILTER_XT_MATCH_DCCP) += xt_dccp.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_DSCP) += xt_dscp.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_ESP) += xt_esp.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_HASHLIMIT) += xt_hashlimit.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_HELPER) += xt_helper.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_LENGTH) += xt_length.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_LIMIT) += xt_limit.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_MAC) += xt_mac.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_MARK) += xt_mark.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_MULTIPORT) += xt_multiport.o
-obj-$(CONFIG_NETFILTER_XT_MATCH_POLICY) += xt_policy.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_PHYSDEV) += xt_physdev.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_PKTTYPE) += xt_pkttype.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_POLICY) += xt_policy.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_QUOTA) += xt_quota.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_REALM) += xt_realm.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_SCTP) += xt_sctp.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STATE) += xt_state.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STATISTIC) += xt_statistic.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STRING) += xt_string.o
-obj-$(CONFIG_NETFILTER_XT_MATCH_TIME) += xt_time.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_TCPMSS) += xt_tcpmss.o
-obj-$(CONFIG_NETFILTER_XT_MATCH_PHYSDEV) += xt_physdev.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_TIME) += xt_time.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_U32) += xt_u32.o
-obj-$(CONFIG_NETFILTER_XT_MATCH_HASHLIMIT) += xt_hashlimit.o

