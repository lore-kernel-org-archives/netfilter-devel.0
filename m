From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH next 1/3] netfilter: limit, hashlimit: avoid duplicated
 inline
Date: Wed, 9 May 2012 13:25:11 +0200
Message-ID: <20120509112511.GA23062@1984>
References: <1336423905-23919-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59249 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758398Ab2EILZQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 May 2012 07:25:16 -0400
Content-Disposition: inline
In-Reply-To: <1336423905-23919-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, May 07, 2012 at 10:51:43PM +0200, Florian Westphal wrote:
> credit_cap can be set to credit, which avoids inlining user2credits
> twice. Also, remove inline keyword and let compiler decide.
> 
> old:
>     684     192       0     876     36c net/netfilter/xt_limit.o
>    4927     344      32    5303    14b7 net/netfilter/xt_hashlimit.o
> now:
>     668     192       0     860     35c net/netfilter/xt_limit.o
>    4793     344      32    5169    1431 net/netfilter/xt_hashlimit.o
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Applied, thanks.
