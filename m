From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH v2] netfilter: properly initialize xt_table_info structure
Date: Thu, 17 May 2018 02:55:42 -0700
Message-ID: <a8fadcf4-c2dd-7465-9b41-189eb97a3dd2@gmail.com>
References: <20180517084442.GA23981@kroah.com>
 <20180517085951.2wxvcg5herkjaxda@unicorn.suse.cz>
 <20180517093410.GB17597@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Michal Kubecek <mkubecek@suse.cz>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180517093410.GB17597@kroah.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org



On 05/17/2018 02:34 AM, Greg Kroah-Hartman wrote:
> When allocating a xt_table_info structure, we should be clearing out the
> full amount of memory that was allocated, not just the "header" of the
> structure.  Otherwise odd values could be passed to userspace, which is
> not a good thing.
> 
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> v2: use kvzalloc instead of kvmalloc/memset pair, as suggested by Michal Kubecek
> 
>  net/netfilter/x_tables.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
> index cb7cb300c3bc..cd22bb9b66f3 100644
> --- a/net/netfilter/x_tables.c
> +++ b/net/netfilter/x_tables.c
> @@ -1183,11 +1183,10 @@ struct xt_table_info *xt_alloc_table_info(unsigned int size)
>  	 * than shoot all processes down before realizing there is nothing
>  	 * more to reclaim.
>  	 */
> -	info = kvmalloc(sz, GFP_KERNEL | __GFP_NORETRY);
> +	info = kvzalloc(sz, GFP_KERNEL | __GFP_NORETRY);
>  	if (!info)
>  		return NULL;
>  
> -	memset(info, 0, sizeof(*info));
>  	info->size = size;
>  	return info;
>  }
> 

I am curious, what particular path does not later overwrite the whole zone ?

Do not get me wrong, this is not fast path, but these blobs can be huge.
