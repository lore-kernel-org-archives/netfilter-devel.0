From: Harald Welte <laforge@gnumonks.org>
Subject: Re: Bug with netfilter and NFS server on same machine (fwd)
Date: Mon, 9 Dec 2002 15:18:01 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021209141801.GD2223@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.44.0211231342530.3237-100000@sparrow> <20021205202119.GH11068@naboo.club.berlin.ccc.de> <3DEFF5B2.1050106@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ABTtc+pdwF7KHXCz"
Cc: William Stearns <wstearns@pobox.com>,
	ML-netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Lars Knudsen <gandalfit@virgilio.it>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <3DEFF5B2.1050106@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--ABTtc+pdwF7KHXCz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 06, 2002 at 01:56:18AM +0100, Patrick McHardy wrote:
> Hi,
>=20
> Harald Welte wrote:

> I experienced the same problem since almost 6 months with nfs and netfilt=
er,
> nfs was veery slow, it wasn't even possible to listen to mp3s over nfs.

I have experienced the problem the last two days, which I was running a
debian woody system with an 2.4.18-k7 kernel.  I've now compiled my own
kernel again (2.4.20-final with lots of patch-o-matic stuff) and the
problem is gone again [nothing but the kernel on the conntracking
nfs-serve was changed].

I'm running lots of Conectiva and Redhat systems with 2.4.18+ kernels
and don't have this particular conntrack problem on any machine.

> bye,
> patrick

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--ABTtc+pdwF7KHXCz
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE99KYZXaXGVTD0i/8RAjZcAJ9wLUhnfMoAbYsO/P1XRnBJNZHuywCgpSi7
LoaQv8Qx3uqn27W3+XFNlgE=
=9CB/
-----END PGP SIGNATURE-----

--ABTtc+pdwF7KHXCz--
