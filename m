From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [Q]what is the net_ratelimit() ?
Date: Mon, 6 Jan 2003 14:02:45 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030106130245.GH9467@sunbeam.de.gnumonks.org>
References: <CKEGJOPDOMNNFIGIMICAGENDCCAA.caster@postech.ac.kr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mjrw6G9AoRBv8oQK"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: caster@postech.ac.kr
Content-Disposition: inline
In-Reply-To: <CKEGJOPDOMNNFIGIMICAGENDCCAA.caster@postech.ac.kr>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--mjrw6G9AoRBv8oQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 20, 2002 at 11:26:39AM +0900, caster@postech.ac.kr wrote:
> Must  every printk messages in network BH  use net_ratelimit?

this is just a ratelimiting of the error messages to ensure we don't
clog up syslog.

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--mjrw6G9AoRBv8oQK
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+GX51XaXGVTD0i/8RAvjbAJ0cvKasxZwf0vlZsBATrt5+F8RkMACgiuWt
sUdDIDRoRfWrIV5y2ZikopA=
=HY7e
-----END PGP SIGNATURE-----

--mjrw6G9AoRBv8oQK--
