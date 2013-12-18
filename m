From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] netfilter: xtables: add quota support to nfacct
Date: Wed, 18 Dec 2013 10:53:22 +0100
Message-ID: <20131218095322.GA4740@localhost>
References: <1386780798-24374-1-git-send-email-mathieu.poirier@linaro.org>
 <1386780798-24374-2-git-send-email-mathieu.poirier@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	john.stultz@linaro.org, jpa@google.com
To: mathieu.poirier@linaro.org
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1386780798-24374-2-git-send-email-mathieu.poirier@linaro.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Mathieu,

On Wed, Dec 11, 2013 at 09:53:18AM -0700, mathieu.poirier@linaro.org wrote:
> From: Mathieu Poirier <mathieu.poirier@linaro.org>
> 
> Adding packet and byte quota support.  Once a quota has been
> reached a noticifaction is sent to user space that includes
> the name of the accounting object along with the current byte
> and packet count.
> 
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> ---
>  include/linux/netfilter/nfnetlink_acct.h      |  4 ++
>  include/uapi/linux/netfilter/nfnetlink.h      |  2 +
>  include/uapi/linux/netfilter/nfnetlink_acct.h |  1 +
>  include/uapi/linux/netfilter/xt_nfacct.h      | 11 +++++
>  net/netfilter/Kconfig                         |  3 +-
>  net/netfilter/nfnetlink_acct.c                | 15 ++++++-
>  net/netfilter/xt_nfacct.c                     | 65 ++++++++++++++++++++++++++-
>  7 files changed, 97 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/netfilter/nfnetlink_acct.h b/include/linux/netfilter/nfnetlink_acct.h
> index bb4bbc9..46a9dda 100644
> --- a/include/linux/netfilter/nfnetlink_acct.h
> +++ b/include/linux/netfilter/nfnetlink_acct.h
> @@ -9,5 +9,9 @@ struct nf_acct;
>  extern struct nf_acct *nfnl_acct_find_get(const char *filter_name);
>  extern void nfnl_acct_put(struct nf_acct *acct);
>  extern void nfnl_acct_update(const struct sk_buff *skb, struct nf_acct *nfacct);
> +extern u64 nfnl_acct_get_pkts(struct nf_acct *acct);
> +extern u64 nfnl_acct_get_bytes(struct nf_acct *acct);
> +extern int nfnl_acct_fill_info(struct sk_buff *skb, u32 portid, u32 seq,
> +				u32 type, int event, struct nf_acct *acct);
>  
>  #endif /* _NFNL_ACCT_H */
> diff --git a/include/uapi/linux/netfilter/nfnetlink.h b/include/uapi/linux/netfilter/nfnetlink.h
> index 4a4efaf..e7e5851 100644
> --- a/include/uapi/linux/netfilter/nfnetlink.h
> +++ b/include/uapi/linux/netfilter/nfnetlink.h
> @@ -18,6 +18,8 @@ enum nfnetlink_groups {
>  #define NFNLGRP_CONNTRACK_EXP_UPDATE	NFNLGRP_CONNTRACK_EXP_UPDATE
>  	NFNLGRP_CONNTRACK_EXP_DESTROY,
>  #define NFNLGRP_CONNTRACK_EXP_DESTROY	NFNLGRP_CONNTRACK_EXP_DESTROY
> +	NFNLGRP_CONNTRACK_QUOTA,
> +#define NFNLGRP_CONNTRACK_QUOTA		NFNLGRP_CONNTRACK_QUOTA

Use NFNLGRP_ACCT_QUOTA, this has nothing to do with conntrack.

>  	__NFNLGRP_MAX,
>  };
>  #define NFNLGRP_MAX	(__NFNLGRP_MAX - 1)
> diff --git a/include/uapi/linux/netfilter/nfnetlink_acct.h b/include/uapi/linux/netfilter/nfnetlink_acct.h
> index c7b6269..ae8ea0a 100644
> --- a/include/uapi/linux/netfilter/nfnetlink_acct.h
> +++ b/include/uapi/linux/netfilter/nfnetlink_acct.h
> @@ -19,6 +19,7 @@ enum nfnl_acct_type {
>  	NFACCT_PKTS,
>  	NFACCT_BYTES,
>  	NFACCT_USE,
> +	NFACCT_QUOTA,
>  	__NFACCT_MAX
>  };
>  #define NFACCT_MAX (__NFACCT_MAX - 1)
> diff --git a/include/uapi/linux/netfilter/xt_nfacct.h b/include/uapi/linux/netfilter/xt_nfacct.h
> index 3e19c8a..c2e49a6 100644
> --- a/include/uapi/linux/netfilter/xt_nfacct.h
> +++ b/include/uapi/linux/netfilter/xt_nfacct.h
> @@ -3,11 +3,22 @@
>  
>  #include <linux/netfilter/nfnetlink_acct.h>
>  
> +enum xt_quota_flags {
> +	XT_QUOTA_INVERT    = 1 << 0,

I don't understand the interaction of invert and the event delivery.

> +	XT_QUOTA_PACKET    = 1 << 1,
> +	XT_QUOTA_QUOTA	   = 1 << 2,

XT_QUOTA_QUOTA ? :-)

