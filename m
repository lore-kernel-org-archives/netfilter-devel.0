Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C786BC19F2B
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Aug 2022 11:02:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239543AbiHDLCI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 4 Aug 2022 07:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239590AbiHDLBh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 Aug 2022 07:01:37 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C7D1167CA3
        for <netfilter-devel@vger.kernel.org>; Thu,  4 Aug 2022 04:01:25 -0700 (PDT)
Date:   Thu, 4 Aug 2022 13:01:17 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v2 0/8] really handle stacked l2 headers
Message-ID: <Yuum/f/DPpnbawkX@salvia>
References: <20220801135633.5317-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220801135633.5317-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian,

On Mon, Aug 01, 2022 at 03:56:25PM +0200, Florian Westphal wrote:
> v2:
> - fix a UAF during rule listing.  When OP_AND gets culled,
>   'expr' is free'd as well ahead of time because they alias one
>   another in the set key case (there is no compare/relational op).
> - add and handle plain 'vlan id' in a set key.
>   in v1, this would be shown with the '& 0xfff' included, because
>   v1 only removed OP_AND in concatenations.
> 
> Eric Garver reported a number of issues when matching vlan headers:
> 
> In:  update @macset { ether saddr . vlan id timeout 5s }
> Out: update @macset { @ll,48,48 . @ll,112,16 & 0xfff timeout 5s }
> 
> This is because of amnesia in nft during expression decoding:
> When we encounter 'vlan id', the L2 protocl (ethernet) is replaced by
> vlan, so we attempt to match @ll,48,48 vs. the vlan header and come up
> empty.
> 
> The vlan decode fails because we can't handle '& 0xfff' in this
> instance, so we can locate the right offset but the payload expression
> length doesn't match the template length (16 vs 12 bits).
> 
> 
> The main patch is patch 3, which adds a stack of l2 protocols to track
> instead of only keeping the cumulative size.
> 
> The latter is ok for serialization (we have the expression tree, so its
> enough to add the size of the 'previous' l2 headers to payload
> expressions that match the new 'top' l2 header.
> 
> But for deserialization, we need to be able to search all protocols base
> headers seen.
> 
> The remaining patches improve handling of 'integer base type'
> expressions and add test cases.

series LGTM.

A few more nits:

# cat test.nft
add table netdev x
add chain netdev x y
add rule netdev x y ip saddr 1.2.3.4 vlan id 10
# nft -f test.nft
test.nft:3:38-44: Error: conflicting protocols specified: ether vs. vlan
add rule netdev x y ip saddr 1.2.3.4 vlan id 10
                                     ^^^^^^^

it also occurs here:

# cat test.nft
add table netdev x
add chain netdev x y
add set netdev x macset { typeof ip saddr . vlan id; flags dynamic,timeout; }
add rule netdev x y update @macset { ip saddr . vlan id }
# nft -f test.nft
test.nft:4:49-55: Error: conflicting protocols specified: ether vs. vlan
add rule netdev x y update @macset { ip saddr . vlan id }
                                                ^^^^^^^

This is related to an implicit ether dependency.

If you see a way to fix this incrementally, I'm fine with you pushing
out this series and then you follow up.

Another issue: probably it would make sense to bail out when trying to
use 'vlan id' (and any other vlan fields) from ip/ip6/inet families?
vlan_do_receive() sets skb->dev to the vlan device, and the vlan
fields in the skbuff are cleared. In iptables, there is not vlan match
for this reason.
