From: Art Haas <ahaas@airmail.net>
Subject: [PATCH] Add C99 initializers to net/ipv4/netfilter
Date: Sun, 16 Mar 2003 14:28:20 -0600
Sender: linux-net-owner@vger.kernel.org
Message-ID: <20030316202820.GA9134@debian>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-net-owner@vger.kernel.org>
To: netfilter-devel@lists.netfilter.org, linux-net@vger.kernel.org
Content-Disposition: inline
List-Id: netfilter-devel.vger.kernel.org

Hi.

Here is a set of patches converting more structures to use C99
initializers. The patches are against the current BK. A set of
similar patches for the ipv6 code will follow. These patches also
include an occasional removal of a '.maxlen = 0,' line in the
initializers.

Art Haas

===== net/ipv4/netfilter/arp_tables.c 1.3 vs edited =====
--- 1.3/net/ipv4/netfilter/arp_tables.c	Mon Mar  3 03:15:36 2003
+++ edited/net/ipv4/netfilter/arp_tables.c	Sat Mar 15 13:08:52 2003
@@ -1205,14 +1205,24 @@
 }
 
 /* The built-in targets: standard (NULL) and error. */
-static struct arpt_target arpt_standard_target
-= { { NULL, NULL }, ARPT_STANDARD_TARGET, NULL, NULL, NULL };
-static struct arpt_target arpt_error_target
-= { { NULL, NULL }, ARPT_ERROR_TARGET, arpt_error, NULL, NULL };
+static struct arpt_target arpt_standard_target = {
+	.name		= ARPT_STANDARD_TARGET,
+};
 
-static struct nf_sockopt_ops arpt_sockopts
-= { { NULL, NULL }, PF_INET, ARPT_BASE_CTL, ARPT_SO_SET_MAX+1, do_arpt_set_ctl,
-    ARPT_BASE_CTL, ARPT_SO_GET_MAX+1, do_arpt_get_ctl, 0, NULL  };
+static struct arpt_target arpt_error_target = {
+	.name		= ARPT_ERROR_TARGET,
+	.target		= arpt_error,
+};
+
+static struct nf_sockopt_ops arpt_sockopts = {
+	.pf		= PF_INET,
+	.set_optmin	= ARPT_BASE_CTL,
+	.set_optmax	= ARPT_SO_SET_MAX+1,
+	.set		= do_arpt_set_ctl,
+	.get_optmin	= ARPT_BASE_CTL,
+	.get_optmax	= ARPT_SO_GET_MAX+1,
+	.get		= do_arpt_get_ctl,
+};
 
 #ifdef CONFIG_PROC_FS
 static inline int print_name(const struct arpt_table *t,
===== net/ipv4/netfilter/ip_conntrack_core.c 1.20 vs edited =====
--- 1.20/net/ipv4/netfilter/ip_conntrack_core.c	Mon Mar  3 03:25:39 2003
+++ edited/net/ipv4/netfilter/ip_conntrack_core.c	Sat Mar 15 13:09:25 2003
@@ -1339,11 +1339,12 @@
 	return -ENOENT;
 }
 
-static struct nf_sockopt_ops so_getorigdst
-= { { NULL, NULL }, PF_INET,
-    0, 0, NULL, /* Setsockopts */
-    SO_ORIGINAL_DST, SO_ORIGINAL_DST+1, &getorigdst,
-    0, NULL };
+static struct nf_sockopt_ops so_getorigdst = {
+	.pf		= PF_INET,
+	.get_optmin	= SO_ORIGINAL_DST,
+	.get_optmax	= SO_ORIGINAL_DST+1,
+	.get		= &getorigdst,
+};
 
 #define NET_IP_CONNTRACK_MAX 2089
 #define NET_IP_CONNTRACK_MAX_NAME "ip_conntrack_max"
@@ -1367,7 +1368,6 @@
 	{
 		.ctl_name	= NET_IPV4,
 		.procname	= "ipv4",
-		.maxlen		= 0,
 		.mode		= 0555,
 		.child		= ip_conntrack_table
 	},
