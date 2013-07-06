From: Eric Leblond <eric@regit.org>
Subject: [nftables PATCH] Add support for insertion inside rule list
Date: Sat,  6 Jul 2013 17:33:57 +0200
Message-ID: <1373124837-6857-1-git-send-email-eric@regit.org>
References: <1373124677-6626-1-git-send-email-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:59771 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab3GFPeS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 6 Jul 2013 11:34:18 -0400
In-Reply-To: <1373124677-6626-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds support for "insert before" and "add after"
rule operation.
The rule handle syntax has an new optional after/before field
which take a handle as argument.
Here is two examples:
  nft add rule filter output after 5  ip daddr 1.2.3.1 drop
  nft insert rule filter output before 5  ip daddr 1.2.3.1 drop

Signed-off-by: Eric Leblond <eric@regit.org>
---
 include/rule.h            |  2 ++
 src/netlink.c             |  2 ++
 src/netlink_delinearize.c |  2 ++
 src/parser.y              | 22 ++++++++++++++++++++--
 src/rule.c                |  2 ++
 src/scanner.l             |  3 +++
 6 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index e0debe3..2577cff 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -13,6 +13,7 @@
  * @chain:	chain name (chains and rules only)
  * @set:	set name (sets only)
  * @handle:	rule handle (rules only)
+ * @position:	rule position (rules only)
  */
 struct handle {
 	uint32_t		family;
@@ -20,6 +21,7 @@ struct handle {
 	const char		*chain;
 	const char		*set;
 	uint64_t		handle;
+	uint64_t		position;
 };
 
 extern void handle_merge(struct handle *dst, const struct handle *src);
diff --git a/src/netlink.c b/src/netlink.c
index 2a7bdb5..5129cac 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -105,6 +105,8 @@ struct nft_rule *alloc_nft_rule(const struct handle *h)
 		nft_rule_attr_set_str(nlr, NFT_RULE_ATTR_CHAIN, h->chain);
 	if (h->handle)
 		nft_rule_attr_set_u64(nlr, NFT_RULE_ATTR_HANDLE, h->handle);
+	if (h->position)
+		nft_rule_attr_set_u64(nlr, NFT_RULE_ATTR_POSITION, h->position);
 	return nlr;
 }
 
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 9348913..f92e83f 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -796,6 +796,8 @@ struct rule *netlink_delinearize_rule(struct netlink_ctx *ctx,
 	h.table  = xstrdup(nft_rule_attr_get_str(nlr, NFT_RULE_ATTR_TABLE));
 	h.chain  = xstrdup(nft_rule_attr_get_str(nlr, NFT_RULE_ATTR_CHAIN));
 	h.handle = nft_rule_attr_get_u64(nlr, NFT_RULE_ATTR_HANDLE);
+	if (nft_rule_attr_is_set(nlr, NFT_RULE_ATTR_POSITION))
+		h.position = nft_rule_attr_get_u64(nlr, NFT_RULE_ATTR_POSITION);
 
 	pctx->rule = rule_alloc(&internal_location, &h);
 	pctx->table = table_lookup(&h);
diff --git a/src/parser.y b/src/parser.y
index 2923b59..d52bd97 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -326,6 +326,9 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token SNAT			"snat"
 %token DNAT			"dnat"
 
+%token BEFORE			"before"
+%token AFTER			"after"
+
 %type <string>			identifier string
 %destructor { xfree($$); }	identifier string
 
@@ -339,7 +342,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %destructor { handle_free(&$$); } table_spec tables_spec chain_spec chain_identifier ruleid_spec
 %type <handle>			set_spec set_identifier
 %destructor { handle_free(&$$); } set_spec set_identifier
-%type <val>			handle_spec family_spec
+%type <val>			handle_spec family_spec position_spec
 
 %type <table>			table_block_alloc table_block
 %destructor { table_free($$); }	table_block_alloc
@@ -842,10 +845,25 @@ handle_spec		:	/* empty */
 			}
 			;
 
-ruleid_spec		:	chain_spec	handle_spec
+position_spec		:	/* empty */
+			{
+				$$ = 0;
+			}
+			|	BEFORE		NUM
+			{
+				$$ = $2;
+			}
+			|	AFTER		NUM
+			{
+				$$ = $2;
+			}
+			;
+
+ruleid_spec		:	chain_spec	handle_spec	position_spec
 			{
 				$$		= $1;
 				$$.handle	= $2;
+				$$.position	= $3;
 			}
 			;
 
diff --git a/src/rule.c b/src/rule.c
index 5a894cc..8368624 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -41,6 +41,8 @@ void handle_merge(struct handle *dst, const struct handle *src)
 		dst->set = xstrdup(src->set);
 	if (dst->handle == 0)
 		dst->handle = src->handle;
+	if (dst->position == 0)
+		dst->position = src->position;
 }
 
 struct set *set_alloc(const struct location *loc)
diff --git a/src/scanner.l b/src/scanner.l
index fe7b86c..519e1fc 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -249,6 +249,9 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "flush"			{ return FLUSH; }
 "rename"		{ return RENAME; }
 
+"before"		{ return BEFORE; }
+"after"			{ return AFTER; }
+
 "counter"		{ return COUNTER; }
 "packets"		{ return PACKETS; }
 "bytes"			{ return BYTES; }
-- 
1.8.3.2

