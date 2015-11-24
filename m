From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nftables 6/6] src: add trace support to nft monitor mode
Date: Tue, 24 Nov 2015 10:25:54 +0000
Message-ID: <20151124102553.GE2310@macbook.localdomain>
References: <1448359331-12692-1-git-send-email-fw@strlen.de>
 <1448359331-12692-7-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:44557 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754449AbbKXKZ6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 05:25:58 -0500
Content-Disposition: inline
In-Reply-To: <1448359331-12692-7-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 24.11, Florian Westphal wrote:
> nft monitor [ trace ]
> 
> ... can now display nftables nftrace debug information.
> 
> $ nft rule bridge raw prerouting add tcp dport 22 limit rate 1/second meta nftrace set 1
> $ nft monitor trace
> trace id 834dd100 bridge packet src 5e:95:99:72:ea:c5 dst 52:54:40:a2:3f:a6 src 192.168.7.1 dst 192.168.7.11 len 88 ttl 64 id 2719 protocol 6 sport 3628 dport 22 iif eth0
> trace id 834dd100 bridge raw prerouting rule verdict continue iif eth0
> trace id 834dd100 rule tcp dport ssh limit rate 1/second nftrace set 1
> trace id 834dd100 bridge raw prerouting policy verdict accept iif eth0
> trace id 834dd100 ip filter input rule verdict jump iif br0
> trace id 834dd100 rule ip saddr . tcp dport vmap { }
> trace id 834dd100 ip filter test rule verdict accept iif br0
> trace id 834dd100 rule accept

I like this *a lot*. No need for external tools and a much more readable
output than using any of the other logging mechanisms. Nice work!

> +static void trace_print_if(const struct nftnl_trace *nlt, uint16_t attr, const char *str)
> +{
> +	char __name[IFNAMSIZ];
> +	const char *ifname;
> +
> +        if (!nftnl_trace_is_set(nlt, attr))
> +		return;
> +
> +	ifname = nft_if_indextoname(nftnl_trace_get_u32(nlt, attr), __name);
> +	if (ifname)
> +		printf(" %s %s", str, ifname);
> +	else
> +		printf(" %s %d", str, nftnl_trace_get_u32(nlt, attr));
> +}

A lot of the other trace attributes are not used so far. I'm wondering if
you intend to add special print functions for them as well.

An alternative would be to use our internal datatypes, IOW parse the
attributes, associate the values with an internal type and use the regular
printing functions. The benefit would be fully consistent output, also
with respect to output options like numerical output.

> +static int do_command_monitor(struct netlink_ctx *ctx, struct cmd *cmd)
> +{
> +	struct table *t;
> +	struct set *s;
> +	struct netlink_mon_handler monhandler;
> +
> +	monhandler.cache_needed = need_cache(cmd);
>  	if (monhandler.cache_needed) {
> +		struct rule *rule, *nrule;
> +		struct chain *chain;
> +		int ret;
> +
>  		list_for_each_entry(t, &table_list, list) {
>  			list_for_each_entry(s, &t->sets, list)
>  				s->init = set_expr_alloc(&cmd->location);
> +
> +			if (!(cmd->monitor->flags & (1 << NFT_MSG_TRACE)))
> +				continue;
> +
> +			/* When tracing we'd like to translate the rule handle
> +			 * we receive in the trace messages to the actual rule
> +			 * struct to print that out.  Populate rule cache now.
> +			 */

Tracing might be a long running operation. The cache can go out of sync, might
be better to do a lookup on demand.

Right now the caching infrastrucure has quite a lot of problems and I'd prefer
to get them fixed before we base new things on it.
