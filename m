From: Stephen Frost <sfrost@snowman.net>
Subject: Re: [PATCH] 2.4.x new amanda conntrack + NAT support
Date: Mon, 31 Mar 2003 10:24:54 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030331152454.GQ18434@ns.snowman.net>
References: <20030330200750.GZ7718@sunbeam.de.gnumonks.org> <20030331.070910.52982765.davem@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="F74xYepWx8quU230"
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
Content-Disposition: inline
In-Reply-To: <20030331.070910.52982765.davem@redhat.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--F74xYepWx8quU230
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* David S. Miller (davem@redhat.com) wrote:
>    From: Harald Welte <laforge@netfilter.org>
>    Date: Sun, 30 Mar 2003 22:07:50 +0200
>=20
>    Author: Brian J. Murrell <netfilter@interlinx.bc.ca>
>    The attached patch for 2.4.x adds new support for connection tracking =
and
>    NAT of the amanda backup protocol.  The patch is incremental to all
>    other 2.4.20 updates (including the tftp patch) I've sent you so far.
>=20
> Applied to 2.4.x, thank you.
>=20
> Harald, what is the state of ipt_recent?  Will I see it soon?

I was hoping to release 0.3.1 over the weekend but got busy with real
life. :)  I'll release it today, probably in the next hour or two.  It's
working well for me though I havn't gotten as much feedback as I would
have liked from other users.

	Stephen

--F74xYepWx8quU230
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+iF3GrzgMPqB3kigRAhtsAKCWfGz+Fzc30yXTBqRXrz8PLbKOYQCfZ6cY
/m5t1o3NnXRrxuES98xfuGo=
=UO3V
-----END PGP SIGNATURE-----

--F74xYepWx8quU230--
