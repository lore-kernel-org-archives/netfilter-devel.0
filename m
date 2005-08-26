From: Harald Welte <laforge@netfilter.org>
Subject: Re: [NETFILTER 1/4]: Fix HW checksum handling in ip_queue/ip6_queue
Date: Fri, 26 Aug 2005 13:11:37 +0200
Message-ID: <20050826111137.GS4226@rama.de.gnumonks.org>
References: <4309166D.9010706@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TMgB3/Ch1aWgZB1L"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <4309166D.9010706@trash.net>
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


--TMgB3/Ch1aWgZB1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 22, 2005 at 02:03:57AM +0200, Patrick McHardy wrote:

> [NETFILTER]: Fix HW checksum handling in ip_queue/ip6_queue
>=20
> The checksum needs to be filled in on output, after mangling a packet
> ip_summed needs to be reset.

I think we're going to need the same fix for nfnetlink_queue, too.  I'm
not sure whether I could just copy+paste your code into the respective
section of the code, or whether there are some other issues that need to
be thought of, like "Is skb->ip_summed valid for non-ip-packets?".

Please advise or propose a patch, thanks!

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--TMgB3/Ch1aWgZB1L
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDDvjpXaXGVTD0i/8RAk44AJoD0eLv46GsAMUqPAZYRZuId8J0/wCeJ3IK
2OGXXGsHVEpc51tKMQkwQs0=
=71Cj
-----END PGP SIGNATURE-----

--TMgB3/Ch1aWgZB1L--
