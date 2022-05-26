Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2803EC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 May 2022 13:43:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbiEZNnP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 May 2022 09:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237973AbiEZNnO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 May 2022 09:43:14 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C9BCE02
        for <netfilter-devel@vger.kernel.org>; Thu, 26 May 2022 06:43:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1653572592; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=T9RUUzFJFI9oQ9Zb2e5ZEM3abPQ5tsYnX/2CT8Z6/ga1sp+mKDnvNl07GwJNXKvKu7k9VNK4UpwlqLsmRUUhWuVrlMq9CWe1MfBO4ftlnB/yjuLWG4z7/T9Y5M1k9ODBa2rBMEbnIb87RkHpnF2SSSBdbhQ3Sd483cpRTqH7kfg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1653572592; h=Content-Type:Content-Transfer-Encoding:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=cIrRrGn3pAMknnS21/mDxM0xfEuuU4oDPEhIE2ftXXA=; 
        b=DY57jDq///j1fuiQKqxo9yUPyKT7AvqinqWT/FgQ1rdUk9NZyyHcBxcO1fV12LllILAFv7MbU2p70BdK513/NOKbBS8COpDjvLlv3H1XkYj2xUsuOfDLod1I1rahxV070shylg3K+foCPoKOR/L0mRFyclbOHOdknn/1Ky9xrDE=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=chandergovind.org;
        spf=pass  smtp.mailfrom=mail@chandergovind.org;
        dmarc=pass header.from=<mail@chandergovind.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1653572592;
        s=zoho; d=chandergovind.org; i=mail@chandergovind.org;
        h=Message-ID:Date:Date:MIME-Version:To:To:From:From:Subject:Subject:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
        bh=cIrRrGn3pAMknnS21/mDxM0xfEuuU4oDPEhIE2ftXXA=;
        b=VmOrThEfW8zCrEgJo/9DvUI4+O1FnA5yGJ2TObquqQaNKTPtjLvrhGMKplmhwbFh
        ugYAlEgF33ZOJbkKABI5dIC3+d6OmGIAaulgS+b6whbNLnOLDd2VqBDqA7cEktaXwEh
        366yRWnDjZCVaJS8WQ+Wp417+wge+NOpq+GbzZHg=
Received: from [192.168.1.38] (103.195.203.136 [103.195.203.136]) by mx.zohomail.com
        with SMTPS id 1653572588588860.6372909093885; Thu, 26 May 2022 06:43:08 -0700 (PDT)
Message-ID: <c8585f82-3cec-401a-534a-ee8d1252cdfd@chandergovind.org>
Date:   Thu, 26 May 2022 19:11:23 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     netfilter-devel@vger.kernel.org
From:   Chander Govindarajan <mail@chandergovind.org>
Subject: [PATCH] nft: allow deletion of rule by full statement form
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Currently, rules can only be deleted by handle. You cannot use the
full rule statement to find and delete rules. This is a documented
limitation and a pressing one, since people are used to the iptables
style of deletion.

Allow deletion of rules by specifying the full rule

The way this works is as follows:
1. Add a new parser rule to match the full rule specification
2. Update the cache mechanism to load the full cache when trying to
delete rule with the new syntax.
3. When deleting, check for presence of the rule. If present, loop
over the existing rules in the chain looking for a match.
4. A match is done using the following approach:
    1. First compare if the number of statments match.
    2. Check if the type of the statements match between the supplied
    rule and the present rule.
    3. Finally, convert the rules into the stateless string
    output form and compare.
5. If we have a match, use the handle id from the match.

Now, there are some small improvements and cleanups needed as
documented in line. I am sure that there are other conventions that I
have broken. However, the approach itself seems to work fine.

PS: This is all a single logical change, not sure if I should have
used a patchset here.

PPS: Right now, this expects comments to match if any.

Signed-off-by: ChanderG <mail@chandergovind.org>
---
  src/cache.c        | 15 ++++++++--
  src/mnl.c          | 73 ++++++++++++++++++++++++++++++++++++++++++++++
  src/parser_bison.y |  4 +++
  3 files changed, 90 insertions(+), 2 deletions(-)

diff --git a/src/cache.c b/src/cache.c
index fd8df884..5a80b324 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -74,12 +74,23 @@ static unsigned int evaluate_cache_add(struct cmd 
*cmd, unsigned int flags)
  	return flags;
  }

