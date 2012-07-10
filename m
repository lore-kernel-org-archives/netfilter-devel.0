From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 3/4] netfilter: use permission mnemonics in module_param
Date: Wed, 11 Jul 2012 01:52:29 +0200
Message-ID: <1341964350-13809-4-git-send-email-jengelh@inai.de>
References: <1341964350-13809-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:54423 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755629Ab2GJXwh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Jul 2012 19:52:37 -0400
In-Reply-To: <1341964350-13809-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Noticed the inconsistent use while going over xt_recent; cleanup the
mode numbers, replacing them by the simpler mnemonics they go by.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 net/ipv4/netfilter/ipt_ULOG.c                  |    6 +++---
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    2 +-
 net/ipv4/netfilter/nf_nat_snmp_basic.c         |    2 +-
 net/netfilter/ipset/ip_set_core.c              |    2 +-
 net/netfilter/ipvs/ip_vs_conn.c                |    2 +-
 net/netfilter/ipvs/ip_vs_ftp.c                 |    2 +-
 net/netfilter/nf_conntrack_acct.c              |    2 +-
 net/netfilter/nf_conntrack_amanda.c            |    4 ++--
 net/netfilter/nf_conntrack_core.c              |    2 +-
 net/netfilter/nf_conntrack_expect.c            |    2 +-
 net/netfilter/nf_conntrack_ftp.c               |    4 ++--
 net/netfilter/nf_conntrack_h323_main.c         |    6 +++---
 net/netfilter/nf_conntrack_helper.c            |    3 ++-
 net/netfilter/nf_conntrack_irc.c               |    6 +++---
 net/netfilter/nf_conntrack_sane.c              |    2 +-
 net/netfilter/nf_conntrack_sip.c               |    8 ++++----
 net/netfilter/nf_conntrack_tftp.c              |    2 +-
 net/netfilter/nf_conntrack_timestamp.c         |    2 +-
 net/netfilter/xt_recent.c                      |    6 +++---
 19 files changed, 33 insertions(+), 32 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index 1109f7f..06417ea 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -58,15 +58,15 @@ MODULE_ALIAS_NET_PF_PROTO(PF_NETLINK, NETLINK_NFLOG);
 #define ULOG_MAXNLGROUPS	32		/* numer of nlgroups */
 
 static unsigned int nlbufsiz = NLMSG_GOODSIZE;
-module_param(nlbufsiz, uint, 0400);
+module_param(nlbufsiz, uint, S_IRUSR);
 MODULE_PARM_DESC(nlbufsiz, "netlink buffer size");
 
 static unsigned int flushtimeout = 10;
-module_param(flushtimeout, uint, 0600);
+module_param(flushtimeout, uint, S_IRUSR | S_IWUSR);
 MODULE_PARM_DESC(flushtimeout, "buffer flush timeout (hundredths of a second)");
 
 static bool nflog = true;
-module_param(nflog, bool, 0400);
+module_param(nflog, bool, S_IRUSR);
 MODULE_PARM_DESC(nflog, "register as internal netfilter logging module");
 
 /* global data structures */
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index e7ff2dc..0853b0c 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -414,7 +414,7 @@ struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv4 __read_mostly = {
 };
 
 module_param_call(hashsize, nf_conntrack_set_hashsize, param_get_uint,
-		  &nf_conntrack_htable_size, 0600);
+		  &nf_conntrack_htable_size, S_IRUSR | S_IWUSR);
 
 MODULE_ALIAS("nf_conntrack-" __stringify(AF_INET));
 MODULE_ALIAS("ip_conntrack");
diff --git a/net/ipv4/netfilter/nf_nat_snmp_basic.c b/net/ipv4/netfilter/nf_nat_snmp_basic.c
index bac7122..6029cdc 100644
--- a/net/ipv4/netfilter/nf_nat_snmp_basic.c
+++ b/net/ipv4/netfilter/nf_nat_snmp_basic.c
@@ -1309,4 +1309,4 @@ static void __exit nf_nat_snmp_basic_fini(void)
 module_init(nf_nat_snmp_basic_init);
 module_exit(nf_nat_snmp_basic_fini);
 
