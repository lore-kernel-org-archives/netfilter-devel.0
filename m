From: Peter Surda <shurdeek@panorama.sth.ac.at>
Subject: Re: 2 problems with my net/conntrack helper for MSN
Date: Sun, 1 Jun 2003 08:25:41 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030601062541.GC12264@smith.cb.ac.at>
References: <1054342550.961.68.camel@exile> <20030531174959.GD29312@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V88s5gaDVPzZ0KCq"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20030531174959.GD29312@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--V88s5gaDVPzZ0KCq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 31, 2003 at 07:49:59PM +0200, Harald Welte wrote:
> > Now what happens is, when host A offers its file for download,=20
> > an expectation is created on the NAT box when Host A offers=20
> > the accepted file:
> >=20
> > ?:? -> IP_A:port_A
> >=20
> > But a switchboard server will inform host B that it can
> > connect to host A to download the file.
> > ip_conntrack_msn tries to create a second expectation:
> >=20
> > IP_B:? -> IP_A:port_A
> This is true.  It was never solved for the IRC case.=20
See my previous post, the mentioned rule should solve it.

> - Harald Welte <laforge@netfilter.org>             http://www.netfilter.o=
rg/
Bye,

Peter Surda (Shurdeek) <shurdeek@panorama.sth.ac.at>, ICQ 10236103, +436505=
122023

--=20
       My mind is like a steel trap - rusty and illegal in 37 states.

--V88s5gaDVPzZ0KCq
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: Weitere Infos: siehe http://www.gnupg.org

iD8DBQE+2ZxlzogxsPZwLzcRAspBAJ9sXnbj9o5jzUFHRM9h7mCKc+vxAgCgkQ+M
KDgVQQKlHDJRb4GRr0xGzzY=
=v4Xo
-----END PGP SIGNATURE-----

--V88s5gaDVPzZ0KCq--
