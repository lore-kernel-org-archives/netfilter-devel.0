From: Max Kellermann <max@duempel.org>
Subject: [PATCH pom-ng 7/6] H.323: reimplement the H.225 parser using the
	ASN.1/PER library
Date: Wed, 11 May 2005 20:16:19 +0200
Message-ID: <20050511181619.GA13487@roonstrasse.net>
References: <20050510225019.GA5102@roonstrasse.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="nFreZHaLTZJo0R7j"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20050510225019.GA5102@roonstrasse.net>
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


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

An additional patch to this patch series, which I developed today:

h323-07-reimplement_h225_parser_with_asn1_per.patch
- reimplement the H.225 parser using the ASN.1/PER library


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="h323-07-reimplement_h225_parser_with_asn1_per.patch"

Wed May 11 11:35:03 CEST 2005  max@duempel.org
  * reimplement the H.225 parser using the ASN.1/PER library
diff -rN -u old-h323-0/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323_h225.c new-h323-0/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323_h225.c
--- old-h323-0/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323_h225.c	2005-05-11 20:16:27.000000000 +0200
+++ new-h323-0/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323_h225.c	2005-05-11 12:26:20.000000000 +0200
@@ -20,6 +20,8 @@
 #include <linux/netfilter_ipv4/ip_conntrack_tuple.h>
 #include <linux/netfilter_ipv4/ip_conntrack_h323.h>
 
+#include "asn1_per.h"
+
 /* This is slow, but it's simple. --RR */
 static char h225_buffer[65536];
 
@@ -46,6 +48,161 @@
 #endif
 
 /**
+ * Parse an H.225 TransportAddress and return the position of the IP
+ * address (if present). Returns 1 on success.
+ */
+static int h225_parse_transport_address(struct asn1_per_buffer *bb, unsigned *i,
+					u_int32_t *ip, u_int16_t *port) {
+	unsigned choice, after;
+
+	choice = asn1_per_read_choice_header(bb, 1, 7, &after);
+	if (bb->error)
+		return 0;
+
+	switch (choice) {
+	case 0: /* ipAddress */
+		asn1_per_byte_align(bb);
+		*i = bb->i;
+		asn1_per_read_bytes(bb, ip, sizeof(*ip));
+		asn1_per_read_bytes(bb, port, sizeof(*port));
+		return !bb->error;
+
+	default:
+		if (after == 0) {
+			DEBUGP("TransportAddress %u not yet supported\n", choice);
+			bb->error = 1;
+		} else {
+			bb->i = after;
+		}
+		return 0;
+	}
+}
+
+/**
+ * Parse a H.225 Connect-UUIE packet and handle NAT/expectations for
+ * the H.245 transport address.
+ */
+static int h225_parse_connect_uuie(struct sk_buff **pskb,
+				   struct ip_conntrack *ct,
+				   enum ip_conntrack_info ctinfo,
+				   struct asn1_per_buffer *bb) {
+	struct asn1_per_sequence_header hdr;
+
+	asn1_per_read_sequence_header(bb, 1, 1, &hdr);
+
+	/* protocolIdentifier */
+	asn1_per_skip_object_id(bb);
+
+	/* h245Address */
+	if (asn1_per_bitmap_get(&hdr.present, 0)) {
+		int dir = CTINFO2DIR(ctinfo);
+		struct ip_conntrack_expect *exp;
+		int ret;
+		unsigned i;
+		u_int32_t ip;
+		u_int16_t port;
+
+		ret = h225_parse_transport_address(bb, &i, &ip, &port);
+		if (ret) {
+			DEBUGP("H.245 transportAddress: %u.%u.%u.%u:%u\n",
+			       NIPQUAD(ip), ntohs(port));
+		}
+		if (ret && ip == ct->tuplehash[dir].tuple.src.ip) {
+			/* match found: create an expectation */
+			exp = ip_conntrack_expect_alloc();
+			if (exp == NULL)
+				return NF_ACCEPT;
+
+			exp->tuple = ((struct ip_conntrack_tuple)
+					{ { ct->tuplehash[!dir].tuple.src.ip,
+					    { 0 } },
+					  { ct->tuplehash[!dir].tuple.dst.ip,
+					    { .tcp = { port } },
+					    IPPROTO_TCP }});
+			exp->mask = ((struct ip_conntrack_tuple)
+					{ { 0xFFFFFFFF, { 0 } },
+					  { 0xFFFFFFFF, { .tcp = { 0xFFFF } }, 0xFF }});
+
+			exp->expectfn = ip_conntrack_h245_expect;
+			exp->master = ct;
+
+			/* call NAT hook and register expectation */
+			if (ip_nat_h225_hook != NULL) {
+				return ip_nat_h225_hook(pskb, ctinfo, i,
+							exp);
+			} else {
+				/* Can't expect this?  Best to drop packet now. */
+				if (ip_conntrack_expect_related(exp) != 0) {
+					ip_conntrack_expect_free(exp);
+					return NF_DROP;
+				} else {
+					return NF_ACCEPT;
+				}
+			}
+		}
+	}
+
+	/* XXX */
+	bb->error = 1;
+
+	asn1_per_skip_sequence_extension(bb, &hdr);
+
+	return NF_ACCEPT;
+}
+
+/**
+ * Parse a H.225 H323-UU-PDU packet and handle NAT/expectations for
+ * the H.245 transport address.
+ */
+static int h225_parse_uu_pdu(struct sk_buff **pskb,
+			     struct ip_conntrack *ct,
+			     enum ip_conntrack_info ctinfo,
+			     struct asn1_per_buffer *bb) {
+	struct asn1_per_sequence_header hdr;
+	unsigned choice, after;
+	int ret;
+
+	asn1_per_read_sequence_header(bb, 1, 1, &hdr);
+
+	/* h323-message-body */
+	choice = asn1_per_read_choice_header(bb, 1, 7, &after);
+	switch (choice) {
+	case 2: /* connect */
+		ret = h225_parse_connect_uuie(pskb, ct, ctinfo, bb);
+		if (ret != NF_ACCEPT)
+			return ret;
+		break;
+
+	default:
+		if (after == 0) {
+			bb->error = 1;
+			return NF_ACCEPT;
+		}
+
+		bb->i = after;
+	}
+
+	asn1_per_skip_sequence_extension(bb, &hdr);
+
+	return NF_ACCEPT;
+}
+
+/**
+ * Parse a H.225 packet and handle NAT/expectations for the H.245
+ * transport address.
+ */
+static int h225_parse(struct sk_buff **pskb,
+		      struct ip_conntrack *ct,
+		      enum ip_conntrack_info ctinfo,
+		      struct asn1_per_buffer *bb) {
+	struct asn1_per_sequence_header hdr;
+
+	asn1_per_read_sequence_header(bb, 1, 1, &hdr);
+
+	return h225_parse_uu_pdu(pskb, ct, ctinfo, bb);
+}
+
+/**
  * Parse a Q.931 CONNECT packet and handle NAT/expectations for the
  * H.245 transport address.
  */
