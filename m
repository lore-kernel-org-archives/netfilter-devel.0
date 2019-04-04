Return-Path: <SRS0=UjrQ=SG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83FDAC4360F
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Apr 2019 10:13:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A2A5205F4
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Apr 2019 10:13:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=verge.net.au header.i=@verge.net.au header.b="Eku9zR/7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729049AbfDDKNX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 4 Apr 2019 06:13:23 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:59185 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727053AbfDDKNW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 Apr 2019 06:13:22 -0400
Received: from reginn.horms.nl (watermunt.horms.nl [80.127.179.77])
        by kirsty.vergenet.net (Postfix) with ESMTPA id 8BEDA25B7A1;
        Thu,  4 Apr 2019 21:13:20 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=verge.net.au; s=mail;
        t=1554372800; bh=v/JW+amkl3uuSgmgmDbXVzJb2G5ndKvwvq3pS/ONcvE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Eku9zR/7H8nn1hG2QepQKNNQ0e27Qn9sR8MFx770YUh74VaRHG//1Fbm8qxqDxpX8
         rsOTzuiFAfd87u4ddDHAUZVbpiy9yF8SWSMR3JIgMygTU40XmA6msDjGXTIqB1/QbD
         ZiLMZEPArnK49cK6PYlDvuO/UxNk2GIdOsNAOrPc=
Received: by reginn.horms.nl (Postfix, from userid 7100)
        id AE2BD9402FD; Thu,  4 Apr 2019 12:13:18 +0200 (CEST)
Date:   Thu, 4 Apr 2019 12:13:18 +0200
From:   Simon Horman <horms@verge.net.au>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     lvs-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Jacky Hu <hengqing.hu@gmail.com>,
        jacky.hu@walmart.com, jason.niesz@walmart.com
Subject: Re: [PATCH net-next 2/3] ipvs: add function to find tunnels
Message-ID: <20190404101318.7e5uttz5r76rmtxq@verge.net.au>
References: <20190331102621.7460-1-ja@ssi.bg>
 <20190331102621.7460-3-ja@ssi.bg>
 <20190403075646.m3yij2qi75yyvsom@verge.net.au>
 <alpine.LFD.2.21.1904032348130.3584@ja.home.ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.21.1904032348130.3584@ja.home.ssi.bg>
Organisation: Horms Solutions BV
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Apr 03, 2019 at 11:52:37PM +0300, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Wed, 3 Apr 2019, Simon Horman wrote:
> 
> > On Sun, Mar 31, 2019 at 01:26:20PM +0300, Julian Anastasov wrote:
> > 
> > > diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
> > > index 14457551bcb4..4447ee512b88 100644
> > > --- a/net/netfilter/ipvs/ip_vs_core.c
> > > +++ b/net/netfilter/ipvs/ip_vs_core.c
> > > @@ -1598,6 +1598,7 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
> > >  	struct ip_vs_proto_data *pd;
> > >  	unsigned int offset, offset2, ihl, verdict;
> > >  	bool ipip, new_cp = false;
> > > +	union nf_inet_addr *raddr;
> > >  
> > >  	*related = 1;
> > >  
> > > @@ -1636,15 +1637,22 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
> > >  	cih = skb_header_pointer(skb, offset, sizeof(_ciph), &_ciph);
> > >  	if (cih == NULL)
> > >  		return NF_ACCEPT; /* The packet looks wrong, ignore */
> > > +	raddr = (union nf_inet_addr *)&cih->daddr;
> > 
> > Hi Julian,
> > 
> > 	Could we consider the following instead of casting?
> > 
> > 	union nf_inet_addr raddr;
> > 
> > 	...
> > 
> > 	raddr.ip = cih->daddr;
> 
> 	It was my initial option but then I decided to reduce the
> stack usage

Understood, I guess that minimising stack usage wins.

> 
> Regards
> 
> --
> Julian Anastasov <ja@ssi.bg>
> 
