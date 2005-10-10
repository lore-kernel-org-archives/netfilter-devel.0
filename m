From: Harald Welte <laforge@netfilter.org>
Subject: Re: x_tables vs. nf-hipac
Date: Mon, 10 Oct 2005 18:34:42 +0200
Message-ID: <20051010163442.GC5627@rama>
References: <434A4B11.4030103@gmx.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z4+8/lEcDcG5Ke9S"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2005@gmx.net>
Content-Disposition: inline
In-Reply-To: <434A4B11.4030103@gmx.net>
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


--z4+8/lEcDcG5Ke9S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 10, 2005 at 01:05:53PM +0200, Carl-Daniel Hailfinger wrote:
> Hi Harald,
>=20
> you said that there is already some code for x_tables (is that
> pkttables, and if so, doesn't the new name collide with a spreadsheet
> layout program?).=20

No, x_tables is not pkttables.  However, x_tables matches/targets will
be incrementally changed in order to be used from
{arp,ip,ip6,pkt}_tables _and_ nf-hipac at the same time.

I don't care about spreadsheet programs.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--z4+8/lEcDcG5Ke9S
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDSpgiXaXGVTD0i/8RAjsTAJ9P2qrdrni4RtbJdVXS1a8/8iYMLACfYzJh
Eivaz34fwj9L56f/K3wqufM=
=kyTk
-----END PGP SIGNATURE-----

--z4+8/lEcDcG5Ke9S--
