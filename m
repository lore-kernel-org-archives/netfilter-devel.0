From: Nigel Kukard <nkukard@lbsd.net>
Subject: Re: ip_queue & QUEUE target
Date: Sun, 15 Jun 2003 20:00:31 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030615180031.GE2103@lbsd.net>
References: <20030615155352.GD2103@lbsd.net> <3EECA7B2.5090300@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XuV1QlJbYrcVoo+x"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <3EECA7B2.5090300@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--XuV1QlJbYrcVoo+x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


>=20
> netlink sockets provide unreliable communication. your problem is
> probably the sockets receive queue overflowing. ip_queue then
> returns a negative error code to nf_queue which drops the packet.

well i'm pumping through about 5,000 pkt/s, doing a few Mb/s. What would
the best thing be to use? or how could i remedy this problem?

i set the rcv buffer to a few Mb, and also the ipq_maxlen to 8196... is
there anything else i can do?


Regards
Nigel


--XuV1QlJbYrcVoo+x
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+7LQ/KoUGSidwLE4RAqRFAKC6Jl3HGsa3aLry6GcmzLzPo5NsSQCguYwt
ZOimGUWpWYYHrf0+EgePpJc=
=L8G5
-----END PGP SIGNATURE-----

--XuV1QlJbYrcVoo+x--
