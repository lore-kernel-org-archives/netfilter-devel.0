From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 30/47] netfilter: Replace printk() with pr_*() and define pr_fmt()
Date: Fri, 30 Mar 2018 13:44:52 +0200
Message-ID: <20180330114509.18738-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Arushi Singhal <arushisinghal19971997@gmail.com>

Using pr_<loglevel>() is more concise than printk(KERN_<LOGLEVEL>).
This patch:
* Replace printks having a log level with the appropriate
pr_*() macros.
* Define pr_fmt() to include relevant name.
* Remove redundant prefixes from pr_*() calls.
* Indent the code where possible.
* Remove the useless output messages.
* Remove periods from messages.

Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_acct.c      |  6 ++++--
 net/netfilter/nf_conntrack_ecache.c    |  6 ++++--
 net/netfilter/nf_conntrack_timestamp.c |  6 ++++--
 net/netfilter/nf_nat_core.c            |  4 +++-
 net/netfilter/nf_nat_ftp.c             |  7 ++++---
 net/netfilter/nf_nat_irc.c             |  7 ++++---
 net/netfilter/nfnetlink_queue.c        | 14 +++++++-------
 net/netfilter/xt_time.c                | 13 +++++++------
 8 files changed, 37 insertions(+), 26 deletions(-)

diff --git a/net/netfilter/nf_conntrack_acct.c b/net/netfilter/nf_conntrack_acct.c
index 866916712905..1d66de5151b2 100644
--- a/net/netfilter/nf_conntrack_acct.c
+++ b/net/netfilter/nf_conntrack_acct.c
@@ -8,6 +8,8 @@
  * published by the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/netfilter.h>
 #include <linux/slab.h>
 #include <linux/kernel.h>
@@ -80,7 +82,7 @@ static int nf_conntrack_acct_init_sysctl(struct net *net)
 	net->ct.acct_sysctl_header = register_net_sysctl(net, "net/netfilter",
 							 table);
 	if (!net->ct.acct_sysctl_header) {
-		printk(KERN_ERR "nf_conntrack_acct: can't register to sysctl.\n");
+		pr_err("can't register to sysctl\n");
 		goto out_register;
 	}
 	return 0;
@@ -125,7 +127,7 @@ int nf_conntrack_acct_init(void)
 {
 	int ret = nf_ct_extend_register(&acct_extend);
 	if (ret < 0)
-		pr_err("nf_conntrack_acct: Unable to register extension\n");
+		pr_err("Unable to register extension\n");
 	return ret;
 }
 
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index caac41ad9483..c11822a7d2bf 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -11,6 +11,8 @@
  * published by the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/types.h>
 #include <linux/netfilter.h>
 #include <linux/skbuff.h>
@@ -372,7 +374,7 @@ static int nf_conntrack_event_init_sysctl(struct net *net)
 	net->ct.event_sysctl_header =
 		register_net_sysctl(net, "net/netfilter", table);
 	if (!net->ct.event_sysctl_header) {
-		printk(KERN_ERR "nf_ct_event: can't register to sysctl.\n");
+		pr_err("can't register to sysctl\n");
 		goto out_register;
 	}
 	return 0;
