Return-Path: <SRS0=21Bs=SF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 244E0C4360F
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Apr 2019 20:52:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F193B2084B
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Apr 2019 20:52:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbfDCUwr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Apr 2019 16:52:47 -0400
Received: from ja.ssi.bg ([178.16.129.10]:46464 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726064AbfDCUwq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Apr 2019 16:52:46 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id x33KqbW8005715;
        Wed, 3 Apr 2019 23:52:37 +0300
Date:   Wed, 3 Apr 2019 23:52:37 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Simon Horman <horms@verge.net.au>
cc:     lvs-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Jacky Hu <hengqing.hu@gmail.com>,
        jacky.hu@walmart.com, jason.niesz@walmart.com
Subject: Re: [PATCH net-next 2/3] ipvs: add function to find tunnels
In-Reply-To: <20190403075646.m3yij2qi75yyvsom@verge.net.au>
Message-ID: <alpine.LFD.2.21.1904032348130.3584@ja.home.ssi.bg>
References: <20190331102621.7460-1-ja@ssi.bg> <20190331102621.7460-3-ja@ssi.bg> <20190403075646.m3yij2qi75yyvsom@verge.net.au>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


	Hello,

On Wed, 3 Apr 2019, Simon Horman wrote:

> On Sun, Mar 31, 2019 at 01:26:20PM +0300, Julian Anastasov wrote:
> 
> > diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
> > index 14457551bcb4..4447ee512b88 100644
> > --- a/net/netfilter/ipvs/ip_vs_core.c
> > +++ b/net/netfilter/ipvs/ip_vs_core.c
> > @@ -1598,6 +1598,7 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
> >  	struct ip_vs_proto_data *pd;
> >  	unsigned int offset, offset2, ihl, verdict;
> >  	bool ipip, new_cp = false;
> > +	union nf_inet_addr *raddr;
> >  
> >  	*related = 1;
> >  
> > @@ -1636,15 +1637,22 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
> >  	cih = skb_header_pointer(skb, offset, sizeof(_ciph), &_ciph);
> >  	if (cih == NULL)
> >  		return NF_ACCEPT; /* The packet looks wrong, ignore */
> > +	raddr = (union nf_inet_addr *)&cih->daddr;
> 
> Hi Julian,
> 
> 	Could we consider the following instead of casting?
> 
> 	union nf_inet_addr raddr;
> 
> 	...
> 
> 	raddr.ip = cih->daddr;

	It was my initial option but then I decided to reduce the
stack usage

Regards

--
Julian Anastasov <ja@ssi.bg>
