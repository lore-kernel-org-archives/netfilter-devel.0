From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Fixed some memoryleaks in ip(6)tables.c
Date: Tue, 18 May 2004 20:23:55 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1084904635.969.10.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-l5QdTcEC07GsM5Z5ZT2f"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-l5QdTcEC07GsM5Z5ZT2f
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi

I just committed a fix for 7 memoryleaks in iptables.c (ip6tables.c got
the same treatment).

As always when messing with things that interact with libiptc you need
to give people a heads up... this is it.

If it breaks you know who to blame :)

I converted an application from direct libiptc fiddling to use
do_command() from iptables.c instead (why use the horrible lowlevel
interface of libiptc when you don't have to?) and found some
memoryleaks. These changes has been running in a small testprogram under
valgrind and seems to work fine.

People with large iptables-restore "sessions" might notice a decrease in
memory-usage.

--=20
/Martin

--=-l5QdTcEC07GsM5Z5ZT2f
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBAqlS6Wm2vlfa207ERAoZ0AJwM3Wj0Yd07f8WjUHvPWkjbq6icrACfVMP2
Gxsuh7azm+pcWQVpVC0I6YI=
=Hipf
-----END PGP SIGNATURE-----

--=-l5QdTcEC07GsM5Z5ZT2f--
