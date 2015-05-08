From: Florian Westphal <fw@strlen.de>
Subject: Re: [iptables PATCH 2/2 RFC] Remove Libc5 support code
Date: Fri, 8 May 2015 16:04:50 +0200
Message-ID: <20150508140450.GK21713@breakpoint.cc>
References: <20150502195138.GB17994@euler>
 <20150504104809.GH22481@breakpoint.cc>
 <20150504105543.GA3622@salvia>
 <alpine.DEB.2.10.1505041332380.12388@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Felix Janda <felix.janda@posteo.de>,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58066 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752734AbbEHOEz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 May 2015 10:04:55 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1505041332380.12388@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:
> > On Mon, May 04, 2015 at 12:48:09PM +0200, Florian Westphal wrote:
> > > Felix Janda <felix.janda@posteo.de> wrote:
> > > > Current code makes the assumption that !defined(__GLIBC__) means libc5
> > > > which is very unlikely the case nowadays.
> > > > 
> > > > Fixes compile error because of conflict between kernel and musl headers.
> > > > ---
> > > > If libc5 is considered still relevant, I could try to come up with an
> > > > autoconf test.
> > > 
> > > I'm all for removing libc5 support if this is whats preventing iptables
> > > to be built with current non-glibc systems.
> > > 
> > > Pablo, Patrick, Eric, Jozsef - whats your take on this?
> > 
> > I would say, go take it.
> 
> I second that.

I've applied this patch, thanks everyone.
