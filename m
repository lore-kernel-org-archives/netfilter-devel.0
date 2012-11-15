From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 2/3] api: add connlabel api and attribute
Date: Thu, 15 Nov 2012 22:07:11 +0100
Message-ID: <20121115210711.GJ20678@breakpoint.cc>
References: <1352994611-3707-1-git-send-email-fw@strlen.de>
 <1352994611-3707-3-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:42282 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750766Ab2KOVfi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2012 16:35:38 -0500
Content-Disposition: inline
In-Reply-To: <1352994611-3707-3-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> wrote:
> --- a/src/conntrack/api.c
> +++ b/src/conntrack/api.c
> @@ -95,6 +95,8 @@ void nfct_destroy(struct nf_conntrack *ct)
>  		free(ct->secctx);
>  	if (ct->helper_info)
>  		free(ct->helper_info);
> +	if (ct->connlabels)
> +		nfct_bitmask_destroy(ct->connlabels);
>  	free(ct);
>  	ct = NULL; /* bugtrap */
>  }

Will cause double-free for nfct_cloned objects.

I'll fix nfct_clone and will add the missing nfct_copy*
handling in the next iteration, some time next week.
