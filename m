From: Harald Welte <laforge@gnumonks.org>
Subject: Re: real time stateful filtering question
Date: Wed, 17 Mar 2004 14:58:25 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040317135825.GA21899@sunbeam.de.gnumonks.org>
References: <NEBBJFIAIKIHKGJDONCDAEMMCCAA.smith-peter@comcast.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k1lZvvs/B4yU6o8G"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: peter smith <smith-peter@comcast.net>
Content-Disposition: inline
In-Reply-To: <NEBBJFIAIKIHKGJDONCDAEMMCCAA.smith-peter@comcast.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 15, 2004 at 10:54:00AM -0500, peter smith wrote:
> If I wish to monitor using netfilter a link that has applications talking=
 on
> it that use ephemeral ports (like, for instance, FTP or H323), is there a
> way to install filters fast enough /syncronously enough to guarantee that
> you won't miss packets that you have already received? For instance, say
> that you have some number of packets in your rx ring buffer waiting to be
> processed. The first one is processed, and matches some filter you have s=
et.
> That packet is queued for delivery to userland.
>=20
> That packet also has a FTP PORT command inside it's payload that specifies
> the new data channel that the two hosts will use to transfer data. (where
> channel =3D=3D the src/dst ip and src/dst ports)
>=20
> Unfortunately, packets sent on the data channel are also in your receive
> buffer, and get processed by netfilter *before* the "PORT COMMAND" packet
> gets processed by the userland monitor, or before the monitor can
> sucessfully re-program the netfilter filter list. So they are dropped,
> silently.

the backlog queue ('receive buffer') is always processed in-order.  so
it is a violation of protocol if an ftp data packet would arrive before
the control connection would show PORT/PASV.

Imagine this being the FTP client/server.  It would return a  TCP RST to
the data packet, since it wouldn't have bound a socket to the respective
address yet (or whatever).

[yes, ftp sucks as an example because this could never happen, but
settinh this aside]

> Thanks,
> Peter

--=20
- Harald Welte <laforge@gnumonks.org>               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
Programming is like sex: One mistake and you have to support it your lifeti=
me

--k1lZvvs/B4yU6o8G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAWFmBXaXGVTD0i/8RAh70AJ9WLuWPdGF0Sw6SGtE/Ez97ZSU44wCfUT/I
2MiZNX0jMbPgJ98PritbPKY=
=9nCf
-----END PGP SIGNATURE-----

--k1lZvvs/B4yU6o8G--
