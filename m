From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6] Fix ipt_REJECT if used on bridge
Date: Sat, 23 Aug 2003 22:46:12 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030823204612.GB5107@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7ZAtKRhVyVSsbBD2"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: David Miller <davem@redhat.com>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--7ZAtKRhVyVSsbBD2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

The patch below (courtesy of Bart de Schuymer) fixes an issue
(skb->nf_bridge not initialized after skb_copy) with briging in the case
of ipt_REJECT is used on a filtering bridge.

Please apply, thanks!


--- linux-2.5.45/net/ipv4/netfilter/ipt_REJECT.c	Thu Oct 31 01:43:38 2002
+++ linux-2.5.45-new/net/ipv4/netfilter/ipt_REJECT.c	Sat Nov  2 18:58:44 20=
02
@@ -76,6 +76,10 @@
 	nskb->nf_debug =3D 0;
 #endif
 	nskb->nfmark =3D 0;
+#if defined(CONFIG_BRIDGE) || defined(CONFIG_BRIDGE_MODULE)
+	nf_bridge_put(nskb->nf_bridge);
+	nskb->nf_bridge =3D NULL;
+#endif
=20
 	tcph =3D (struct tcphdr *)((u_int32_t*)nskb->nh.iph + nskb->nh.iph->ihl);
=20
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--7ZAtKRhVyVSsbBD2
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/R9KUXaXGVTD0i/8RAmuHAJ44Y5Kr5nGsOv/1azk/qKt1U7yO4ACfVF45
utyhOJh2x0/Mtm8bLPe1TB8=
=IaED
-----END PGP SIGNATURE-----

--7ZAtKRhVyVSsbBD2--
