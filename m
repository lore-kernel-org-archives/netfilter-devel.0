From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] ebtables: Allow RETURN target rules in user defined
 chains
Date: Wed, 28 Oct 2015 03:46:00 +0100
Message-ID: <20151028024600.GB3254@salvia>
References: <5628F57F.1010504@gmail.com>
 <20151028010155.GD9420@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alin Nastac <alin.nastac@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49136 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704AbbJ1Ciy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Oct 2015 22:38:54 -0400
Content-Disposition: inline
In-Reply-To: <20151028010155.GD9420@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Oct 28, 2015 at 02:01:55AM +0100, Florian Westphal wrote:
> Alin Nastac <alin.nastac@gmail.com> wrote:
> > ebtables has a bug that prevents creation of rules with RETURN target, any attempt will result in an
> >    RETURN not allowed on base chain
> > error even if the chain where you want to create the rule is a user defined chain.
> > 
> > Reproduction scenario:
> >    root@OpenWrt:~# ebtables -N foo
> >    root@OpenWrt:~# ebtables -A OUTPUT -j foo
> >    root@OpenWrt:~# ebtables -A foo -j mark --mark-or 3 --mark-target RETURN
> >    --mark-target RETURN not allowed on base chain.
> > 
> > My email client will probably replace tabs in the patch below, but
> 
> Yes, I applied this manually (with minor edits to commit message).

Thanks, I wonder since then this has been broken BTW.
