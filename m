From: Harald Welte <laforge@netfilter.org>
Subject: Re: NAT problem with related connections
Date: Tue, 4 Nov 2003 16:44:00 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031104154359.GA31614@sunbeam.de.gnumonks.org>
References: <20031103153941.GF5081@sunbeam.de.gnumonks.org> <DAELKAPIKOFAFFKELNHOCEAJCAAA.listuser@epygi.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Nikolai Dahlem <listuser@epygi.de>
Content-Disposition: inline
In-Reply-To: <DAELKAPIKOFAFFKELNHOCEAJCAAA.listuser@epygi.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 04, 2003 at 02:41:59PM +0100, Nikolai Dahlem wrote:
> So what do you think of raising the expectation after the INVITE packet,
> instead of after the OK packet.

you don't nee to raise the expectation at that way, but you definitely
already need to determine the new 'client' port number and replace it in
the packet payload.

This is what the ip_nat_pptp.c helper does with the CallID in the
OUT_CALL_REQUEST case.

However, there is no way to reserve the tuple at that moment.  So you
can just blindly set it to a random port number, and hope that the full
tuple (which you only know after the OK packet arrived) has not been
taken at that time.

There is no way to recover if the tuple is taken at that point :(

With PPTP it's easier, since we don't deal with port numbers, but with
GRE key id values (and almost nobody uses GRE, so the probability of a
taken tuple is low).

> This way I'd be able to rewrite to the correct port,  but at this moment
> there is no info about the ext.client,
> so what should I enter in the expect-tuple ?

that is not the problem.  You can easily raise an expectation at that
point (fill in zweroes and a mask of 0xFF of the part you don't know
yet, so it won't match)... you'd then later change the expectation after
you've received the OK message from the ext.client.

However, the problem I've described above still persists. We'd need some
kind of reservation for that.

And that is really hard in the SIP case, since all of conntrack works by
unique _tuples_.  It doesn't have a concept of a unique (srcip,srcport)
independent of the destination.   We have full symmetric NAT, and thus
can use the same (srcip,scrport) to may different destinations at the
same time.

The only way I see is to restrict the port range of your MASQUERADE or
SNAT rule to a certain range, and have some ports guaranteed to be free
and usable for SIP NAT bindings.

> kind regards
> Nikolai Dahlem

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/p8k/XaXGVTD0i/8RAouYAJ9G+y74ZsJLjTy4ePIiJH5JOOnO/ACdFAVM
B1Rw4tRXvIAv/3KBcU9EZsI=
=LPky
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--