@@ -1378,7 +1378,6 @@
 	{
 		.ctl_name	= CTL_NET,
 		.procname	= "net",
-		.maxlen		= 0,
 		.mode		= 0555,
 		.child		= ip_conntrack_dir_table
 	},
===== net/ipv4/netfilter/ip_queue.c 1.10 vs edited =====
--- 1.10/net/ipv4/netfilter/ip_queue.c	Wed Feb 12 23:50:47 2003
+++ edited/net/ipv4/netfilter/ip_queue.c	Sat Mar 15 13:14:25 2003
@@ -555,9 +555,7 @@
 }
 
 static struct notifier_block ipq_dev_notifier = {
-	ipq_rcv_dev_event,
-	NULL,
-	0
+	.notifier_call	= ipq_rcv_dev_event,
 };
 
 static int
@@ -577,9 +575,7 @@
 }
 
 static struct notifier_block ipq_nl_notifier = {
-	ipq_rcv_nl_event,
-	NULL,
-	0
+	.notifier_call	= ipq_rcv_nl_event,
 };
 
 static int sysctl_maxlen = IPQ_QMAX_DEFAULT;
@@ -601,7 +597,6 @@
 	{
 		.ctl_name	= NET_IPV4,
 		.procname	= "ipv4",
-		.maxlen		= 0,
 		.mode		= 0555,
 		.child		= ipq_table
 	},
@@ -612,7 +607,6 @@
 	{
 		.ctl_name	= CTL_NET,
 		.procname	= "net",
-		.maxlen		= 0,
 		.mode		= 0555,
 		.child		= ipq_dir_table
 	},
===== net/ipv4/netfilter/ip_tables.c 1.11 vs edited =====
--- 1.11/net/ipv4/netfilter/ip_tables.c	Mon Mar  3 03:21:27 2003
+++ edited/net/ipv4/netfilter/ip_tables.c	Sat Mar 15 12:46:44 2003
@@ -1663,21 +1663,42 @@
 }
 
 /* The built-in targets: standard (NULL) and error. */
-static struct ipt_target ipt_standard_target
-= { { NULL, NULL }, IPT_STANDARD_TARGET, NULL, NULL, NULL };
-static struct ipt_target ipt_error_target
-= { { NULL, NULL }, IPT_ERROR_TARGET, ipt_error, NULL, NULL };
+static struct ipt_target ipt_standard_target = {
+	.name		= IPT_STANDARD_TARGET,
+};
 
-static struct nf_sockopt_ops ipt_sockopts
-= { { NULL, NULL }, PF_INET, IPT_BASE_CTL, IPT_SO_SET_MAX+1, do_ipt_set_ctl,
-    IPT_BASE_CTL, IPT_SO_GET_MAX+1, do_ipt_get_ctl, 0, NULL  };
+static struct ipt_target ipt_error_target = {
+	.name		= IPT_ERROR_TARGET,
+	.target		= ipt_error,
+};
 
-static struct ipt_match tcp_matchstruct
-= { { NULL, NULL }, "tcp", &tcp_match, &tcp_checkentry, NULL };
-static struct ipt_match udp_matchstruct
-= { { NULL, NULL }, "udp", &udp_match, &udp_checkentry, NULL };
-static struct ipt_match icmp_matchstruct
-= { { NULL, NULL }, "icmp", &icmp_match, &icmp_checkentry, NULL };
+static struct nf_sockopt_ops ipt_sockopts = {
+	.pf		= PF_INET,
+	.set_optmin	= IPT_BASE_CTL,
+	.set_optmax	= IPT_SO_SET_MAX+1,
+	.set		= do_ipt_set_ctl,
+	.get_optmin	= IPT_BASE_CTL,
+	.get_optmax	= IPT_SO_GET_MAX+1,
+	.get		= do_ipt_get_ctl,
+};
+
+static struct ipt_match tcp_matchstruct = {
+	.name		= "tcp",
+	.match		= &tcp_match,
+	.checkentry	= &tcp_checkentry,
+};
+
+static struct ipt_match udp_matchstruct = {
+	.name		= "udp",
+	.match		= &udp_match,
+	.checkentry	= &udp_checkentry,
+};
+
+static struct ipt_match icmp_matchstruct = {
+	.name		= "icmp",
+	.match		= &icmp_match,
+	.checkentry	= &icmp_checkentry,
+};
 
 #ifdef CONFIG_PROC_FS
 static inline int print_name(const struct ipt_table *t,
===== net/ipv4/netfilter/ipfwadm_core.c 1.11 vs edited =====
--- 1.11/net/ipv4/netfilter/ipfwadm_core.c	Mon Mar  3 03:06:54 2003
+++ edited/net/ipv4/netfilter/ipfwadm_core.c	Sat Mar 15 13:29:33 2003
@@ -1315,9 +1315,7 @@
 }
 
 static struct notifier_block ipfw_dev_notifier={
-	ipfw_device_event,
-	NULL,
-	0
+	.notifier_call	= ipfw_device_event,
 };
 
 #endif
