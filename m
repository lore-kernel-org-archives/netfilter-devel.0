From: Harald Welte <laforge@netfilter.org>
Subject: Re: IP6TABLES and Muulticast Listener ICMPV6 PDUs
Date: Mon, 10 Nov 2003 19:05:54 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031110180554.GT8206@sunbeam.de.gnumonks.org>
References: <20031110115012.GB2850@ruf098.fkie.fgan.de>
Reply-To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y/XsGip80ttrIE8G"
Cc: netfilter-devel@lists.netfilter.org,
	Netfilter Mailinglist <netfilter@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Christian Riechmann <riechmann@fgan.de>
Content-Disposition: inline
In-Reply-To: <20031110115012.GB2850@ruf098.fkie.fgan.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--y/XsGip80ttrIE8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[Please follow-up-to netfilter-devel]

On Mon, Nov 10, 2003 at 12:50:12PM +0100, Christian Riechmann wrote:

> I am working on a project dealing with IPv6 and Multicast.=20
> I am trying to filter those IPv6 PDUs being sent by my host and
> containing ICMPv6 Multicast Listener Discovery Protocol (MLDP) PDUs.
> (In other words I want to see those Multicast Reports which
> inform a router that my host wants to see those PDUs which are
> sent to a specific multicast address.)These PDUs shall be queued
> for some processing within a user space program.=20
>=20
> I tried a lot of IP6TABLES rules, but just these types of=20
> ICMPV6 PDUs are not queued.=20
>=20
> I tried different rules, but none worked:
> 	ip6tables -A OUTPUT -p icmp6 -j QUEUE
> 	ip6tables -A OUTPUT -p icmpv6 -j QUEUE
> 	ip6tables -A OUTPUT -p ipv6-icmp -j QUEUE

they are all the same, just synonyms.

> I should mention that ICMPv6 HELLO PDUs are well queued.
> And:
> 	ip6tables -A OUTPUT -p ipv6 -j QUEUE
>=20
> The last rule queues all IPv6 PDUs except those I really
> want to see: MLDP-PDUs.
>=20
> All tests running on Kernels 2.4.18, 2.4.22 and 2.6.0test8
> show the same results.

yes, indeed.  After reading the ipv6 multicast code, I can confirm that
incoming MLD packets (e.g. queries from the network) are traversing
netfilter, but outgoing ones seem to be sent directly by net/ipv6/mcast.c

I really don't have the time to write a patch for this right now.  Could
you please enter it into our bugzilla.netfilter.org bugtracking system?
This way it [at least] cannot get lost.

> Christian Riechmann
> (riechmann@fgan.de)

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--y/XsGip80ttrIE8G
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/r9OCXaXGVTD0i/8RAkXcAKCoz/+IxRqit23hP/CN6kSTeduxdACgg9BY
/xj1xAN3udDUb66yHv7MjjI=
=9HnK
-----END PGP SIGNATURE-----

--y/XsGip80ttrIE8G--
