From: Harald Welte <laforge@netfilter.org>
Subject: Re: Table duplication on smp machine
Date: Mon, 31 Mar 2003 13:07:09 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030331110709.GE7718@sunbeam.de.gnumonks.org>
References: <3E881DD6.8090206@hipac.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4imyEzq1NYdDURgI"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Thomas Heinz <creatix@hipac.org>
Content-Disposition: inline
In-Reply-To: <3E881DD6.8090206@hipac.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--4imyEzq1NYdDURgI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 31, 2003 at 12:52:06PM +0200, Thomas Heinz wrote:
> Hi
>=20
> Netfilter maintains different tables for each cpu which is especially
> interesting for smp ;-)

yes.

> This is done - according to the docs - to avoid write locking.
> Now, what would be write locked in case we had only one set of
> rules:

it's not only write locking.  Even if there was a locking mechanism in
place, and we didn't care about it's performance.=20

What we are really caring about is cacheline ping-pong.  If you have a
single piece of data (like a counter) that is written by different cpu's
all the time, you will always invalidate the cached values in the other
cpu's cachelines.

> Hm, remains a). There must be another reason. Otherwise a lot
> of space is wasted just to keep separate per-cpu counter values.

Depends on what you think of 'a lot of space'.  In all my practical
setups, the connection tracking table is significantly larger (by orders
of magnitude) than the iptables ruleset.

> Regards
> Thomas

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--4imyEzq1NYdDURgI
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+iCFdXaXGVTD0i/8RAvMwAKCWKWpl6tnkrzMcw0kiHom0ilm6IACgj0MJ
H26iSS8Fr3ubv1TKj3FKZT0=
=hSaT
-----END PGP SIGNATURE-----

--4imyEzq1NYdDURgI--
