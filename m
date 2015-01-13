From: Patrick McHardy <kaber@trash.net>
Subject: Re: BUG: Kernel panic at masquerade
Date: Tue, 13 Jan 2015 19:41:12 +0000
Message-ID: <20150113194111.GB23967@acer.localdomain>
References: <54B048D1.6040009@mail.ru>
 <CAOkSjBieyfUV6HMENQcETwcoADT2YMxhgBfv9Kx9kiM8YYAhKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linke <linkerpro@mail.ru>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>, pablo@netfilter.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49692 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbbAMTlQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Jan 2015 14:41:16 -0500
Content-Disposition: inline
In-Reply-To: <CAOkSjBieyfUV6HMENQcETwcoADT2YMxhgBfv9Kx9kiM8YYAhKA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 09.01, Arturo Borrero Gonzalez wrote:
> On 9 January 2015 at 22:32, Linke <linkerpro@mail.ru> wrote:
> > Hello,
> >
> > I'm stable receive a kernel panic in this ruleset:
> >
> > nft add table firewall
> > nft add chain firewall prerouting {type nat hook prerouting priority 0\;}
> > nft add rule firewall prerouting masquerade
> >
> >
> > trying at Archlinux
> >
> > official latest 3.18-grsec kernel
> > and AUR 3.19.0-rc3-gbdec419 (builded from git.kernel.org)
> >
> 
> Why are you using masquerade in a prerouting hook? It only makes sense
> in postrouting. Is a case I've not tested.
> 
> Anyway, that should not happen. I will investigate.

Well, we only check for the NAT property, not the hooks. We need to
make sure its only used in the appropriate hook.

Related to this, what also kind of sucks is that you have to manually
take care of creating the opposite NAT chain (pre/postrouting, in/output)
to have NAT work properly. We should make sure that the user can't
mess this up. Simlarly we need to prevent to have multiple NAT
chains for the same hook.

Generally I think the current NAT chain implementation is very
wrong. We need to invoke the core functions once for each direction
if NAT is used independantly of any chains. So they probably
shouldn't be tied together.
