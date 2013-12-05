From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Merging iptables-nftables into iptables
Date: Thu, 5 Dec 2013 09:24:09 +0100
Message-ID: <20131205082409.GB4557@localhost>
References: <20131204114834.GA13280@localhost>
 <CAOkSjBj5z7x+15Dmw-EWtqiBWfv4h+DBO0s7KNeZgkgrZP4g+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34473 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234Ab3LEIYT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Dec 2013 03:24:19 -0500
Content-Disposition: inline
In-Reply-To: <CAOkSjBj5z7x+15Dmw-EWtqiBWfv4h+DBO0s7KNeZgkgrZP4g+w@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 04, 2013 at 04:11:18PM +0100, Arturo Borrero Gonzalez wrote:
> On 4 December 2013 12:48, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Hi,
> >
> > The iptables-nftables tree [1] currently stores the iptables over
> > nftables compatibility support. This allows you to run iptables
> > commands using the nftables kernel infrastructure.
> >
> > JFYI, my plan is to merge the iptables-nftables into iptables at some
> > point of this week given that it contains stuff that is scheduled for
> > 3.13.  After that merge, the iptables-nftables will be disabled.
> >
> > [1] http://git.netfilter.org/iptables-nftables/
> 
> Could you give some hints about releases of userspace stuff?
> (libnftables, nft, new iptables...)
> 
> Is 3.13 a deadline for releases?

The initial release of the userspace libraries and tools will happen
by when the Linux kernel 3.13 is released, that should happen by the
beginning of 2014.

The nftables compatibility layer (the so-called iptables-nftables)
will be included in regular iptables releases, since it will be part
of that package.
