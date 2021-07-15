Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 768E2C636C9
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Jul 2021 22:13:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5631C613D8
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Jul 2021 22:13:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231887AbhGOWQj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 15 Jul 2021 18:16:39 -0400
Received: from mail.netfilter.org ([217.70.188.207]:43520 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231882AbhGOWQi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Jul 2021 18:16:38 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 59DC364299;
        Fri, 16 Jul 2021 00:13:24 +0200 (CEST)
Date:   Fri, 16 Jul 2021 00:13:42 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Andrea Mayer <andrea.mayer@uniroma2.it>
Cc:     Ryoga Saito <proelbtn@gmail.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netfilter-devel@vger.kernel.org,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>
Subject: Re: [PATCH] net: Add netfilter hooks to track SRv6-encapsulated flows
Message-ID: <20210715221342.GA19921@salvia>
References: <20210706052548.5440-1-proelbtn@gmail.com>
 <20210708033138.ef3af5a724d7b569c379c35e@uniroma2.it>
 <20210708133859.GA6745@salvia>
 <20210708183239.824f8e1ed569b0240c38c7a8@uniroma2.it>
 <CALPAGbJt_rb_r3M2AEJ_6VRsG+zXrEOza0U-6SxFGsERGipT4w@mail.gmail.com>
 <8EFE7482-6E0E-4589-A9BE-F7BC96C7876E@gmail.com>
 <20210709204851.90b847c71760aa40668a0971@uniroma2.it>
 <FEF1CBA8-62EC-483A-B7CA-50973020F27B@gmail.com>
 <20210713013116.441cc6015af001c4df4f16b0@uniroma2.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210713013116.441cc6015af001c4df4f16b0@uniroma2.it>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Andrea,

On Tue, Jul 13, 2021 at 01:31:16AM +0200, Andrea Mayer wrote:
[...]
> > On Sun, 11 Jul 2021 16:12:48 +0900
> > Ryoga Saito <proelbtn@gmail.com> wrote:
> 
> > >
> > > No, this is a way to fix the problem that you introduce by changing the current
> > > srv6local forwarding model. If you have 100 End SIDs should you add 100 accept
> > > rules? The root problem is that SRv6 (srv6local) traffic should not go through
> > > the INPUT path.
> >
> > No, you only need to add single rule for accepting these SIDs. Here is the
> > quote of RFC 8986.
> >
> > ---
> > This document defines an SRv6 SID as consisting of LOC:FUNCT:ARG, where
> > a locator (LOC) is encoded in the L most significant bits of the SID,
> > followed by F bits of function (FUNCT) and A bits of arguments (ARG). L,
> > the locator length, is flexible, and an operator is free to use the locator
> > length of their choice. F and A may be any value as long as L+F+A <= 128.
> > When L+F+A is less than 128, then the remaining bits of the SID MUST be
> > zero.
> >
> > A locator may be represented as B:N where B is the SRv6 SID block (IPv6
> > prefix allocated for SRv6 SIDs by the operator) and N is the identifier of
> > the parent node instantiating the SID.
> >
> > When the LOC part of the SRv6 SIDs is routable, it leads to the node, which
> > instantiates the SID.
> > ---
> >
> > If there are 100 SIDs, but these SIDs are for the same node, the locators
> > of these SIDs also should be same. so, you can allow SRv6 flows by adding
> > only single rule.
> 
> No, you cannot rely on this assumption.
> Operators can choose to assign different locators to the same node.
> The document you mention does not prescribe how the SIDs should be allocated on
> the nodes, nor whether they should be part of one or more locators.
> Consequently, no one imposes on us that those 100 SIDs must belong all to the
> same locator.

It is possible to filter 100 SIDs with one single rule and one set,
even if they are different SIDs.

> > > Have you set the traffic to flow through INPUT to confirm a connection (for
> > > conntrack)? If this is the only reason, before changing the srv6local
> > > processing model in such a disruptive way, you can investigate different ways
> > > to do connection confirmation without going directly through nfhook with INPUT.
> > > I can help with some hints if you are interested.
> >
> > You stated this patch isn't acceptable because NF_HOOK is called even when
> > End behavior is processing, aren't you? 
> 
> Yes, since the SRv6 processing (seg6_local) is applied to traffic with DAs not
> necessarily associated with local addresses, it should not pass through INPUT.

See below.

> > So, do you think it’s natural that
> > NF_HOOK is called *only* when SRv6 behavior is encap/decap operation. The
> > problem I stated first is that netfilter couldn't track inner flows of
> > SRv6-encapsulated packets regardless of the status of IPv6 conntrack. If
> > yes, I will fix and resubmit patch.
> >
> 
> Let's consider encap/decap operation. The first important consideration is that
> encap and decap are two different beasts.
> 
> Encap (T.Encap) is done in seg6_input (seg6_iptunnel) when a packet is
> received on the IPv6 receive path and in seg6_output if the packet to be
> encapsulated is locally generated.
> Then you will have decap operations that are performed in seg6_local, according
> to several different decap behaviors.
> 
> For the moment, let's consider the encap operation applied to a packet received
> on the IPv6 receive path. If your plan is to call NF_HOOK set on OUTPUT, you
> will have a similar problem to what I have already described for
> seg6_local_input (seg6_local). However, this time the OUTPUT is involved rather
> than the INPUT.

If this is a real concern, then it should be to possible to add new
hooks such as NF_INET_LWT_LOCAL_IN and NF_INET_LWT_LOCAL_OUT, and extend
conntrack to also register handlers for those new hooks.

> The SRv6 encap operation (seg6_input) for packets received on the IPv6 receive
> path has been designed and implemented so that packets are not steered through
> the OUTPUT. For this reason, if you change this design you will cause:
> 
>  1) possible traffic loss due to some already existing policies in OUTPUT.
>     In other words you will break existing working configuration;
>
>  2) a performance drop in SRv6 encapsulation, which I have measured below.
> 
> ---
> 
> I set up a testbed with the purpose of quickly and preliminarily testing the
> performance (throughput) of a couple of patched processing functions you
> proposed:
> 
>   i) SRv6 End (since the seg6_local_input function was patched);
> 
>  ii) SRv6 T.Encap (seg6_iptunnel).
> 
> 
> The following scenarios were tested:
> 
>  1.a) vanilla kernel with a single SRv6 End Behavior and only 1 ip6tables
>       (filter) rule to fill the INPUT (although not necessary, see below);
>  
>  1.b) vanilla kernel with a single SRv6 T.Encap and 0 ip6tables (filter)
>       rules on OUTPUT;
> 
>  2.a) patched kernel with a single SRv6 End Behavior and only 1 ip6tables
>       (filter) rule in INPUT to do accept (necessary to accept the SID);
>  
>  2.b) patched kernel with a single SRv6 T.Encap and 0 ip6tables (filter)
>       rules on OUTPUT.

This is not correct, you are evaluating here the cost of the
filtering, not the cost of the new hooks. If your concern that the new
hooks might slow down the IPv6 SRv6 datapath, then you should repeat
your experiment with and without the patch that adds the hooks.

And you should also provide more information on how you're collecting
any performance number to allow us to scrutinize that your performance
evaluation is correct.

Thanks.
