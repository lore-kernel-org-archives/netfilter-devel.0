From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] [PATCH] dynamic calculation of event message size for
 ctnetlink
Date: Tue, 17 Mar 2009 13:03:52 +0100
Message-ID: <49BF91A8.2070900@trash.net>
References: <20090317094909.6434.27331.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, holger@eitzenberger.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45135 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527AbZCQMD7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Mar 2009 08:03:59 -0400
In-Reply-To: <20090317094909.6434.27331.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> This patch adds dynamic message size calculation for ctnetlink. This
> reduces CPU consumption since the overhead in the message trimming
> is removed.
> 
> +static inline size_t
> +ctnetlink_calculate_room_size(const struct nf_conn *ct, unsigned long events)
> +{
> +	size_t size = NLMSG_SPACE(sizeof(struct nfgenmsg));
> +
> +	size += calculate_tuple_room_size(ct) * 2 +  /* original and reply */
> +		nla_total_size(sizeof(u_int32_t)) +  /* status */
> +		nla_total_size(sizeof(u_int32_t));   /* id */
> +
> +#ifdef CONFIG_NF_CONNTRACK_MARK
> +	if (events & IPCT_MARK || ct->mark)
> +		size += nla_total_size(sizeof(u_int32_t));
> +#endif
> +
> +	if (events & IPCT_DESTROY) {
> +		const struct nf_conn_counter *acct;
> +
> +		acct = nf_conn_acct_find(ct);
> +		if (acct) {
> +			size += nla_total_size(0) * 2 +
> +				nla_total_size(sizeof(u_int64_t)) * 2 * 2;
> +		}
> +		return size;
> +	}
> +...

Holger's patch pre-calculates things where possible, which reduces
run-time overhead.

> I'm not sure about this. Instead, I noticed with oprofile that we spend
> more cycles to calculate the message size. I think it's more like a
> trade-off, reducing the message size to what we need reduces the chances
> to hit ENOBUFS.

"More cycles" is to be expected for calculation (which is not done
so far), but summed up, I always suspected a measurement error and
I'd be surprised if this is correct.

So we so far have your numbers, which showed a regression, and no
numbers from Holger, which is slightly better :)

OK seriously, we need *some* numbers showing an improvement since I
have basically zero base to decide between your patches, besides the
fact that its to be expected that Holger's will be slightly faster.
