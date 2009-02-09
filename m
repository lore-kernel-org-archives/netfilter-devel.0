From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 01/16] src: remove redundant returns at end of void-returning functions
Date: Mon,  9 Feb 2009 18:34:45 +0100
Message-ID: <1234200900-5964-2-git-send-email-jengelh@medozas.de>
References: <1234200900-5964-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51461 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754911AbZBIRfC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:35:02 -0500
In-Reply-To: <1234200900-5964-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_ipv6header.c |    4 ----
 extensions/libxt_DSCP.c         |    1 -
 extensions/libxt_NFQUEUE.c      |    1 -
 extensions/libxt_dscp.c         |    1 -
 extensions/libxt_u32.c          |    2 --
 iptables-xml.c                  |    2 --
 6 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/extensions/libip6t_ipv6header.c b/extensions/libip6t_ipv6header.c
index 3006124..1fc9b7e 100644
--- a/extensions/libip6t_ipv6header.c
+++ b/extensions/libip6t_ipv6header.c
@@ -262,8 +262,6 @@ static void ipv6header_print(const void *ip,
 
 	if (info->modeflag)
 		printf("soft ");
-
-	return;
 }
 
 static void ipv6header_save(const void *ip, const struct xt_entry_match *match)
@@ -276,8 +274,6 @@ static void ipv6header_save(const void *ip, const struct xt_entry_match *match)
 	printf(" ");
 	if (info->modeflag)
 		printf("--soft ");
-
-	return;
 }
 
 static struct xtables_match ipv6header_mt6_reg = {
diff --git a/extensions/libxt_DSCP.c b/extensions/libxt_DSCP.c
index 6625db1..c9b0327 100644
--- a/extensions/libxt_DSCP.c
+++ b/extensions/libxt_DSCP.c
@@ -57,7 +57,6 @@ parse_dscp(const char *s, struct xt_DSCP_info *dinfo)
 			   "DSCP `%d` out of range\n", dscp);
 
     	dinfo->dscp = (u_int8_t )dscp;
-    	return;
 }
 
 
diff --git a/extensions/libxt_NFQUEUE.c b/extensions/libxt_NFQUEUE.c
index 7daed18..5880785 100644
--- a/extensions/libxt_NFQUEUE.c
+++ b/extensions/libxt_NFQUEUE.c
@@ -38,7 +38,6 @@ parse_num(const char *s, struct xt_NFQ_info *tinfo)
 			   "Invalid queue number `%s'\n", s);
 
     	tinfo->queuenum = num & 0xffff;
-    	return;
 }
 
 static int
diff --git a/extensions/libxt_dscp.c b/extensions/libxt_dscp.c
index eefb186..bb794f5 100644
--- a/extensions/libxt_dscp.c
+++ b/extensions/libxt_dscp.c
@@ -57,7 +57,6 @@ parse_dscp(const char *s, struct xt_dscp_info *dinfo)
 			   "DSCP `%d` out of range\n", dscp);
 
     	dinfo->dscp = (u_int8_t )dscp;
-    	return;
 }
 
 
diff --git a/extensions/libxt_u32.c b/extensions/libxt_u32.c
index 256d15f..f0bb61a 100644
--- a/extensions/libxt_u32.c
+++ b/extensions/libxt_u32.c
@@ -254,7 +254,6 @@ static void u32_print(const void *ip, const struct xt_entry_match *match,
 	if (data->invert)
 		printf("! ");
 	u32_dump(data);
-	return;
 }
 
 static void u32_save(const void *ip, const struct xt_entry_match *match)
@@ -264,7 +263,6 @@ static void u32_save(const void *ip, const struct xt_entry_match *match)
 		printf("! ");
 	printf("--u32 ");
 	u32_dump(data);
-	return;
 }
 
 static struct xtables_match u32_match = {
diff --git a/iptables-xml.c b/iptables-xml.c
index 8aee5c2..6481b8e 100644
--- a/iptables-xml.c
+++ b/iptables-xml.c
@@ -531,8 +531,6 @@ do_rule_part(char *leveltag1, char *leveltag2, int part, int argc,
 	if (level1)
 		printf("%s", leveli1);
 	CLOSE_LEVEL(1);
-
-	return;
 }
 
 static int
-- 
1.6.1.2

