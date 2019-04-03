Return-Path: <SRS0=21Bs=SF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9C78C4360F
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Apr 2019 20:43:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2D492084B
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Apr 2019 20:43:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726206AbfDCUnv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Apr 2019 16:43:51 -0400
Received: from ja.ssi.bg ([178.16.129.10]:46452 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726183AbfDCUnv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Apr 2019 16:43:51 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id x33KhSS2005681;
        Wed, 3 Apr 2019 23:43:28 +0300
Date:   Wed, 3 Apr 2019 23:43:28 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Simon Horman <horms@verge.net.au>
cc:     Pablo Neira Ayuso <pablo@netfilter.org>, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, Alex Gartrell <agartrell@fb.com>,
        Jacky Hu <hengqing.hu@gmail.com>, jacky.hu@walmart.com,
        jason.niesz@walmart.com
Subject: Re: [PATCH net] ipvs: do not schedule icmp errors from tunnels
In-Reply-To: <20190403074521.uijb34c6mo264nmg@verge.net.au>
Message-ID: <alpine.LFD.2.21.1904032342290.3584@ja.home.ssi.bg>
References: <20190331102452.7415-1-ja@ssi.bg> <20190403074521.uijb34c6mo264nmg@verge.net.au>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


	Hello,

On Wed, 3 Apr 2019, Simon Horman wrote:

> On Sun, Mar 31, 2019 at 01:24:52PM +0300, Julian Anastasov wrote:
> > We can receive ICMP errors from client or from
> > tunneling real server. While the former can be
> > scheduled to real server, the latter should
> > not be scheduled, they are decapsulated only when
> > existing connection is found.
> > 
> > Fixes: 6044eeffafbe ("ipvs: attempt to schedule icmp packets")
> > Signed-off-by: Julian Anastasov <ja@ssi.bg>
> 
> Thanks Julian, I assume this is also relevant to -stable.

	Yes

> Pablo, please consider applying this to nf.
> 
> Signed-off-by: Simon Horman <horms@verge.net.au>
> 
> > ---
> >  net/netfilter/ipvs/ip_vs_core.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
> > index 43bbaa32b1d6..14457551bcb4 100644
> > --- a/net/netfilter/ipvs/ip_vs_core.c
> > +++ b/net/netfilter/ipvs/ip_vs_core.c
> > @@ -1678,7 +1678,7 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
> >  	if (!cp) {
> >  		int v;
> >  
> > -		if (!sysctl_schedule_icmp(ipvs))
> > +		if (ipip || !sysctl_schedule_icmp(ipvs))
> >  			return NF_ACCEPT;
> >  
> >  		if (!ip_vs_try_to_schedule(ipvs, AF_INET, skb, pd, &v, &cp, &ciph))
> > -- 
> > 2.17.1

Regards

--
Julian Anastasov <ja@ssi.bg>
