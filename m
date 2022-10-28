Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 203FEC38A02
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Oct 2022 18:26:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiJ1S0K (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 Oct 2022 14:26:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiJ1S0J (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Oct 2022 14:26:09 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04F871C19D1
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Oct 2022 11:26:07 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1ooU3R-0001Uq-F4; Fri, 28 Oct 2022 20:26:05 +0200
Date:   Fri, 28 Oct 2022 20:26:05 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v4] src: add support to command "destroy"
Message-ID: <Y1weve5JsmyNLb8t@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        netfilter-devel@vger.kernel.org
References: <20221028100648.58789-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221028100648.58789-1-ffmancera@riseup.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Fernando,

On Fri, Oct 28, 2022 at 12:06:48PM +0200, Fernando Fernandez Mancera wrote:
[...]
> diff --git a/src/mnl.c b/src/mnl.c
> index e87b0338..ab0e06c9 100644
> --- a/src/mnl.c
> +++ b/src/mnl.c
> @@ -602,10 +602,16 @@ int mnl_nft_rule_del(struct netlink_ctx *ctx, struct cmd *cmd)
>  
>  	nftnl_rule_set_u32(nlr, NFTNL_RULE_FAMILY, h->family);
>  
> -	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(ctx->batch),
> -				    NFT_MSG_DELRULE,
> -				    nftnl_rule_get_u32(nlr, NFTNL_RULE_FAMILY),
> -				    0, ctx->seqnum);
> +	if (cmd->op == CMD_DESTROY)
> +		nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(ctx->batch),
> +					    NFT_MSG_DESTROYRULE,
> +					    nftnl_rule_get_u32(nlr, NFTNL_RULE_FAMILY),
> +					    0, ctx->seqnum);
> +	else
> +		nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(ctx->batch),
> +					    NFT_MSG_DELRULE,
> +					    nftnl_rule_get_u32(nlr, NFTNL_RULE_FAMILY),
> +					    0, ctx->seqnum);
>  
>  	cmd_add_loc(cmd, nlh->nlmsg_len, &h->table.location);
>  	mnl_attr_put_strz(nlh, NFTA_RULE_TABLE, h->table.name);

These chunks become much simpler if you introduce a local variable
holding NFT_MSG_DELRULE by default and set it to NFT_MSG_DESTROYRULE if
cmd->op == CMD_DESTROY. 

Cheers, Phil