@@ -419,7 +421,7 @@ int nf_conntrack_ecache_init(void)
 {
 	int ret = nf_ct_extend_register(&event_extend);
 	if (ret < 0)
-		pr_err("nf_ct_event: Unable to register event extension.\n");
+		pr_err("Unable to register event extension\n");
 
 	BUILD_BUG_ON(__IPCT_MAX >= 16);	/* ctmask, missed use u16 */
 
diff --git a/net/netfilter/nf_conntrack_timestamp.c b/net/netfilter/nf_conntrack_timestamp.c
index 4c4734b78318..56766cb26e40 100644
--- a/net/netfilter/nf_conntrack_timestamp.c
+++ b/net/netfilter/nf_conntrack_timestamp.c
@@ -6,6 +6,8 @@
  * published by the Free Software Foundation (or any later at your option).
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/netfilter.h>
 #include <linux/slab.h>
 #include <linux/kernel.h>
@@ -58,7 +60,7 @@ static int nf_conntrack_tstamp_init_sysctl(struct net *net)
 	net->ct.tstamp_sysctl_header = register_net_sysctl(net,	"net/netfilter",
 							   table);
 	if (!net->ct.tstamp_sysctl_header) {
-		printk(KERN_ERR "nf_ct_tstamp: can't register to sysctl.\n");
+		pr_err("can't register to sysctl\n");
 		goto out_register;
 	}
 	return 0;
@@ -104,7 +106,7 @@ int nf_conntrack_tstamp_init(void)
 	int ret;
 	ret = nf_ct_extend_register(&tstamp_extend);
 	if (ret < 0)
-		pr_err("nf_ct_tstamp: Unable to register extension\n");
+		pr_err("Unable to register extension\n");
 	return ret;
 }
 
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 6c38421e31f9..617693ff9f4c 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -8,6 +8,8 @@
  * published by the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/timer.h>
@@ -814,7 +816,7 @@ static int __init nf_nat_init(void)
 	ret = nf_ct_extend_register(&nat_extend);
 	if (ret < 0) {
 		nf_ct_free_hashtable(nf_nat_bysource, nf_nat_htable_size);
-		printk(KERN_ERR "nf_nat_core: Unable to register extension\n");
+		pr_err("Unable to register extension\n");
 		return ret;
 	}
 
diff --git a/net/netfilter/nf_nat_ftp.c b/net/netfilter/nf_nat_ftp.c
index d76afafdc699..5063cbf1689c 100644
--- a/net/netfilter/nf_nat_ftp.c
+++ b/net/netfilter/nf_nat_ftp.c
@@ -8,6 +8,8 @@
  * published by the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/inet.h>
