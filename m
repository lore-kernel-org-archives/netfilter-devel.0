From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 nf-next 1/9] netfilter: ingress: don't use
 nf_hook_list_active
Date: Fri, 6 Nov 2015 19:33:54 +0100
Message-ID: <20151106183354.GA2147@salvia>
References: <1445597006-11264-1-git-send-email-fw@strlen.de>
 <1445597006-11264-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50449 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335AbbKFS0b (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Nov 2015 13:26:31 -0500
Content-Disposition: inline
In-Reply-To: <1445597006-11264-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 23, 2015 at 12:43:18PM +0200, Florian Westphal wrote:
> nf_hook_list_active() always returns true once at least one device has
> NF_INGRESS hook enabled.
> 
> Thus, don't use this function. Instead, inverse the test and use the static
> key to elide list_empty test if no NF_INGRESS hooks are active.

Florian, I think this qualifies as a fix, I'm going to apply this to
the nf tree.

Thanks.
