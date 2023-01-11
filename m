Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F1BEC5479D
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Jan 2023 18:21:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238692AbjAKSV4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Jan 2023 13:21:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231972AbjAKSVT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Jan 2023 13:21:19 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6F7C0638D
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Jan 2023 10:21:13 -0800 (PST)
Date:   Wed, 11 Jan 2023 19:21:09 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Jeremy Sowden <jeremy@azazel.net>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [libnetfilter_conntrack PATCH] conntrack: increase the length of
 `l4proto_map`
Message-ID: <Y77+FQ06j+gRFURI@salvia>
References: <20221223123806.2685611-1-jeremy@azazel.net>
 <Y7758rNEafF9XurG@salvia>
 <20230111180818.GD27644@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230111180818.GD27644@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jan 11, 2023 at 07:08:18PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Fri, Dec 23, 2022 at 12:38:06PM +0000, Jeremy Sowden wrote:
> > > With addition of MPTCP `IPPROTO_MAX` is greater than 256, so extend the
> > > array to account for the new upper bound.
> > 
> > Applied, thanks.
> > 
> > I don't expect we will ever see IPPROTO_MPTCP in this path though.
> > To my understanding, this definition is targeted at the
> > setsockopt/getsockopt() use-case. IP headers and the ctnetlink
> > interface also assumes 8-bits protocol numbers.
> 
> Yes, this is an uapi thing:
> 
> socket(AF_INET, SOCK_STREAM, IPPROTO_TCP); vs.
> socket(AF_INET, SOCK_STREAM, IPPROTO_MPTCP);
> 
> Only second version results in a multipath-tcp aware socket.
> 
> If mptcp is active (both peers need to support it), tcp frames will
> have an 'mptcp' option, but its still tcp (6) on wire.

Thanks for confirming.

Probably I'll post a patch to add an internal __IPPROTO_MAX definition
that sticks to 255, so libnetfilter_conntrack maps don't start
increasing if more IPPROTO_* definitions show up in the future for the
setsockopt/getsockopt interface.
