From: Harald Welte <laforge@netfilter.org>
Subject: Re: [RFC]correction - cloned skbs - if i am right there is a bug in ipt_ECN.c
Date: Sat, 13 Dec 2003 09:58:05 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031213085805.GG8950@obroa-skai.de.gnumonks.org>
References: <002701c3c0ea$e26efa70$0e25fe0a@southpark.ae.poznan.pl> <003001c3c0eb$ede8cb50$0e25fe0a@southpark.ae.poznan.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Wtrm9ATX0sn6fFKv"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Content-Disposition: inline
In-Reply-To: <003001c3c0eb$ede8cb50$0e25fe0a@southpark.ae.poznan.pl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Wtrm9ATX0sn6fFKv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 12, 2003 at 09:10:00PM +0100, Maciej Soltysiak wrote:
> > But iph is not used, we are using tcph later on in the code, so we shou=
ld:
> >                 tcph =3D (*pskb)->nh.tcph;
> Of course I meant:
>                 tcph =3D (*pskb)->h.th;

I'll put the following patch in CVS and submit it for kernel inclusion:

--- linux/net/ipv4/netfilter/ipt_ECN.c	2003-12-13 09:54:14.000000000 +0100
+++ linux-new/net/ipv4/netfilter/ipt_ECN.c	2003-12-13 09:56:35.000000000 +0=
100
@@ -4,7 +4,7 @@
  *=20
  * This software is distributed under GNU GPL v2, 1991
  *=20
- * ipt_ECN.c,v 1.4 2002/08/05 19:36:51 laforge Exp
+ * ipt_ECN.c,v 1.5 2003/12/13 19:36:51 laforge Exp
 */
=20
 #include <linux/module.h>
@@ -59,8 +59,8 @@
 	    const struct ipt_ECN_info *einfo)
 {
=20
-	struct tcphdr *tcph =3D (void *) iph + iph->ihl * 4;
-	u_int16_t *tcpflags =3D (u_int16_t *)tcph + 6;
+	struct tcphdr *tcph;
+	u_int16_t *tcpflags;
 	u_int16_t diffs[2];
=20
 	/* raw socket (tcpdump) may have clone of incoming
@@ -71,9 +71,12 @@
 			return NF_DROP;
 		kfree_skb(*pskb);
 		*pskb =3D nskb;
-		iph =3D (*pskb)->nh.iph;
 	}
=20
+	iph =3D (*pskb)->nh.iph;
+	tcph =3D (void *) iph + iph->ihl * 4;
+	tcpflags =3D (u_int16_t *)tcph + 6;
+
 	diffs[0] =3D *tcpflags;
=20
 	if (einfo->operation & IPT_ECN_OP_SET_ECE

> Regards,
> Maciej
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Wtrm9ATX0sn6fFKv
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/2tScXaXGVTD0i/8RAng5AJ90D0U2NzZAyFyBb/9jq3DVIfzAIgCgpofA
NmU1v1dnAgWA2XGau1Uzn+g=
=EgDU
-----END PGP SIGNATURE-----

--Wtrm9ATX0sn6fFKv--