-module_param(debug, int, 0600);
+module_param(debug, int, S_IRUSR | S_IWUSR);
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 9730882..d5db0da 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -35,7 +35,7 @@ static ip_set_id_t ip_set_max = CONFIG_IP_SET_MAX; /* max number of sets */
 
 static unsigned int max_sets;
 
-module_param(max_sets, int, 0600);
+module_param(max_sets, int, S_IRUSR | S_IWUSR);
 MODULE_PARM_DESC(max_sets, "maximal number of sets");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 1548df9..699b71a 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -49,7 +49,7 @@
  * Connection hash size. Default is what was selected at compile time.
 */
 static int ip_vs_conn_tab_bits = CONFIG_IP_VS_TAB_BITS;
-module_param_named(conn_tab_bits, ip_vs_conn_tab_bits, int, 0444);
+module_param_named(conn_tab_bits, ip_vs_conn_tab_bits, int, S_IRUGO);
 MODULE_PARM_DESC(conn_tab_bits, "Set connections' hash size");
 
 /* size and mask values */
diff --git a/net/netfilter/ipvs/ip_vs_ftp.c b/net/netfilter/ipvs/ip_vs_ftp.c
index b20b29c..d114170 100644
--- a/net/netfilter/ipvs/ip_vs_ftp.c
+++ b/net/netfilter/ipvs/ip_vs_ftp.c
@@ -54,7 +54,7 @@
  */
 static unsigned int ports_count = 1;
 static unsigned short ports[IP_VS_APP_MAX_PORTS] = {21, 0};
-module_param_array(ports, ushort, &ports_count, 0444);
+module_param_array(ports, ushort, &ports_count, S_IRUGO);
 MODULE_PARM_DESC(ports, "Ports to monitor for FTP control commands");
 
 
diff --git a/net/netfilter/nf_conntrack_acct.c b/net/netfilter/nf_conntrack_acct.c
index d61e078..6746733 100644
--- a/net/netfilter/nf_conntrack_acct.c
+++ b/net/netfilter/nf_conntrack_acct.c
@@ -20,7 +20,7 @@
 
 static bool nf_ct_acct __read_mostly;
 
