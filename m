From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [iptables PATCH 2/2 RFC] Remove Libc5 support code
Date: Mon, 4 May 2015 13:34:05 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1505041332380.12388@blackhole.kfki.hu>
References: <20150502195138.GB17994@euler> <20150504104809.GH22481@breakpoint.cc> <20150504105543.GA3622@salvia>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Florian Westphal <fw@strlen.de>,
	Felix Janda <felix.janda@posteo.de>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:54280 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922AbbEDLdp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 May 2015 07:33:45 -0400
In-Reply-To: <20150504105543.GA3622@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 4 May 2015, Pablo Neira Ayuso wrote:

> On Mon, May 04, 2015 at 12:48:09PM +0200, Florian Westphal wrote:
> > Felix Janda <felix.janda@posteo.de> wrote:
> > > Current code makes the assumption that !defined(__GLIBC__) means libc5
> > > which is very unlikely the case nowadays.
> > > 
> > > Fixes compile error because of conflict between kernel and musl headers.
> > > ---
> > > If libc5 is considered still relevant, I could try to come up with an
> > > autoconf test.
> > 
> > I'm all for removing libc5 support if this is whats preventing iptables
> > to be built with current non-glibc systems.
> > 
> > Pablo, Patrick, Eric, Jozsef - whats your take on this?
> 
> I would say, go take it.

I second that.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
