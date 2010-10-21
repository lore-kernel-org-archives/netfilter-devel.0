From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/5] netfilter: ebtables: remove unused definitions
Date: Thu, 21 Oct 2010 17:06:04 +0200
Message-ID: <1287673569-8587-2-git-send-email-jengelh@medozas.de>
References: <1287673569-8587-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org, bdschuym@pandora.be
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:56808 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129Ab0JUPGM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Oct 2010 11:06:12 -0400
In-Reply-To: <1287673569-8587-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Userspace does not make use of the inner definitions, so we can remove
these from the header now.

v2.6.27-rc8-947-g66bff35 removed the last uses of these structs in the
kernel.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter_bridge/ebtables.h |   52 -----------------------------
 1 files changed, 0 insertions(+), 52 deletions(-)

diff --git a/include/linux/netfilter_bridge/ebtables.h b/include/linux/netfilter_bridge/ebtables.h
index 1c6f0c5..cbbb883 100644
--- a/include/linux/netfilter_bridge/ebtables.h
+++ b/include/linux/netfilter_bridge/ebtables.h
@@ -199,58 +199,6 @@ struct ebt_entry {
 #define EBT_MATCH 0
 #define EBT_NOMATCH 1
 
-struct ebt_match {
-	struct list_head list;
-	const char name[EBT_FUNCTION_MAXNAMELEN];
-	bool (*match)(const struct sk_buff *skb, const struct net_device *in,
-		const struct net_device *out, const struct xt_match *match,
-		const void *matchinfo, int offset, unsigned int protoff,
-		bool *hotdrop);
-	bool (*checkentry)(const char *table, const void *entry,
-		const struct xt_match *match, void *matchinfo,
-		unsigned int hook_mask);
-	void (*destroy)(const struct xt_match *match, void *matchinfo);
-	unsigned int matchsize;
-	u_int8_t revision;
-	u_int8_t family;
-	struct module *me;
-};
-
-struct ebt_watcher {
-	struct list_head list;
-	const char name[EBT_FUNCTION_MAXNAMELEN];
-	unsigned int (*target)(struct sk_buff *skb,
-		const struct net_device *in, const struct net_device *out,
-		unsigned int hook_num, const struct xt_target *target,
-		const void *targinfo);
-	bool (*checkentry)(const char *table, const void *entry,
-		const struct xt_target *target, void *targinfo,
-		unsigned int hook_mask);
-	void (*destroy)(const struct xt_target *target, void *targinfo);
-	unsigned int targetsize;
-	u_int8_t revision;
-	u_int8_t family;
-	struct module *me;
-};
-
-struct ebt_target {
-	struct list_head list;
-	const char name[EBT_FUNCTION_MAXNAMELEN];
-	/* returns one of the standard EBT_* verdicts */
-	unsigned int (*target)(struct sk_buff *skb,
-		const struct net_device *in, const struct net_device *out,
-		unsigned int hook_num, const struct xt_target *target,
-		const void *targinfo);
-	bool (*checkentry)(const char *table, const void *entry,
-		const struct xt_target *target, void *targinfo,
-		unsigned int hook_mask);
-	void (*destroy)(const struct xt_target *target, void *targinfo);
-	unsigned int targetsize;
-	u_int8_t revision;
-	u_int8_t family;
-	struct module *me;
-};
-
 /* used for jumping from and into user defined chains (udc) */
 struct ebt_chainstack {
 	struct ebt_entries *chaininfo; /* pointer to chain data */
-- 
1.7.1

