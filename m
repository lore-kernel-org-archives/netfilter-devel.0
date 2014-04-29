From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: ctnetlink: don't add null bindings if no nat
 requested
Date: Tue, 29 Apr 2014 21:03:24 +0200
Message-ID: <20140429190324.GA10858@localhost>
References: <1398712051-1684-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48438 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933428AbaD2TDc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Apr 2014 15:03:32 -0400
Content-Disposition: inline
In-Reply-To: <1398712051-1684-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Apr 28, 2014 at 09:07:31PM +0200, Florian Westphal wrote:
> commit 0eba801b64cc8284d9024c7ece30415a2b981a72 tried to fix a race
> where nat initialisation can happen after ctnetlink-created conntrack
> has been created.
> 
> However, it causes the nat module(s) to be loaded needlessly on
> systems that are not using NAT.
> 
> Fortunately, we do not have to create null bindings in that case.
> 
> conntracks injected via ctnetlink always have the CONFIRMED bit set,
> which prevents addition of the nat extension in nf_nat_ipv4/6_fn().
> 
> We only need to make sure that either no nat extension is added
> or that we've created both src and dst manips.

Thanks Florian, applied.