===== net/ipv4/netfilter/ipt_DSCP.c 1.1 vs edited =====
--- 1.1/net/ipv4/netfilter/ipt_DSCP.c	Mon Aug 19 13:48:13 2002
+++ edited/net/ipv4/netfilter/ipt_DSCP.c	Sat Mar 15 13:32:58 2003
@@ -88,8 +88,12 @@
 	return 1;
 }
 
-static struct ipt_target ipt_dscp_reg
-= { { NULL, NULL }, "DSCP", target, checkentry, NULL, THIS_MODULE };
+static struct ipt_target ipt_dscp_reg = {
+	.name		= "DSCP",
+	.target		= target,
+	.checkentry	= checkentry,
+	.me		= THIS_MODULE,
+};
 
 static int __init init(void)
 {
===== net/ipv4/netfilter/ipt_ECN.c 1.3 vs edited =====
--- 1.3/net/ipv4/netfilter/ipt_ECN.c	Fri Jan 10 03:05:48 2003
+++ edited/net/ipv4/netfilter/ipt_ECN.c	Sat Mar 15 13:33:31 2003
@@ -164,8 +164,12 @@
 	return 1;
 }
 
-static struct ipt_target ipt_ecn_reg
-= { { NULL, NULL }, "ECN", target, checkentry, NULL, THIS_MODULE };
+static struct ipt_target ipt_ecn_reg = {
+	.name		= "ECN",
+	.target		= target,
+	.checkentry	= checkentry,
+	.me		= THIS_MODULE,
+};
 
 static int __init init(void)
 {
===== net/ipv4/netfilter/ipt_LOG.c 1.5 vs edited =====
--- 1.5/net/ipv4/netfilter/ipt_LOG.c	Mon Oct 28 07:06:31 2002
+++ edited/net/ipv4/netfilter/ipt_LOG.c	Sat Mar 15 13:34:03 2003
@@ -350,9 +350,12 @@
 	return 1;
 }
 
-static struct ipt_target ipt_log_reg
-= { { NULL, NULL }, "LOG", ipt_log_target, ipt_log_checkentry, NULL, 
-    THIS_MODULE };
+static struct ipt_target ipt_log_reg = {
+	.name		= "LOG",
+	.target		= ipt_log_target,
+	.checkentry	= ipt_log_checkentry,
+	.me		= THIS_MODULE,
+};
 
 static int __init init(void)
 {
===== net/ipv4/netfilter/ipt_MARK.c 1.2 vs edited =====
--- 1.2/net/ipv4/netfilter/ipt_MARK.c	Tue Feb  5 01:49:27 2002
+++ edited/net/ipv4/netfilter/ipt_MARK.c	Sat Mar 15 13:34:32 2003
@@ -46,8 +46,12 @@
 	return 1;
 }
 
