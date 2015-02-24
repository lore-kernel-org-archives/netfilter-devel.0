From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/2] src: complete meta priority support
Date: Tue, 24 Feb 2015 19:05:29 +0100
Message-ID: <1424801130-29052-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35908 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752445AbbBXSCI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Feb 2015 13:02:08 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds the missing bits to scan and parse the meta priority
string. The output code to list it has been also reworked.

To match the skbuff priority you can use:

 nft add rule filter forward meta priority :ffff
 nft add rule filter forward meta priority ffff:
 nft add rule filter forward meta priority abcd:1234

and to set it, you can use:

 nft add rule filter forward meta priority set abcd:1234

flex performs longest prefix matching when scanning patterns so there is
not conflict with IPv6 addresses.

There's still a possible clash with:

	nft add rule filter input tcp dport vmap { 25:accept, 28:drop }

where "25:acce" and "28:d" are interpreted as a meta priority.

I think it's reasonable to tell people that they have to separate the
key and the data that represent the element tuple with a whitespace
separator between the colon, at least until we find a better way to
handle this.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
@Patrick: You proposed an alternative to this time ago:

http://patchwork.ozlabs.org/patch/320066/

but after applying a similar patch here, that seem to break many other
stuff according to the nft-test.py regression tests.

 src/meta.c                  |   33 +++++++++++++-------------------
 src/scanner.l               |   44 +++++++++++++++++++++++++++++++++++++++++++
 tests/regression/any/meta.t |   21 ++++++++++++---------
 tests/regression/inet/tcp.t |    3 +--
 4 files changed, 70 insertions(+), 31 deletions(-)

