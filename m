From: Harald Welte <laforge@netfilter.org>
Subject: Re: [netfilter-core] iptables/conntrack in enterprise environment.
Date: Sat, 31 May 2003 19:20:46 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030531172046.GB29312@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.33.0305291422290.8961-100000@blackhole.kfki.hu> <Pine.GSO.4.33.0305291009480.21132-100000@castle.srealm.net.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="95puKF9o0QNvO5PE"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Preston A. Elder" <prez@srealm.net.au>
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.33.0305291009480.21132-100000@castle.srealm.net.au>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--95puKF9o0QNvO5PE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 29, 2003 at 10:16:07AM -0400, Preston A. Elder wrote:
> > But how those connections disappear? Normal TCP closing?
> The majority, I believe so, however, that is beside the point.  Should it
> really matter if it was closed with a RST or a FIN/FINACK/ACK?  conntrack
> should realise the connection is closed either way, and stop tracking it.

yes, and it is supposed to do so.

> Hell, even if it didn't even get a RST *OR* FIN (ie. the lan cable was
> unplugged or something, which is NOT happening), these are connections
> to the LOCAL machine.  TCP keepalive should take care of it regardless.
> In any case, the kernel TCP stack knows the connection is no longer valid
> (and that port is now available for use again), why does connection
> tracking still keep the connection tracked.

Connection tracking has no notion of local or remote connections.  And I
really don't like the idea of putting some callbacks into the socket
code for the very special case somebody is tracking locally terminated
connections.

> OK, I realise the connection tracking subsystem is keeping track of the
> connection that is supposed to go to a remote machine, so it can't rely on
> the local TCP stack, however, I'm pretty sure that every connection in
> this case is getting either a RST or a FIN/FINACK/ACK to close down the
> socket, so I really can't see why connection tracking has to wait for the
> pre-set expiry time (ie. leave stale entries), it just seems sloppy.

are you talking about the ESTABLISHED expiry time?  If this happens,
there really is some bug.  However, I am still not convinced that you
are indeed seeing some malfunction in conntrack.

> PreZ (using a different email client, which is why this email is not
> signed).
=20

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--95puKF9o0QNvO5PE
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+2ORuXaXGVTD0i/8RAi5hAKCMIK0ZCnfZJ2ZqLzdYL0gzluCJ6wCeJ9An
6DN9rUb4QX2bpd9zV84/dPs=
=3j/q
-----END PGP SIGNATURE-----

--95puKF9o0QNvO5PE--
