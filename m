From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] netfilter: ipset: bitmap:ip,mac: fix listing with
 timeout
Date: Tue, 16 Apr 2013 19:44:42 +0200
Message-ID: <20130416174441.GA3174@localhost>
References: <1365857474-4943-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1365857474-4943-2-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Yoann JUET <yoann.juet@univ-nantes.fr>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38538 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935536Ab3DPRox (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Apr 2013 13:44:53 -0400
Content-Disposition: inline
In-Reply-To: <1365857474-4943-2-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jozsef,

On Sat, Apr 13, 2013 at 02:51:14PM +0200, Jozsef Kadlecsik wrote:
> The type when timeout support was enabled, could not list all elements,
> just the first ones which could fit into one netlink message: it just
> did not continue listing after the first message.
>
> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> ---
>  net/netfilter/ipset/ip_set_bitmap_ipmac.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
>
> diff --git a/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
> index 0f92dc2..d7df6ac 100644
> --- a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
> +++ b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
> @@ -339,7 +339,11 @@ bitmap_ipmac_tlist(const struct ip_set *set,
>  nla_put_failure:
>  	nla_nest_cancel(skb, nested);
>  	ipset_nest_end(skb, atd);

I think this ipset_nest_end should be after the id == first checking.
It doesn't make sense for the -EMSGSIZE case.

BTW, in the first message, where `first' is unset, id will never equal
first and you will always return success even if you could not add one
single nested attribute into the message.

> -	return -EMSGSIZE;
> +	if (unlikely(id == first)) {
> +		cb->args[2] = 0;
> +		return -EMSGSIZE;
> +	}
> +	return 0;

Regards.
