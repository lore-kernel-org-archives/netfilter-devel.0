From: Harald Welte <laforge@gnumonks.org>
Subject: [PATCH] locking fix for TCP conntrack
Date: Thu, 9 Jan 2003 15:42:06 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030109144206.GF9467@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m699nQIRt8EJjqXo"
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


--m699nQIRt8EJjqXo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

This is another patch of the series of patches you will receive from me tod=
ay.

Please apply to 2.4.x and 2.5.x, thanks.

Author: Martin Josefsson <gandalf@wlug.westbo.se>
Fix a locking bug in ip_conntrack_proto_tcp.


--- linux-2.4.20-pre10/net/ipv4/netfilter/ip_conntrack_proto_tcp.c.meep	200=
2-10-24 17:05:49.000000000 +0200
+++ linux-2.4.20-pre10/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2002-10-=
24 17:11:19.000000000 +0200
@@ -186,13 +186,13 @@
 	    && tcph->syn && tcph->ack)
 		conntrack->proto.tcp.handshake_ack
 			=3D htonl(ntohl(tcph->seq) + 1);
-	WRITE_UNLOCK(&tcp_lock);
=20
 	/* If only reply is a RST, we can consider ourselves not to
 	   have an established connection: this is a fairly common
 	   problem case, so we can delete the conntrack
 	   immediately.  --RR */
 	if (!(conntrack->status & IPS_SEEN_REPLY) && tcph->rst) {
+		WRITE_UNLOCK(&tcp_lock);
 		if (del_timer(&conntrack->timeout))
 			conntrack->timeout.function((unsigned long)conntrack);
 	} else {
@@ -203,6 +203,7 @@
 		    && tcph->ack_seq =3D=3D conntrack->proto.tcp.handshake_ack)
 			set_bit(IPS_ASSURED_BIT, &conntrack->status);
=20
+		WRITE_UNLOCK(&tcp_lock);
 		ip_ct_refresh(conntrack, tcp_timeouts[newconntrack]);
 	}
=20
--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--m699nQIRt8EJjqXo
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+HYo+XaXGVTD0i/8RAltGAKC0lg4Jo3eTHWxNcB8WSwaqEZgNwQCfeSxs
fYMF1mIizTUDGJ8iWnMC7ww=
=QR6o
-----END PGP SIGNATURE-----

--m699nQIRt8EJjqXo--