-static struct ipt_target ipt_mark_reg
-= { { NULL, NULL }, "MARK", target, checkentry, NULL, THIS_MODULE };
+static struct ipt_target ipt_mark_reg = {
+	.name		= "MARK",
+	.target		= target,
+	.checkentry	= checkentry,
+	.me		= THIS_MODULE,
+};
 
 static int __init init(void)
 {
===== net/ipv4/netfilter/ipt_MASQUERADE.c 1.6 vs edited =====
--- 1.6/net/ipv4/netfilter/ipt_MASQUERADE.c	Fri Oct 11 18:07:30 2002
+++ edited/net/ipv4/netfilter/ipt_MASQUERADE.c	Sat Mar 15 13:31:30 2003
@@ -167,20 +167,19 @@
 }
 
 static struct notifier_block masq_dev_notifier = {
-	masq_device_event,
-	NULL,
-	0
+	.notifier_call	= masq_device_event,
 };
 
 static struct notifier_block masq_inet_notifier = {
-	masq_inet_event,
-	NULL,
-	0
+	.notifier_call	= masq_inet_event,
 };
 
-static struct ipt_target masquerade
-= { { NULL, NULL }, "MASQUERADE", masquerade_target, masquerade_check, NULL,
-    THIS_MODULE };
+static struct ipt_target masquerade = {
+	.name		= "MASQUERADE",
+	.target		= masquerade_target,
+	.checkentry	= masquerade_check,
+	.me		= THIS_MODULE,
+};
 
 static int __init init(void)
 {
===== net/ipv4/netfilter/ipt_MIRROR.c 1.4 vs edited =====
--- 1.4/net/ipv4/netfilter/ipt_MIRROR.c	Fri Oct 11 18:07:30 2002
+++ edited/net/ipv4/netfilter/ipt_MIRROR.c	Sat Mar 15 13:35:03 2003
@@ -157,9 +157,12 @@
 	return 1;
 }
 
-static struct ipt_target ipt_mirror_reg
-= { { NULL, NULL }, "MIRROR", ipt_mirror_target, ipt_mirror_checkentry, NULL,
-    THIS_MODULE };
+static struct ipt_target ipt_mirror_reg = {
+	.name		= "MIRROR",
+	.target		= ipt_mirror_target,
+	.checkentry	= ipt_mirror_checkentry,
+	.me		= THIS_MODULE,
+};
 
 static int __init init(void)
 {
===== net/ipv4/netfilter/ipt_REDIRECT.c 1.3 vs edited =====
--- 1.3/net/ipv4/netfilter/ipt_REDIRECT.c	Tue Feb  5 09:24:40 2002
+++ edited/net/ipv4/netfilter/ipt_REDIRECT.c	Sat Mar 15 13:35:33 2003
@@ -96,9 +96,12 @@
 	return ip_nat_setup_info(ct, &newrange, hooknum);
 }
 
-static struct ipt_target redirect_reg
-= { { NULL, NULL }, "REDIRECT", redirect_target, redirect_check, NULL,
-    THIS_MODULE };
+static struct ipt_target redirect_reg = {
+	.name		= "REDIRECT",
+	.target		= redirect_target,
+	.checkentry	= redirect_check,
+	.me		= THIS_MODULE,
+};
 
 static int __init init(void)
 {
===== net/ipv4/netfilter/ipt_REJECT.c 1.11 vs edited =====
--- 1.11/net/ipv4/netfilter/ipt_REJECT.c	Fri Jan 10 03:01:00 2003
+++ edited/net/ipv4/netfilter/ipt_REJECT.c	Sat Mar 15 13:36:06 2003
@@ -386,8 +386,12 @@
 	return 1;
 }
 
-static struct ipt_target ipt_reject_reg
-= { { NULL, NULL }, "REJECT", reject, check, NULL, THIS_MODULE };
+static struct ipt_target ipt_reject_reg = {
+	.name		= "REJECT",
+	.target		= reject,
+	.checkentry	= check,
+	.me		= THIS_MODULE,
+};
 
 static int __init init(void)
 {
===== net/ipv4/netfilter/ipt_TCPMSS.c 1.7 vs edited =====
--- 1.7/net/ipv4/netfilter/ipt_TCPMSS.c	Sun Nov 10 18:20:05 2002
+++ edited/net/ipv4/netfilter/ipt_TCPMSS.c	Sat Mar 15 13:36:37 2003
@@ -238,9 +238,12 @@
 	return 0;
 }
 
