Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE0AB7347B
	for <netfilter-devel@vger.kernel.org>; Mon,  2 Sep 2024 23:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725320956; cv=none; b=Od1Y37bEdxVI7F8fXGiCXqBDNgLeI2LhMtXpoX8hkX3b55Jd7YhQ8zfPlwP3oprGqEt6b1f+pJ+j4XQcP/18xcz05hayLqN+wkBo4H3W1ubfS1CA77qoIKp8QIL3kzvHQ02RDh8AwZr2Yvr/8mtY78foyWlvXoy/ADbEf4p8IA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725320956; c=relaxed/simple;
	bh=50zvSem93RTY/XtZLfAIbqV5WSLD3z4ctmqcfkptTQk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tVEz2NpjXtp9wySbPzzbV+OCxk3WGldibO7/eiFzIX6Pb1f8K6p/jX2ozf1apyK01pn7zwbWXgsBdLwYjx1qLqATRrH/NTArUhwd+to3BWfPeQh7KBwqmWJ0dqpMXL+r6b2W8cHCYszRCb0uAuThc2CQkxw9x3t8BVItQ7y64fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: phil@nwl.cc,
	fw@strlen.de
Subject: [PATCH nft,v2] src: support for timeout never in elements
Date: Tue,  3 Sep 2024 01:49:09 +0200
Message-Id: <20240902234909.323657-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow to specify elements that never expire in sets with global
timeout.

    set x {
        typeof ip saddr
        timeout 1m
        elements = { 1.1.1.1 timeout never,
                     2.2.2.2,
                     3.3.3.3 timeout 2m }
    }

in this example above:

 - 1.1.1.1 is a permanent element
 - 2.2.2.2 expires after 1 minute (uses default set timeout)
 - 3.3.3.3 expires after 2 minutes (uses specified timeout override)

Use internal NFT_NEVER_TIMEOUT marker to differenciate between use
default set timeout and timeout never if "timeout N" is used in set
declaration.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: keep marker internal to simplify timeout never handling.
    Revamp on top of kernel updates.

 include/nftables.h |  3 +++
 src/expression.c   |  9 +++++++--
 src/netlink.c      | 17 +++++++++++++----
 src/parser_bison.y | 27 ++++++++++++++++++++++++---
 4 files changed, 47 insertions(+), 9 deletions(-)

diff --git a/include/nftables.h b/include/nftables.h
index 4b7c335928da..c25deb3676dd 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -241,4 +241,7 @@ int nft_optimize(struct nft_ctx *nft, struct list_head *cmds);
 
 #define __NFT_OUTPUT_NOTSUPP	UINT_MAX
 
+/* internal marker, not used by the kernel. */
+#define NFT_NEVER_TIMEOUT	UINT64_MAX
+
 #endif /* NFTABLES_NFTABLES_H */
diff --git a/src/expression.c b/src/expression.c
index 992f51064051..c0cb7f22eb73 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1314,9 +1314,14 @@ static void set_elem_expr_print(const struct expr *expr,
 	}
 	if (expr->timeout) {
 		nft_print(octx, " timeout ");
-		time_print(expr->timeout, octx);
+		if (expr->timeout == NFT_NEVER_TIMEOUT)
+			nft_print(octx, "never");
+		else
+			time_print(expr->timeout, octx);
 	}
-	if (!nft_output_stateless(octx) && expr->expiration) {
+	if (!nft_output_stateless(octx) &&
+	    expr->timeout != NFT_NEVER_TIMEOUT &&
+	    expr->expiration) {
 		nft_print(octx, " expires ");
 		time_print(expr->expiration, octx);
 	}
diff --git a/src/netlink.c b/src/netlink.c
index dea95ffa0704..25ee3419772b 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -155,9 +155,14 @@ struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
 		break;
 	}
 
-	if (elem->timeout)
-		nftnl_set_elem_set_u64(nlse, NFTNL_SET_ELEM_TIMEOUT,
-				       elem->timeout);
+	if (elem->timeout) {
+		uint64_t timeout = elem->timeout;
+
+		if (elem->timeout == NFT_NEVER_TIMEOUT)
+			timeout = 0;
+
+		nftnl_set_elem_set_u64(nlse, NFTNL_SET_ELEM_TIMEOUT, timeout);
+	}
 	if (elem->expiration)
 		nftnl_set_elem_set_u64(nlse, NFTNL_SET_ELEM_EXPIRATION,
 				       elem->expiration);
@@ -1417,8 +1422,12 @@ key_end:
 	expr = set_elem_expr_alloc(&netlink_location, key);
 	expr->flags |= EXPR_F_KERNEL;
 
-	if (nftnl_set_elem_is_set(nlse, NFTNL_SET_ELEM_TIMEOUT))
+	if (nftnl_set_elem_is_set(nlse, NFTNL_SET_ELEM_TIMEOUT)) {
 		expr->timeout	 = nftnl_set_elem_get_u64(nlse, NFTNL_SET_ELEM_TIMEOUT);
+		if (expr->timeout == 0)
+			expr->timeout	 = NFT_NEVER_TIMEOUT;
+	}
+
 	if (nftnl_set_elem_is_set(nlse, NFTNL_SET_ELEM_EXPIRATION))
 		expr->expiration = nftnl_set_elem_get_u64(nlse, NFTNL_SET_ELEM_EXPIRATION);
 	if (nftnl_set_elem_is_set(nlse, NFTNL_SET_ELEM_USERDATA))
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 8fbb98bdcd69..e2936d10efe4 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -695,7 +695,7 @@ int nft_lex(void *, void *, void *);
 %type <string>			identifier type_identifier string comment_spec
 %destructor { free_const($$); }	identifier type_identifier string comment_spec
 
-%type <val>			time_spec time_spec_or_num_s quota_used
+%type <val>			time_spec time_spec_or_num_s set_elem_time_spec quota_used
 
 %type <expr>			data_type_expr data_type_atom_expr
 %destructor { expr_free($$); }  data_type_expr data_type_atom_expr
@@ -4545,7 +4545,28 @@ set_elem_options	:	set_elem_option
 			|	set_elem_options	set_elem_option
 			;
 
-set_elem_option		:	TIMEOUT			time_spec
+set_elem_time_spec	:	STRING
+			{
+				struct error_record *erec;
+				uint64_t res;
+
+				if (!strcmp("never", $1)) {
+					free_const($1);
+					$$ = NFT_NEVER_TIMEOUT;
+					break;
+				}
+
+				erec = time_parse(&@1, $1, &res);
+				free_const($1);
+				if (erec != NULL) {
+					erec_queue(erec, state->msgs);
+					YYERROR;
+				}
+				$$ = res;
+			}
+			;
+
+set_elem_option		:	TIMEOUT		time_spec
 			{
 				$<expr>0->timeout = $2;
 			}
@@ -4655,7 +4676,7 @@ set_elem_stmt		:	COUNTER	close_scope_counter
 			}
 			;
 
-set_elem_expr_option	:	TIMEOUT			time_spec
+set_elem_expr_option	:	TIMEOUT		set_elem_time_spec
 			{
 				$<expr>0->timeout = $2;
 			}
-- 
2.30.2

