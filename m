Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16DC3C433FE
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Nov 2022 14:00:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbiKBOAj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Nov 2022 10:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbiKBOAh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Nov 2022 10:00:37 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB7E5DF71
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Nov 2022 07:00:28 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1oqEI5-0003nX-4t; Wed, 02 Nov 2022 15:00:25 +0100
Date:   Wed, 2 Nov 2022 15:00:25 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Cc:     Florian Westphal <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        kernel test robot <lkp@intel.com>,
        "claudio.porfiri@ericsson.com" <claudio.porfiri@ericsson.com>
Subject: Re: [PATCH v2 1/2] netfilter: conntrack: introduce no_random_port
 proc entry
Message-ID: <20221102140025.GF5040@breakpoint.cc>
References: <20221030122541.31354-1-sriram.yagnaraman@est.tech>
 <20221030122541.31354-2-sriram.yagnaraman@est.tech>
 <20221031083858.GB5040@breakpoint.cc>
 <7c24bfe4-94be-6eab-d30a-6dc0500652da@est.tech>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7c24bfe4-94be-6eab-d30a-6dc0500652da@est.tech>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Sriram Yagnaraman <sriram.yagnaraman@est.tech> wrote:
> On 2022-10-31 09:38, Florian Westphal wrote:
> 
> > sriram.yagnaraman@est.tech <sriram.yagnaraman@est.tech> wrote:
> >> From: Sriram Yagnaraman <sriram.yagnaraman@est.tech>
> >>
> >> This patch introduces a new proc entry to disable source port
> >> randomization for SCTP connections.
> > Hmm.  Can you elaborate?  The sport is never randomized, unless either
> > 1. User explicitly requested it via "random" flag passed to snat rule, or
> > 2. the is an existing connection, using the *same* sport:saddr -> daddr:dport
> >    quadruple as the new request.
> >
> > In 2), this new toggle prevents communication.  So I wonder why ...
> 
> Thank you so much for the detailed review comments.
> 
> My use case for this flag originates from a deployment of SCTP client
> endpoints on docker/kubernetes environments, where typically there exists
> SNAT rules for the endpoints on egress. The *user* in this case are the
> CNI plugins that configure the SNAT rules, and some of the most common
> plugins use --random-fully regardless of the protocol.
> 
> Consider an SCTP association A -> B, which has two paths via NAT A and B
> A: 1.2.3.4:12345
> B: 5.6.7.8/9:42
> NAT A: 1.2.31.4 (used for path towards 5.6.7.8)
> NAT B: 1.2.32.4 (used for path towards 5.6.7.9)
> 
>               ┌───────┐   ┌───┐
>            ┌──► NAT A ├───►   │
>  ┌─────┐   │  └───────┘   │   │
>  │  A  ├───┤              │ B │
>  └─────┘   │  ┌───────┐   │   │
>            └──► NAT B ├───►   │
>               └───────┘   └───┘
> 
> Let us assume in NAT A (1.2.31.4), the connections is setup as
> 	ORIGINAL TUPLE		    REPLY TUPLE
> 1.2.3.4:12345 -> 5.6.7.8:42, 5.6.7.8.42 -> 1.2.31.4:33333
> 
> Let us assume in NAT B (1.2.32.4), the connections is setup as
> 	ORIGINAL TUPLE		    REPLY TUPLE
> 1.2.3.4:12345 -> 5.6.7.9:42, 5.6.7.8.42 -> 1.2.32.4:44444
> 
> Since the port numbers are different when viewed from B, the association
> will not become multihomed, with only the primary path being active.
> Moreover, on a NAT/middlebox restart, we will end up getting new ports.
>
> I understand this is a problem in the way SNAT rules are configured, my
> proposal was to have this flag as a means of preventing such a problem
> even if the user wanted to.

Ugh, sorry, but that sounds just wrong.

> >> As specified in RFC9260 all transport addresses used by an SCTP endpoint
> >> MUST use the same port number but can use multiple IP addresses. That
> >> means that all paths taken within an SCTP association should have the
> >> same port even if they pass through different NAT/middleboxes in the
> >> network.

Hmm, I don't understand WHY this requirement exists, since endpoints
cannot control source port (or source address) seen by the peer;
NAT won't go away.

I read that snippet several times and its not clear to me if
"port number" refers to sport or dport.  Dport would make sense to me,
but sport...?  No, not really.

Won't the endpoints notice that the path is down and re-create the flow?

AFAIU the root cause of your problem is that:
1. NAT middleboxes remap source port AND
2. NAT middleboxes restart frequently

... so fixing either 1 or 2 would avoid the problem.

I don't think adding sysctls to override 1) is a sane option.

> Since the flag is optional, the idea is to enable it only on hosts that
> are part of docker/kubernetes environments and use NAT in their datapath.

We can't fix the ruleset but we can somehow cure it via sysctl in each netns?
I don't like this.

NAT middlebox restart with --random is a problem in any case, not just
for SCTP, because the chosen "random port" is lost.

I don't see a way to fix this, unless NOT using --random mode.
If connection is subject to sequence number rewrite (for tcp)
the connection won't survive either as the sejadj state is lost.
