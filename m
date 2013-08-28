From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [nftables tool PATCH 2/5] src: Wrap netfilter hooks around human readable strings
Date: Wed, 28 Aug 2013 11:33:08 +0300
Message-ID: <1377678791-7616-3-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1377678791-7616-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:21466 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441Ab3H1IdT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Aug 2013 04:33:19 -0400
In-Reply-To: <1377678791-7616-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This allows to use unique, human readable, hook names for the command
line and let the user being unaware of the complex netfilter's hook
names and there difference depending on the netfilter family.

So:
add chain foo bar { type route hook NF_INET_LOCAL_IN 0; }

becomes:
add chain foo bar { type route hook input 0; }

It also fixes then the difference in hook values between families.
I.e.: ARP family has different values for input, forward and output
compared to IPv4, IPv6 or BRIDGE.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 include/rule.h |  22 ++++++++++++
 src/netlink.c  | 105 ++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 src/parser.y   |  21 +++++++++---
 src/rule.c     |  28 ++++++++++-----
 src/scanner.l  |   6 ----
 5 files changed, 159 insertions(+), 23 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index 4f68431..97bace5 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -82,6 +82,28 @@ extern void table_free(struct table *table);
 extern void table_add_hash(struct table *table);
 extern struct table *table_lookup(const struct handle *h);
 
