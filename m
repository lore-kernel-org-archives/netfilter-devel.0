From: Jan Engelhardt <jengelh@medozas.de>
Subject: 01/11 [NETFILTER]: Ebtables: do centralized size checking
Date: Wed, 10 Sep 2008 22:44:38 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0809102242180.8838@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:41545 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbYIKCom (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Sep 2008 22:44:42 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 195dab667664f4083e89459d666a3887b683b820
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Sep 10 22:31:42 2008 -0400

[NETFILTER]: Ebtables: do centralized size checking

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter_bridge/ebtables.h |    3 +
 net/bridge/netfilter/ebt_802_3.c          |    7 +--
 net/bridge/netfilter/ebt_among.c          |    1 +
 net/bridge/netfilter/ebt_arp.c            |    9 ++--
 net/bridge/netfilter/ebt_arpreply.c       |    9 ++--
 net/bridge/netfilter/ebt_dnat.c           |    9 ++--
 net/bridge/netfilter/ebt_ip.c             |    9 ++--
 net/bridge/netfilter/ebt_ip6.c            |    9 ++--
 net/bridge/netfilter/ebt_limit.c          |   11 ++---
 net/bridge/netfilter/ebt_log.c            |   11 ++---
 net/bridge/netfilter/ebt_mark.c           |    6 +-
 net/bridge/netfilter/ebt_mark_m.c         |    7 +--
 net/bridge/netfilter/ebt_nflog.c          |    4 +-
 net/bridge/netfilter/ebt_pkttype.c        |    7 +--
 net/bridge/netfilter/ebt_redirect.c       |   11 ++---
 net/bridge/netfilter/ebt_snat.c           |   11 ++---
 net/bridge/netfilter/ebt_stp.c            |   10 ++---
 net/bridge/netfilter/ebt_ulog.c           |    5 +-
 net/bridge/netfilter/ebt_vlan.c           |   10 +----
 net/bridge/netfilter/ebtables.c           |   43 ++++++++++++++++++--
 20 files changed, 104 insertions(+), 88 deletions(-)

diff --git a/include/linux/netfilter_bridge/ebtables.h b/include/linux/netfilter_bridge/ebtables.h
index 892f5b7..fd085af 100644
--- a/include/linux/netfilter_bridge/ebtables.h
+++ b/include/linux/netfilter_bridge/ebtables.h
@@ -215,6 +215,7 @@ struct ebt_match
 	int (*check)(const char *tablename, unsigned int hookmask,
 	   const struct ebt_entry *e, void *matchdata, unsigned int datalen);
 	void (*destroy)(void *matchdata, unsigned int datalen);
+	unsigned int matchsize;
 	struct module *me;
 };
 
@@ -229,6 +230,7 @@ struct ebt_watcher
 	int (*check)(const char *tablename, unsigned int hookmask,
 	   const struct ebt_entry *e, void *watcherdata, unsigned int datalen);
 	void (*destroy)(void *watcherdata, unsigned int datalen);
+	unsigned int targetsize;
 	struct module *me;
 };
 
@@ -244,6 +246,7 @@ struct ebt_target
 	int (*check)(const char *tablename, unsigned int hookmask,
 	   const struct ebt_entry *e, void *targetdata, unsigned int datalen);
 	void (*destroy)(void *targetdata, unsigned int datalen);
+	unsigned int targetsize;
 	struct module *me;
 };
 
diff --git a/net/bridge/netfilter/ebt_802_3.c b/net/bridge/netfilter/ebt_802_3.c
index 9853402..ccecfbd 100644
--- a/net/bridge/netfilter/ebt_802_3.c
+++ b/net/bridge/netfilter/ebt_802_3.c
@@ -7,10 +7,10 @@
  * May 2003
  *
  */
-
+#include <linux/module.h>
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_bridge/ebt_802_3.h>
-#include <linux/module.h>
 
 static int ebt_filter_802_3(const struct sk_buff *skb, const struct net_device *in,
    const struct net_device *out, const void *data, unsigned int datalen)
