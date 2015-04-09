From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables PATCH] list: fix prefetch dummy
Date: Thu, 9 Apr 2015 12:45:03 +0200
Message-ID: <20150409104503.GB3568@salvia>
References: <20150406180541.7031.97131.stgit@nfdev2.cica.es>
 <20150408171825.40368215@urahara>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	netfilter-devel@vger.kernel.org, kaber@trash.net
To: Stephen Hemminger <stephen@networkplumber.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43740 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755307AbbDIKkw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Apr 2015 06:40:52 -0400
Content-Disposition: inline
In-Reply-To: <20150408171825.40368215@urahara>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 08, 2015 at 05:18:25PM -0700, Stephen Hemminger wrote:
> On Mon, 06 Apr 2015 20:05:41 +0200
> Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com> wrote:
> 
> > linux_list.h:381:59: warning: right-hand operand of comma expression has no effect [-Wunused-value]
> >   for (pos = list_entry((head)->next, typeof(*pos), member), \
> >                                                            ^
> > libiptc.c:552:2: note: in expansion of macro 'list_for_each_entry'
> >   list_for_each_entry(c, &h->chains, list) {
> >   ^
> > 
> > [ Patch copied from one similar of Patrick McHardy on libnftnl ]
> > 
> > Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> > ---
> >  libiptc/linux_list.h |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/libiptc/linux_list.h b/libiptc/linux_list.h
> > index abdcf88..559e33c 100644
> > --- a/libiptc/linux_list.h
> > +++ b/libiptc/linux_list.h
> > @@ -27,7 +27,7 @@
> >  	1; \
> >  })
> >  
> > -#define prefetch(x)		1
> > +#define prefetch(x)		((void)0)
> >  
> >  /* empty define to make this work in userspace -HW */
> >  #define smp_wmb()
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> The kernel dropped the prefetch() in the list macros a couple
> of years ago. The prefetch() had no performance gain and hurt
> in several cases.

We have an old copy of linux's list.h in our userspace trees. We can
probably refresh those to get them in sync with current at some point.
