From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/4] deliver events for conntracks created/updated via
 ctnetlink
Date: Wed, 21 May 2008 13:48:10 +0200
Message-ID: <48340BFA.2030307@trash.net>
References: <483350D9.7010809@netfilter.org> <48335339.2050007@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38476 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756916AbYEULsM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 May 2008 07:48:12 -0400
In-Reply-To: <48335339.2050007@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Pablo Neira Ayuso wrote:
>> As for now, the creation and update of conntracks via ctnetlink do not
>> propagate an event to userspace. This can result in inconsistent
>> situations if several userspace processes modify the connection tracking
>> table by means of ctnetlink at the same time. Specifically, using the
>> conntrack-cli while running an instance of conntrackde unsynchronizes
>> the cache of conntrackd with the kernel conntrack table. Note that
>> deletions do not suffer from this problem.
>>

Thanks for working on this. I have a couple of comments/questions
about the patch:

> @@ -529,6 +529,11 @@ nla_put_failure:
>  	kfree_skb(skb);
>  	return NOTIFY_DONE;
>  }
> +
> +static struct notifier_block ctnl_notifier = {
> +	.notifier_call	= ctnetlink_conntrack_event,
> +};

Why are the notifier blocks moved? It doesn't look necessary
for this patch.

>  static int
> -ctnetlink_change_status(struct nf_conn *ct, struct nlattr *cda[])
> +ctnetlink_change_status(struct nf_conn *ct, struct nlattr *cda[], int *events)
>  {
>  	unsigned long d;
>  	unsigned int status = ntohl(nla_get_be32(cda[CTA_STATUS]));
> @@ -930,12 +935,15 @@ ctnetlink_change_status(struct nf_conn *
>  	 * so don't let users modify them directly if they don't pass
>  	 * nf_nat_range. */
>  	ct->status |= status & ~(IPS_NAT_DONE_MASK | IPS_NAT_MASK);
> +
> +	*events |= IPCT_STATUS;

I have some doubts whether we should really do this by
keeping track of the events outside of the cache.

Some changes are not performed manually, but by calling NAT
and conntrack functions, like nf_nat_setup_info(). These
might cache events for the conntrack, which will cause the
events to be delivered again some (unknown) time later.
For now things look fine, but for example nf_nat_setup_info()
should really cache the NAT event instead of
nf_conntrack_confirm(), at which point the above would happen.

This makes me think that ctnetlink should simply use the
normal event caching functions and trigger delivery once
its done.


> +		spin_unlock_bh(&nf_conntrack_lock);
> +
> +		if (err == 0) {
> +			atomic_inc(&ct->ct_general.use);
> +			ctnetlink_conntrack_event(&ctnl_notifier, &events, ct);
> +			nf_ct_put(ct);
> +		}

This doesn't look right. The conntrack might already be gone,
no?

One final thing: event messages generated after changes requested
by userspace should include the pid of the requesting socket
in nlmsg_pid. If a unicast report is requested, the socket should
be excluded from receiving the multicast message again.

Check out nlmsg_notify() and nlmsg_report() for reference.
