Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5B56C07E99
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Jul 2021 23:31:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B00B60FF2
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Jul 2021 23:31:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbhGLXel (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 12 Jul 2021 19:34:41 -0400
Received: from smtp.uniroma2.it ([160.80.6.16]:46572 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230132AbhGLXel (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Jul 2021 19:34:41 -0400
Received: from smtpauth-2019-1.uniroma2.it (smtpauth.uniroma2.it [160.80.5.46])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 16CNVLWO017330;
        Tue, 13 Jul 2021 01:31:26 +0200
Received: from lubuntu-18.04 (unknown [160.80.103.126])
        by smtpauth-2019-1.uniroma2.it (Postfix) with ESMTPSA id 048F0121E39;
        Tue, 13 Jul 2021 01:31:16 +0200 (CEST)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=uniroma2.it;
        s=ed201904; t=1626132677; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=13RlklJGaBbtlvNb0PZ6ENCr2Y1TDAjiFCxsUQfAVkw=;
        b=T/Wo5gkQunv+bLaM027yoTrt87bn1mc3oZ8MA6tIkO6QlnR1d39zWSy62RIviwEp5rdBCU
        D4eyaP5E9msup0Cg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniroma2.it; s=rsa201904;
        t=1626132677; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=13RlklJGaBbtlvNb0PZ6ENCr2Y1TDAjiFCxsUQfAVkw=;
        b=TeuDsdezM9BJQhSaTQjoAAiFYpVQuAXgsRLHwqV30EmpHLxW7nN1jb0De1tFmyoIRvn3xZ
        bvsjrZcFWZwkpEaBjKCGN8TfWOKxHeuN41DGyIyfo6fvmIcbr9Qn0MT8Y+iNdnB0d180Pn
        LFv+JtWkBwAqphb9BnvrIruSyKXtpRljhS6M2i5i/rvCJImo/+A57SNuo9Iu8qig6pwiiw
        46Kv8vjoOHyNguAo8iltE22zxBTHZL8muhIj52bhA6MAt692dkU0tNUG5w8f8PtlmoJ7cM
        bz7EHKFuCnukhoybF5s+xYY5SNhD9ER6EsWflMDXyrswjBVfgr1DNgtrXh2GtA==
Date:   Tue, 13 Jul 2021 01:31:16 +0200
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     Ryoga Saito <proelbtn@gmail.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netfilter-devel@vger.kernel.org,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: Re: [PATCH] net: Add netfilter hooks to track SRv6-encapsulated
 flows
Message-Id: <20210713013116.441cc6015af001c4df4f16b0@uniroma2.it>
In-Reply-To: <FEF1CBA8-62EC-483A-B7CA-50973020F27B@gmail.com>
References: <20210706052548.5440-1-proelbtn@gmail.com>
        <20210708033138.ef3af5a724d7b569c379c35e@uniroma2.it>
        <20210708133859.GA6745@salvia>
        <20210708183239.824f8e1ed569b0240c38c7a8@uniroma2.it>
        <CALPAGbJt_rb_r3M2AEJ_6VRsG+zXrEOza0U-6SxFGsERGipT4w@mail.gmail.com>
        <8EFE7482-6E0E-4589-A9BE-F7BC96C7876E@gmail.com>
        <20210709204851.90b847c71760aa40668a0971@uniroma2.it>
        <FEF1CBA8-62EC-483A-B7CA-50973020F27B@gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Ryoga,
Thanks for considering my points.

Please, see below for my answers.

> On Sun, 11 Jul 2021 16:12:48 +0900
> Ryoga Saito <proelbtn@gmail.com> wrote:

> >
> > No, this is a way to fix the problem that you introduce by changing the current
> > srv6local forwarding model. If you have 100 End SIDs should you add 100 accept
> > rules? The root problem is that SRv6 (srv6local) traffic should not go through
> > the INPUT path.
>
> No, you only need to add single rule for accepting these SIDs. Here is the
> quote of RFC 8986.
>
> ---
> This document defines an SRv6 SID as consisting of LOC:FUNCT:ARG, where
> a locator (LOC) is encoded in the L most significant bits of the SID,
> followed by F bits of function (FUNCT) and A bits of arguments (ARG). L,
> the locator length, is flexible, and an operator is free to use the locator
> length of their choice. F and A may be any value as long as L+F+A <= 128.
> When L+F+A is less than 128, then the remaining bits of the SID MUST be
> zero.
>
> A locator may be represented as B:N where B is the SRv6 SID block (IPv6
> prefix allocated for SRv6 SIDs by the operator) and N is the identifier of
> the parent node instantiating the SID.
>
> When the LOC part of the SRv6 SIDs is routable, it leads to the node, which
> instantiates the SID.
> ---
>
> If there are 100 SIDs, but these SIDs are for the same node, the locators
> of these SIDs also should be same. so, you can allow SRv6 flows by adding
> only single rule.

No, you cannot rely on this assumption.
Operators can choose to assign different locators to the same node.
The document you mention does not prescribe how the SIDs should be allocated on
the nodes, nor whether they should be part of one or more locators.
Consequently, no one imposes on us that those 100 SIDs must belong all to the
same locator.


> > Have you set the traffic to flow through INPUT to confirm a connection (for
> > conntrack)? If this is the only reason, before changing the srv6local
> > processing model in such a disruptive way, you can investigate different ways
> > to do connection confirmation without going directly through nfhook with INPUT.
> > I can help with some hints if you are interested.
>
> You stated this patch isn't acceptable because NF_HOOK is called even when
> End behavior is processing, aren't you? 

Yes, since the SRv6 processing (seg6_local) is applied to traffic with DAs not
necessarily associated with local addresses, it should not pass through INPUT.


> So, do you think it’s natural that
> NF_HOOK is called *only* when SRv6 behavior is encap/decap operation. The
> problem I stated first is that netfilter couldn't track inner flows of
> SRv6-encapsulated packets regardless of the status of IPv6 conntrack. If
> yes, I will fix and resubmit patch.
>

Let's consider encap/decap operation. The first important consideration is that
encap and decap are two different beasts.

Encap (T.Encap) is done in seg6_input (seg6_iptunnel) when a packet is
received on the IPv6 receive path and in seg6_output if the packet to be
encapsulated is locally generated.
Then you will have decap operations that are performed in seg6_local, according
to several different decap behaviors.

For the moment, let's consider the encap operation applied to a packet received
on the IPv6 receive path. If your plan is to call NF_HOOK set on OUTPUT, you
will have a similar problem to what I have already described for
seg6_local_input (seg6_local). However, this time the OUTPUT is involved rather
than the INPUT.

The SRv6 encap operation (seg6_input) for packets received on the IPv6 receive
path has been designed and implemented so that packets are not steered through
the OUTPUT. For this reason, if you change this design you will cause: 

 1) possible traffic loss due to some already existing policies in OUTPUT.
    In other words you will break existing working configuration;

 2) a performance drop in SRv6 encapsulation, which I have measured below.

---

I set up a testbed with the purpose of quickly and preliminarily testing the
performance (throughput) of a couple of patched processing functions you
proposed:

  i) SRv6 End (since the seg6_local_input function was patched);

 ii) SRv6 T.Encap (seg6_iptunnel).


