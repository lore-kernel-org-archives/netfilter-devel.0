From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: install nf_nat.h and related headers to
 INSTALL_HDR_PATH
Date: Tue, 6 Sep 2011 20:05:05 +0200
Message-ID: <20110906180505.GA5387@1984>
References: <1315075784-10163-1-git-send-email-basile@opensource.dyc.edu>
 <20110905174847.GB32733@1984>
 <4E664E05.4090907@opensource.dyc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, kaber@trash.net, blueness@gentoo.org,
	gurligebis@gentoo.org, base-system@gentoo.org, kernel@gentoo.org,
	toolchain@gentoo.org, mchehab@redhat.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, arnd@arndb.de,
	eparis@redhat.com, netfilter-devel@vger.kernel.org
To: "Anthony G. Basile" <basile@opensource.dyc.edu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47505 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543Ab1IFSFK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Sep 2011 14:05:10 -0400
Content-Disposition: inline
In-Reply-To: <4E664E05.4090907@opensource.dyc.edu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 06, 2011 at 12:44:53PM -0400, Anthony G. Basile wrote:
> On 09/05/2011 01:48 PM, Pablo Neira Ayuso wrote:
> > Those headers contain structure layouts that may change along time
> > without further notice, thus breaking backward compatibility.
> > 
> 
> It makes use of
> 
>    union nf_conntrack_man_proto
>    struct nf_nat_range
>    struct nf_nat_multi_range_compat

I see, they are also used by the NAT target in iptables. So these
structure definitions should be exported.

> which are not available in any /usr/include/linux/netfilter header.  It
> needs these for its portfowarding when doing upnp.  The solution in
> Gentoo and other distros is to introduce a local tiny_nf_nat.h in the
> miniupnpd source tree which defines these union/structs, like what
> iptables does. 

This is indeed a good idea. Other net-tools keep a copy of the linux
kernel headers that they need to compile.

> Unlike iptables though, the miniupnpd developer expects
> miniupnpd to -I/usr/src/linux/include which is worse.  Since two
> userland apps need this, and to discourage less than ideal workarounds,
> it makes sense to make it available in include/linux/.

In that case, I'd prefer to add a new file that contains only those
structures to linux/, instead of the whole file with the internal NAT
definitions.

> Also, in answer to Jan, yes it would be best if these go into linux/
> rather than net/.
>
> Perhaps the approach here should be to introduce
> linux/include/linux/netfilter/nf_nat.h which contains these structs and
> is a sanitized version of net/netfilter/nf_nat.h, so that it doesn't
> contain struct layouts that will break backwards compat.  This also
> address Jan's concern and a simple header-y += would install nf_nat.h in
> the right place.

This is exactly what I like, please do it this way.

> > and BTW, no need to cross-post this message to such a huge list of CC.
> > I guess you could simply use netfilter-devel for this.
> 
> I followed what get_maintainer.pl gave me.  I've removed all the
> @vger.kernel.org lists except netfilter-devel@  Please re-add any you
> think they should be there.

Hm, interesting, that's quite spamming.
