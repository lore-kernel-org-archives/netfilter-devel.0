From: Art Haas <ahaas@airmail.net>
Subject: [PATCH] Add C99 initializers for net/ipv6/netfilter code
Date: Sun, 16 Mar 2003 14:29:52 -0600
Sender: linux-net-owner@vger.kernel.org
Message-ID: <20030316202952.GB9134@debian>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-net-owner@vger.kernel.org>
To: netfilter-devel@lists.netfilter.org, linux-net@vger.kernel.org
Content-Disposition: inline
List-Id: netfilter-devel.vger.kernel.org

Hi.

Here is the promised patch set for the ipv6 code.

Art Haas

===== net/ipv6/netfilter/ip6_queue.c 1.7 vs edited =====
--- 1.7/net/ipv6/netfilter/ip6_queue.c	Mon Feb 24 00:41:51 2003
+++ edited/net/ipv6/netfilter/ip6_queue.c	Sat Mar 15 13:13:01 2003
@@ -558,9 +558,7 @@
 }
 
 static struct notifier_block ipq_dev_notifier = {
-	ipq_rcv_dev_event,
-	NULL,
-	0
+	.notifier_call	= ipq_rcv_dev_event,
 };
 
 static int
@@ -580,9 +578,7 @@
 }
 
 static struct notifier_block ipq_nl_notifier = {
-	ipq_rcv_nl_event,
-	NULL,
-	0
+	.notifier_call	= ipq_rcv_nl_event,
 };
 
 static int sysctl_maxlen = IPQ_QMAX_DEFAULT;
@@ -604,7 +600,6 @@
 	{
 		.ctl_name	= NET_IPV6,
 		.procname	= "ipv6",
-		.maxlen		= 0,
 		.mode		= 0555,
 		.child		= ipq_table
 	},
@@ -615,7 +610,6 @@
 	{
 		.ctl_name	= CTL_NET,
 		.procname	= "net",
-		.maxlen		= 0,
 		.mode		= 0555,
 		.child		= ipq_dir_table
 	},
===== net/ipv6/netfilter/ip6_tables.c 1.14 vs edited =====
--- 1.14/net/ipv6/netfilter/ip6_tables.c	Mon Mar  3 03:15:36 2003
+++ edited/net/ipv6/netfilter/ip6_tables.c	Sat Mar 15 12:14:15 2003
@@ -1735,21 +1735,42 @@
 }
 
 /* The built-in targets: standard (NULL) and error. */
-static struct ip6t_target ip6t_standard_target
-= { { NULL, NULL }, IP6T_STANDARD_TARGET, NULL, NULL, NULL };
-static struct ip6t_target ip6t_error_target
-= { { NULL, NULL }, IP6T_ERROR_TARGET, ip6t_error, NULL, NULL };
+static struct ip6t_target ip6t_standard_target = {
+	.name		= IP6T_STANDARD_TARGET,
+};
 
-static struct nf_sockopt_ops ip6t_sockopts
-= { { NULL, NULL }, PF_INET6, IP6T_BASE_CTL, IP6T_SO_SET_MAX+1, do_ip6t_set_ctl,
-    IP6T_BASE_CTL, IP6T_SO_GET_MAX+1, do_ip6t_get_ctl, 0, NULL  };
+static struct ip6t_target ip6t_error_target = {
+	.name		= IP6T_ERROR_TARGET,
+	.target		= ip6t_error,
+};
 