The following scenarios were tested:

 1.a) vanilla kernel with a single SRv6 End Behavior and only 1 ip6tables
      (filter) rule to fill the INPUT (although not necessary, see below);
 
 1.b) vanilla kernel with a single SRv6 T.Encap and 0 ip6tables (filter)
      rules on OUTPUT;

 2.a) patched kernel with a single SRv6 End Behavior and only 1 ip6tables
      (filter) rule in INPUT to do accept (necessary to accept the SID);
 
 2.b) patched kernel with a single SRv6 T.Encap and 0 ip6tables (filter)
      rules on OUTPUT.

In 1.a and 2.a, I considered the *ideal* case where we have a single locator
and a single accept rule for the whole locator+SIDs. In the vanilla kernel this
is not necessary, but I wanted to simulate the presence of at least one INPUT
rule in both cases for being as fair as possible.
Indeed, in 2.a the accept rule is mandatory if the default policy in INPUT is
set to drop.

In 1.b and 2.b, I consider a use case where a SRv6 router can generate traffic
(of any kind) to communicate with another node in the network. Although this is
*not* often the case in reality, I considered the *ideal* situation where there
are no restrictions on OUTPUT at all.
However in the real world for case 2.b, we have to consider fixing OUTPUT
policies to handle the IPv6+SRH outer header in case there are some restrictions
on locally generated traffic by the router. Otherwise, this can break
configurations where OUTPUT policies are strict.


Results of tests run in the 4 scenarios:

  Achieved Throughput
  ===================
  1.a) avg. 939.34  kpps, std. dev. 1.09 kpps;
  1.b) avg. 1095.35 kpps, std. dev. 3.64 kpps;
  2.a) avg. 863.07  kpps, std. dev. 1.74 kpps;
  2.b) avg. 924.93  kpps, std. dev. 4.33 kpps.

The changes slowed down performance by about 8.1% in the case of SRv6 End
Behavior and 15.6% in the case of SRv6 T.Encap Behavior.

The performance drop is significant and is always experienced even when we are
not interested in tracking internal packets whatsoever.

I hope I have been of help.

Andrea
