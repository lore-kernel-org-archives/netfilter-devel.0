From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 1/2] src: not create iterator with empty list
Date: Sat, 10 Jan 2015 19:51:07 +0100
Message-ID: <20150110185107.GA7210@salvia>
References: <1420807661-29751-1-git-send-email-alvaroneay@gmail.com>
 <20150110182022.GA5185@salvia>
 <54B16EDE.7060207@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?iso-8859-1?Q?=C1lvaro?= Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46862 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548AbbAJSsR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 10 Jan 2015 13:48:17 -0500
Content-Disposition: inline
In-Reply-To: <54B16EDE.7060207@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jan 10, 2015 at 07:26:38PM +0100, =C1lvaro Neira Ayuso wrote:
> El 10/01/15 a las 19:20, Pablo Neira Ayuso escribi=F3:
> >On Fri, Jan 09, 2015 at 01:47:40PM +0100, Alvaro Neira Ayuso wrote:
> >>Now, we create iterator without test if the list is empty. If the l=
ist
> >>is empty, we have a crash when we set up the current element.
> >>With this patch, we test if the list is empty before to create the =
iterator. If
> >>the list is empty the iterator return NULL.
> >
> >Please, handle this from the _next() function.
> >
> >The idea is to set iter->cur to NULL if the list is empty from
> >iter_create, ie.
> >
> >         if (iter->r->expr_list.next =3D=3D &iter->r.expr_list)
> >                 iter->cur =3D NULL;
> >         else
> >                 iter->cur =3D list_entry(...);
> >
> >Then, from _next() you check for:
> >
> >         if (expr =3D=3D NULL)
> >                 return NULL;
>=20
> Ok, nice idea.
>=20
> >
> >>Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
> >>---
> >>  src/chain.c    |    3 +++
> >>  src/rule.c     |    6 ++++++
> >>  src/set.c      |    3 +++
> >>  src/set_elem.c |    3 +++
> >>  src/table.c    |    3 +++
> >
> >I can count up to six iterator interfaces, I only see 5 here, please
> >make sure you adapt all spots. Thanks.
> >
>=20
> mmm yes and I have changed the code in the six iterator interfaces.
> I have changed:

Oh your right, sorry for the noise.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
