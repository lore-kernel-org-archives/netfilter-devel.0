From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/3] netfilter: xtables: add and use
 xt_request_find_table_lock
Date: Sat, 9 Dec 2017 16:23:20 +0100
Message-ID: <20171209152320.GA7731@salvia>
References: <20171208160155.968-1-fw@strlen.de>
 <20171208160155.968-2-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51620 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750886AbdLIPXY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Dec 2017 10:23:24 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8BC37EB465
        for <netfilter-devel@vger.kernel.org>; Sat,  9 Dec 2017 16:23:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7A4FFDA807
        for <netfilter-devel@vger.kernel.org>; Sat,  9 Dec 2017 16:23:23 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171208160155.968-2-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 08, 2017 at 05:01:53PM +0100, Florian Westphal wrote:
> currently we always return -ENOENT to userspace if we can't find
> a particular table, or if the table initialization fails.
> 
> Followup patch will make nat table init fail in case nftables already
> registered a nat hook so this change makes xt_find_table_lock return
> an ERR_PTR to return the errno value reported from the table init
> function.
> 
> Add xt_request_find_table_lock as try_then_request_module replacement
> and use it where needed.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  include/linux/netfilter/x_tables.h |  2 ++
>  net/ipv4/netfilter/arp_tables.c    | 26 ++++++++++++--------------
>  net/ipv4/netfilter/ip_tables.c     | 26 ++++++++++++--------------
>  net/ipv6/netfilter/ip6_tables.c    | 26 ++++++++++++--------------
>  net/netfilter/x_tables.c           | 37 +++++++++++++++++++++++++++----------
>  5 files changed, 65 insertions(+), 52 deletions(-)
> 
> diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
> index 33f7530f96b9..1313b35c3ab7 100644
> --- a/include/linux/netfilter/x_tables.h
> +++ b/include/linux/netfilter/x_tables.h
> @@ -320,6 +320,8 @@ int xt_find_revision(u8 af, const char *name, u8 revision, int target,
>  
>  struct xt_table *xt_find_table_lock(struct net *net, u_int8_t af,
>  				    const char *name);
> +struct xt_table *xt_request_find_table_lock(struct net *net, u_int8_t af,
> +					    const char *name);
>  void xt_table_unlock(struct xt_table *t);
>  
>  int xt_proto_init(struct net *net, u_int8_t af);
> diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
> index f88221aebc9d..8cfe3d37cbb1 100644
> --- a/net/ipv4/netfilter/arp_tables.c
> +++ b/net/ipv4/netfilter/arp_tables.c
> @@ -811,9 +811,8 @@ static int get_info(struct net *net, void __user *user,
>  	if (compat)
>  		xt_compat_lock(NFPROTO_ARP);
>  #endif
> -	t = try_then_request_module(xt_find_table_lock(net, NFPROTO_ARP, name),
> -				    "arptable_%s", name);
> -	if (t) {
> +	t = xt_request_find_table_lock(net, NFPROTO_ARP, name);
> +	if (!IS_ERR(t)) {
>  		struct arpt_getinfo info;
>  		const struct xt_table_info *private = t->private;
>  #ifdef CONFIG_COMPAT
> @@ -842,7 +841,7 @@ static int get_info(struct net *net, void __user *user,
>  		xt_table_unlock(t);
>  		module_put(t->me);
>  	} else
> -		ret = -ENOENT;
> +		ret = PTR_ERR(t);
>  #ifdef CONFIG_COMPAT
>  	if (compat)
>  		xt_compat_unlock(NFPROTO_ARP);
> @@ -867,7 +866,7 @@ static int get_entries(struct net *net, struct arpt_get_entries __user *uptr,
>  	get.name[sizeof(get.name) - 1] = '\0';
>  
>  	t = xt_find_table_lock(net, NFPROTO_ARP, get.name);
> -	if (t) {
> +	if (!IS_ERR(t)) {
>  		const struct xt_table_info *private = t->private;
>  
>  		if (get.size == private->size)
> @@ -879,7 +878,7 @@ static int get_entries(struct net *net, struct arpt_get_entries __user *uptr,
>  		module_put(t->me);
>  		xt_table_unlock(t);
>  	} else
> -		ret = -ENOENT;
> +		ret = PTR_ERR(t);
>  
>  	return ret;
>  }
> @@ -904,10 +903,9 @@ static int __do_replace(struct net *net, const char *name,
>  		goto out;
>  	}
>  
> -	t = try_then_request_module(xt_find_table_lock(net, NFPROTO_ARP, name),
> -				    "arptable_%s", name);
> -	if (!t) {
> -		ret = -ENOENT;
> +	t = xt_request_find_table_lock(net, NFPROTO_ARP, name);
> +	if (IS_ERR(t)) {
> +		ret = ERR_PTR(t);

net/ipv4/netfilter/arp_tables.c:908:17: warning: passing argument 1 of ‘ERR_PTR’ makes integer from pointer without a cast
net/ipv4/netfilter/arp_tables.c:908:7: warning: assignment makes integer from pointer without a cast
net/ipv4/netfilter/arp_tables.c:1023:17: warning: passing argument 1 of ‘ERR_PTR’ makes integer from pointer without a cast
net/ipv4/netfilter/arp_tables.c:1023:7: warning: assignment makes integer from pointer without a cast

Will fix this here, I need to invert ERR_PTR() to PTR_ERR().
