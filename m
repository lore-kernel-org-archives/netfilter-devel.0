From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next] netfilter: xt_quota: fix the behavior of
 xt_quota module
Date: Wed, 3 Oct 2018 11:19:41 +0200
Message-ID: <20181003091941.cbaceffk3uwrqwjo@salvia>
References: <1538443388-6881-1-git-send-email-chenbofeng.kernel@gmail.com>
 <1538443388-6881-3-git-send-email-chenbofeng.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        kernel-team@android.com, Lorenzo Colitti <lorenzo@google.com>,
        maze@google.com, Chenbo Feng <fengc@google.com>
To: Chenbo Feng <chenbofeng.kernel@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1538443388-6881-3-git-send-email-chenbofeng.kernel@gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Oct 01, 2018 at 06:23:08PM -0700, Chenbo Feng wrote:
[...]
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

Sorry, just noticed, one more question though:

Would this break backward compatibility with existing iptables 32-bits
binaries?

New kernel will hit size mismatch given that master pointer area used
to be 32-bits but now it is 64-bits long?

Let me know, thanks!
