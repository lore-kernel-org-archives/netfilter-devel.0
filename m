From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: commit 720350a38b1dbd43c907d5d81decd6edd6725d81
Date: Tue, 25 Mar 2008 19:06:19 +0100
Message-ID: <1206468391-368-17-git-send-email-jengelh@computergmbh.de>
References: <alpine.LNX.1.10.0803251903230.31276@fbirervta.pbzchgretzou.qr>
 <1206468391-368-1-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-2-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-3-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-4-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-5-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-6-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-7-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-8-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-9-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-10-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-11-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-12-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-13-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-14-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-15-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-16-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52559 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759245AbYCYSGi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 14:06:38 -0400
In-Reply-To: <1206468391-368-16-git-send-email-jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

    [NETFILTER]: Rename ipt_recent to xt_recent
    
    Like with other modules (such as ipt_state), ipt_recent.h is changed
    to forward definitions to (IOW include) xt_recent.h, and xt_recent.c
    is changed to use the new constant names.
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 include/linux/netfilter/xt_recent.h                |   26 ++++++++
 include/linux/netfilter_ipv4/ipt_recent.h          |   28 ++++-----
 net/ipv4/netfilter/Kconfig                         |   13 ----
 net/ipv4/netfilter/Makefile                        |    1 -
 net/netfilter/Kconfig                              |   11 ++++
 net/netfilter/Makefile                             |    1 +
 .../ipt_recent.c => netfilter/xt_recent.c}         |   37 ++++++------
 7 files changed, 68 insertions(+), 49 deletions(-)
 create mode 100644 include/linux/netfilter/xt_recent.h
 rename net/{ipv4/netfilter/ipt_recent.c => netfilter/xt_recent.c} (92%)

diff --git a/include/linux/netfilter/xt_recent.h b/include/linux/netfilter/xt_recent.h
new file mode 100644
index 0000000..5cfeb81
--- /dev/null
+++ b/include/linux/netfilter/xt_recent.h
@@ -0,0 +1,26 @@
+#ifndef _LINUX_NETFILTER_XT_RECENT_H
+#define _LINUX_NETFILTER_XT_RECENT_H 1
+
+enum {
+	XT_RECENT_CHECK    = 1 << 0,
+	XT_RECENT_SET      = 1 << 1,
+	XT_RECENT_UPDATE   = 1 << 2,
+	XT_RECENT_REMOVE   = 1 << 3,
+	XT_RECENT_TTL      = 1 << 4,
+
+	XT_RECENT_SOURCE   = 0,
+	XT_RECENT_DEST     = 1,
+
+	XT_RECENT_NAME_LEN = 200,
+};
+
+struct xt_recent_mtinfo {
+	u_int32_t seconds;
+	u_int32_t hit_count;
+	u_int8_t check_set;
+	u_int8_t invert;
+	char name[XT_RECENT_NAME_LEN];
+	u_int8_t side;
+};
+
+#endif /* _LINUX_NETFILTER_XT_RECENT_H */
diff --git a/include/linux/netfilter_ipv4/ipt_recent.h b/include/linux/netfilter_ipv4/ipt_recent.h
index 6508a45..d636cca 100644
--- a/include/linux/netfilter_ipv4/ipt_recent.h
+++ b/include/linux/netfilter_ipv4/ipt_recent.h
@@ -1,27 +1,21 @@
 #ifndef _IPT_RECENT_H
 #define _IPT_RECENT_H
 
-#define RECENT_NAME	"ipt_recent"
-#define RECENT_VER	"v0.3.1"
+#include <linux/netfilter/xt_recent.h>
 
-#define IPT_RECENT_CHECK  1
-#define IPT_RECENT_SET    2
-#define IPT_RECENT_UPDATE 4
-#define IPT_RECENT_REMOVE 8
-#define IPT_RECENT_TTL   16
+#define ipt_recent_info xt_recent_mtinfo
 
