From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v2] parser: add kludges for "param-problem" and "redirect"
Date: Sun, 5 Apr 2015 13:42:23 +0200
Message-ID: <20150405114215.GB23433@acer.localdomain>
References: <551FC211.6000907@ahsoftware.de>
 <1428145986-15421-1-git-send-email-holler@ahsoftware.de>
 <20150404115550.GA5832@salvia>
 <551FD970.7030105@ahsoftware.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Eric Leblond <eric@regit.org>
To: Alexander Holler <holler@ahsoftware.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57407 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbbDELm1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Apr 2015 07:42:27 -0400
Content-Disposition: inline
In-Reply-To: <551FD970.7030105@ahsoftware.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 04.04, Alexander Holler wrote:
> Am 04.04.2015 um 13:55 schrieb Pablo Neira Ayuso:
> > On Sat, Apr 04, 2015 at 01:13:06PM +0200, Alexander Holler wrote:
> >> Context sensitive handling of "param-problem" and "redirect" is necessary
> >> to allow usage of them as token or as string for icmp types.
> > [...]
> > 
> > I think we need some evaluation step at scanner level. This new
> > evaluation routine needs to understand the token semantics to set some
> > context information.
> > 
> > "redirect"		{ return scanner_evaluate(ctx, REDIRECT); }
> > 
> > We have to catch up more use cases such as sets and concatenations. I
> > started a patch here, a bit more generalized than this when you
> > reported this problem (we actually already knew about it).
> > 
> > @Patrick, any better idea?
> 
> Hmm. Looks ambitious.
> 
> I've no idea if it's worse to spend the time to build a general solution
> instead of doing it like I did. It looks like you want to build a state
> machine inside that scanner_evaluate() which means you have to use it
> for every token, if I've understood your idea correctly.
> 
> How many ambigious tokens do exist besides redirect and param-problem
> for which I've now added a "mini state machine"?

These cases keep coming up and we actually can't even know all cases
since many expressions use externally defined constants, f.i. services,
routing marks, realms etc, interface names and many more. We really
need a generic solution, at least in the mid term.

> Sorry, but I'm not actively following this project or the mailing lists,
> and thus have no real overview over existing problems. I've just fixed a
> problem I've encountered while switching some of my systems from
> iptables to nftables.

I'm not opposed to a short term fix until we have something generic.
However we used a different approach so far (for different cases though)
and I'd like to at least check whether something similar will work
in this case.
