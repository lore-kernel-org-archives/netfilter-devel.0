From: Harald Welte <laforge@netfilter.org>
Subject: Re: can netfilter capture internal network packet?
Date: Wed, 11 Jun 2003 14:04:39 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030611120439.GJ32593@sunbeam.de.gnumonks.org>
References: <001101c32cd0$14bdf940$010aa8c0@toowoomba>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JkW1gnuWHDypiMFO"
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: calvin <calvinproject@ihug.com.au>
Content-Disposition: inline
In-Reply-To: <001101c32cd0$14bdf940$010aa8c0@toowoomba>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--JkW1gnuWHDypiMFO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 07, 2003 at 06:37:50PM +1000, calvin wrote:
> Dear all,
>=20
> I got a serious problem with my netfilter programe.
>=20
> what i am trying to do is capture a packet frmo A to B in the same network
> and direct it to QUEUE.
>=20
> My setup is
>=20
> A      B
>  \       /
>   \     /
>   HUB
>      | (eth0)
>    GW
>      |(eth1)
>      |
>      |
>=20
> is that possible to: when A send a message to B port 1700 (for example) ,
> the iptales in GW can grep the packet and put into queue for processing a=
nd
> put it back to the line?

no, of course not.  You seem to have a basic misunderstanding about
network topology.  A and B are on the same layer 2, they are never sent
through your gateway.  The GW is only involved when the packet needs to
be passed from one layer 2 segment to the other layer 2 segment.

> is that any way I can do what I want to do in module? in iptables?

No.  And this is not a limitation of iptables, it's a fundamental
principle of ethernet.

> Regards,
> Calvin

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--JkW1gnuWHDypiMFO
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+5xrXXaXGVTD0i/8RAr27AJ4qTjmwjQnQ5BFdipiEkme+qr8OsACfRjxh
CgKCtNiTx3RvCuYT34fVBLQ=
=RKUN
-----END PGP SIGNATURE-----

--JkW1gnuWHDypiMFO--
