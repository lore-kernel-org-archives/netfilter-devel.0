From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 2/2] examples: nft-set-parse-add: give batching
 support
Date: Tue, 30 Sep 2014 11:03:12 +0200
Message-ID: <20140930090312.GB7059@salvia>
References: <20140926183442.3333.62136.stgit@nfdev.cica.es>
 <20140926183448.3333.64808.stgit@nfdev.cica.es>
 <20140929150323.GA4591@salvia>
 <CAOkSjBhujE4fx-1YnH1ZqdP1aUsZxaPQR+rrXoLC6wBBbONjYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Alvaro Neira Ayuso <alvaroneay@gmail.com>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52273 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904AbaI3JCG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Sep 2014 05:02:06 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBhujE4fx-1YnH1ZqdP1aUsZxaPQR+rrXoLC6wBBbONjYg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 29, 2014 at 05:35:44PM +0200, Arturo Borrero Gonzalez wrote=
:
> El 29/09/2014 17:02, "Pablo Neira Ayuso" <pablo@netfilter.org> escrib=
i=F3:
> >
> > On Fri, Sep 26, 2014 at 08:34:48PM +0200, Arturo Borrero Gonzalez w=
rote:
> > > @@ -66,6 +67,8 @@ static struct nft_set *set_parse_file(const cha=
r
> *file, uint16_t format)
> > >       }
> > >
> > >       nft_parse_err_free(err);
> > > +
> > > +     nft_set_attr_set_u32(s, NFT_SET_ATTR_ID, 1);
> > >       return s;
> > >
> > >  }
> >
> > I guess this works if you parse one single set definition in a file=
=2E
> > With more than one set, this will break.
> >
> > IIRC, Alvaro started a patch time ago to add a new interface to
> > libnftnl to handle the set internal id which was incomplete.
> >
> > Cc'ing him to know its status.
>=20
> Yes, there is a issue here. But this code example just parse one set.

Right. Then applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
