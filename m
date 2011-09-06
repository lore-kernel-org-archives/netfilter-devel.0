From: "Anthony G. Basile" <basile@opensource.dyc.edu>
Subject: Re: [PATCH] netfilter: install nf_nat.h and related headers to INSTALL_HDR_PATH
Date: Tue, 06 Sep 2011 12:44:53 -0400
Message-ID: <4E664E05.4090907@opensource.dyc.edu>
References: <1315075784-10163-1-git-send-email-basile@opensource.dyc.edu> <20110905174847.GB32733@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, kaber@trash.net, blueness@gentoo.org,
	gurligebis@gentoo.org, base-system@gentoo.org, kernel@gentoo.org,
	toolchain@gentoo.org, mchehab@redhat.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, arnd@arndb.de,
	eparis@redhat.com, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from virtual.dyc.edu ([67.222.116.22]:45430 "EHLO virtual.dyc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337Ab1IFQzH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Sep 2011 12:55:07 -0400
In-Reply-To: <20110905174847.GB32733@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 09/05/2011 01:48 PM, Pablo Neira Ayuso wrote:
> On Sat, Sep 03, 2011 at 02:49:44PM -0400, Anthony G. Basile wrote:
>> Currently nf_nat.h, nf_conntrack_tuple.h and related headers under
>> include/net/netfilter are not installed as part of the public kernel
>> headers.   However, there are userland applications, other than iptables
>> which ships with its own headers, which need these to make use of NAT in
>> the kernel's netfilter API.  For example, miniupnpd, requires them and is
>> forced to search /usr/src/linux when building.
> 
> Could anyone clarify why miniupnpd (or any other application) require
> this?
> 
> Those headers contain structure layouts that may change along time
> without further notice, thus breaking backward compatibility.
> 

It makes use of

   union nf_conntrack_man_proto
   struct nf_nat_range
   struct nf_nat_multi_range_compat

which are not available in any /usr/include/linux/netfilter header.  It
needs these for its portfowarding when doing upnp.  The solution in
Gentoo and other distros is to introduce a local tiny_nf_nat.h in the
miniupnpd source tree which defines these union/structs, like what
iptables does.  Unlike iptables though, the miniupnpd developer expects
miniupnpd to -I/usr/src/linux/include which is worse.  Since two
userland apps need this, and to discourage less than ideal workarounds,
it makes sense to make it available in include/linux/.

Also, in answer to Jan, yes it would be best if these go into linux/
rather than net/.

Perhaps the approach here should be to introduce
linux/include/linux/netfilter/nf_nat.h which contains these structs and
is a sanitized version of net/netfilter/nf_nat.h, so that it doesn't
contain struct layouts that will break backwards compat.  This also
address Jan's concern and a simple header-y += would install nf_nat.h in
the right place.

> and BTW, no need to cross-post this message to such a huge list of CC.
> I guess you could simply use netfilter-devel for this.

I followed what get_maintainer.pl gave me.  I've removed all the
@vger.kernel.org lists except netfilter-devel@  Please re-add any you
think they should be there.

-- 
Anthony G. Basile, Ph. D.
Chair of Information Technology
D'Youville College
Buffalo, NY 14201
(716) 829-8197
