From: Bart De Schuymer <bart.de.schuymer@pandora.be>
Subject: [PATCH][RFC] ipt_REJECT.c - nf_bridge source and
Date: Sat, 2 Nov 2002 20:32:45 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200211022032.46007.bart.de.schuymer@pandora.be>
References: <20021102153451.N8635@sunbeam.de.gnumonks.org> <200211021530.EREjZ0McAA@gate.tbc.sub.de> <20021102185730.S8635@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20021102185730.S8635@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,

A discussion on the Linux bridge mailing list showed the following proble=
ms:
1. send_reset() does a skb_copy() and doesn't yet initialize the nf_bridg=
e
skbuff field.
2. send_unreach() seems to copy the wrong source IP address in the ICMP
message. Namely, it seems to always use an IP address of the router as
source IP address. Is that a bug?

The following patch solves both problems.
If the second issue is a bug then the 2.4 kernel needs a fix too.

cheers,
Bart

--- linux-2.5.45/net/ipv4/netfilter/ipt_REJECT.c=09Thu Oct 31 01:43:38 20=
02
+++ linux-2.5.45-new/net/ipv4/netfilter/ipt_REJECT.c=09Sat Nov  2 18:58:4=
4 2002
@@ -76,6 +76,10 @@
 =09nskb->nf_debug =3D 0;
 #endif
 =09nskb->nfmark =3D 0;
+#if defined(CONFIG_BRIDGE) || defined(CONFIG_BRIDGE_MODULE)
+=09nf_bridge_put(nskb->nf_bridge);
+=09nskb->nf_bridge =3D NULL;
+#endif
=20
 =09tcph =3D (struct tcphdr *)((u_int32_t*)nskb->nh.iph + nskb->nh.iph->i=
hl);
=20
@@ -222,6 +226,9 @@
 =09=09if (ip_route_output_key(&rt, &fl))
 =09=09=09return;
 =09}
+
+=09saddr =3D iph->daddr;
+
 =09/* RFC says return as much as we can without exceeding 576 bytes. */
 =09length =3D skb_in->len + sizeof(struct iphdr) + sizeof(struct icmphdr=
);
=20
@@ -256,7 +263,7 @@
 =09iph->ttl =3D MAXTTL;
 =09ip_select_ident(iph, &rt->u.dst, NULL);
 =09iph->protocol=3DIPPROTO_ICMP;
-=09iph->saddr=3Drt->rt_src;
+=09iph->saddr=3Dsaddr;
 =09iph->daddr=3Drt->rt_dst;
 =09iph->check=3D0;
 =09iph->check =3D ip_fast_csum((unsigned char *)iph, iph->ihl);