+/*
+ * enum hook_numbers - family agnostic hook identifiers
+ *
+ * @HOOK_PREROUTING:	prerouting hook (NF_INET_LOCAL_PRE_ROUTING in ipv4)
+ * @HOOK_INPUT:		input hook (NF_INET_LOCAL_IN in ipv4)
+ * @HOOK_FORWARD:	forward hook (NF_INET_LOCAL_FORWARD in ipv4)
+ * @HOOK_OUTPUT:	output hook (NF_INET_LOCAL_OUT in ipv4)
+ * @HOOK_POSTROUTING:	postrouting hook (NF_INET_LOCAL_POST_ROUTING in ipv4)
+ * @HOOK_NUMHOOKS:	maximum number of hooks
+ */
+enum hook_number {
+	HOOK_PREROUTING		= 0,
+	HOOK_INPUT		= 1,
+	HOOK_FORWARD		= 2,
+	HOOK_POSTROUTING	= 3,
+	HOOK_OUTPUT		= 4,
+	HOOK_NUMHOOKS		= 5,
+};
+
+extern unsigned int str2hooknum(const char *hook_name);
+extern const char *hooknum2str(unsigned int hooknum);
+
 /**
  * enum chain_flags - chain flags
  *
diff --git a/src/netlink.c b/src/netlink.c
index 7f99416..1eb6e52 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -20,6 +20,10 @@
 #include <libnftables/set.h>
 #include <linux/netfilter/nf_tables.h>
 
+#include <netinet/in.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter_arp.h>
+
 #include <nftables.h>
 #include <netlink.h>
 #include <mnl.h>
@@ -449,16 +453,68 @@ void netlink_dump_chain(struct nft_chain *nlc)
 #endif
 }
 
+static uint32_t hooknum2nfhook(uint32_t family, enum hook_number hook_num)
+{
+	switch (family)
+	{
+	case NFPROTO_IPV4:
+	case NFPROTO_BRIDGE:
+	case NFPROTO_IPV6:
+		/* All these 3 families share actually
+		 * the same values for each hook */
+		switch (hook_num) {
+		case HOOK_PREROUTING:
+			return NF_INET_PRE_ROUTING;
+		case HOOK_INPUT:
+			return NF_INET_LOCAL_IN;
+		case HOOK_FORWARD:
+			return NF_INET_FORWARD;
+		case HOOK_OUTPUT:
+			return NF_INET_LOCAL_OUT;
+		case HOOK_POSTROUTING:
+			return NF_INET_POST_ROUTING;
+		default:
+			break;
+		}
+		break;
+	case NFPROTO_ARP:
+		switch (hook_num) {
+		case HOOK_INPUT:
+			return NF_ARP_IN;
+		case HOOK_FORWARD:
+			return NF_ARP_FORWARD;
+		case HOOK_OUTPUT:
+			return NF_ARP_OUT;
+		default:
+			break;
+		}
+	default:
+		break;
+	}
+
+	return NF_INET_NUMHOOKS;
+}
+
 int netlink_add_chain(struct netlink_ctx *ctx, const struct handle *h,
 		      const struct location *loc, const struct chain *chain)
 {
 	struct nft_chain *nlc;
-	int err;
+	int err = -1;
 
 	nlc = alloc_nft_chain(h);
 	if (chain != NULL && chain->flags & CHAIN_F_BASECHAIN) {
+		uint32_t hooknum = hooknum2nfhook(h->family, chain->hooknum);
+
+		if (hooknum == NF_INET_NUMHOOKS) {
+			netlink_io_error(ctx, loc, "No such hook \"%s\""
+					 " for current family",
+					 hooknum2str(chain->hooknum));
+			errno = EINVAL;
+			goto error;
+		}
+
 		nft_chain_attr_set_u32(nlc, NFT_CHAIN_ATTR_HOOKNUM,
-				       chain->hooknum);
+				       hooknum);
 		nft_chain_attr_set_u32(nlc, NFT_CHAIN_ATTR_PRIO,
 				       chain->priority);
 		nft_chain_attr_set_str(nlc, NFT_CHAIN_ATTR_TYPE,
@@ -466,6 +522,7 @@ int netlink_add_chain(struct netlink_ctx *ctx, const struct handle *h,
 	}
 	netlink_dump_chain(nlc);
 	err = mnl_nft_chain_add(nf_sock, nlc, NLM_F_EXCL);
+error:
 	nft_chain_free(nlc);
 
 	if (err < 0)
@@ -509,6 +566,46 @@ int netlink_delete_chain(struct netlink_ctx *ctx, const struct handle *h,
 	return err;
 }
 
+static uint32_t nfhook2hooknum(uint32_t family, uint32_t nf_hook)
+{
+	switch (family) {
+	case NFPROTO_IPV4:
+	case NFPROTO_BRIDGE:
+	case NFPROTO_IPV6:
+		switch (nf_hook) {
+		case NF_INET_PRE_ROUTING:
+			return HOOK_PREROUTING;
+		case NF_INET_LOCAL_IN:
+			return HOOK_INPUT;
+		case NF_INET_FORWARD:
+			return HOOK_FORWARD;
+		case NF_INET_LOCAL_OUT:
+			return HOOK_OUTPUT;
+		case NF_INET_POST_ROUTING:
+			return HOOK_POSTROUTING;
+		default:
+			break;
+		}
+		break;
+	case NFPROTO_ARP:
+		switch (nf_hook) {
+		case NF_ARP_IN:
+			return HOOK_INPUT;
+		case NF_ARP_FORWARD:
+			return HOOK_FORWARD;
+		case NF_ARP_OUT:
+			return HOOK_OUTPUT;
+		default:
+			break;
+		}
+		break;
+	default:
+		break;
+	}
+
+	return -1;
+}
+
 static int list_chain_cb(struct nft_chain *nlc, void *arg)
 {
 	struct netlink_ctx *ctx = arg;
@@ -530,8 +627,8 @@ static int list_chain_cb(struct nft_chain *nlc, void *arg)
 	if (nft_chain_attr_is_set(nlc, NFT_CHAIN_ATTR_HOOKNUM) &&
 	    nft_chain_attr_is_set(nlc, NFT_CHAIN_ATTR_PRIO) &&
 	    nft_chain_attr_is_set(nlc, NFT_CHAIN_ATTR_TYPE)) {
-		chain->hooknum       =
-			nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_HOOKNUM);
+		chain->hooknum       = nfhook2hooknum(h->family,
+			nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_HOOKNUM));
 		chain->priority      =
 			nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_PRIO);
 		chain->type          =
diff --git a/src/parser.y b/src/parser.y
index f0eb8e3..4df7d44 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -155,7 +155,6 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token DEFINE			"define"
 
 %token HOOK			"hook"
-%token <val> HOOKNUM		"hooknum"
 %token TABLE			"table"
 %token TABLES			"tables"
 %token CHAIN			"chain"
@@ -766,19 +765,31 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 			}
 			;
 
