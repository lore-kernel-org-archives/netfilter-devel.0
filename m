From: Harald Welte <laforge@netfilter.org>
Subject: Re: [netfilter-core] Re: [ANNOUNCE] Release of iptables-1.2.9
Date: Fri, 7 Nov 2003 14:55:20 +0100
Sender: netfilter-admin@lists.netfilter.org
Message-ID: <20031107135520.GM5741@sunbeam.de.gnumonks.org>
References: <20031102171611.GF1536@sunbeam.de.gnumonks.org> <20031107073518.GA1215@alpha.home.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BZziOT8Kz25R/m/E"
Cc: Netfilter Core Team <coreteam@netfilter.org>,
	Netfilter Announcement List <netfilter-announce@lists.netfilter.org>,
	Netfilter Mailinglist <netfilter@lists.netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-admin@lists.netfilter.org>
To: Willy Tarreau <willy@w.ods.org>
Content-Disposition: inline
In-Reply-To: <20031107073518.GA1215@alpha.home.local>
Errors-To: netfilter-admin@lists.netfilter.org
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter/>
List-Id: netfilter-devel.vger.kernel.org


--BZziOT8Kz25R/m/E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 07, 2003 at 08:35:18AM +0100, Willy Tarreau wrote:
> Hi Harald,
>=20
> > 	http://www.netfilter.org/files/iptables-1.2.9.tar.bz2
> > 	ftp://ftp.netfilter.org/pub/iptables/iptables-1.2.9.tar.bz2
>=20
> I was wondering why this file was nearly 50kB bigger than rc1. In fact, t=
he
> archive contains some old files, totalizing about 160 kB :
>=20
>   extensions/.#libipt_ECN.c.1.7
>   extensions/.#libipt_recent.c.1.6
>   .#iptables.c.1.54
>   .#iptables.c.1.55
>   libiptc2/.libiptc.c.1.40

oh, I wonder how they get there... .# looks like emacs, but I never use
emacs...

thanks for pointing this out, I'll try to avoid that for the next
release.

> That's harmless however. I will probably upgrade today some hosts on which
> I installed rc1 a few days ago and which didn't have any problem with it.

That's great, thanks!

> Cheers,
> Willy

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--BZziOT8Kz25R/m/E
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/q6RHXaXGVTD0i/8RAh0CAKCrYD3oDEjvIMqaMV7UEpnac6Mt/ACfR8nG
mrt5u5pKtunFLaiAmCSBzw4=
=LMhJ
-----END PGP SIGNATURE-----

--BZziOT8Kz25R/m/E--
