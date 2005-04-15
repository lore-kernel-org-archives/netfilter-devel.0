From: Harald Welte <laforge@netfilter.org>
Subject: Re: SIP/RTP support coming?
Date: Fri, 15 Apr 2005 17:48:04 +0200
Message-ID: <20050415154804.GF25433@sunbeam.de.gnumonks.org>
References: <5caa9b8705021203527b3891d@mail.gmail.com>
	<20050212120847.GA30461@roonstrasse.net>
	<1108238199.1183.11.camel@www.l-chr.com.ar>
	<5caa9b870504150144bc47d62@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YxhXyeZxSPLgOHN0"
Cc: Christian Hentschel <chentschel2@arnet.com.ar>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Steve Davies <davies147@gmail.com>
Content-Disposition: inline
In-Reply-To: <5caa9b870504150144bc47d62@mail.gmail.com>
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


--YxhXyeZxSPLgOHN0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 15, 2005 at 09:44:03AM +0100, Steve Davies wrote:
> Christian,
>=20
> Sorry about taking so long to get back to you - I have been using your
> SIP conntrack helper for a little while now, and it seems to work very
> well for me, also with kernel 2.6.10.
>=20
> Many thanks for providing it.
>=20
> One small problem I do have is the netfilter API change in kernel
> 2.6.11 - Is this change documented anywhere? Is there a
> porting/updating guide anywhere?

unfortunately not.  I suggest looking at a diff between 2.6.10 and
2.6.11 version of a helper (e.g. within patch-o-matic).

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--YxhXyeZxSPLgOHN0
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCX+IzXaXGVTD0i/8RAjiJAKCKFGtPRFSfCSDi/rJkX/NNhHUFhgCdFxKT
170wJ0CHQp9q4tDjJuHHYHk=
=qDG+
-----END PGP SIGNATURE-----

--YxhXyeZxSPLgOHN0--
