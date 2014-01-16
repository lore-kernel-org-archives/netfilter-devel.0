From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nftables] fix parser.h recursive inclusion
Date: Thu, 16 Jan 2014 18:38:04 +0000
Message-ID: <20140116183804.GB30318@macbook.localnet>
References: <20140116180426.GA12421@macbook.localnet>
 <20140116181520.GA18874@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58275 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbaAPSiI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jan 2014 13:38:08 -0500
Content-Disposition: inline
In-Reply-To: <20140116181520.GA18874@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 16, 2014 at 07:15:20PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Jan 16, 2014 at 06:04:27PM +0000, Patrick McHardy wrote:
> > This the recursive parser.h inclusion that happens occasionally when
> > regenerating the parser files. Amazingly bison, despite its age, is
> > not using header sandwiches to protect against this *sigh*
> > 
> > Slightly ugly, but fixes the problem.
> 
> Ah, much nicer than the "nested too deep" warning message :)

Indeed. Pushed out to master.

> 
> > diff --git a/Makefile.rules.in b/Makefile.rules.in
> > index 25988dd..ae563a5 100644
> > --- a/Makefile.rules.in
> > +++ b/Makefile.rules.in
> > @@ -22,7 +22,14 @@ configure:		configure.ac
> >  
> >  %.c %.h:		%.y	$(makedeps)
> >  			@echo -e "  YACC\t\t$<"
> > -			$(YACC) $(YACCFLAGS) -d -o $@ $<
> > +			$(YACC) $(YACCFLAGS) --defines=$*.h.tmp -o $@ $<
> > +			( \
> > +				echo "#ifndef __$(*F)_H"; \
> > +				echo "#define __$(*F)_H"; \
> > +				cat $*.h.tmp; \
> > +				echo "#endif /* __$(*F)_H */" \
> > +			) > $*.h
> > +			$(RM) $*.h.tmp
> >  
> >  %.c %.h:		%.l	$(makedeps)
> >  			@echo -e "  LEX\t\t$<"
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
