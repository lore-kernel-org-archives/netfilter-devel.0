From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next] netfilter: xt_quota: fix the behavior of
 xt_quota module
Date: Tue, 2 Oct 2018 09:59:03 +0200
Message-ID: <20181002075903.3wpgej3j6dttbqck@salvia>
References: <1538443388-6881-1-git-send-email-chenbofeng.kernel@gmail.com>
 <1538443388-6881-3-git-send-email-chenbofeng.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        kernel-team@android.com, Lorenzo Colitti <lorenzo@google.com>,
        maze@google.com, Chenbo Feng <fengc@google.com>
To: Chenbo Feng <chenbofeng.kernel@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1538443388-6881-3-git-send-email-chenbofeng.kernel@gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

On Mon, Oct 01, 2018 at 06:23:08PM -0700, Chenbo Feng wrote:
> From: Chenbo Feng <fengc@google.com>
> 
> A major flaw of the current xt_quota module is that quota in a specific
> rule gets reset every time there is a rule change in the same table. It
> makes the xt_quota module not very useful in a table in which iptables
> rules are changed at run time. This fix introduces a new counter that is
> visible to userspace as the remaining quota of the current rule. When
> userspace restores the rules in a table, it can restore the counter to
> the remaining quota instead of resetting it to the full quota.

A few questions, see below.

First one is, don't we need a new match revision for this new option?

> Signed-off-by: Chenbo Feng <fengc@google.com>
> Suggested-by: Maciej Żenczykowski <maze@google.com>
> Reviewed-by: Maciej Żenczykowski <maze@google.com>
> ---
>  include/uapi/linux/netfilter/xt_quota.h |  8 +++--
>  net/netfilter/xt_quota.c                | 55 +++++++++++++--------------------
>  2 files changed, 27 insertions(+), 36 deletions(-)
> 
> diff --git a/include/uapi/linux/netfilter/xt_quota.h b/include/uapi/linux/netfilter/xt_quota.h
> index f3ba5d9..d72fd52 100644
> --- a/include/uapi/linux/netfilter/xt_quota.h
> +++ b/include/uapi/linux/netfilter/xt_quota.h
> @@ -15,9 +15,11 @@ struct xt_quota_info {
>  	__u32 flags;
>  	__u32 pad;
>  	__aligned_u64 quota;
> -
> -	/* Used internally by the kernel */
> -	struct xt_quota_priv	*master;
> +#ifdef __KERNEL__
> +	atomic64_t counter;
> +#else
> +	__aligned_u64 remain;
> +#endif
>  };
>  
>  #endif /* _XT_QUOTA_H */
> diff --git a/net/netfilter/xt_quota.c b/net/netfilter/xt_quota.c
> index 10d61a6..6afa7f4 100644
> --- a/net/netfilter/xt_quota.c
> +++ b/net/netfilter/xt_quota.c
> @@ -11,11 +11,6 @@
>  #include <linux/netfilter/xt_quota.h>
>  #include <linux/module.h>
>  
> -struct xt_quota_priv {
> -	spinlock_t	lock;
> -	uint64_t	quota;
> -};
> -
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Sam Johnston <samj@samj.net>");
>  MODULE_DESCRIPTION("Xtables: countdown quota match");
> @@ -26,54 +21,48 @@ static bool
>  quota_mt(const struct sk_buff *skb, struct xt_action_param *par)
>  {
>  	struct xt_quota_info *q = (void *)par->matchinfo;
> -	struct xt_quota_priv *priv = q->master;
> +	u64 current_count = atomic64_read(&q->counter);
>  	bool ret = q->flags & XT_QUOTA_INVERT;
> -
> -	spin_lock_bh(&priv->lock);
> -	if (priv->quota >= skb->len) {
> -		priv->quota -= skb->len;
> -		ret = !ret;
> -	} else {
> -		/* we do not allow even small packets from now on */
> -		priv->quota = 0;
> -	}
> -	spin_unlock_bh(&priv->lock);
> -
> -	return ret;
> +	u64 old_count, new_count;
> +
> +	do {
> +		if (current_count == 1)
> +			return ret;

So 1 means, don't keep updating, quota is depleted?

This current_count = 1 would be exposed to userspace too, right?

Hm, this semantics are going to be a bit awkwards to users I think, I
would prefer to expose this in a different way.

> +		if (current_count <= skb->len) {
> +			atomic64_set(&q->counter, 1);
> +			return ret;
> +		}
> +		old_count = current_count;
> +		new_count = current_count - skb->len;
> +		current_count = atomic64_cmpxchg(&q->counter, old_count,
> +						 new_count);
> +	} while (current_count != old_count);

Probably we simplify this via atomic64_add_return()?

I guess problem is userspace may get a current counter that is larger
than the quota, but we could handle this from userspace iptables to
print a value that equals the quota, ie. from userspace, before
printing:

        if (consumed > quota)
                printf("--consumed %PRIu64 ", quota);
        else
                printf("--consumed %PRIu64 ", consumed);

> +	return !ret;
>  }

Thanks !
