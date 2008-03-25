From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: commit 720350a38b1dbd43c907d5d81decd6edd6725d81
Date: Tue, 25 Mar 2008 19:06:11 +0100
Message-ID: <1206468391-368-9-git-send-email-jengelh@computergmbh.de>
References: <alpine.LNX.1.10.0803251903230.31276@fbirervta.pbzchgretzou.qr>
 <1206468391-368-1-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-2-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-3-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-4-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-5-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-6-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-7-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-8-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52542 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759170AbYCYSGf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 14:06:35 -0400
In-Reply-To: <1206468391-368-8-git-send-email-jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

    [NETFILTER]: remove ARPT_{STANDARD,ERROR}_TARGET indirection macro
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 include/linux/netfilter_arp/arp_tables.h |    9 ++-------
 net/ipv4/netfilter/arp_tables.c          |    8 ++++----
 2 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
index 4aed7c4..0e6b5e1 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -203,11 +203,6 @@ struct arpt_get_entries
 	struct arpt_entry entrytable[0];
 };
 
-/* Standard return verdict, or do jump. */
-#define ARPT_STANDARD_TARGET XT_STANDARD_TARGET
-/* Error verdict. */
-#define ARPT_ERROR_TARGET XT_ERROR_TARGET
-
 /* Helper functions */
 static __inline__ struct arpt_entry_target *arpt_get_target(struct arpt_entry *e)
 {
@@ -251,7 +246,7 @@ struct arpt_error
 #define ARPT_STANDARD_INIT(__verdict)					       \
 {									       \
 	.entry		= ARPT_ENTRY_INIT(sizeof(struct arpt_standard)),       \
-	.target		= XT_TARGET_INIT(ARPT_STANDARD_TARGET,		       \
+	.target		= XT_TARGET_INIT(XT_STANDARD_TARGET,		       \
 					 sizeof(struct arpt_standard_target)), \
 	.target.verdict	= -(__verdict) - 1,				       \
 }
@@ -259,7 +254,7 @@ struct arpt_error
 #define ARPT_ERROR_INIT							       \
 {									       \
 	.entry		= ARPT_ENTRY_INIT(sizeof(struct arpt_error)),	       \
-	.target		= XT_TARGET_INIT(ARPT_ERROR_TARGET,		       \
+	.target		= XT_TARGET_INIT(XT_ERROR_TARGET,		       \
 					 sizeof(struct arpt_error_target)),    \
 	.target.errorname = "ERROR",					       \
 }
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 67db115..514f91b 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -367,7 +367,7 @@ static int mark_source_chains(struct xt_table_info *newinfo,
 			/* Unconditional return/END. */
 			if ((e->target_offset == sizeof(struct arpt_entry)
 			    && (strcmp(t->target.u.user.name,
-				       ARPT_STANDARD_TARGET) == 0)
+				       XT_STANDARD_TARGET) == 0)
 			    && t->verdict < 0
 			    && unconditional(&e->arp)) || visited) {
 				unsigned int oldpos, size;
@@ -406,7 +406,7 @@ static int mark_source_chains(struct xt_table_info *newinfo,
 				int newpos = t->verdict;
 
 				if (strcmp(t->target.u.user.name,
-					   ARPT_STANDARD_TARGET) == 0
+					   XT_STANDARD_TARGET) == 0
 				    && newpos >= 0) {
 					if (newpos > newinfo->size -
 						sizeof(struct arpt_entry)) {
@@ -1785,7 +1785,7 @@ void arpt_unregister_table(struct xt_table *table)
 
 /* The built-in targets: standard (NULL) and error. */
 static struct xt_target arpt_standard_target __read_mostly = {
-	.name		= ARPT_STANDARD_TARGET,
+	.name		= XT_STANDARD_TARGET,
 	.targetsize	= sizeof(int),
 	.family		= NF_ARP,
 #ifdef CONFIG_COMPAT
@@ -1796,7 +1796,7 @@ static struct xt_target arpt_standard_target __read_mostly = {
 };
 
 static struct xt_target arpt_error_target __read_mostly = {
-	.name		= ARPT_ERROR_TARGET,
+	.name		= XT_ERROR_TARGET,
 	.target		= arpt_error,
 	.targetsize	= ARPT_FUNCTION_MAXNAMELEN,
 	.family		= NF_ARP,
