From: Harald Welte <laforge@netfilter.org>
Subject: Re: Table duplication on smp machine
Date: Mon, 31 Mar 2003 14:33:26 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030331123326.GO7718@sunbeam.de.gnumonks.org>
References: <3E881DD6.8090206@hipac.org> <20030331110709.GE7718@sunbeam.de.gnumonks.org> <3E882F52.1040705@hipac.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1f4qkB5Yv+YDR+z0"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Thomas Heinz <creatix@hipac.org>
Content-Disposition: inline
In-Reply-To: <3E882F52.1040705@hipac.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--1f4qkB5Yv+YDR+z0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 31, 2003 at 02:06:42PM +0200, Thomas Heinz wrote:
> Hi Harald
>=20
> Thanks for your quick reply.
>=20
> You wrote:
> >it's not only write locking.  Even if there was a locking mechanism in
> >place, and we didn't care about it's performance.=20
> >
> >What we are really caring about is cacheline ping-pong.  If you have a
> >single piece of data (like a counter) that is written by different cpu's
> >all the time, you will always invalidate the cached values in the other
> >cpu's cachelines.
>=20
> I see. If this is the main reason it would suffice to have _one_ ruleset
> for all cpu's but a block of counters for each rule like this:

then you start having cacheline ping-pong problems when match/target
private data is written to (like in the limit match, ...)

apart from that, ther is no reason why we shouldn't do what you are
proposing.  In fact, this is exactly what my initial pkttables/iptables2
design does ;)

=20
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

--1f4qkB5Yv+YDR+z0
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+iDWWXaXGVTD0i/8RAngzAJ44vQI33KDKEkL7CQ3IwI6VvBWjSwCcDc2H
72pJtUGk+MQ82fE/xv2xDYc=
=qgiq
-----END PGP SIGNATURE-----

--1f4qkB5Yv+YDR+z0--
