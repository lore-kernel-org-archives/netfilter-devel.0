Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19DCACA0FE6
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Sep 2023 08:39:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235364AbjIAIj7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Sep 2023 04:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233494AbjIAIj7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Sep 2023 04:39:59 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA4910CF;
        Fri,  1 Sep 2023 01:39:56 -0700 (PDT)
Received: from [78.30.34.192] (port=57334 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qbzh1-00AIpi-NY; Fri, 01 Sep 2023 10:39:54 +0200
Date:   Fri, 1 Sep 2023 10:39:50 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC] netfilter: nf_tables: ignore -EOPNOTSUPP on flowtable
 device offload setup
Message-ID: <ZPGjVl7jmLhMhgBP@calendula>
References: <20230831201420.63178-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230831201420.63178-1-nbd@nbd.name>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Felix,

On Thu, Aug 31, 2023 at 10:14:20PM +0200, Felix Fietkau wrote:
> On many embedded devices, it is common to configure flowtable offloading for
> a mix of different devices, some of which have hardware offload support and
> some of which don't.
> The current code limits the ability of user space to properly set up such a
> configuration by only allowing adding devices with hardware offload support to
> a offload-enabled flowtable.
> Given that offload-enabled flowtables also imply fallback to pure software
> offloading, this limitation makes little sense.
> Fix it by not bailing out when the offload setup returns -EOPNOTSUPP

Would you send a v2 to untoggle the offload flag when listing the
ruleset if EOPNOTSUPP is reported? Thus, the user knows that no
hardware offload is being used.

> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
>  net/netfilter/nf_tables_api.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 41b826dff6f5..dfa2ea98088b 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -8103,7 +8103,7 @@ static int nft_register_flowtable_net_hooks(struct net *net,
>  		err = flowtable->data.type->setup(&flowtable->data,
>  						  hook->ops.dev,
>  						  FLOW_BLOCK_BIND);
> -		if (err < 0)
> +		if (err < 0 && err != -EOPNOTSUPP)
>  			goto err_unregister_net_hooks;
>  
>  		err = nf_register_net_hook(net, &hook->ops);
> -- 
> 2.41.0
> 
