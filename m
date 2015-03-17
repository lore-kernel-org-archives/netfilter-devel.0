From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 3/3] src: allow to specify the default policy for base chains
Date: Tue, 17 Mar 2015 13:13:05 +0100
Message-ID: <1426594385-24063-3-git-send-email-pablo@netfilter.org>
References: <1426594385-24063-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35487 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753359AbbCQMJY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Mar 2015 08:09:24 -0400
In-Reply-To: <1426594385-24063-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The new syntax is:

 nft add chain filter input { hook input type filter priority 0 policy accept\; }

but the previous syntax is still allowed:

 nft add chain filter input { hook input type filter priority 0\; }

this assumes default policy to accept.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
I have discovered a bug in newchain() in the nf_tables kernel API that forces
us to specify the hook when changing the policy for an existing chain, please
see follow up patch to address this problem.

 include/rule.h     |    3 +++
 src/netlink.c      |   13 ++++++++++++-
 src/parser_bison.y |   20 ++++++++++++++++++++
 src/rule.c         |   21 +++++++++++++++++----
 4 files changed, 52 insertions(+), 5 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index b0ea1ba..5161787 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -99,6 +99,7 @@ enum chain_obj_flags {
 	CHAIN_OBJ_F_BASE	= (CHAIN_OBJ_F_HOOK |
 				   CHAIN_OBJ_F_TYPE |
 				   CHAIN_OBJ_F_PRIO),
+	CHAIN_OBJ_F_POLICY	= (1 << 3),
 };
 
 /**
@@ -120,6 +121,7 @@ enum chain_flags {
  * @hookstr:	unified and human readable hook name (base chains)
  * @hooknum:	hook number (base chains)
  * @priority:	hook priority (base chains)
+ * @policy:	default chain policy (base chains)
  * @type:	chain type
  * @obj_flags:	internal object flags (indicates structure field is set)
  * @rules:	rules contained in the chain
@@ -133,6 +135,7 @@ struct chain {
 	unsigned int		hooknum;
 	int			priority;
 	const char		*type;
+	uint32_t		policy;
 	uint32_t		obj_flags;
 	struct scope		scope;
 	struct list_head	rules;
diff --git a/src/netlink.c b/src/netlink.c
index 8c37ec5..fd4a11b 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -508,6 +508,10 @@ static int netlink_add_chain_compat(struct netlink_ctx *ctx,
 		nft_chain_attr_set_str(nlc, NFT_CHAIN_ATTR_TYPE,
 				       chain->type);
 	}
+	if (chain->obj_flags & CHAIN_OBJ_F_POLICY)
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
+	if (chain->obj_flags & CHAIN_OBJ_F_POLICY)
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
index 6fa201d..c7b0c17 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1090,6 +1090,26 @@ hook_option		:	TYPE		STRING
 				$<chain>0->priority	= -$3;
 				$<chain>0->obj_flags	|= CHAIN_OBJ_F_PRIO;
 			}
+			|	POLICY		ACCEPT
+			{
+				if ($<chain>0->flags & CHAIN_OBJ_F_POLICY) {
+					erec_queue(error(&@$, "you cannot set chain policy twice"),
+						   state->msgs);
+					YYERROR;
+				}
+				$<chain>0->policy	= NF_ACCEPT;
+				$<chain>0->obj_flags	|= CHAIN_OBJ_F_POLICY;
+			}
+			|	POLICY		DROP
+			{
+				if ($<chain>0->flags & CHAIN_OBJ_F_POLICY) {
+					erec_queue(error(&@$, "you cannot set chain policy twice"),
+						   state->msgs);
+					YYERROR;
+				}
+				$<chain>0->policy	= NF_DROP;
+				$<chain>0->obj_flags	|= CHAIN_OBJ_F_POLICY;
+			}
 			;
 
 identifier		:	STRING
diff --git a/src/rule.c b/src/rule.c
index 3c92589..5224f80 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -425,15 +425,27 @@ static const char *hooknum2str(unsigned int family, unsigned int hooknum)
 	return "unknown";
 }
 
+static const char *policy2str(uint32_t policy)
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
+		printf("\t\t type %s hook %s priority %d policy %s;\n",
+		       chain->type,
 		       hooknum2str(chain->handle.family, chain->hooknum),
-		       chain->priority);
+		       chain->priority, policy2str(chain->policy));
 	}
 	list_for_each_entry(rule, &chain->rules, list) {
 		printf("\t\t");
@@ -452,9 +464,10 @@ void chain_print_plain(const struct chain *chain)
 	       chain->handle.table, chain->handle.chain);
 
 	if (chain->flags & CHAIN_F_BASECHAIN) {
-		printf(" { type %s hook %s priority %d; }", chain->type,
+		printf(" { type %s hook %s priority %d policy %s; }",
+		       chain->type,
 		       hooknum2str(chain->handle.family, chain->hooknum),
-		       chain->priority);
+		       chain->priority, policy2str(chain->policy));
 	}
 
 	printf("\n");
-- 
1.7.10.4

