From: Harald Welte <laforge@gnumonks.org>
Subject: Re: Corruption on mangle/INPUT when MARKing packets
Date: Mon, 6 Jan 2003 13:52:30 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030106125230.GE9467@sunbeam.de.gnumonks.org>
References: <37584.195.97.5.193.1041644841.squirrel@fs.tsaousis.gr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ugCSa1rMkiCAmd9S"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Costa Tsaousis <costa@tsaousis.gr>
Content-Disposition: inline
In-Reply-To: <37584.195.97.5.193.1041644841.squirrel@fs.tsaousis.gr>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--ugCSa1rMkiCAmd9S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 04, 2003 at 03:47:21AM +0200, Costa Tsaousis wrote:

> During a few experiments I made I believe I have found a bug in
> iptables.=20
>=20
> To reproduce the bug, type:
>=20
> # /etc/init.d/iptables stop
> # iptables -t mangle -A INPUT -p icmp -j MARK --set-mark 1
>=20
> Now, this host will be unpingable.


This is really strange.  I can perfectly reproduce the bug, but I cannot
see how this happens.  the whole net/ipv4/icmp.c code doesn't do
anything with the nfmark of the original skb.

I'll have to investigate this further. Stay tuned.
=20
Thanks for reporting the bug...

> Kind Regards
> Costa Tsaousis

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--ugCSa1rMkiCAmd9S
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+GXwOXaXGVTD0i/8RAgdcAJ9nOWN5RQaWJbuu4de0wjsVXuzLwQCfcP/q
BFJo5Xhp1bGgDNbcBz5qiDQ=
=REqf
-----END PGP SIGNATURE-----

--ugCSa1rMkiCAmd9S--
