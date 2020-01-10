Return-Path: <SRS0=mMMR=27=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FBDEC33CA4
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Jan 2020 12:53:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F6382072A
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Jan 2020 12:53:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbgAJMxN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 10 Jan 2020 07:53:13 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:35176 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727174AbgAJMxN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Jan 2020 07:53:13 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iptmp-0004Ri-2f; Fri, 10 Jan 2020 13:53:11 +0100
Date:   Fri, 10 Jan 2020 13:53:11 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 1/3] libnftables: add nft_ctx_set_netns()
Message-ID: <20200110125311.GP20229@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20200109172115.229723-1-pablo@netfilter.org>
 <20200109172115.229723-2-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200109172115.229723-2-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Thu, Jan 09, 2020 at 06:21:13PM +0100, Pablo Neira Ayuso wrote:
[...]
> diff --git a/include/nftables/libnftables.h b/include/nftables/libnftables.h
> index 765b20dd71ee..887628959ac6 100644
> --- a/include/nftables/libnftables.h
> +++ b/include/nftables/libnftables.h
> @@ -34,10 +34,13 @@ enum nft_debug_level {
>   * Possible flags to pass to nft_ctx_new()
>   */
>  #define NFT_CTX_DEFAULT		0
> +#define NFT_CTX_NETNS		1

What is this needed for?

>  struct nft_ctx *nft_ctx_new(uint32_t flags);
>  void nft_ctx_free(struct nft_ctx *ctx);
>  
> +int nft_ctx_set_netns(struct nft_ctx *ctx, const char *netns);

Is there a way to select init ns again?

Thanks, Phil
