From: Harald Welte <laforge@netfilter.org>
Subject: Re: TTL patch buggy?
Date: Wed, 7 Jan 2004 20:35:47 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040107193547.GF6629@obroa-skai.de.gnumonks.org>
References: <Pine.LNX.4.44.0401071709030.4717-100000@filer.marasystems.com> <1073502275.16972.10.camel@jasiiitosh.nexusmgmt.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qftxBdZWiueWNAVY"
Cc: Henrik Nordstrom <hno@marasystems.com>, netfilter@lists.netfilter.org,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "John A. Sullivan III" <john.sullivan@nexusmgmt.com>
Content-Disposition: inline
In-Reply-To: <1073502275.16972.10.camel@jasiiitosh.nexusmgmt.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--qftxBdZWiueWNAVY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 07, 2004 at 02:04:36PM -0500, John A. Sullivan III wrote:
> Thank you very much but could you please explain this a bit more.  Oskar
> Andreasson's tutorial explicitly mentions doing this, i.e., incrementing
> TTL and we thought it was a good idea.  We certainly want to change our
> ways if this is dangerous.  Here is the excerpt from the tutorial:

Well, as indicated in my last emai:

1) it is dangerous to increment the TTL
2) still, there are vallid uses.

In gerneral, incrementing packets heading towards your internal network
shouldn't be a problem.  If people want to hide their internal network
structure from traceroute, they have two options:

a) drop all packets that have a ttl < number_of_hops_in_internal_net
b) increment the TTL by number_of_hops_in_internal_net

Both ways make sure that the TTL never expires on a router in the
internal network.

Where 'a' would interrupt traffic, and 'b' would make sure traffic
passes.

Also, sometimes ISP's try to detect if you are running a router/gateway
behind your DSL line by checking for well-known TTL values.  In this
case, setting the TTL=20

The most dangerous cases of incrementing the TTL are:

a) incrementing the TTL of transit traffic (not close to sender or
receiver)
b) incrementing the TTL of multicast traffic
> John A. Sullivan III

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--qftxBdZWiueWNAVY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE//F+SXaXGVTD0i/8RAoUOAJ0Qo84JquplWo5CxYj+Ti+0bWPbswCfdj4o
GDBaBUaG21QND4eI28axJPQ=
=c1gr
-----END PGP SIGNATURE-----

--qftxBdZWiueWNAVY--
