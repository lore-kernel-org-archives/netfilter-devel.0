From: Harald Welte <laforge@gnumonks.org>
Subject: Re: conntrack state change logging
Date: Mon, 9 Sep 2002 12:39:16 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020909123916.E3810@sunbeam.de.gnumonks.org>
References: <20020620211242.V2543@sunbeam.de.gnumonks.org> <Pine.LNX.4.33.0209051100260.3007-100000@strut.corplink.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="24zk1gE8NUlDmwG9"
Cc: <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Nick Eggleston <netfilter-devel@nick.corplink.net>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0209051100260.3007-100000@strut.corplink.net>; from netfilter-devel@nick.corplink.net on Thu, Sep 05, 2002 at 11:07:34AM -0500
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--24zk1gE8NUlDmwG9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 05, 2002 at 11:07:34AM -0500, Nick Eggleston wrote:
> Is there a framework for logging activity in the conntrack database?

please see the original ctnetlink patches by Jay Schulist (netfilter-devel=
=20
archives).  Look at the 'ctrace' application.

> Thanks,
> Nick

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

--24zk1gE8NUlDmwG9
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9fHpTXaXGVTD0i/8RAmPNAJwJkfJ/eMq71sU5Ex8Sqi3XhuNgtACePIMm
5XJyj1gXPjtC/1JO2abgc7s=
=6I7K
-----END PGP SIGNATURE-----

--24zk1gE8NUlDmwG9--