-#define IPT_RECENT_SOURCE 0
-#define IPT_RECENT_DEST   1
+enum {
+	IPT_RECENT_CHECK    = XT_RECENT_CHECK,
+	IPT_RECENT_SET      = XT_RECENT_SET,
+	IPT_RECENT_UPDATE   = XT_RECENT_UPDATE,
+	IPT_RECENT_REMOVE   = XT_RECENT_REMOVE,
+	IPT_RECENT_TTL      = XT_RECENT_TTL,
 
-#define IPT_RECENT_NAME_LEN 200
+	IPT_RECENT_SOURCE   = XT_RECENT_SOURCE,
+	IPT_RECENT_DEST     = XT_RECENT_DEST,
 
-struct ipt_recent_info {
-	u_int32_t   seconds;
-	u_int32_t   hit_count;
-	u_int8_t    check_set;
-	u_int8_t    invert;
-	char        name[IPT_RECENT_NAME_LEN];
-	u_int8_t    side;
+	IPT_RECENT_NAME_LEN = XT_RECENT_NAME_LEN,
 };
 
 #endif /*_IPT_RECENT_H*/
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 9a077cb..eeaab13 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -57,19 +57,6 @@ config IP_NF_IPTABLES
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 # The matches.
-config IP_NF_MATCH_RECENT
-	tristate '"recent" match support'
-	depends on IP_NF_IPTABLES
-	depends on NETFILTER_ADVANCED
-	help
-	  This match is used for creating one or many lists of recently
-	  used addresses and then matching against that/those list(s).
-
-	  Short options are available by using 'iptables -m recent -h'
-	  Official Website: <http://snowman.net/projects/ipt_recent/>
-
-	  To compile it as a module, choose M here.  If unsure, say N.
-
 config IP_NF_MATCH_ECN
 	tristate '"ecn" match support'
 	depends on IP_NF_IPTABLES
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 0c7dc78..7b1b4e5 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -44,7 +44,6 @@ obj-$(CONFIG_IP_NF_RAW) += iptable_raw.o
 obj-$(CONFIG_IP_NF_MATCH_ADDRTYPE) += ipt_addrtype.o
 obj-$(CONFIG_IP_NF_MATCH_AH) += ipt_ah.o
 obj-$(CONFIG_IP_NF_MATCH_ECN) += ipt_ecn.o
-obj-$(CONFIG_IP_NF_MATCH_RECENT) += ipt_recent.o
 obj-$(CONFIG_IP_NF_MATCH_TTL) += ipt_ttl.o
 
 # targets
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index daf5b88..222aa07 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -711,6 +711,17 @@ config NETFILTER_XT_MATCH_REALM
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
 
+config NETFILTER_XT_MATCH_RECENT
+	tristate '"recent" match support'
+	depends on NETFILTER_XTABLES
+	depends on NETFILTER_ADVANCED
+	---help---
+	This match is used for creating one or many lists of recently
+	used addresses and then matching against that/those list(s).
+
+	Short options are available by using 'iptables -m recent -h'
+	Official Website: <http://snowman.net/projects/ipt_recent/>
+
 config NETFILTER_XT_MATCH_SCTP
 	tristate  '"sctp" protocol match support (EXPERIMENTAL)'
 	depends on NETFILTER_XTABLES && EXPERIMENTAL
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index ea75083..9599083 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -75,6 +75,7 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_POLICY) += xt_policy.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_QUOTA) += xt_quota.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_RATEEST) += xt_rateest.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_REALM) += xt_realm.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_RECENT) += xt_recent.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_SCTP) += xt_sctp.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STATE) += xt_state.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STATISTIC) += xt_statistic.o
diff --git a/net/ipv4/netfilter/ipt_recent.c b/net/netfilter/xt_recent.c
similarity index 92%
rename from net/ipv4/netfilter/ipt_recent.c
rename to net/netfilter/xt_recent.c
index 3e62066..cc5472d 100644
--- a/net/ipv4/netfilter/ipt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -27,11 +27,12 @@
 #include <net/net_namespace.h>
 
 #include <linux/netfilter/x_tables.h>
-#include <linux/netfilter_ipv4/ipt_recent.h>
+#include <linux/netfilter/xt_recent.h>
 
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
 MODULE_DESCRIPTION("Xtables: \"recently-seen\" host matching for IPv4");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_recent");
 
 static unsigned int ip_list_tot = 100;
 static unsigned int ip_pkt_list_tot = 20;
