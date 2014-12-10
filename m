From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: return -EFAULT directly when counters_ptr is
 NULL
Date: Wed, 10 Dec 2014 15:17:47 +0100
Message-ID: <20141210141747.GA5107@salvia>
References: <547EACB2.8090501@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Duan Jiong <duanj.fnst@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53691 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755972AbaLJOPZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Dec 2014 09:15:25 -0500
Content-Disposition: inline
In-Reply-To: <547EACB2.8090501@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 03, 2014 at 02:24:50PM +0800, Duan Jiong wrote:
> 
> Now if the copy_to_user() fail, __do_replace just silent error, because
> new table is alread replaced. But at the beginning of __do_replace(), if
> we notice that user supply no memory to store counters, we should not
> replace table, so we can just returen -EFAULT directly.

This is independent of the change you mention, right?

I mean, userspace can send us null counters and we'll crash.

Another nitpick comment below:

> Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
> ---
>  net/bridge/netfilter/ebtables.c | 3 +++
>  net/ipv4/netfilter/arp_tables.c | 4 ++++
>  net/ipv4/netfilter/ip_tables.c  | 4 ++++
>  net/ipv6/netfilter/ip6_tables.c | 4 ++++
>  4 files changed, 15 insertions(+)
> 
> diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
> index d9a8c05..90ccc78 100644
> --- a/net/bridge/netfilter/ebtables.c
> +++ b/net/bridge/netfilter/ebtables.c
> @@ -983,6 +983,9 @@ static int do_replace_finish(struct net *net, struct ebt_replace *repl,
>  	struct ebt_table_info *table;
>  	struct ebt_table *t;
>  
> +	if (!repl->counters)
> +		return -EFAULT;
> +
>  	/* the user wants counters back
>  	   the check on the size is done later, when we have the lock */
>  	if (repl->num_counters) {
> diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
> index f95b6f9..654debe 100644
> --- a/net/ipv4/netfilter/arp_tables.c
> +++ b/net/ipv4/netfilter/arp_tables.c
> @@ -999,6 +999,10 @@ static int __do_replace(struct net *net, const char *name,
>  	struct arpt_entry *iter;
>  
>  	ret = 0;
> +	if (!counters_ptr) {
> +		ret = -EFAULT;
> +		goto out;
> +	}

Please move this check before 'ret = 0'. So we avoid the unnecessary
initialization. Same thing below.

>  	counters = vzalloc(num_counters * sizeof(struct xt_counters));
>  	if (!counters) {
>  		ret = -ENOMEM;
> diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
> index 99e810f..0acdcc8 100644
> --- a/net/ipv4/netfilter/ip_tables.c
> +++ b/net/ipv4/netfilter/ip_tables.c
> @@ -1186,6 +1186,10 @@ __do_replace(struct net *net, const char *name, unsigned int valid_hooks,
>  	struct ipt_entry *iter;
>  
>  	ret = 0;
> +	if (!counters_ptr) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
>  	counters = vzalloc(num_counters * sizeof(struct xt_counters));
>  	if (!counters) {
>  		ret = -ENOMEM;
> diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
> index e080fbb..cb91f2b 100644
> --- a/net/ipv6/netfilter/ip6_tables.c
> +++ b/net/ipv6/netfilter/ip6_tables.c
> @@ -1196,6 +1196,10 @@ __do_replace(struct net *net, const char *name, unsigned int valid_hooks,
>  	struct ip6t_entry *iter;
>  
>  	ret = 0;
> +	if (!counters_ptr) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
>  	counters = vzalloc(num_counters * sizeof(struct xt_counters));
>  	if (!counters) {
>  		ret = -ENOMEM;
> -- 
> 1.8.3.1
