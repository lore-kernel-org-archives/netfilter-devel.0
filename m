From: Harald Welte <laforge@netfilter.org>
Subject: Re: conntrack and ICMP errors
Date: Sun, 13 Apr 2003 18:43:13 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030413164313.GZ1922@sunbeam.de.gnumonks.org>
References: <20030410182056.GA17723@bzorp.balabit.hu> <20030410200816.GA18520@oknodo.bof.de> <20030411094340.GA32552@balabit.hu> <20030411094956.GC18520@oknodo.bof.de> <20030411101648.GB32552@balabit.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qa1NXTiqN6KSzHv0"
Cc: Patrick Schaaf <bof@bof.de>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Balazs Scheidler <bazsi@balabit.hu>
Content-Disposition: inline
In-Reply-To: <20030411101648.GB32552@balabit.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--qa1NXTiqN6KSzHv0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 11, 2003 at 12:16:48PM +0200, Balazs Scheidler wrote:

> You are right, ICMP port unreachable is sent only in reaction to a SYN. S=
o I
> was not right, however:
>=20
> when an RST is received to a SYN the timeout becomes 60 secs
> (ip_conntrack_proto_tcp.c, timeout in state CONNTRACK_CLOSE)
>=20
> when an ICMP error is received to a SYN it is not considered therefore the
> SYN_SENT timeout applies which is 120 secs
>=20
> OK, this is not a grave problem but is still an inconsistency.

Yes, it is.  If there is an easy fix, I'm happy to include it.

> But this error is propagated to userspace if IP_RECVERR socket option is
> enabled for the socket:

which is the case for 0.1% of all applications (unfortunately) :(

> err_soft is picked up only in case send() timeouts. Therefore other than =
the
> small timeout difference between the SYN-RST and SYN-ICMP UNREACH scenari=
os
> TCP would not necessary need to consider ICMP errors.

ok.  So we are talking about a tiny inconsistency that doesn't have
that grave practical implications.  The question would be: How to solve
this interdependency of icmp/tcp resp. icmp/udp within our current
modular 'ip_conntrack_protocol' approach, without making the code too
much interdependent.

> The more I think about this the more I understand the my scenario (with t=
he
> proxies) would not be solved by terminating sessions when an ICMP error
> occurs, the solution would be more to explicitly request a state removal
> from userspace. Hmm... it might be time to check ctnetlink?

removing a conntrack entry by ctnetlink is one of the few things that
are in the current ctnetlink code.  ctnltest.c even uses it.

> Bazsi

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--qa1NXTiqN6KSzHv0
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+mZOhXaXGVTD0i/8RApmgAJ9ZysfGcqj9hAyQvTtX9TtojdlakgCfa+E2
8cjg0CSdXXT67uKa9tjUoBI=
=EbWM
-----END PGP SIGNATURE-----

--qa1NXTiqN6KSzHv0--
