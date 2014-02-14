From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: nf_tables: fix rule batch with anonymous set
 and module autoload
Date: Fri, 14 Feb 2014 11:37:56 +0000
Message-ID: <20140214113755.GC19082@macbook.localnet>
References: <1392377228-3748-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49143 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbaBNLiA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Feb 2014 06:38:00 -0500
Content-Disposition: inline
In-Reply-To: <1392377228-3748-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[ sorry accidentally dropped netfilter-devel ]

On Fri, Feb 14, 2014 at 12:27:08PM +0100, Pablo Neira Ayuso wrote:
> If some modules are missing while processing a rule batch, the updates
> are aborted to start scratch since the nfnl lock was released. If the
> rule-set contains this configuration (in this order):
> 
>  #1 rule using anonymous set
>  #2 rule requiring module autoload
> 
> The anonymous set will be released when aborting. This patch fixes this
> by passing a context variable (autoload) that can be used to decide if
> the anonymous set has to be released or not.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> I guess we can encapsulate that autoload into a context information structure
> in the future in case any other information is needed in the rule destroy path
> to make this look nicer.
>
> I started hacking on two patches to net-next, one to include table, chains and
> set into the batch and follow up to add atomic updates for sets. @Patrick: I
> think that should not interfer with your set enhancements.

Wouldn't be a big problem, they're pretty much contained to newset().

Regarding this patch - I'd really prefer to just fix batches to include sets
instead of changing all these function signatures just to handle this very
specific case.

I'm wondering how this will work in case of anonymous sets though, right now
we need two transactions so userspace can attach the new set to the lookup
expression.
