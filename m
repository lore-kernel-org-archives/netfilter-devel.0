From: Harald Welte <laforge@netfilter.org>
Subject: Re: PATCH: extra conntrack stats
Date: Thu, 1 May 2003 13:32:48 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030501113248.GE26924@sunbeam.de.gnumonks.org>
References: <1051743903.8213.188.camel@tux.rsn.bth.se> <20030501050235.F0DCE2C04F@lists.samba.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xJK8B5Wah2CMJs8h"
Cc: Martin Josefsson <gandalf@wlug.westbo.se>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Rolf Fokkens <fokkensr@fokkensr.vertis.nl>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Patrick Schaaf <bof@bof.de>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline
In-Reply-To: <20030501050235.F0DCE2C04F@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--xJK8B5Wah2CMJs8h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 01, 2003 at 02:05:52PM +1000, Rusty Russell wrote:

> Ignoring NAT for the moment, and using a 32-bit arch:
> So, we're about 192 bytes.  We could get to 80 bytes.

JFYI: including PPTP nat (which expands struct ip_conntrack_tuple),
sizeof(struct ip_conntrack) is about 340 bytes on a 32bit arch.

> Cheers,
> Rusty.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--xJK8B5Wah2CMJs8h
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+sQXgXaXGVTD0i/8RAoKDAJ0Q0Ym4Oxg1n1lNr+UWTEihj9FHmACghiZj
A4o0IWCTK5MuM++LnCZ4OOA=
=2whC
-----END PGP SIGNATURE-----

--xJK8B5Wah2CMJs8h--
