From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/3] scanner: replace binary characters '&' '|' and '!'
 by their names
Date: Tue, 14 Jan 2014 12:24:36 +0000
Message-ID: <20140114122435.GD27277@macbook.localnet>
References: <1389699030-6301-1-git-send-email-pablo@netfilter.org>
 <1389699030-6301-2-git-send-email-pablo@netfilter.org>
 <20140114120057.GA6957@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33924 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbaANMYk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Jan 2014 07:24:40 -0500
Content-Disposition: inline
In-Reply-To: <20140114120057.GA6957@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 14, 2014 at 01:00:57PM +0100, Pablo Neira Ayuso wrote:
> On Tue, Jan 14, 2014 at 12:30:28PM +0100, Pablo Neira Ayuso wrote:
> > These symbol need to be escaped in bash and can lead to confusion,
> > so let's use their names instead which are still short, eg.
> > 
> >  nft add rule filter output meta mark and 0x3 == 0x1
> > 
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> >  src/scanner.l |    6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/src/scanner.l b/src/scanner.l
> > index cee6aa6..2d7ac88 100644
> > --- a/src/scanner.l
> > +++ b/src/scanner.l
> > @@ -200,9 +200,9 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
> >  "<<"			{ return LSHIFT; }
> >  ">>"			{ return RSHIFT; }
> >  "^"			{ return CARET; }
> 
> Extending this proposal:
> 
> For consistency, we can also rename the caret to 'xor'.
> 
> Regarding <<, we can use lshift, but that's a bit longer.
> 
> We also have >, >=, < and <=. We could use gt, ge, lt, le.

Agreed on all of those, but please also keep the short forms.

> > -"&"			{ return AMPERSAND; }
> > -"|"			{ return '|'; }
> > -"!"			{ return NOT; }
> > +"and"			{ return AMPERSAND; }
> > +"or"			{ return '|'; }
> > +"not"			{ return NOT; }
> >  "/"			{ return SLASH; }
> >  "-"			{ return DASH; }
> >  "*"			{ return ASTERISK; }
> > -- 
> > 1.7.10.4
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
