From: Harald Welte <laforge@netfilter.org>
Subject: Re: raw patch = kernel panic :(
Date: Tue, 7 Oct 2003 12:52:37 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031007105237.GR18246@sunbeam.de.gnumonks.org>
References: <20031006142214.GM5758@sunbeam.de.gnumonks.org> <Pine.LNX.4.33.0310071154220.17604-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Zbynv6TNPa9FrOf6"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0310071154220.17604-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Zbynv6TNPa9FrOf6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 07, 2003 at 12:12:12PM +0200, Jozsef Kadlecsik wrote:
> > So I don't really see the need for raw.patch having a userspace part at
> > all.
> >
> > Did I miss something?
>=20
> No, then there's no problem. I did not think of simply releasing a new
> iptables snapshot.

I'm about to release 1.2.9 anyway, so I'll add the userspace part of the
raw patch now.

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

--Zbynv6TNPa9FrOf6
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/gpr1XaXGVTD0i/8RAgH6AJ9h/4/xE7LGpUD2ed0vU2GnPVHd8QCeN8Hj
G2BN34WIJlpDhiRTIHeqTrM=
=6fds
-----END PGP SIGNATURE-----

--Zbynv6TNPa9FrOf6--
