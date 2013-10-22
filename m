From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] statement: avoid huge rodata array
Date: Tue, 22 Oct 2013 15:18:41 +0200
Message-ID: <20131022131841.GA7127@localhost>
References: <1382445302-8050-1-git-send-email-fw@strlen.de>
 <20131022131241.GE12157@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45419 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533Ab3JVNSr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Oct 2013 09:18:47 -0400
Content-Disposition: inline
In-Reply-To: <20131022131241.GE12157@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 22, 2013 at 03:12:41PM +0200, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
> > commit b259d1a ('src: operational limit match') creates huge
> > array, increasing nft binary size from ~240k to ~5m on x86_64.
> > 
> > Use switch statement instead.
> 
> Applied,
> 
> > +static const char *get_unit(uint64_t u)
> > +{
> > +	switch (u) {
> > +	case 1: return "seconds";
> 
> ... after changing this to 'second', spotted by Phil Oester.

Please, push a patch to change libnftables to 'second'. Thanks!