-static struct ipt_target ipt_tcpmss_reg
-= { { NULL, NULL }, "TCPMSS",
-    ipt_tcpmss_target, ipt_tcpmss_checkentry, NULL, THIS_MODULE };
+static struct ipt_target ipt_tcpmss_reg = {
+	.name		= "TCPMSS",
+	.target		= ipt_tcpmss_target,
+	.checkentry	= ipt_tcpmss_checkentry,
+	.me		= THIS_MODULE,
+};
 
 static int __init init(void)
 {
===== net/ipv4/netfilter/ipt_TOS.c 1.6 vs edited =====
--- 1.6/net/ipv4/netfilter/ipt_TOS.c	Tue Feb  5 09:23:43 2002
+++ edited/net/ipv4/netfilter/ipt_TOS.c	Sat Mar 15 13:37:05 2003
@@ -76,8 +76,12 @@
 	return 1;
 }
 
-static struct ipt_target ipt_tos_reg
-= { { NULL, NULL }, "TOS", target, checkentry, NULL, THIS_MODULE };
+static struct ipt_target ipt_tos_reg = {
+	.name		= "TOS",
+	.target		= target,
+	.checkentry	= checkentry,
+	.me		= THIS_MODULE,
+};
 
 static int __init init(void)
 {
===== net/ipv4/netfilter/ipt_ULOG.c 1.6 vs edited =====
--- 1.6/net/ipv4/netfilter/ipt_ULOG.c	Fri Jan 10 02:57:03 2003
+++ edited/net/ipv4/netfilter/ipt_ULOG.c	Sat Mar 15 13:37:35 2003
@@ -304,9 +304,11 @@
 	return 1;
 }
 
-static struct ipt_target ipt_ulog_reg =
-    { {NULL, NULL}, "ULOG", ipt_ulog_target, ipt_ulog_checkentry, NULL,
-THIS_MODULE
+static struct ipt_target ipt_ulog_reg = {
+	.name		= "ULOG",
+	.target		= ipt_ulog_target,
+	.checkentry	= ipt_ulog_checkentry,
+	.me		= THIS_MODULE,
 };
 
 static int __init init(void)
===== net/ipv4/netfilter/ipt_ah.c 1.4 vs edited =====
--- 1.4/net/ipv4/netfilter/ipt_ah.c	Wed Feb 19 14:23:15 2003
+++ edited/net/ipv4/netfilter/ipt_ah.c	Sat Mar 15 12:51:17 2003
@@ -87,8 +87,12 @@
 	return 1;
 }
 
-static struct ipt_match ah_match
-= { { NULL, NULL }, "ah", &match, &checkentry, NULL, THIS_MODULE };
+static struct ipt_match ah_match = {
+	.name		= "ah",
+	.match		= &match,
+	.checkentry	= &checkentry,
+	.me		= THIS_MODULE,
+};
 
 static int __init init(void)
 {
===== net/ipv4/netfilter/ipt_conntrack.c 1.2 vs edited =====
--- 1.2/net/ipv4/netfilter/ipt_conntrack.c	Mon Mar  3 03:15:36 2003
+++ edited/net/ipv4/netfilter/ipt_conntrack.c	Sat Mar 15 12:51:52 2003
@@ -100,8 +100,12 @@
 	return 1;
 }
 
-static struct ipt_match conntrack_match
-= { { NULL, NULL }, "conntrack", &match, &check, NULL, THIS_MODULE };
+static struct ipt_match conntrack_match = {
+	.name		= "conntrack",
+	.match		= &match,
+	.checkentry	= &check,
+	.me		= THIS_MODULE,
+};
 
 static int __init init(void)
 {
===== net/ipv4/netfilter/ipt_dscp.c 1.1 vs edited =====
--- 1.1/net/ipv4/netfilter/ipt_dscp.c	Mon Aug 19 13:48:13 2002
+++ edited/net/ipv4/netfilter/ipt_dscp.c	Sat Mar 15 12:52:24 2003
@@ -40,8 +40,12 @@
 	return 1;
 }
 
