From: Harald Welte <laforge@netfilter.org>
Subject: Re: Preliminary NetBIOS datagram NAT filter
Date: Tue, 1 Mar 2005 11:02:34 +0100
Message-ID: <20050301100234.GL6825@sunbeam.de.gnumonks.org>
References: <ea59786f050223203860806aa2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R6sEYoIZpp9JErk7"
Cc: netfilter-devel@lists.netfilter.org
To: Constantine Sapuntzakis <csapuntz@gmail.com>
Content-Disposition: inline
In-Reply-To: <ea59786f050223203860806aa2@mail.gmail.com>
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


--R6sEYoIZpp9JErk7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 23, 2005 at 08:38:43PM -0800, Constantine Sapuntzakis wrote:
> http://suif.stanford.edu/~csapuntz/ip_nat_netbios.c
>=20
> Using this, I was able to join a Windows NT domain and login into the
> domain from behind a NAT.
>=20
> I had a hard time understanding all the parameters to the various
> methods, so I probably got it wrong for anything except for source NAT
> (which I tested). I'd appreciate any help from more experienced
> developers.
>=20
> Here's the problem with NetBIOS. NetBIOS datagrams contain the source
> IP address and
> source port as bytes 4-9 of the UDP payload. These need to be
> rewritten while traversing a NAT.

so how do you determine that what you are modyfying is really a netbios
packet?  just using the port number is too little.  maybe you can do
some plausibility checks on the whole packet, and also verify that bytes
4-9 are the same as the ip (source?) address in the packet.

> - the HOWTO seems to indicate you want to override
> hlpr->tuple.dst.u.udp.port but all the examples override
> hlpr->tuple.src.u.udp.port  to filter all traffic to a port. Which is
> right?

src.

> - will this NAT helper work with two computers with different IP
> addresses behind a NAT? i.e. if both computers send packets with
> source port 138 and destination port 138, will it correctly move the
> source port number of one of the packets. Or do I have to call some
> extra functions.

i'm not really sure how the netbios protocol works. therefore I cannot
really comment on what you're doing and whether it's the right thing to
do.  normally, you implement a conntrack helper before writing a nat
helper.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--R6sEYoIZpp9JErk7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFCJD26XaXGVTD0i/8RAs/hAJ9lFMLPl5HfDUOFJLNGrEQhGwNtPACfU5Dq
N4h1AM1G8wk2YNyxARPoaFY=
=ZTpS
-----END PGP SIGNATURE-----

--R6sEYoIZpp9JErk7--
