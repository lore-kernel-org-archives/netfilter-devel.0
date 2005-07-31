From: Harald Welte <laforge@netfilter.org>
Subject: Re: conntrack management
Date: Sun, 31 Jul 2005 12:59:13 +0200
Message-ID: <20050731105913.GJ14874@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oplxJGu+Ee5xywIT"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Osama Abu Elsorour <osama@wayout.net>
Content-Disposition: inline
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


--oplxJGu+Ee5xywIT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 31, 2005 at 11:41:34AM +0300, Osama Abu Elsorour wrote:

> I always wondered why there isn't a more comprehensive way of managing
> current conntrack entries, perhaps some sort of a user-space program that
> can list conntracks in a more readable way using simple filters or matchi=
ng
> criteria.
> This also leads to wondering why there isn't a way of forcefully destroyi=
ng
> specific conntracks without the need of resetting the modules, etc.=20

That's what ctnetlink (now called netlink_conntrack) is for.  It has
existed for a long time out-of-tree (in patch-o-matic[-ng) and is now
pending for inclusion into the 2.6.14 kernel series.

> I find it very important specially when deleting a NAT rule while
> existing connections are established.

That's a problem that the CONFIRMED patch tries to solve

> I was thinking of building a tool to do both. On the first front, it seems
> that it is quite doable=20

have you seeen the conntrack tool
(http://svn.netfilter.org/netfilter/trunk/conntrack) ? It is a
commandline application for the purpose you describe.

>(I am even thinking of making a kind of meta-tag
> scheme, like string name-value pairs that can be attached to conntracks to
> help ease up matching them for listing and/or deletion). The second front=
, I
> am sure there is a good reason why it has not been done so far, I am just
> not quite sure what it is.

as long as you keep your tags/strings to userspace, you can do whatever
you want ;)

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--oplxJGu+Ee5xywIT
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC7K8BXaXGVTD0i/8RAqUDAKCpqj4cXLqPY8i5TlTU/Avz9hduQACfWGIG
MSZOw8hb6DsbCYOFhgAZgNI=
=a4re
-----END PGP SIGNATURE-----

--oplxJGu+Ee5xywIT--
