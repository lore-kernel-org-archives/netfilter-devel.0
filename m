From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: Re: [PATCH RFC 1/3] NFQUEUE: introduce CPU fanout
Date: Tue, 19 Mar 2013 22:34:24 +0100
Message-ID: <20130319213424.GE13505@imap.eitzenberger.org>
References: <20130319141442.150005875@eitzenberger.org>
 <20130319141605.158831637@eitzenberger.org>
 <20130319.102620.2063759629502166169.davem@davemloft.net>
 <alpine.LNX.2.01.1303191531210.9679@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:61512 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933832Ab3CSVe1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Mar 2013 17:34:27 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1303191531210.9679@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

> http://www.braceless.org/Various/The%20Else%20Statement%20Considered%20Harmful
> 
> Something like
> 
> +static unsigned int
> +nfqueue_tg_v3(struct sk_buff *skb, const struct xt_action_param *par)
> +{
> +	const struct xt_NFQ_info_v3 *info = par->targinfo;
> +	u32 queue = info->queuenum;
> +
> +	if (info->queues_total == 1)
> +		return NF_QUEUE_NR(queue);
> +	if (info->flags & NFQ_FLAG_CPU_FANOUT) {
> +		int cpu = smp_processor_id();
> +
> +		queue = info->queuenum + cpu % info->queues_total;
> +	} else if (par->family == NFPROTO_IPV4) {
> +		queue = (((u64) hash_v4(skb) * info->queues_total) >>
> +				 32) + queue;
> +#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
> +	} else if (par->family == NFPROTO_IPV6) {
> +		queue = (((u64) hash_v6(skb) * info->queues_total) >>
> +				 32) + queue;
> +	}
> +#endif
> +	return NF_QUEUE_NR(queue);
> +}

having read through the webpage - and using 'goto' for error handling
in own code quite often - I don't see why your code above should be
more readable.

