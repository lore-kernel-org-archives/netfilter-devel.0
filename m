From: netfilter@interlinx.bc.ca
Subject: [PATCH] ip_nat_mangle_udp_packet() updated
Date: Thu, 17 Oct 2002 12:39:09 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021017163909.GO344@pc.ilinx>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s9kDAZ2EyO0AcRYa"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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


--s9kDAZ2EyO0AcRYa
Content-Type: multipart/mixed; boundary="kK1uqZGE6pgsGNyR"
Content-Disposition: inline


--kK1uqZGE6pgsGNyR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Harald and all.

Find attached an updated patch for my ip_nat_mangle_udp_packet().
This function no longer gratuitously checkums the mangled UDP packet.
It only calculated a UDP checksum when the pre-mangling checksum is
non-zero.  It still pushes the packet up for IP checksum however.  I
believe this to be the correct way to do this.

Thanx,
b.

--=20
Brian J. Murrell

--kK1uqZGE6pgsGNyR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="udp_conntrack-2.patch"
Content-Transfer-Encoding: quoted-printable

diff -Nur --exclude '*~' --exclude '*.orig' linux-2.4.19-16mdk/include/linu=
x/netfilter_ipv4/ip_nat_helper.h linux-2.4.19-16mdk.tmp/include/linux/netfi=
lter_ipv4/ip_nat_helper.h
--- linux-2.4.19-16mdk/include/linux/netfilter_ipv4/ip_nat_helper.h	2002-10=
-09 04:52:29.000000000 -0400
+++ linux-2.4.19-16mdk.tmp/include/linux/netfilter_ipv4/ip_nat_helper.h	200=
2-10-17 11:07:43.000000000 -0400
@@ -50,6 +50,13 @@
 				unsigned int match_len,
 				char *rep_buffer,
 				unsigned int rep_len);
+extern int ip_nat_mangle_udp_packet(struct sk_buff **skb,
+				struct ip_conntrack *ct,
+				enum ip_conntrack_info ctinfo,
+				unsigned int match_offset,
+				unsigned int match_len,
+				char *rep_buffer,
+				unsigned int rep_len);
 extern int ip_nat_seq_adjust(struct sk_buff *skb,
 				struct ip_conntrack *ct,
 				enum ip_conntrack_info ctinfo);
diff -Nur --exclude '*~' --exclude '*.orig' linux-2.4.19-16mdk/net/ipv4/net=
filter/ip_nat_helper.c linux-2.4.19-16mdk.tmp/net/ipv4/netfilter/ip_nat_hel=
per.c
--- linux-2.4.19-16mdk/net/ipv4/netfilter/ip_nat_helper.c	2002-09-20 09:44:=
35.000000000 -0400
+++ linux-2.4.19-16mdk.tmp/net/ipv4/netfilter/ip_nat_helper.c	2002-10-17 11=
:15:35.000000000 -0400
@@ -8,6 +8,9 @@
  *		- add support for SACK adjustment=20
  *	14 Mar 2002 Harald Welte <laforge@gnumonks.org>:
  *		- merge SACK support into newnat API
+ *	16 Aug 2002 Brian J. Murrell <netfilter@interlinx.bc.ca>:
+ *		- make ip_nat_resize_packet more generic (TCP and UDP)
+ *		- add ip_nat_mangle_udp_packet
  */
 #include <linux/version.h>
 #include <linux/config.h>
@@ -22,6 +25,7 @@
 #include <net/icmp.h>
 #include <net/ip.h>
 #include <net/tcp.h>
+#include <net/udp.h>
=20
 #define ASSERT_READ_LOCK(x) MUST_BE_READ_LOCKED(&ip_nat_lock)
 #define ASSERT_WRITE_LOCK(x) MUST_BE_WRITE_LOCKED(&ip_nat_lock)
@@ -51,18 +55,12 @@
 		     int new_size)
 {
 	struct iphdr *iph;
-	struct tcphdr *tcph;
-	void *data;
 	int dir;
 	struct ip_nat_seq *this_way, *other_way;
=20
 	DEBUGP("ip_nat_resize_packet: old_size =3D %u, new_size =3D %u\n",
 		(*skb)->len, new_size);
=20
-	iph =3D (*skb)->nh.iph;
-	tcph =3D (void *)iph + iph->ihl*4;
-	data =3D (void *)tcph + tcph->doff*4;
-
 	dir =3D CTINFO2DIR(ctinfo);
=20
 	this_way =3D &ct->nat.info.seq[dir];
@@ -84,37 +82,41 @@
 	}
=20
 	iph =3D (*skb)->nh.iph;
