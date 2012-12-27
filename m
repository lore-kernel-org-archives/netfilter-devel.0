From: Florian Westphal <fw@strlen.de>
Subject: Re: [libnetfilter_conntrack PATCH] Fix logic typo in cmp_secctx
Date: Thu, 27 Dec 2012 15:29:55 +0100
Message-ID: <20121227142955.GB11727@breakpoint.cc>
References: <4631253.eD7KB7KPU6@storm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:44612 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752629Ab2L0O35 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Dec 2012 09:29:57 -0500
Content-Disposition: inline
In-Reply-To: <4631253.eD7KB7KPU6@storm>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thomas Jarosch <thomas.jarosch@intra2net.com> wrote:
> cppcheck reported:
> [src/conntrack/compare.c:364] -> [src/conntrack/compare.c:364]: (style) Same expression on both sides of '||'.
> 
> Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
> ---
>  src/conntrack/compare.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/src/conntrack/compare.c b/src/conntrack/compare.c
> index b18f7fc..e282a24 100644
> --- a/src/conntrack/compare.c
> +++ b/src/conntrack/compare.c
> @@ -361,7 +361,7 @@ cmp_secctx(const struct nf_conntrack *ct1,
>  	   const struct nf_conntrack *ct2,
>  	   unsigned int flags)
>  {
> -	if (ct1->secctx == NULL || ct1->secctx == NULL)
> +	if (ct1->secctx == NULL || ct2->secctx == NULL)

Grrr, my fault.

Applied, thanks for fixing this.
