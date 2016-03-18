From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] netfilter: x_tables: ensure e->next_offset consistency
 with table size
Date: Fri, 18 Mar 2016 15:23:55 -0700
Message-ID: <1458339835.31963.17.camel@edumazet-glaptop3.roam.corp.google.com>
References: <1458338325-1456-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, mkubecek@suse.cz,
	hawkes@google.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:35088 "EHLO
	mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbcCRWX5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Mar 2016 18:23:57 -0400
Received: by mail-pf0-f175.google.com with SMTP id n5so184578797pfn.2
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Mar 2016 15:23:57 -0700 (PDT)
In-Reply-To: <1458338325-1456-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 2016-03-18 at 22:58 +0100, Pablo Neira Ayuso wrote:
> This patch introduces the generic __xt_entry_foreach() that includes a
> new parameter to account for remaining entry bytes in the table that we
> didn't walk so far. If the amount of remaining bytes is zero, then we
> keep validating this table, otherwise for < 0 we just reject this.
> 
> Reported-by: Ben Hawkes <hawkes@google.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> Slightly tested here, will be spinning on this again with more testing
> tomorrow morning. I'll appreciate any extra hand on testing this
> further.
> 
>  include/linux/netfilter/x_tables.h | 10 ++++++++++
>  net/ipv4/netfilter/arp_tables.c    | 17 +++++++++++++++--
>  net/ipv4/netfilter/ip_tables.c     | 16 ++++++++++++++--
>  net/ipv6/netfilter/ip6_tables.c    | 16 ++++++++++++++--
>  4 files changed, 53 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
> index c557741..1206830 100644
> --- a/include/linux/netfilter/x_tables.h
> +++ b/include/linux/netfilter/x_tables.h
> @@ -411,6 +411,16 @@ xt_get_per_cpu_counter(struct xt_counters *cnt, unsigned int cpu)
>  struct nf_hook_ops *xt_hook_link(const struct xt_table *, nf_hookfn *);
>  void xt_hook_unlink(const struct xt_table *, struct nf_hook_ops *);
>  
> +/* Similar to xt_entry_foreach, but this tell us how many bytes are remaining
> + * after the iteration. If remain is < 0 then this table we're iterating over
> + * is wrong.
> + */
> +#define __xt_entry_foreach(pos, ehead, esize, remain)			\
> +	for ((pos) = (typeof(pos))(ehead), (remain) = (esize);		\
> +	     (pos) < (typeof(pos))((char *)(ehead) + (esize));		\
> +	     (remain) -= (pos)->next_offset,				\
> +	     (pos) = (typeof(pos))((char *)(pos) + (pos)->next_offset))
> +
>  #ifdef CONFIG_COMPAT
>  #include <net/compat.h>
>  
> diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
> index b488cac..9081cda 100644
> --- a/net/ipv4/netfilter/arp_tables.c
> +++ b/net/ipv4/netfilter/arp_tables.c
> @@ -637,6 +637,7 @@ static int translate_table(struct xt_table_info *newinfo, void *entry0,
>  	struct arpt_entry *iter;
>  	unsigned int i;
>  	int ret = 0;
> +	s64 remain;
>  

Looks overkill to use s64 on 32bit kernels ?
long should be enough I guess.


