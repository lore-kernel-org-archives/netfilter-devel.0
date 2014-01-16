From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nftables] fix parser.h recursive inclusion
Date: Thu, 16 Jan 2014 19:15:20 +0100
Message-ID: <20140116181520.GA18874@localhost>
References: <20140116180426.GA12421@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34030 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbaAPSP3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jan 2014 13:15:29 -0500
Content-Disposition: inline
In-Reply-To: <20140116180426.GA12421@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 16, 2014 at 06:04:27PM +0000, Patrick McHardy wrote:
> This the recursive parser.h inclusion that happens occasionally when
> regenerating the parser files. Amazingly bison, despite its age, is
> not using header sandwiches to protect against this *sigh*
> 
> Slightly ugly, but fixes the problem.

Ah, much nicer than the "nested too deep" warning message :)

> diff --git a/Makefile.rules.in b/Makefile.rules.in
> index 25988dd..ae563a5 100644
> --- a/Makefile.rules.in
> +++ b/Makefile.rules.in
> @@ -22,7 +22,14 @@ configure:		configure.ac
>  
>  %.c %.h:		%.y	$(makedeps)
>  			@echo -e "  YACC\t\t$<"
> -			$(YACC) $(YACCFLAGS) -d -o $@ $<
> +			$(YACC) $(YACCFLAGS) --defines=$*.h.tmp -o $@ $<
> +			( \
> +				echo "#ifndef __$(*F)_H"; \
> +				echo "#define __$(*F)_H"; \
> +				cat $*.h.tmp; \
> +				echo "#endif /* __$(*F)_H */" \
> +			) > $*.h
> +			$(RM) $*.h.tmp
>  
>  %.c %.h:		%.l	$(makedeps)
>  			@echo -e "  LEX\t\t$<"
