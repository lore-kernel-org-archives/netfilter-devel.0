Return-Path: <SRS0=/ozj=TY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F0FDC072B5
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 May 2019 19:53:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E808217D7
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 May 2019 19:53:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403950AbfEXTxj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 May 2019 15:53:39 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:45079 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403797AbfEXTxi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 May 2019 15:53:38 -0400
Received: from [31.4.219.201] (helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <pablo@gnumonks.org>)
        id 1hUGFz-0004Hn-4M; Fri, 24 May 2019 21:53:36 +0200
Date:   Fri, 24 May 2019 21:53:34 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Eric Garver <e@erig.me>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 3/3] src: Support intra-transaction rule references
Message-ID: <20190524195334.xgwzfzljlwt4ln74@salvia>
References: <20190522153035.19806-1-phil@nwl.cc>
 <20190522153035.19806-4-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522153035.19806-4-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, May 22, 2019 at 05:30:35PM +0200, Phil Sutter wrote:
> index 21d9e146e587f..9964adcf9a601 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
[...]
> @@ -3418,8 +3455,13 @@ static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
>  		handle_merge(&cmd->set->handle, &cmd->handle);
>  		return set_evaluate(ctx, cmd->set);
>  	case CMD_OBJ_RULE:
> +		/* update cache with CMD_LIST so that rules are fetched, too */
> +		ret = cache_update(ctx->nft, CMD_LIST, ctx->msgs);
> +		if (ret < 0)
> +			return ret;

This also slows down addition for the non-index case. We should allow
fetch the cache only when needed.
