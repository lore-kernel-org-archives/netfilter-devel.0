From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH] return value of conntrack protocol helper functions
	and a macro for stats
Date: Sat, 21 Aug 2004 23:27:38 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1093123658.21593.7.camel@localhost.localdomain>
References: <4112377A.8050106@eurodev.net>
	 <1093040122.20712.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-YA0uUvJ+gLy0akY+an7M"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Harald Welte <laforge@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <1093040122.20712.18.camel@localhost.localdomain>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-YA0uUvJ+gLy0akY+an7M
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2004-08-21 at 00:15, Martin Josefsson wrote:

> > @@ -303,12 +307,13 @@
> >  	unsigned int insert_failed;
> >  	unsigned int drop;
> >  	unsigned int early_drop;
> > -	unsigned int icmp_error;
> > +	unsigned int error;
> >  	unsigned int expect_new;
> >  	unsigned int expect_create;
> >  	unsigned int expect_delete;
> >  };

There's a piece missing:
(hand-made, ymmv)

--- linux.old/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-08-21 23:17=
:00.548009856 -0400
+++ linux/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-08-21 23:17:00.=
545555344 -0400
@@ -334,6 +334,6 @@
 		   st->insert_failed,
 		   st->drop,
 		   st->early_drop,
-		   st->icmp_error,
+		   st->error,
=20
 		   st->expect_new,
 		   st->expect_create,

--=20
/Martin

--=-YA0uUvJ+gLy0akY+an7M
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQBBJ75JWm2vlfa207ERAlfkAJ9kmDrwsqz4FKRAEJ4v9A9qbfRh/wCgv2zG
kGhGUuxy8TrNmguYYCOOAlI=
=jNEV
-----END PGP SIGNATURE-----

--=-YA0uUvJ+gLy0akY+an7M--
