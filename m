From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH -next 1/2] netfilter: iptables: separate counters from
 iptables rules
Date: Wed, 27 May 2015 08:20:32 +0200
Message-ID: <20150527082032.51cd621d@redhat.com>
References: <1432686919-8827-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	brouer@redhat.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbbE0GUp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 May 2015 02:20:45 -0400
In-Reply-To: <1432686919-8827-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 27 May 2015 02:35:18 +0200
Florian Westphal <fw@strlen.de> wrote:

> The binary arp/ip/ip6tables ruleset is stored per cpu.
> 
> The only reason left as to why we need percpu duplication are the rule
> counters embedded into ipt_entry et al -- since each cpu has its own copy
> of the rules, all counters can be lockless.
> 
> The downside is that the more cpus are supported, the more memory is
> required.  Rules are not just duplicated per online cpu but for each
> possible cpu, i.e. if maxcpu is 144, then rule is duplicated 144 times,
> not for the e.g. 64 cores present.
> 
> To save some memory and also allow cpus with shared caches to make
> better use of available cache size, it would be preferable to only
> store a copy of the rule blob for each numa node.
> 
> So we first need to separate counters and the rule blob.
> 
> We create array of struct xt_counters for each possible cpu and
> index them from the main blob via the (unused after validation)
> ->comefrom member.
> 
> Reported-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  include/linux/netfilter/x_tables.h |  6 ++++++
>  net/ipv4/netfilter/arp_tables.c    | 31 ++++++++++++++--------------
>  net/ipv4/netfilter/ip_tables.c     | 31 ++++++++++++++--------------
>  net/ipv6/netfilter/ip6_tables.c    | 32 ++++++++++++++---------------
>  net/netfilter/x_tables.c           | 42 ++++++++++++++++++++++++++++++++++++++
>  5 files changed, 93 insertions(+), 49 deletions(-)
> 
> diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
> index 09f3820..e50ba76 100644
> --- a/include/linux/netfilter/x_tables.h
> +++ b/include/linux/netfilter/x_tables.h
[...]
> @@ -690,6 +693,7 @@ static int translate_table(struct xt_table_info *newinfo, void *entry0,
>  		ret = find_check_entry(iter, repl->name, repl->size);
>  		if (ret != 0)
>  			break;
> +		iter->comefrom = i;

Please add comment to this line. E.g.

 iter->comefrom = i; /* store index to (percpu) counter */

>  		++i;
>  	}

  
> @@ -1416,6 +1414,7 @@ static int translate_compat_table(const char *name,
>  		ret = check_target(iter1, name);
>  		if (ret != 0)
>  			break;
> +		iter1->comefrom = i;

And comment missing here...

>  		++i;
>  		if (strcmp(arpt_get_target(iter1)->u.user.name,
>  		    XT_ERROR_TARGET) == 0)


> diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
> index 583779f..a68c377 100644
> --- a/net/ipv4/netfilter/ip_tables.c
> +++ b/net/ipv4/netfilter/ip_tables.c
[...]
> @@ -854,6 +856,8 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
>  		ret = find_check_entry(iter, net, repl->name, repl->size);
>  		if (ret != 0)
>  			break;
> +		/* overload comefrom to index into percpu counters array */
> +		iter->comefrom = i;

Here you remembered it.  And your formulation is more clear :-)

>  		++i;
>  	}
>  
[...]
> @@ -1736,6 +1733,8 @@ translate_compat_table(struct net *net,
>  		ret = compat_check_entry(iter1, net, name);
>  		if (ret != 0)
>  			break;
> +		/* overload comefrom to index into percpu counters array */
> +		iter1->comefrom = i;

Here you also remembered

>  		++i;
>  		if (strcmp(ipt_get_target(iter1)->u.user.name,
>  		    XT_ERROR_TARGET) == 0)


> diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
> index d54f049..69aec1d 100644
> --- a/net/ipv6/netfilter/ip6_tables.c
> +++ b/net/ipv6/netfilter/ip6_tables.c
[...]
> @@ -867,6 +869,8 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
>  		ret = find_check_entry(iter, net, repl->name, repl->size);
>  		if (ret != 0)
>  			break;
> +		/* overload comefrom to index into percpu counters array */
> +		iter->comefrom = i;

Ok

>  		++i;
>  	}
>  
[...]
> @@ -1749,6 +1745,8 @@ translate_compat_table(struct net *net,
>  		ret = compat_check_entry(iter1, net, name);
>  		if (ret != 0)
>  			break;
> +		/* overload comefrom to index into percpu counters array */
> +		iter1->comefrom = i;

Ok

>  		++i;
>  		if (strcmp(ip6t_get_target(iter1)->u.user.name,
>  		    XT_ERROR_TARGET) == 0)

Okay, so you only missed the comments in:
 include/linux/netfilter/x_tables.h

Thanks for the good work! :-)
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Sr. Network Kernel Developer at Red Hat
  Author of http://www.iptv-analyzer.org
  LinkedIn: http://www.linkedin.com/in/brouer
