From: Jan Engelhardt <jengelh@medozas.de>
Subject: 04/11 [NETFILTER]: Change return types of targets/watchers for
 Ebtables extensions
Date: Wed, 10 Sep 2008 22:45:15 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0809102245060.8838@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0809102242180.8838@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:41553 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733AbYIKCpR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Sep 2008 22:45:17 -0400
In-Reply-To: <alpine.LNX.1.10.0809102242180.8838@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 2e6802e13dd11bd1a9d87a972d5c0b9507268dea
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Thu Sep 11 02:27:23 2008 -0400

[NETFILTER]: Change return types of targets/watchers for Ebtables extensions

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter_bridge/ebtables.h |    6 +++---
 net/bridge/netfilter/ebt_arpreply.c       |    2 +-
 net/bridge/netfilter/ebt_dnat.c           |    2 +-
 net/bridge/netfilter/ebt_log.c            |    3 ++-
 net/bridge/netfilter/ebt_mark.c           |    2 +-
 net/bridge/netfilter/ebt_nflog.c          |   11 ++++++-----
 net/bridge/netfilter/ebt_redirect.c       |    3 ++-
 net/bridge/netfilter/ebt_snat.c           |    2 +-
 net/bridge/netfilter/ebt_ulog.c           |    3 ++-
 9 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/include/linux/netfilter_bridge/ebtables.h b/include/linux/netfilter_bridge/ebtables.h
