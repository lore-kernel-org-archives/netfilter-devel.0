From: Nigel Kukard <nkukard@lbsd.net>
Subject: Re: ip_queue & QUEUE target
Date: Sun, 15 Jun 2003 20:35:05 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030615183504.GG2103@lbsd.net>
References: <20030615155352.GD2103@lbsd.net> <3EECA7B2.5090300@trash.net> <20030615180031.GE2103@lbsd.net> <3EECB5F4.7010004@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bO4vSxwwZtUjUWHo"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <3EECB5F4.7010004@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--bO4vSxwwZtUjUWHo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Probably not much, but did you make sure you also increased
> /proc/sys/net/core/rmem_max ? If you don't mind your statistics
> beeing wrong (better than high drop rates imho) you could
> modify ip_queue so it nf_reinjects packets which could not
> be sent instead of returning a error to nf_queue.
>=20

What about DIVERT sockets, would these be reliable?


-Nigel


--bO4vSxwwZtUjUWHo
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+7LxYKoUGSidwLE4RAlKCAKCgI+d/4nP66VOvbg22Ee8QHm7hTwCfcTUz
6aXNOC0J98WBjS19OADnYbE=
=jXrK
-----END PGP SIGNATURE-----

--bO4vSxwwZtUjUWHo--
