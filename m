From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] ulog: add protection when remove ipt_ULOG
Date: Thu, 7 Feb 2013 19:27:08 +0100
Message-ID: <20130207182708.GA18328@localhost>
References: <1360029450-6673-1-git-send-email-gaofeng@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Gao feng <gaofeng@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slan-550-85.anhosting.com ([174.127.110.175]:61057 "EHLO
	slan-550-85.anhosting.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758690Ab3BGS1N (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Feb 2013 13:27:13 -0500
Content-Disposition: inline
In-Reply-To: <1360029450-6673-1-git-send-email-gaofeng@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Gao,

On Tue, Feb 05, 2013 at 09:57:30AM +0800, Gao feng wrote:
> We should add a lock protection when we free the skb,
> because it maybe used by ipt_ulog_packet right now.

Did you hit a reproducible crash?

I think this is very unlikely to happen. The removal of the module
happens in user-context and the entire path to build and deliver the
skb to user-space is protected is under spin_lock_bh, so scheduling
is not possible.

> Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
> ---
>  net/ipv4/netfilter/ipt_ULOG.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
> index b5ef3cb..b390002 100644
> --- a/net/ipv4/netfilter/ipt_ULOG.c
> +++ b/net/ipv4/netfilter/ipt_ULOG.c
> @@ -430,11 +430,12 @@ static void __exit ulog_tg_exit(void)
>  			pr_debug("timer was pending, deleting\n");
>  			del_timer(&ub->timer);
>  		}
> -
> +		spin_lock_bh(&ulog_lock);
>  		if (ub->skb) {
>  			kfree_skb(ub->skb);
>  			ub->skb = NULL;
>  		}
> +		spin_unlock_bh(&ulog_lock);
>  	}
>  }
>  
> -- 
> 1.7.11.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
