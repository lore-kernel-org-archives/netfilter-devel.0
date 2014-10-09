From: Steven Barth <cyrus@openwrt.org>
Subject: Re: [nft PATCH] build: allow disabling libreadline-support
Date: Thu, 09 Oct 2014 17:02:41 +0200
Message-ID: <1412866961.4287.1.camel@openwrt.org>
References: <1412200742-5898-1-git-send-email-cyrus@openwrt.org>
	 <20141009122648.GA17919@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from chi.subsignal.org ([188.40.166.11]:48723 "EHLO
	chi.subsignal.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757457AbaJIPCx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Oct 2014 11:02:53 -0400
In-Reply-To: <20141009122648.GA17919@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo, 


> >  
> > -AC_CHECK_LIB([readline], [readline], ,
> > -	     AC_MSG_ERROR([No suitable version of libreadline found]))
> > +
> > +AC_ARG_WITH([libreadline], [AS_HELP_STRING([--without-libreadline],
> > +            [Disable libreadline support (no interactive CLI)])], [],
> > +            [with_libreadline=yes])
> 
> I think, better call this option "without-cli" ?
OK, guess that's fine as well.

> 
> Please, add the:
> 
> #ifdef HAVE_LIBREADLINE
> 
> in cli_init() and cli_exit() in cli.c. It would be good if the cli_init()
> returns a negative value, so you spot the error message below.

The problem I see here that this would basically mean enclosing most of
cli.c in #ifdef HAVE_LIBREADLINE to avoid depending on readline-headers
and having a rather awkward stub of cli_init in the no-readline case.

My main point of excluding cli.c in the Makefile from the start is to
avoid this madness.



Cheers,

Steven