-module_param_named(acct, nf_ct_acct, bool, 0644);
+module_param_named(acct, nf_ct_acct, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(acct, "Enable connection tracking flow accounting.");
 
 #ifdef CONFIG_SYSCTL
diff --git a/net/netfilter/nf_conntrack_amanda.c b/net/netfilter/nf_conntrack_amanda.c
index f2de8c5..d451b06 100644
--- a/net/netfilter/nf_conntrack_amanda.c
+++ b/net/netfilter/nf_conntrack_amanda.c
@@ -33,9 +33,9 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS("ip_conntrack_amanda");
 MODULE_ALIAS_NFCT_HELPER("amanda");
 
-module_param(master_timeout, uint, 0600);
+module_param(master_timeout, uint, S_IRUSR | S_IWUSR);
 MODULE_PARM_DESC(master_timeout, "timeout for the master connection");
-module_param(ts_algo, charp, 0400);
+module_param(ts_algo, charp, S_IRUSR);
 MODULE_PARM_DESC(ts_algo, "textsearch algorithm to use (default kmp)");
 
 unsigned int (*nf_nat_amanda_hook)(struct sk_buff *skb,
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index cf48755..fb73c76 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1458,7 +1458,7 @@ int nf_conntrack_set_hashsize(const char *val, struct kernel_param *kp)
 EXPORT_SYMBOL_GPL(nf_conntrack_set_hashsize);
 
 module_param_call(hashsize, nf_conntrack_set_hashsize, param_get_uint,
-		  &nf_conntrack_htable_size, 0600);
+		  &nf_conntrack_htable_size, S_IRUSR | S_IWUSR);
 
 void nf_ct_untracked_status_or(unsigned long bits)
 {
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 45cf602..d5f7093 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -602,7 +602,7 @@ static void exp_proc_remove(struct net *net)
 #endif /* CONFIG_NF_CONNTRACK_PROCFS */
 }
 
-module_param_named(expect_hashsize, nf_ct_expect_hsize, uint, 0400);
+module_param_named(expect_hashsize, nf_ct_expect_hsize, uint, S_IRUSR);
 
 int nf_conntrack_expect_init(struct net *net)
 {
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 4bb771d..6eab10a 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -40,10 +40,10 @@ static DEFINE_SPINLOCK(nf_ftp_lock);
 #define MAX_PORTS 8
 static u_int16_t ports[MAX_PORTS];
 static unsigned int ports_c;
-module_param_array(ports, ushort, &ports_c, 0400);
+module_param_array(ports, ushort, &ports_c, S_IRUSR);
 
 static bool loose;
-module_param(loose, bool, 0600);
+module_param(loose, bool, S_IRUSR | S_IWUSR);
 
 unsigned int (*nf_nat_ftp_hook)(struct sk_buff *skb,
 				enum ip_conntrack_info ctinfo,
diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index 4283b20..4073cd0 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -35,15 +35,15 @@
 
 /* Parameters */
 static unsigned int default_rrq_ttl __read_mostly = 300;
-module_param(default_rrq_ttl, uint, 0600);
+module_param(default_rrq_ttl, uint, S_IRUSR | S_IWUSR);
 MODULE_PARM_DESC(default_rrq_ttl, "use this TTL if it's missing in RRQ");
 
 static int gkrouted_only __read_mostly = 1;
-module_param(gkrouted_only, int, 0600);
+module_param(gkrouted_only, int, S_IRUSR | S_IWUSR);
 MODULE_PARM_DESC(gkrouted_only, "only accept calls from gatekeeper");
 
 static bool callforward_filter __read_mostly = true;
-module_param(callforward_filter, bool, 0600);
+module_param(callforward_filter, bool, S_IRUSR | S_IWUSR);
 MODULE_PARM_DESC(callforward_filter, "only create call forwarding expectations "
 				     "if both endpoints are on different sides "
 				     "(determined by routing information)");
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index c4bc637..0d241ca 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -37,7 +37,8 @@ EXPORT_SYMBOL_GPL(nf_ct_helper_hsize);
 static unsigned int nf_ct_helper_count __read_mostly;
 
 static bool nf_ct_auto_assign_helper __read_mostly = true;
-module_param_named(nf_conntrack_helper, nf_ct_auto_assign_helper, bool, 0644);
+module_param_named(nf_conntrack_helper, nf_ct_auto_assign_helper,
+		   bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(nf_conntrack_helper,
 		 "Enable automatic conntrack helper assignment (default 1)");
 
diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index 009c52c..b680bbb 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -44,12 +44,12 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS("ip_conntrack_irc");
 MODULE_ALIAS_NFCT_HELPER("irc");
 
-module_param_array(ports, ushort, &ports_c, 0400);
+module_param_array(ports, ushort, &ports_c, S_IRUSR);
 MODULE_PARM_DESC(ports, "port numbers of IRC servers");
-module_param(max_dcc_channels, uint, 0400);
+module_param(max_dcc_channels, uint, S_IRUSR);
 MODULE_PARM_DESC(max_dcc_channels, "max number of expected DCC channels per "
 				   "IRC session");
-module_param(dcc_timeout, uint, 0400);
+module_param(dcc_timeout, uint, S_IRUSR);
 MODULE_PARM_DESC(dcc_timeout, "timeout on for unestablished DCC channels");
 
 static const char *const dccprotos[] = {
diff --git a/net/netfilter/nf_conntrack_sane.c b/net/netfilter/nf_conntrack_sane.c
index 295429f..fae8eac 100644
--- a/net/netfilter/nf_conntrack_sane.c
+++ b/net/netfilter/nf_conntrack_sane.c
@@ -40,7 +40,7 @@ static DEFINE_SPINLOCK(nf_sane_lock);
 #define MAX_PORTS 8
 static u_int16_t ports[MAX_PORTS];
 static unsigned int ports_c;
-module_param_array(ports, ushort, &ports_c, 0400);
+module_param_array(ports, ushort, &ports_c, S_IRUSR);
 
 struct sane_request {
 	__be32 RPC_code;
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 758a1ba..e93a767 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -35,20 +35,20 @@ MODULE_ALIAS_NFCT_HELPER("sip");
 #define MAX_PORTS	8
 static unsigned short ports[MAX_PORTS];
 static unsigned int ports_c;
-module_param_array(ports, ushort, &ports_c, 0400);
+module_param_array(ports, ushort, &ports_c, S_IRUSR);
 MODULE_PARM_DESC(ports, "port numbers of SIP servers");
 
 static unsigned int sip_timeout __read_mostly = SIP_TIMEOUT;
-module_param(sip_timeout, uint, 0600);
+module_param(sip_timeout, uint, S_IRUSR | S_IWUSR);
 MODULE_PARM_DESC(sip_timeout, "timeout for the master SIP session");
 
 static int sip_direct_signalling __read_mostly = 1;
-module_param(sip_direct_signalling, int, 0600);
+module_param(sip_direct_signalling, int, S_IRUSR | S_IWUSR);
 MODULE_PARM_DESC(sip_direct_signalling, "expect incoming calls from registrar "
 					"only (default 1)");
 
 static int sip_direct_media __read_mostly = 1;
-module_param(sip_direct_media, int, 0600);
+module_param(sip_direct_media, int, S_IRUSR | S_IWUSR);
 MODULE_PARM_DESC(sip_direct_media, "Expect Media streams between signalling "
 				   "endpoints only (default 1)");
 
diff --git a/net/netfilter/nf_conntrack_tftp.c b/net/netfilter/nf_conntrack_tftp.c
index 81fc61c..136714e 100644
--- a/net/netfilter/nf_conntrack_tftp.c
+++ b/net/netfilter/nf_conntrack_tftp.c
@@ -27,7 +27,7 @@ MODULE_ALIAS_NFCT_HELPER("tftp");
 #define MAX_PORTS 8
 static unsigned short ports[MAX_PORTS];
 static unsigned int ports_c;
-module_param_array(ports, ushort, &ports_c, 0400);
+module_param_array(ports, ushort, &ports_c, S_IRUSR);
 MODULE_PARM_DESC(ports, "Port numbers of TFTP servers");
 
 unsigned int (*nf_nat_tftp_hook)(struct sk_buff *skb,
diff --git a/net/netfilter/nf_conntrack_timestamp.c b/net/netfilter/nf_conntrack_timestamp.c
index dbb364f6..06fd0d3 100644
--- a/net/netfilter/nf_conntrack_timestamp.c
+++ b/net/netfilter/nf_conntrack_timestamp.c
@@ -17,7 +17,7 @@
 
 static bool nf_ct_tstamp __read_mostly;
 
-module_param_named(tstamp, nf_ct_tstamp, bool, 0644);
+module_param_named(tstamp, nf_ct_tstamp, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(tstamp, "Enable connection tracking flow timestamping.");
 
 #ifdef CONFIG_SYSCTL
diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index 0acc17f..54d9d7d 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -48,9 +48,9 @@ static unsigned int ip_list_hash_size = 0;
 static unsigned int ip_list_perms = 0644;
 static unsigned int ip_list_uid = 0;
 static unsigned int ip_list_gid = 0;
-module_param(ip_list_tot, uint, 0400);
-module_param(ip_pkt_list_tot, uint, 0400);
-module_param(ip_list_perms, uint, 0400);
+module_param(ip_list_tot, uint, S_IRUSR);
+module_param(ip_pkt_list_tot, uint, S_IRUSR);
+module_param(ip_list_perms, uint, S_IRUSR);
 module_param(ip_list_uid, uint, S_IRUGO | S_IWUSR);
 module_param(ip_list_gid, uint, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(ip_list_tot, "number of IP addresses to remember per list (>0)");
-- 
1.7.7

