From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] [PATCH] dynamic calculation of event message size for
 ctnetlink
Date: Wed, 18 Mar 2009 05:41:43 +0100
Message-ID: <49C07B87.90404@trash.net>
References: <20090317094909.6434.27331.stgit@Decadence> <49BF91A8.2070900@trash.net> <20090317121446.GB3526@mail.eitzenberger.org> <49BF94A6.6080508@trash.net> <49C0266B.40204@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Holger Eitzenberger <holger@eitzenberger.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64322 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbZCRElr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Mar 2009 00:41:47 -0400
In-Reply-To: <49C0266B.40204@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
>> Holger Eitzenberger wrote:
>>> On Tue, Mar 17, 2009 at 01:03:52PM +0100, Patrick McHardy wrote:
>>>
>>>> OK seriously, we need *some* numbers showing an improvement since I
>>>> have basically zero base to decide between your patches, besides the
>>>> fact that its to be expected that Holger's will be slightly faster.
>>> I think we can give the hard numbers in the next 1-3 days.  Do you
>>> have a special test in mind?  Pablo, how did you test then?
>> Nothing too complicated. I guess either a raw throughput benchmark,
>> some cycle counting for event delivery or event delivery throughput
>> would all be fine.
> 
> I have done a toy program - I know, it can be improved a lot - to get
> some numbers. Please, find it attached. Here are some results that I got
> in my testbed [1]. Uff, this has been hard as the numbers doesn't seem
> to be very concluding.
> 
> ~24000 HTTP connections/s with no events listener
> 
> = With no patch =
> ~19500 HTTP connections/s
> 
> AVG events/s 71779; enobufs/s=125; in 50 seconds
> AVG events/s 69723; enobufs/s=123; in 89 seconds
> AVG events/s 71061; enobufs/s=120; in 52 seconds
> 
> = With Pablo's =
> ~20500 HTTP connections/s
> 
> AVG events/s 72141; enobufs/s=151; in 65 seconds
> AVG events/s 70287; enobufs/s=141; in 76 seconds
> 
> = With Holger's =
> ~20500-21000 HTTP connections/s
> 
> AVG events/s 68233; enobufs/s=192; in 126 seconds
> AVG events/s 70241; enobufs/s=204; in 76 seconds
> 
> It seems that the results in terms of events/s are similar. While the
> thoughput is slightly higher with Holger's patch, the number of enobufs
> errors also increases, I don't have an explanation why enobufs errors
> increases.

My guess would be that without either patch, the reallocation causes
less socket buffer usage. With approximate allocation, we safe the
CPU overhead of reallocating, but end up using slightly more socket
buffer space. The odd thing is that your patch also seems to increase
the overflow rate, despite using exact allocations.

Just to clarify, the test didn't use "reliable" event deliver, right?

> I still have one concern with Holger's patch and the static calculation
> approach:
> 
> +	len = NLMSG_SPACE(sizeof(struct nfgenmsg))
> +		+ 3 * nla_total_size(0)		/* CTA_TUPLE_ORIG|REPL|MASTER */
> +		+ 3 * nla_total_size(0)		/* CTA_TUPLE_IP */
> +		+ 3 * nla_total_size(0)		/* CTA_TUPLE_PROTO */
> +		+ 3 * NLA_TYPE_SIZE(u_int8_t)	/* CTA_PROTO_NUM */
> +		+ NLA_TYPE_SIZE(u_int32_t)	/* CTA_ID */
> +		+ NLA_TYPE_SIZE(u_int32_t)	/* CTA_STATUS */
> +		+ 2 * nla_total_size(0)		/* CTA_COUNTERS_ORIG|REPL */
> +		+ 2 * NLA_TYPE_SIZE(uint64_t)	/* CTA_COUNTERS_PACKETS */
> +		+ 2 * NLA_TYPE_SIZE(uint64_t)	/* CTA_COUNTERS_BYTES */
> +		+ NLA_TYPE_SIZE(u_int32_t)	/* CTA_TIMEOUT */
> +		+ nla_total_size(0)		/* CTA_PROTOINFO */
> +		+ nla_total_size(0)		/* CTA_HELP */
> +		+ nla_total_size(NF_CT_HELPER_NAME_LEN)	/* CTA_HELP_NAME */
> +		+ NLA_TYPE_SIZE(u_int32_t)	/* CTA_SECMARK */
> +		+ 2 * nla_total_size(0)		/* CTA_NAT_SEQ_ADJ_ORIG|REPL */
> +		+ 2 * NLA_TYPE_SIZE(u_int32_t)	/* CTA_NAT_SEQ_CORRECTION_POS */
> +		+ 2 * NLA_TYPE_SIZE(u_int32_t)	/* CTA_NAT_SEQ_CORRECTION_BEFORE */
> +		+ 2 * NLA_TYPE_SIZE(u_int32_t)	/* CTA_NAT_SEQ_CORRECTION_AFTER */
> +		+ NLA_TYPE_SIZE(u_int32_t);	/* CTA_MARK */
> 
> This calculation results in no message trim if most of those attributes
> are present. However, assuming the worst case (no counters, no helper,
> no mark, no master tuple, etc.), netlink_trim() may be called. My patch
> calculates the exact size, so there's no trimming for any case.

The numbers imply that its still a net win. But its a valid point, if
the common case will still result in reallocations, it might make sense
to include the space for a few of those members optionally to make
sure we don't cross the 50% waste threshold.
