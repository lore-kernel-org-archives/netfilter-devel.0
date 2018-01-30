From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [patch 1/1] net/netfilter/x_tables.c: make allocation less
 aggressive
Date: Tue, 30 Jan 2018 11:53:58 -0800
Message-ID: <1517342038.3715.97.camel@gmail.com>
References: <5a70c7c3.JeIh2XMA2ZATeitK%akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: akpm@linux-foundation.org, davem@davemloft.net,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        mhocko@kernel.org, fw@strlen.de, mhocko@suse.com
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <5a70c7c3.JeIh2XMA2ZATeitK%akpm@linux-foundation.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 2018-01-30 at 11:30 -0800, akpm@linux-foundation.org wrote:
> From: Michal Hocko <mhocko@kernel.org>
> Subject: net/netfilter/x_tables.c: make allocation less aggressive
> 
> syzbot has noticed that xt_alloc_table_info can allocate a lot of memory. 
> This is an admin only interface but an admin in a namespace is sufficient
> as well.  eacd86ca3b03 ("net/netfilter/x_tables.c: use kvmalloc() in
> xt_alloc_table_info()") has changed the opencoded kmalloc->vmalloc
> fallback into kvmalloc.  It has dropped __GFP_NORETRY on the way because
> vmalloc has simply never fully supported __GFP_NORETRY semantic.  This is
> still the case because e.g.  page tables backing the vmalloc area are
> hardcoded GFP_KERNEL.
> 
> Revert back to __GFP_NORETRY as a poors man defence against excessively
> large allocation request here.  We will not rule out the OOM killer
> completely but __GFP_NORETRY should at least stop the large request in
> most cases.
> 
> [akpm@linux-foundation.org: coding-style fixes]
> Fixes: eacd86ca3b03 ("net/netfilter/x_tables.c: use kvmalloc() in xt_alloc_tableLink: http://lkml.kernel.org/r/20180130140104.GE21609@dhcp22.suse.cz
> Signed-off-by: Michal Hocko <mhocko@suse.com>
> Acked-by: Florian Westphal <fw@strlen.de>
> Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
> Cc: David S. Miller <davem@davemloft.net>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  net/netfilter/x_tables.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff -puN net/netfilter/x_tables.c~net-netfilter-x_tablesc-make-allocation-less-aggressive net/netfilter/x_tables.c
> --- a/net/netfilter/x_tables.c~net-netfilter-x_tablesc-make-allocation-less-aggressive
> +++ a/net/netfilter/x_tables.c
> @@ -1008,7 +1008,12 @@ struct xt_table_info *xt_alloc_table_inf
>  	if ((size >> PAGE_SHIFT) + 2 > totalram_pages)
>  		return NULL;
>  
> -	info = kvmalloc(sz, GFP_KERNEL);
> +	/* __GFP_NORETRY is not fully supported by kvmalloc but it should
> +	 * work reasonably well if sz is too large and bail out rather
> +	 * than shoot all processes down before realizing there is nothing
> +	 * more to reclaim.
> +	 */
> +	info = kvmalloc(sz, GFP_KERNEL | __GFP_NORETRY);
>  	if (!info)
>  		return NULL;


How is __GFP_NORETRY working exactly ?

Surely, if some firewall tools attempt to load a new iptables rules, we
do not want to abort them if the request can be satisfied after few
pages moved on swap or written back to disk.

We want to avoid huge allocations, but leave reasonable ones succeed.

Thanks.
