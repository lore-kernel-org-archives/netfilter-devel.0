From: Harald Welte <laforge@netfilter.org>
Subject: Re: nopickup-patch
Date: Tue, 15 Jul 2003 18:06:06 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030715160606.GN7198@naboo>
References: <000001c34999$97f22a80$0200a8c0@basti79>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2EnvhqpWJq810sZn"
Cc: Netfilter Mailinglist <netfilter@lists.netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Sebastian <netfilter@basti79.de>
Content-Disposition: inline
In-Reply-To: <000001c34999$97f22a80$0200a8c0@basti79>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--2EnvhqpWJq810sZn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 14, 2003 at 01:50:52AM +0200, Sebastian wrote:
> Hi list...
>=20
> I just wondered, when u r talking about this nopickup-patch, then u mean
> that one located in directory oldnat of POM? Or is there any newer
> version available?

I did a quick 'port' of the patch.  You can now switch pickup off by
using 'echo 0 > /proc/sys/net/ipv4/netfilter/ip_conntrack_tcp_pickup'.

The patch is untested, so it might not even compile (maybe a stupid
typo somewhere). Please give it some testing...

Find the patch in patch-o-matic/pending/57_*

> Greets
> Sebastian.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--2EnvhqpWJq810sZn
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE/FCZtXaXGVTD0i/8RAvqeAJ9+amfFBBYXjpxmRU2ikWYWls65TgCghkxL
XHmt7tKumFaPZj7ySGM7kuQ=
=1xBq
-----END PGP SIGNATURE-----

--2EnvhqpWJq810sZn--
