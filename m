From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 7/7] netfilter: x_tables: use pr ratelimiting in all
 remaining spots
Date: Wed, 7 Feb 2018 18:00:52 +0100
Message-ID: <20180207170052.x6n6kod2zld7wuqd@salvia>
References: <20180207134828.18691-1-fw@strlen.de>
 <20180207134828.18691-8-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58700 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754377AbeBGRBC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Feb 2018 12:01:02 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0CC6E3066AB
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2018 18:00:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E52B8DA78D
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2018 18:00:58 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180207134828.18691-8-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

Thanks for looking into this, comments below.

On Wed, Feb 07, 2018 at 02:48:28PM +0100, Florian Westphal wrote:
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/bridge/netfilter/ebt_among.c | 10 ++++----
>  net/bridge/netfilter/ebt_limit.c |  4 ++--
>  net/ipv4/netfilter/ipt_ECN.c     |  2 +-
>  net/ipv4/netfilter/ipt_REJECT.c  |  4 ++--
>  net/ipv6/netfilter/ip6t_REJECT.c |  4 ++--
>  net/ipv6/netfilter/ip6t_srh.c    |  6 +++--
>  net/netfilter/xt_AUDIT.c         |  4 ++--
>  net/netfilter/xt_CHECKSUM.c      |  5 ++--
>  net/netfilter/xt_CONNSECMARK.c   |  6 ++---
>  net/netfilter/xt_DSCP.c          |  2 +-
>  net/netfilter/xt_LED.c           |  2 +-
>  net/netfilter/xt_NFQUEUE.c       |  6 ++---
>  net/netfilter/xt_SECMARK.c       | 12 ++++++----
>  net/netfilter/xt_TCPMSS.c        | 10 ++++----
>  net/netfilter/xt_TPROXY.c        |  6 ++---
>  net/netfilter/xt_cgroup.c        |  8 ++++---
>  net/netfilter/xt_cluster.c       |  8 +++----
>  net/netfilter/xt_connbytes.c     |  4 ++--
>  net/netfilter/xt_connlabel.c     |  4 ++--
>  net/netfilter/xt_connmark.c      |  8 +++----
>  net/netfilter/xt_conntrack.c     |  4 ++--
>  net/netfilter/xt_dscp.c          |  2 +-
>  net/netfilter/xt_ecn.c           |  4 ++--
>  net/netfilter/xt_hashlimit.c     | 24 ++++++++++---------
>  net/netfilter/xt_helper.c        |  4 ++--
>  net/netfilter/xt_l2tp.c          | 20 +++++++++-------
>  net/netfilter/xt_limit.c         |  4 ++--
>  net/netfilter/xt_nat.c           |  5 ++--
>  net/netfilter/xt_nfacct.c        |  6 +++--
>  net/netfilter/xt_physdev.c       |  4 +---
>  net/netfilter/xt_recent.c        | 10 ++++----
>  net/netfilter/xt_set.c           | 50 ++++++++++++++++++++--------------------
>  net/netfilter/xt_state.c         |  4 ++--
>  net/netfilter/xt_time.c          |  3 +--
>  34 files changed, 132 insertions(+), 127 deletions(-)
> 
> diff --git a/net/bridge/netfilter/ebt_among.c b/net/bridge/netfilter/ebt_among.c
> index 279527f8b1fe..12d850a3ea68 100644
> --- a/net/bridge/netfilter/ebt_among.c
> +++ b/net/bridge/netfilter/ebt_among.c
> @@ -187,17 +187,17 @@ static int ebt_among_mt_check(const struct xt_mtchk_param *par)
>  	expected_length += ebt_mac_wormhash_size(wh_src);
>  
>  	if (em->match_size != EBT_ALIGN(expected_length)) {
> -		pr_info("wrong size: %d against expected %d, rounded to %zd\n",
> -			em->match_size, expected_length,
> -			EBT_ALIGN(expected_length));
> +		pr_info_ratelimited("wrong size: %d against expected %d, rounded to %zd\n",

Shouldn't all these be pr_err_ratelimited instead?

Probably this is a good chance to homogeneize all error reporting in
xtables.

> +				    em->match_size, expected_length,
> +				    EBT_ALIGN(expected_length));
>  		return -EINVAL;
>  	}
>  	if (wh_dst && (err = ebt_mac_wormhash_check_integrity(wh_dst))) {
> -		pr_info("dst integrity fail: %x\n", -err);
> +		pr_info_ratelimited("dst integrity fail: %x\n", -err);
>  		return -EINVAL;
>  	}
>  	if (wh_src && (err = ebt_mac_wormhash_check_integrity(wh_src))) {
> -		pr_info("src integrity fail: %x\n", -err);
> +		pr_info_ratelimited("src integrity fail: %x\n", -err);
>  		return -EINVAL;
>  	}
>  	return 0;
[...]
> diff --git a/net/netfilter/xt_NFQUEUE.c b/net/netfilter/xt_NFQUEUE.c
> index a360b99a958a..9fac4710f7cf 100644
> --- a/net/netfilter/xt_NFQUEUE.c
> +++ b/net/netfilter/xt_NFQUEUE.c
> @@ -67,13 +67,13 @@ static int nfqueue_tg_check(const struct xt_tgchk_param *par)
>  	init_hashrandom(&jhash_initval);
>  
>  	if (info->queues_total == 0) {
> -		pr_err("NFQUEUE: number of total queues is 0\n");
                        ^^^^^^^^

We can probably add this all over the place in the same go?

        #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

> +		pr_err_ratelimited("NFQUEUE: number of total queues is 0\n");
>  		return -EINVAL;
>  	}
>  	maxid = info->queues_total - 1 + info->queuenum;
>  	if (maxid > 0xffff) {
> -		pr_err("NFQUEUE: number of queues (%u) out of range (got %u)\n",
> -		       info->queues_total, maxid);
> +		pr_err_ratelimited("NFQUEUE: number of queues (%u) out of range (got %u)\n",
> +				   info->queues_total, maxid);
>  		return -ERANGE;
>  	}
>  	if (par->target->revision == 2 && info->flags > 1)
[...]
> diff --git a/net/netfilter/xt_set.c b/net/netfilter/xt_set.c
> index 16b6b11ee83f..ba94286f25aa 100644
> --- a/net/netfilter/xt_set.c
> +++ b/net/netfilter/xt_set.c
> @@ -92,12 +92,12 @@ set_match_v0_checkentry(const struct xt_mtchk_param *par)
>  	index = ip_set_nfnl_get_byindex(par->net, info->match_set.index);
>  
>  	if (index == IPSET_INVALID_ID) {
> -		pr_warn("Cannot find set identified by id %u to match\n",
> -			info->match_set.index);
> +		pr_warn_ratelimited("Cannot find set identified by id %u to match\n",
> +				    info->match_set.index);

Use pr_err_ratelimited instead?