-static struct ip6t_match tcp_matchstruct
-= { { NULL, NULL }, "tcp", &tcp_match, &tcp_checkentry, NULL };
-static struct ip6t_match udp_matchstruct
-= { { NULL, NULL }, "udp", &udp_match, &udp_checkentry, NULL };
-static struct ip6t_match icmp6_matchstruct
-= { { NULL, NULL }, "icmp6", &icmp6_match, &icmp6_checkentry, NULL };
+static struct nf_sockopt_ops ip6t_sockopts = {
+	.pf		= PF_INET6,
+	.set_optmin	= IP6T_BASE_CTL,
+	.set_optmax	= IP6T_SO_SET_MAX+1,
+	.set		= do_ip6t_set_ctl,
+	.get_optmin	= IP6T_BASE_CTL,
+	.get_optmax	= IP6T_SO_GET_MAX+1,
+	.get		= do_ip6t_get_ctl,
+};
+
+static struct ip6t_match tcp_matchstruct = {
+	.name		= "tcp",
+	.match		= &tcp_match,
+	.checkentry	= &tcp_checkentry,
+};
+
+static struct ip6t_match udp_matchstruct = {
+	.name		= "udp",
+	.match		= &udp_match,
+	.checkentry	= &udp_checkentry,
+};
+
+static struct ip6t_match icmp6_matchstruct = {
+	.name		= "icmp6",
+	.match		= &icmp6_match,
+	.checkentry	= &icmp6_checkentry,
+};
 
 #ifdef CONFIG_PROC_FS
 static inline int print_name(const struct ip6t_table *t,
===== net/ipv6/netfilter/ip6t_ah.c 1.2 vs edited =====
--- 1.2/net/ipv6/netfilter/ip6t_ah.c	Thu Mar  6 11:11:12 2003
+++ edited/net/ipv6/netfilter/ip6t_ah.c	Sat Mar 15 12:17:27 2003
@@ -200,8 +200,12 @@
        return 1;
 }
 
-static struct ip6t_match ah_match
-= { { NULL, NULL }, "ah", &match, &checkentry, NULL, THIS_MODULE };
+static struct ip6t_match ah_match = {
+	.name		= "ah",
+	.match		= &match,
+	.checkentry	= &checkentry,
+	.me		= THIS_MODULE,
+};
 
 static int __init init(void)
 {
===== net/ipv6/netfilter/ip6t_dst.c 1.2 vs edited =====
--- 1.2/net/ipv6/netfilter/ip6t_dst.c	Thu Mar  6 11:11:12 2003
+++ edited/net/ipv6/netfilter/ip6t_dst.c	Sat Mar 15 12:20:04 2003
@@ -265,12 +265,15 @@
        return 1;
 }
 
-static struct ip6t_match opts_match
+static struct ip6t_match opts_match = {
 #if HOPBYHOP
-= { { NULL, NULL }, "hbh", &match, &checkentry, NULL, THIS_MODULE };
+	.name		= "hbh",
 #else
-= { { NULL, NULL }, "dst", &match, &checkentry, NULL, THIS_MODULE };
+	.name		= "dst",
 #endif
+	.match		= &match,
+	.checkentry	= &checkentry,
+};
 
 static int __init init(void)
 {
===== net/ipv6/netfilter/ip6t_esp.c 1.2 vs edited =====
--- 1.2/net/ipv6/netfilter/ip6t_esp.c	Thu Mar  6 11:11:12 2003
+++ edited/net/ipv6/netfilter/ip6t_esp.c	Sat Mar 15 12:20:39 2003
@@ -168,8 +168,12 @@
 	return 1;
 }
 
-static struct ip6t_match esp_match
-= { { NULL, NULL }, "esp", &match, &checkentry, NULL, THIS_MODULE };
+static struct ip6t_match esp_match = {
+	.name		= "esp",
+	.match		= &match,
+	.checkentry	= &checkentry,
+	.me		= THIS_MODULE,
+};
 
 static int __init init(void)
 {
===== net/ipv6/netfilter/ip6t_eui64.c 1.1 vs edited =====
--- 1.1/net/ipv6/netfilter/ip6t_eui64.c	Mon Aug 19 13:48:29 2002
+++ edited/net/ipv6/netfilter/ip6t_eui64.c	Sat Mar 15 12:21:12 2003
@@ -69,8 +69,12 @@
 	return 1;
 }
 
-static struct ip6t_match eui64_match
-= { { NULL, NULL }, "eui64", &match, &ip6t_eui64_checkentry, NULL, THIS_MODULE };
+static struct ip6t_match eui64_match = {
+	.name		= "eui64",
+	.match		= &match,
+	.checkentry	= &ip6t_eui64_checkentry,
+	.me		= THIS_MODULE,
+};
 
 static int __init init(void)
 {
===== net/ipv6/netfilter/ip6t_frag.c 1.2 vs edited =====
--- 1.2/net/ipv6/netfilter/ip6t_frag.c	Thu Mar  6 11:11:12 2003
+++ edited/net/ipv6/netfilter/ip6t_frag.c	Sat Mar 15 12:21:48 2003
@@ -232,8 +232,12 @@
        return 1;
 }
 
