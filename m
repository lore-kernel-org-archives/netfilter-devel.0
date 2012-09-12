From: Pablo Neira Ayuso <pablo@gnumonks.org>
Subject: Re: help with conntrack
Date: Thu, 13 Sep 2012 00:07:36 +0200
Message-ID: <20120912220736.GA17526@1984>
References: <CAOSBYzdLo=A9VApP-BsbQ_Hi8c_NOkS00GUEAjU8X85o+vEy_A@mail.gmail.com>
 <1347478050.2349.202.camel@andrew-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Miguel Alejandro =?iso-8859-1?Q?Gonz=E1lez?= <maggonzz@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Andrew Beverley <andy@andybev.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47035 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754775Ab2ILWHk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Sep 2012 18:07:40 -0400
Content-Disposition: inline
In-Reply-To: <1347478050.2349.202.camel@andrew-desktop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Sep 12, 2012 at 08:27:30PM +0100, Andrew Beverley wrote:
> On Tue, 2012-09-11 at 23:08 -0500, Miguel Alejandro Gonz=E1lez wrote:
> > Hello
> >=20
> > I'm making a netfilter module and I need to have interaction with
> > conntrack, as I understand conntrack is a hash table of all connect=
ions
> > IPv4 and IPv6. I basically need to know how to do lookups, insertio=
ns an
> > deletions, can you tell me how do this? If you can give me some
> > documentation or code to see how conntrack works and how to achieve=
 what I
> > need to do, that would be great
>
> The "Writing Netfilter Modules" should help you (see part II):
> http://inai.de/documents/Netfilter_Modules.pdf
>=20
> Of course, there's also libnetfilter_conntrack which includes some go=
od
> examples, although it's a userspace library.

This should also help to get an overall idea on how is implemented:

http://1984.lsi.us.es/~pablo/docs/login06.pdf

But you'll have to get ready to read Linux kernel code.

Start with net/netfilter/nf_conntrack_core.c

Good luck!
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
