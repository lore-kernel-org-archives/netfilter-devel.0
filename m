From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2] net: netfilter: Replace printk() with appropriate
 pr_*() macro
Date: Sun, 11 Mar 2018 12:52:41 -0700
Message-ID: <1520797961.19456.4.camel@perches.com>
References: <20180311194104.GA17450@seema-Inspiron-15-3567>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: Arushi Singhal <arushisinghal19971997@gmail.com>,
        pablo@netfilter.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180311194104.GA17450@seema-Inspiron-15-3567>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, 2018-03-12 at 01:11 +0530, Arushi Singhal wrote:
> Using pr_<loglevel>() is more concise than
> printk(KERN_<LOGLEVEL>).
> Replace printks having a log level with the appropriate
> pr_*() macros.
> 
> Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>
> ---
> changes in v2
> *in v1 printk() were replaced with netdev_*()

>  net/netfilter/nf_conntrack_acct.c      | 2 +-
>  net/netfilter/nf_conntrack_ecache.c    | 2 +-
>  net/netfilter/nf_conntrack_timestamp.c | 2 +-
>  net/netfilter/nf_nat_core.c            | 2 +-
>  net/netfilter/nfnetlink_queue.c        | 4 ++--
>  5 files changed, 6 insertions(+), 6 deletions(-)

None of these files have a #define for pr_fmt so this
should be OK.

Perhaps coalesce the formats and remove the unnecessary periods too.

> diff --git a/net/netfilter/nf_conntrack_acct.c b/net/netfilter/nf_conntrack_acct.c
[]
> @@ -80,7 +80,7 @@ static int nf_conntrack_acct_init_sysctl(struct net *net)
>  	net->ct.acct_sysctl_header = register_net_sysctl(net, "net/netfilter",
>  							 table);
>  	if (!net->ct.acct_sysctl_header) {
> -		printk(KERN_ERR "nf_conntrack_acct: can't register to sysctl.\n");
> +		pr_err("nf_conntrack_acct: can't register to sysctl.\n");
>  		goto out_register;
>  	}
>  	return 0;

etc...

> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
[]
> @@ -834,8 +834,8 @@ nfqnl_mangle(void *data, int data_len, struct nf_queue_entry *e, int diff)
>  			nskb = skb_copy_expand(e->skb, skb_headroom(e->skb),
>  					       diff, GFP_ATOMIC);
>  			if (!nskb) {
> -				printk(KERN_WARNING "nf_queue: OOM "
> -				      "in mangle, dropping packet\n");
> +				pr_warn("nf_queue: OOM "
> +					"in mangle, dropping packet\n");
>  				return -ENOMEM;
>  			}
>  			kfree_skb(e->skb);
