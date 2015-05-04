From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables PATCH 2/2 RFC] Remove Libc5 support code
Date: Mon, 4 May 2015 12:55:43 +0200
Message-ID: <20150504105543.GA3622@salvia>
References: <20150502195138.GB17994@euler>
 <20150504104809.GH22481@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Felix Janda <felix.janda@posteo.de>,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59856 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225AbbEDKvF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 May 2015 06:51:05 -0400
Content-Disposition: inline
In-Reply-To: <20150504104809.GH22481@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, May 04, 2015 at 12:48:09PM +0200, Florian Westphal wrote:
> Felix Janda <felix.janda@posteo.de> wrote:
> > Current code makes the assumption that !defined(__GLIBC__) means libc5
> > which is very unlikely the case nowadays.
> > 
> > Fixes compile error because of conflict between kernel and musl headers.
> > ---
> > If libc5 is considered still relevant, I could try to come up with an
> > autoconf test.
> 
> I'm all for removing libc5 support if this is whats preventing iptables
> to be built with current non-glibc systems.
> 
> Pablo, Patrick, Eric, Jozsef - whats your take on this?

I would say, go take it.
