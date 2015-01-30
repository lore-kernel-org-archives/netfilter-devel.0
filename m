From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [ebtables-compat PATCH] extensions: cleanup commented code in
 ebtables-compat extensions
Date: Fri, 30 Jan 2015 12:47:16 +0100
Message-ID: <20150130114716.21184.4893.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp4.cica.es ([150.214.5.182]:41137 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761178AbbA3LrZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Jan 2015 06:47:25 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This code can be cleaned up.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 extensions/libebt_802_3.c |   29 -----------------------------
 extensions/libebt_ip.c    |   16 ----------------
 2 files changed, 45 deletions(-)

diff --git a/extensions/libebt_802_3.c b/extensions/libebt_802_3.c
index 3ca80f7..e19c21d 100644
--- a/extensions/libebt_802_3.c
+++ b/extensions/libebt_802_3.c
@@ -44,8 +44,6 @@ static void br802_3_init(struct xt_entry_match *match)
 	info->bitmask = 0;
 }
 
-/*static int parse(int c, char **argv, int argc, const struct ebt_u_entry *entry,
-   unsigned int *flags, struct ebt_entry_match **match)*/
 static int
 br802_3_parse(int c, char **argv, int invert, unsigned int *flags,
 	      const void *entry, struct xt_entry_match **match)
@@ -87,17 +85,11 @@ br802_3_parse(int c, char **argv, int invert, unsigned int *flags,
 static void
 br802_3_final_check(unsigned int flags)
 {
-	/*if (!(entry->bitmask & EBT_802_3))
-		ebt_print_error("For 802.3 DSAP/SSAP filtering the protocol "
-				"must be LENGTH");
-	*/
 	if (!flags)
 		xtables_error(PARAMETER_PROBLEM,
 			      "You must specify proper arguments");
 }
 
-/*static void print(const struct ebt_u_entry *entry,
-   const struct ebt_entry_match *match)*/
 static void br802_3_print(const void *ip, const struct xt_entry_match *match,
 			  int numeric)
 {
@@ -116,28 +108,7 @@ static void br802_3_print(const void *ip, const struct xt_entry_match *match,
 		printf("0x%.4x ", ntohs(info->type));
 	}
 }
-/*
-static int compare(const struct ebt_entry_match *m1,
-   const struct ebt_entry_match *m2)
-{
-	struct ebt_802_3_info *info1 = (struct ebt_802_3_info *)m1->data;
-	struct ebt_802_3_info *info2 = (struct ebt_802_3_info *)m2->data;
 
-	if (info1->bitmask != info2->bitmask)
-		return 0;
-	if (info1->invflags != info2->invflags)
-		return 0;
-	if (info1->bitmask & EBT_802_3_SAP) {
-		if (info1->sap != info2->sap)
-			return 0;
-	}
-	if (info1->bitmask & EBT_802_3_TYPE) {
-		if (info1->type != info2->type)
-			return 0;
-	}
-	return 1;
-}
-*/
 static struct xtables_match br802_3_match =
 {
 	.name		= "802_3",
diff --git a/extensions/libebt_ip.c b/extensions/libebt_ip.c
index ffb7ed6..a85810b 100644
--- a/extensions/libebt_ip.c
+++ b/extensions/libebt_ip.c
@@ -219,22 +219,6 @@ brip_parse(int c, char **argv, int invert, unsigned int *flags,
 
 static void brip_final_check(unsigned int flags)
 {
-/*	struct ebt_ip_info *ipinfo = (struct ebt_ip_info *)match->data;
-
-	if (entry->ethproto != ETH_P_IP || entry->invflags & EBT_IPROTO) {
-		ebt_print_error("For IP filtering the protocol must be "
-		            "specified as IPv4");
-	} else if (info->bitmask & (EBT_IP_SPORT|EBT_IP_DPORT) &&
-		(!(info->bitmask & EBT_IP_PROTO) ||
-		info->invflags & EBT_IP_PROTO ||
-		(info->protocol!=IPPROTO_TCP &&
-		 info->protocol!=IPPROTO_UDP &&
-		 info->protocol!=IPPROTO_SCTP &&
-		 info->protocol!=IPPROTO_DCCP)))
-		ebt_print_error("For port filtering the IP protocol must be "
-				"either 6 (tcp), 17 (udp), 33 (dccp) or "
-				"132 (sctp)");
-*/
 	if (!flags)
 		xtables_error(PARAMETER_PROBLEM,
 			      "You must specify proper arguments");

