From: Harald Welte <laforge@netfilter.org>
Subject: Re: Port Triggering and Netfilter
Date: Wed, 18 Jun 2003 18:36:18 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030618163618.GE1661@naboo>
References: <B5AA414A16B5D411B16B0002A507F5B0034600FC@exchil02.mercury.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/unnNtmY43mpUSKx"
Cc: "'netfilter-devel@lists.netfilter.org'" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Michael Pogrebisky <mic@mercury.co.il>
Content-Disposition: inline
In-Reply-To: <B5AA414A16B5D411B16B0002A507F5B0034600FC@exchil02.mercury.co.il>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--/unnNtmY43mpUSKx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 12, 2003 at 01:57:54PM +0300, Michael Pogrebisky wrote:
> Sorry for lengthy e-mail. But, please, read on, it may worth it.

Well, compared with other stuff going on on the devel list, it's not
that lengthy.

> In essence, the client (Windows CE device) opens a TCP connection to the
> server on port 5678. The server, in its turn, opens a connection back to =
the
> client port 990.
>=20
> How it can be supported with Netfilter?

Traditionally, those cases (like any other protocols that use more than
one TCP or UDP connection to establish a 'session') are solved by
implementing a conntrack or NAT helper module.

> I looked extensively through Netfilter docs but failed to find anything
> useful. Did I miss something?

I think so.  From what I understand about ActiveSync from your email (I
do not regularly follow MS development since 1995, so I have no idea
about that protocol by myself), I don't see why this is different from
the traditional 'active FTP' case (control connection / data
connection).

> Here, Port Triggering can come to my rescue.

Port triggering is definitely a mechanism that could solve such
problems.  However, port triggering can easily open up bigger security
problems.  In principle, you are drilling holes into your firwall, just
because somebody connected to some other port.

It is advisable to have some code (i.e. a connection tracking helper
module) to verify some of the application data inside the payload of the
control connection, in order to raise an expectation about the related
slave/sibling connection.

> Port Triggering is a popular extension found on some consumer-grade hardw=
are
> routers (including some Linux-based ones).

Popularity doesn't necessarily make it a good choice.

> In essence, it allows opening (and correct DNAT-ing, if necessary) of
> certain inbound firewall ports if some outbound activity on some other po=
rts
> has been seen from within the private network.

as for outbound connections, this is less risky than for inbound
connections.  However, it is very easy to trick a web browser into
establishing a TCP connection to some 'outside' ip address, just by
using a link scheme like http://evil.host:5678.

> This functionality is somewhat similar to non-passive FTP. The difference=
 is
> that outbound packet analysis is not required for determining the correct
> inbound ports, but instead these ports are simply known in advance.
>=20
> As you can see, this makes perfect solution for my ActiveSync problem.

It is a 'perfect' solution, just like MS and others regard UPnP as
'perfect' solution.  However, they seem to forget what packet filters /
firewalls are about: Security.

> Finally, my last question, does it make sense to add a support for Port
> Triggering to Netfilter?

yes, but we should strongly advise the user about the possible dangers
associated with using port triggering.  It is always the second choice,
if at all.

> What do you think?

feel free to implement such a target, I am happy to include it in
patch-o-matic, and maybe later the mainstream kernel.  However, my
concerns remain.

> Thanks,
> Michael.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--/unnNtmY43mpUSKx
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+8JUCXaXGVTD0i/8RAgc7AKCaaL84GlYp6UoB4E+kAzt6FnS1+wCgqbyu
CK/q07Rjeytgjhn2+4a+gI4=
=C7R3
-----END PGP SIGNATURE-----

--/unnNtmY43mpUSKx--