@@ -42,8 +42,6 @@ static int ebt_802_3_check(const char *tablename, unsigned int hookmask,
 {
 	const struct ebt_802_3_info *info = data;
 
-	if (datalen < sizeof(struct ebt_802_3_info))
-		return -EINVAL;
 	if (info->bitmask & ~EBT_802_3_MASK || info->invflags & ~EBT_802_3_MASK)
 		return -EINVAL;
 
@@ -54,6 +52,7 @@ static struct ebt_match filter_802_3 __read_mostly = {
 	.name		= EBT_802_3_MATCH,
 	.match		= ebt_filter_802_3,
 	.check		= ebt_802_3_check,
+	.matchsize	= XT_ALIGN(sizeof(struct ebt_802_3_info)),
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/bridge/netfilter/ebt_among.c b/net/bridge/netfilter/ebt_among.c
index 70b6dca..b0acb13 100644
--- a/net/bridge/netfilter/ebt_among.c
+++ b/net/bridge/netfilter/ebt_among.c
@@ -216,6 +216,7 @@ static struct ebt_match filter_among __read_mostly = {
 	.name		= EBT_AMONG_MATCH,
 	.match		= ebt_filter_among,
 	.check		= ebt_among_check,
+	.matchsize	= -1, /* special case */
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/bridge/netfilter/ebt_arp.c b/net/bridge/netfilter/ebt_arp.c
index 7c535be..385f9cb 100644
--- a/net/bridge/netfilter/ebt_arp.c
+++ b/net/bridge/netfilter/ebt_arp.c
@@ -8,12 +8,12 @@
  *  April, 2002
  *
  */
-
-#include <linux/netfilter_bridge/ebtables.h>
-#include <linux/netfilter_bridge/ebt_arp.h>
 #include <linux/if_arp.h>
 #include <linux/if_ether.h>
 #include <linux/module.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter_bridge/ebtables.h>
+#include <linux/netfilter_bridge/ebt_arp.h>
 
 static int ebt_filter_arp(const struct sk_buff *skb, const struct net_device *in,
    const struct net_device *out, const void *data, unsigned int datalen)
@@ -105,8 +105,6 @@ static int ebt_arp_check(const char *tablename, unsigned int hookmask,
 {
 	const struct ebt_arp_info *info = data;
 
-	if (datalen != EBT_ALIGN(sizeof(struct ebt_arp_info)))
-		return -EINVAL;
 	if ((e->ethproto != htons(ETH_P_ARP) &&
 	   e->ethproto != htons(ETH_P_RARP)) ||
 	   e->invflags & EBT_IPROTO)
@@ -120,6 +118,7 @@ static struct ebt_match filter_arp __read_mostly = {
 	.name		= EBT_ARP_MATCH,
 	.match		= ebt_filter_arp,
 	.check		= ebt_arp_check,
+	.matchsize	= XT_ALIGN(sizeof(struct ebt_arp_info)),
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/bridge/netfilter/ebt_arpreply.c b/net/bridge/netfilter/ebt_arpreply.c
index 0c42795..a860ea6 100644
--- a/net/bridge/netfilter/ebt_arpreply.c
+++ b/net/bridge/netfilter/ebt_arpreply.c
@@ -8,12 +8,12 @@
  *  August, 2003
  *
  */
-
-#include <linux/netfilter_bridge/ebtables.h>
-#include <linux/netfilter_bridge/ebt_arpreply.h>
 #include <linux/if_arp.h>
 #include <net/arp.h>
 #include <linux/module.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter_bridge/ebtables.h>
+#include <linux/netfilter_bridge/ebt_arpreply.h>
 
 static int ebt_target_reply(struct sk_buff *skb, unsigned int hooknr,
    const struct net_device *in, const struct net_device *out,
@@ -63,8 +63,6 @@ static int ebt_target_reply_check(const char *tablename, unsigned int hookmask,
 {
 	const struct ebt_arpreply_info *info = data;
 
-	if (datalen != EBT_ALIGN(sizeof(struct ebt_arpreply_info)))
-		return -EINVAL;
 	if (BASE_CHAIN && info->target == EBT_RETURN)
 		return -EINVAL;
 	if (e->ethproto != htons(ETH_P_ARP) ||
@@ -80,6 +78,7 @@ static struct ebt_target reply_target __read_mostly = {
 	.name		= EBT_ARPREPLY_TARGET,
 	.target		= ebt_target_reply,
 	.check		= ebt_target_reply_check,
+	.targetsize	= XT_ALIGN(sizeof(struct ebt_arpreply_info)),
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/bridge/netfilter/ebt_dnat.c b/net/bridge/netfilter/ebt_dnat.c
index ca64c1c..c2be41e 100644
--- a/net/bridge/netfilter/ebt_dnat.c
+++ b/net/bridge/netfilter/ebt_dnat.c
@@ -7,12 +7,12 @@
  *  June, 2002
  *
  */
-
+#include <linux/module.h>
+#include <net/sock.h>
 #include <linux/netfilter.h>
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_bridge/ebt_nat.h>
-#include <linux/module.h>
-#include <net/sock.h>
 
 static int ebt_target_dnat(struct sk_buff *skb, unsigned int hooknr,
    const struct net_device *in, const struct net_device *out,
@@ -39,8 +39,6 @@ static int ebt_target_dnat_check(const char *tablename, unsigned int hookmask,
 	   (hookmask & ~((1 << NF_BR_PRE_ROUTING) | (1 << NF_BR_LOCAL_OUT)))) &&
 	   (strcmp(tablename, "broute") || hookmask & ~(1 << NF_BR_BROUTING)) )
 		return -EINVAL;
-	if (datalen != EBT_ALIGN(sizeof(struct ebt_nat_info)))
-		return -EINVAL;
 	if (INVALID_TARGET)
 		return -EINVAL;
 	return 0;
@@ -50,6 +48,7 @@ static struct ebt_target dnat __read_mostly = {
 	.name		= EBT_DNAT_TARGET,
 	.target		= ebt_target_dnat,
 	.check		= ebt_target_dnat_check,
+	.targetsize	= XT_ALIGN(sizeof(struct ebt_nat_info)),
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/bridge/netfilter/ebt_ip.c b/net/bridge/netfilter/ebt_ip.c
index 65caa00..c1ae254 100644
--- a/net/bridge/netfilter/ebt_ip.c
+++ b/net/bridge/netfilter/ebt_ip.c
@@ -11,13 +11,13 @@
  *    Innominate Security Technologies AG <mhopf@innominate.com>
  *    September, 2002
  */
-
-#include <linux/netfilter_bridge/ebtables.h>
-#include <linux/netfilter_bridge/ebt_ip.h>
 #include <linux/ip.h>
 #include <net/ip.h>
 #include <linux/in.h>
 #include <linux/module.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter_bridge/ebtables.h>
+#include <linux/netfilter_bridge/ebt_ip.h>
 
 struct tcpudphdr {
 	__be16 src;
@@ -83,8 +83,6 @@ static int ebt_ip_check(const char *tablename, unsigned int hookmask,
 {
 	const struct ebt_ip_info *info = data;
 
-	if (datalen != EBT_ALIGN(sizeof(struct ebt_ip_info)))
-		return -EINVAL;
 	if (e->ethproto != htons(ETH_P_IP) ||
 	   e->invflags & EBT_IPROTO)
 		return -EINVAL;
@@ -111,6 +109,7 @@ static struct ebt_match filter_ip __read_mostly = {
 	.name		= EBT_IP_MATCH,
 	.match		= ebt_filter_ip,
 	.check		= ebt_ip_check,
+	.matchsize	= XT_ALIGN(sizeof(struct ebt_ip_info)),
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/bridge/netfilter/ebt_ip6.c b/net/bridge/netfilter/ebt_ip6.c
index 36efb3a..554dd68 100644
--- a/net/bridge/netfilter/ebt_ip6.c
+++ b/net/bridge/netfilter/ebt_ip6.c
@@ -13,14 +13,14 @@
  *
  *  Jan, 2008
  */
-
-#include <linux/netfilter_bridge/ebtables.h>
-#include <linux/netfilter_bridge/ebt_ip6.h>
 #include <linux/ipv6.h>
 #include <net/ipv6.h>
 #include <linux/in.h>
 #include <linux/module.h>
 #include <net/dsfield.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter_bridge/ebtables.h>
+#include <linux/netfilter_bridge/ebt_ip6.h>
 
 struct tcpudphdr {
 	__be16 src;
@@ -97,8 +97,6 @@ static int ebt_ip6_check(const char *tablename, unsigned int hookmask,
 {
 	struct ebt_ip6_info *info = (struct ebt_ip6_info *)data;
 
-	if (datalen != EBT_ALIGN(sizeof(struct ebt_ip6_info)))
-		return -EINVAL;
 	if (e->ethproto != htons(ETH_P_IPV6) || e->invflags & EBT_IPROTO)
 		return -EINVAL;
 	if (info->bitmask & ~EBT_IP6_MASK || info->invflags & ~EBT_IP6_MASK)
@@ -125,6 +123,7 @@ static struct ebt_match filter_ip6 =
 	.name		= EBT_IP6_MATCH,
 	.match		= ebt_filter_ip6,
 	.check		= ebt_ip6_check,
+	.matchsize	= XT_ALIGN(sizeof(struct ebt_ip6_info)),
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/bridge/netfilter/ebt_limit.c b/net/bridge/netfilter/ebt_limit.c
index 8cbdc01..3d71f35 100644
--- a/net/bridge/netfilter/ebt_limit.c
+++ b/net/bridge/netfilter/ebt_limit.c
@@ -10,13 +10,12 @@
  *  September, 2003
  *
  */
-
-#include <linux/netfilter_bridge/ebtables.h>
-#include <linux/netfilter_bridge/ebt_limit.h>
 #include <linux/module.h>
-
 #include <linux/netdevice.h>
 #include <linux/spinlock.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter_bridge/ebtables.h>
+#include <linux/netfilter_bridge/ebt_limit.h>
 
 static DEFINE_SPINLOCK(limit_lock);
 
@@ -71,9 +70,6 @@ static int ebt_limit_check(const char *tablename, unsigned int hookmask,
 {
 	struct ebt_limit_info *info = data;
 
-	if (datalen != EBT_ALIGN(sizeof(struct ebt_limit_info)))
-		return -EINVAL;
-
 	/* Check for overflow. */
 	if (info->burst == 0 ||
 	    user2credits(info->avg * info->burst) < user2credits(info->avg)) {
@@ -94,6 +90,7 @@ static struct ebt_match ebt_limit_reg __read_mostly = {
 	.name		= EBT_LIMIT_MATCH,
 	.match		= ebt_limit_match,
 	.check		= ebt_limit_check,
+	.matchsize	= XT_ALIGN(sizeof(struct ebt_limit_info)),
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/bridge/netfilter/ebt_log.c b/net/bridge/netfilter/ebt_log.c
index 8b17c64..d9596f1 100644
--- a/net/bridge/netfilter/ebt_log.c
+++ b/net/bridge/netfilter/ebt_log.c
@@ -8,10 +8,6 @@
  *  April, 2002
  *
  */
-
-#include <linux/netfilter_bridge/ebtables.h>
-#include <linux/netfilter_bridge/ebt_log.h>
-#include <linux/netfilter.h>
 #include <linux/module.h>
 #include <linux/ip.h>
 #include <linux/in.h>
@@ -21,6 +17,10 @@
 #include <linux/ipv6.h>
 #include <net/ipv6.h>
 #include <linux/in6.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter_bridge/ebtables.h>
+#include <linux/netfilter_bridge/ebt_log.h>
+#include <linux/netfilter.h>
 
 static DEFINE_SPINLOCK(ebt_log_lock);
 
@@ -29,8 +29,6 @@ static int ebt_log_check(const char *tablename, unsigned int hookmask,
 {
 	struct ebt_log_info *info = data;
 
-	if (datalen != EBT_ALIGN(sizeof(struct ebt_log_info)))
-		return -EINVAL;
 	if (info->bitmask & ~EBT_LOG_MASK)
 		return -EINVAL;
 	if (info->loglevel >= 8)
@@ -218,6 +216,7 @@ static struct ebt_watcher log =
 	.name		= EBT_LOG_WATCHER,
 	.watcher	= ebt_log,
 	.check		= ebt_log_check,
+	.targetsize	= XT_ALIGN(sizeof(struct ebt_log_info)),
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/bridge/netfilter/ebt_mark.c b/net/bridge/netfilter/ebt_mark.c
index 36723f4..bb02412 100644
--- a/net/bridge/netfilter/ebt_mark.c
+++ b/net/bridge/netfilter/ebt_mark.c
@@ -13,9 +13,10 @@
  * Marking a frame doesn't really change anything in the frame anyway.
  */
 
+#include <linux/module.h>
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_bridge/ebt_mark_t.h>
-#include <linux/module.h>
 
 static int ebt_target_mark(struct sk_buff *skb, unsigned int hooknr,
    const struct net_device *in, const struct net_device *out,
@@ -42,8 +43,6 @@ static int ebt_target_mark_check(const char *tablename, unsigned int hookmask,
 	const struct ebt_mark_t_info *info = data;
 	int tmp;
 
-	if (datalen != EBT_ALIGN(sizeof(struct ebt_mark_t_info)))
-		return -EINVAL;
 	tmp = info->target | ~EBT_VERDICT_BITS;
 	if (BASE_CHAIN && tmp == EBT_RETURN)
 		return -EINVAL;
@@ -61,6 +60,7 @@ static struct ebt_target mark_target __read_mostly = {
 	.name		= EBT_MARK_TARGET,
 	.target		= ebt_target_mark,
 	.check		= ebt_target_mark_check,
+	.targetsize	= XT_ALIGN(sizeof(struct ebt_mark_t_info)),
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/bridge/netfilter/ebt_mark_m.c b/net/bridge/netfilter/ebt_mark_m.c
index 9b0a454..b8ce9eb 100644
--- a/net/bridge/netfilter/ebt_mark_m.c
+++ b/net/bridge/netfilter/ebt_mark_m.c
@@ -7,10 +7,10 @@
  *  July, 2002
  *
  */
-
+#include <linux/module.h>
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_bridge/ebt_mark_m.h>
-#include <linux/module.h>
 
 static int ebt_filter_mark(const struct sk_buff *skb,
    const struct net_device *in, const struct net_device *out, const void *data,
@@ -28,8 +28,6 @@ static int ebt_mark_check(const char *tablename, unsigned int hookmask,
 {
 	const struct ebt_mark_m_info *info = data;
 
-	if (datalen != EBT_ALIGN(sizeof(struct ebt_mark_m_info)))
-		return -EINVAL;
 	if (info->bitmask & ~EBT_MARK_MASK)
 		return -EINVAL;
 	if ((info->bitmask & EBT_MARK_OR) && (info->bitmask & EBT_MARK_AND))
@@ -43,6 +41,7 @@ static struct ebt_match filter_mark __read_mostly = {
 	.name		= EBT_MARK_MATCH,
 	.match		= ebt_filter_mark,
 	.check		= ebt_mark_check,
+	.matchsize	= XT_ALIGN(sizeof(struct ebt_mark_m_info)),
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/bridge/netfilter/ebt_nflog.c b/net/bridge/netfilter/ebt_nflog.c
index 8e799aa..88ceb5e 100644
--- a/net/bridge/netfilter/ebt_nflog.c
+++ b/net/bridge/netfilter/ebt_nflog.c
@@ -14,6 +14,7 @@
 
 #include <linux/module.h>
 #include <linux/spinlock.h>
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_bridge/ebt_nflog.h>
 #include <net/netfilter/nf_log.h>
@@ -42,8 +43,6 @@ static int ebt_nflog_check(const char *tablename,
 {
 	struct ebt_nflog_info *info = (struct ebt_nflog_info *)data;
 
-	if (datalen != EBT_ALIGN(sizeof(struct ebt_nflog_info)))
-		return -EINVAL;
 	if (info->flags & ~EBT_NFLOG_MASK)
 		return -EINVAL;
 	info->prefix[EBT_NFLOG_PREFIX_SIZE - 1] = '\0';
@@ -54,6 +53,7 @@ static struct ebt_watcher nflog __read_mostly = {
 	.name = EBT_NFLOG_WATCHER,
 	.watcher = ebt_nflog,
 	.check = ebt_nflog_check,
+	.targetsize = XT_ALIGN(sizeof(struct ebt_nflog_info)),
 	.me = THIS_MODULE,
 };
 
diff --git a/net/bridge/netfilter/ebt_pkttype.c b/net/bridge/netfilter/ebt_pkttype.c
index 676db32..0190261 100644
--- a/net/bridge/netfilter/ebt_pkttype.c
+++ b/net/bridge/netfilter/ebt_pkttype.c
@@ -7,10 +7,10 @@
  *  April, 2003
  *
  */
-
+#include <linux/module.h>
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_bridge/ebt_pkttype.h>
-#include <linux/module.h>
 
 static int ebt_filter_pkttype(const struct sk_buff *skb,
    const struct net_device *in,
@@ -28,8 +28,6 @@ static int ebt_pkttype_check(const char *tablename, unsigned int hookmask,
 {
 	const struct ebt_pkttype_info *info = data;
 
-	if (datalen != EBT_ALIGN(sizeof(struct ebt_pkttype_info)))
-		return -EINVAL;
 	if (info->invert != 0 && info->invert != 1)
 		return -EINVAL;
 	/* Allow any pkt_type value */
@@ -40,6 +38,7 @@ static struct ebt_match filter_pkttype __read_mostly = {
 	.name		= EBT_PKTTYPE_MATCH,
 	.match		= ebt_filter_pkttype,
 	.check		= ebt_pkttype_check,
+	.matchsize	= XT_ALIGN(sizeof(struct ebt_pkttype_info)),
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/bridge/netfilter/ebt_redirect.c b/net/bridge/netfilter/ebt_redirect.c
index b8afe85..0405326 100644
--- a/net/bridge/netfilter/ebt_redirect.c
+++ b/net/bridge/netfilter/ebt_redirect.c
@@ -7,13 +7,13 @@
  *  April, 2002
  *
  */
-
-#include <linux/netfilter.h>
-#include <linux/netfilter_bridge/ebtables.h>
-#include <linux/netfilter_bridge/ebt_redirect.h>
 #include <linux/module.h>
 #include <net/sock.h>
 #include "../br_private.h"
+#include <linux/netfilter.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter_bridge/ebtables.h>
+#include <linux/netfilter_bridge/ebt_redirect.h>
 
 static int ebt_target_redirect(struct sk_buff *skb, unsigned int hooknr,
    const struct net_device *in, const struct net_device *out,
@@ -38,8 +38,6 @@ static int ebt_target_redirect_check(const char *tablename, unsigned int hookmas
 {
 	const struct ebt_redirect_info *info = data;
 
-	if (datalen != EBT_ALIGN(sizeof(struct ebt_redirect_info)))
-		return -EINVAL;
 	if (BASE_CHAIN && info->target == EBT_RETURN)
 		return -EINVAL;
 	CLEAR_BASE_CHAIN_BIT;
@@ -55,6 +53,7 @@ static struct ebt_target redirect_target __read_mostly = {
 	.name		= EBT_REDIRECT_TARGET,
 	.target		= ebt_target_redirect,
 	.check		= ebt_target_redirect_check,
+	.targetsize	= XT_ALIGN(sizeof(struct ebt_redirect_info)),
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/bridge/netfilter/ebt_snat.c b/net/bridge/netfilter/ebt_snat.c
index 5425333..abfbc6c 100644
--- a/net/bridge/netfilter/ebt_snat.c
+++ b/net/bridge/netfilter/ebt_snat.c
@@ -7,14 +7,14 @@
  *  June, 2002
  *
  */
-
-#include <linux/netfilter.h>
-#include <linux/netfilter_bridge/ebtables.h>
-#include <linux/netfilter_bridge/ebt_nat.h>
 #include <linux/module.h>
 #include <net/sock.h>
 #include <linux/if_arp.h>
 #include <net/arp.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter_bridge/ebtables.h>
+#include <linux/netfilter_bridge/ebt_nat.h>
 
 static int ebt_target_snat(struct sk_buff *skb, unsigned int hooknr,
    const struct net_device *in, const struct net_device *out,
@@ -49,8 +49,6 @@ static int ebt_target_snat_check(const char *tablename, unsigned int hookmask,
 	const struct ebt_nat_info *info = data;
 	int tmp;
 
-	if (datalen != EBT_ALIGN(sizeof(struct ebt_nat_info)))
-		return -EINVAL;
 	tmp = info->target | ~EBT_VERDICT_BITS;
 	if (BASE_CHAIN && tmp == EBT_RETURN)
 		return -EINVAL;
@@ -72,6 +70,7 @@ static struct ebt_target snat __read_mostly = {
 	.name		= EBT_SNAT_TARGET,
 	.target		= ebt_target_snat,
 	.check		= ebt_target_snat_check,
+	.targetsize	= XT_ALIGN(sizeof(struct ebt_nat_info)),
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/bridge/netfilter/ebt_stp.c b/net/bridge/netfilter/ebt_stp.c
index 40f36d3..c7a0a00 100644
--- a/net/bridge/netfilter/ebt_stp.c
+++ b/net/bridge/netfilter/ebt_stp.c
@@ -7,11 +7,11 @@
  *
  *  July, 2003
  */
-
-#include <linux/netfilter_bridge/ebtables.h>
-#include <linux/netfilter_bridge/ebt_stp.h>
 #include <linux/etherdevice.h>
 #include <linux/module.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter_bridge/ebtables.h>
+#include <linux/netfilter_bridge/ebt_stp.h>
 
 #define BPDU_TYPE_CONFIG 0
 #define BPDU_TYPE_TCN 0x80
@@ -157,15 +157,12 @@ static int ebt_stp_check(const char *tablename, unsigned int hookmask,
    const struct ebt_entry *e, void *data, unsigned int datalen)
 {
 	const struct ebt_stp_info *info = data;
-	const unsigned int len = EBT_ALIGN(sizeof(struct ebt_stp_info));
 	const uint8_t bridge_ula[6] = {0x01, 0x80, 0xc2, 0x00, 0x00, 0x00};
 	const uint8_t msk[6] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 
 	if (info->bitmask & ~EBT_STP_MASK || info->invflags & ~EBT_STP_MASK ||
 	    !(info->bitmask & EBT_STP_MASK))
 		return -EINVAL;
-	if (datalen != len)
-		return -EINVAL;
 	/* Make sure the match only receives stp frames */
 	if (compare_ether_addr(e->destmac, bridge_ula) ||
 	    compare_ether_addr(e->destmsk, msk) || !(e->bitmask & EBT_DESTMAC))
@@ -178,6 +175,7 @@ static struct ebt_match filter_stp __read_mostly = {
 	.name		= EBT_STP_MATCH,
 	.match		= ebt_filter_stp,
 	.check		= ebt_stp_check,
+	.matchsize	= XT_ALIGN(sizeof(struct ebt_stp_info)),
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/bridge/netfilter/ebt_ulog.c b/net/bridge/netfilter/ebt_ulog.c
index 3b1678c..bdd8a27 100644
--- a/net/bridge/netfilter/ebt_ulog.c
+++ b/net/bridge/netfilter/ebt_ulog.c
@@ -36,6 +36,7 @@
 #include <linux/timer.h>
 #include <linux/netlink.h>
 #include <linux/netdevice.h>
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_bridge/ebt_ulog.h>
 #include <net/netfilter/nf_log.h>
@@ -260,8 +261,7 @@ static int ebt_ulog_check(const char *tablename, unsigned int hookmask,
 {
 	struct ebt_ulog_info *uloginfo = data;
 
-	if (datalen != EBT_ALIGN(sizeof(struct ebt_ulog_info)) ||
-	    uloginfo->nlgroup > 31)
+	if (uloginfo->nlgroup > 31)
 		return -EINVAL;
 
 	uloginfo->prefix[EBT_ULOG_PREFIX_LEN - 1] = '\0';
@@ -276,6 +276,7 @@ static struct ebt_watcher ulog __read_mostly = {
 	.name		= EBT_ULOG_WATCHER,
 	.watcher	= ebt_ulog,
 	.check		= ebt_ulog_check,
+	.targetsize	= XT_ALIGN(sizeof(struct ebt_ulog_info)),
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/bridge/netfilter/ebt_vlan.c b/net/bridge/netfilter/ebt_vlan.c
index ab60b0d..4dba47a 100644
--- a/net/bridge/netfilter/ebt_vlan.c
+++ b/net/bridge/netfilter/ebt_vlan.c
@@ -22,6 +22,7 @@
 #include <linux/if_vlan.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_bridge/ebt_vlan.h>
 
@@ -93,14 +94,6 @@ ebt_check_vlan(const char *tablename,
 {
 	struct ebt_vlan_info *info = data;
 
-	/* Parameters buffer overflow check */
-	if (datalen != EBT_ALIGN(sizeof(struct ebt_vlan_info))) {
-		DEBUG_MSG
-		    ("passed size %d is not eq to ebt_vlan_info (%Zd)\n",
-		     datalen, sizeof(struct ebt_vlan_info));
-		return -EINVAL;
-	}
-
 	/* Is it 802.1Q frame checked? */
 	if (e->ethproto != htons(ETH_P_8021Q)) {
 		DEBUG_MSG
@@ -173,6 +166,7 @@ static struct ebt_match filter_vlan __read_mostly = {
 	.name		= EBT_VLAN_MATCH,
 	.match		= ebt_filter_vlan,
 	.check		= ebt_check_vlan,
+	.matchsize	= XT_ALIGN(sizeof(struct ebt_vlan_info)),
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 32afff8..b04e288 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -19,6 +19,7 @@
 #include <linux/kmod.h>
 #include <linux/module.h>
 #include <linux/vmalloc.h>
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
@@ -59,8 +60,9 @@ static LIST_HEAD(ebt_targets);
 static LIST_HEAD(ebt_matches);
 static LIST_HEAD(ebt_watchers);
 
-static struct ebt_target ebt_standard_target =
-{ {NULL, NULL}, EBT_STANDARD_TARGET, NULL, NULL, NULL, NULL};
+static struct ebt_target ebt_standard_target = {
+	.name = "standard",
+};
 
 static inline int ebt_do_watcher (struct ebt_entry_watcher *w,
    const struct sk_buff *skb, unsigned int hooknr, const struct net_device *in,
@@ -350,6 +352,18 @@ ebt_check_match(struct ebt_entry_match *m, struct ebt_entry *e,
 		return -ENOENT;
 	}
 	mutex_unlock(&ebt_mutex);
+	if (XT_ALIGN(match->matchsize) != m->match_size &&
+	    match->matchsize != -1) {
+		/*
+		 * ebt_among is exempt from centralized matchsize checking
+		 * because it uses a dynamic-size data set.
+		 */
+		printk(KERN_WARNING "ebtables: %s match: "
+		       "invalid size %Zu != %u\n",
+		       match->name, XT_ALIGN(match->matchsize), m->match_size);
+		module_put(match->me);
+		return -EINVAL;
+	}
 	if (match->check &&
 	   match->check(name, hookmask, e, m->data, m->match_size) != 0) {
 		BUGPRINT("match->check failed\n");
@@ -380,6 +394,14 @@ ebt_check_watcher(struct ebt_entry_watcher *w, struct ebt_entry *e,
 		return -ENOENT;
 	}
 	mutex_unlock(&ebt_mutex);
+	if (XT_ALIGN(watcher->targetsize) != w->watcher_size) {
+		printk(KERN_WARNING "ebtables: %s watcher: "
+		       "invalid size %Zu != %u\n",
+		       watcher->name, XT_ALIGN(watcher->targetsize),
+		       w->watcher_size);
+		module_put(watcher->me);
+		return -EINVAL;
+	}
 	if (watcher->check &&
 	   watcher->check(name, hookmask, e, w->data, w->watcher_size) != 0) {
 		BUGPRINT("watcher->check failed\n");
@@ -681,9 +703,20 @@ ebt_check_entry(struct ebt_entry *e, struct ebt_table_info *newinfo,
 			ret = -EFAULT;
 			goto cleanup_watchers;
 		}
-	} else if (t->target_size > gap - sizeof(struct ebt_entry_target) ||
-	   (t->u.target->check &&
-	   t->u.target->check(name, hookmask, e, t->data, t->target_size) != 0)){
+	} else if (t->target_size > gap - sizeof(struct ebt_entry_target)) {
+		module_put(t->u.target->me);
+		ret = -EFAULT;
+		goto cleanup_watchers;
+	} else if (XT_ALIGN(target->targetsize) != t->target_size) {
+		printk(KERN_WARNING "ebtables: %s target: "
+		       "invalid size %Zu != %u\n",
+		       target->name, XT_ALIGN(target->targetsize),
+		       t->target_size);
+		module_put(t->u.target->me);
+		ret = -EINVAL;
+		goto cleanup_watchers;
+	} else if (t->u.target->check &&
+	    t->u.target->check(name, hookmask, e, t->data, t->target_size) != 0) {
 		module_put(t->u.target->me);
 		ret = -EFAULT;
 		goto cleanup_watchers;

