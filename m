From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH -next 1/2] netfilter: ctnetlink: refactor
 ctnetlink_create_expect
Date: Thu, 8 Aug 2013 14:28:39 +0200
Message-ID: <20130808122839.GE29345@breakpoint.cc>
References: <1375954280-6579-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:35806 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752515Ab3HHM2l (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Aug 2013 08:28:41 -0400
Content-Disposition: inline
In-Reply-To: <1375954280-6579-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> This patch refactors ctnetlink_create_expect by spliting it in two
> chunks. As a result, we have a new function ctnetlink_alloc_expect
> to allocate and to setup the expectation from ctnetlink.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> +ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
> +		       struct nf_conntrack_tuple *tuple,
> +		       struct nf_conntrack_tuple *mask)
>  {
[..]
>  #ifdef CONFIG_MODULES
> -			if (request_module("nfct-helper-%s", helpname) < 0) {
> -				err = -EOPNOTSUPP;
> -				goto out;
> -			}
> +			if (request_module("nfct-helper-%s", helpname) < 0)
> +				return ERR_PTR(-EOPNOTSUPP);

Not sure if I decoded the diff correctly, but AFAIU this
function can now be called from rcu protected section (nfqueue verdict
handler), so request_module might not be safe.
