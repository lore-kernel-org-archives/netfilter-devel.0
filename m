Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B8E6C19F2B
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Aug 2022 11:07:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239251AbiHDLHQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 4 Aug 2022 07:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233704AbiHDLHP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 Aug 2022 07:07:15 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 360BE5925D
        for <netfilter-devel@vger.kernel.org>; Thu,  4 Aug 2022 04:07:13 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1oJYh5-0003wk-Ff; Thu, 04 Aug 2022 13:07:11 +0200
Date:   Thu, 4 Aug 2022 13:07:11 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v2 0/8] really handle stacked l2 headers
Message-ID: <20220804110711.GC2741@breakpoint.cc>
References: <20220801135633.5317-1-fw@strlen.de>
 <Yuum/f/DPpnbawkX@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yuum/f/DPpnbawkX@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> series LGTM.
> 
> A few more nits:
> 
> # cat test.nft
> add table netdev x
> add chain netdev x y
> add rule netdev x y ip saddr 1.2.3.4 vlan id 10
> # nft -f test.nft
> test.nft:3:38-44: Error: conflicting protocols specified: ether vs. vlan
> add rule netdev x y ip saddr 1.2.3.4 vlan id 10
>                                      ^^^^^^^

But thats not a regression, right?

> # cat test.nft
> add table netdev x
> add chain netdev x y
> add set netdev x macset { typeof ip saddr . vlan id; flags dynamic,timeout; }
> add rule netdev x y update @macset { ip saddr . vlan id }
> # nft -f test.nft
> test.nft:4:49-55: Error: conflicting protocols specified: ether vs. vlan
> add rule netdev x y update @macset { ip saddr . vlan id }
>                                                 ^^^^^^^
> 
> This is related to an implicit ether dependency.

Yes, it needs two implcit deps.

> If you see a way to fix this incrementally, I'm fine with you pushing
> out this series and then you follow up.

OK, will do that then.

> Another issue: probably it would make sense to bail out when trying to
> use 'vlan id' (and any other vlan fields) from ip/ip6/inet families?
> vlan_do_receive() sets skb->dev to the vlan device, and the vlan
> fields in the skbuff are cleared. In iptables, there is not vlan match
> for this reason.

Thanks for the hint.  Right, so it makes sense to refuse the implcit dep
and/or reject it from eval phase.

I will have a look next week.
