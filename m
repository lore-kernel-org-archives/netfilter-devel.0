From: Cedric de Launois <delaunois@info.ucl.ac.be>
Subject: [PATCH] ROUTE target : IP csum recalculation fix at INPUT chain
Date: Mon, 10 May 2004 17:26:45 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1084202805.2743.55.camel@descartes.info.ucl.ac.be>
References: <5340B444BE2BD411A89C009027F6917B4FDDE6@BSSERVER>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-Id7ls8xuXgiAf4c1RONq"
Cc: Rickard Molin <rickard.molin@businessecurity.com>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <5340B444BE2BD411A89C009027F6917B4FDDE6@BSSERVER>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-Id7ls8xuXgiAf4c1RONq
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by info.ucl.ac.be id i4AFQ9ba016605

Le lun 19/04/2004 =E0 14:42, Rickard Molin a =E9crit :
> If ROUTE is used on the INPUT chain with the --oif option the ttl needs=
 to
> be decreased and the checksum recalculated. This is currently done with
> ip_decrease_ttl which also fixes the checksum assuming that nothing els=
e has
> changed in the IP header. If the packet was defragmented before the
> netfilter hook the length has changed and ip_decrease_ttl produces an
> incorrect checksum.
>=20
> Therefore i propose that ip_fast_csum should be used when on INPUT chai=
n
> instead.

Ok. Thanks and sorry for the delay !

Here is the (re-diffed) patch from Rickard that fix this bug.

Please apply,

Cedric


--=-Id7ls8xuXgiAf4c1RONq
Content-Disposition: attachment; filename=ipt_ROUTE-csum-fix.patch
Content-Type: text/x-patch; name=ipt_ROUTE-csum-fix.patch; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

--- patch-o-matic-ng/ROUTE/linux/net/ipv4/netfilter/ipt_ROUTE.c.orig	2004-05-05 18:57:43.000000000 +0200
+++ patch-o-matic-ng/ROUTE/linux/net/ipv4/netfilter/ipt_ROUTE.c	2004-05-10 17:15:21.000000000 +0200
@@ -277,7 +277,18 @@
 			return NF_DROP;
 		}
 
-		ip_decrease_ttl(iph);
+		/*
+		 * If we are at INPUT the checksum must be recalculated since
+		 * the length could change as the result of a defragmentation.
+		 * -- Rickard Molin
+		 */
+		if(hooknum == NF_IP_LOCAL_IN) {
+			iph->ttl = iph->ttl - 1;
+			iph->check = 0;
+			iph->check = ip_fast_csum((unsigned char *)iph, iph->ihl);
+		} else {
+			ip_decrease_ttl(iph);
+		}
 	}
 
 	/* Tell conntrack to forget this packet since it may get confused 

--=-Id7ls8xuXgiAf4c1RONq--
