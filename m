From: Harald Welte <laforge@gnumonks.org>
Subject: Re: fixes in netfilter PPTP NAT helper
Date: Mon, 10 Feb 2003 12:06:18 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030210110618.GY24861@sunbeam.de.gnumonks.org>
References: <200302051734.17601.raivis@mt.lv>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O7Os1+MGCLLi8F5z"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Raivis Bucis <raivis@mt.lv>
Content-Disposition: inline
In-Reply-To: <200302051734.17601.raivis@mt.lv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--O7Os1+MGCLLi8F5z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 05, 2003 at 05:34:17PM +0200, Raivis Bucis wrote:
> Hello,
>=20
> I have fixed following 2 bugs in your netfilter PPTP NAT helper:
> 1) PPTP client didn't work on the box that had loaded ip_nat_pptp module;
> 2) DST-NAT didn't work for PPTP connections;
>=20
> Patch is attached.

you seem to be running an old version of the PPTP helper.  Your patch
doesn't match what we currently have in CVS - in fact both of those
problems [and some more] have been addressed by the change

http://cvs.netfilter.org/netfilter/patch-o-matic/extra/pptp-conntrack-nat.p=
atch.diff?r1=3D1.11&r2=3D1.12

> Raivis Bucis
>=20
> P.S.
> By the way, PNS is PPTP server and PAC is PPTP client (according to RFC).=
 It=20
> seems to me you are using these terms with mixed meaning. It made=20
> understanding your code a little bit more difficult.

I am aware of the terminology.  If it is used differently than in the
RFC, it's a mistake.  If you have some time left, please provide a patch
to make it consistent.  Thanks.

--=20
- Harald Welte <laforge@gnumonks.org>               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--O7Os1+MGCLLi8F5z
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+R4eqXaXGVTD0i/8RAie5AKCkdn7CLiT1Kmn/9a5XvD2LG3Mp1wCgiOVf
ZrgGicgXObWJhgEMk6MJp9M=
=aesT
-----END PGP SIGNATURE-----

--O7Os1+MGCLLi8F5z--
