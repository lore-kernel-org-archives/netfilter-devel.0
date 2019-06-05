Return-Path: <SRS0=tNyb=UE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD16FC28CC5
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Jun 2019 20:52:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0AE32070B
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Jun 2019 20:52:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbfFEUwQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Jun 2019 16:52:16 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:59448 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726305AbfFEUwQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Jun 2019 16:52:16 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1hYctK-0001Wi-AM; Wed, 05 Jun 2019 22:52:14 +0200
Date:   Wed, 5 Jun 2019 22:52:14 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] mnl: bogus error when running monitor mode
Message-ID: <20190605205214.GA31548@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20190605173451.19031-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190605173451.19031-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 05, 2019 at 07:34:51PM +0200, Pablo Neira Ayuso wrote:
> Fix bogus error message:
> 
>  # nft monitor
>  Cannot set up netlink socket buffer size to 16777216 bytes, falling back to 16777216 bytes
> 
> Fixes: bcf60fb819bf ("mnl: add mnl_set_rcvbuffer() and use it")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  src/mnl.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/src/mnl.c b/src/mnl.c
> index c0df2c941d88..a7693ef1de30 100644
> --- a/src/mnl.c
> +++ b/src/mnl.c
> @@ -1433,8 +1433,6 @@ int mnl_nft_event_listener(struct mnl_socket *nf_sock, unsigned int debug_mask,
>  
>  	ret = mnl_set_rcvbuffer(nf_sock, bufsiz);
>  	if (ret < 0)
> -		nft_print(octx, "# Cannot increase netlink socket buffer size, expect message loss\n");
> -	else
>  		nft_print(octx, "# Cannot set up netlink socket buffer size to %u bytes, falling back to %u bytes\n",
>  			  NFTABLES_NLEVENT_BUFSIZ, bufsiz);

This error message is not correct: If mnl_set_rcvbuffer() returned
non-zero, both setsockopt() calls failed. The removed message would be
more appropriate for that situation.

BTW: While being at it, maybe s/socket buffer/socket receive buffer/?

Cheers, Phil

