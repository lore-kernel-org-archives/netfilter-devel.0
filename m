From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables PATCH] Add support for insertion inside rule list
Date: Fri, 19 Jul 2013 14:28:33 +0200
Message-ID: <20130719122833.GA30497@localhost>
References: <1373124677-6626-1-git-send-email-eric@regit.org>
 <1373124837-6857-1-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="PNTmBPCT7hxwcZjr"
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44371 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759898Ab3GSM2j (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Jul 2013 08:28:39 -0400
Content-Disposition: inline
In-Reply-To: <1373124837-6857-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Eric,

On Sat, Jul 06, 2013 at 05:33:57PM +0200, Eric Leblond wrote:
> This patch adds support for "insert before" and "add after"
> rule operation.
> The rule handle syntax has an new optional after/before field
> which take a handle as argument.
> Here is two examples:
>   nft add rule filter output after 5  ip daddr 1.2.3.1 drop
>   nft insert rule filter output before 5  ip daddr 1.2.3.1 drop

While testing this new feature, I noticed that the parser was
accepting this:

nft add rule filter output after 5  ip daddr 1.2.3.1 drop
nft insert rule filter output after 5  ip daddr 1.2.3.1 drop

Note that 'add' and 'insert' become semantically equivalent, which
seems inconsistent to me.

While fixing it using the 'before' and 'after', I noticed that 'add'
and 'insert' already tell us where to put the new rule, so 'after' and
'before' were repeating again what we want to do. I have reworked this
patch to change this initial syntax:

nft add rule filter output position 5  ip daddr 1.2.3.1 drop
nft insert rule filter output position 5  ip daddr 1.2.3.1 drop

We can support the after and before, but that would imply some extra
evaluation after the parsing that would make the patch bigger. So I
prefered to go the simpler solution.

Please, find the new patch attached. Thanks.

--PNTmBPCT7hxwcZjr
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-src-Add-support-for-insertion-inside-rule-list.patch"

>From f8afcae4af949c1f8c71fc4dbbffdbddbedb7adf Mon Sep 17 00:00:00 2001
From: Eric Leblond <eric@regit.org>
Date: Sat, 6 Jul 2013 17:33:57 +0200
Subject: [PATCH] src: Add support for insertion inside rule list

This patch adds support to insert and to add rule using a rule
handle as reference. The rule handle syntax has an new optional
position field which take a handle as argument.

Two examples:

  nft add rule filter output position 5 ip daddr 1.2.3.1 drop
  nft insert rule filter output position 5 ip daddr 1.2.3.1 drop

Signed-off-by: Eric Leblond <eric@regit.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h            |    2 ++
 src/mnl.c                 |    2 +-
 src/netlink.c             |    2 ++
 src/netlink_delinearize.c |    2 ++
 src/parser.y              |   17 +++++++++++++++--
 src/rule.c                |    2 ++
 src/scanner.l             |    2 ++
 7 files changed, 26 insertions(+), 3 deletions(-)

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
diff --git a/src/mnl.c b/src/mnl.c
index a58f7ea..928d692 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -61,7 +61,7 @@ int mnl_nft_rule_add(struct mnl_socket *nf_sock, struct nft_rule *nlr,
 
 	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE,
 			nft_rule_attr_get_u32(nlr, NFT_RULE_ATTR_FAMILY),
-			NLM_F_APPEND|NLM_F_ACK|NLM_F_CREATE, seq);
+			flags|NLM_F_ACK|NLM_F_CREATE, seq);
 	nft_rule_nlmsg_build_payload(nlh, nlr);
 
 	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
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
index 2923b59..91981e9 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -326,6 +326,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token SNAT			"snat"
 %token DNAT			"dnat"
 
+%token POSITION			"position"
+
 %type <string>			identifier string
 %destructor { xfree($$); }	identifier string
 
@@ -339,7 +341,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %destructor { handle_free(&$$); } table_spec tables_spec chain_spec chain_identifier ruleid_spec
 %type <handle>			set_spec set_identifier
 %destructor { handle_free(&$$); } set_spec set_identifier
-%type <val>			handle_spec family_spec
+%type <val>			handle_spec family_spec position_spec
 
 %type <table>			table_block_alloc table_block
 %destructor { table_free($$); }	table_block_alloc
@@ -842,10 +844,21 @@ handle_spec		:	/* empty */
 			}
 			;
 
-ruleid_spec		:	chain_spec	handle_spec
+position_spec		:	/* empty */
+			{
+				$$ = 0;
+			}
+			|	POSITION	NUM
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
index fe7b86c..7946e94 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -249,6 +249,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "flush"			{ return FLUSH; }
 "rename"		{ return RENAME; }
 
+"position"		{ return POSITION; }
+
 "counter"		{ return COUNTER; }
 "packets"		{ return PACKETS; }
 "bytes"			{ return BYTES; }
-- 
1.7.10.4


--PNTmBPCT7hxwcZjr--
