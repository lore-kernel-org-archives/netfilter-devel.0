From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nf_tables RFH PATCH] netfilter: nf_tables: add set_elem
 notifications
Date: Fri, 28 Mar 2014 12:02:38 +0000
Message-ID: <20140328120238.GB7423@macbook.localnet>
References: <20140328114622.8896.14752.stgit@nfdev.cica.es>
 <20140328114938.GA13207@localhost>
 <CAOkSjBhhaAOCyZpXBG2N3v7TStEz-ye00mhKdx0+RpHXN96rqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54968 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaC1MCm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Mar 2014 08:02:42 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBhhaAOCyZpXBG2N3v7TStEz-ye00mhKdx0+RpHXN96rqg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 28, 2014 at 01:00:36PM +0100, Arturo Borrero Gonzalez wrote:
> On 28 March 2014 12:49, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Fri, Mar 28, 2014 at 12:46:22PM +0100, Arturo Borrero Gonzalez wrote:
> >> This patch adds set_elems notifications.
> >>
> >> When a set_elem is added/deleted, all listening peers in userspace will
> >> receive the corresponding notification.
> >
> > I was just looking into this now. Is this patch still crashing?
> 
> Yes, still crashing :-(

And this is only happening using anonymous sets?

> Should this be delayed until the set batching is applied?

I think it would be nice to get this in ASAP. Lets fix the crash and
hope it doesn't clash much, but I don't think so.
