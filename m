From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] ip_conntrack_irc, allowance for quoted filenames
Date: Mon, 12 May 2003 09:53:41 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030512075341.GE3344@sunbeam.de.gnumonks.org>
References: <3EBEFB08.4070903@keyaccess.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kVXhAStRUZ/+rrGn"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Rene Herman <rene.herman@keyaccess.nl>
Content-Disposition: inline
In-Reply-To: <3EBEFB08.4070903@keyaccess.nl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--kVXhAStRUZ/+rrGn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 12, 2003 at 03:38:16AM +0200, Rene Herman wrote:
> Resend, this time _with_ patch ...
>=20
> [ please keep me in CC, not subscribed ]
>=20
> When the irssi (www.irssi.org) IRC client is asked to DCC SEND a file
> with a filename containing spaces, it does so by leaving the spaces
> intact and quoting the filename (""). ip_conntrack_irc.c:parse_dcc()
> however can't handle the embedded spaces.

Thanks a lot, I will include your patch.

This is, however, an irssi extension.  the DCC specification does not
include support for spaces in filenames, neither does the ircII
implementation.

> I haven't checked other clients but I assume they might do the same. Is
> the attached hack (against 2.4.20) acceptable? Should this be solved
> differently and/or elsewhere?

no, it's perfectly fine.

> Rene.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--kVXhAStRUZ/+rrGn
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+v1L5XaXGVTD0i/8RAh20AJoDJNbrytRRln4pM3uz8m9/e6SoygCeN1jP
cSx8ElLuKQlfvbsEx2evUnY=
=jboh
-----END PGP SIGNATURE-----

--kVXhAStRUZ/+rrGn--
