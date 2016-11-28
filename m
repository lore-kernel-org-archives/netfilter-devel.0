From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next] netfilter: nft_fib: store loopback interface to
 dreg when rt is local
Date: Mon, 28 Nov 2016 13:25:07 +0100
Message-ID: <20161128122507.GB28510@breakpoint.cc>
References: <1479994128-16654-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org, fw@strlen.de,
        Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:35572 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754190AbcK1M2K (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Nov 2016 07:28:10 -0500
Content-Disposition: inline
In-Reply-To: <1479994128-16654-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Liping Zhang <zlpnobody@163.com> wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> In general, we haven't do routing lookup in PREROUTING hook, so it's
> very likely that fib4/6_is_local will not be met. Then the *dest will
> be set to 0 because we do nothing when the fib result is RTN_LOCAL.
> 
> So if the user want to drop all packets which cannot be routed,
> and input the following nft rule:
>   # nft add rule filter prerouting fib daddr oif eq 0 drop
> 
> Then all the packets which destinate to local will be dropped
> incorrectly.
> 
> Fixes: f6d0cbcf09c5 ("netfilter: nf_tables: add fib expression")
> Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
> ---
>  net/ipv4/netfilter/nft_fib_ipv4.c | 3 ++-
>  net/ipv6/netfilter/nft_fib_ipv6.c | 8 ++++++--
>  2 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
> index 2581363..2107775 100644
> --- a/net/ipv4/netfilter/nft_fib_ipv4.c
> +++ b/net/ipv4/netfilter/nft_fib_ipv4.c
> @@ -130,7 +130,8 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
>  	switch (res.type) {
>  	case RTN_UNICAST:
>  		break;
> -	case RTN_LOCAL:	/* should not appear here, see fib4_is_local() above */
> +	case RTN_LOCAL:
> +		nft_fib_store_result(dest, priv->result, pkt, LOOPBACK_IFINDEX);

Liping, what about doing:

	case RTN_LOCAL:
		if (priv->flags & NFTA_FIB_F_DADDR)
			nft_fib_store_result(dest, priv->result, pkt, LOOPBACK_IFINDEX);


AFAICS this will make above rule work while the saddr test will
still appear to not have a route at all.

What do you think?