index f9fda2c..097432b 100644
--- a/include/linux/netfilter_bridge/ebtables.h
+++ b/include/linux/netfilter_bridge/ebtables.h
@@ -221,7 +221,7 @@ struct ebt_watcher
 {
 	struct list_head list;
 	const char name[EBT_FUNCTION_MAXNAMELEN];
-	void (*watcher)(const struct sk_buff *skb, unsigned int hooknr,
+	unsigned int (*watcher)(const struct sk_buff *skb, unsigned int hooknr,
 	   const struct net_device *in, const struct net_device *out,
 	   const void *watcherdata, unsigned int datalen);
 	bool (*check)(const char *tablename, unsigned int hookmask,
@@ -235,8 +235,8 @@ struct ebt_target
 {
 	struct list_head list;
 	const char name[EBT_FUNCTION_MAXNAMELEN];
-	/* returns one of the standard verdicts */
-	int (*target)(struct sk_buff *skb, unsigned int hooknr,
+	/* returns one of the standard EBT_* verdicts */
+	unsigned int (*target)(struct sk_buff *skb, unsigned int hooknr,
 	   const struct net_device *in, const struct net_device *out,
 	   const void *targetdata, unsigned int datalen);
 	bool (*check)(const char *tablename, unsigned int hookmask,
diff --git a/net/bridge/netfilter/ebt_arpreply.c b/net/bridge/netfilter/ebt_arpreply.c
index c298d3d..b444cf8 100644
--- a/net/bridge/netfilter/ebt_arpreply.c
+++ b/net/bridge/netfilter/ebt_arpreply.c
@@ -15,7 +15,7 @@
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_bridge/ebt_arpreply.h>
 
-static int ebt_target_reply(struct sk_buff *skb, unsigned int hooknr,
+static unsigned int ebt_target_reply(struct sk_buff *skb, unsigned int hooknr,
    const struct net_device *in, const struct net_device *out,
    const void *data, unsigned int datalen)
 {
diff --git a/net/bridge/netfilter/ebt_dnat.c b/net/bridge/netfilter/ebt_dnat.c
index 6ddea21..d58b9e3 100644
--- a/net/bridge/netfilter/ebt_dnat.c
+++ b/net/bridge/netfilter/ebt_dnat.c
@@ -14,7 +14,7 @@
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_bridge/ebt_nat.h>
 
-static int ebt_target_dnat(struct sk_buff *skb, unsigned int hooknr,
+static unsigned int ebt_target_dnat(struct sk_buff *skb, unsigned int hooknr,
    const struct net_device *in, const struct net_device *out,
    const void *data, unsigned int datalen)
 {
diff --git a/net/bridge/netfilter/ebt_log.c b/net/bridge/netfilter/ebt_log.c
index f3d6d5e..2705d7a 100644
--- a/net/bridge/netfilter/ebt_log.c
+++ b/net/bridge/netfilter/ebt_log.c
@@ -192,7 +192,7 @@ out:
 
 }
 
-static void ebt_log(const struct sk_buff *skb, unsigned int hooknr,
+static unsigned int ebt_log(const struct sk_buff *skb, unsigned int hooknr,
    const struct net_device *in, const struct net_device *out,
    const void *data, unsigned int datalen)
 {
@@ -209,6 +209,7 @@ static void ebt_log(const struct sk_buff *skb, unsigned int hooknr,
 	else
 		ebt_log_packet(NFPROTO_BRIDGE, hooknr, skb, in, out, &li,
 			       info->prefix);
+	return EBT_CONTINUE;
 }
 
 static struct ebt_watcher log =
diff --git a/net/bridge/netfilter/ebt_mark.c b/net/bridge/netfilter/ebt_mark.c
index b85c738..e4b91d8 100644
--- a/net/bridge/netfilter/ebt_mark.c
+++ b/net/bridge/netfilter/ebt_mark.c
@@ -18,7 +18,7 @@
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_bridge/ebt_mark_t.h>
 
-static int ebt_target_mark(struct sk_buff *skb, unsigned int hooknr,
+static unsigned int ebt_target_mark(struct sk_buff *skb, unsigned int hooknr,
    const struct net_device *in, const struct net_device *out,
    const void *data, unsigned int datalen)
 {
diff --git a/net/bridge/netfilter/ebt_nflog.c b/net/bridge/netfilter/ebt_nflog.c
index a6954eb..2c75023 100644
--- a/net/bridge/netfilter/ebt_nflog.c
+++ b/net/bridge/netfilter/ebt_nflog.c
@@ -19,11 +19,11 @@
 #include <linux/netfilter_bridge/ebt_nflog.h>
 #include <net/netfilter/nf_log.h>
 
-static void ebt_nflog(const struct sk_buff *skb,
-		      unsigned int hooknr,
-		      const struct net_device *in,
-		      const struct net_device *out,
-		      const void *data, unsigned int datalen)
+static unsigned int ebt_nflog(const struct sk_buff *skb,
+			      unsigned int hooknr,
+			      const struct net_device *in,
+			      const struct net_device *out,
+			      const void *data, unsigned int datalen)
 {
 	struct ebt_nflog_info *info = (struct ebt_nflog_info *)data;
 	struct nf_loginfo li;
@@ -34,6 +34,7 @@ static void ebt_nflog(const struct sk_buff *skb,
 	li.u.ulog.qthreshold = info->threshold;
 
 	nf_log_packet(PF_BRIDGE, hooknr, skb, in, out, &li, "%s", info->prefix);
+	return EBT_CONTINUE;
 }
 
 static bool ebt_nflog_check(const char *tablename,
diff --git a/net/bridge/netfilter/ebt_redirect.c b/net/bridge/netfilter/ebt_redirect.c
index d2076f4..7bf1390 100644
--- a/net/bridge/netfilter/ebt_redirect.c
+++ b/net/bridge/netfilter/ebt_redirect.c
@@ -15,7 +15,8 @@
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_bridge/ebt_redirect.h>
 
-static int ebt_target_redirect(struct sk_buff *skb, unsigned int hooknr,
+static unsigned int ebt_target_redirect(struct sk_buff *skb,
+   unsigned int hooknr,
    const struct net_device *in, const struct net_device *out,
    const void *data, unsigned int datalen)
 {
diff --git a/net/bridge/netfilter/ebt_snat.c b/net/bridge/netfilter/ebt_snat.c
index 5a5a16a..d13f05d 100644
--- a/net/bridge/netfilter/ebt_snat.c
+++ b/net/bridge/netfilter/ebt_snat.c
@@ -16,7 +16,7 @@
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_bridge/ebt_nat.h>
 
-static int ebt_target_snat(struct sk_buff *skb, unsigned int hooknr,
+static unsigned int ebt_target_snat(struct sk_buff *skb, unsigned int hooknr,
    const struct net_device *in, const struct net_device *out,
    const void *data, unsigned int datalen)
 {
diff --git a/net/bridge/netfilter/ebt_ulog.c b/net/bridge/netfilter/ebt_ulog.c
index e13a005..5f86f55 100644
--- a/net/bridge/netfilter/ebt_ulog.c
+++ b/net/bridge/netfilter/ebt_ulog.c
@@ -246,13 +246,14 @@ static void ebt_log_packet(u_int8_t pf, unsigned int hooknum,
 	ebt_ulog_packet(hooknum, skb, in, out, &loginfo, prefix);
 }
 
-static void ebt_ulog(const struct sk_buff *skb, unsigned int hooknr,
+static unsigned int ebt_ulog(const struct sk_buff *skb, unsigned int hooknr,
    const struct net_device *in, const struct net_device *out,
    const void *data, unsigned int datalen)
 {
 	const struct ebt_ulog_info *uloginfo = data;
 
 	ebt_ulog_packet(hooknr, skb, in, out, uloginfo, NULL);
+	return EBT_CONTINUE;
 }
 
 static bool ebt_ulog_check(const char *tablename, unsigned int hookmask,
