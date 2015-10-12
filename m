From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 0/7] listing command updates
Date: Mon, 12 Oct 2015 20:33:12 +0200
Message-ID: <20151012183312.GA9016@salvia>
References: <1444337370-8269-1-git-send-email-pablo@netfilter.org>
 <CAOkSjBi-3aQyS3oBSLBbYNbC-Cqtgd=dy9EBvdZsX=2uFCdoUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>,
	Florian Westphal <fw@strlen.de>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45130 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbbJLS0O (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Oct 2015 14:26:14 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBi-3aQyS3oBSLBbYNbC-Cqtgd=dy9EBvdZsX=2uFCdoUw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 09, 2015 at 09:09:10AM +0200, Arturo Borrero Gonzalez wrote:
> On 8 October 2015 at 22:49, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Hi,
> >
> > This patchset is following up after:
> >
> > http://www.spinics.net/lists/netfilter-devel/msg38491.html
> >
> > In a nutshell, what I'm proposing is that:
> >
> > * `list {tables,chains,sets}' only display the object declaration, not its
> >   definition (ie. content). Moreover, if no family is specified, then they
> >   show all families to get this aligned with `list ruleset'.
> >
> > * If you want to obtain the objects definition, then you use the
> >   `list {table,chain,set}' variant.
> >
> > * We always provide an output that doesn't break `nft -f'.
> >
> > Let me know if you have any comment,
> 
> I agree with the changes :-)
> 
> Acked-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>

Just pushed out this. Please, help testing, thanks.
