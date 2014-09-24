From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] parser: simplify monitor command parsing
Date: Wed, 24 Sep 2014 13:42:57 +0200
Message-ID: <20140924114257.GD18799@acer.localdomain>
References: <1410939907-10180-1-git-send-email-kaber@trash.net>
 <CAOkSjBgHZ4aG7Qog1pOtCHS=YDmLiJi11eXPxdY20oDNgPE1bA@mail.gmail.com>
 <20140917080115.GB10380@acer.localdomain>
 <1411548406.10103.1.camel@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56441 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbaIXLnB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Sep 2014 07:43:01 -0400
Content-Disposition: inline
In-Reply-To: <1411548406.10103.1.camel@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Sep 24, 2014 at 10:46:46AM +0200, Eric Leblond wrote:
> Hi,
> 
> On Wed, 2014-09-17 at 10:01 +0200, Patrick McHardy wrote:
> > On Wed, Sep 17, 2014 at 09:52:11AM +0200, Arturo Borrero Gonzalez wrote:
> > > On 17 September 2014 09:45, Patrick McHardy <kaber@trash.net> wrote:
> > > > Add tokens for "new" and "destroy". Split up the monitor flags into an
> > > > event and an object to avoid lots of duplicated code.
> > > >
> > > > Signed-off-by: Patrick McHardy <kaber@trash.net>
> > > > ---
> > > 
> > > I think the 'new' keyword may clash with 'ct new', don't you?. That's
> > > why Pablo did the parser that way.
> > 
> > Right. The split into event and object still saves a lot of code, I'll
> > add back the strcmp if I can't think of a nicer way to fix this.
> > 
> > I'm working on command line completion based on the bison grammar, so
> > I'd prefer to only use strings for identifiers, not for keywords.
> 
> I confirm that 102c300 "parser: simplify monitor command parsing" breaks
> the "ct state new" filter so current nftables git is not usable. 
> 
> For the record the error is the following:
>  nft> add rule inet filter input ct state new
>  <cli>:1:37-39: Error: syntax error, unexpected new
>  add rule inet filter input ct state new
>                                      ^^^ 
> 
> And this is also caught by regression tests:
> nftables/tests/regression# ./nft-test.py any/ct.t 
> any/ct.t: ERROR: line 10: nft add rule -nnn ip test-ip4 output ct state new,established, related, untracked: This rule should not have failed.
> any/ct.t: ERROR: line 12: nft add rule -nnn ip test-ip4 output ct state {new,established, related, untracked}: This rule should not have failed.
> 
> Patrick, let me know if you can look into it. If not I will try to have
> a look this week end or next week.

I have a rather large patchset that reorganizes the parser and fixes
this for all constants that clash with keywords, but it will take a
day or two.
