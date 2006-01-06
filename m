From: Harald Welte <laforge@netfilter.org>
Subject: Re: [RFC][PATCH] ctnetlink port to nf_conntrack take #3
Date: Fri, 6 Jan 2006 15:36:08 +0100
Message-ID: <20060106143608.GC4898@sunbeam.de.gnumonks.org>
References: <200512150224.jBF2O4Qf011205@toshiba.co.jp>
	<43A0D5C2.40000@trash.net> <43A1C126.9020606@eurodev.net>
	<200512181133.jBIBXYPo012043@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+sXEj1HC0AeGgRD2"
Cc: netfilter-devel@lists.netfilter.org, pablo@eurodev.net, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200512181133.jBIBXYPo012043@toshiba.co.jp>
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


--+sXEj1HC0AeGgRD2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Sorry everyone, slowly catching up with my mail backlog

On Sun, Dec 18, 2005 at 08:33:33PM +0900, Yasuyuki KOZAKAI wrote:

> > What about the patch attached? It applies on top of my previous global
> > ctnetlink port to nf_conntrack take#4 patch.
>=20
> looks fine to me. And that's good idea to dump informations of all connec=
tions
> if AF_UNSPEC is set in nfgenmsg. But I don't know that such way to handle
> AF_UNSPEC can be generic policy of nfnetlink.

It is a nice use, but it would clash with our current definition of
NF_ARP - in case we ever implement something via nfnetlink for the ARP
protocol.

NF_ARP is defined to 0 in netfilter_arp.h, as a kludge around the
problem of ARP not having an AF_ARP constant.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--+sXEj1HC0AeGgRD2
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDvoBYXaXGVTD0i/8RApCSAJ9Qq5fQBg8vfMhcwT1HaPRS2KHHVwCgmmcm
spisR2HfcHsdxCTkAL+nRTM=
=6UBO
-----END PGP SIGNATURE-----

--+sXEj1HC0AeGgRD2--
