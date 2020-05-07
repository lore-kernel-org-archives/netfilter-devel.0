Return-Path: <SRS0=DUCC=6V=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48FE4C38A2A
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 May 2020 19:33:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F7C621582
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 May 2020 19:33:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbgEGTdQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 May 2020 15:33:16 -0400
Received: from correo.us.es ([193.147.175.20]:55688 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726320AbgEGTdQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 May 2020 15:33:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D6CA8B5AB7
        for <netfilter-devel@vger.kernel.org>; Thu,  7 May 2020 21:33:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C41AC11541A
        for <netfilter-devel@vger.kernel.org>; Thu,  7 May 2020 21:33:13 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B748B115416; Thu,  7 May 2020 21:33:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6B7D711540C;
        Thu,  7 May 2020 21:33:11 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 07 May 2020 21:33:11 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 48B0C42EF4E0;
        Thu,  7 May 2020 21:33:11 +0200 (CEST)
Date:   Thu, 7 May 2020 21:33:10 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, jengelh@inai.de
Subject: Re: [PATCH nft] mnl: fix error rule reporting with missing
 table/chain and anonymous sets
Message-ID: <20200507193310.GA24304@salvia>
References: <20200507112919.21227-1-pablo@netfilter.org>
 <20200507141148.GN32392@breakpoint.cc>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="3MwIy2ne0vdjdPXF"
Content-Disposition: inline
In-Reply-To: <20200507141148.GN32392@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 07, 2020 at 04:11:48PM +0200, Florian Westphal wrote:
[...]
> Yes, but there is something else going on.
> 
> The command above works without this patch if you use a shorter table name.
> There is another bug that causes nft to pull the wrong error object
> from the queue.
> 
> The kernel doesn't generate an error for NFTA_SET_NAME in the above
> rule, so we should not crash even without this (correct) fix, because
> nft should not find this particular error object.
> 
> Seems the generated error is for NFTA_SET_ELEM_LIST_TABLE when handling
> nf_tables_newsetelem() in kernel (which makes sense, the table doesn't
> exist).
> 
> With the above command (traffic-filter) NFTA_SET_NAMEs start offset
> matches the offset of NFTA_SET_ELEM_LIST_TABLE error message in the
> other netlink message (the one adding the element to the set), it will
> erronously find the cmd_add_loc() of NFTA_SET_NAME and then barf because
> of the bug fixed here.
> 
> Not sure how to fix nft_cmd_error(), it looks like the error queueing assumes
> 1:1 mapping of cmd struct and netlink message header...?

Thanks for explaining.

I forgot anonymous sets are missing the expansion to achieve the 1:1
mapping between commands and netlink messages.

Please, have a look at attached sketch patch.

--3MwIy2ne0vdjdPXF
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

diff --git a/include/rule.h b/include/rule.h
index 1a4ec3d8bc37..e11740d548ca 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -587,6 +587,7 @@ enum cmd_ops {
 enum cmd_obj {
 	CMD_OBJ_INVALID,
 	CMD_OBJ_SETELEM,
+	CMD_OBJ_SETELEM_ANONYMOUS,
 	CMD_OBJ_SET,
 	CMD_OBJ_SETS,
 	CMD_OBJ_RULE,
diff --git a/src/libnftables.c b/src/libnftables.c
index 32da0a29ee21..668e3fc43031 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -419,8 +419,12 @@ static int nft_evaluate(struct nft_ctx *nft, struct list_head *msgs,
 	if (nft->state->nerrs)
 		return -1;
 
-	list_for_each_entry(cmd, cmds, list)
+	list_for_each_entry(cmd, cmds, list) {
+		if (cmd->op != CMD_ADD)
+			continue;
+
 		nft_cmd_expand(cmd);
+	}
 
 	return 0;
 }
diff --git a/src/rule.c b/src/rule.c
index c58aa359259e..166c6c2befaf 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1417,11 +1417,11 @@ void cmd_add_loc(struct cmd *cmd, uint16_t offset, struct location *loc)
 void nft_cmd_expand(struct cmd *cmd)
 {
 	struct list_head new_cmds;
+	struct set *set, *newset;
 	struct flowtable *ft;
 	struct table *table;
 	struct chain *chain;
 	struct rule *rule;
-	struct set *set;
 	struct obj *obj;
 	struct cmd *new;
 	struct handle h;
@@ -1477,6 +1477,22 @@ void nft_cmd_expand(struct cmd *cmd)
 		}
 		list_splice(&new_cmds, &cmd->list);
 		break;
+	case CMD_OBJ_SET:
+		set = cmd->set;
+		if (!set_is_anonymous(set->flags))
+			break;
+
+		memset(&h, 0, sizeof(h));
+		handle_merge(&h, &set->handle);
+		newset = set_clone(set);
+		newset->handle.set_id = set->handle.set_id;
+		newset->init = set->init;
+		set->init = NULL;
+		new = cmd_alloc(CMD_ADD, CMD_OBJ_SETELEM_ANONYMOUS, &h,
+				&set->location, newset);
+		list_add(&new->list, &cmd->list);
+		set->init = NULL;
+		break;
 	default:
 		break;
 	}
@@ -1525,6 +1541,7 @@ void cmd_free(struct cmd *cmd)
 			expr_free(cmd->expr);
 			break;
 		case CMD_OBJ_SET:
+		case CMD_OBJ_SETELEM_ANONYMOUS:
 			set_free(cmd->set);
 			break;
 		case CMD_OBJ_RULE:
@@ -1610,7 +1627,7 @@ static int do_add_setelems(struct netlink_ctx *ctx, struct cmd *cmd,
 }
 
 static int do_add_set(struct netlink_ctx *ctx, struct cmd *cmd,
-		      uint32_t flags)
+		      uint32_t flags, bool anonymous)
 {
 	struct set *set = cmd->set;
 
@@ -1621,7 +1638,7 @@ static int do_add_set(struct netlink_ctx *ctx, struct cmd *cmd,
 				     &ctx->nft->output) < 0)
 			return -1;
 	}
-	if (mnl_nft_set_add(ctx, cmd, flags) < 0)
+	if (!anonymous && mnl_nft_set_add(ctx, cmd, flags) < 0)
 		return -1;
 	if (set->init != NULL) {
 		return __do_add_setelems(ctx, set, set->init, flags);
@@ -1644,7 +1661,9 @@ static int do_command_add(struct netlink_ctx *ctx, struct cmd *cmd, bool excl)
 	case CMD_OBJ_RULE:
 		return mnl_nft_rule_add(ctx, cmd, flags | NLM_F_APPEND);
 	case CMD_OBJ_SET:
-		return do_add_set(ctx, cmd, flags);
+		return do_add_set(ctx, cmd, flags, false);
+	case CMD_OBJ_SETELEM_ANONYMOUS:
+		return do_add_set(ctx, cmd, flags, true);
 	case CMD_OBJ_SETELEM:
 		return do_add_setelems(ctx, cmd, flags);
 	case CMD_OBJ_COUNTER:

--3MwIy2ne0vdjdPXF--