diff --git a/src/meta.c b/src/meta.c
index ad57228..5f93ade 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -10,6 +10,7 @@
  * Development of this code funded by Astaro AG (http://www.astaro.com/)
  */
 
+#include <errno.h>
 #include <stddef.h>
 #include <stdlib.h>
 #include <stdio.h>
@@ -71,9 +72,11 @@ static void tchandle_type_print(const struct expr *expr)
 
 	switch(handle) {
 	case TC_H_ROOT:
-		printf("root\n");
+		printf("root");
+		break;
 	case TC_H_UNSPEC:
-		printf("none\n");
+		printf("none");
+		break;
 	default:
 		if (TC_H_MAJ(handle) == 0)
 			printf(":%04x", TC_H_MIN(handle));
@@ -92,40 +95,30 @@ static struct error_record *tchandle_type_parse(const struct expr *sym,
 {
 	uint32_t handle;
 
-	if (strcmp(sym->identifier, "root") == 0)
+	if (strcmp(sym->identifier, "root") == 0) {
 		handle = TC_H_ROOT;
-	else if (strcmp(sym->identifier, "none") == 0)
+	} else if (strcmp(sym->identifier, "none") == 0) {
 		handle = TC_H_UNSPEC;
-	else if (sym->identifier[0] == ':') {
-		if (sscanf(sym->identifier, ":%04x", &handle) < 0)
-			goto err;
-	} else if (sym->identifier[strlen(sym->identifier)-1] == ':') {
-		if (sscanf(sym->identifier, "%04x:", &handle) < 0)
-			goto err;
-
-		handle <<= 16;
 	} else {
-		uint32_t min, max;
-
-		if (sscanf(sym->identifier, "%04x:%04x", &min, &max) < 0)
+		errno = 0;
+		handle = strtoul(sym->identifier, NULL, 0);
+		if (errno != 0)
 			goto err;
-
-		handle = max << 16 | min;
 	}
+
 	*res = constant_expr_alloc(&sym->location, sym->dtype,
 				   BYTEORDER_HOST_ENDIAN,
 				   sizeof(handle) * BITS_PER_BYTE, &handle);
 	return NULL;
 err:
-	return error(&sym->location, "Could not parse %s",
-		     sym->dtype->desc);
+	return error(&sym->location, "Could not parse %s", sym->dtype->desc);
 }
 
 static const struct datatype tchandle_type = {
 	.type		= TYPE_TC_HANDLE,
 	.name		= "tc_handle",
 	.desc		= "TC handle",
-	.byteorder	= BYTEORDER_BIG_ENDIAN,
+	.byteorder	= BYTEORDER_HOST_ENDIAN,
 	.size		= 4 * BITS_PER_BYTE,
 	.basetype	= &integer_type,
 	.print		= tchandle_type_print,
diff --git a/src/scanner.l b/src/scanner.l
index 73c4f8b..0120c9f 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -167,6 +167,11 @@ macaddr		(([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2})
 ip4addr		(([[:digit:]]{1,3}"."){3}([[:digit:]]{1,3}))
 ip6addr		({v680}|{v67}|{v66}|{v65}|{v64}|{v63}|{v62}|{v61}|{v60})
 
+prio1		({hexdigit}{1,4}:)
+prio2		(:{hexdigit}{1,4})
+prio3		({hexdigit}{1,4}:{hexdigit}{1,4})
+
+priority	({prio1}|{prio2}|{prio3})
 addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
 %option prefix="nft_"
@@ -477,6 +482,45 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 				return NUM;
 			}
 
+{priority}		{
+				char *colon;
+				char *str = xstrdup(yytext);
+				uint16_t prio = 0;
+
+				yylval->val = 0;
+
+				if (yytext[0] == ':') {
+					colon = str;
+				} else {
+					colon = strchr(str, ':');
+					if (colon == NULL)
+						return STRING;
+
+					errno = 0;
+					prio = strtoull(str, NULL, 16);
+					if (errno != 0) {
+						xfree(str);
+						yylval->string = xstrdup(yytext);
+						return STRING;
+					}
+					yylval->val = (prio << 16);
+					if (str[strlen(str) - 1] == ':')
+						return NUM;
+				}
+
+				*colon = '\0';
+				errno = 0;
+				prio = strtoull(colon + 1, NULL, 16);
+				if (errno != 0) {
+					xfree(str);
+					yylval->string = xstrdup(yytext);
+					return STRING;
+				}
+				xfree(str);
+				yylval->val |= prio;
+				return NUM;
+			}
+
 {quotedstring}		{
 				yytext[yyleng - 1] = '\0';
 				yylval->string = xstrdup(yytext + 1);
diff --git a/tests/regression/any/meta.t b/tests/regression/any/meta.t
index f11fd00..c472832 100644
--- a/tests/regression/any/meta.t
+++ b/tests/regression/any/meta.t
@@ -34,15 +34,18 @@ meta l4proto { 33, 55, 67, 88};ok;meta l4proto { 33, 55, 67, 88}
 meta l4proto { 33-55};ok
 - meta l4proto != { 33-55};ok
 
-- meta priority :aabb;ok
-- meta priority bcad:dadc;ok
-- meta priority aabb:;ok
-- meta priority != :aabb;ok
-- meta priority != bcad:dadc;ok
-- meta priority != aabb:;ok
-- meta priority bcad:dada-bcad:dadc;ok
-- meta priority != bcad:dada-bcad:dadc;ok
-- meta priority {bcad:dada, bcad:dadc, aaaa:bbbb};ok
+meta priority root;ok
+meta priority none;ok
+meta priority :aabb;ok
+meta priority bcad:dadc;ok
+meta priority aabb:;ok
+meta priority != :aabb;ok
+meta priority != bcad:dadc;ok
+meta priority != aabb:;ok
+meta priority bcad:dada-bcad:dadc;ok
+meta priority != bcad:dada-bcad:dadc;ok
+meta priority {bcad:dada, bcad:dadc, aaaa:bbbb};ok
+meta priority set cafe:beef;ok
 - meta priority != {bcad:dada, bcad:dadc, aaaa:bbbb};ok
 
 meta mark 0x4;ok;mark 0x00000004
diff --git a/tests/regression/inet/tcp.t b/tests/regression/inet/tcp.t
index f72ec52..c1d6b42 100644
--- a/tests/regression/inet/tcp.t
+++ b/tests/regression/inet/tcp.t
@@ -13,7 +13,6 @@ tcp dport { 33-55};ok
 - tcp dport != { 33-55};ok
 tcp dport {telnet, http, https} accept;ok;tcp dport { 443, 23, 80} accept
 tcp dport vmap { 22 : accept, 23 : drop };ok
-tcp dport vmap { 25:accept, 28:drop };ok
 tcp dport { 22, 53, 80, 110 };ok
 - tcp dport != { 22, 53, 80, 110 };ok
 # BUG: invalid expression type set
@@ -27,7 +26,7 @@ tcp sport { 33, 55, 67, 88};ok
 - tcp sport != { 33, 55, 67, 88};ok
 tcp sport { 33-55};ok
 - tcp sport != { 33-55};ok
-tcp sport vmap { 25:accept, 28:drop };ok
+tcp sport vmap { 25 : accept, 28 : drop };ok
 
 tcp sport 8080 drop;ok
 tcp sport 1024 tcp dport 22;ok
-- 
1.7.10.4

