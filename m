From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] comment match port to pom-ng
Date: Mon, 17 May 2004 15:43:38 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040517134338.GD11060@obroa-skai.de.gnumonks.org>
References: <40A29A7D.A1111933@info-link.net> <Pine.LNX.4.33.0405141055450.21804-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4zI0WCX1RcnW9Hbu"
Cc: Brad Fisher <brad@info-link.net>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0405141055450.21804-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--4zI0WCX1RcnW9Hbu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 14, 2004 at 11:09:55AM +0200, Jozsef Kadlecsik wrote:
> Hi Brad,
>=20
> On Wed, 12 May 2004, Brad Fisher wrote:
>=20
> > Attached is a tar file containing the comment match I wrote a while back
> > (Also posted before for old POM with no response:
> > http://marc.theaimsgroup.com/?l=3Dnetfilter-devel&m=3D107056927528485&w=
=3D2).
> > I've ported it to pom-ng, and it should work for 2.4 kernels fine.
> > Haven't tested 2.6 kernels, but will hopefully get a chance soon.
>=20
> Sorry, but could you demonstrate the necessity/usefulness of such a
> feature? I tried to figure out at least one, but failed.

Jozsef, we have so many questionable or even useless (according to our
judgement) stuff in patch-o-matic, let's add the comment match with a
big warning (in source code, Kconfig, manpage and iptables --help), too.

Maybe we should add some kind of bitmask/flags to every pomng patchlet.
Something like POMNG_PATCHLET_UNWISE ;)

> Best regards,
> Jozsef


--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--4zI0WCX1RcnW9Hbu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAqMGKXaXGVTD0i/8RAiFlAJwKjpwN5tz5spin4VSNX5doYprjpACgmgBz
3Cv1EMDgHOciQk8M2HviZog=
=M7Np
-----END PGP SIGNATURE-----

--4zI0WCX1RcnW9Hbu--
