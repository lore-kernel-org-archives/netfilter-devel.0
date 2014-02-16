From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: nf_tables: check if payload offset is a power
 of 2
Date: Sun, 16 Feb 2014 12:27:15 +0000
Message-ID: <20140216122714.GB6769@macbook.localnet>
References: <1392551680-31543-1-git-send-email-nikolay@redhat.com>
 <20140216120714.GA6769@macbook.localnet>
 <5300AA87.4030001@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Nikolay Aleksandrov <nikolay@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39439 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbaBPM1T (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Feb 2014 07:27:19 -0500
Content-Disposition: inline
In-Reply-To: <5300AA87.4030001@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Feb 16, 2014 at 01:09:43PM +0100, Nikolay Aleksandrov wrote:
> On 02/16/2014 01:07 PM, Patrick McHardy wrote:
> > On Sun, Feb 16, 2014 at 12:54:40PM +0100, Nikolay Aleksandrov wrote:
> >> Add a check if payload's offset is a power of 2 when selecting ops.
> >> The fast ops were meant for well aligned offsets, also this fixes a
> >> small bug when using unaligned offset and length of 3 which causes
> >> only 1 byte to be loaded because the fast ops are chosen.
> >>
> >> Signed-off-by: Nikolay Aleksandrov <nikolay@redhat.com>
> >> ---
> >> I broke the line since it was >80 chars.
> >> This patch applies to Dave's -net tree.
> >>
> >>  net/netfilter/nft_payload.c | 4 +++-
> >>  1 file changed, 3 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
> >> index a2aeb31..15a3dcb 100644
> >> --- a/net/netfilter/nft_payload.c
> >> +++ b/net/netfilter/nft_payload.c
> >> @@ -135,7 +135,9 @@ nft_payload_select_ops(const struct nft_ctx *ctx,
> >>  	if (len == 0 || len > FIELD_SIZEOF(struct nft_data, data))
> >>  		return ERR_PTR(-EINVAL);
> >>  
> >> -	if (len <= 4 && IS_ALIGNED(offset, len) && base != NFT_PAYLOAD_LL_HEADER)
> >> +	if (len <= 4 && IS_ALIGNED(offset, len) &&
> >> +	    base != NFT_PAYLOAD_LL_HEADER &&
> >> +	    !(offset & (offset - 1)))
> > 
> > Small cosmetic note: we have is_power_of_2(), which does exactly this.
> > 
> I didn't choose is_power_of_2 because it also checks if x is != 0, so I
> thought we can allow for 0 offset with the fast ops.

Sorry for not noticing before, but I'd propose to check length for power
of two. We're trying to determine whether the load is well aligned.

> 
> > Also I think the more logical order would be:
> > 
> > len <= 4 && is_power_of_2 && IS_ALIGNED && base ...
> > 
> Okay :-)
> 
> >>  		return &nft_payload_fast_ops;
> >>  	else
> >>  		return &nft_payload_ops;
> >> -- 
> >> 1.8.4.2