-static struct ip6t_match frag_match
-= { { NULL, NULL }, "frag", &match, &checkentry, NULL, THIS_MODULE };
+static struct ip6t_match frag_match = {
+	.name		= "frag",
+	.match		= &match,
+	.checkentry	= &checkentry,
+	.me		= THIS_MODULE,
+};
 
 static int __init init(void)
 {
===== net/ipv6/netfilter/ip6t_hbh.c 1.2 vs edited =====
--- 1.2/net/ipv6/netfilter/ip6t_hbh.c	Thu Mar  6 11:11:12 2003
+++ edited/net/ipv6/netfilter/ip6t_hbh.c	Sat Mar 15 12:24:04 2003
@@ -265,12 +265,16 @@
        return 1;
 }
 
-static struct ip6t_match opts_match
+static struct ip6t_match opts_match = {
 #if HOPBYHOP
-= { { NULL, NULL }, "hbh", &match, &checkentry, NULL, THIS_MODULE };
+	.name		= "hbh",
 #else
-= { { NULL, NULL }, "dst", &match, &checkentry, NULL, THIS_MODULE };
+	.name		= "dst",
 #endif
+	.match		= &match,
+	.checkentry	= &checkentry,
+	.me		= THIS_MODULE,
+};
 
 static int __init init(void)
 {
===== net/ipv6/netfilter/ip6t_hl.c 1.1 vs edited =====
--- 1.1/net/ipv6/netfilter/ip6t_hl.c	Mon Mar  3 03:40:34 2003
+++ edited/net/ipv6/netfilter/ip6t_hl.c	Sat Mar 15 12:24:37 2003
@@ -56,8 +56,12 @@
 	return 1;
 }
 
-static struct ip6t_match hl_match = { { NULL, NULL }, "hl", &match,
-		&checkentry, NULL, THIS_MODULE };
+static struct ip6t_match hl_match = {
+	.name		= "hl",
+	.match		= &match,
+	.checkentry	= &checkentry,
+	.me		= THIS_MODULE,
+};
 
 static int __init init(void)
 {
===== net/ipv6/netfilter/ip6t_ipv6header.c 1.2 vs edited =====
--- 1.2/net/ipv6/netfilter/ip6t_ipv6header.c	Thu Mar  6 11:11:12 2003
+++ edited/net/ipv6/netfilter/ip6t_ipv6header.c	Sat Mar 15 12:25:17 2003
@@ -196,14 +196,12 @@
 	return;
 }
 
-static struct ip6t_match
-ip6t_ipv6header_match = {
-	{ NULL, NULL },
-	"ipv6header",
-	&ipv6header_match,
-	&ipv6header_checkentry,
-	&ipv6header_destroy,
-	THIS_MODULE
+static struct ip6t_match ip6t_ipv6header_match = {
+	.name		= "ipv6header",
+	.match		= &ipv6header_match,
+	.checkentry	= &ipv6header_checkentry,
+	.destroy	= &ipv6header_destroy,
+	.me		= THIS_MODULE,
 };
 
 static int  __init ipv6header_init(void)
===== net/ipv6/netfilter/ip6t_length.c 1.1 vs edited =====
--- 1.1/net/ipv6/netfilter/ip6t_length.c	Mon Aug 19 13:48:29 2002
+++ edited/net/ipv6/netfilter/ip6t_length.c	Sat Mar 15 12:25:49 2003
@@ -34,8 +34,12 @@
 	return 1;
 }
 
-static struct ip6t_match length_match
-= { { NULL, NULL }, "length", &match, &checkentry, NULL, THIS_MODULE };
+static struct ip6t_match length_match = {
+	.name		= "length",
+	.match		= &match,
+	.checkentry	= &checkentry,
+	.me		= THIS_MODULE,
+};
 
 static int __init init(void)
 {
===== net/ipv6/netfilter/ip6t_limit.c 1.3 vs edited =====
--- 1.3/net/ipv6/netfilter/ip6t_limit.c	Tue Feb  5 01:54:00 2002
+++ edited/net/ipv6/netfilter/ip6t_limit.c	Sat Mar 15 12:26:20 2003
@@ -115,9 +115,12 @@
 	return 1;
 }
 
