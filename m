From: Harald Welte <laforge@gnumonks.org>
Subject: Re: netfilter FAQ: correction to answer about UNREPLIED connections
Date: Wed, 8 Oct 2003 11:30:41 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031008093041.GK25743@sunbeam.de.gnumonks.org>
References: <87ekyam77o.fsf@orcus.priv.at>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hk6Zb6cduJ+I0Tmj"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Robert Bihlmeyer <robbe@orcus.priv.at>
Content-Disposition: inline
In-Reply-To: <87ekyam77o.fsf@orcus.priv.at>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--hk6Zb6cduJ+I0Tmj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 21, 2003 at 06:34:03PM +0200, Robert Bihlmeyer wrote:
> Hi,

sorry for the late reply.  I'm cc'ing netfilter-devel, since this might
be of interest to other people.

> the FAQ states
>=20
> > The answer is easy: UNREPLIED entries are temporary entries, i.e. as
> > soon as we run out of connection tracking entries (we reach
> > /proc/sys/net/ipv4/ip_conntrack_max), we delete old UNREPLIED
> > entries.
>=20
> As I read the source (linux 2.4.22), only entries without the ASSURED
> bit are dropped early. I have a number of connections in my table that
> are ESTABLISHED, UNREPLIED and ASSURED at the same time (I'm using the
> tcp-window-tracking patch, FWIW).

There is a bit of confusion what ESTABLISHED means.  There are two
ESTABLISHED. =20

a) TCP state (printed in /proc/net/ip_conntrack)

b) connection state (as used with the -m state --state match)

here it means that the state of the connection is ESTABLISHED.  An
ESTABLISHED connection must have had a NEW packet before - and it can
never be ESTABLISHED without having seen at least one reply packet.=20

ASSURED is a bit set by the UDP and TCP helpers only.  For TCP it means
that we have seen a valid ACK in ESTABLISHED conntrack state, after SYN_RECV
tcp state.  For UDP it means that we've seen a matchin reply packet
(inverted tuple).  The general meaning is 'we are sure there is a
connection from all we can tel'.

UNREPLIED means we have only seen packets in one direction.  So the
following combination in /proc/ip_conntrack is certainly invalid:

[UNREPLIED] [ASSURED]

How could we be sure about a connection, if we have not seen a reply
packet before?

> Either I'm experiencing a bug, and UNREPLIED connections should never
> get ASSURED, or the FAQ is wrong. Even in the former case ASSURED
> could get mentioned as the real criteria.

yes, indeed.  Thanks for the correction.

> Robbe

--=20
- Harald Welte <laforge@gnumonks.org>               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
Programming is like sex: One mistake and you have to support it your lifeti=
me

--hk6Zb6cduJ+I0Tmj
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/g9lBXaXGVTD0i/8RAsq8AJ9N2CDQD3YoCY3Ly2Gr+HStB9R5yQCaAiQj
SF1Yd6ZwP5cm/jElC0d5xOw=
=6+Dp
-----END PGP SIGNATURE-----

--hk6Zb6cduJ+I0Tmj--
