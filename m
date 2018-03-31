From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 04/12] bridge: netfilter: Use the new global
 ether_<foo>_addr arrays
Date: Sat, 31 Mar 2018 20:28:10 +0200
Message-ID: <20180331182810.or7attmfpjxw4sfm@salvia>
References: <cover.1522479607.git.joe@perches.com>
 <df70bafdca663db034626f4f1525826ea263bf2c.1522479607.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Joe Perches <joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <df70bafdca663db034626f4f1525826ea263bf2c.1522479607.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Joe,

On Sat, Mar 31, 2018 at 12:05:19AM -0700, Joe Perches wrote:
> Remove the local consts and use the new globals.

This one is already upstream:

https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git/commit/?id=9124a20d8794663a396b5d6f91f66903848a042b

I can see you're using is_broadcast_ether_addr(e->destmsk) in this new
version, we would need an incremental version.

Thanks.

> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  net/bridge/netfilter/ebt_stp.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/net/bridge/netfilter/ebt_stp.c b/net/bridge/netfilter/ebt_stp.c
> index 3140eb912d7e..2b7479cc0140 100644
> --- a/net/bridge/netfilter/ebt_stp.c
> +++ b/net/bridge/netfilter/ebt_stp.c
> @@ -153,8 +153,6 @@ ebt_stp_mt(const struct sk_buff *skb, struct xt_action_param *par)
>  static int ebt_stp_mt_check(const struct xt_mtchk_param *par)
>  {
>  	const struct ebt_stp_info *info = par->matchinfo;
> -	const u8 bridge_ula[6] = {0x01, 0x80, 0xc2, 0x00, 0x00, 0x00};
> -	const u8 msk[6] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
>  	const struct ebt_entry *e = par->entryinfo;
>  
>  	if (info->bitmask & ~EBT_STP_MASK || info->invflags & ~EBT_STP_MASK ||
> @@ -162,8 +160,8 @@ static int ebt_stp_mt_check(const struct xt_mtchk_param *par)
>  		return -EINVAL;
>  	/* Make sure the match only receives stp frames */
>  	if (!par->nft_compat &&
> -	    (!ether_addr_equal(e->destmac, bridge_ula) ||
> -	     !ether_addr_equal(e->destmsk, msk) ||
> +	    (!ether_addr_equal(e->destmac, ether_stp_addr) ||
> +	     !ether_addr_equal(e->destmsk, ether_broadcast_addr) ||
>  	     !(e->bitmask & EBT_DESTMAC)))
>  		return -EINVAL;
>  
> -- 
> 2.15.0
> 