-static struct ipt_match dscp_match = { { NULL, NULL }, "dscp", &match,
-		&checkentry, NULL, THIS_MODULE };
+static struct ipt_match dscp_match = {
+	.name		= "dscp",
+	.match		= &match,
+	.checkentry	= &checkentry,
+	.me		= THIS_MODULE,
+};
 
 static int __init init(void)
 {
===== net/ipv4/netfilter/ipt_ecn.c 1.1 vs edited =====
--- 1.1/net/ipv4/netfilter/ipt_ecn.c	Mon Aug 19 13:48:13 2002
+++ edited/net/ipv4/netfilter/ipt_ecn.c	Sat Mar 15 12:52:58 2003
@@ -101,8 +101,12 @@
 	return 1;
 }
 
-static struct ipt_match ecn_match = { { NULL, NULL }, "ecn", &match,
-		&checkentry, NULL, THIS_MODULE };
+static struct ipt_match ecn_match = {
+	.name		= "ecn",
+	.match		= &match,
+	.checkentry	= &checkentry,
+	.me		= THIS_MODULE,
+};
 
 static int __init init(void)
 {
===== net/ipv4/netfilter/ipt_esp.c 1.4 vs edited =====
--- 1.4/net/ipv4/netfilter/ipt_esp.c	Wed Feb 19 14:23:13 2003
+++ edited/net/ipv4/netfilter/ipt_esp.c	Sat Mar 15 12:53:26 2003
@@ -87,8 +87,12 @@
 	return 1;
 }
 
-static struct ipt_match esp_match
-= { { NULL, NULL }, "esp", &match, &checkentry, NULL, THIS_MODULE };
+static struct ipt_match esp_match = {
+	.name		= "esp",
+	.match		= &match,
+	.checkentry	= &checkentry,
+	.me		= THIS_MODULE,
+};
 
 static int __init init(void)
 {
===== net/ipv4/netfilter/ipt_helper.c 1.2 vs edited =====
--- 1.2/net/ipv4/netfilter/ipt_helper.c	Mon Mar  3 03:15:36 2003
+++ edited/net/ipv4/netfilter/ipt_helper.c	Sat Mar 15 12:53:55 2003
@@ -89,8 +89,12 @@
 	return 1;
 }
 
-static struct ipt_match helper_match
-= { { NULL, NULL }, "helper", &match, &check, NULL, THIS_MODULE };
+static struct ipt_match helper_match = {
+	.name		= "helper",
+	.match		= &match,
+	.checkentry	= &check,
+	.me		= THIS_MODULE,
+};
 
 static int __init init(void)
 {
===== net/ipv4/netfilter/ipt_length.c 1.1 vs edited =====
--- 1.1/net/ipv4/netfilter/ipt_length.c	Tue Feb  5 01:54:00 2002
+++ edited/net/ipv4/netfilter/ipt_length.c	Sat Mar 15 12:54:25 2003
@@ -38,8 +38,12 @@
 	return 1;
 }
 
-static struct ipt_match length_match
-= { { NULL, NULL }, "length", &match, &checkentry, NULL, THIS_MODULE };
+static struct ipt_match length_match = {
+	.name		= "length",
+	.match		= &match,
+	.checkentry	= &checkentry,
+	.me		= THIS_MODULE,
+};
 
 static int __init init(void)
 {
===== net/ipv4/netfilter/ipt_limit.c 1.2 vs edited =====
--- 1.2/net/ipv4/netfilter/ipt_limit.c	Tue Feb  5 01:49:27 2002
+++ edited/net/ipv4/netfilter/ipt_limit.c	Sat Mar 15 12:55:44 2003
@@ -115,9 +115,12 @@
 	return 1;
 }
 
-static struct ipt_match ipt_limit_reg
-= { { NULL, NULL }, "limit", ipt_limit_match, ipt_limit_checkentry, NULL,
-    THIS_MODULE };
+static struct ipt_match ipt_limit_reg = {
+	.name		= "limit",
+	.match		= ipt_limit_match,
+	.checkentry	= ipt_limit_checkentry,
+	.me		= THIS_MODULE,
+};
 
 static int __init init(void)
 {
===== net/ipv4/netfilter/ipt_mac.c 1.3 vs edited =====
--- 1.3/net/ipv4/netfilter/ipt_mac.c	Tue Feb  5 01:49:35 2002
+++ edited/net/ipv4/netfilter/ipt_mac.c	Sat Mar 15 12:56:16 2003
@@ -47,8 +47,12 @@
 	return 1;
 }
 
