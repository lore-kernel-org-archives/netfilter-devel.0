From: Harald Welte <laforge@netfilter.org>
Subject: Re: libiptc - frustrating
Date: Thu, 2 Oct 2003 22:13:44 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031002201344.GF5758@sunbeam.de.gnumonks.org>
References: <3F7C4919.8060800@hhb.bonn.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4WQlXZB3DN+7gtbl"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Karsten =?iso-8859-1?Q?R=F6mke?= <Biermann-Roemke@t-online.de>
Content-Disposition: inline
In-Reply-To: <3F7C4919.8060800@hhb.bonn.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--4WQlXZB3DN+7gtbl
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 02, 2003 at 05:49:45PM +0200, Karsten R=F6mke wrote:
> OK, cause it was some work I now thought:
> "look for examples in the archive" and I found:
>=20
> >We said it before and we say it again. libiptc was never intended to=20
> >be used by anything else but iptables.c self. Its not an "open" API
> >to be used by any C-program. It might be and will be changed without
> >any notice possible making your c-program not working anymore.
>=20
> Uuups - horrible for me :-)

yes, unfortunately...

> Question: how can I insert a rule from a running daemon in the fastest wa=
y:
> 1) calling a system("iptables ..."), don't know if the syntas is correct
> 2) doing the work again of analyzing the source code again
> 3) linking iptables.o to my application. I remember, that I've not done t=
hat
>    because iptables never frees any memory - only allocates - not=20
> useful for a
>    long time running program.

this should be fixed now.

You have to consider a fourth option:
4) running iptables-restore --noflash and piping commands to stdin.

Depending on your usage scenario (how frequent do you have ruleset
changes?) this might be the fastest one.

> Thank you
> 	Karsten

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--4WQlXZB3DN+7gtbl
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/fIb4XaXGVTD0i/8RAkAxAJsFwGTE9s3V1G8fHAduz69ObockIgCfQJ6n
HkL2+kyGKwStK5z5XpSiwd0=
=ybE/
-----END PGP SIGNATURE-----

--4WQlXZB3DN+7gtbl--