@@ -55,10 +212,7 @@
 				   const unsigned char *data,
 				   unsigned i, unsigned length)
 {
-	int dir = CTINFO2DIR(ctinfo);
-	u_int32_t data_ip;
-	u_int16_t data_port;
-	struct ip_conntrack_expect *exp;
+	struct asn1_per_buffer bb;
 
 	/* protocol(1) + header(3) + protocolIdentifier(6) +
 	   h245ipAddress(1) + h245ipv4(4) + h245ipv4port(2) */
@@ -68,61 +222,9 @@
 	if (data[i++] != 0x05) /* X.208 / X.209 */
 		return NF_ACCEPT;
 
-	/* XXX: h225 header connect? */
-	if (data[i++] != 0x22 || data[i++] != 0xc0 || data[i++] != 0x06)
-		return NF_ACCEPT;
+	asn1_per_initialize(&bb, data, length, i);
 
-	/* protocolIdentifier, ignore the last 2 bytes (minor
-	   version) */
-	if (memcmp(data + i, "\x00\x08\x91\x4a", 4) != 0)
-		return NF_ACCEPT;
-
-	i += 6;
-
-	if (data[i++] != 0x00) /* h245ipAddress? */
-		return NF_ACCEPT;
-
-	/* compare the IP address - this is only a valid H.245
-	   transport address, if it equals the source address of the
-	   packet */
-	data_ip = *(u_int32_t *)(data + i);
-	if (data_ip != ct->tuplehash[dir].tuple.src.ip)
-		return NF_ACCEPT;
-
-
-	data_port = *((u_int16_t *)(data + i + 4));
-
-	/* match found: create an expectation */
-	exp = ip_conntrack_expect_alloc();
-	if (exp == NULL)
-		return NF_ACCEPT;
-
-	exp->tuple = ((struct ip_conntrack_tuple)
-			{ { ct->tuplehash[!dir].tuple.src.ip,
-			    { 0 } },
-			  { ct->tuplehash[!dir].tuple.dst.ip,
-			    { .tcp = { data_port } },
-			    IPPROTO_TCP }});
-	exp->mask = ((struct ip_conntrack_tuple)
-			{ { 0xFFFFFFFF, { 0 } },
-			  { 0xFFFFFFFF, { .tcp = { 0xFFFF } }, 0xFF }});
-
-	exp->expectfn = ip_conntrack_h245_expect;
-	exp->master = ct;
-
-	/* call NAT hook and register expectation */
-	if (ip_nat_h225_hook != NULL) {
-		return ip_nat_h225_hook(pskb, ctinfo, i,
-					exp);
-	} else {
-		/* Can't expect this?  Best to drop packet now. */
-		if (ip_conntrack_expect_related(exp) != 0) {
-			ip_conntrack_expect_free(exp);
-			return NF_DROP;
-		} else {
-			return NF_ACCEPT;
-		}
-	}
+	return h225_parse(pskb, ct, ctinfo, &bb);
 }
 
 /**


--nFreZHaLTZJo0R7j--
