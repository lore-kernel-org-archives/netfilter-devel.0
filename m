From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 12/19] [NETFILTER]: remove ARPT_{CONTINUE,RETURN} indirection
 macros
Date: Tue, 4 Mar 2008 17:34:26 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803041734130.7660@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0803040519150.7660@fbirervta.pbzchgretzou.qr>
 <47CD6296.90303@trash.net> <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:47326 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765785AbYCDQe1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:34:27 -0500
In-Reply-To: <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 7e0eee1c5180c61d764e475fcc841fd00de7dc99
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Sat Feb 9 00:45:44 2008 +0100

    [NETFILTER]: remove ARPT_{CONTINUE,RETURN} indirection macros
    
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
index 3c89d66..31598cc 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -267,7 +267,7 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 				v = ((struct arpt_standard_target *)t)->verdict;
 				if (v < 0) {
 					/* Pop from stack? */
-					if (v != ARPT_RETURN) {
+					if (v != XT_RETURN) {
 						verdict = (unsigned)(-v) - 1;
 						break;
 					}
@@ -302,7 +302,7 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 				/* Target might have changed stuff. */
 				arp = arp_hdr(skb);
 
-				if (verdict == ARPT_CONTINUE)
+				if (verdict == XT_CONTINUE)
 					e = (void *)e + e->next_offset;
 				else
 					/* Verdict */
@@ -545,7 +545,7 @@ static inline int check_entry_size_and_hooks(struct arpt_entry *e,
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
