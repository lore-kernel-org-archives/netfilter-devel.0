From: Harald Welte <laforge@netfilter.org>
Subject: Re: Jitter phenomenon in the netfilter infrastructure
Date: Thu, 16 Oct 2003 14:30:29 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031016123029.GU14807@obroa-skai.de.gnumonks.org>
References: <3F8E4BFD.1050103@yahoo.it>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="D2rVImvqWGvKULsk"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Mike-Ro-Chanel <mikerochanel@yahoo.it>
Content-Disposition: inline
In-Reply-To: <3F8E4BFD.1050103@yahoo.it>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--D2rVImvqWGvKULsk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 16, 2003 at 09:42:53AM +0200, Mike-Ro-Chanel wrote:
> Hi All,
> Inspired by ipt_limit module I've written a token bucket module as a=20
> iptables module extension.
>=20
> I've observed a strange behaviour:
> In the linux kernel 2.4.21 input ethernet frames are sent to the IPv4=20
> layer by "process_backlog()" function, this one pass to ip_rcv()=20
> hundreds of SKB elements in a single burst, its execution is limited (in=
=20
> time) by 1 jiffy.
> As result a regular IPv4 input traffic is looked by PREROUTING hook as=20
> an irregular flow of packets.

yes, but you have an skb receive timestamp, which tells you the exact
jiffies at which the skb came in from the wire.

> Thanks
> 	Mike-Ro-Chanel

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--D2rVImvqWGvKULsk
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/jo9lXaXGVTD0i/8RAirhAJ9s2hbPNXxY67ccEeI1BNYiWvxPzwCfaiCU
UTceok0b6XcogcUoeeGfok0=
=ctwL
-----END PGP SIGNATURE-----

--D2rVImvqWGvKULsk--