-	tcph =3D (void *)iph + iph->ihl*4;
-	data =3D (void *)tcph + tcph->doff*4;
-
-	DEBUGP("ip_nat_resize_packet: Seq_offset before: ");
-	DUMP_OFFSET(this_way);
+	if (iph->protocol =3D=3D IPPROTO_TCP) {
+		struct tcphdr *tcph =3D (void *)iph + iph->ihl*4;
+		void *data =3D (void *)tcph + tcph->doff*4;
+
+		DEBUGP("ip_nat_resize_packet: Seq_offset before: ");
+		DUMP_OFFSET(this_way);
+
+		LOCK_BH(&ip_nat_seqofs_lock);
+
+		/* SYN adjust. If it's uninitialized, of this is after last=20
+		 * correction, record it: we don't handle more than one=20
+		 * adjustment in the window, but do deal with common case of a=20
+		 * retransmit */
+		if (this_way->offset_before =3D=3D this_way->offset_after
+		    || before(this_way->correction_pos, ntohl(tcph->seq))) {
+			this_way->correction_pos =3D ntohl(tcph->seq);
+			this_way->offset_before =3D this_way->offset_after;
+			this_way->offset_after =3D (int32_t)
+				this_way->offset_before + new_size -
+				(*skb)->len;
+		}
=20
-	LOCK_BH(&ip_nat_seqofs_lock);
+		UNLOCK_BH(&ip_nat_seqofs_lock);
=20
-	/* SYN adjust. If it's uninitialized, of this is after last=20
-	 * correction, record it: we don't handle more than one=20
-	 * adjustment in the window, but do deal with common case of a=20
-	 * retransmit */
-	if (this_way->offset_before =3D=3D this_way->offset_after
-	    || before(this_way->correction_pos, ntohl(tcph->seq))) {
-		this_way->correction_pos =3D ntohl(tcph->seq);
-		this_way->offset_before =3D this_way->offset_after;
-		this_way->offset_after =3D (int32_t)
-			this_way->offset_before + new_size - (*skb)->len;
+		DEBUGP("ip_nat_resize_packet: Seq_offset after: ");
+		DUMP_OFFSET(this_way);
 	}
-
-	UNLOCK_BH(&ip_nat_seqofs_lock);
-
-	DEBUGP("ip_nat_resize_packet: Seq_offset after: ");
-	DUMP_OFFSET(this_way);
 =09
 	return 1;
 }
=20
=20
 /* Generic function for mangling variable-length address changes inside
- * NATed connections (like the PORT XXX,XXX,XXX,XXX,XXX,XXX command in FTP=
).
+ * NATed TCP connections (like the PORT XXX,XXX,XXX,XXX,XXX,XXX
+ * command in FTP).
  *
  * Takes care about all the nasty sequence number changes, checksumming,
  * skb enlargement, ...
@@ -174,10 +176,11 @@
 	tcph =3D (void *)iph + iph->ihl*4;
 	data =3D (void *)tcph + tcph->doff*4;
=20
-	/* move post-replacement */
-	memmove(data + match_offset + rep_len,
-		 data + match_offset + match_len,
-		 (*skb)->tail - (data + match_offset + match_len));
+	if (rep_len !=3D match_len)
+		/* move post-replacement */
+		memmove(data + match_offset + rep_len,
+			data + match_offset + match_len,
+			(*skb)->tail - (data + match_offset + match_len));
=20
 	/* insert data from buffer */
 	memcpy(data + match_offset, rep_buffer, rep_len);
@@ -207,6 +210,114 @@
=20
 	return 1;
 }
