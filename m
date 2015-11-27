From: Patrick McHardy <kaber@trash.net>
Subject: Re: kernel crash in netlink_sock_destruct()
Date: Fri, 27 Nov 2015 17:06:27 +0000
Message-ID: <20151127170627.GA3639@macbook.localdomain>
References: <CAOkSjBgsSapxsCeFA6W-BfSZ3SUjr9mxQ3z6F-ABsrY8yb7veg@mail.gmail.com>
 <CAOkSjBh+UPThVvfsKeT5nhFitJyQGNdbtA1eVVPE_ux3PvsV0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>, pablo@netfilter.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48634 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894AbbK0RGb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Nov 2015 12:06:31 -0500
Content-Disposition: inline
In-Reply-To: <CAOkSjBh+UPThVvfsKeT5nhFitJyQGNdbtA1eVVPE_ux3PvsV0Q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 24.11, Arturo Borrero Gonzalez wrote:
> On 17 November 2015 at 13:49, Arturo Borrero Gonzalez
> <arturo.borrero.glez@gmail.com> wrote:
> > Hi,
> >
> > I've found this in a machine I'm using to play with nftables.
> >
> > The kernel is 4.2, so not sure if already fixed.
> >
> 
> More info. I can reproduce the issue:
> 
>  % sudo ip netns add test
>  % sudo ip netns exec test nft -f test.nft
>  % sudo ip netns del test
> 
> Find attached the test.nft file.

@Arturo: was there any delay between those commands or did you execute all
of them directly after each other?

Somewhat related question: i'm wondering, what, if anything, is removing all
the nftables objects if a namespace exits? It seems we're leaking them all.
