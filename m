From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 2/2] src: rename ct eventmask to event
Date: Wed, 7 Jun 2017 13:27:50 +0200
Message-ID: <20170607112750.GA9759@salvia>
References: <20170607102410.21024-1-fw@strlen.de>
 <20170607102410.21024-2-fw@strlen.de>
 <20170607103820.GB9280@salvia>
 <20170607110751.GC18283@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36836 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751414AbdFGL1z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Jun 2017 07:27:55 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EE27A2519A7
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Jun 2017 13:27:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BF62310218B
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Jun 2017 13:27:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A9C15102194
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Jun 2017 13:27:43 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170607110751.GC18283@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 07, 2017 at 01:07:51PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Wed, Jun 07, 2017 at 12:24:10PM +0200, Florian Westphal wrote:
> > > diff --git a/tests/py/any/ct.t b/tests/py/any/ct.t
> > > index 667126e656ae..1c90ec1c769d 100644
> > > --- a/tests/py/any/ct.t
> > > +++ b/tests/py/any/ct.t
> > > @@ -100,11 +100,11 @@ ct original mark 42;fail
> > [...]
> > > +ct event set new or related or destroy or foobar;fail
> > > +ct event set 'new | related | destroy | label';ok;ct event set new | related | destroy | label
> > 
> > I would replace this by the new syntax in the tests too.
> > 
> > So anyone looking at test for example relies on this new one, it is
> > more compact and readable IMO.
> 
> Good point, we still print
> ct event set new | related | destroy | label
> 
> because we lack the OP_FLAGCMP postprocessing that relational expression
> does (it converts the rhs binops into list in case of OP_FLAGCMP).
> 
> Flagcmp is also a bit different thing:
>    tcp flags syn,ack
> is short-hand for
>    'tcp flags & (syn|ack) != 0'
> 
> but when using 'ct event set foo,bar'
> its same as
> ct event set foo|bar.
> 
> This gets ugly... I see no way to autodetect which output format
> we should use.
>
> I could of course stick a check for the key type into
> netlink_delinerize.c but thats ugly.
> 
> Alterntively I could hook into ct_stmt_print and dissect there.
> 
> Any idea/preference?

I suggest you always use the comma separated one to print this.

This assymmetry is not a problem, what matters if that the internal
AST representation end up being the same, which is what matters to the
delete by name (if that is your primary concern with this). So it's
not that we need the same syntax in both directions specifically, but
the same internal representation for both.

So we just need that the evaluation transform these or syntax to
OP_FLAGCMP.

Actually, I remember to have discussed with Laura ideas to kill
OP_FLAGCMP and just convert this to binary, specifically, I need to
look back at the archive, but I think the problem is to check for
flaglist mismatch.

Anyway, at this stage, I would suggest you just update this to print
it in comma separated output.
