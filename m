From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC PATCH v2 6/6] src: add events reporting
Date: Wed, 26 Feb 2014 18:27:14 +0100
Message-ID: <20140226172714.GA23009@localhost>
References: <20140226160918.18974.64532.stgit@nfdev.cica.es>
 <20140226161015.18974.17832.stgit@nfdev.cica.es>
 <CAOkSjBjFNzeHWaN5gaAeifH2rAqBbUrTJBvzNiLqE7bP4H4R4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36792 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753198AbaBZR1W (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Feb 2014 12:27:22 -0500
Content-Disposition: inline
In-Reply-To: <CAOkSjBjFNzeHWaN5gaAeifH2rAqBbUrTJBvzNiLqE7bP4H4R4g@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 26, 2014 at 06:17:36PM +0100, Arturo Borrero Gonzalez wrote:
> On 26 February 2014 17:10, Arturo Borrero Gonzalez
> <arturo.borrero.glez@gmail.com> wrote:
> >
> > +
> > +       /* XXXX */
> > +       sleep(1);
> > +
> > +       /* only way, by now, to know set_elems (no set_elem events) */
> > +       if (netlink_get_setelems(&set_tmpctx, &s->handle, monh->loc, s) < 0)
> > +               goto out;
> > +
> 
> About this:
> 
> it seems that I can't query the kernel just after the set is created,
> because I get an empty set.

I see. Since sets are first created then elements are added, I think
you have to make a kernel patch to add set element events.
