From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netfilter: xt_TCPOPTSTRIP: fix possible mangling
 beyond packet boundary
Date: Wed, 15 May 2013 14:33:36 +0200
Message-ID: <20130515123336.GE18095@breakpoint.cc>
References: <1368619552-30635-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:48047 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758567Ab3EOMdj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 May 2013 08:33:39 -0400
Content-Disposition: inline
In-Reply-To: <1368619552-30635-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> This target assumes that tcph->doff is well-formed, that may be well
> not the case. Add extra sanity checkings to avoid possible crash due
> to read/write out of the real packet boundary.

>  static unsigned int
>  tcpoptstrip_mangle_packet(struct sk_buff *skb,
> -			  const struct xt_tcpoptstrip_target_info *info,
> +			  const struct xt_action_param *par,
>  			  unsigned int tcphoff, unsigned int minlen)
>  {
> +	const struct xt_tcpoptstrip_target_info *info = par->targinfo;
>  	unsigned int optl, i, j;
>  	struct tcphdr *tcph;
>  	u_int16_t n, o;
>  	u_int8_t *opt;
> +	int len;
> +
[..]
> +	len = skb->len - tcphoff;
> +	if (len < sizeof(struct tcphdr))

I think this needs a cast 'if (len < (int) sizeof( ...?

> @@ -51,7 +67,7 @@ tcpoptstrip_mangle_packet(struct sk_buff *skb,
>  	for (i = sizeof(struct tcphdr); i < tcp_hdrlen(skb); i += optl) {
>  		optl = optlen(opt, i);
>  
> -		if (i + optl > tcp_hdrlen(skb))
> +		if (i + optl > len)
>  			break;

I don't understand this change.  This should stop parsing if the
option length points outside of the tcp option size.

But doesn't len include the size of the actual payload?
