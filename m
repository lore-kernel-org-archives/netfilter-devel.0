From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Accounting objects support in nft
Date: Mon, 12 Jan 2015 14:38:14 +0100
Message-ID: <20150112133814.GA3669@salvia>
References: <cover.1421059192.git.ana@soleta.eu>
 <CAOkSjBi6K9t0W5Nv=mBwNUMbzT3UeFsMoadqzkBpSfDqJ3tJUQ@mail.gmail.com>
 <20150112123516.GA4546@salvia>
 <20150112123711.GL3491@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	ana@soleta.eu,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33403 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111AbbALNfZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jan 2015 08:35:25 -0500
Content-Disposition: inline
In-Reply-To: <20150112123711.GL3491@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 12, 2015 at 12:37:11PM +0000, Patrick McHardy wrote:
> On 12.01, Pablo Neira Ayuso wrote:
> > On Mon, Jan 12, 2015 at 12:48:35PM +0100, Arturo Borrero Gonzalez wrote:
> > > On 12 January 2015 at 11:55,  <ana@soleta.eu> wrote:
> > > >
> > > > table ip filter {
> > > >         acct http-traffic { pkts 779 bytes 99495}
> > > >         acct https-traffic { pkts 189 bytes 37824}
> > > >
> > > >         chain output {
> > > >              type filter hook output priority 0;
> > > >              tcp dport http acct http-traffic
> > > >              tcp dport https acct https-traffic
> > > >         }
> > > > }
> > > >
> > >
> > > Interesting, Ana!
> > >
> > > I understand that acct objects are bounded to a table/family.
> > > Why not make them globals? So we could increment same counters from
> > > different families/tables.
> > 
> > Indeed. The existing binding between acct and tables is superfluous.
> > With sets, we need that to check for loops in verdict maps.
> > 
> > So counters can become also top-level identifier as it happens with
> > tables, ie.
> > 
> > counters {
> >         http-traffic { pkts 779 bytes 99495}
> >         acct https-traffic { pkts 189 bytes 37824}
> > }
> > 
> > table ip filter {
> >         chain output {
> >              type filter hook output priority 0;
> >              tcp dport http counter http-traffic
> >              tcp dport https counter https-traffic
> >         }
> > }
> > 
> > Patrick, any comment on that?
> 
> I'm unsure, we don't have any global objects so far, this might open
> another can of flushing/ordering etc problems. If it works without
> problems, I can see both variants being useful. Given that we only
> need a list to store them we might be able to support both by minor
> adjustments to the lookup function.
> 
> If we do actually want to support both, I'd suggest to start using
> just table scope and expand it later.

Agreed.
