From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nftables-kernel PATCH] netfilter: nftables: Fix sparse
 endianness issue on nft_nat.c
Date: Mon, 28 Oct 2013 09:41:11 +0000
Message-ID: <20131028094111.GA9725@macbook.localnet>
References: <1382086853-14251-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37509 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756119Ab3J1JlP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Oct 2013 05:41:15 -0400
Content-Disposition: inline
In-Reply-To: <1382086853-14251-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 18, 2013 at 12:00:53PM +0300, Tomasz Bursztyka wrote:
> Fixes this:
> 
> CHECK   net/netfilter/nft_nat.c
> net/netfilter/nft_nat.c:50:43: warning: incorrect type in assignment (different base types)
> net/netfilter/nft_nat.c:50:43:    expected restricted __be32 [addressable] [usertype] ip
> net/netfilter/nft_nat.c:50:43:    got unsigned int [unsigned] [usertype] <noident>
> net/netfilter/nft_nat.c:51:43: warning: incorrect type in assignment (different base types)
> net/netfilter/nft_nat.c:51:43:    expected restricted __be32 [addressable] [usertype] ip
> net/netfilter/nft_nat.c:51:43:    got unsigned int [unsigned] [usertype] <noident>
> net/netfilter/nft_nat.c:65:37: warning: incorrect type in assignment (different base types)
> net/netfilter/nft_nat.c:65:37:    expected restricted __be16 [addressable] [assigned] [usertype] all
> net/netfilter/nft_nat.c:65:37:    got unsigned int [unsigned] <noident>
> net/netfilter/nft_nat.c:66:37: warning: incorrect type in assignment (different base types)
> net/netfilter/nft_nat.c:66:37:    expected restricted __be16 [addressable] [assigned] [usertype] all
> net/netfilter/nft_nat.c:66:37:    got unsigned int [unsigned] <noident>
> 
> Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
> ---
> 
> Hi,
> 
> looks a bit ugly, would there be another way to fix this?
> 
> Tomasz
> 
>  net/netfilter/nft_nat.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
> index b0b87b2..f9d488f 100644
> --- a/net/netfilter/nft_nat.c
> +++ b/net/netfilter/nft_nat.c
> @@ -47,8 +47,12 @@ static void nft_nat_eval(const struct nft_expr *expr,
>  	memset(&range, 0, sizeof(range));
>  	if (priv->sreg_addr_min) {
>  		if (priv->family == AF_INET) {
> -			range.min_addr.ip = data[priv->sreg_addr_min].data[0];
> -			range.max_addr.ip = data[priv->sreg_addr_max].data[0];
> +			range.min_addr.ip =
> +				be32_to_cpup((__be32 *)
> +					data[priv->sreg_addr_min].data);
> +			range.max_addr.ip =
> +				be32_to_cpup((__be32 *)
> +					data[priv->sreg_addr_max].data);

That doesn't seem correct, we don't want to actually switch the byteorder of
the data. I'd suggest to simply use (__force __be32).
