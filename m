From: Max Kellermann <max@duempel.org>
Subject: [PATCH pom-ng] H.225 parser for h323-conntrack-nat
Date: Thu, 17 Mar 2005 04:24:05 +0100
Message-ID: <20050317032405.GA7200@roonstrasse.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="u3/rZRmxL6MmkK24"
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

this patch implements a "real" H.225 parser, replacing the old "brute
force" algorithm. This parser is not complete yet; it currently only
handles CONNECT packets, although that seems to be enough for most
H.323 clients. I tested with ohphone, MS Netmeeting and gnomemeeting
(plus a nfsim test which I will publish soon). NAT works well.

I havn't written a H.245 parser yet, that's the next item on my todo
list.

The attached patch applies to the pom-ng trunk after you merged my
last patches from the linux-2.6.11 branch:

  cd h323-conntrack-nat/linux-2.6.11
  svn merge -r 3689:3690 \
    https://svn.netfilter.org/netfilter/branches/patch-o-matic-ng/linux-2.6.11/h323-conntrack-nat/linux-2.6

(I guess the linux-2.6.11 branch is obsolete since the
h323-conntrack-nat/linux-2.6.11 directory was introduced by Harald)

Max


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="h323_parse_h225_no_bruteforce.patch"

Thu Mar 17 04:05:23 CET 2005  max@duempel.org
  * replaced brute force by a H.225 parser, still incomplete
diff -rN -u old-h323-7/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323.c new-h323-7/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323.c
--- old-h323-7/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323.c	2005-03-17 04:07:06.847233824 +0100
+++ new-h323-7/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323.c	2005-03-17 04:04:05.000000000 +0100
@@ -178,21 +178,204 @@
 	WRITE_UNLOCK(&ip_conntrack_lock);
 }
 
