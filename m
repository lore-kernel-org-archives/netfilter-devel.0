From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] src: add xt compat support
Date: Tue, 2 Jul 2013 00:20:20 +0200
Message-ID: <20130701222020.GA4082@localhost>
References: <1372608125-28734-1-git-send-email-pablo@netfilter.org>
 <51D12B42.40806@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net, eric@regit.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49846 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753736Ab3GAWUn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Jul 2013 18:20:43 -0400
Content-Disposition: inline
In-Reply-To: <51D12B42.40806@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 01, 2013 at 10:09:54AM +0300, Tomasz Bursztyka wrote:
> Hi Pablo,
> 
> Are you sure you want this feature?
> iptables-nftables has been planned to provide full compat with
> iptables, so it hides the nft commands.
>
> But, little by little, the point is to move on with nft tool only,
> when people will realize it brings cooler stuff.
> And I am afraid that, with such patch, we are going to maintain
> legacy stuff also in nft.
> 
> To me I see iptables-nftables being the only entry point for legacy
> commands, and nowhere else.

We can add native nft interfaces to several of the existing xt
matches/targets, no need to reimplement all of them from scratch, we
can reuse many of the existing xt extensions by adding nft interfaces.

If iptables-nftables starts translating existing matches/targets to
native nft expressions, users will get their rule-set automatically
translated to native nft expressions. Thus, they will get rid of the
old rule expressed using the binary xt interface with no work at all.
That can happen progressively, as iptables-nftables will provide more
and more native replacements.

> Being able to list partially match/target (type and names) would be
> fine. But manipulating those should be only through
> iptables-nftables imho.

With this approach, if we export all rules (including those using xt
stuff) via `nft list table', then we cannot use that output to reload
it via nft -f. We would have to ignore those rules. That will be
problematic.
