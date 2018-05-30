From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nfnetlink: Remove VLA usage
Date: Wed, 30 May 2018 11:52:49 +0200
Message-ID: <20180530095249.3jdhb5gdwt24cnsa@salvia>
References: <20180530003525.GA18642@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180530003525.GA18642@beast>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, May 29, 2018 at 05:35:25PM -0700, Kees Cook wrote:
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
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
> @@ -37,6 +38,11 @@ MODULE_ALIAS_NET_PF_PROTO(PF_NETLINK, NETLINK_NETFILTER);
>  	rcu_dereference_protected(table[(id)].subsys, \
>  				  lockdep_nfnl_is_held((id)))
>  
> +#define NFTA_MAX_ATTR	max(max(max(NFTA_CHAIN_MAX, NFTA_FLOWTABLE_MAX),\
> +				max(NFTA_OBJ_MAX, NFTA_RULE_MAX)),	\
> +			    max(NFTA_TABLE_MAX,				\
> +				max(NFTA_SET_ELEM_LIST_MAX, NFTA_SET_MAX)))

This is very specific of nftables, there are other nf subsystems using
nfnetlink that may go over this maximum attribute value (grep from
"struct nfnetlink_subsystem").

To remove the VLA, I think we need an artificial maximum attribute
that reasonably large enough.
