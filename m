From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 08/12] nftables: add support for the "inet" family
Date: Wed,  8 Jan 2014 13:08:59 +0000
Message-ID: <1389186543-6919-9-git-send-email-kaber@trash.net>
References: <1389186543-6919-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40194 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756010AbaAHNJT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jan 2014 08:09:19 -0500
In-Reply-To: <1389186543-6919-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add support for the mixed IPv4/IPv6 "inet" family. This mainly consist
of adding the "inet" <-> NFPROTO_INET mapping in the parser and netlink
support functions.

Additionally add the definitions for the inet filter table.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/evaluate.c | 1 +
 src/parser.y   | 3 +++
 src/rule.c     | 3 +++
 src/scanner.l  | 2 ++
 4 files changed, 9 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index 257c67e..4ca3294 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1273,6 +1273,7 @@ static uint32_t str2hooknum(uint32_t family, const char *hook)
 	case NFPROTO_IPV4:
 	case NFPROTO_BRIDGE:
 	case NFPROTO_IPV6:
+	case NFPROTO_INET:
 		/* These families have overlapping values for each hook */
 		if (!strcmp(hook, "prerouting"))
 			return NF_INET_PRE_ROUTING;
diff --git a/src/parser.y b/src/parser.y
index 7778d50..1907333 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -166,6 +166,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token MAP			"map"
 %token HANDLE			"handle"
 
+%token INET			"inet"
+
 %token ADD			"add"
 %token INSERT			"insert"
 %token DELETE			"delete"
@@ -827,6 +829,7 @@ string			:	STRING
 family_spec		:	/* empty */	{ $$ = NFPROTO_IPV4; }
 			|	IP		{ $$ = NFPROTO_IPV4; }
 			|	IP6		{ $$ = NFPROTO_IPV6; }
+			|	INET		{ $$ = NFPROTO_INET; }
 			|	ARP		{ $$ = NFPROTO_ARP; }
 			|	BRIDGE		{ $$ = NFPROTO_BRIDGE; }
 			;
diff --git a/src/rule.c b/src/rule.c
index ec8b6a4..a16c2de 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -276,6 +276,8 @@ static const char *family2str(unsigned int family)
 			return "ip";
 		case NFPROTO_IPV6:
 			return "ip6";
+		case NFPROTO_INET:
+			return "inet";
 		case NFPROTO_ARP:
 			return "arp";
 		case NFPROTO_BRIDGE:
@@ -292,6 +294,7 @@ static const char *hooknum2str(unsigned int family, unsigned int hooknum)
 	case NFPROTO_IPV4:
 	case NFPROTO_BRIDGE:
 	case NFPROTO_IPV6:
+	case NFPROTO_INET:
 		switch (hooknum) {
 		case NF_INET_PRE_ROUTING:
 			return "prerouting";
diff --git a/src/scanner.l b/src/scanner.l
index 8c4f25d..f075f82 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -235,6 +235,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "goto"			{ return GOTO; }
 "return"		{ return RETURN; }
 
+"inet"			{ return INET; }
+
 "add"			{ return ADD; }
 "insert"		{ return INSERT; }
 "delete"		{ return DELETE; }
-- 
1.8.4.2

