Return-Path: <SRS0=nOV7=VK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B432C31E40
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Jul 2019 21:44:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C7CB20848
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Jul 2019 21:44:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728086AbfGMVny (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 13 Jul 2019 17:43:54 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:45274 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727978AbfGMVnx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 13 Jul 2019 17:43:53 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hmPo8-0004fr-0w; Sat, 13 Jul 2019 23:43:52 +0200
Date:   Sat, 13 Jul 2019 23:43:52 +0200
From:   Florian Westphal <fw@strlen.de>
To:     michael-dev@fami-braun.de
Cc:     netdev@vger.kernel.org,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] Fix dumping vlan rules
Message-ID: <20190713214352.e5nsp35f6rbctsbd@breakpoint.cc>
References: <20190713210306.30815-1-michael-dev@fami-braun.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190713210306.30815-1-michael-dev@fami-braun.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

michael-dev@fami-braun.de <michael-dev@fami-braun.de> wrote:
> From: "M. Braun" <michael-dev@fami-braun.de>
> 
> Given the following bridge rules:
> 1. ip protocol icmp accept
> 2. ether type vlan vlan type ip ip protocol icmp accept
> 
> The are currently both dumped by "nft list ruleset" as
> 1. ip protocol icmp accept
> 2. ip protocol icmp accept

Yes, thats a bug, the dependency removal is incorrect.

> +++ b/src/payload.c
> @@ -506,6 +506,18 @@ static bool payload_may_dependency_kill(struct payload_dep_ctx *ctx,
>  		     dep->left->payload.desc == &proto_ip6) &&
>  		    expr->payload.base == PROTO_BASE_TRANSPORT_HDR)
>  			return false;
> +		/* Do not kill
> +		 *  ether type vlan and vlan type ip and ip protocol icmp
> +		 * into
> +		 *  ip protocol icmp
> +		 * as this lacks ether type vlan.
> +		 * More generally speaking, do not kill protocol type
> +		 * for stacked protocols if we only have protcol type matches.
> +		 */
> +		if (dep->left->etype == EXPR_PAYLOAD && dep->op == OP_EQ &&
> +		    expr->flags & EXPR_F_PROTOCOL &&
> +		    expr->payload.base == dep->left->payload.base)
> +			return false;

Can you please add a test case for this problem to
tests/py/bridge/vlan.t so we catch this when messing with dependency
handling in the future?

Also, please submit v2 directly to netfilter-devel@.

Thanks!
