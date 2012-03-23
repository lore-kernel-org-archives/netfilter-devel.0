From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] xt_log.h: don't use xchg() for simple assignment
Date: Fri, 23 Mar 2012 11:07:05 +0100
Message-ID: <20120323100705.GA22309@1984>
References: <4F588DD8020000780007711C@nat28.tlf.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Jan Beulich <JBeulich@suse.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57116 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022Ab2CWKHL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Mar 2012 06:07:11 -0400
Content-Disposition: inline
In-Reply-To: <4F588DD8020000780007711C@nat28.tlf.novell.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 08, 2012 at 09:45:44AM +0000, Jan Beulich wrote:
> At least on ia64 the (bogus) use of xchg() here results in the compiler
> warning about an unused expression result. As only an assignment is
> intended here, convert it to such.
> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> 
> ---
>  include/net/netfilter/xt_log.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- 3.3-rc6/include/net/netfilter/xt_log.h
> +++ 3.3-rc6-netfilter-xt_log-no-xchg/include/net/netfilter/xt_log.h
> @@ -47,7 +47,7 @@ static void sb_close(struct sbuff *m)
>  	if (likely(m != &emergency))
>  		kfree(m);
>  	else {
> -		xchg(&emergency_ptr, m);
> +		emergency_ptr = m;

That xchg is there for some reason. I think it's better if you just
cast it to void.
