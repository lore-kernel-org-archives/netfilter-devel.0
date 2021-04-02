Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77D64C433ED
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Apr 2021 09:28:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A7F661005
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Apr 2021 09:28:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbhDBJ2s (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 2 Apr 2021 05:28:48 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:53394 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234389AbhDBJ2r (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Apr 2021 05:28:47 -0400
Received: from madeliefje.horms.nl (tulip.horms.nl [83.161.246.101])
        by kirsty.vergenet.net (Postfix) with ESMTPA id CE6B825BE7B;
        Fri,  2 Apr 2021 20:28:45 +1100 (AEDT)
Received: by madeliefje.horms.nl (Postfix, from userid 7100)
        id C699CFAA; Fri,  2 Apr 2021 11:28:43 +0200 (CEST)
Date:   Fri, 2 Apr 2021 11:28:43 +0200
From:   Simon Horman <horms@verge.net.au>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        lvs-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: ipvs: do not printk on netns creation
Message-ID: <20210402092843.GB7320@vergenet.net>
References: <20210330064232.11960-1-fw@strlen.de>
 <33419d34-c96-4eb5-b633-c73d5bcf4ee@ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33419d34-c96-4eb5-b633-c73d5bcf4ee@ssi.bg>
Organisation: Horms Solutions BV
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Apr 02, 2021 at 06:07:23AM +0300, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Tue, 30 Mar 2021, Florian Westphal wrote:
> 
> > This causes dmesg spew during normal operation, so remove this.
> > 
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> 	Looks good to me, thanks!
> 
> Acked-by: Julian Anastasov <ja@ssi.bg>

Reviewed-by: Simon Horman <horms@verge.net.au>

> 
> > ---
> >  net/netfilter/ipvs/ip_vs_ftp.c | 2 --
> >  1 file changed, 2 deletions(-)
> > 
> > diff --git a/net/netfilter/ipvs/ip_vs_ftp.c b/net/netfilter/ipvs/ip_vs_ftp.c
> > index cf925906f59b..ef1f45e43b63 100644
> > --- a/net/netfilter/ipvs/ip_vs_ftp.c
> > +++ b/net/netfilter/ipvs/ip_vs_ftp.c
> > @@ -591,8 +591,6 @@ static int __net_init __ip_vs_ftp_init(struct net *net)
> >  		ret = register_ip_vs_app_inc(ipvs, app, app->protocol, ports[i]);
> >  		if (ret)
> >  			goto err_unreg;
> > -		pr_info("%s: loaded support on port[%d] = %u\n",
> > -			app->name, i, ports[i]);
> >  	}
> >  	return 0;
> >  
> > -- 
> > 2.26.3
> 
> Regards
> 
> --
> Julian Anastasov <ja@ssi.bg>
> 
