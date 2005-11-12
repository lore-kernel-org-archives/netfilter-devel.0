From: Harald Welte <laforge@netfilter.org>
Subject: Re: Simulatenous use of LOG and ULOG on 2.6.14
Date: Sat, 12 Nov 2005 11:17:27 +0100
Message-ID: <20051112101727.GC10584@sunbeam.de.gnumonks.org>
References: <436EF34E.2030806@netboxblue.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eGwLO2yoW8Ya4hN1"
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Menno Smits <menno@netboxblue.com>
Content-Disposition: inline
In-Reply-To: <436EF34E.2030806@netboxblue.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--eGwLO2yoW8Ya4hN1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 07, 2005 at 04:25:18PM +1000, Menno Smits wrote:
> Hi,
>=20
> I'm trying to use the LOG and ULOG targets simultaenously on 2.6.14
> but am having problems.  This used to work on previous kernel
> versions.

this is no longer possible, since both now use the nf_log API.
Everything you log via LOG, ULOG or NFLOG will be sent to the nf_log
core.  At any given time, there can only be one backend registered to
nf_log.

The idea is that in the long term there will only be one LOG target that
everybody uses.

One thing that I've been thinking about, though, was having priorities.
So when you use ULOG/NFLOG and your daemon dies, it would fall back to
the LOG/dmesg backend, if that is available.

> How do I make this work as before? I need to be able to use both ULOG and=
 LOG at the same=20
> time. Will it work if enable CONFIG_NETFILTER_NETLINK and related options=
 and port the=20
> daemon to the new libnetfilter_log library? I'd really prefer to not have=
 to touch the=20
> daemon at this stage but will if that's the only answer.

no, it wouldn't be any different.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--eGwLO2yoW8Ya4hN1
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDdcE3XaXGVTD0i/8RAi/8AJ45thBcc89cDztZqGTdk85+a5QbcACfV/TE
LaG0HO8EIV/3/RdGnvxdDI8=
=WlSE
-----END PGP SIGNATURE-----

--eGwLO2yoW8Ya4hN1--
