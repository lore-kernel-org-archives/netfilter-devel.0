Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7E7AC433ED
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Apr 2021 03:15:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEFB260FDC
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Apr 2021 03:15:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234211AbhDBDP6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Apr 2021 23:15:58 -0400
Received: from mg.ssi.bg ([178.16.128.9]:40896 "EHLO mg.ssi.bg"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233786AbhDBDP6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Apr 2021 23:15:58 -0400
X-Greylist: delayed 508 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Apr 2021 23:15:57 EDT
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id E1252BBDC;
        Fri,  2 Apr 2021 06:07:28 +0300 (EEST)
Received: from ink.ssi.bg (ink.ssi.bg [178.16.128.7])
        by mg.ssi.bg (Proxmox) with ESMTP id 2EE80BBD1;
        Fri,  2 Apr 2021 06:07:28 +0300 (EEST)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id 587A33C0332;
        Fri,  2 Apr 2021 06:07:27 +0300 (EEST)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id 13237NKG006950;
        Fri, 2 Apr 2021 06:07:23 +0300
Date:   Fri, 2 Apr 2021 06:07:23 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Florian Westphal <fw@strlen.de>
cc:     netfilter-devel@vger.kernel.org, lvs-devel@vger.kernel.org,
        Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: ipvs: do not printk on netns
 creation
In-Reply-To: <20210330064232.11960-1-fw@strlen.de>
Message-ID: <33419d34-c96-4eb5-b633-c73d5bcf4ee@ssi.bg>
References: <20210330064232.11960-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


	Hello,

On Tue, 30 Mar 2021, Florian Westphal wrote:

> This causes dmesg spew during normal operation, so remove this.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

	Looks good to me, thanks!

Acked-by: Julian Anastasov <ja@ssi.bg>

> ---
>  net/netfilter/ipvs/ip_vs_ftp.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_ftp.c b/net/netfilter/ipvs/ip_vs_ftp.c
> index cf925906f59b..ef1f45e43b63 100644
> --- a/net/netfilter/ipvs/ip_vs_ftp.c
> +++ b/net/netfilter/ipvs/ip_vs_ftp.c
> @@ -591,8 +591,6 @@ static int __net_init __ip_vs_ftp_init(struct net *net)
>  		ret = register_ip_vs_app_inc(ipvs, app, app->protocol, ports[i]);
>  		if (ret)
>  			goto err_unreg;
> -		pr_info("%s: loaded support on port[%d] = %u\n",
> -			app->name, i, ports[i]);
>  	}
>  	return 0;
>  
> -- 
> 2.26.3

Regards

--
Julian Anastasov <ja@ssi.bg>

