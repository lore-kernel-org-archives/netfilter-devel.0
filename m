From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v2] nfnetlink_queue: add security context information
Date: Mon, 25 May 2015 22:52:10 +0200
Message-ID: <20150525205210.GG3629@breakpoint.cc>
References: <5562F661.5000503@samsung.com>
 <20150525131319.GA3529@salvia>
 <55634935.4020100@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Roman Kubiak <r.kubiak@samsung.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:41971 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751207AbbEYUwO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 May 2015 16:52:14 -0400
Content-Disposition: inline
In-Reply-To: <55634935.4020100@samsung.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Roman Kubiak <r.kubiak@samsung.com> wrote:
> [sidenote]
> The additional NULL at the end of the security context is there because SMACK does not add this
> to it's labels while SELinux does. So in order to avoid checking i just add it always.
> This additional byte is also represented when calculating the size.
> I did that because we are not transmitting the size of the context and there is no specified
> max length so it has to be NULL terminated (at least it seemed like a valid solution)

The netlink header contains the size of the attribute.
I'd prefer to not have the kernel deal with NULL termination.

> +static u32 nfqnl_get_sk_secctx(struct sock *sk, char **secdata)
> +{
> +	u32 secid = 0;
> +	u32 seclen = 0;
> +	int ret = -1;
> +
> +	if (!sk || !sk_fullsock(sk))
> +		return ret;

return 0/return seclen?

> +	if ((queue->flags & NFQA_CFG_F_SECCTX) && entskb->sk) {
> +		seclen = nfqnl_get_sk_secctx(entskb->sk, &secdata);
> +			if (seclen > 0)
> +				size += nla_total_size(seclen) + 1;

Wrong intent level for if (seclen > 0)

Other than this, it looks ok to me.
