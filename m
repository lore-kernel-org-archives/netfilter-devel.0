From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6] optimization of ip_conntrack_proto_tcp:tcp_packet()
Date: Mon, 29 Mar 2004 12:33:48 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040329103348.GC1528@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bajzpZikUji1w+G9"
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


--bajzpZikUji1w+G9
Content-Type: multipart/mixed; boundary="c3bfwLpm8qysLVxt"
Content-Disposition: inline


--c3bfwLpm8qysLVxt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

This is the first in a set of 2.6.x optimization patches.  Obviosly,
they are meant for 2.6.6, not 2.6.5.  Please apply to your tree, thanks.

A: Pablo Neira
D: This patch cleans up tcp_packet().  No semantical change, just juggling
D: code pieces. =20

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--c3bfwLpm8qysLVxt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="linux-2.6.patch"
Content-Transfer-Encoding: quoted-printable

--- linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2004-02-18 =
04:59:50.000000000 +0100
+++ linux-2.6.3/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2004-03-02 03:1=
1:10.000000000 +0100
@@ -178,6 +178,16 @@
 	if (skb_copy_bits(skb, skb->nh.iph->ihl * 4, &tcph, sizeof(tcph)) !=3D 0)
 		return -1;
=20
+	/* If only reply is a RST, we can consider ourselves not to
+	   have an established connection: this is a fairly common
+	   problem case, so we can delete the conntrack
+	   immediately.  --RR */
+	if (!test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status) && tcph.rst) {
+		if (del_timer(&conntrack->timeout))
+			conntrack->timeout.function((unsigned long)conntrack);
+		return NF_ACCEPT;
+	}
+
 	WRITE_LOCK(&tcp_lock);
 	oldtcpstate =3D conntrack->proto.tcp.state;
 	newconntrack
@@ -199,29 +209,21 @@
 	/* Poor man's window tracking: record SYN/ACK for handshake check */
 	if (oldtcpstate =3D=3D TCP_CONNTRACK_SYN_SENT
 	    && CTINFO2DIR(ctinfo) =3D=3D IP_CT_DIR_REPLY
-	    && tcph.syn && tcph.ack)
+	    && tcph.syn && tcph.ack) {
 		conntrack->proto.tcp.handshake_ack
 			=3D htonl(ntohl(tcph.seq) + 1);
+		goto out;
+	}
=20
-	/* If only reply is a RST, we can consider ourselves not to
-	   have an established connection: this is a fairly common
-	   problem case, so we can delete the conntrack
-	   immediately.  --RR */
-	if (!test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status) && tcph.rst) {
-		WRITE_UNLOCK(&tcp_lock);
-		if (del_timer(&conntrack->timeout))
-			conntrack->timeout.function((unsigned long)conntrack);
-	} else {
-		/* Set ASSURED if we see see valid ack in ESTABLISHED after SYN_RECV */
-		if (oldtcpstate =3D=3D TCP_CONNTRACK_SYN_RECV
-		    && CTINFO2DIR(ctinfo) =3D=3D IP_CT_DIR_ORIGINAL
-		    && tcph.ack && !tcph.syn
-		    && tcph.ack_seq =3D=3D conntrack->proto.tcp.handshake_ack)
-			set_bit(IPS_ASSURED_BIT, &conntrack->status);
+	/* Set ASSURED if we see valid ack in ESTABLISHED after SYN_RECV */
+	if (oldtcpstate =3D=3D TCP_CONNTRACK_SYN_RECV
+	    && CTINFO2DIR(ctinfo) =3D=3D IP_CT_DIR_ORIGINAL
+	    && tcph.ack && !tcph.syn
+	    && tcph.ack_seq =3D=3D conntrack->proto.tcp.handshake_ack)
+		set_bit(IPS_ASSURED_BIT, &conntrack->status);
=20
-		WRITE_UNLOCK(&tcp_lock);
-		ip_ct_refresh(conntrack, *tcp_timeouts[newconntrack]);
-	}
+out:	WRITE_UNLOCK(&tcp_lock);
+	ip_ct_refresh(conntrack, *tcp_timeouts[newconntrack]);
=20
 	return NF_ACCEPT;
 }

--c3bfwLpm8qysLVxt--

--bajzpZikUji1w+G9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAZ/uMXaXGVTD0i/8RAvR0AKCsA99IhwqeUVbyWmQj4juswxGpUgCgrItl
ztdL495fNZyIhaUtscR0I/U=
=ifUB
-----END PGP SIGNATURE-----

--bajzpZikUji1w+G9--
