From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 08/12] nftables: add support for the "inet" family
Date: Mon,  6 Jan 2014 17:27:23 +0000
Message-ID: <1389029247-27697-9-git-send-email-kaber@trash.net>
References: <1389029247-27697-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55577 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880AbaAFR1l (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jan 2014 12:27:41 -0500
In-Reply-To: <1389029247-27697-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add support for the mixed IPv4/IPv6 "inet" family. This mainly consist
of adding the "inet" <-> NFPROTO_INET mapping in the parser and netlink
support functions.

Additionally add the definitions for the inet filter table.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 files/nftables/inet-filter | 7 +++++++
 src/evaluate.c             | 1 +
 src/parser.y               | 3 +++
 src/rule.c                 | 3 +++
 src/scanner.l              | 2 ++
 5 files changed, 16 insertions(+)
 create mode 100644 files/nftables/inet-filter

diff --git a/files/nftables/inet-filter b/files/nftables/inet-filter
new file mode 100644
index 0000000..9f3108f
--- /dev/null
+++ b/files/nftables/inet-filter
@@ -0,0 +1,7 @@
+#! nft -f
+
+table inet filter {
+	chain input		{ type filter hook input priority 0; }
+	chain forward		{ type filter hook forward priority 0; }
+	chain output		{ type filter hook output priority 0; }
+}
diff --git a/src/evaluate.c b/src/evaluate.c
index 0f1cc4c..bf61b63 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1271,6 +1271,7 @@ static uint32_t str2hooknum(uint32_t family, const char *hook)
 	case NFPROTO_IPV4:
 	case NFPROTO_BRIDGE:
 	case NFPROTO_IPV6:
+	case NFPROTO_INET:
 		/* These families have overlapping values for each hook */
 		if (!strcmp(hook, "prerouting"))
 			return NF_INET_PRE_ROUTING;
diff --git a/src/parser.y b/src/parser.y
index b299b9d..6671804 100644
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
@@ -818,6 +820,7 @@ string			:	STRING
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
index cee6aa6..0c62729 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -236,6 +236,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "return"		{ return RETURN; }
 "queue"			{ return QUEUE; }
 
+"inet"			{ return INET; }
+
 "add"			{ return ADD; }
 "insert"		{ return INSERT; }
 "delete"		{ return DELETE; }
-- 
1.8.4.2

