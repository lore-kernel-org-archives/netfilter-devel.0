Return-Path: <SRS0=2jko=VQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A648C76195
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Jul 2019 10:32:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FCAD21849
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Jul 2019 10:32:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbfGSKcG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 19 Jul 2019 06:32:06 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:37692 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725853AbfGSKcG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Jul 2019 06:32:06 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1hoQBJ-0006CN-8q; Fri, 19 Jul 2019 12:32:05 +0200
Date:   Fri, 19 Jul 2019 12:32:05 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] libnftables: got rid of repeated initialization of
 netlink_ctx variable in loop.
Message-ID: <20190719103205.GM1628@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Jeremy Sowden <jeremy@azazel.net>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <20190718145722.k5nnznt753cunnca@salvia>
 <20190718210552.16890-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190718210552.16890-1-jeremy@azazel.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Thu, Jul 18, 2019 at 10:05:52PM +0100, Jeremy Sowden wrote:
> Most members in the context doesn't change, so there is no need to
> memset it and reassign most of its members on every iteration.  Moved
> that code out of the loop.
> 
> Fixes: 49900d448ac9 ("libnftables: Move library stuff out of main.c")

This commit merely moved the code from src/main.c into the current
location. I would rather point at a72315d2bad47 ("src: add rule batching
support"), which introduced the loop (and already contains some of the
pointless assignments). Note that commit is from 2013. :)

> Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> ---
>  src/libnftables.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/src/libnftables.c b/src/libnftables.c
> index 2f77a7709e2c..834ea661a146 100644
> --- a/src/libnftables.c
> +++ b/src/libnftables.c
> @@ -23,7 +23,7 @@ static int nft_netlink(struct nft_ctx *nft,
>  {
>  	uint32_t batch_seqnum, seqnum = 0, num_cmds = 0;
>  	struct nftnl_batch *batch;
> -	struct netlink_ctx ctx;
> +	struct netlink_ctx ctx = { .msgs = msgs, .nft = nft };

Use '.list = LIST_HEAD_INIT(ctx.list),' here. Refer to cache_update() in
src/rule.c for inspiration. :)

>  	struct cmd *cmd;
>  	struct mnl_err *err, *tmp;
>  	LIST_HEAD(err_list);
> @@ -32,16 +32,13 @@ static int nft_netlink(struct nft_ctx *nft,
>  	if (list_empty(cmds))
>  		return 0;
>  
> -	batch = mnl_batch_init();
> +	init_list_head(&ctx.list);

Drop this.

> +
> +	ctx.batch = batch = mnl_batch_init();

Move ctx.batch init into declaration as well. Drop dedicated 'batch'
variable and replace by 'ctx.batch'.

Thanks, Phil
