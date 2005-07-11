From: Harald Welte <laforge@netfilter.org>
Subject: Re: ctnetlink attributes [was: Re: [PATCH 1/2] updates for
	[nf|ct]netlink and event API]
Date: Mon, 11 Jul 2005 19:10:23 +0200
Message-ID: <20050711171023.GG16728@sunbeam.de.gnumonks.org>
References: <42C03F2E.30706@eurodev.net> <42C0806E.3010400@trash.net>
	<20050628071308.GE13239@sunbeam.de.gnumonks.org>
	<42C1747A.3010703@trash.net> <42C2F2DF.7070301@eurodev.net>
	<42C2FC14.80609@trash.net> <42C33E33.7090908@eurodev.net>
	<42C34445.9020709@trash.net> <42C426B2.6030907@eurodev.net>
	<42D29EC0.9050707@ufomechanic.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GwwLvQJ0l3HSwfoE"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
Content-Disposition: inline
In-Reply-To: <42D29EC0.9050707@ufomechanic.net>
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


--GwwLvQJ0l3HSwfoE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 11, 2005 at 05:30:56PM +0100, Amin Azez wrote:
> I'm interested in adding MAC addr attributes and CTA_TUPLE_MAC; not just
> because of my fixation with MAC addresses but also to use conntrack to
> record flow data for non IP-related protocols.

ctnetlink MAC attributes are IMHO nonsense because there is no mac
address tracking in conntrack.
=20
> I realise it is not the current intent of conntrack to do this, but as
> much as conntrack solves the high-load problems of ulog, it is desirable
> for it to keep counters for non-ip protocols.

Also, MAC address tracking doesn't really make sense since as an
intermediate router there is no way that the assumption "source and
destination mac never change" is ever valid.

> As fast as protocol handlers can be devised it will become "conntrack"
> again instead of "flowtrack", but the universal identifier between hosts
> involved in a connection is the mac address and protocol.=20

no.  you always only see the next hop mac address.  let's say you have
an upsteram and a downstream router, then all your 'connections' would
be between the same two mac addresses.

> The question is, how do others feel about conntrack tracking non-ip
> connections? I intend to provide patches to do this if it is welcome.

nf_conntrack goes the way to layer-3-independent connection tracking.
However, conntrack will remain to happen at layer3 and 4 (with minor
exceptions to higher layers in the case of conntrack helpers).

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--GwwLvQJ0l3HSwfoE
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC0qf/XaXGVTD0i/8RAuAlAJ4upGX211KNJh6BByvv9MZ1lbqERACglBMS
uHvXKnrtF04R5jkAYcuiP5Y=
=ot4B
-----END PGP SIGNATURE-----

--GwwLvQJ0l3HSwfoE--
