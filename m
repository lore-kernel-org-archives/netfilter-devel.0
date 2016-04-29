From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next] netfilter: fix IS_ERR_VALUE usage
Date: Fri, 29 Apr 2016 11:17:54 +0200
Message-ID: <20160429091754.GN17538@breakpoint.cc>
References: <1461920038-6795-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, a.hajda@samsung.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:42899 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752599AbcD2JR6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Apr 2016 05:17:58 -0400
Content-Disposition: inline
In-Reply-To: <1461920038-6795-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> This is a forward-ported original patch from Andrzej Hajda, he said:
> 
> "IS_ERR_VALUE should be used only with unsigned long type.
> Otherwise it can work incorrectly. To achieve this function
> xt_percpu_counter_alloc is modified to return unsigned long,
> and its result is assigned to temporary variable to perform
> error checking, before assigning to .pcnt field.
> 
> The patch follows conclusion from discussion on LKML [1][2].
> 
> [1]: http://permalink.gmane.org/gmane.linux.kernel/2120927
> [2]: http://permalink.gmane.org/gmane.linux.kernel/2150581"
> 
> Original patch from Andrzej is here:
> 
> http://patchwork.ozlabs.org/patch/582970/
> 
> This patch has clashed with input validation fixes for x_tables.

AFAICS this isn't a bug fix so I'm fine with this going into nf-next.