-hook_spec		:	TYPE		STRING		HOOK		HOOKNUM		NUM
+hook_spec		:	TYPE		STRING		HOOK		STRING		NUM
 			{
 				$<chain>0->type		= $2;
-				$<chain>0->hooknum	= $4;
+				$<chain>0->hooknum	= str2hooknum($4);
 				$<chain>0->priority	= $5;
 				$<chain>0->flags	|= CHAIN_F_BASECHAIN;
+
+				if ($<chain>0->hooknum == HOOK_NUMHOOKS) {
+					erec_queue(error(&@4, "unknown hook %s", $4),
+						   state->msgs);
+					YYERROR;	
+				}
 			}
-			|	TYPE		STRING		HOOK		HOOKNUM		DASH	NUM
+			|	TYPE		STRING		HOOK		STRING		DASH	NUM
 			{
 				$<chain>0->type		= $2;
-				$<chain>0->hooknum	= $4;
+				$<chain>0->hooknum	= str2hooknum($4);
 				$<chain>0->priority	= -$6;
 				$<chain>0->flags	|= CHAIN_F_BASECHAIN;
+
+				if ($<chain>0->hooknum == HOOK_NUMHOOKS) {
+					erec_queue(error(&@4, "unknown hook %s", $4),
+						   state->msgs);
+					YYERROR;	
+				}
 			}
 			;
 
diff --git a/src/rule.c b/src/rule.c
index 73054ba..23b64a7 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -228,17 +228,29 @@ struct chain *chain_lookup(const struct table *table, const struct handle *h)
 	return NULL;
 }
 
-static const char *hooknum2str_array[NF_INET_NUMHOOKS] = {
-	[NF_INET_PRE_ROUTING]	= "NF_INET_PRE_ROUTING",
-	[NF_INET_LOCAL_IN]	= "NF_INET_LOCAL_IN",
-	[NF_INET_FORWARD]	= "NF_INET_FORWARD",
-	[NF_INET_LOCAL_OUT]	= "NF_INET_LOCAL_OUT",
-	[NF_INET_POST_ROUTING]	= "NF_INET_POST_ROUTING",
+static const char *hooknum2str_array[HOOK_NUMHOOKS] = {
+	[HOOK_PREROUTING]	= "prerouting",
+	[HOOK_INPUT]		= "input",
+	[HOOK_FORWARD]		= "forward",
+	[HOOK_OUTPUT]		= "output",
+	[HOOK_POSTROUTING]	= "postrouting",
 };
 
-static const char *hooknum2str(unsigned int hooknum)
+unsigned int str2hooknum(const char *hook_name)
 {
-	if (hooknum >= NF_INET_NUMHOOKS)
+	int i;
+
+	for (i = 0; i < HOOK_NUMHOOKS; i++) {
+		if (!strcmp(hook_name, hooknum2str_array[i]))
+			return i;
+	}
+
+	return HOOK_NUMHOOKS;
+}
+
+const char *hooknum2str(unsigned int hooknum)
+{
+	if (hooknum >= HOOK_NUMHOOKS)
 		return "UNKNOWN";
 
 	return hooknum2str_array[hooknum];
diff --git a/src/scanner.l b/src/scanner.l
index 59e0aac..cee6aa6 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -212,12 +212,6 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "=>"			{ return ARROW; }
 "vmap"			{ return VMAP; }
 
-"NF_INET_PRE_ROUTING"	{ yylval->val = NF_INET_PRE_ROUTING;	return HOOKNUM; }
-"NF_INET_LOCAL_IN"	{ yylval->val = NF_INET_LOCAL_IN;	return HOOKNUM; }
-"NF_INET_FORWARD"	{ yylval->val = NF_INET_FORWARD;	return HOOKNUM; }
-"NF_INET_LOCAL_OUT"	{ yylval->val = NF_INET_LOCAL_OUT;	return HOOKNUM; }
-"NF_INET_POST_ROUTING"	{ yylval->val = NF_INET_POST_ROUTING;	return HOOKNUM; }
-
 "include"		{ return INCLUDE; }
 "define"		{ return DEFINE; }
 
-- 
1.8.3.2

