From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC nft] ct expr: make directional keys work
Date: Fri, 18 Dec 2015 21:30:51 +0100
Message-ID: <20151218203051.GA2086@salvia>
References: <20151217005533.GA24044@strlen.de>
 <20151217111334.GA1694@salvia>
 <20151217130344.GA3198@breakpoint.cc>
 <20151218171707.GA29573@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55389 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932736AbbLRUbR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Dec 2015 15:31:17 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 32E9918FDA4
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Dec 2015 21:31:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C241CDA878
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Dec 2015 21:31:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6EC1052CB8
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Dec 2015 21:30:53 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151218171707.GA29573@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 18, 2015 at 06:17:07PM +0100, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > I think this should fit into the grammar that I'm proposing above with
> > > no shift/reduce conflicts, ie.
> > > 
> > > ct packets VALUE
> > > ct direction original packets VALUE
> > > ct direction reply packets VALUE
> > 
> > I'll have to check.  I don't want to add any new keywords to the lexer
> > since that creates more problems for the grammar.
> 
> Drats, it doesn't work.
> conflicts: 1 shift/reduce

Right, the parser doesn't know if it has to reduce

ct direction original

as simple expression, or keep shifting for more tokens.

> 'ct direction' is already a valid expression, it loads
> CTINFO2DIR(ctinfo).
> 
> I'll send what I have in a second, but its not great either.

Wait for it.
