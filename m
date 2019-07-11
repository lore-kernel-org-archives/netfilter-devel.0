Return-Path: <SRS0=IQIq=VI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13569C74A3F
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Jul 2019 00:30:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDB5520844
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Jul 2019 00:30:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727859AbfGKAar (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 10 Jul 2019 20:30:47 -0400
Received: from smtprelay0030.hostedemail.com ([216.40.44.30]:45094 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726627AbfGKAar (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 Jul 2019 20:30:47 -0400
X-Greylist: delayed 505 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Jul 2019 20:30:46 EDT
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave08.hostedemail.com (Postfix) with ESMTP id 9A74E182D48C4;
        Thu, 11 Jul 2019 00:22:22 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id F2F3B4833;
        Thu, 11 Jul 2019 00:22:20 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: need74_4e415a63a7511
X-Filterd-Recvd-Size: 2210
Received: from XPS-9350.home (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf15.hostedemail.com (Postfix) with ESMTPA;
        Thu, 11 Jul 2019 00:22:17 +0000 (UTC)
Message-ID: <80a4e132f3be48899904eccdc023f5c53229840b.camel@perches.com>
Subject: Re: [PATCH] ipvs: remove unnecessary space
From:   Joe Perches <joe@perches.com>
To:     Simon Horman <horms@verge.net.au>,
        yangxingwu <xingwu.yang@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     wensong@linux-vs.org, ja@ssi.bg, kadlec@blackhole.kfki.hu,
        fw@strlen.de, davem@davemloft.net, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org
Date:   Wed, 10 Jul 2019 17:22:16 -0700
In-Reply-To: <20190710080609.smxjqe2d5jyro4hv@verge.net.au>
References: <20190710074552.74394-1-xingwu.yang@gmail.com>
         <20190710080609.smxjqe2d5jyro4hv@verge.net.au>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 2019-07-10 at 10:06 +0200, Simon Horman wrote:
> On Wed, Jul 10, 2019 at 03:45:52PM +0800, yangxingwu wrote:
> > this patch removes the extra space.
> > 
> > Signed-off-by: yangxingwu <xingwu.yang@gmail.com>
> 
> Thanks, this looks good to me.
> 
> Acked-by: Simon Horman <horms@verge.net.au>
> 
> Pablo, please consider including this in nf-next.
> 
> 
> > ---
> >  net/netfilter/ipvs/ip_vs_mh.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/net/netfilter/ipvs/ip_vs_mh.c b/net/netfilter/ipvs/ip_vs_mh.c
> > index 94d9d34..98e358e 100644
> > --- a/net/netfilter/ipvs/ip_vs_mh.c
> > +++ b/net/netfilter/ipvs/ip_vs_mh.c
> > @@ -174,8 +174,8 @@ static int ip_vs_mh_populate(struct ip_vs_mh_state *s,
> >  		return 0;
> >  	}
> >  
> > -	table =  kcalloc(BITS_TO_LONGS(IP_VS_MH_TAB_SIZE),
> > -			 sizeof(unsigned long), GFP_KERNEL);
> > +	table =	kcalloc(BITS_TO_LONGS(IP_VS_MH_TAB_SIZE),
> > +			sizeof(unsigned long), GFP_KERNEL);

bitmap_alloc?

> >  	if (!table)
> >  		return -ENOMEM;
> >  
> > -- 
> > 1.8.3.1
> > 

