From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH] 2.4.x ipt_REJECT bugfix for TCP RST packets + asymm. routing
Date: Sun, 30 Mar 2003 21:44:02 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030330194402.GU7718@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0M7E0x35R+W+EAky"
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


--0M7E0x35R+W+EAky
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Davem!

This fixes a bug (oops) in the generation of TCP RST packets in the
ipt_REJECT target in the case of asymmetric routing, where the hardware
header length of the outgoing interface is bigger than the hardware
header length of the incoming interface.

Please apply to 2.4.x (2.5.x will follow), thanks.


diff -Nru --exclude .depend --exclude *.o --exclude *.ver --exclude .*.flag=
s --exclude *.orig --exclude *.rej --exclude *~ linux-2.4.20-plain/net/ipv4=
/netfilter/ipt_REJECT.c linux-2.4.20-reject/net/ipv4/netfilter/ipt_REJECT.c
--- linux-2.4.20-plain/net/ipv4/netfilter/ipt_REJECT.c	Fri Nov 29 00:53:15 =
2002
+++ linux-2.4.20-reject/net/ipv4/netfilter/ipt_REJECT.c	Wed Mar  5 08:50:28=
 2003
@@ -42,6 +42,7 @@
 	u_int16_t tmp_port;
 	u_int32_t tmp_addr;
 	int needs_ack;
+	int hh_len;
=20
 	/* IP header checks: fragment, too short. */
 	if (oldskb->nh.iph->frag_off & htons(IP_OFFSET)
@@ -61,13 +62,28 @@
 			 csum_partial((char *)otcph, otcplen, 0)) !=3D 0)
 		return;
=20
+	/* Routing: if not headed for us, route won't like source */
+	if (ip_route_output(&rt, oldskb->nh.iph->daddr,
+			    local ? oldskb->nh.iph->saddr : 0,
+			    RT_TOS(oldskb->nh.iph->tos) | RTO_CONN,
+			    0) !=3D 0)
+		return;
+
+	hh_len =3D (rt->u.dst.dev->hard_header_len + 15)&~15;
+
+
 	/* Copy skb (even if skb is about to be dropped, we can't just
            clone it because there may be other things, such as tcpdump,
-           interested in it) */
-	nskb =3D skb_copy(oldskb, GFP_ATOMIC);
+           interested in it). We also need to expand headroom in case
+	   hh_len of incoming interface < hh_len of outgoing interface */
+	nskb =3D skb_copy_expand(oldskb, hh_len, skb_tailroom(oldskb),
+			       GFP_ATOMIC);
 	if (!nskb)
 		return;
=20
+	dst_release(nskb->dst);
+	nskb->dst =3D &rt->u.dst;
+
 	/* This packet will not be the same as the other: clear nf fields */
 	nf_conntrack_put(nskb->nfct);
 	nskb->nfct =3D NULL;
@@ -129,16 +145,6 @@
 	nskb->nh.iph->check =3D 0;
 	nskb->nh.iph->check =3D ip_fast_csum((unsigned char *)nskb->nh.iph,=20
 					   nskb->nh.iph->ihl);
-
-	/* Routing: if not headed for us, route won't like source */
-	if (ip_route_output(&rt, nskb->nh.iph->daddr,
-			    local ? nskb->nh.iph->saddr : 0,
-			    RT_TOS(nskb->nh.iph->tos) | RTO_CONN,
-			    0) !=3D 0)
-		goto free_nskb;
-
-	dst_release(nskb->dst);
-	nskb->dst =3D &rt->u.dst;
=20
 	/* "Never happens" */
 	if (nskb->len > nskb->dst->pmtu)

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--0M7E0x35R+W+EAky
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+h0kCXaXGVTD0i/8RAs3oAJ4/cJlWxnNZUoZNf+hWXgkimJxJBACZAX3I
B/rVXhJUf1rhMCSuC8OqWfw=
=nRba
-----END PGP SIGNATURE-----

--0M7E0x35R+W+EAky--
