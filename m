From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] conntrack: made the protocol option value case
 insensitive
Date: Thu, 2 Jul 2015 18:59:21 +0200
Message-ID: <20150702165921.GA12994@salvia>
References: <1435227145-15554-1-git-send-email-pfeiffer.szilard@balabit.hu>
 <20150626071921.GA30656@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: pfeiffer.szilard@balabit.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36812 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753714AbbGBQxy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jul 2015 12:53:54 -0400
Content-Disposition: inline
In-Reply-To: <20150626071921.GA30656@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 26, 2015 at 09:19:21AM +0200, Florian Westphal wrote:
> pfeiffer.szilard@balabit.hu <pfeiffer.szilard@balabit.hu> wrote:
> > From: Szil=E1rd Pfeiffer <pfeiffer.szilard@balabit.hu>
> >=20
> > Extensions register protocols by lowercase protocol name, but value=
 of
> > proto command line option may be uppercase. Extension related optio=
ns
> > cannot be used when protocol name comparision fails.
> >=20
> > Signed-off-by: Szil=E1rd Pfeiffer <pfeiffer.szilard@balabit.hu>
> > ---
> >  src/conntrack.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >=20
> > diff --git a/src/conntrack.c b/src/conntrack.c
> > index f7d37fb..b1a2589 100644
> > --- a/src/conntrack.c
> > +++ b/src/conntrack.c
> > @@ -555,6 +555,12 @@ static struct ctproto_handler *findproto(char =
*name, int *pnum)
> >  	/* using the protocol name for an unsupported protocol? */
> >  	if ((pent =3D getprotobyname(name))) {
> >  		*pnum =3D pent->p_proto;
>=20
> Why not use strcasecmp to check the proto_list?

Please, address Florian's feedback and resubmit, thanks.

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
