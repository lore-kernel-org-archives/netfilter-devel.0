Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99CACC433DB
	for <netfilter-devel@archiver.kernel.org>; Sat, 27 Mar 2021 08:37:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4300661968
	for <netfilter-devel@archiver.kernel.org>; Sat, 27 Mar 2021 08:37:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbhC0IhL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 27 Mar 2021 04:37:11 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:56344 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbhC0Igq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 27 Mar 2021 04:36:46 -0400
Received: from madeliefje.horms.nl (tulip.horms.nl [83.161.246.101])
        by kirsty.vergenet.net (Postfix) with ESMTPA id 2B7A925B7A8;
        Sat, 27 Mar 2021 19:36:45 +1100 (AEDT)
Received: by madeliefje.horms.nl (Postfix, from userid 7100)
        id C84943C01; Sat, 27 Mar 2021 09:36:42 +0100 (CET)
Date:   Sat, 27 Mar 2021 09:36:42 +0100
From:   Simon Horman <horms@verge.net.au>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rdunlap@infradead.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 08/19] netfilter: ipvs: A spello fix
Message-ID: <20210327083642.GB734@vergenet.net>
References: <cover.1616797633.git.unixbhaskar@gmail.com>
 <e332d89570c2dd95512a888c8372e69fab711952.1616797633.git.unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e332d89570c2dd95512a888c8372e69fab711952.1616797633.git.unixbhaskar@gmail.com>
Organisation: Horms Solutions BV
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

+ netfilter-devel@vger.kernel.org

On Sat, Mar 27, 2021 at 04:43:01AM +0530, Bhaskar Chowdhury wrote:
> s/registerd/registered/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Reviewed-by: Simon Horman <horms@verge.net.au>

> ---
>  net/netfilter/ipvs/ip_vs_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
> index 0c132ff9b446..128690c512df 100644
> --- a/net/netfilter/ipvs/ip_vs_core.c
> +++ b/net/netfilter/ipvs/ip_vs_core.c
> @@ -2398,7 +2398,7 @@ static int __net_init __ip_vs_init(struct net *net)
>  	if (ipvs == NULL)
>  		return -ENOMEM;
> 
> -	/* Hold the beast until a service is registerd */
> +	/* Hold the beast until a service is registered */
>  	ipvs->enable = 0;
>  	ipvs->net = net;
>  	/* Counters used for creating unique names */
> --
> 2.26.2
> 