-static struct ipt_match mac_match
-= { { NULL, NULL }, "mac", &match, &ipt_mac_checkentry, NULL, THIS_MODULE };
+static struct ipt_match mac_match = {
+	.name		= "mac",
+	.match		= &match,
+	.checkentry	= &ipt_mac_checkentry,
+	.me		= THIS_MODULE,
+};
 
 static int __init init(void)
 {
===== net/ipv4/netfilter/ipt_mark.c 1.2 vs edited =====
--- 1.2/net/ipv4/netfilter/ipt_mark.c	Tue Feb  5 01:49:27 2002
+++ edited/net/ipv4/netfilter/ipt_mark.c	Sat Mar 15 12:56:48 2003
@@ -33,8 +33,12 @@
 	return 1;
 }
 
-static struct ipt_match mark_match
-= { { NULL, NULL }, "mark", &match, &checkentry, NULL, THIS_MODULE };
+static struct ipt_match mark_match = {
+	.name		= "mark",
+	.match		= &match,
+	.checkentry	= &checkentry,
+	.me		= THIS_MODULE,
+};
 
 static int __init init(void)
 {
===== net/ipv4/netfilter/ipt_multiport.c 1.3 vs edited =====
--- 1.3/net/ipv4/netfilter/ipt_multiport.c	Fri Jan 10 02:47:07 2003
+++ edited/net/ipv4/netfilter/ipt_multiport.c	Sat Mar 15 12:57:14 2003
@@ -86,8 +86,12 @@
 		&& multiinfo->count <= IPT_MULTI_PORTS;
 }
 
-static struct ipt_match multiport_match
-= { { NULL, NULL }, "multiport", &match, &checkentry, NULL, THIS_MODULE };
+static struct ipt_match multiport_match = {
+	.name		= "multiport",
+	.match		= &match,
+	.checkentry	= &checkentry,
+	.me		= THIS_MODULE,
+};
 
 static int __init init(void)
 {
===== net/ipv4/netfilter/ipt_owner.c 1.4 vs edited =====
--- 1.4/net/ipv4/netfilter/ipt_owner.c	Sat Sep 14 08:16:57 2002
+++ edited/net/ipv4/netfilter/ipt_owner.c	Sat Mar 15 12:57:42 2003
@@ -176,8 +176,12 @@
 	return 1;
 }
 
-static struct ipt_match owner_match
-= { { NULL, NULL }, "owner", &match, &checkentry, NULL, THIS_MODULE };
+static struct ipt_match owner_match = {
+	.name		= "owner",
+	.match		= &match,
+	.checkentry	= &checkentry,
+	.me		= THIS_MODULE,
+};
 
 static int __init init(void)
 {
===== net/ipv4/netfilter/ipt_physdev.c 1.2 vs edited =====
--- 1.2/net/ipv4/netfilter/ipt_physdev.c	Sat Nov  2 04:10:40 2002
+++ edited/net/ipv4/netfilter/ipt_physdev.c	Sat Mar 15 12:58:12 2003
@@ -63,8 +63,12 @@
 	return 1;
 }
 
-static struct ipt_match physdev_match
-= { { NULL, NULL }, "physdev", &match, &checkentry, NULL, THIS_MODULE };
+static struct ipt_match physdev_match = {
+	.name		= "physdev",
+	.match		= &match,
+	.checkentry	= &checkentry,
+	.me		= THIS_MODULE,
+};
 
 static int __init init(void)
 {
===== net/ipv4/netfilter/ipt_pkttype.c 1.1 vs edited =====
--- 1.1/net/ipv4/netfilter/ipt_pkttype.c	Mon Aug 19 13:48:13 2002
+++ edited/net/ipv4/netfilter/ipt_pkttype.c	Sat Mar 15 12:58:38 2003
@@ -42,8 +42,12 @@
 	return 1;
 }
 
