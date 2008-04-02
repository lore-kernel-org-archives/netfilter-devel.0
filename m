From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 06/24] [NETFILTER]: remove ARPT_{CONTINUE,RETURN} indirection macros
Date: Wed,  2 Apr 2008 13:11:48 +0200
Message-ID: <c3311a6c3c9a63f913b4c634eaa0e57a3a5bf6ef.1207134547.git.jengelh@computergmbh.de>
References: <1207134726-28689-1-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:43153 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755625AbYDBLMJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Apr 2008 07:12:09 -0400
In-Reply-To: <1207134726-28689-1-git-send-email-jengelh@computergmbh.de>
In-Reply-To: <455b3b0ee249d17dff621933f163b8d5e377eb8f.1207134547.git.jengelh@computergmbh.de>
References: <455b3b0ee249d17dff621933f163b8d5e377eb8f.1207134547.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 include/linux/netfilter_arp/arp_tables.h |    6 ------
 net/ipv4/netfilter/arp_tables.c          |    6 +++---
 net/ipv4/netfilter/arpt_mangle.c         |    2 +-
 3 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
index 493dcd2..2cdcc0c 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -125,12 +125,6 @@ struct arpt_entry
 #define ARPT_SO_GET_REVISION_TARGET	(ARPT_BASE_CTL + 3)
 #define ARPT_SO_GET_MAX			(ARPT_SO_GET_REVISION_TARGET)
 
-/* CONTINUE verdict for targets */
-#define ARPT_CONTINUE XT_CONTINUE
-
-/* For standard target */
-#define ARPT_RETURN XT_RETURN
-
 /* The argument to ARPT_SO_GET_INFO */
 struct arpt_getinfo
 {
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index fe4616b..056f0ff 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -264,7 +264,7 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 				v = ((struct arpt_standard_target *)t)->verdict;
 				if (v < 0) {
 					/* Pop from stack? */
-					if (v != ARPT_RETURN) {
+					if (v != XT_RETURN) {
 						verdict = (unsigned)(-v) - 1;
 						break;
 					}
@@ -299,7 +299,7 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 				/* Target might have changed stuff. */
 				arp = arp_hdr(skb);
 
-				if (verdict == ARPT_CONTINUE)
+				if (verdict == XT_CONTINUE)
 					e = (void *)e + e->next_offset;
 				else
 					/* Verdict */
@@ -542,7 +542,7 @@ static inline int check_entry_size_and_hooks(struct arpt_entry *e,
 	}
 
 	/* FIXME: underflows must be unconditional, standard verdicts
-	   < 0 (not ARPT_RETURN). --RR */
+	   < 0 (not XT_RETURN). --RR */
 
 	/* Clear counters and comefrom */
 	e->counters = ((struct xt_counters) { 0, 0 });
diff --git a/net/ipv4/netfilter/arpt_mangle.c b/net/ipv4/netfilter/arpt_mangle.c
index a385959..6cccaab 100644
--- a/net/ipv4/netfilter/arpt_mangle.c
+++ b/net/ipv4/netfilter/arpt_mangle.c
@@ -68,7 +68,7 @@ checkentry(const char *tablename, const void *e, const struct xt_target *target,
 		return false;
 
 	if (mangle->target != NF_DROP && mangle->target != NF_ACCEPT &&
-	   mangle->target != ARPT_CONTINUE)
+	   mangle->target != XT_CONTINUE)
 		return false;
 	return true;
 }
-- 
1.5.4.4

