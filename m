From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 07/17]: conntrack: add sysctl to disable checksumming
Date: Tue, 30 May 2006 00:34:19 +0200 (MEST)
Message-ID: <20060529223418.24834.13407.sendpatchset@localhost.localdomain>
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

[NETFILTER]: conntrack: add sysctl to disable checksumming

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 951256425de86a32569c787ff827554314026824
tree 604ff1fd7cdfe02990d34d78a8da24e38bbe05ab
parent ee0877ce5fb4e72afee68e2c393d86ac64e69afe
author Patrick McHardy <kaber@trash.net> Tue, 30 May 2006 00:02:44 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 30 May 2006 00:02:44 +0200

 include/linux/netfilter_ipv4/ip_conntrack.h    |    1 +
 include/linux/sysctl.h                         |    2 ++
 include/net/netfilter/nf_conntrack.h           |    1 +
 net/ipv4/netfilter/ip_conntrack_proto_icmp.c   |    2 +-
 net/ipv4/netfilter/ip_conntrack_proto_tcp.c    |    2 +-
 net/ipv4/netfilter/ip_conntrack_proto_udp.c    |    2 +-
 net/ipv4/netfilter/ip_conntrack_standalone.c   |   11 +++++++++++
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |    2 +-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |    2 +-
 net/netfilter/nf_conntrack_proto_tcp.c         |    5 +++--
 net/netfilter/nf_conntrack_proto_udp.c         |    3 ++-
 net/netfilter/nf_conntrack_standalone.c        |   11 +++++++++++
 12 files changed, 36 insertions(+), 8 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ip_conntrack.h b/include/linux/netfilter_ipv4/ip_conntrack.h
index d54d7b2..5473c01 100644
--- a/include/linux/netfilter_ipv4/ip_conntrack.h
+++ b/include/linux/netfilter_ipv4/ip_conntrack.h
@@ -293,6 +293,7 @@ static inline int is_dying(struct ip_con
 }
 
 extern unsigned int ip_conntrack_htable_size;
+extern int ip_conntrack_checksum;
  
 #define CONNTRACK_STAT_INC(count) (__get_cpu_var(ip_conntrack_stat).count++)
 
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index cd9e7c0..98338ed 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -313,6 +313,7 @@ enum
 	NET_NF_CONNTRACK_FRAG6_TIMEOUT=29,
 	NET_NF_CONNTRACK_FRAG6_LOW_THRESH=30,
 	NET_NF_CONNTRACK_FRAG6_HIGH_THRESH=31,
+	NET_NF_CONNTRACK_CHECKSUM=32,
 };
 
 /* /proc/sys/net/ipv4 */
@@ -492,6 +493,7 @@ enum
  	NET_IPV4_NF_CONNTRACK_SCTP_TIMEOUT_SHUTDOWN_RECD=25,
  	NET_IPV4_NF_CONNTRACK_SCTP_TIMEOUT_SHUTDOWN_ACK_SENT=26,
 	NET_IPV4_NF_CONNTRACK_COUNT=27,
+	NET_IPV4_NF_CONNTRACK_CHECKSUM=28,
 };
  
 /* /proc/sys/net/ipv6 */
diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 916013c..dbe7a11 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -285,6 +285,7 @@ static inline int nf_ct_is_dying(struct 
 }
 
 extern unsigned int nf_conntrack_htable_size;
+extern int nf_conntrack_checksum;
 
 #define NF_CT_STAT_INC(count) (__get_cpu_var(nf_conntrack_stat).count++)
 
diff --git a/net/ipv4/netfilter/ip_conntrack_proto_icmp.c b/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
index d8b14a9..23f1c50 100644
--- a/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
@@ -224,7 +224,7 @@ icmp_error(struct sk_buff *skb, enum ip_
 	}
 
 	/* See ip_conntrack_proto_tcp.c */
