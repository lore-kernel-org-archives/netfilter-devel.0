From: Harald Welte <laforge@netfilter.org>
Subject: Re: possible target SBALANCE ?
Date: Tue, 29 Apr 2003 16:48:37 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030429144837.GE684@naboo.intranet.astaro.de>
References: <200304192142.h3JLg1S03466@fokkensr.vertis.nl> <20030428091332.GB29390@dns2.italway.it> <20030428134713.GA12364@oknodo.bof.de> <20030428150727.GA10325@dns2.italway.it>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FEz7ebHBGB6b2e8X"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: vecna@s0ftpj.org
Content-Disposition: inline
In-Reply-To: <20030428150727.GA10325@dns2.italway.it>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--FEz7ebHBGB6b2e8X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 28, 2003 at 05:07:27PM +0200, vecna@s0ftpj.org wrote:
> > Regarding your patch, it introduces another new place for cache line
> > pingpong, happening with the same frequency as creation of new conntrac=
ks.
> excuse me, what do you mean with pingpong ?

he is referring to cache line ping pong on SMP systems.  It means that
only one of the per-cpu caches can have writeable data.  as soon as you
write to a certain memory location (like incrementing a counter), all
cached values of this memory location on the other CPU's get
invalidated.  This basically results in a cache miss at every time you
are referencing this memory location, making the CPU idle to wait for
the data from memory to arrive.

> umh, I've always view as hard work the calling of __ip_conntrack_find,
> that call LIST_FIND that one check at the wrong possibility all present
> connection tracked ...

__ip_conntrack_find is an inline function and LIST_FIND a macro.  so
there are not really any function calls involved.

> them explain our system for make a traffic division more or less similar
> to a load balancer, them suppose that statistically all internet connecti=
on
> should be (more or less) equally distributed if is applied a matematic=20
> computation over session params (ip source, ip dest, source porc, dest po=
rt).
>=20
> if we take a look at the last byte of ip addres and port, we could use
> this number and associate them (with a simple LAST_BYTENUMBER %
> POSSIBLE_OUTPUT) to one output interface, for make load balancing
> applied to session without doing session tracking. (because on between
> direction of sessions, ip source ip dest source port dest port, is
> alwayes the some, also with inverted position).

this is not new.  However:
- you cannot have outgoing connections from your individual nodes, since
  you cannot make sure that the reply packets will end up in the correct
  hash bucket
- you cannot deal with complex protocols like FTP,IRC,H.323,SIP,PPTP,...
- your load balancing is static and depends on the equal distribution of
  (source) IP addresses

> I've some time to use for make a possible -j SBALANCE target for do
> a forward on a list of output interface ... did you think that
> should be nice ?=20

I personally don't think this would be very helpful.
=20
> ~c

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--FEz7ebHBGB6b2e8X
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+rpDFXaXGVTD0i/8RAq1vAKCCennVuOxQ3QOLUce+Mx12FP7xUACggD3u
DQ74vfCQi/PE3w8pEsHHdP8=
=aSLJ
-----END PGP SIGNATURE-----

--FEz7ebHBGB6b2e8X--
