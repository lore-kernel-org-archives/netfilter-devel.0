From: Harald Welte <laforge@gnumonks.org>
Subject: Re: TCP/IP checksums and changing destination address
Date: Sat, 15 Jun 2002 14:58:05 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020615145805.U2543@sunbeam.de.gnumonks.org>
References: <03781128C7B74B4DBC27C55859C9D73809840639@es06snlnt>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="K9yN6gtjNHvbaj05"
Cc: "'netfilter-devel@lists.samba.org'" <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: "Shipman, Jeffrey E" <jeshipm@sandia.gov>
Content-Disposition: inline
In-Reply-To: <03781128C7B74B4DBC27C55859C9D73809840639@es06snlnt>; from jeshipm@sandia.gov on Fri, Jun 14, 2002 at 08:03:38AM -0600
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--K9yN6gtjNHvbaj05
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 14, 2002 at 08:03:38AM -0600, Shipman, Jeffrey E wrote:
> I'm currently writing a netfilter module to modify
> some options in TCP packets. Currently, I'm just
> trying to learn a bit about it so I've written a
> module that 1) Sets the PSH flag in all TCP packets
> and 2) Modifies the destination address to be the
> source address.
>=20
> I wrote a small function that uses tcp_v4_check()
> and ip_fast_csum() to recalculate the checksums
> on the packets.=20

This is wrong. Just think of a packet arriving with broken checksum, and th=
en
you recalculate the checksum - passing on a broken packet with a valid
checksum. Please use incremental checksumming, as used by netfilter/iptables
all over the place (like in ipt_TOS.c, or ipt_TCPMSS.c)

> Jeff Shipman - CCD
> Sandia National Laboratories

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M+=
=20
V-- PS++ PE-- Y++ PGP++ t+ 5-- !X !R tv-- b+++ !DI !D G+ e* h--- r++ y+(*)

--K9yN6gtjNHvbaj05
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9CzncXaXGVTD0i/8RAg9kAKCt/PtKgbVpc3Jk76H4rFLLmonPqwCfXmvP
dw8E2OEI6/k9japiyI4ZT2E=
=7YMb
-----END PGP SIGNATURE-----

--K9yN6gtjNHvbaj05--
