Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D5B0C388F9
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Nov 2020 01:33:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33E16206F1
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Nov 2020 01:33:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728638AbgKLBdn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Nov 2020 20:33:43 -0500
Received: from correo.us.es ([193.147.175.20]:57310 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727961AbgKKXnG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Nov 2020 18:43:06 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 65E411C41C0
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Nov 2020 00:43:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 55437DA73F
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Nov 2020 00:43:04 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4AEC7DA72F; Thu, 12 Nov 2020 00:43:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 031F6DA704;
        Thu, 12 Nov 2020 00:43:02 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 12 Nov 2020 00:43:02 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D71A64301DE0;
        Thu, 12 Nov 2020 00:43:01 +0100 (CET)
Date:   Thu, 12 Nov 2020 00:43:01 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Martin Willi <martin@strongswan.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net] vrf: Fix fast path output packet handling with async
 Netfilter rules
Message-ID: <20201111234301.GA3058@salvia>
References: <20201106073030.3974927-1-martin@strongswan.org>
 <20201110133506.GA1777@salvia>
 <2df88651a28cf77daf09e3d1282261d518794629.camel@strongswan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2df88651a28cf77daf09e3d1282261d518794629.camel@strongswan.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Martin,

On Tue, Nov 10, 2020 at 04:02:13PM +0100, Martin Willi wrote:
> Hi Pablo,
>  
> > > +static int vrf_output6_direct_finish(struct net *net, struct sock *sk,
> > > +				     struct sk_buff *skb)
> > > +{
> > > +	vrf_finish_direct(skb);
> > > +
> > > +	return vrf_ip6_local_out(net, sk, skb);
> > > +}
> > > +
> > >  static int vrf_output6_direct(struct net *net, struct sock *sk,
> > >  			      struct sk_buff *skb)
> > >  {
> > > +	int err = 1;
> > > +
> > >  	skb->protocol = htons(ETH_P_IPV6);
> > >  
> > > -	return NF_HOOK_COND(NFPROTO_IPV6, NF_INET_POST_ROUTING,
> > > -			    net, sk, skb, NULL, skb->dev,
> > > -			    vrf_finish_direct,
> > > -			    !(IPCB(skb)->flags & IPSKB_REROUTED));
> > > +	if (!(IPCB(skb)->flags & IPSKB_REROUTED))
> > > +		err = nf_hook(NFPROTO_IPV6, NF_INET_POST_ROUTING, net, sk, skb,
> > > +			      NULL, skb->dev, vrf_output6_direct_finish);
> > 
> > I might missing something... this looks very similar to NF_HOOK_COND
> > but it's open-coded.
> > 
> > My question, could you still use NF_HOOK_COND?
> > 
> >         ret = NF_HOOK_COND(NFPROTO_IPV6, ..., vrf_output6_direct_finish);
> > 
> > just update the okfn.
> 
> I don't think this will work. The point of the patch is to have
> different paths for sync and async Netfilter rules: In the async case
> we call vrf_output6_direct_finish() to additionally do dst_output(). In
> the (existing) synchronous path we just do vrf_finish_direct() and let
> the caller do the dst_output().
> 
> If we prefer a common okfn(), we could return 0 to omit dst_output() in
> ip/ip6_local_out(). This changes/extends the call stack for the common
> case, though, and this is what I've tried to avoid.

thanks for explaining.

> > > +	if (likely(err == 1))
> > 
> > I'd suggest you remove likely() here and elsewhere in this patch.
> > Just let the branch predictor make its work instead of assuming that
> > the ruleset accepts traffic.
> 
> The likely() may be questionable, but I seems that is done in most
> places when checking for synchronous Netfilter completion. But I'm fine
> with changing these hunks, if you prefer.

I see, this likely() assumes that IPCB(skb)->flags & IPSKB_REROUTED is
actually unlikely to happen.

no objections from my side to this patch, thanks.
