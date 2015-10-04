From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH -next 4/8] netfilter: xtables: don't register table hooks
 in namespace at init time
Date: Sun, 4 Oct 2015 21:58:49 +0200
Message-ID: <20151004195849.GA11391@salvia>
References: <1443786557-21315-1-git-send-email-fw@strlen.de>
 <1443786557-21315-5-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, ebiederm@xmission.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46675 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820AbbJDTvx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 4 Oct 2015 15:51:53 -0400
Content-Disposition: inline
In-Reply-To: <1443786557-21315-5-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 02, 2015 at 01:49:13PM +0200, Florian Westphal wrote:
> delay hook registration until the table is being requested inside a
> namespace.
> 
> Historically, a particular table (iptables mangle, ip6tables filter,
> etc) was registered on module load.
> 
> When netns support was added to iptables only the ip/ip6tables ruleset
> was made namespace aware, not the actual hook points.
> 
> This means f.e. that when ipt_filter table/module is loaded on a system,
> then each namespace on that system has an (empty) iptables filter ruleset.
> 
> In other words, if a namespace sends a packet, such skb is 'caught'
> by netfilter machinery and fed to hooking points for that table
> (i.e. INPUT, FORWARD, etc).
> 
> Thanks to Eric Biederman, hooks are no longer global, but per namespace.
> 
> This means that we can avoid allocation of empty ruleset in a namespace
> and defer hook registration until we need the functionality.
> 
> We register a tables hook entry points ONLY in the initial namespace.
> When an iptables get/setockopt is issued inside a given namespace,
> we check if the table is found in the per-namespace list.
> 
> If not, we attempt to find it in the initial namespace, and,
> if found, create an empty default table in the requesting namespace
> and register the needed hooks.
> 
> Hook points are destroyed only once namespace is deleted, there is no
> 'usage count' (it makes no sense since there is no 'remove table'
> operation in xtables api).
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  include/linux/netfilter/x_tables.h     | 10 ++++-
>  net/ipv4/netfilter/arptable_filter.c   | 39 +++++++++++-------
>  net/ipv4/netfilter/iptable_filter.c    | 65 ++++++++++++++++++++++--------
>  net/ipv4/netfilter/iptable_mangle.c    | 50 ++++++++++++++++++-----
>  net/ipv4/netfilter/iptable_nat.c       | 51 ++++++++++++++++--------
>  net/ipv4/netfilter/iptable_raw.c       | 50 ++++++++++++++++++-----
>  net/ipv4/netfilter/iptable_security.c  | 52 +++++++++++++++++-------
>  net/ipv6/netfilter/ip6table_filter.c   | 54 ++++++++++++++++++-------
>  net/ipv6/netfilter/ip6table_mangle.c   | 53 +++++++++++++++++-------
>  net/ipv6/netfilter/ip6table_nat.c      | 51 ++++++++++++++++--------
>  net/ipv6/netfilter/ip6table_raw.c      | 54 ++++++++++++++++++-------
>  net/ipv6/netfilter/ip6table_security.c | 53 +++++++++++++++++-------
>  net/netfilter/x_tables.c               | 73 +++++++++++++++++++++++++---------
>  13 files changed, 475 insertions(+), 180 deletions(-)

Can we get this smaller by performing the same netns hook registration
from xx_register_table()?

I remember the NAT table was specifically problematic when I sent my
RFC patchset to add per-netns hook, but it just required some previous
refactoring to handle that particular thing.

> @@ -103,16 +109,33 @@ static int __net_init iptable_mangle_net_init(struct net *net)
>  	net->ipv4.iptable_mangle =
>  		ipt_register_table(net, &packet_mangler, repl);
>  	kfree(repl);
> -	return PTR_ERR_OR_ZERO(net->ipv4.iptable_mangle);
> +	ret = PTR_ERR_OR_ZERO(net->ipv4.iptable_mangle);
> +	if (ret < 0)
> +		goto err;
> +	/* Register hooks */
> +	ret = xt_hook_link_net(net, net->ipv4.iptable_mangle, mangle_ops);
> +	if (ret) {
> +		ipt_unregister_table(net, net->ipv4.iptable_mangle);
> +		goto err;
> +	}
> +
> +	return ret;
> + err:
> +	net->ipv4.iptable_mangle = NULL;
> +	return ret;
>  }

I'm refering to the code pattern above, it looks like it's repeated
several times.

Thanks.
