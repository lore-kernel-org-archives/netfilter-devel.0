From: Eric Leblond <eric@regit.org>
Subject: Re: p-o-m-ng patch
Date: Fri, 20 Feb 2004 19:27:34 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1077301654.5116.18.camel@porky>
References: <1077284489.27084.5.camel@tech004.alphalink.fr>
	 <1077300913.5116.12.camel@porky>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Uit2pLfSfPKJeEQ/IHId"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <1077300913.5116.12.camel@porky>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-Uit2pLfSfPKJeEQ/IHId
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Sorry for the disturbance, I do a test from a clean 2.6.3 kernel tree
and there's compilation problem with CONNMARK.

The best match now correctly found the best directory for each type
(patch,file,ladd) but in the CONNMARK patch the files are split  between
the 2 directories (linux  linux-2.6). So we miss a subset of the files.
So my question :
	- Do we change p-o-m-ng or do we change CONNMARK patch ?
BR,

Le ven 20/02/2004 =C3=A0 19:15, Eric Leblond a =C3=A9crit :
> Some adjustement, this patch does not solve the issue of
> Documentation/Configure.help.ladd in the CONNMARK patch.
> This ladd should not be applied if we're compiling a 2.6 kernel.
>=20
> I resend a corrected version.
>=20
> BR,
>=20
> Le ven 20/02/2004 =C3=A0 14:41, Eric Leblond a =C3=A9crit :
> > Hi,
> >=20
> > The best match code has a problem with selection of best directory when
> > initiating patchlet. Existence of a best directory was sufficient to
> > decide to choose this directory even if it is empty.
> > I attach a patch to Netfilter_POM.pm that solves the problem.
> >=20
> > BR,
--=20
Eric Leblond
Nufw, Now User Filtering Works (http://www.nufw.org)

--=-Uit2pLfSfPKJeEQ/IHId
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e=2E?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBANlGUnxA7CdMWjzIRAm76AJ0WVGuTW//H6ria7HqZuB38qqIrVACfRskB
bsisVoRUzx6hQ/sS/tPXWHQ=
=ymP9
-----END PGP SIGNATURE-----

--=-Uit2pLfSfPKJeEQ/IHId--