+		=09
+/* Generic function for mangling variable-length address changes inside
+ * NATed UDP connections (like the CONNECT DATA XXXXX MESG XXXXX INDEX XXX=
XX
+ * command in the Amanda protocol)
+ *
+ * Takes care about all the nasty sequence number changes, checksumming,
+ * skb enlargement, ...
+ *
+ * XXX - This function could be merged with ip_nat_mangle_tcp_packet which
+ *       should be fairly easy to do.
+ */
+int=20
+ip_nat_mangle_udp_packet(struct sk_buff **skb,
+			 struct ip_conntrack *ct,
+			 enum ip_conntrack_info ctinfo,
+			 unsigned int match_offset,
+			 unsigned int match_len,
+			 char *rep_buffer,
+			 unsigned int rep_len)
+{
+	struct iphdr *iph =3D (*skb)->nh.iph;
+	struct udphdr *udph =3D (void *)iph + iph->ihl * 4;
+	unsigned char *data;
+	u_int32_t udplen, newlen, newudplen;
+
+	udplen =3D (*skb)->len - iph->ihl*4;
+	newudplen =3D udplen - match_len + rep_len;
+	newlen =3D iph->ihl*4 + newudplen;
+
+	if (newlen > 65535) {
+		if (net_ratelimit())
+			printk("ip_nat_mangle_udp_packet: nat'ed packet "
+				"exceeds maximum packet size\n");
+		return 0;
+	}
+
+	if ((*skb)->len !=3D newlen) {
+		if (!ip_nat_resize_packet(skb, ct, ctinfo, newlen)) {
+			printk("resize_packet failed!!\n");
+			return 0;
+		}
+	}
+
+	/* Alexey says: if a hook changes _data_ ... it can break
+	   original packet sitting in tcp queue and this is fatal */
+	if (skb_cloned(*skb)) {
+		struct sk_buff *nskb =3D skb_copy(*skb, GFP_ATOMIC);
+		if (!nskb) {
+			if (net_ratelimit())
+				printk("Out of memory cloning TCP packet\n");
+			return 0;
+		}
+		/* Rest of kernel will get very unhappy if we pass it
+		   a suddenly-orphaned skbuff */
+		if ((*skb)->sk)
+			skb_set_owner_w(nskb, (*skb)->sk);
+		kfree_skb(*skb);
+		*skb =3D nskb;
+	}
+
+	/* skb may be copied !! */
+	iph =3D (*skb)->nh.iph;
+	udph =3D (void *)iph + iph->ihl*4;
+	data =3D (void *)udph + sizeof(struct udphdr);
+
+	if (rep_len !=3D match_len)
+		/* move post-replacement */
+		memmove(data + match_offset + rep_len,
+			data + match_offset + match_len,
+			(*skb)->tail - (data + match_offset + match_len));
+
+	/* insert data from buffer */
+	memcpy(data + match_offset, rep_buffer, rep_len);
+
+	/* update skb info */
+	if (newlen > (*skb)->len) {
+		DEBUGP("ip_nat_mangle_udp_packet: Extending packet by "
+			"%u to %u bytes\n", newlen - (*skb)->len, newlen);
+		skb_put(*skb, newlen - (*skb)->len);
+	} else {
+		DEBUGP("ip_nat_mangle_udp_packet: Shrinking packet from "
+			"%u to %u bytes\n", (*skb)->len, newlen);
+		skb_trim(*skb, newlen);
+	}
+
+	/* update the length of the UDP and IP packets to the new values*/
+	udph->len =3D htons((*skb)->len - iph->ihl*4);
+	iph->tot_len =3D htons(newlen);
+
+	/* fix udp checksum if udp checksum was previously calculated */
+	if ((*skb)->csum !=3D 0) {
+		(*skb)->csum =3D csum_partial((char *)udph +
+					    sizeof(struct udphdr),
+					    newudplen - sizeof(struct udphdr),
+					    0);
+
+		udph->check =3D 0;
+		udph->check =3D csum_tcpudp_magic(iph->saddr, iph->daddr,
+						newudplen, IPPROTO_UDP,
+						csum_partial((char *)udph,
+							 sizeof(struct udphdr),
+							(*skb)->csum));
+	}
+
+	ip_send_check(iph);
+
+	return 1;
+}
=20
 /* Adjust one found SACK option including checksum correction */
 static void
diff -Nur --exclude '*~' --exclude '*.orig' linux-2.4.19-16mdk/net/ipv4/net=
filter/ip_nat_standalone.c linux-2.4.19-16mdk.tmp/net/ipv4/netfilter/ip_nat=
_standalone.c
--- linux-2.4.19-16mdk/net/ipv4/netfilter/ip_nat_standalone.c	2002-09-20 09=
:44:36.000000000 -0400
+++ linux-2.4.19-16mdk.tmp/net/ipv4/netfilter/ip_nat_standalone.c	2002-10-1=
7 11:16:00.000000000 -0400
@@ -358,5 +358,6 @@
 EXPORT_SYMBOL(ip_nat_helper_unregister);
 EXPORT_SYMBOL(ip_nat_cheat_check);
 EXPORT_SYMBOL(ip_nat_mangle_tcp_packet);
+EXPORT_SYMBOL(ip_nat_mangle_udp_packet);
 EXPORT_SYMBOL(ip_nat_used_tuple);
 MODULE_LICENSE("GPL");
Binary files linux-2.4.19-16mdk/net/ipv4/netfilter/.ip_nat_standalone.c.swp=
 and linux-2.4.19-16mdk.tmp/net/ipv4/netfilter/.ip_nat_standalone.c.swp dif=
fer

--kK1uqZGE6pgsGNyR--

--s9kDAZ2EyO0AcRYa
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE9ruetl3EQlGLyuXARAq7+AKD/bJ7LAfUD4H1dmBzv6WSoMrLHbgCfchO4
lHPAvSMFj9+XaXHQ3KPEojg=
=CE6t
-----END PGP SIGNATURE-----

--s9kDAZ2EyO0AcRYa--
