Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1B6BC636D6
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Feb 2023 11:37:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbjBVLhm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Feb 2023 06:37:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231185AbjBVLhl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Feb 2023 06:37:41 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA05F34C15
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Feb 2023 03:37:35 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pUnRD-0006cX-QV; Wed, 22 Feb 2023 12:37:31 +0100
Date:   Wed, 22 Feb 2023 12:37:31 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC nf-next PATCH] netfilter: nft: introduce broute chain type
Message-ID: <20230222113731.GE12484@breakpoint.cc>
References: <20230222110337.15951-1-sriram.yagnaraman@est.tech>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230222110337.15951-1-sriram.yagnaraman@est.tech>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Sriram Yagnaraman <sriram.yagnaraman@est.tech> wrote:
> Is there any interest or plan to implement BROUTE chain type for nftables?

I'm not aware of anyone working on broute for nftables.
Not sure a new chain type is good, it seems better to implement it via
a new expression.

> We have a situation when a network interface that is part of a bridge is
> used to receive PTP and/or EAPOL packets. Userspace daemons that use
> AF_PACKET to capture specific ether types do not receive the packets,
> and they are instead bridged. We are currently still using etables -t
> broute to send packets packets up the stack. This functionality seems to
> be missing in nftables. Below you can find a proposal that could be used,
> of course there is some work to introduce the chain type and a default
> priority in nftables userspace tool.

Can't you just override the destination mac to point to the bridge
device itself?

> I could see there are other users asking for BROUTE:
> [1]: https://bugzilla.netfilter.org/show_bug.cgi?id=1316
> [2]: https://lore.kernel.org/netfilter-devel/20191024114653.GU25052@breakpoint.cc/
> [3]: https://marc.info/?l=netfilter&m=154807010116514
> 
> broute chain type is just a copy from etables -t broute implementation.
> NF_DROP: skb is routed instead of bridged, and mapped to NF_ACCEPT.
> All other verdicts are returned as it is.
> 
> Please advise if there are better ways to solve this instead of using
> the br_netfilter_broute flag.

The br_netfilter_broute flag is required, but I don't like a new chain
type for this, nor keeping the drop/accept override.

I'd add a new "broute" expression that sets the flag in the skb cb
and sets NF_ACCEPT, useable in bridge family -- I think that this would
be much more readable.

As this expression would be very small I'd make it builtin if nftables
bridge support is enabled.