I suggest XT_NFACCT_QUOTA_PKTS and XT_NFACCT_QUOTA_BYTES.

> +};
> +
>  struct nf_acct;
> +struct nf_acct_quota;
>  
>  struct xt_nfacct_match_info {
>  	char		name[NFACCT_NAME_MAX];
>  	struct nf_acct	*nfacct;
> +

You cannot add new field to this structure like this since it would
break backward compatibility. You have to add a v1 revision of this
structure, see net/netfilter/xt_NFQUEUE.c for instance on how to user
the iptables revision infrastructure.

> +	u_int8_t flags;

Better use __u32 for these flags to fill the hole.

> +	aligned_u64 quota;

Use __aligned_u64.

> +	struct nf_acct_quota	*priv;

This has to look like this:

/* Used internally by the kernel */
struct nf_acct_quota *priv __attribute__((aligned(8)));

But see below, I have a proposal to avoid this private area.

>  };
>  
>  #endif /* _XT_NFACCT_MATCH_H */
> diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
> index 6e839b6..aa635d8 100644
> --- a/net/netfilter/Kconfig
> +++ b/net/netfilter/Kconfig
> @@ -1056,7 +1056,8 @@ config NETFILTER_XT_MATCH_NFACCT
>  	select NETFILTER_NETLINK_ACCT
>  	help
>  	  This option allows you to use the extended accounting through
> -	  nfnetlink_acct.
> +	  nfnetlink_acct.  It is also possible to add quotas at the
> +	  packet and byte level.
>  
>  	  To compile it as a module, choose M here.  If unsure, say N.
>  
> diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
> index c7b6d46..20f1dad 100644
> --- a/net/netfilter/nfnetlink_acct.c
> +++ b/net/netfilter/nfnetlink_acct.c
> @@ -92,7 +92,7 @@ nfnl_acct_new(struct sock *nfnl, struct sk_buff *skb,
>  	return 0;
>  }
>  
> -static int
> +int
>  nfnl_acct_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
>  		   int event, struct nf_acct *acct)
>  {
> @@ -134,6 +134,7 @@ nla_put_failure:
>  	nlmsg_cancel(skb, nlh);
>  	return -1;
>  }
> +EXPORT_SYMBOL_GPL(nfnl_acct_fill_info);
>  
>  static int
>  nfnl_acct_dump(struct sk_buff *skb, struct netlink_callback *cb)
> @@ -336,6 +337,18 @@ void nfnl_acct_update(const struct sk_buff *skb, struct nf_acct *nfacct)
>  }
>  EXPORT_SYMBOL_GPL(nfnl_acct_update);
>  
> +u64 nfnl_acct_get_pkts(struct nf_acct *nfacct)
> +{
> +	return atomic64_read(&nfacct->pkts);
> +}
> +EXPORT_SYMBOL_GPL(nfnl_acct_get_pkts);
> +
> +u64 nfnl_acct_get_bytes(struct nf_acct *nfacct)
> +{
> +	return atomic64_read(&nfacct->bytes);
> +}
> +EXPORT_SYMBOL_GPL(nfnl_acct_get_bytes);

I think you can move the definition of struct nf_acct to
include/net/netfilter/nfnetlink_acct.h, so we don't need these
two exported symbols.

