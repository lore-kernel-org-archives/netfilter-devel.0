From: Harald Welte <laforge@gnumonks.org>
Subject: Re: bug in iptables-save/iptables-restore
Date: Mon, 9 Dec 2002 17:28:58 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021209162858.GL2223@sunbeam.de.gnumonks.org>
References: <3DD7B46F.3050006@attbi.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J2pR2RtFp0tAjF3C"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Gerry Skerbitz <gsker@attbi.com>
Content-Disposition: inline
In-Reply-To: <3DD7B46F.3050006@attbi.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--J2pR2RtFp0tAjF3C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 17, 2002 at 09:23:27AM -0600, Gerry Skerbitz wrote:
> here are the offending lines created by iptables-save:
> #~>iptables-save | grep length
> -A CUST_LOG -p tcp -m length --length !40:68 -j LOG --log-prefix=20
> "PACKET_LENGTH_BAD: " --log-level 7 --log-tcp-options --log-ip-options
> -A CUST_LOG -p tcp -m length --length !40:68 -j DROP
> #~>
>=20
> I just did some digging and figured out that the exclamation point=20
> should go before the --length 40:68.  I guess that's
> what iptables-save should really do and clearly it's what narc does when=
=20
> it sets up the rule.

there was a bugfix for libipt_length.c, which is in latest CVS.  Could
you try using the latest CVS version (or the latest iptables-snapshot
from ftp.netfilter.org) and see if the bug is gone?

Thanks.

> Gerry

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--J2pR2RtFp0tAjF3C
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE99MTKXaXGVTD0i/8RAiLIAJ4oXfuY2Hfu5jD+MovNBggNfgfc0gCdHZRy
y7K8BGPanBGkzXDodkBdO7A=
=Y/cc
-----END PGP SIGNATURE-----

--J2pR2RtFp0tAjF3C--
