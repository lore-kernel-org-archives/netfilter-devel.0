From: Eric Leblond <eric@regit.org>
Subject: Re: iptables and external processes
Date: Thu, 19 Feb 2004 14:26:31 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1077197191.3684.13.camel@tech004.alphalink.fr>
References: <Pine.LNX.4.44.0402172303080.3844-100000@filer.marasystems.com>
	 <20040217161130.K27680@tempest.prismnet.com>
	 <1077060658.2011.19.camel@ca.gts.nexusmgmt.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/C/QSrEwdueAsiWDZqle"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "John A. Sullivan III" <john.sullivan@nexusmgmt.com>
In-Reply-To: <1077060658.2011.19.camel@ca.gts.nexusmgmt.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-/C/QSrEwdueAsiWDZqle
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Le mer 18/02/2004 =E0 00:30, John A. Sullivan III a =E9crit :

> We are looking to set up a light-weight user authentication service for
> wireless.  We know the Nu-FW folks have done a good job of creating a
> robust user authentication service

Thank you :-)

>  but we think that we can take some of
> the practices we have learned from using the excellent Qt toolkit to
> create a simple client service that will pre-authenticate to a Linux
> wireless access-point.

Using nufw you can authenticate packets by connection and avoid any
problem with spoofing. I think we've to get rid of the old association
User<->IP that brings too much complexity and a lot of problems.

If you like some help on how to implement nufw protocols (to be able
write a graphical client to nufw) I'm at your disposal.

BR,
--=20
Eric Leblond
NuFW, Now User Filtering Works (http://www.nufw.org)

--=-/C/QSrEwdueAsiWDZqle
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e=2E?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBANLmHnxA7CdMWjzIRAscHAJ9YmpeWqRJ+qSgjuJ0OboLeDk4MZgCfXWuX
rAT+dpglfQqj6GRliMxNjyg=
=P+cZ
-----END PGP SIGNATURE-----

--=-/C/QSrEwdueAsiWDZqle--
