From: "Brian J. Murrell" <netfilter@interlinx.bc.ca>
Subject: Re: separation of sysctl and tcp-window-tracking patch?
Date: 12 Dec 2002 09:14:47 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1039702486.2373.17.camel@pc>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-J1vNvCZvsqFteAohawGJ"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-J1vNvCZvsqFteAohawGJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2002-12-12 at 04:02, Jozsef Kadlecsik wrote:=20
> On Thu, 12 Dec 2002, James Ralston wrote:
>=20
> > (My specific need is related to DNS service: namely, in many cases, 30
> > seconds to establish a UDP session simply isn't enough time to permit
> > a reply to an outstanding DNS query.  I want to be able to up that
> > timeout to something closer to 60 or 120 seconds.)

I had this problem with the Amanda protocol, but it was with the UDP
streaming timeout.  It was not long enough to allow an Amanda client to
go do it's work and still respond to the server when it was done.

Fortunately (for this situation), the Amanda protocol requires a helper,
so I just upped the timeout on the connection in the helper.  But this
led me to think about UDP timeouts in general.

You might want to refer to this message:

http://lists.netfilter.org/pipermail/netfilter-devel/2002-September/009259.=
html

> Please note, that the timeout settings via /proc introduced in the
> tcp-window-tracking patch are global. You cannot raise the UDP timeout
> values just for DNS.

Indeed.  I had thought about this when I was doing my Amanda
modification for the UDP streaming timeout on it's connection.  For UDP
timeouts in general I had originally thought of doing this with
load-time module parameters.  Something along the lines of:

# insmod ip_conntrack.o udp_timeouts=3D"53=3D60,123=3D10"

which would be added to a table already defined in
ip_conntrack_proto_udp.c with a set of common defaults.

This could be done via proc too however.  Maybe something like:

# cat /proc/sys/net/ipv4/netfilter/udp_timeout
default=3D30
53=3D60
123=3D10

to see the current timeout table and

# echo "default=3D45,520=3D30" > /proc/sys/net/ipv4/netfilter/udp_timeout

to set/modify entries in the table.

Of course we have two udp timeouts to deal with, initial UDP connection
setup timeout and the UDP streaming timeout.  Perhaps two different
/proc nodes.

> Also, we have to handle the backward compatibility issue of
> /proc/sys/net/ipv4/ip_conntrack_max, if the introduction of
> /proc/sys/net/ipv4/netfilter/ is accepted.

Right.  But let's not let this be a lone issue holding-up on moving
forward with general netfilter tunables via proc.

b.



--=20

Brian J. Murrell <netfilter@interlinx.bc.ca>

--=-J1vNvCZvsqFteAohawGJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQA9+JnWl3EQlGLyuXARAnl9AJ9qrfXBm9MMwLeMKapDIWGgux8aogCbBDaz
pG+oNxZ36X4Yi3XIXBnSsiM=
=nWrw
-----END PGP SIGNATURE-----

--=-J1vNvCZvsqFteAohawGJ--
