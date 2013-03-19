From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH RFC 1/3] NFQUEUE: introduce CPU fanout
Date: Tue, 19 Mar 2013 10:37:08 -0400 (EDT)
Message-ID: <20130319.103708.24746976367419338.davem@davemloft.net>
References: <20130319141605.158831637@eitzenberger.org>
	<20130319.102620.2063759629502166169.davem@davemloft.net>
	<alpine.LNX.2.01.1303191531210.9679@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: holger@eitzenberger.org, netfilter-devel@vger.kernel.org
To: jengelh@inai.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:43333 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756775Ab3CSOhK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:37:10 -0400
In-Reply-To: <alpine.LNX.2.01.1303191531210.9679@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jan Engelhardt <jengelh@inai.de>
Date: Tue, 19 Mar 2013 15:34:56 +0100 (CET)

> 
> On Tuesday 2013-03-19 15:26, David Miller wrote:
>>
>>> +			if (par->family == NFPROTO_IPV4)
>>> +				queue = (((u64) hash_v4(skb) * info->queues_total) >>
>>> +						 32) + queue;
>>> +#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
>>> +			else if (par->family == NFPROTO_IPV6)
>>> +				queue = (((u64) hash_v6(skb) * info->queues_total) >>
>>> +						 32) + queue;
>>> +#endif
>>
>>Maybe add a helper function so you don't have to indent so deeply.  Something
>>like:
> 
> And combined with smart arranging of clauses, won't need an extra 
> helper function.
> http://www.braceless.org/Various/The%20Else%20Statement%20Considered%20Harmful
> 
> Something like

Yes, but:

> +		queue = (((u64) hash_v4(skb) * info->queues_total) >>
> +				 32) + queue;
                                 ^^^^^^

it's that terribly indented giblet that I want to disappear.
