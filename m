From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: New draft document on nat / traversal / hole punching (with
	Dan Kegel)
Date: Tue, 09 Nov 2004 19:22:07 +0100
Message-ID: <1100024526.6496.10.camel@tux.rsn.bth.se>
References: <20041109154946.GD22257@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-4PmpkKerFMAmRFVIoNTT"
Cc: Rusty Russell <rusty@rustcorp.com.au>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	coreteam@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20041109154946.GD22257@sunbeam.de.gnumonks.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--=-4PmpkKerFMAmRFVIoNTT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2004-11-09 at 16:49, Harald Welte wrote:
> Hi!

Hi

> On the IETF behave list, I received a link to a yet unpublished draft
> that can be seen as a successor to the old 'kegel draft' (now also
> authored by a whole group).  It should be a good reading for anyone who
> wans to thoroughly understand the problem and see proposed solutions.
>=20
> It now covers both, UDP and TCP.
>=20
> http://www.brynosaurus.com/pub/os/nat.pdf

Interesting read. Just one thing... the tcp-windowtracking patch
"breaks" TCP "hole punching" unless ip_conntrack_tcp_be_liberal is set
nonzero. Maybe we should introduce an option to enable/disable "hole
punching", a few modifications to the state-table, possibly some other
small things and it should work unless I'm missing something.

Rusty, iirc we have a problem in the NAT core when we SNAT and have to
remap ports, later SNAT'd connections from the same host:port pair
doesn't get the same mapping as the first one. You were working on a fix
for this? Was this ever made public?

--=20
/Martin

--=-4PmpkKerFMAmRFVIoNTT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQBBkQrOWm2vlfa207ERAmuhAJ9eWVA+fNTBYGpt9rrGbzY8fX/k4ACggH4E
zBGJeZmpVeCktOuo/svdMcE=
=xe1Y
-----END PGP SIGNATURE-----

--=-4PmpkKerFMAmRFVIoNTT--