> +
>  static int __init nfnl_acct_init(void)
>  {
>  	int ret;
> diff --git a/net/netfilter/xt_nfacct.c b/net/netfilter/xt_nfacct.c
> index b3be0ef..6ed807c 100644
> --- a/net/netfilter/xt_nfacct.c
> +++ b/net/netfilter/xt_nfacct.c
> @@ -8,10 +8,14 @@
>   */
>  #include <linux/module.h>
>  #include <linux/skbuff.h>
> +#include <linux/spinlock.h>
>  
> +#include <net/netlink.h>
>  #include <linux/netfilter/x_tables.h>
>  #include <linux/netfilter/nfnetlink_acct.h>
> +#include <linux/netfilter/nfnetlink.h>
>  #include <linux/netfilter/xt_nfacct.h>
> +#include <linux/netfilter_ipv4/ipt_ULOG.h>
>  
>  MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
>  MODULE_DESCRIPTION("Xtables: match for the extended accounting infrastructure");
> @@ -19,13 +23,62 @@ MODULE_LICENSE("GPL");
>  MODULE_ALIAS("ipt_nfacct");
>  MODULE_ALIAS("ip6t_nfacct");
>  
> +struct nf_acct_quota {
> +	spinlock_t lock;

A spinlock to protect a boolean is rather expensive.

> +	bool quota_reached; /* true if quota has been reached. */

I think you can avoid this private area (including the spinlock) by
storing a copy of the packet/byte counter before calling
nfnl_acct_update(). Then if you note that old packet/byte counter was
below quota but new is overquota, then you have to send an event, ie.

        old_pkts = atomic64_read(info->nfacct->pkts);
        new_pkts = nfnl_acct_update(skb, info->nfacct, info->flags);
        if (old_pkts < info->quota && new_pkts > info->quota)
                send event

There's still one problem with this approach since it is racy, as it
may send several events, so you can refine it with:

        if (old_pkts < info->quota && new_pkts > info->quota
            && old_pkts + 1 == new_pkts)
                send event

You will need two different functions depending on the quota mode
(packet or bytes), and you will also need to modify nfnl_acct_update()
to return the new number of packets or bytes (depending on the flags),
you can use atomic_add_return and atomic_inc_return respectively to
retrieve the new (updated) value.

> +};
> +
> +static void nfacct_quota_log(struct nf_acct *cur,
> +			const struct sk_buff *skb)

Define this nfacct_quota_event function in nfnetlink_acct and export
it, thus, you don't need to export nfnl_acct_fill_info().

> +{
> +	int ret;
> +	struct sk_buff *skb2;
> +
> +	skb2 = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
                                             ^
This is called from interrupt context as well (input packets), this
has to be GFP_ATOMIC.

> +	if (skb2 == NULL) {
> +		pr_err("nfacct_quota_log: nlmsg_new failed\n");

Please, remove the error message.

> +		return;
> +	}
> +
> +	ret = nfnl_acct_fill_info(skb2, 0, 0, NFACCT_QUOTA,
> +						NFNL_MSG_ACCT_NEW, cur);
                                  ^-------------
                                       wrong coding style

> +
> +	if (ret <= 0) {
> +		kfree_skb(skb2);
> +		pr_err("nfacct_quota_log: nfnl_acct_fill_info failed\n");

remove this as well.

> +		return;
> +	}
> +
> +	netlink_broadcast(init_net.nfnl, skb2, 0,
> +					 NFNLGRP_CONNTRACK_QUOTA, GFP_ATOMIC);

wrong coding style:

        netlink_broadcast(init_net.nfnl, skb2, 0,
                          NFNLGRP_CONNTRACK_QUOTA, GFP_ATOMIC);

> +}
> +
>  static bool nfacct_mt(const struct sk_buff *skb, struct xt_action_param *par)
>  {
> -	const struct xt_nfacct_match_info *info = par->targinfo;
> +	u64 val;
> +	struct xt_nfacct_match_info *info = (void *) par->targinfo;
> +	bool ret = info->flags & XT_QUOTA_INVERT;
>  
>  	nfnl_acct_update(skb, info->nfacct);
>  
> -	return true;
> +	if (info->flags & XT_QUOTA_QUOTA) {
> +		spin_lock_bh(&info->priv->lock);
> +		val = (info->flags & XT_QUOTA_PACKET) ?
> +				nfnl_acct_get_pkts(info->nfacct) :
> +				nfnl_acct_get_bytes(info->nfacct);
> +		if (val <= info->quota) {
> +			ret = !ret;
> +			info->priv->quota_reached = false;
> +		} else {
> +			if (!info->priv->quota_reached) {
> +				info->priv->quota_reached = true;
> +				nfacct_quota_log(info->nfacct, skb);
> +			}
> +		}
> +		spin_unlock_bh(&info->priv->lock);
> +	}
> +
> +	return ret;
>  }
>  
>  static int
> @@ -40,7 +93,14 @@ nfacct_mt_checkentry(const struct xt_mtchk_param *par)
>  			"does not exists\n", info->name);
>  		return -ENOENT;
>  	}
> +
>  	info->nfacct = nfacct;
> +
> +	if ((info->flags & XT_QUOTA_QUOTA) && !info->priv) {
> +		info->priv =  kmalloc(sizeof(struct nf_acct_quota), GFP_KERNEL);

You always have to check the return value of kmalloc, the allocation
may fail.

> +		spin_lock_init(&info->priv->lock);
> +	}
> +
>  	return 0;
>  }
>  
> @@ -50,6 +110,7 @@ nfacct_mt_destroy(const struct xt_mtdtor_param *par)
>  	const struct xt_nfacct_match_info *info = par->matchinfo;
>  
>  	nfnl_acct_put(info->nfacct);
> +	kfree(info->priv);
>  }
>  
>  static struct xt_match nfacct_mt_reg __read_mostly = {
