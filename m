From: Max Kellermann <max@duempel.org>
Subject: [PATCH pom-ng 3/3] h323-conntrack-nat updates: simplified length
	checks
Date: Thu, 12 May 2005 22:52:46 +0200
Message-ID: <20050512205246.GD2175@roonstrasse.net>
References: <20050512204956.GA2086@roonstrasse.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Pd0ReVV5GZGQvF3a"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20050512204956.GA2086@roonstrasse.net>
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


--Pd0ReVV5GZGQvF3a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

h323-03-simplified_length_checks.patch
- simplified some length checks to make them easier readable


--Pd0ReVV5GZGQvF3a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="h323-03-simplified_length_checks.patch"

Thu May 12 22:38:17 CEST 2005  max@duempel.org
  * simplified buffer length checks
diff -rN -u old-h323-0/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323_h225.c new-h323-0/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323_h225.c
--- old-h323-0/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323_h225.c	2005-05-12 22:49:00.000000000 +0200
+++ new-h323-0/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323_h225.c	2005-05-12 22:38:36.000000000 +0200
@@ -214,7 +214,7 @@
 {
 	struct asn1_per_buffer bb;
 
-	if (i + 8 > length)
+	if (i + 2 > length)
 		return NF_ACCEPT;
 
 	if (data[i++] != 0x05) /* X.208 / X.209 */
@@ -275,6 +275,9 @@
 	u_int8_t q931_message_type;
 	unsigned length;
 
+	if (i + 3 > datalen)
+		return NF_ACCEPT;
+
 	/* parse Q.931 packet */
 	if (data[i++] != 0x08) /* protocol discriminator */
 		return NF_ACCEPT;
@@ -319,6 +322,9 @@
 	unsigned int i = 0;
 	u_int16_t tpkt_len;
 
+	if (i + 4 > datalen)
+		return NF_ACCEPT;
+
 	/* expect TPKT header, see RFC 1006 */
 	if (data[0] != 0x03 || data[1] != 0x00)
 		return NF_ACCEPT;
@@ -326,9 +332,6 @@
 	i += 2;
 
 	tpkt_len = ntohs(*(u_int16_t*)(data + i));
-	if (tpkt_len < 16)
-		return NF_ACCEPT;
-
 	if (tpkt_len < datalen)
 		datalen = tpkt_len;
 
@@ -372,7 +375,7 @@
 	}
 	datalen = (*pskb)->len - dataoff;
 
-	if (datalen < 32)
+	if (datalen < 16)
 		return NF_ACCEPT;
 
 	/* get data portion, and evaluate it */
diff -rN -u old-h323-0/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323_h245.c new-h323-0/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323_h245.c
--- old-h323-0/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323_h245.c	2005-05-12 22:49:00.000000000 +0200
+++ new-h323-0/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323_h245.c	2005-05-12 22:38:36.000000000 +0200
@@ -868,6 +868,9 @@
 	u_int16_t tpkt_len;
 	struct asn1_per_buffer bb;
 
+	if (i + 4 > datalen)
+		return NF_ACCEPT;
+
 	/* expect TPKT header, see RFC 1006 */
 	if (data[0] != 0x03 || data[1] != 0x00)
 		return NF_ACCEPT;
@@ -875,9 +878,6 @@
 	i += 2;
 
 	tpkt_len = ntohs(*(u_int16_t*)(data + i));
-	if (tpkt_len < 16)
-		return NF_ACCEPT;
-
 	if (tpkt_len < datalen)
 		datalen = tpkt_len;
 
@@ -922,6 +922,9 @@
 	}
 	datalen = (*pskb)->len - dataoff;
 
+	if (datalen < 16)
+		return NF_ACCEPT;
+
 	LOCK_BH(&ip_h245_lock);
 	data = skb_header_pointer((*pskb), dataoff,
 				  datalen, h245_buffer);


--Pd0ReVV5GZGQvF3a--