-static struct ipt_match pkttype_match
-= { { NULL, NULL }, "pkttype", &match, &checkentry, NULL, THIS_MODULE };
+static struct ipt_match pkttype_match = {
+	.name		= "pkttype",
+	.match		= &match,
+	.checkentry	= &checkentry,
+	.me		= THIS_MODULE,
+};
 
 static int __init init(void)
 {
===== net/ipv4/netfilter/ipt_state.c 1.3 vs edited =====
--- 1.3/net/ipv4/netfilter/ipt_state.c	Mon Mar  3 03:15:36 2003
+++ edited/net/ipv4/netfilter/ipt_state.c	Sat Mar 15 12:59:07 2003
@@ -41,8 +41,12 @@
 	return 1;
 }
 
-static struct ipt_match state_match
-= { { NULL, NULL }, "state", &match, &check, NULL, THIS_MODULE };
+static struct ipt_match state_match = {
+	.name		= "state",
+	.match		= &match,
+	.checkentry	= &check,
+	.me		= THIS_MODULE,
+};
 
 static int __init init(void)
 {
===== net/ipv4/netfilter/ipt_tcpmss.c 1.2 vs edited =====
--- 1.2/net/ipv4/netfilter/ipt_tcpmss.c	Tue Feb  5 01:49:27 2002
+++ edited/net/ipv4/netfilter/ipt_tcpmss.c	Sat Mar 15 13:00:07 2003
@@ -91,8 +91,12 @@
 	return 1;
 }
 
-static struct ipt_match tcpmss_match
-= { { NULL, NULL }, "tcpmss", &match, &checkentry, NULL, THIS_MODULE };
+static struct ipt_match tcpmss_match = {
+	.name		= "tcpmss",
+	.match		= &match,
+	.checkentry	= &checkentry,
+	.me		= THIS_MODULE,
+};
 
 static int __init init(void)
 {
===== net/ipv4/netfilter/ipt_tos.c 1.2 vs edited =====
--- 1.2/net/ipv4/netfilter/ipt_tos.c	Tue Feb  5 01:49:27 2002
+++ edited/net/ipv4/netfilter/ipt_tos.c	Sat Mar 15 13:00:35 2003
@@ -34,8 +34,12 @@
 	return 1;
 }
 
-static struct ipt_match tos_match
-= { { NULL, NULL }, "tos", &match, &checkentry, NULL, THIS_MODULE };
+static struct ipt_match tos_match = {
+	.name		= "tos",
+	.match		= &match,
+	.checkentry	= &checkentry,
+	.me		= THIS_MODULE,
+};
 
 static int __init init(void)
 {
===== net/ipv4/netfilter/ipt_ttl.c 1.1 vs edited =====
--- 1.1/net/ipv4/netfilter/ipt_ttl.c	Tue Feb  5 01:54:00 2002
+++ edited/net/ipv4/netfilter/ipt_ttl.c	Sat Mar 15 13:01:05 2003
@@ -57,8 +57,12 @@
 	return 1;
 }
 
-static struct ipt_match ttl_match = { { NULL, NULL }, "ttl", &match,
-		&checkentry, NULL, THIS_MODULE };
+static struct ipt_match ttl_match = {
+	.name		= "ttl",
+	.match		= &match,
+	.checkentry	= &checkentry,
+	.me		= THIS_MODULE,
+};
 
 static int __init init(void)
 {
===== net/ipv4/netfilter/ipt_unclean.c 1.8 vs edited =====
--- 1.8/net/ipv4/netfilter/ipt_unclean.c	Wed Oct 23 06:09:45 2002
+++ edited/net/ipv4/netfilter/ipt_unclean.c	Sat Mar 15 13:01:33 2003
@@ -580,8 +580,12 @@
 	return 1;
 }
 
-static struct ipt_match unclean_match
-= { { NULL, NULL }, "unclean", &match, &checkentry, NULL, THIS_MODULE };
+static struct ipt_match unclean_match = {
+	.name		= "unclean",
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
