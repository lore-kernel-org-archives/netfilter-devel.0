From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netfilter: nfnetlink: Remove VLA usage
Date: Wed, 30 May 2018 10:19:22 +0200
Message-ID: <20180530081922.tckogxkmltw6cxn7@breakpoint.cc>
References: <20180530003525.GA18642@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180530003525.GA18642@beast>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Kees Cook <keescook@chromium.org> wrote:
> In the quest to remove all stack VLA usage from the kernel[1], this
> allocates the maximum size expected for all possible attrs and adds
> a sanity-check to make sure nothing gets out of sync.
> 
> [1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  net/netfilter/nfnetlink.c | 22 ++++++++++++++++++++--
>  1 file changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
> index 03ead8a9e90c..0cb395f9627e 100644
> --- a/net/netfilter/nfnetlink.c
> +++ b/net/netfilter/nfnetlink.c
> @@ -28,6 +28,7 @@
>  
>  #include <net/netlink.h>
>  #include <linux/netfilter/nfnetlink.h>
> +#include <linux/netfilter/nf_tables.h>
>
>  	const struct nfnetlink_subsystem __rcu	*subsys;
> @@ -185,11 +191,17 @@ static int nfnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
>  	{
>  		int min_len = nlmsg_total_size(sizeof(struct nfgenmsg));
>  		u8 cb_id = NFNL_MSG_TYPE(nlh->nlmsg_type);
> -		struct nlattr *cda[ss->cb[cb_id].attr_count + 1];
> +		struct nlattr *cda[NFTA_MAX_ATTR + 1];
>  		struct nlattr *attr = (void *)nlh + min_len;
>  		int attrlen = nlh->nlmsg_len - min_len;
>  		__u8 subsys_id = NFNL_SUBSYS_ID(type);
>  
> +		/* Sanity-check NFTA_MAX_ATTR */
> +		if (ss->cb[cb_id].attr_count > NFTA_MAX_ATTR) {
> +			rcu_read_unlock();
> +			return -ENOMEM;
> +		}

Would you mind also adding check to nfnetlink_subsys_register, plus WARN()?

That way we'll see that NFTA_MAX_ATTR isn't large enough by virtue
of registration rather than actual use.

Other than that this looks fine to me.