-	if (hooknum == NF_IP_PRE_ROUTING &&
+	if (ip_conntrack_checksum && hooknum == NF_IP_PRE_ROUTING &&
 	    nf_ip_checksum(skb, hooknum, skb->nh.iph->ihl * 4, 0)) {
 		if (LOG_INVALID(IPPROTO_ICMP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL, NULL,
diff --git a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
index 062b252..c5c2ce5 100644
--- a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
+++ b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
@@ -870,7 +870,7 @@ static int tcp_error(struct sk_buff *skb
 	 * and moreover root might send raw packets.
 	 */
 	/* FIXME: Source route IP option packets --RR */
-	if (hooknum == NF_IP_PRE_ROUTING &&
+	if (ip_conntrack_checksum && hooknum == NF_IP_PRE_ROUTING &&
 	    nf_ip_checksum(skb, hooknum, iph->ihl * 4, IPPROTO_TCP)) {
 		if (LOG_INVALID(IPPROTO_TCP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL, NULL,
diff --git a/net/ipv4/netfilter/ip_conntrack_proto_udp.c b/net/ipv4/netfilter/ip_conntrack_proto_udp.c
index 7089986..9b2c16b 100644
--- a/net/ipv4/netfilter/ip_conntrack_proto_udp.c
+++ b/net/ipv4/netfilter/ip_conntrack_proto_udp.c
@@ -120,7 +120,7 @@ static int udp_error(struct sk_buff *skb
 	 * because the semantic of CHECKSUM_HW is different there 
 	 * and moreover root might send raw packets.
 	 * FIXME: Source route IP option packets --RR */
-	if (hooknum == NF_IP_PRE_ROUTING &&
+	if (ip_conntrack_checksum && hooknum == NF_IP_PRE_ROUTING &&
 	    nf_ip_checksum(skb, hooknum, iph->ihl * 4, IPPROTO_UDP)) {
 		if (LOG_INVALID(IPPROTO_UDP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL, NULL,
diff --git a/net/ipv4/netfilter/ip_conntrack_standalone.c b/net/ipv4/netfilter/ip_conntrack_standalone.c
index f0cc7fe..6cb9b98 100644
--- a/net/ipv4/netfilter/ip_conntrack_standalone.c
+++ b/net/ipv4/netfilter/ip_conntrack_standalone.c
@@ -564,6 +564,8 @@ extern unsigned int ip_ct_generic_timeou
 static int log_invalid_proto_min = 0;
 static int log_invalid_proto_max = 255;
 
+int ip_conntrack_checksum = 1;
+
 static struct ctl_table_header *ip_ct_sysctl_header;
 
 static ctl_table ip_ct_sysctl_table[] = {
@@ -592,6 +594,14 @@ static ctl_table ip_ct_sysctl_table[] = 
 		.proc_handler	= &proc_dointvec,
 	},
 	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_CHECKSUM,
+		.procname	= "ip_conntrack_checksum",
+		.data		= &ip_conntrack_checksum,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
 		.ctl_name	= NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_SYN_SENT,
 		.procname	= "ip_conntrack_tcp_timeout_syn_sent",
 		.data		= &ip_ct_tcp_timeout_syn_sent,
@@ -946,6 +956,7 @@ EXPORT_SYMBOL_GPL(__ip_conntrack_helper_
 EXPORT_SYMBOL_GPL(ip_conntrack_proto_find_get);
 EXPORT_SYMBOL_GPL(ip_conntrack_proto_put);
 EXPORT_SYMBOL_GPL(__ip_conntrack_proto_find);
+EXPORT_SYMBOL_GPL(ip_conntrack_checksum);
 #if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
     defined(CONFIG_IP_NF_CONNTRACK_NETLINK_MODULE)
 EXPORT_SYMBOL_GPL(ip_ct_port_tuple_to_nfattr);
diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index 4b0d361..663a73e 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -235,7 +235,7 @@ icmp_error(struct sk_buff *skb, unsigned
 	}
 
 	/* See ip_conntrack_proto_tcp.c */
-	if (hooknum == NF_IP_PRE_ROUTING &&
+	if (nf_conntrack_checksum && hooknum == NF_IP_PRE_ROUTING &&
 	    nf_ip_checksum(skb, hooknum, dataoff, 0)) {
 		if (LOG_INVALID(IPPROTO_ICMP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL, NULL,
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index 86c6703..ef18a7b 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -233,7 +233,7 @@ icmpv6_error(struct sk_buff *skb, unsign
 		return -NF_ACCEPT;
 	}
 
-	if (hooknum == NF_IP6_PRE_ROUTING &&
+	if (nf_conntrack_checksum && hooknum == NF_IP6_PRE_ROUTING &&
 	    nf_ip6_checksum(skb, hooknum, dataoff, IPPROTO_ICMPV6)) {
 		nf_log_packet(PF_INET6, 0, skb, NULL, NULL, NULL,
 			      "nf_ct_icmpv6: ICMPv6 checksum failed\n");
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 69899f2..12fb7c0 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -828,8 +828,9 @@ static int tcp_error(struct sk_buff *skb
 	 * and moreover root might send raw packets.
 	 */
 	/* FIXME: Source route IP option packets --RR */
-	if (((pf == PF_INET && hooknum == NF_IP_PRE_ROUTING) ||
-	     (pf == PF_INET6 && hooknum  == NF_IP6_PRE_ROUTING)) &&
+	if (nf_conntrack_checksum &&
+	    ((pf == PF_INET && hooknum == NF_IP_PRE_ROUTING) ||
+	     (pf == PF_INET6 && hooknum == NF_IP6_PRE_ROUTING)) &&
 	    nf_checksum(skb, hooknum, dataoff, IPPROTO_TCP, pf)) {
 		if (LOG_INVALID(IPPROTO_TCP))
 			nf_log_packet(pf, 0, skb, NULL, NULL, NULL,
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index d93edbf..ae07ebe 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -134,7 +134,8 @@ static int udp_error(struct sk_buff *skb
 	 * because the semantic of CHECKSUM_HW is different there
 	 * and moreover root might send raw packets.
 	 * FIXME: Source route IP option packets --RR */
-	if (((pf == PF_INET && hooknum == NF_IP_PRE_ROUTING) ||
+	if (nf_conntrack_checksum &&
+	    ((pf == PF_INET && hooknum == NF_IP_PRE_ROUTING) ||
 	     (pf == PF_INET6 && hooknum == NF_IP6_PRE_ROUTING)) &&
 	    nf_checksum(skb, hooknum, dataoff, IPPROTO_UDP, pf)) {
 		if (LOG_INVALID(IPPROTO_UDP))
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 408960c..e01d20d 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -455,6 +455,8 @@ extern unsigned int nf_ct_generic_timeou
 static int log_invalid_proto_min = 0;
 static int log_invalid_proto_max = 255;
 
+int nf_conntrack_checksum = 1;
+
 static struct ctl_table_header *nf_ct_sysctl_header;
 
 static ctl_table nf_ct_sysctl_table[] = {
@@ -483,6 +485,14 @@ static ctl_table nf_ct_sysctl_table[] = 
 		.proc_handler   = &proc_dointvec,
 	},
 	{
+		.ctl_name	= NET_NF_CONNTRACK_CHECKSUM,
+		.procname	= "nf_conntrack_checksum",
+		.data		= &nf_conntrack_checksum,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
 		.ctl_name	= NET_NF_CONNTRACK_TCP_TIMEOUT_SYN_SENT,
 		.procname	= "nf_conntrack_tcp_timeout_syn_sent",
 		.data		= &nf_ct_tcp_timeout_syn_sent,
@@ -851,6 +861,7 @@ EXPORT_SYMBOL(nf_ct_proto_put);
 EXPORT_SYMBOL(nf_ct_l3proto_find_get);
 EXPORT_SYMBOL(nf_ct_l3proto_put);
 EXPORT_SYMBOL(nf_ct_l3protos);
+EXPORT_SYMBOL_GPL(nf_conntrack_checksum);
 EXPORT_SYMBOL(nf_conntrack_expect_alloc);
 EXPORT_SYMBOL(nf_conntrack_expect_put);
 EXPORT_SYMBOL(nf_conntrack_expect_related);
