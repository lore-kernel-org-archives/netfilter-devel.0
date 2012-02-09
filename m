From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: BUG nf_conntrack_ffff880863c50000: Objects remaining on
 kmem_cache_close()
Date: Thu, 9 Feb 2012 20:39:17 +0100
Message-ID: <20120209193917.GB6881@1984>
References: <4F328A81.4050607@univ-nantes.fr>
 <20120209155753.GB5951@1984>
 <4F33F03C.5030805@univ-nantes.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jean-Philippe Menil <jean-philippe.menil@univ-nantes.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58598 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757903Ab2BITjT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Feb 2012 14:39:19 -0500
Content-Disposition: inline
In-Reply-To: <4F33F03C.5030805@univ-nantes.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 09, 2012 at 05:11:40PM +0100, Jean-Philippe Menil wrote:
> Le 09/02/2012 16:57, Pablo Neira Ayuso a =E9crit :
> >On Wed, Feb 08, 2012 at 03:45:21PM +0100, Jean-Philippe Menil wrote:
> >>Hi,
> >>
> >>I'm seeing bug in a host with a 3.2.1 kernel.
> >>This host is running both kvm and lxc guest.
> >>It seems that it happened just after the restart of a lxc guest.
> >>
> >>However, it doesn't seem to affect any guest.
> >>
> >>I was just wondering if this was problematic, and if so, what shoul=
d
> >>I do to debug this further.
> >Could you provide more information on your setup? Is it using
> >conntrackd or anything you think it can be relevant to this bug.
> >
> >It can make it easier for us to know what's wrong with this.
> >
> Hi,
>=20
> the server hosts two kvm guest (one firewall running contrackd, one
> captive portal) and a lxc guest (running squid).
> This setup remain unchanged for month, except the kernel (reboot
> with a 3.2.1 one week ago).

Is conntrackd running with NetlinkEventsReliable On?
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
