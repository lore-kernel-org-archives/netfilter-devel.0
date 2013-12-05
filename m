From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Merging iptables-nftables into iptables
Date: Thu, 5 Dec 2013 22:54:47 +0100
Message-ID: <20131205215447.GA4367@localhost>
References: <20131204114834.GA13280@localhost>
 <CAOkSjBj5z7x+15Dmw-EWtqiBWfv4h+DBO0s7KNeZgkgrZP4g+w@mail.gmail.com>
 <20131205082409.GB4557@localhost>
 <52A0ED02.40603@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53365 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867Ab3LEVzA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Dec 2013 16:55:00 -0500
Content-Disposition: inline
In-Reply-To: <52A0ED02.40603@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Bart,

On Thu, Dec 05, 2013 at 10:15:46PM +0100, Bart De Schuymer wrote:
> Pablo Neira Ayuso schreef op 5/12/2013 9:24:
> >On Wed, Dec 04, 2013 at 04:11:18PM +0100, Arturo Borrero Gonzalez wrote:
> >>On 4 December 2013 12:48, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >>>Hi,
> >>>
> >>>The iptables-nftables tree [1] currently stores the iptables over
> >>>nftables compatibility support. This allows you to run iptables
> >>>commands using the nftables kernel infrastructure.
> >>>
> >>>JFYI, my plan is to merge the iptables-nftables into iptables at some
> >>>point of this week given that it contains stuff that is scheduled for
> >>>3.13.  After that merge, the iptables-nftables will be disabled.
> >>>
> >>>[1] http://git.netfilter.org/iptables-nftables/
> >>Could you give some hints about releases of userspace stuff?
> >>(libnftables, nft, new iptables...)
> >>
> >>Is 3.13 a deadline for releases?
> >The initial release of the userspace libraries and tools will happen
> >by when the Linux kernel 3.13 is released, that should happen by the
> >beginning of 2014.
> >
> >The nftables compatibility layer (the so-called iptables-nftables)
> >will be included in regular iptables releases, since it will be part
> >of that package.
> 
> Nice to see this progress. What are the plans/obstacles (if any?)
> for migrating ebtables/arptables to nftables?

We already have a working compatibility layer for iptables, ip6tables
and arptables.

Regarding arptables, there's still one limitation that we have to
resolve as it only allows EUI-64 addresses (which should be the most
common case), the arptables kernel code seems to support variable
length hardware addresses up to 128 bytes long IIRC. Tomasz has been
working on that for a while.

Regarding ebtables, Giuseppe Longo have several patches to bootstrap
the ebtables compatibility, so it's work in progress.

In any case, we will still need the native {arp,eb,ip,ip6}tables tools
for a while, those will co-exist with the compatibility tools. At some
point in the future, distributors may decide to switch to the
compatibility tools transparently, the idea is that users won't notice
any change from the syntax point of view and they won't be forced to
drop their scripts.
