From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH v2] examples: add nft-ruleset-get
Date: Mon, 6 Jan 2014 13:06:19 +0100
Message-ID: <20140106120619.GA4122@localhost>
References: <20131223141507.6481.39666.stgit@nfdev.cica.es>
 <20140104005303.GA5037@localhost>
 <CAOkSjBjneHWTth=u+4mf9xXPyQ4+GCVq+WcyZiBwYean8N6GhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51776 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753844AbaAFMGY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jan 2014 07:06:24 -0500
Content-Disposition: inline
In-Reply-To: <CAOkSjBjneHWTth=u+4mf9xXPyQ4+GCVq+WcyZiBwYean8N6GhQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 06, 2014 at 12:53:24PM +0100, Arturo Borrero Gonzalez wrote=
:
> On 4 January 2014 01:53, Pablo Neira Ayuso <pablo@netfilter.org> wrot=
e:
> > On Mon, Dec 23, 2013 at 03:18:22PM +0100, Arturo Borrero Gonzalez w=
rote:
> >> This example prints the ruleset, using the ruleset API of nftables=
=2E
> >>
> >> The kernel patch [b63108a] (netfilter: nf_tables: allow to dump se=
ts with
> >> NFPROTO_UNSPEC) is required.
> >
> > Updated this to point to c9c8e48 ("netfilter: nf_tables: dump sets =
in
> > all existing families").
> >
> > Applied to -next, thanks Arturo.
>=20
> I don't see the kernel patch applied [0].
>=20
> Have you applied it, or have plans to do so? If applied, please, coul=
d
> you point me to the right tree?

It's there, the one at the HEAD:

http://git.kernel.org/cgit/linux/kernel/git/pablo/nftables.git/commit/?=
id=3Dc9c8e485978a308c8a359140da187d55120f8fee

> [0] http://git.kernel.org/cgit/linux/kernel/git/pablo/nftables.git/lo=
g/
> --=20
> Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
