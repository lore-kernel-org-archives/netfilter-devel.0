Return-Path: <SRS0=wLp+=YK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 336EBECE58E
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 16:53:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12D1520872
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 16:53:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440510AbfJQQxW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Oct 2019 12:53:22 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:41996 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436732AbfJQQxW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Oct 2019 12:53:22 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iL91c-0007k3-Cy; Thu, 17 Oct 2019 18:53:20 +0200
Date:   Thu, 17 Oct 2019 18:53:20 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] src: restore --echo with anonymous sets
Message-ID: <20191017165320.GM12661@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20191017133455.17560-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017133455.17560-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Thu, Oct 17, 2019 at 03:34:55PM +0200, Pablo Neira Ayuso wrote:
> If --echo is passed, then the cache already contains the commands that
> have been sent to the kernel. However, anonymous sets are an exception
> since the cache needs to be updated in this case.
> 
> Remove the old cache logic from the monitor code that has been replaced
> by 01e5c6f0ed03 ("src: add cache level flags").
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

This is a nice solution, thanks! A few nits below:

[...]
> diff --git a/src/monitor.c b/src/monitor.c
> index 40c381149cda..b7b00d7b1343 100644
> --- a/src/monitor.c
> +++ b/src/monitor.c
> @@ -609,6 +609,12 @@ static void netlink_events_cache_addset(struct netlink_mon_handler *monh,
>  		goto out;
>  	}
>  
> +	if (nft_output_echo(&monh->ctx->nft->output) &&
> +	    !(s->flags & NFT_SET_ANONYMOUS)) {

There is set_is_anonymous(), set and element printing callbacks use it
as well.

[...]
> @@ -636,6 +642,10 @@ static void netlink_events_cache_addsetelem(struct netlink_mon_handler *monh,
>  		goto out;
>  	}
>  
> +	if (nft_output_echo(&monh->ctx->nft->output) &&
> +	    !(set->flags & NFT_SET_ANONYMOUS))

Same here.

[...]
> @@ -744,7 +754,8 @@ out:
>  static void netlink_events_cache_update(struct netlink_mon_handler *monh,
>  					const struct nlmsghdr *nlh, int type)
>  {
> -	if (!monh->cache_needed)
> +	if (nft_output_echo(&monh->ctx->nft->output) &&
> +	    type != NFT_MSG_NEWSET && type != NFT_MSG_NEWSETELEM)
>  		return;

I would use switch() here, like so:

|	if (nft_output_echo(&monh->ctx->nft->output)) {
|		switch (type) {
|		case NFT_MSG_NEWSET:
|		case NFT_MSG_NEWSETELEM:
|			break;
|		default:
|			return;
|		}
|	}

it emphasises that code is filtering for certain event types. Up to you,
I'm fine with both.

Thanks, Phil
