From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [RFC] how to write static int parse(...) function
Date: Sun, 16 Jun 2002 21:59:00 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020616215900.I2543@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.21.0206151504090.16282-100000@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2W4wSx0jmTCcLO7w"
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.21.0206151504090.16282-100000@dns.toxicfilms.tv>; from solt@dns.toxicfilms.tv on Sat, Jun 15, 2002 at 03:11:44PM +0200
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--2W4wSx0jmTCcLO7w
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 15, 2002 at 03:11:44PM +0200, Maciej Soltysiak wrote:
> Hello,
>=20
> I am writing options to the unclean module, so that we can:
> -m unclean --tcp, -m unclean ! --udp, etc.
>=20
> I have the kernelspace additions written.
> The userspace libipt_unclean.c need rewriting, and here i come across a
> problem:
> i do not know what all the functions and variables there mean.
> like, flags, nfcache, invert, check_invert.

nfcache was never implemented, and has no meaning in userspace anyway.

invert just tells you if the parameter was inverted. So what you have is=20
a case statement with:

    switch (c) {
        case 'F':
		// check if this option is already set=20
                if (*flags & IPT_ECN_OP_MATCH_CWR)
                        exit_error(PARAMETER_PROBLEM,
                                   "ECN match: can only use parameter ONCE!=
");
		// see if the option is inverted.  This sets 'invert'
		// and possibly changes 'optind' (so it reflects the option and
		// not the '!'
                check_inverse(optarg, &invert, &optind, 0);
                einfo->operation |=3D IPT_ECN_OP_MATCH_CWR;
		// if invert is true [set by check_inverse], store invert
		// flag for this option in match->data
                if (invert)
                        einfo->invert |=3D IPT_ECN_OP_MATCH_CWR;
		// set flags to detect if parameter was used more than once
                *flags |=3D IPT_ECN_OP_MATCH_CWR;
                break;

> Best Regards,
> Maciej Soltysiak

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

--2W4wSx0jmTCcLO7w
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9DO4DXaXGVTD0i/8RAsM6AKCqzNlA+eQWxnOJJqX7fj1INQMWCACeKzRN
UNYOYT1GvefRYZYpoco58WQ=
=cgSx
-----END PGP SIGNATURE-----

--2W4wSx0jmTCcLO7w--