-static struct ip6t_match ip6t_limit_reg
-= { { NULL, NULL }, "limit", ip6t_limit_match, ip6t_limit_checkentry, NULL,
-    THIS_MODULE };
+static struct ip6t_match ip6t_limit_reg = {
+	.name		= "limit",
+	.match		= ip6t_limit_match,
+	.checkentry	= ip6t_limit_checkentry,
+	.me		= THIS_MODULE,
+};
 
 static int __init init(void)
 {
===== net/ipv6/netfilter/ip6t_mac.c 1.4 vs edited =====
--- 1.4/net/ipv6/netfilter/ip6t_mac.c	Wed Apr 10 23:49:23 2002
+++ edited/net/ipv6/netfilter/ip6t_mac.c	Sat Mar 15 12:26:50 2003
@@ -47,8 +47,12 @@
 	return 1;
 }
 
-static struct ip6t_match mac_match
-= { { NULL, NULL }, "mac", &match, &ip6t_mac_checkentry, NULL, THIS_MODULE };
+static struct ip6t_match mac_match = {
+	.name		= "mac",
+	.match		= &match,
+	.checkentry	= &ip6t_mac_checkentry,
+	.me		= THIS_MODULE,
+};
 
 static int __init init(void)
 {
===== net/ipv6/netfilter/ip6t_mark.c 1.3 vs edited =====
--- 1.3/net/ipv6/netfilter/ip6t_mark.c	Tue Feb  5 01:49:27 2002
+++ edited/net/ipv6/netfilter/ip6t_mark.c	Sat Mar 15 12:27:54 2003
@@ -33,8 +33,12 @@
 	return 1;
 }
 
-static struct ip6t_match mark_match
-= { { NULL, NULL }, "mark", &match, &checkentry, NULL, THIS_MODULE };
+static struct ip6t_match mark_match = {
+	.name		= "mark",
+	.match		= &match,
+	.checkentry	= &checkentry,
+	.me		= THIS_MODULE,
+};
 
 static int __init init(void)
 {
===== net/ipv6/netfilter/ip6t_multiport.c 1.2 vs edited =====
--- 1.2/net/ipv6/netfilter/ip6t_multiport.c	Tue Feb  5 01:54:00 2002
+++ edited/net/ipv6/netfilter/ip6t_multiport.c	Sat Mar 15 12:28:25 2003
@@ -84,8 +84,12 @@
 		&& multiinfo->count <= IP6T_MULTI_PORTS;
 }
 
-static struct ip6t_match multiport_match
-= { { NULL, NULL }, "multiport", &match, &checkentry, NULL, THIS_MODULE };
+static struct ip6t_match multiport_match = {
+	.name		= "multiport",
+	.match		= &match,
+	.checkentry	= &checkentry,
+	.me		= THIS_MODULE,
+};
 
 static int __init init(void)
 {
===== net/ipv6/netfilter/ip6t_owner.c 1.2 vs edited =====
--- 1.2/net/ipv6/netfilter/ip6t_owner.c	Sat Sep 14 08:17:21 2002
+++ edited/net/ipv6/netfilter/ip6t_owner.c	Sat Mar 15 12:28:54 2003
@@ -142,8 +142,12 @@
 	return 1;
 }
 
-static struct ip6t_match owner_match
-= { { NULL, NULL }, "owner", &match, &checkentry, NULL, THIS_MODULE };
+static struct ip6t_match owner_match = {
+	.name		= "owner",
+	.match		= &match,
+	.checkentry	= &checkentry,
+	.me		= THIS_MODULE,
+};
 
 static int __init init(void)
 {
===== net/ipv6/netfilter/ip6t_rt.c 1.2 vs edited =====
--- 1.2/net/ipv6/netfilter/ip6t_rt.c	Thu Mar  6 11:11:12 2003
+++ edited/net/ipv6/netfilter/ip6t_rt.c	Sat Mar 15 12:29:21 2003
@@ -287,8 +287,12 @@
        return 1;
 }
 
-static struct ip6t_match rt_match
-= { { NULL, NULL }, "rt", &match, &checkentry, NULL, THIS_MODULE };
+static struct ip6t_match rt_match = {
+	.name		= "rt",
+	.match		= &match,
+	.checkentry	= &checkentry,
+	.me		= THIS_MODULE,
+};
 
 static int __init init(void)
 {
-- 
They that can give up essential liberty to obtain a little temporary safety
deserve neither liberty nor safety.
 -- Benjamin Franklin, Historical Review of Pennsylvania, 1759
