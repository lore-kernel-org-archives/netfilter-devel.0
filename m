From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v2] extensions: libxt_NFQUEUE: Add translation to nft
Date: Sun, 7 Feb 2016 10:25:04 +0100
Message-ID: <20160207092504.GB32181@breakpoint.cc>
References: <20160207060721.GA11310@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:48228 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752104AbcBGJZH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Feb 2016 04:25:07 -0500
Content-Disposition: inline
In-Reply-To: <20160207060721.GA11310@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Shivani Bhardwaj <shivanib134@gmail.com> wrote:
> $ sudo iptables-translate -t nat -A PREROUTING -p tcp --dport 80 -j NFQUEUE --queue-num 30
> nft add rule ip nat PREROUTING tcp dport 80 counter queue num 30
> 
> $ sudo iptables-translate -A FORWARD -j NFQUEUE --queue-num 0 --queue-bypass -p TCP --sport 80
> nft add rule ip filter FORWARD tcp sport 80 counter queue num 0 bypass
> 
> $ sudo iptables-translate -A FORWARD -j NFQUEUE --queue-bypass -p TCP --sport 80 --queue-balance 0:3 --queue-cpu-fanout
> nft add rule ip filter FORWARD tcp sport 80 counter queue num 0-3 bypass,fanout

translation look correct, thanks!

> +bool sep_need = false;

Is this really needed?
If it is, please add static keyword too.

> +static int NFQUEUE_xlate_v2(const struct xt_entry_target *target,
> +			    struct xt_xlate *xl, int numeric)
> +{
> +	const struct xt_NFQ_info_v2 *info = (void *) target->data;
> +
> +	NFQUEUE_xlate_v1(target, xl, numeric);
> +
> +	if (info->bypass & NFQ_FLAG_BYPASS) {
> +		xt_xlate_add(xl, "bypass");
> +		sep_need = true;
> +	}
> +
> +	return 1;
> +}
> +
> +static int NFQUEUE_xlate_v3(const struct xt_entry_target *target,
> +			    struct xt_xlate *xl, int numeric)
> +{
> +	const struct xt_NFQ_info_v3 *info = (void *)target->data;
> +
> +	NFQUEUE_xlate_v2(target, xl, numeric);
> +	if (info->flags & NFQ_FLAG_CPU_FANOUT)
> +		xt_xlate_add(xl, "%sfanout ", sep_need ? "," : "");
> +

Seems this could be written similar to something like:

if (info->flags & NFQ_FLAG_CPU_FANOUT) {
	bool sep_needed = info->bypass & NFQ_FLAG_BYPASS;
	xt_xlate_add(xl, "%sfanout ", sep_need ? "," : "");
...
