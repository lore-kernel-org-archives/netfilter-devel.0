From: Harald Welte <laforge@netfilter.org>
Subject: Re: Clusterip: What about Cluster-side ARP-requests
Date: Wed, 22 Jun 2005 13:54:36 +0200
Message-ID: <20050622115436.GC4551@obroa-skai.de.gnumonks.org>
References: <31236.1119294959@www15.gmx.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IMjqdzrDRly81ofr"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Alex <alex_oz@gmx.net>
Content-Disposition: inline
In-Reply-To: <31236.1119294959@www15.gmx.net>
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


--IMjqdzrDRly81ofr
Content-Type: multipart/mixed; boundary="oJ71EGRlYNjSvfq7"
Content-Disposition: inline


--oJ71EGRlYNjSvfq7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 20, 2005 at 09:15:59PM +0200, Alex wrote:
> Hi folks,
>=20
> as far as I can see from the CLUSTERIP source all ARP-Responses are
> manipulated so that the clients have a multicast MAC - ClusterIP mapping =
in
> their ARP-caches. But what about ARP-requests from the nodes itself? Such=
 a
> request is not mangled by the module and thus contains the original
> non-cluster-MAC.

yes, you're totally correct.  Seems like I forgot about the fact that
arp caches learn from both (requests and replies) while writing that
particular piece of code.

> Do I have any missconception?

no.  It just seems like nobody really ran the code since it was merged
mainline - or at least in no setup that would cause outbound arp
requests on the cluster ip address.

Please try the attached patch:

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--oJ71EGRlYNjSvfq7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=f
Content-Transfer-Encoding: quoted-printable

Index: linux-2.6/net/ipv4/netfilter/ipt_CLUSTERIP.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6/net/ipv4/netfilter/ipt_CLUSTERIP.c	(revision 3983)
+++ linux-2.6/net/ipv4/netfilter/ipt_CLUSTERIP.c	(working copy)
@@ -522,8 +523,9 @@
 	    || arp->ar_pln !=3D 4 || arp->ar_hln !=3D ETH_ALEN)
 		return NF_ACCEPT;
=20
-	/* we only want to mangle arp replies */
-	if (arp->ar_op !=3D htons(ARPOP_REPLY))
+	/* we only want to mangle arp requests and replies */
+	if (arp->ar_op !=3D htons(ARPOP_REPLY)
+	    && arp->ar_op !=3D htons(ARPOP_REQUEST))
 		return NF_ACCEPT;
=20
 	payload =3D (void *)(arp+1);


--oJ71EGRlYNjSvfq7--

--IMjqdzrDRly81ofr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFCuVF8XaXGVTD0i/8RAs2wAJ4pl/mb394SGPJgHkb79KBy8x6LfwCfaBtP
hqjW9jsfYdcYRtxOVED09QQ=
=FKcX
-----END PGP SIGNATURE-----

--IMjqdzrDRly81ofr--
