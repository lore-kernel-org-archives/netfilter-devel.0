From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft] ct: use nftables sysconf location for connlabel
 configuration
Date: Thu, 21 Jul 2016 00:27:03 +0200
Message-ID: <20160720222703.GC9123@breakpoint.cc>
References: <1469009825-1188-1-git-send-email-fw@strlen.de>
 <20160720161917.GA1413@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:56504 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755784AbcGTW1K (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Jul 2016 18:27:10 -0400
Content-Disposition: inline
In-Reply-To: <20160720161917.GA1413@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Jul 20, 2016 at 12:17:05PM +0200, Florian Westphal wrote:
> > Instead of using /etc/xtables use the nftables syconfdir.
> > Also update error message to tell which label failed translation
> > and which config file was used for this:
> > 
> > nft add filter input ct label foo
> > <cmdline>:1:27-29: Error: /etc/nftables/connlabel.conf: could not parse conntrack label "foo"
> > 
> > Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > ---
> >  src/Makefile.am | 2 ++
> >  src/ct.c        | 7 +++++--
> >  2 files changed, 7 insertions(+), 2 deletions(-)
> > 
> > diff --git a/src/Makefile.am b/src/Makefile.am
> > index 8c59449..ff1dd6e 100644
> > --- a/src/Makefile.am
> > +++ b/src/Makefile.am
> > @@ -27,6 +27,8 @@ parser_bison.o scanner.o: AM_CFLAGS += -Wno-missing-prototypes -Wno-missing-decl
> >  
> >  BUILT_SOURCES = parser_bison.h
> >  
> > +ct.o: AM_CFLAGS += -DCONNLABEL_PATH="\"${sysconfdir}/\""
> 
> I think we can simplify this by using DEFAULT_INCLUDE_PATH.
> 
> See patch attached, it applies on top of this one. Feel free to
> collapse them.

Okay, I pushed it to nftables.git (with your patch collapsed).

