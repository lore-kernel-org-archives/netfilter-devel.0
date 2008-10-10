From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 5/8] [PATCH] deliver events for conntracks created via
 ctnetlink
Date: Fri, 10 Oct 2008 15:31:39 +0200
Message-ID: <48EF593B.30208@trash.net>
References: <20081009083339.9824.24056.stgit@Decadence> <20081009083506.9824.48734.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54505 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756516AbYJJNbm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Oct 2008 09:31:42 -0400
In-Reply-To: <20081009083506.9824.48734.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> As for now, the creation and update of conntracks via ctnetlink do not
> propagate an event to userspace. This can result in inconsistent situations
> if several userspace processes modify the connection tracking table by means
> of ctnetlink at the same time. Specifically, using the conntrack command
> line tool and conntrackd at the same time can trigger unconsistencies.
> 
> This patch also modifies the event cache infrastructure to pass the
> process PID and the ECHO flag to nfnetlink_send() to report back
> to userspace if the process that triggered the change needs so.
> Based on a suggestion from Patrick McHardy.

Looks pretty good, some minor issues:

- there are quite a lot of trailing whitespaces in this
   patch, please remove those.

> +/* This structure is passed to event handler */
> +struct nf_ct_event {
> +	struct nf_conn *ct;
> +	u32 pid;
> +	int report;
> +};

Just a suggestion: passing the nlmsghdr instead of the ECHO
flag and doing the approriate handling in the event functions
seems more logical to me. I think I know why you did it this
way (no reporting on unload, no netlink context there), see
below about that.

> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index f465090..aab2618 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -174,7 +174,8 @@ destroy_conntrack(struct nf_conntrack *nfct)
>  	NF_CT_ASSERT(atomic_read(&nfct->use) == 0);
>  	NF_CT_ASSERT(!timer_pending(&ct->timeout));
>  
> -	nf_conntrack_event(IPCT_DESTROY, ct);
> +	if (!test_bit(IPS_DYING_BIT, &ct->status))
> +		nf_conntrack_event(IPCT_DESTROY, ct);

Whats the idea behind this change? Is it simply an optimization?

>  	set_bit(IPS_DYING_BIT, &ct->status);
>  
>  	/* To make sure we don't get any weird locking issues here:
> @@ -963,8 +964,24 @@ void nf_ct_iterate_cleanup(struct net *net,
>  }
>  EXPORT_SYMBOL_GPL(nf_ct_iterate_cleanup);
>  
> +struct __nf_ct_flush_report {
> +	u32 pid;
> +	int report;
> +};
> +
>  static int kill_all(struct nf_conn *i, void *data)
>  {
> +	struct __nf_ct_flush_report *fr = (struct __nf_ct_flush_report *)data;
> +
> +	if (!fr->report)
> +		return 1;

Whats the reasoning behind not reporting destroy events on unload?
I don't think there's anything special about module unload, so it
seems inconsistent.
