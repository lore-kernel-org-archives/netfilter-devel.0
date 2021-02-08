Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CDE1C433DB
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Feb 2021 15:50:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35F6264E60
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Feb 2021 15:50:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234176AbhBHPuS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Feb 2021 10:50:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234141AbhBHPuA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Feb 2021 10:50:00 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA600C061786;
        Mon,  8 Feb 2021 07:49:16 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1l98mp-0004nh-I8; Mon, 08 Feb 2021 16:49:15 +0100
Date:   Mon, 8 Feb 2021 16:49:15 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Martin Gignac <martin.gignac@gmail.com>
Cc:     netfilter@vger.kernel.org,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: Unable to create a chain called "trace"
Message-ID: <20210208154915.GF16570@breakpoint.cc>
References: <CANf9dFMJN5ZsihtygUnEWB_9T=WLbEHrZY1a5mTqLgN7J39D5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANf9dFMJN5ZsihtygUnEWB_9T=WLbEHrZY1a5mTqLgN7J39D5w@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Martin Gignac <martin.gignac@gmail.com> wrote:

[ cc devel ]

> Out of curiosity, is there a reason why calling a chain "trace"
> results in an error?
> 
> This configuration:
> 
>   chain trace {
>     type filter hook prerouting priority -301;
>     ip daddr 24.153.88.9 ip protocol icmp meta nftrace set 1
>   }
> 
> Results in the following error when I try loading the ruleset:
> 
>   /etc/firewall/rules.nft:40:9-13: Error: syntax error, unexpected
> trace, expecting string
>   chain trace {
>         ^^^^^

grammar bug.

Pablo, Phil, others, can you remind me why we never did:

diff --git a/src/monitor.c b/src/monitor.c
--- a/src/monitor.c
+++ b/src/monitor.c
@@ -254,7 +254,7 @@ static int netlink_events_chain_cb(const struct nlmsghdr *nlh, int type,
 			chain_print_plain(c, &monh->ctx->nft->output);
 			break;
 		case NFT_MSG_DELCHAIN:
-			nft_mon_print(monh, "chain %s %s %s",
+			nft_mon_print(monh, "chain %s \"%s\" \"%s\"",
 				      family2str(c->handle.family),
 				      c->handle.table.name,
 				      c->handle.chain.name);
diff --git a/src/parser_bison.y b/src/parser_bison.y
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2395,6 +2395,7 @@ chain_policy		:	ACCEPT		{ $$ = NF_ACCEPT; }
 			;
 
 identifier		:	STRING
+			|	QUOTED_STRING
 			;
 
 string			:	STRING
diff --git a/src/rule.c b/src/rule.c
index e4bb6bae276a..77477e535f2e 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1236,7 +1236,7 @@ static void chain_print_declaration(const struct chain *chain,
 	if (chain->flags & CHAIN_F_BINDING)
 		return;
 
-	nft_print(octx, "\tchain %s {", chain->handle.chain.name);
+	nft_print(octx, "\tchain \"%s\" {", chain->handle.chain.name);
 	if (nft_output_handle(octx))
 		nft_print(octx, " # handle %" PRIu64, chain->handle.handle.id);
 	if (chain->comment)
@@ -1297,7 +1297,7 @@ void chain_print_plain(const struct chain *chain, struct output_ctx *octx)
 	char priobuf[STD_PRIO_BUFSIZE];
 	int policy;
 
-	nft_print(octx, "chain %s %s %s", family2str(chain->handle.family),
+	nft_print(octx, "chain %s \"%s\" \"%s\"", family2str(chain->handle.family),
 		  chain->handle.table.name, chain->handle.chain.name);
 
 	if (chain->flags & CHAIN_F_BASECHAIN) {

?
