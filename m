From: Harald Welte <laforge@netfilter.org>
Subject: Re: memory leak related to bridging, conntrack and frags in 2.6.0
Date: Sat, 13 Dec 2003 07:47:29 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031213064729.GC8950@obroa-skai.de.gnumonks.org>
References: <20031212155543.GD14920@sunbeam.de.gnumonks.org> <Pine.LNX.4.44.0312121606000.8670-100000@sorbus2.navaho>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E/DnYTRukya0zdZ1"
Cc: Andy Loukes <andy@navaho.co.uk>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Steve Hill <steve@navaho.co.uk>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0312121606000.8670-100000@sorbus2.navaho>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--E/DnYTRukya0zdZ1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 12, 2003 at 04:11:38PM +0000, Steve Hill wrote:
> On Fri, 12 Dec 2003, Harald Welte wrote:
>=20
> > are you sure it's a memory leak?  Please explain why.  Which number in
> > /proc/slabinfo are you looking at?  And did you confirm that this is not
> > just some cache that expires after some time?
>=20
> I am looking into this too - size-64 is increasing (and keeps increasing=
=20
> until the box dies after it's filled all 128MB of RAM).
>=20
> The memory that is leaking seems to be allocated on line 299 on=20
> net/bridge/br_netfilter.c:
>  =20
>         if ((nf_bridge =3D nf_bridge_alloc(skb)) =3D=3D NULL)
>                 return NF_DROP;
>  =20
> Only the first fragment gets freed later on, all the other fragments seem=
=20
> to get leaked during defragmentation.  (I'm not an expert on netfilter,=
=20
> but I presume that the defrag routines defragment the packet and puts it=
=20
> in the first skb, leaving the skbs for the other packets needing to be=20
> freed?)

now that sounds interesting.  Please make sure you contact the linux
bridging maintainer (Bart De Schuymer) or the respective linux bridging
mailinglist about your findings.

Maybe something screws up the reference counting to the skb->nf_bridge
attached structure.

> - Steve Hill

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--E/DnYTRukya0zdZ1
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/2rYBXaXGVTD0i/8RAsNcAJ90HnvQdQ2lunDrZYVT+17qg1LXSwCdELM1
6xHrh+Jw8H6GRbkLxZ5iFO4=
=/Pgm
-----END PGP SIGNATURE-----

--E/DnYTRukya0zdZ1--
