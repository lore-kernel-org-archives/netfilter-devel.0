From: Harald Welte <laforge@gnumonks.org>
Subject: Re: another PPTP conntrack problem (no fix this time)
Date: Fri, 31 Jan 2003 13:04:34 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030131120434.GA9073@naboo.cybercafe42>
References: <4.2.0.58.20030129161653.01aab6e8@avocetgw> <3E38D590.9070608@snapgear.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m9FEOsnejx470nED"
Cc: Paul Mielke <paulm@routefree.com>, netfilter-devel@lists.netfilter.org,
	paulm@broadon.com
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Philip Craig <philipc@snapgear.com>
Content-Disposition: inline
In-Reply-To: <3E38D590.9070608@snapgear.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--m9FEOsnejx470nED
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 30, 2003 at 05:34:40PM +1000, Philip Craig wrote:
> This sounds like a problem with NAT of ICMP errors, rather than
> a PPTP conntrack problem.  There have been at least 2 patches
> on the list regarding NAT of the inner ICMP header.  I don't
> think either have made it into standard kernels yet.  Have you
> tried them?

Yes, you are correct. After finishing some final testing one of those
patches will make it to the kernel during the next couple of days.

This bug is IIRC also in bugzilla.netfilter.org

> Philip Craig     Software Engineer     http://www.SnapGear.com
=20

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M-=
=20
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)

--m9FEOsnejx470nED
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+OmZSXaXGVTD0i/8RAtD9AJ9G/CB62EvrRQ/2x3mQenMiKPNuxACgoYv5
VJI0Q/JBP+sbWYuXEX37NyQ=
=raga
-----END PGP SIGNATURE-----

--m9FEOsnejx470nED--