-static unsigned int evaluate_cache_del(struct cmd *cmd, unsigned int flags)
+static unsigned int evaluate_cache_del(struct cmd *cmd,
+				       unsigned int flags,
+				       struct nft_cache_filter *filter)
  {
  	switch (cmd->obj) {
  	case CMD_OBJ_ELEMENTS:
  		flags |= NFT_CACHE_SETELEM_MAYBE;
  		break;
+	case CMD_OBJ_RULE:
+		// only for delete rule with full rule specified
+		if (filter && cmd->handle.chain.name && cmd->rule) {
+			filter->list.family = cmd->handle.family;
+			filter->list.table = cmd->handle.table.name;
+			filter->list.chain = cmd->handle.chain.name;
+			flags |= NFT_CACHE_FULL;
+		}
+		break;
  	default:
  		break;
  	}
@@ -290,7 +301,7 @@ unsigned int nft_cache_evaluate(struct nft_ctx *nft, 
struct list_head *cmds,
  				 NFT_CACHE_FLOWTABLE |
  				 NFT_CACHE_OBJECT;

-			flags = evaluate_cache_del(cmd, flags);
+			flags = evaluate_cache_del(cmd, flags, filter);
  			break;
  		case CMD_GET:
  			flags = evaluate_cache_get(cmd, flags);
diff --git a/src/mnl.c b/src/mnl.c
index 7dd77be1..c611c89f 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -590,6 +590,49 @@ int mnl_nft_rule_replace(struct netlink_ctx *ctx, 
struct cmd *cmd)
  	return 0;
  }

+bool __compare_rules(struct rule *rule1, struct rule *rule2) {
+	if (rule1->num_stmts != rule2->num_stmts)
+		return false;
+
+	// check for type match for all stmts
+
+	struct stmt *stmt1, *stmt2;
+	stmt1 = &rule1->stmts;
+	stmt2 = &rule2->stmts;
+	int count = rule1->num_stmts;
+
+	while(count) {
+		stmt1 = list_entry(stmt1->list.next, typeof(*stmt1), list);
+		stmt2 = list_entry(stmt2->list.next, typeof(*stmt2), list);
+
+		if (stmt1->ops->type != stmt2->ops->type)
+			return false;
+
+		count--;
+	}
+
+	// now check the full string match
+
+	// TODO: convert to malloc - but how large?
+	char buf1[500], buf2[500];
+	struct output_ctx octx1, octx2;
+	unsigned int flags = 0;
+	flags |= NFT_CTX_OUTPUT_STATELESS;
+
+	octx1.output_fp = fmemopen(buf1, 500, "w");
+	octx1.flags = flags;
+	octx2.output_fp = fmemopen(buf2, 500, "w");
+	octx2.flags = flags;
+
+	rule_print(rule1, &octx1);
+	rule_print(rule2, &octx2);
+
+	if (!strcmp(buf1, buf2))
+		return true;
+
+	return false;
+}
+
  int mnl_nft_rule_del(struct netlink_ctx *ctx, struct cmd *cmd)
  {
  	struct handle *h = &cmd->handle;
@@ -617,6 +660,36 @@ int mnl_nft_rule_del(struct netlink_ctx *ctx, 
struct cmd *cmd)
  		cmd_add_loc(cmd, nlh->nlmsg_len, &h->handle.location);
  		mnl_attr_put_u64(nlh, NFTA_RULE_HANDLE, htobe64(h->handle.id));
  	}
+	if (cmd->rule) {
+		// TODO: short-circuit if no stmts in rule
+		struct table *table;
+		struct chain *chain;
+		struct rule *rule;
+		bool matched = false;
+
+		// TODO: anything special to be done for unspecified family?
+		table = table_cache_find(&ctx->nft->cache.table_cache,
+					 h->table.name,
+					 cmd->handle.family);
+
+		chain = chain_cache_find(table, h->chain.name);
+
+		list_for_each_entry(rule, &chain->rules, list) {
+			if (__compare_rules(rule, cmd->rule)) {
+				cmd_add_loc(cmd, nlh->nlmsg_len, &rule->handle.handle.location);
+				mnl_attr_put_u64(nlh, NFTA_RULE_HANDLE, 
htobe64(rule->handle.handle.id));
+				matched = true;
+				break;
+			}
+		}
+
+		if (!matched) {
+			errno = ENOENT;
+			nftnl_rule_free(nlr);
+			return -1;
+		}
+	}
+	// TODO: handle situation when both are not present, if needed

  	nftnl_rule_nlmsg_build_payload(nlh, nlr);
  	nftnl_rule_free(nlr);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index ca5c488c..f911f7f0 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1322,6 +1322,10 @@ delete_cmd		:	TABLE		table_or_id_spec
  			{
  				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_RULE, &$2, &@$, NULL);
  			}
+			|	RULE		rule_position   rule
+			{
+				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_RULE, &$2, &@$, $3);
+			}
  			|	SET		set_or_id_spec
  			{
  				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_SET, &$2, &@$, NULL);
-- 
2.27.0
