From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] message parsing functions for nfqueue
Date: Fri, 12 Aug 2005 00:48:13 +0200
Message-ID: <20050811224813.GU5353@rama.de.gnumonks.org>
References: <1123794106.4980.11.camel@porky>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u+FGODhbLwgAeSOU"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Vincent Deffontaines <vincent@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
Content-Disposition: inline
In-Reply-To: <1123794106.4980.11.camel@porky>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--u+FGODhbLwgAeSOU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 11, 2005 at 11:01:46PM +0200, Eric Leblond wrote:
> Hi,
>=20
> This is a patch against libnfnetlink_queue.

At the first sight, the patch looks fine to me.  I'll look at it in
detail over the weekend.

Oh. One thing that comes to my mind is "get_{in,out}dev" don't return a
device [name], but ifindex.  that should be reflected in the names.

Also, I think we should implement some common ifindex<->devicename
mapping/resolval code.  This could be part of libnfnetlink (but be put
into a separate source code file).

IMHO, all required information can be accessed via nfnetlink.  I've once
written some code for caching the ifindex<->devicename in userspace (it
receives rtnetlink events of ifup/ifdown messages and keeps the cache in
sync).  I'll try to locate that code.

If you (or anyone else) is interested in cleanly integrating it into
libnfnetlink, please contact me and I'll give you that code.

It has to be common, since other nfnetlink users also need the same
information.  masq_index in the conntrack structure, e.g.=20

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--u+FGODhbLwgAeSOU
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC+9WsXaXGVTD0i/8RAp9PAJ0R+tfss9zuiIskij2HMeUOHgU7YgCggYkR
35kBdpVpP/jPkgHhSef+3RI=
=21Hi
-----END PGP SIGNATURE-----

--u+FGODhbLwgAeSOU--
