From: Harald Welte <laforge@gnumonks.org>
Subject: Re: netfilter for IPv6
Date: Tue, 5 Nov 2002 00:13:00 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021105001300.B8635@sunbeam.de.gnumonks.org>
References: <200211042309.gA4N9A6K028235@rm-rstar.sfu.ca>
Reply-To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xxKTo6wS8zlLE5N3"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Peter Lee <mclee@sfu.ca>
Content-Disposition: inline
In-Reply-To: <200211042309.gA4N9A6K028235@rm-rstar.sfu.ca>; from mclee@sfu.ca on Mon, Nov 04, 2002 at 03:09:10PM -0800
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--xxKTo6wS8zlLE5N3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 04, 2002 at 03:09:10PM -0800, Peter Lee wrote:
> Hi,
>=20

hi. please direct netfilter-related questions to
netfilter-devel@lists.netfilter.org

> Is there any good tutorial on how to use netfilter hooks for IPv6? I'm st=
uck
> in the middle of porting an IPv4 protocol to IPv6. Please help.

There is no difference between netfilter hooks for ipv4 and ipv6. You=20
use them exactly the same way.

However, if you are porting a protocol, netfilter shouldn't be involved at
all.  Transport Protocols (layer 4) are dealt with in the standard network
stack

> Peter Lee
> M.Eng. Student
> Simon Fraser University

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--xxKTo6wS8zlLE5N3
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9xv78XaXGVTD0i/8RAkavAKCyXFeVPmyVzGsXMxqQNrpBH9ppyACfbuPr
SSon0/7JDiedNatcChHGkjY=
=CX6J
-----END PGP SIGNATURE-----

--xxKTo6wS8zlLE5N3--
