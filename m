From: Harald Welte <laforge@netfilter.org>
Subject: Re: mangle MSS via tcp_manip_pkt() in ip_nat_proto_tcp.c [patch]
Date: Fri, 25 Jul 2003 22:50:21 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030725205020.GZ3244@sunbeam.de.gnumonks.org>
References: <BE229ADC976AC343830DFF9BC159FAEB011E46AA@KUEXCHANGE.kvhinternal.kvhi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3fquP/57BBR2yLsK"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Michael Glaum <mglaum@kvh.com>
Content-Disposition: inline
In-Reply-To: <BE229ADC976AC343830DFF9BC159FAEB011E46AA@KUEXCHANGE.kvhinternal.kvhi>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--3fquP/57BBR2yLsK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 18, 2003 at 10:57:05AM -0400, Michael Glaum wrote:

> I tried several things, e.g. pathMTU, etc but in view of severe time
> constraints I decided to HACK tcp_manip_pkt() in ip_nat_proto_tcp.c
> so that when it does source and destination address translation it also
> drops the MSS on outgoing and incoming packets to be below 1360. This
> appears to work. I didn't even bother to check if the packets had
> tcphdr->syn =3D=3D1 set.
>=20
> Please advise if there is a more elegant way to do this!

Use the TCPMSS target  (iptables -j TCPMSS -h).

> 								Michael Glaum
> 								KVH Industries

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--3fquP/57BBR2yLsK
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/IZgMXaXGVTD0i/8RAsuoAJ4qi8BTc/DjL92b9+h5BMikbYZ8awCgnqJg
PdRCEmKGf+ja36X+vXUA4kg=
=MX/F
-----END PGP SIGNATURE-----

--3fquP/57BBR2yLsK--
