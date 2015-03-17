From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft v2] src: allow to specify the default policy for base chains
Date: Tue, 17 Mar 2015 16:54:14 +0100
Message-ID: <1426607654-5341-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47814 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754095AbbCQPub (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Mar 2015 11:50:31 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The new syntax is:

 nft add chain filter input { hook input type filter priority 0\; policy accept\; }

but the previous syntax is still allowed:

 nft add chain filter input { hook input type filter priority 0\; }

this assumes default policy to accept.

If the base chain already exists, you can update the policy via:

 nft add chain filter input { policy drop\; }

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: modify syntax to implement policy as an independent statement

 doc/nft.xml        |    1 +
 include/rule.h     |    2 ++
 src/netlink.c      |   13 ++++++++++++-
 src/parser_bison.y |   21 +++++++++++++++++++++
 src/rule.c         |   23 +++++++++++++++++++----
 5 files changed, 55 insertions(+), 5 deletions(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index 696a4c3..8d79016 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -456,6 +456,7 @@ filter input iif $int_ifs accept
 				<arg choice="req"><replaceable>chain</replaceable></arg>
 				<arg choice="req"><replaceable>hook</replaceable></arg>
 				<arg choice="req"><replaceable>priority</replaceable></arg>
+				<arg choice="req"><replaceable>policy</replaceable></arg>
 			</cmdsynopsis>
 			<cmdsynopsis>
 				<group choice="req">
diff --git a/include/rule.h b/include/rule.h
index 90836bc..97959f7 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -111,6 +111,7 @@ enum chain_flags {
  * @hookstr:	unified and human readable hook name (base chains)
  * @hooknum:	hook number (base chains)
  * @priority:	hook priority (base chains)
+ * @policy:	default chain policy (base chains)
  * @type:	chain type
  * @rules:	rules contained in the chain
  */
@@ -122,6 +123,7 @@ struct chain {
 	const char		*hookstr;
 	unsigned int		hooknum;
 	int			priority;
+	int			policy;
 	const char		*type;
 	struct scope		scope;
 	struct list_head	rules;
diff --git a/src/netlink.c b/src/netlink.c
index 8c37ec5..2d1fb79 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -508,6 +508,10 @@ static int netlink_add_chain_compat(struct netlink_ctx *ctx,
 		nft_chain_attr_set_str(nlc, NFT_CHAIN_ATTR_TYPE,
 				       chain->type);
 	}
+	if (chain->policy != -1)
+		nft_chain_attr_set_u32(nlc, NFT_CHAIN_ATTR_POLICY,
+				       chain->policy);
+
 	netlink_dump_chain(nlc);
 	err = mnl_nft_chain_add(nf_sock, nlc, excl ? NLM_F_EXCL : 0);
 	nft_chain_free(nlc);
@@ -535,6 +539,10 @@ static int netlink_add_chain_batch(struct netlink_ctx *ctx,
 		nft_chain_attr_set_str(nlc, NFT_CHAIN_ATTR_TYPE,
 				       chain->type);
 	}
+	if (chain->policy != -1)
+		nft_chain_attr_set_u32(nlc, NFT_CHAIN_ATTR_POLICY,
+				       chain->policy);
+
 	netlink_dump_chain(nlc);
 	err = mnl_nft_chain_batch_add(nlc, excl ? NLM_F_EXCL : 0,
 				      ctx->seqnum);
@@ -665,13 +673,16 @@ static struct chain *netlink_delinearize_chain(struct netlink_ctx *ctx,
 
 	if (nft_chain_attr_is_set(nlc, NFT_CHAIN_ATTR_HOOKNUM) &&
 	    nft_chain_attr_is_set(nlc, NFT_CHAIN_ATTR_PRIO) &&
-	    nft_chain_attr_is_set(nlc, NFT_CHAIN_ATTR_TYPE)) {
+	    nft_chain_attr_is_set(nlc, NFT_CHAIN_ATTR_TYPE) &&
+	    nft_chain_attr_is_set(nlc, NFT_CHAIN_ATTR_POLICY)) {
 		chain->hooknum       =
 			nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_HOOKNUM);
 		chain->priority      =
 			nft_chain_attr_get_s32(nlc, NFT_CHAIN_ATTR_PRIO);
 		chain->type          =
 			xstrdup(nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_TYPE));
+		chain->policy          =
+			nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_POLICY);
 		chain->flags        |= CHAIN_F_BASECHAIN;
 	}
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 6fc834d..ea3ff52 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -913,6 +913,7 @@ chain_block		:	/* empty */	{ $$ = $<chain>-1; }
 			|	chain_block	common_block
 	     		|	chain_block	stmt_seperator
 			|	chain_block	hook_spec	stmt_seperator
+			|	chain_block	policy_spec	stmt_seperator
 			|	chain_block	rule		stmt_seperator
 			{
 				list_add_tail(&$2->list, &$1->rules);
@@ -1070,6 +1071,26 @@ hook_spec		:	TYPE		STRING		HOOK		STRING		PRIORITY	NUM
 			}
 			;
 
+policy_spec		:	POLICY		ACCEPT
+			{
+				if ($<chain>0->policy != -1) {
+					erec_queue(error(&@$, "you cannot set chain policy twice"),
+						   state->msgs);
+					YYERROR;
+				}
+				$<chain>0->policy	= NF_ACCEPT;
+			}
+			|	POLICY		DROP
+			{
+				if ($<chain>0->policy != -1) {
+					erec_queue(error(&@$, "you cannot set chain policy twice"),
+						   state->msgs);
+					YYERROR;
+				}
+				$<chain>0->policy	= NF_DROP;
+			}
+			;
+
 identifier		:	STRING
 			;
 
diff --git a/src/rule.c b/src/rule.c
index 3c92589..d11a0c0 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -336,6 +336,8 @@ struct chain *chain_alloc(const char *name)
 	init_list_head(&chain->scope.symbols);
 	if (name != NULL)
 		chain->handle.chain = xstrdup(name);
+
+	chain->policy = -1;
 	return chain;
 }
 
@@ -425,15 +427,27 @@ static const char *hooknum2str(unsigned int family, unsigned int hooknum)
 	return "unknown";
 }
 
+static const char *chain_policy2str(uint32_t policy)
+{
+	switch (policy) {
+	case NF_DROP:
+		return "drop";
+	case NF_ACCEPT:
+		return "accept";
+	}
+	return "unknown";
+}
+
 static void chain_print(const struct chain *chain)
 {
 	struct rule *rule;
 
 	printf("\tchain %s {\n", chain->handle.chain);
 	if (chain->flags & CHAIN_F_BASECHAIN) {
-		printf("\t\t type %s hook %s priority %d;\n", chain->type,
+		printf("\t\t type %s hook %s priority %d; policy %s;\n",
+		       chain->type,
 		       hooknum2str(chain->handle.family, chain->hooknum),
-		       chain->priority);
+		       chain->priority, chain_policy2str(chain->policy));
 	}
 	list_for_each_entry(rule, &chain->rules, list) {
 		printf("\t\t");
@@ -452,9 +466,10 @@ void chain_print_plain(const struct chain *chain)
 	       chain->handle.table, chain->handle.chain);
 
 	if (chain->flags & CHAIN_F_BASECHAIN) {
-		printf(" { type %s hook %s priority %d; }", chain->type,
+		printf(" { type %s hook %s priority %d; policy %s; }",
+		       chain->type,
 		       hooknum2str(chain->handle.family, chain->hooknum),
-		       chain->priority);
+		       chain->priority, chain_policy2str(chain->policy));
 	}
 
 	printf("\n");
-- 
1.7.10.4