-/* FIXME: This should be in userspace.  Later. */
+/**
+ * Parse a Q.931 CONNECT packet and handle NAT/expectations for the
+ * H.245 transport address.
+ */
+static int h225_parse_q931_connect(struct sk_buff **pskb,
+				   struct ip_conntrack *ct,
+				   enum ip_conntrack_info ctinfo,
+				   const unsigned char *data,
+				   unsigned i, unsigned length)
+{
+	int dir = CTINFO2DIR(ctinfo);
+	u_int32_t data_ip;
+	u_int16_t data_port;
+	struct ip_conntrack_expect *exp;
+
+	/* protocol(1) + header(3) + protocolIdentifier(6) +
+	   h245ipAddress(1) + h245ipv4(4) + h245ipv4port(2) */
+	if (length < 17)
+		return NF_ACCEPT;
+
+	if (data[i++] != 0x05) /* X.208 / X.209 */
+		return NF_ACCEPT;
+
+	/* XXX: h225 header connect? */
+	if (data[i++] != 0x22 || data[i++] != 0xc0 || data[i++] != 0x06)
+		return NF_ACCEPT;
+
+	/* protocolIdentifier, ignore the last 2 bytes (minor
+	   version) */
+	if (memcmp(data + i, "\x00\x08\x91\x4a", 4) != 0)
+		return NF_ACCEPT;
+
+	i += 6;
+
+	if (data[i++] != 0x00) /* h245ipAddress? */
+		return NF_ACCEPT;
+
+	/* compare the IP address - this is only a valid H.245
+	   transport address, if it equals the source address of the
+	   packet */
+	data_ip = *(u_int32_t *)(data + i);
+	if (data_ip != ct->tuplehash[dir].tuple.src.ip)
+		return NF_ACCEPT;
+
+
+	data_port = *((u_int16_t *)(data + i + 4));
+
+	/* match found: create an expectation */
+	exp = ip_conntrack_expect_alloc();
+	if (exp == NULL)
+		return NF_ACCEPT;
+
+	exp->tuple = ((struct ip_conntrack_tuple)
+			{ { ct->tuplehash[!dir].tuple.src.ip,
+			    { 0 } },
+			  { ct->tuplehash[!dir].tuple.dst.ip,
+			    { .tcp = { data_port } },
+			    IPPROTO_TCP }});
+	exp->mask = ((struct ip_conntrack_tuple)
+			{ { 0xFFFFFFFF, { 0 } },
+			  { 0xFFFFFFFF, { .tcp = { 0xFFFF } }, 0xFF }});
+
+	exp->expectfn = h225_expect;
+	exp->master = ct;
+
+	/* call NAT hook and register expectation */
+	if (ip_nat_h225_hook != NULL) {
+		return ip_nat_h225_hook(pskb, ctinfo, i,
+					exp);
+	} else {
+		/* Can't expect this?  Best to drop packet now. */
+		if (ip_conntrack_expect_related(exp) != 0) {
+			ip_conntrack_expect_free(exp);
+			return NF_DROP;
+		} else {
+			return NF_ACCEPT;
+		}
+	}
+}
+
+/**
+ * Scan a Q.931 packet for a user-to-user information element
+ * (IE). Return the index, or 0 if none found.
+ */
+static unsigned q931_find_u2u(const unsigned char *data,
+			      unsigned datalen,
+			      unsigned int i,
+			      unsigned *lengthp) {
+	unsigned char type;
+	unsigned length;
+
+	/* traverse all Q.931 information elements (IE) */
+	while (i + 2 <= datalen) {
+		type = data[i++];
+
+		/* highest bit set means one-byte IE */
+		if (type & 0x80)
+			continue;
+
+		length = data[i++];
+
+		if (type == 0x7e) { /* user-to-user */
+			/* user-to-user IEs have a 16 bit length
+			   field */
+			length = (length << 8) | data[i++];
+			if (i + length > datalen)
+				return 0;
+
+			*lengthp = length;
+			return i;
+		}
+
+		i += length;
+	}
+
+	return 0;
+}
+
+/**
+ * Parse a Q.931/H.225 packet and handle NAT/expectations for the
+ * H.245 transport address (if applicable).
+ */
+static int h225_parse_q931(struct sk_buff **pskb,
+			   struct ip_conntrack *ct,
+			   enum ip_conntrack_info ctinfo,
+			   const unsigned char *data,
+			   unsigned datalen, unsigned i) {
+	u_int8_t q931_message_type;
+	unsigned length;
+
+	/* parse Q.931 packet */
+	if (data[i++] != 0x08) /* protocol discriminator */
+		return NF_ACCEPT;
+
+	/* call reference */
+	i += 1 + data[i];
+	if (i >= datalen)
+		return NF_ACCEPT;
+
+	/* only some Q.931 message types can contain a H.245 transport
+	   address - we can ignore the rest in this module */
+	q931_message_type = data[i++];
+	if (q931_message_type == 0x07) {
+		/* CONNECT */
+
+		/* find a user-to-user information element (IE) */
+		i = q931_find_u2u(data, datalen, i, &length);
+		if (i == 0)
+			return NF_ACCEPT;
+
+		return h225_parse_q931_connect(pskb, ct, ctinfo,
+					       data, i, length);
+	} else {
+		/* XXX handle q931_message_type 0x01, 0x02, 0x03 */
+		return NF_ACCEPT;
+	}
+}
+
+/**
+ * Parse a TPKT/Q.931/H.225 packet and handle NAT/expectations for the
+ * H.245 transport address (if applicable).
+ */
+static int h225_parse_tpkt(struct sk_buff **pskb,
+			   struct ip_conntrack *ct,
+			   enum ip_conntrack_info ctinfo,
+			   const unsigned char *data,
+			   unsigned datalen) {
+	unsigned int i = 0;
+	u_int16_t tpkt_len;
+
+	/* expect TPKT header, see RFC 1006 */
+	if (data[0] != 0x03 || data[1] != 0x00)
+		return NF_ACCEPT;
+
+	i += 2;
+
+	tpkt_len = ntohs(*(u_int16_t*)(data + i));
+	if (tpkt_len < 16)
+		return NF_ACCEPT;
+
+	if (tpkt_len < datalen)
+		datalen = tpkt_len;
+
+	i += 2;
+
+	/* parse Q.931 packet */
+	return h225_parse_q931(pskb, ct, ctinfo,
+			       data, datalen, i);
+}
+
 static int h225_help(struct sk_buff **pskb,
 		     struct ip_conntrack *ct,
 		     enum ip_conntrack_info ctinfo)
 {
 	struct tcphdr _tcph, *tcph;
 	unsigned char *data;
-	unsigned char *data_limit;
 	unsigned dataoff, datalen;
-	int dir = CTINFO2DIR(ctinfo);
-	struct ip_conntrack_expect *exp;
-	u_int16_t data_port;
-	u_int32_t data_ip;
-	unsigned int i;
-	int ret;
+	int ret = NF_ACCEPT;
 
 	/* Until there's been traffic both ways, don't look in packets. */
 	if (ctinfo != IP_CT_ESTABLISHED
@@ -218,79 +401,18 @@
 	}
 	datalen = (*pskb)->len - dataoff;
 
+	if (datalen < 32)
+		return NF_ACCEPT;
+
+	/* get data portion, and evaluate it */
 	LOCK_BH(&ip_h323_lock);
 	data = skb_header_pointer((*pskb), dataoff,
 				  datalen, h323_buffer);
 	BUG_ON(data == NULL);
 
-	data_limit = data + datalen - 6;
-	/* bytes: 0123   45
-	          ipadrr port */
-	for (i = 0; data <= data_limit; data++, i++) {
-		data_ip = *((u_int32_t *)data);
-		if (data_ip == ct->tuplehash[dir].tuple.src.ip) {
-			data_port = *((u_int16_t *)(data + 4));
-			if (data_port == ct->tuplehash[dir].tuple.src.u.tcp.port) {
-				/* Signal address */
-				DEBUGP("ct_h225_help: sourceCallSignalAddress from %u.%u.%u.%u\n",
-					NIPQUAD((*pskb)->nh.iph->saddr));
-				/* Update the H.225 info so that NAT can mangle the address/port
-				   even when we have no expected connection! */
-				if (ip_nat_h225_signal_hook != NULL)
-					ip_nat_h225_signal_hook(pskb, ct, ctinfo,
-								i, IP_CT_DIR_ORIGINAL, dir);
-			} else {
-				/* update the H.225 info */
-				exp = ip_conntrack_expect_alloc();
-				if (exp == NULL) {
-					ret = NF_ACCEPT;
-					goto out;
-				}
-
-				exp->tuple = ((struct ip_conntrack_tuple)
-					{ { ct->tuplehash[!dir].tuple.src.ip,
-					    { 0 } },
-					  { data_ip,
-					    { .tcp = { data_port } },
-					    IPPROTO_TCP }});
-				exp->mask = ((struct ip_conntrack_tuple)
-					{ { 0xFFFFFFFF, { 0 } },
-					  { 0xFFFFFFFF, { .tcp = { 0xFFFF } }, 0xFF }});
-
-				exp->expectfn = h225_expect;
-				exp->master = ct;
-
-				if (ip_nat_h225_hook != NULL) {
-					ret = ip_nat_h225_hook(pskb, ctinfo, i,
-							       exp);
-				} else {
-					/* Can't expect this?  Best to drop packet now. */
-					if (ip_conntrack_expect_related(exp) != 0) {
-						ip_conntrack_expect_free(exp);
-						ret = NF_DROP;
-					} else
-						ret = NF_ACCEPT;
-				}
-			}
-
-			break;
-		} else if (data_ip == ct->tuplehash[dir].tuple.dst.ip) {
-			data_port = *((u_int16_t *)(data + 4));
-			if (data_port == ct->tuplehash[dir].tuple.dst.u.tcp.port) {
-				/* Signal address */
-				DEBUGP("ct_h225_help: destCallSignalAddress %u.%u.%u.%u\n",
-					NIPQUAD((*pskb)->nh.iph->daddr));
-				/* Update the H.225 info so that NAT can mangle the address/port
-				   even when we have no expected connection! */
-				if (ip_nat_h225_signal_hook != NULL)
-					ip_nat_h225_signal_hook(pskb, ct, ctinfo,
-								i, IP_CT_DIR_REPLY, dir);
-			}
-		}
-	}
+	ret = h225_parse_tpkt(pskb, ct, ctinfo,
+			      data, datalen);
 
-	ret = NF_ACCEPT;
- out:
 	UNLOCK_BH(&ip_h323_lock);
 	return ret;
 }


--u3/rZRmxL6MmkK24--