@@ -64,7 +65,7 @@ struct recent_entry {
 
 struct recent_table {
 	struct list_head	list;
-	char			name[IPT_RECENT_NAME_LEN];
+	char			name[XT_RECENT_NAME_LEN];
 #ifdef CONFIG_PROC_FS
 	struct proc_dir_entry	*proc;
 #endif
@@ -175,14 +176,14 @@ recent_mt(const struct sk_buff *skb, const struct net_device *in,
           const void *matchinfo, int offset, unsigned int protoff,
           bool *hotdrop)
 {
-	const struct ipt_recent_info *info = matchinfo;
+	const struct xt_recent_mtinfo *info = matchinfo;
 	struct recent_table *t;
 	struct recent_entry *e;
 	__be32 addr;
 	u_int8_t ttl;
 	bool ret = info->invert;
 
-	if (info->side == IPT_RECENT_DEST)
+	if (info->side == XT_RECENT_DEST)
 		addr = ip_hdr(skb)->daddr;
 	else
 		addr = ip_hdr(skb)->saddr;
@@ -195,9 +196,9 @@ recent_mt(const struct sk_buff *skb, const struct net_device *in,
 	spin_lock_bh(&recent_lock);
 	t = recent_table_lookup(info->name);
 	e = recent_entry_lookup(t, addr,
-				info->check_set & IPT_RECENT_TTL ? ttl : 0);
+				info->check_set & XT_RECENT_TTL ? ttl : 0);
 	if (e == NULL) {
-		if (!(info->check_set & IPT_RECENT_SET))
+		if (!(info->check_set & XT_RECENT_SET))
 			goto out;
 		e = recent_entry_init(t, addr, ttl);
 		if (e == NULL)
@@ -206,12 +207,12 @@ recent_mt(const struct sk_buff *skb, const struct net_device *in,
 		goto out;
 	}
 
-	if (info->check_set & IPT_RECENT_SET)
+	if (info->check_set & XT_RECENT_SET)
 		ret = !ret;
-	else if (info->check_set & IPT_RECENT_REMOVE) {
+	else if (info->check_set & XT_RECENT_REMOVE) {
 		recent_entry_remove(t, e);
 		ret = !ret;
-	} else if (info->check_set & (IPT_RECENT_CHECK | IPT_RECENT_UPDATE)) {
+	} else if (info->check_set & (XT_RECENT_CHECK | XT_RECENT_UPDATE)) {
 		unsigned long time = jiffies - info->seconds * HZ;
 		unsigned int i, hits = 0;
 
@@ -225,8 +226,8 @@ recent_mt(const struct sk_buff *skb, const struct net_device *in,
 		}
 	}
 
-	if (info->check_set & IPT_RECENT_SET ||
-	    (info->check_set & IPT_RECENT_UPDATE && ret)) {
+	if (info->check_set & XT_RECENT_SET ||
+	    (info->check_set & XT_RECENT_UPDATE && ret)) {
 		recent_entry_update(t, e);
 		e->ttl = ttl;
 	}
@@ -240,22 +241,22 @@ recent_mt_check(const char *tablename, const void *ip,
                 const struct xt_match *match, void *matchinfo,
                 unsigned int hook_mask)
 {
-	const struct ipt_recent_info *info = matchinfo;
+	const struct xt_recent_mtinfo *info = matchinfo;
 	struct recent_table *t;
 	unsigned i;
 	bool ret = false;
 
 	if (hweight8(info->check_set &
-		     (IPT_RECENT_SET | IPT_RECENT_REMOVE |
-		      IPT_RECENT_CHECK | IPT_RECENT_UPDATE)) != 1)
+		     (XT_RECENT_SET | XT_RECENT_REMOVE |
+		      XT_RECENT_CHECK | XT_RECENT_UPDATE)) != 1)
 		return false;
-	if ((info->check_set & (IPT_RECENT_SET | IPT_RECENT_REMOVE)) &&
+	if ((info->check_set & (XT_RECENT_SET | XT_RECENT_REMOVE)) &&
 	    (info->seconds || info->hit_count))
 		return false;
 	if (info->hit_count > ip_pkt_list_tot)
 		return false;
 	if (info->name[0] == '\0' ||
-	    strnlen(info->name, IPT_RECENT_NAME_LEN) == IPT_RECENT_NAME_LEN)
+	    strnlen(info->name, XT_RECENT_NAME_LEN) == XT_RECENT_NAME_LEN)
 		return false;
 
 	mutex_lock(&recent_mutex);
@@ -297,7 +298,7 @@ out:
 
 static void recent_mt_destroy(const struct xt_match *match, void *matchinfo)
 {
-	const struct ipt_recent_info *info = matchinfo;
+	const struct xt_recent_mtinfo *info = matchinfo;
 	struct recent_table *t;
 
 	mutex_lock(&recent_mutex);
@@ -462,7 +463,7 @@ static struct xt_match recent_mt_reg __read_mostly = {
 	.name		= "recent",
 	.family		= AF_INET,
 	.match		= recent_mt,
-	.matchsize	= sizeof(struct ipt_recent_info),
+	.matchsize	= sizeof(struct xt_recent_mtinfo),
 	.checkentry	= recent_mt_check,
 	.destroy	= recent_mt_destroy,
 	.me		= THIS_MODULE,
