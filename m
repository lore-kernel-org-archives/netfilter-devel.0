From: Patrick McHardy <kaber@trash.net>
Subject: Re: documentation bug: missing nat targets in man
Date: Wed, 10 Apr 2013 15:20:10 +0200
Message-ID: <20130410132010.GA23135@macbook.localnet>
References: <5163E3BE.3040609@chello.at>
 <20130409095448.GD26170@macbook.localnet>
 <5163FE28.3020604@chello.at>
 <20130410112623.GB21728@macbook.localnet>
 <516560E0.6000605@chello.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Mart Frauenlob <mart.frauenlob@chello.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53656 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab3DJNUQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Apr 2013 09:20:16 -0400
Content-Disposition: inline
In-Reply-To: <516560E0.6000605@chello.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 10, 2013 at 02:53:52PM +0200, Mart Frauenlob wrote:
> On 10.04.2013 13:26, Patrick McHardy wrote:
> >On Tue, Apr 09, 2013 at 01:40:24PM +0200, Mart Frauenlob wrote:
> >>On 09.04.2013 11:54, Patrick McHardy wrote:
> >>>On Tue, Apr 09, 2013 at 11:47:42AM +0200, Mart Frauenlob wrote:
> >>>>Hello,
> >>>>
> >>>>I noticed there's quite new DNAT, SNAT, NETMAP support for
> >>>>ip6tables, but that information is missing in the man page.
> >>>>Anything else needed than just copying the according ipv4 *.man files?
> >>>>If so, want me do prepare a patch?
> >>>
> >>>I guess you can rename the ipv4 specific man files to xt_... and
> >>>update them accordingly, the modules should behave similar to their
> >>>IPv4 counterparts.
> >>>
> >>
> >>Ok, here it is.
> >>I slightly modified the text in regards to sentence structure.
> >>Removed the references to older kernels, as this does not apply to
> >>the new ipv6 version.
> >>Added the list of valid protocols, which again - for me leaves the
> >>question about -p icmp open (re other mail).
> 
> [...]
> >>---
> >>  extensions/libip6t_DNAT.man   |   30 ++++++++++++++++++++++++++++++
> >>  extensions/libip6t_NETMAP.man |    9 +++++++++
> >>  extensions/libip6t_SNAT.man   |   28 ++++++++++++++++++++++++++++
> >>  3 files changed, 67 insertions(+), 0 deletions(-)
> >>  create mode 100644 extensions/libip6t_DNAT.man
> >>  create mode 100644 extensions/libip6t_NETMAP.man
> >>  create mode 100644 extensions/libip6t_SNAT.man
> >
> >Well, my suggestion was to add one manpage which covers both the IPv4
> >and IPv6 targets since they're pretty much identical. I think just
> >adding a libxt_DNAT.man etc. should work.
> 
> I've not yet tried to figure out where and what code is responsible
> for assembling all the *.man files together, but from what I see as
> the result and from what is there, like the LOG or MASQUERADE target
> are split up that way, actually producing redundant sections. Thats
> why I thought thats the way to go. Will try the libxt_*.man way...

Thanks,

> As there's redundant stuff, I can also prepare patches to join that
> together. Wanted?

I guess that would make sense if the IPv4 and IPv6 parts are (nearly)
identical.

> What about the -p icmp part?

Not sure, I'd leave it as it is for now.
