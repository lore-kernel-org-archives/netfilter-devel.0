From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/5] libip6t_policy: remove redundant functions
Date: Mon,  1 Jun 2009 12:06:29 +0200
Message-ID: <1243850793-9526-2-git-send-email-jengelh@medozas.de>
References: <1243850793-9526-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53161 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863AbZFAKGd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Jun 2009 06:06:33 -0400
In-Reply-To: <1243850793-9526-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_policy.c |   48 +++++++-----------------------------------
 1 files changed, 8 insertions(+), 40 deletions(-)

diff --git a/extensions/libip6t_policy.c b/extensions/libip6t_policy.c
index 5106c28..697ac24 100644
--- a/extensions/libip6t_policy.c
+++ b/extensions/libip6t_policy.c
@@ -91,38 +91,6 @@ static const struct option policy_opts[] =
 	{ .name = NULL }
 };
 
-/* FIXME - Duplicated code from ip6tables.c */
-/* Duplicated to stop too many changes in other files .... */
-static void
-in6addrcpy(struct in6_addr *dst, struct in6_addr *src)
-{
-        memcpy(dst, src, sizeof(struct in6_addr));
-        /* dst->s6_addr = src->s6_addr; */
-}
-
-static char *
-addr_to_numeric(const struct in6_addr *addrp)
-{
-        /* 0000:0000:0000:0000:0000:000.000.000.000
-	 * 0000:0000:0000:0000:0000:0000:0000:0000 */
-        static char buf[50+1];
-        return (char *)inet_ntop(AF_INET6, addrp, buf, sizeof(buf));
-}
-
-static char *
-mask_to_numeric(const struct in6_addr *addrp)
-{
-        static char buf[50+2];
-        int l = ipv6_prefix_length(addrp);
-        if (l == -1) {
-		strcpy(buf, "/");
-		strcat(buf, addr_to_numeric(addrp));
-		return buf;
-	}
-	sprintf(buf, "/%d", l);
-	return buf;
-}
-
 static int parse_direction(char *s)
 {
 	if (strcmp(s, "in") == 0)
@@ -224,8 +192,8 @@ static int policy_parse(int c, char **argv, int invert, unsigned int *flags,
 
 		e->match.saddr = 1;
 		e->invert.saddr = invert;
-		in6addrcpy(&e->saddr.a6, addr);
-		in6addrcpy(&e->smask.a6, &mask);
+		memcpy(&e->saddr.a6, addr, sizeof(*addr));
+		memcpy(&e->smask.a6, &mask, sizeof(mask));
                 break;
 	case '7':
 		if (e->match.daddr)
@@ -239,8 +207,8 @@ static int policy_parse(int c, char **argv, int invert, unsigned int *flags,
 
 		e->match.daddr = 1;
 		e->invert.daddr = invert;
-		in6addrcpy(&e->daddr.a6, addr);
-		in6addrcpy(&e->dmask.a6, &mask);
+		memcpy(&e->daddr.a6, addr, sizeof(*addr));
+		memcpy(&e->dmask.a6, &mask, sizeof(mask));
 		break;
 	case '8':
 		if (e->match.proto)
@@ -387,14 +355,14 @@ static void print_entry(char *prefix, const struct ip6t_policy_elem *e,
 	if (e->match.daddr) {
 		PRINT_INVERT(e->invert.daddr);
 		printf("%stunnel-dst %s%s ", prefix,
-		       addr_to_numeric((struct in6_addr *)&e->daddr),
-		       mask_to_numeric((struct in6_addr *)&e->dmask));
+		       xtables_ip6addr_to_numeric(&e->daddr.a6),
+		       xtables_ip6mask_to_numeric(&e->dmask.a6));
 	}
 	if (e->match.saddr) {
 		PRINT_INVERT(e->invert.saddr);
 		printf("%stunnel-src %s%s ", prefix,
-		       addr_to_numeric((struct in6_addr *)&e->saddr),
-		       mask_to_numeric((struct in6_addr *)&e->smask));
+		       xtables_ip6addr_to_numeric(&e->saddr.a6),
+		       xtables_ip6mask_to_numeric(&e->smask.a6));
 	}
 }
 
-- 
1.6.3.1