@@ -71,7 +73,7 @@ static unsigned int nf_nat_ftp(struct sk_buff *skb,
 	char buffer[sizeof("|1||65535|") + INET6_ADDRSTRLEN];
 	unsigned int buflen;
 
-	pr_debug("FTP_NAT: type %i, off %u len %u\n", type, matchoff, matchlen);
+	pr_debug("type %i, off %u len %u\n", type, matchoff, matchlen);
 
 	/* Connection will come from wherever this packet goes, hence !dir */
 	newaddr = ct->tuplehash[!dir].tuple.dst.u3;
@@ -136,8 +138,7 @@ static int __init nf_nat_ftp_init(void)
 /* Prior to 2.6.11, we had a ports param.  No longer, but don't break users. */
 static int warn_set(const char *val, const struct kernel_param *kp)
 {
-	printk(KERN_INFO KBUILD_MODNAME
-	       ": kernel >= 2.6.10 only uses 'ports' for conntrack modules\n");
+	pr_info("kernel >= 2.6.10 only uses 'ports' for conntrack modules\n");
 	return 0;
 }
 module_param_call(ports, warn_set, NULL, NULL, 0);
diff --git a/net/netfilter/nf_nat_irc.c b/net/netfilter/nf_nat_irc.c
index dcb5f6375d9d..3aa35a43100d 100644
--- a/net/netfilter/nf_nat_irc.c
+++ b/net/netfilter/nf_nat_irc.c
@@ -10,6 +10,8 @@
  * 2 of the License, or (at your option) any later version.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/tcp.h>
@@ -79,7 +81,7 @@ static unsigned int help(struct sk_buff *skb,
 	 */
 	/* AAA = "us", ie. where server normally talks to. */
 	snprintf(buffer, sizeof(buffer), "%u %u", ntohl(newaddr.ip), port);
-	pr_debug("nf_nat_irc: inserting '%s' == %pI4, port %u\n",
+	pr_debug("inserting '%s' == %pI4, port %u\n",
 		 buffer, &newaddr.ip, port);
 
 	if (!nf_nat_mangle_tcp_packet(skb, ct, ctinfo, protoff, matchoff,
@@ -108,8 +110,7 @@ static int __init nf_nat_irc_init(void)
 /* Prior to 2.6.11, we had a ports param.  No longer, but don't break users. */
 static int warn_set(const char *val, const struct kernel_param *kp)
 {
-	printk(KERN_INFO KBUILD_MODNAME
-	       ": kernel >= 2.6.10 only uses 'ports' for conntrack modules\n");
+	pr_info("kernel >= 2.6.10 only uses 'ports' for conntrack modules\n");
 	return 0;
 }
 module_param_call(ports, warn_set, NULL, NULL, 0);
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 8bba23160a68..74a04638ef03 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -14,6 +14,9 @@
  * published by the Free Software Foundation.
  *
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/init.h>
@@ -833,11 +836,8 @@ nfqnl_mangle(void *data, int data_len, struct nf_queue_entry *e, int diff)
 		if (diff > skb_tailroom(e->skb)) {
 			nskb = skb_copy_expand(e->skb, skb_headroom(e->skb),
 					       diff, GFP_ATOMIC);
-			if (!nskb) {
-				printk(KERN_WARNING "nf_queue: OOM "
-				      "in mangle, dropping packet\n");
+			if (!nskb)
 				return -ENOMEM;
-			}
 			kfree_skb(e->skb);
 			e->skb = nskb;
 		}
@@ -1536,20 +1536,20 @@ static int __init nfnetlink_queue_init(void)
 
 	status = register_pernet_subsys(&nfnl_queue_net_ops);
 	if (status < 0) {
-		pr_err("nf_queue: failed to register pernet ops\n");
+		pr_err("failed to register pernet ops\n");
 		goto out;
 	}
 
 	netlink_register_notifier(&nfqnl_rtnl_notifier);
 	status = nfnetlink_subsys_register(&nfqnl_subsys);
 	if (status < 0) {
-		pr_err("nf_queue: failed to create netlink socket\n");
+		pr_err("failed to create netlink socket\n");
 		goto cleanup_netlink_notifier;
 	}
 
 	status = register_netdevice_notifier(&nfqnl_dev_notifier);
 	if (status < 0) {
-		pr_err("nf_queue: failed to register netdevice notifier\n");
+		pr_err("failed to register netdevice notifier\n");
 		goto cleanup_netlink_subsys;
 	}
 
diff --git a/net/netfilter/xt_time.c b/net/netfilter/xt_time.c
index 0160f505e337..c13bcd0ab491 100644
--- a/net/netfilter/xt_time.c
+++ b/net/netfilter/xt_time.c
@@ -9,6 +9,9 @@
  *	This file is distributed under the terms of the GNU General Public
  *	License (GPL). Copies of the GPL can be obtained from gnu.org/gpl.
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/ktime.h>
 #include <linux/module.h>
 #include <linux/skbuff.h>
@@ -266,13 +269,11 @@ static int __init time_mt_init(void)
 	int minutes = sys_tz.tz_minuteswest;
 
 	if (minutes < 0) /* east of Greenwich */
-		printk(KERN_INFO KBUILD_MODNAME
-		       ": kernel timezone is +%02d%02d\n",
-		       -minutes / 60, -minutes % 60);
+		pr_info("kernel timezone is +%02d%02d\n",
+			-minutes / 60, -minutes % 60);
 	else /* west of Greenwich */
-		printk(KERN_INFO KBUILD_MODNAME
-		       ": kernel timezone is -%02d%02d\n",
-		       minutes / 60, minutes % 60);
+		pr_info("kernel timezone is -%02d%02d\n",
+			minutes / 60, minutes % 60);
 
 	return xt_register_match(&xt_time_mt_reg);
 }
-- 
2.11.0
