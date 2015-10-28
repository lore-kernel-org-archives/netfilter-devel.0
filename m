From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] ebtables: Allow RETURN target rules in user defined
 chains
Date: Wed, 28 Oct 2015 14:31:34 +0100
Message-ID: <20151028133134.GA24571@breakpoint.cc>
References: <5628F57F.1010504@gmail.com>
 <20151028010155.GD9420@breakpoint.cc>
 <20151028024600.GB3254@salvia>
 <20151028024625.GA3301@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	Alin Nastac <alin.nastac@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:57705 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753221AbbJ1Nbi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Oct 2015 09:31:38 -0400
Content-Disposition: inline
In-Reply-To: <20151028024625.GA3301@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Oct 28, 2015 at 03:46:00AM +0100, Pablo Neira Ayuso wrote:
> > On Wed, Oct 28, 2015 at 02:01:55AM +0100, Florian Westphal wrote:
> > > Alin Nastac <alin.nastac@gmail.com> wrote:
> > > > ebtables has a bug that prevents creation of rules with RETURN target, any attempt will result in an
> > > >    RETURN not allowed on base chain
> > > > error even if the chain where you want to create the rule is a user defined chain.
> > > > 
> > > > Reproduction scenario:
> > > >    root@OpenWrt:~# ebtables -N foo
> > > >    root@OpenWrt:~# ebtables -A OUTPUT -j foo
> > > >    root@OpenWrt:~# ebtables -A foo -j mark --mark-or 3 --mark-target RETURN
> > > >    --mark-target RETURN not allowed on base chain.
> > > > 
> > > > My email client will probably replace tabs in the patch below, but
> > > 
> > > Yes, I applied this manually (with minor edits to commit message).
> > 
> > Thanks, I wonder since then this has been broken BTW.
> 
> s/then/when/

Seems it never worked.

I hacked 'allow checking for --xxxx--target RETURN rules on base chains'
commit from 2002 to build and it rejects RETURN unconditionally.
