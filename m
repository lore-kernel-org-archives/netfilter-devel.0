From: Max Kellermann <max@duempel.org>
Subject: [PATCH pom-ng 4/6] H.323: splitted ip_conntrack_h323.c into 3
	sources
Date: Wed, 11 May 2005 00:52:55 +0200
Message-ID: <20050510225255.GD5720@roonstrasse.net>
References: <20050510225019.GA5102@roonstrasse.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="W5WqUoFLvi1M7tJE"
Cc: laforge@gnumonks.org
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


--W5WqUoFLvi1M7tJE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

h323-04-split_conntrack_into_3.patch
- splitted ip_conntrack_h323.c into 3 sources

--W5WqUoFLvi1M7tJE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="h323-04-split_conntrack_into_3.patch"

Tue May 10 23:26:46 CEST 2005  max@duempel.org
  * splitted ip_conntrack_h323.c into 3 sources IV
diff -rN -u old-h323-4/h323-conntrack-nat/linux-2.6.11/include/linux/netfilter_ipv4/ip_conntrack_h323.h new-h323-4/h323-conntrack-nat/linux-2.6.11/include/linux/netfilter_ipv4/ip_conntrack_h323.h
--- old-h323-4/h323-conntrack-nat/linux-2.6.11/include/linux/netfilter_ipv4/ip_conntrack_h323.h	2005-05-10 23:48:49.000000000 +0200
+++ new-h323-4/h323-conntrack-nat/linux-2.6.11/include/linux/netfilter_ipv4/ip_conntrack_h323.h	2005-05-10 23:33:19.000000000 +0200
@@ -9,6 +9,7 @@
 
 struct ip_conntrack_expect;
 struct ip_conntrack;
+struct ip_conntrack_helper;
 
 extern int (*ip_nat_h245_hook)(struct sk_buff **pskb,
 			       enum ip_conntrack_info ctinfo,
@@ -27,6 +28,8 @@
 				       int dir,
 				       int orig_dir);
 
+extern struct ip_conntrack_helper ip_conntrack_helper_h225;
+
 void ip_conntrack_h245_expect(struct ip_conntrack *new,
 			      struct ip_conntrack_expect *this);
 
diff -rN -u old-h323-4/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/Makefile.ladd new-h323-4/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/Makefile.ladd
--- old-h323-4/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/Makefile.ladd	2005-05-10 23:48:49.000000000 +0200
+++ new-h323-4/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/Makefile.ladd	2005-05-10 23:48:49.000000000 +0200
@@ -2,5 +2,6 @@
  
 # H.323 support
 obj-$(CONFIG_IP_NF_H323) += ip_conntrack_h323.o
+ip_conntrack_h323-objs := ip_conntrack_h323_core.o ip_conntrack_h323_h225.o ip_conntrack_h323_h245.o
 obj-$(CONFIG_IP_NF_NAT_H323) += ip_nat_h323.o
 
diff -rN -u old-h323-4/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323.c new-h323-4/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323.c
--- old-h323-4/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323.c	2005-05-10 23:48:49.000000000 +0200
+++ new-h323-4/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323.c	1970-01-01 01:00:00.000000000 +0100
@@ -1,448 +0,0 @@
-/*
- * H.323 'brute force' extension for H.323 connection tracking.
- * Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
- * (c) 2005 Max Kellermann <max@duempel.org>
- *
- * Based on ip_masq_h323.c for 2.2 kernels from CoRiTel, Sofia project.
- * (http://www.coritel.it/projects/sofia/nat/)
- * Uses Sampsa Ranta's excellent idea on using expectfn to 'bind'
- * the unregistered helpers to the conntrack entries.
- */
-
-
-#include <linux/module.h>
-#include <linux/netfilter.h>
-#include <linux/ip.h>
-#include <net/checksum.h>
-#include <net/tcp.h>
-
-#include <linux/netfilter_ipv4/lockhelp.h>
-#include <linux/netfilter_ipv4/ip_conntrack.h>
-#include <linux/netfilter_ipv4/ip_conntrack_core.h>
-#include <linux/netfilter_ipv4/ip_conntrack_helper.h>
-#include <linux/netfilter_ipv4/ip_conntrack_tuple.h>
-#include <linux/netfilter_ipv4/ip_conntrack_h323.h>
-
-MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
-MODULE_DESCRIPTION("H.323 'brute force' connection tracking module");
-MODULE_LICENSE("GPL");
-
-/* This is slow, but it's simple. --RR */
-static char h323_buffer[65536];
-
-static DECLARE_LOCK(ip_h323_lock);
-
-struct module *ip_conntrack_h323 = THIS_MODULE;
-
-int (*ip_nat_h245_hook)(struct sk_buff **pskb,
-			enum ip_conntrack_info ctinfo,
-			unsigned int offset,
-			struct ip_conntrack_expect *exp);
-EXPORT_SYMBOL_GPL(ip_nat_h245_hook);
-
-int (*ip_nat_h225_hook)(struct sk_buff **pskb,
-			enum ip_conntrack_info ctinfo,
-			unsigned int offset,
-			struct ip_conntrack_expect *exp);
-EXPORT_SYMBOL_GPL(ip_nat_h225_hook);
-
-void (*ip_nat_h225_signal_hook)(struct sk_buff **pskb,
-				struct ip_conntrack *ct,
-				enum ip_conntrack_info ctinfo,
-				unsigned int offset,
-				int dir,
-				int orig_dir);
-EXPORT_SYMBOL_GPL(ip_nat_h225_signal_hook);
-
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(format, args...)
-#endif
-
-/* FIXME: This should be in userspace.  Later. */
-static int h245_help(struct sk_buff **pskb,
-		     struct ip_conntrack *ct,
-		     enum ip_conntrack_info ctinfo)
-{
-	struct tcphdr _tcph, *tcph;
-	unsigned char *data;
-	unsigned char *data_limit;
-	unsigned dataoff, datalen;
-	int dir = CTINFO2DIR(ctinfo);
-	struct ip_conntrack_expect *exp;
-	u_int16_t data_port;
-	u_int32_t data_ip;
-	unsigned int i;
-	int ret;
-
-	/* Until there's been traffic both ways, don't look in packets. */
-	if (ctinfo != IP_CT_ESTABLISHED
-	    && ctinfo != IP_CT_ESTABLISHED + IP_CT_IS_REPLY) {
-		DEBUGP("ct_h245_help: Conntrackinfo = %u\n", ctinfo);
-		return NF_ACCEPT;
-	}
-
-	tcph = skb_header_pointer(*pskb, (*pskb)->nh.iph->ihl*4,
-				  sizeof(_tcph), &_tcph);
-	if (tcph == NULL)
-		return NF_ACCEPT;
-
-	DEBUGP("ct_h245_help: help entered %u.%u.%u.%u:%u->%u.%u.%u.%u:%u\n",
-		NIPQUAD((*pskb)->nh.iph->saddr), ntohs(tcph->source),
-		NIPQUAD((*pskb)->nh.iph->daddr), ntohs(tcph->dest));
-
-	dataoff = (*pskb)->nh.iph->ihl*4 + tcph->doff*4;
-	/* No data? */
-	if (dataoff >= (*pskb)->len) {
-		DEBUGP("ct_h245_help: skblen = %u\n", (*pskb)->len);
-		return NF_ACCEPT;
-	}
-	datalen = (*pskb)->len - dataoff;
-
-	LOCK_BH(&ip_h323_lock);
-	data = skb_header_pointer((*pskb), dataoff,
-				  datalen, h323_buffer);
-	BUG_ON(data == NULL);
-
-	data_limit = data + datalen - 6;
-	/* bytes: 0123   45
-	          ipadrr port */
-	for (i = 0; data <= data_limit; data++, i++) {
-		data_ip = *((u_int32_t *)data);
-		if (data_ip == ct->tuplehash[dir].tuple.src.ip) {
-			data_port = *((u_int16_t *)(data + 4));
-
-			/* update the H.225 info */
-			DEBUGP("ct_h245_help: new RTCP/RTP requested %u.%u.%u.%u:->%u.%u.%u.%u:%u\n",
-				NIPQUAD(ct->tuplehash[!dir].tuple.src.ip),
-				NIPQUAD((*pskb)->nh.iph->saddr), ntohs(data_port));
-
-			exp = ip_conntrack_expect_alloc();
-			if (exp == NULL) {
-				ret = NF_ACCEPT;
-				goto out;
-			}
-
-			exp->tuple = ((struct ip_conntrack_tuple)
-				{ { ct->tuplehash[!dir].tuple.src.ip,
-				    { 0 } },
-				  { data_ip,
-				    { .tcp = { data_port } },
-				    IPPROTO_UDP }});
-			exp->mask = ((struct ip_conntrack_tuple)
-				{ { 0xFFFFFFFF, { 0 } },
-				  { 0xFFFFFFFF, { .tcp = { 0xFFFF } }, 0xFF }});
-
-			exp->expectfn = NULL;
-			exp->master = ct;
-
-			if (ip_nat_h245_hook != NULL) {
-				ret = ip_nat_h245_hook(pskb, ctinfo, i,
-						       exp);
-			} else {
-				/* Can't expect this?  Best to drop packet now. */
-				if (ip_conntrack_expect_related(exp) != 0) {
-					ip_conntrack_expect_free(exp);
-					ret = NF_DROP;
-				} else
-					ret = NF_ACCEPT;
-			}
-
-			break;
-		}
-	}
-
-	ret = NF_ACCEPT;
- out:
-	UNLOCK_BH(&ip_h323_lock);
-	return ret;
-}
-
-/* H.245 helper is not registered! */
-static struct ip_conntrack_helper h245 =
-{
-	.name = "H.245",
-	.max_expected = 8,
-	.timeout = 240,
-	.tuple = { .dst = { .protonum = IPPROTO_TCP } },
-	.mask = { .src = { .u = { 0xFFFF } },
-		  .dst = { .protonum = 0xFF } },
-	.help = h245_help
-};
-
-void ip_conntrack_h245_expect(struct ip_conntrack *new,
-			      struct ip_conntrack_expect *this)
-{
-	WRITE_LOCK(&ip_conntrack_lock);
-	new->helper = &h245;
-	DEBUGP("h225_expect: helper for %p added\n", new);
-	WRITE_UNLOCK(&ip_conntrack_lock);
-}
-EXPORT_SYMBOL_GPL(ip_conntrack_h245_expect);
-
-/**
- * Parse a Q.931 CONNECT packet and handle NAT/expectations for the
- * H.245 transport address.
- */
-static int h225_parse_q931_connect(struct sk_buff **pskb,
-				   struct ip_conntrack *ct,
-				   enum ip_conntrack_info ctinfo,
-				   const unsigned char *data,
-				   unsigned i, unsigned length)
-{
-	int dir = CTINFO2DIR(ctinfo);
-	u_int32_t data_ip;
-	u_int16_t data_port;
-	struct ip_conntrack_expect *exp;
-
-	/* protocol(1) + header(3) + protocolIdentifier(6) +
-	   h245ipAddress(1) + h245ipv4(4) + h245ipv4port(2) */
-	if (length < 17)
-		return NF_ACCEPT;
-
-	if (data[i++] != 0x05) /* X.208 / X.209 */
-		return NF_ACCEPT;
-
-	/* XXX: h225 header connect? */
-	if (data[i++] != 0x22 || data[i++] != 0xc0 || data[i++] != 0x06)
-		return NF_ACCEPT;
-
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
-}
-
-/**
- * Scan a Q.931 packet for a user-to-user information element
- * (IE). Return the index, or 0 if none found.
- */
-static unsigned q931_find_u2u(const unsigned char *data,
-			      unsigned datalen,
-			      unsigned int i,
-			      unsigned *lengthp) {
-	unsigned char type;
-	unsigned length;
-
-	/* traverse all Q.931 information elements (IE) */
-	while (i + 2 <= datalen) {
-		type = data[i++];
-
-		/* highest bit set means one-byte IE */
-		if (type & 0x80)
-			continue;
-
-		length = data[i++];
-
-		if (type == 0x7e) { /* user-to-user */
-			/* user-to-user IEs have a 16 bit length
-			   field */
-			length = (length << 8) | data[i++];
-			if (i + length > datalen)
-				return 0;
-
-			*lengthp = length;
-			return i;
-		}
-
-		i += length;
-	}
-
-	return 0;
-}
-
-/**
- * Parse a Q.931/H.225 packet and handle NAT/expectations for the
- * H.245 transport address (if applicable).
- */
-static int h225_parse_q931(struct sk_buff **pskb,
-			   struct ip_conntrack *ct,
-			   enum ip_conntrack_info ctinfo,
-			   const unsigned char *data,
-			   unsigned datalen, unsigned i) {
-	u_int8_t q931_message_type;
-	unsigned length;
-
-	/* parse Q.931 packet */
-	if (data[i++] != 0x08) /* protocol discriminator */
-		return NF_ACCEPT;
-
-	/* call reference */
-	i += 1 + data[i];
-	if (i >= datalen)
-		return NF_ACCEPT;
-
-	/* only some Q.931 message types can contain a H.245 transport
-	   address - we can ignore the rest in this module */
-	q931_message_type = data[i++];
-	if (q931_message_type == 0x07) {
-		/* CONNECT */
-
-		/* find a user-to-user information element (IE) */
-		i = q931_find_u2u(data, datalen, i, &length);
-		if (i == 0)
-			return NF_ACCEPT;
-
-		return h225_parse_q931_connect(pskb, ct, ctinfo,
-					       data, i, length);
-	} else {
-		/* XXX handle q931_message_type 0x01, 0x02, 0x03 */
-		return NF_ACCEPT;
-	}
-}
-
-/**
- * Parse a TPKT/Q.931/H.225 packet and handle NAT/expectations for the
- * H.245 transport address (if applicable).
- */
-static int h225_parse_tpkt(struct sk_buff **pskb,
-			   struct ip_conntrack *ct,
-			   enum ip_conntrack_info ctinfo,
-			   const unsigned char *data,
-			   unsigned datalen) {
-	unsigned int i = 0;
-	u_int16_t tpkt_len;
-
-	/* expect TPKT header, see RFC 1006 */
-	if (data[0] != 0x03 || data[1] != 0x00)
-		return NF_ACCEPT;
-
-	i += 2;
-
-	tpkt_len = ntohs(*(u_int16_t*)(data + i));
-	if (tpkt_len < 16)
-		return NF_ACCEPT;
-
-	if (tpkt_len < datalen)
-		datalen = tpkt_len;
-
-	i += 2;
-
-	/* parse Q.931 packet */
-	return h225_parse_q931(pskb, ct, ctinfo,
-			       data, datalen, i);
-}
-
-static int h225_help(struct sk_buff **pskb,
-		     struct ip_conntrack *ct,
-		     enum ip_conntrack_info ctinfo)
-{
-	struct tcphdr _tcph, *tcph;
-	unsigned char *data;
-	unsigned dataoff, datalen;
-	int ret = NF_ACCEPT;
-
-	/* Until there's been traffic both ways, don't look in packets. */
-	if (ctinfo != IP_CT_ESTABLISHED
-	    && ctinfo != IP_CT_ESTABLISHED + IP_CT_IS_REPLY) {
-		DEBUGP("ct_h225_help: Conntrackinfo = %u\n", ctinfo);
-		return NF_ACCEPT;
-	}
-
-	tcph = skb_header_pointer((*pskb), (*pskb)->nh.iph->ihl*4,
-				  sizeof(_tcph), &_tcph);
-	if (tcph == NULL)
-		return NF_ACCEPT;
-
-	DEBUGP("ct_h225_help: help entered %u.%u.%u.%u:%u->%u.%u.%u.%u:%u\n",
-		NIPQUAD((*pskb)->nh.iph->saddr), ntohs(tcph->source),
-		NIPQUAD((*pskb)->nh.iph->daddr), ntohs(tcph->dest));
-
-	dataoff = (*pskb)->nh.iph->ihl*4 + tcph->doff*4;
-	/* No data? */
-	if (dataoff >= (*pskb)->len) {
-		DEBUGP("ct_h225_help: skblen = %u\n", (*pskb)->len);
-		return NF_ACCEPT;
-	}
-	datalen = (*pskb)->len - dataoff;
-
-	if (datalen < 32)
-		return NF_ACCEPT;
-
-	/* get data portion, and evaluate it */
-	LOCK_BH(&ip_h323_lock);
-	data = skb_header_pointer((*pskb), dataoff,
-				  datalen, h323_buffer);
-	BUG_ON(data == NULL);
-
-	ret = h225_parse_tpkt(pskb, ct, ctinfo,
-			      data, datalen);
-
-	UNLOCK_BH(&ip_h323_lock);
-	return ret;
-}
-
-static struct ip_conntrack_helper h225 =
-{
-	.name = "H.225",
-	.me = THIS_MODULE,
-	.max_expected = 2,
-	.timeout = 240,
-	.tuple = { .src = { .u = { __constant_htons(H225_PORT) } },
-		   .dst = { .protonum = IPPROTO_TCP } },
-	.mask = { .src = { .u = { 0xFFFF } },
-		  .dst = { .protonum = 0xFF } },
-	.help = h225_help
-};
-
-static int __init init(void)
-{
-	return ip_conntrack_helper_register(&h225);
-}
-
-static void __exit fini(void)
-{
-	/* Unregister H.225 helper */
-	ip_conntrack_helper_unregister(&h225);
-}
-
-module_init(init);
-module_exit(fini);
diff -rN -u old-h323-4/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323_core.c new-h323-4/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323_core.c
--- old-h323-4/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323_core.c	1970-01-01 01:00:00.000000000 +0100
+++ new-h323-4/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323_core.c	2005-05-10 23:33:19.000000000 +0200
@@ -0,0 +1,38 @@
+/*
+ * H.323 connection tracking helper
+ * (c) 2005 Max Kellermann <max@duempel.org>
+ *
+ * Based on the 'brute force' H.323 connection tracking module by
+ * Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+ */
+
+
+#include <linux/module.h>
+#include <linux/netfilter.h>
+#include <linux/ip.h>
+#include <net/checksum.h>
+#include <net/tcp.h>
+
+#include <linux/netfilter_ipv4/lockhelp.h>
+#include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/netfilter_ipv4/ip_conntrack_core.h>
+#include <linux/netfilter_ipv4/ip_conntrack_helper.h>
+#include <linux/netfilter_ipv4/ip_conntrack_tuple.h>
+#include <linux/netfilter_ipv4/ip_conntrack_h323.h>
+
+MODULE_AUTHOR("Max Kellermann <max@duempel.org>");
+MODULE_DESCRIPTION("H.323 connection tracking helper");
+MODULE_LICENSE("GPL");
+
+static int __init init(void)
+{
+	return ip_conntrack_helper_register(&ip_conntrack_helper_h225);
+}
+
+static void __exit fini(void)
+{
+	ip_conntrack_helper_unregister(&ip_conntrack_helper_h225);
+}
+
+module_init(init);
+module_exit(fini);
diff -rN -u old-h323-4/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323_h225.c new-h323-4/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323_h225.c
--- old-h323-4/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323_h225.c	1970-01-01 01:00:00.000000000 +0100
+++ new-h323-4/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323_h225.c	2005-05-10 23:33:19.000000000 +0200
@@ -0,0 +1,299 @@
+/*
+ * H.323/H.225 connection tracking helper
+ * (c) 2005 Max Kellermann <max@duempel.org>
+ *
+ * Uses Sampsa Ranta's excellent idea on using expectfn to 'bind'
+ * the unregistered helpers to the conntrack entries.
+ */
+
+
+#include <linux/module.h>
+#include <linux/netfilter.h>
+#include <linux/ip.h>
+#include <net/checksum.h>
+#include <net/tcp.h>
+
+#include <linux/netfilter_ipv4/lockhelp.h>
+#include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/netfilter_ipv4/ip_conntrack_core.h>
+#include <linux/netfilter_ipv4/ip_conntrack_helper.h>
+#include <linux/netfilter_ipv4/ip_conntrack_tuple.h>
+#include <linux/netfilter_ipv4/ip_conntrack_h323.h>
+
+/* This is slow, but it's simple. --RR */
+static char h225_buffer[65536];
+
+static DECLARE_LOCK(ip_h225_lock);
+
+int (*ip_nat_h225_hook)(struct sk_buff **pskb,
+			enum ip_conntrack_info ctinfo,
+			unsigned int offset,
+			struct ip_conntrack_expect *exp);
+EXPORT_SYMBOL_GPL(ip_nat_h225_hook);
+
+void (*ip_nat_h225_signal_hook)(struct sk_buff **pskb,
+				struct ip_conntrack *ct,
+				enum ip_conntrack_info ctinfo,
+				unsigned int offset,
+				int dir,
+				int orig_dir);
+EXPORT_SYMBOL_GPL(ip_nat_h225_signal_hook);
+
+#if 0
+#define DEBUGP printk
+#else
+#define DEBUGP(format, args...)
+#endif
+
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
+	exp->expectfn = ip_conntrack_h245_expect;
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
+static int h225_help(struct sk_buff **pskb,
+		     struct ip_conntrack *ct,
+		     enum ip_conntrack_info ctinfo)
+{
+	struct tcphdr _tcph, *tcph;
+	unsigned char *data;
+	unsigned dataoff, datalen;
+	int ret = NF_ACCEPT;
+
+	/* Until there's been traffic both ways, don't look in packets. */
+	if (ctinfo != IP_CT_ESTABLISHED
+	    && ctinfo != IP_CT_ESTABLISHED + IP_CT_IS_REPLY) {
+		DEBUGP("ct_h225_help: Conntrackinfo = %u\n", ctinfo);
+		return NF_ACCEPT;
+	}
+
+	tcph = skb_header_pointer((*pskb), (*pskb)->nh.iph->ihl*4,
+				  sizeof(_tcph), &_tcph);
+	if (tcph == NULL)
+		return NF_ACCEPT;
+
+	DEBUGP("ct_h225_help: help entered %u.%u.%u.%u:%u->%u.%u.%u.%u:%u\n",
+		NIPQUAD((*pskb)->nh.iph->saddr), ntohs(tcph->source),
+		NIPQUAD((*pskb)->nh.iph->daddr), ntohs(tcph->dest));
+
+	dataoff = (*pskb)->nh.iph->ihl*4 + tcph->doff*4;
+	/* No data? */
+	if (dataoff >= (*pskb)->len) {
+		DEBUGP("ct_h225_help: skblen = %u\n", (*pskb)->len);
+		return NF_ACCEPT;
+	}
+	datalen = (*pskb)->len - dataoff;
+
+	if (datalen < 32)
+		return NF_ACCEPT;
+
+	/* get data portion, and evaluate it */
+	LOCK_BH(&ip_h225_lock);
+	data = skb_header_pointer((*pskb), dataoff,
+				  datalen, h225_buffer);
+	BUG_ON(data == NULL);
+
+	ret = h225_parse_tpkt(pskb, ct, ctinfo,
+			      data, datalen);
+
+	UNLOCK_BH(&ip_h225_lock);
+	return ret;
+}
+
+struct ip_conntrack_helper ip_conntrack_helper_h225 =
+{
+	.name = "H.225",
+	.me = THIS_MODULE,
+	.max_expected = 2,
+	.timeout = 240,
+	.tuple = { .src = { .u = { __constant_htons(H225_PORT) } },
+		   .dst = { .protonum = IPPROTO_TCP } },
+	.mask = { .src = { .u = { 0xFFFF } },
+		  .dst = { .protonum = 0xFF } },
+	.help = h225_help
+};
+EXPORT_SYMBOL_GPL(ip_conntrack_helper_h225);
diff -rN -u old-h323-4/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323_h245.c new-h323-4/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323_h245.c
--- old-h323-4/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323_h245.c	1970-01-01 01:00:00.000000000 +0100
+++ new-h323-4/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323_h245.c	2005-05-10 23:48:49.000000000 +0200
@@ -0,0 +1,161 @@
+/*
+ * H.323/H.245 connection tracking helper
+ * (c) 2005 Max Kellermann <max@duempel.org>
+ *
+ * Based on the 'brute force' H.323 connection tracking module by
+ * Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+ */
+
+
+#include <linux/module.h>
+#include <linux/netfilter.h>
+#include <linux/ip.h>
+#include <net/checksum.h>
+#include <net/tcp.h>
+
+#include <linux/netfilter_ipv4/lockhelp.h>
+#include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/netfilter_ipv4/ip_conntrack_core.h>
+#include <linux/netfilter_ipv4/ip_conntrack_helper.h>
+#include <linux/netfilter_ipv4/ip_conntrack_tuple.h>
+#include <linux/netfilter_ipv4/ip_conntrack_h323.h>
+
+/* This is slow, but it's simple. --RR */
+static char h245_buffer[65536];
+
+static DECLARE_LOCK(ip_h245_lock);
+
+struct module *ip_conntrack_h245 = THIS_MODULE;
+
+int (*ip_nat_h245_hook)(struct sk_buff **pskb,
+			enum ip_conntrack_info ctinfo,
+			unsigned int offset,
+			struct ip_conntrack_expect *exp);
+EXPORT_SYMBOL_GPL(ip_nat_h245_hook);
+
+#if 0
+#define DEBUGP printk
+#else
+#define DEBUGP(format, args...)
+#endif
+
+/* FIXME: This should be in userspace.  Later. */
+static int h245_help(struct sk_buff **pskb,
+		     struct ip_conntrack *ct,
+		     enum ip_conntrack_info ctinfo)
+{
+	struct tcphdr _tcph, *tcph;
+	unsigned char *data;
+	unsigned char *data_limit;
+	unsigned dataoff, datalen;
+	int dir = CTINFO2DIR(ctinfo);
+	struct ip_conntrack_expect *exp;
+	u_int16_t data_port;
+	u_int32_t data_ip;
+	unsigned int i;
+	int ret;
+
+	/* Until there's been traffic both ways, don't look in packets. */
+	if (ctinfo != IP_CT_ESTABLISHED
+	    && ctinfo != IP_CT_ESTABLISHED + IP_CT_IS_REPLY) {
+		DEBUGP("ct_h245_help: Conntrackinfo = %u\n", ctinfo);
+		return NF_ACCEPT;
+	}
+
+	tcph = skb_header_pointer(*pskb, (*pskb)->nh.iph->ihl*4,
+				  sizeof(_tcph), &_tcph);
+	if (tcph == NULL)
+		return NF_ACCEPT;
+
+	DEBUGP("ct_h245_help: help entered %u.%u.%u.%u:%u->%u.%u.%u.%u:%u\n",
+		NIPQUAD((*pskb)->nh.iph->saddr), ntohs(tcph->source),
+		NIPQUAD((*pskb)->nh.iph->daddr), ntohs(tcph->dest));
+
+	dataoff = (*pskb)->nh.iph->ihl*4 + tcph->doff*4;
+	/* No data? */
+	if (dataoff >= (*pskb)->len) {
+		DEBUGP("ct_h245_help: skblen = %u\n", (*pskb)->len);
+		return NF_ACCEPT;
+	}
+	datalen = (*pskb)->len - dataoff;
+
+	LOCK_BH(&ip_h245_lock);
+	data = skb_header_pointer((*pskb), dataoff,
+				  datalen, h245_buffer);
+	BUG_ON(data == NULL);
+
+	data_limit = data + datalen - 6;
+	/* bytes: 0123   45
+	          ipadrr port */
+	for (i = 0; data <= data_limit; data++, i++) {
+		data_ip = *((u_int32_t *)data);
+		if (data_ip == ct->tuplehash[dir].tuple.src.ip) {
+			data_port = *((u_int16_t *)(data + 4));
+
+			/* update the H.225 info */
+			DEBUGP("ct_h245_help: new RTCP/RTP requested %u.%u.%u.%u:->%u.%u.%u.%u:%u\n",
+				NIPQUAD(ct->tuplehash[!dir].tuple.src.ip),
+				NIPQUAD((*pskb)->nh.iph->saddr), ntohs(data_port));
+
+			exp = ip_conntrack_expect_alloc();
+			if (exp == NULL) {
+				ret = NF_ACCEPT;
+				goto out;
+			}
+
+			exp->tuple = ((struct ip_conntrack_tuple)
+				{ { ct->tuplehash[!dir].tuple.src.ip,
+				    { 0 } },
+				  { data_ip,
+				    { .tcp = { data_port } },
+				    IPPROTO_UDP }});
+			exp->mask = ((struct ip_conntrack_tuple)
+				{ { 0xFFFFFFFF, { 0 } },
+				  { 0xFFFFFFFF, { .tcp = { 0xFFFF } }, 0xFF }});
+
+			exp->expectfn = NULL;
+			exp->master = ct;
+
+			if (ip_nat_h245_hook != NULL) {
+				ret = ip_nat_h245_hook(pskb, ctinfo, i,
+						       exp);
+			} else {
+				/* Can't expect this?  Best to drop packet now. */
+				if (ip_conntrack_expect_related(exp) != 0) {
+					ip_conntrack_expect_free(exp);
+					ret = NF_DROP;
+				} else
+					ret = NF_ACCEPT;
+			}
+
+			break;
+		}
+	}
+
+	ret = NF_ACCEPT;
+ out:
+	UNLOCK_BH(&ip_h245_lock);
+	return ret;
+}
+
+/* H.245 helper is not registered! */
+static struct ip_conntrack_helper h245 =
+{
+	.name = "H.245",
+	.max_expected = 8,
+	.timeout = 240,
+	.tuple = { .dst = { .protonum = IPPROTO_TCP } },
+	.mask = { .src = { .u = { 0xFFFF } },
+		  .dst = { .protonum = 0xFF } },
+	.help = h245_help
+};
+
+void ip_conntrack_h245_expect(struct ip_conntrack *new,
+			      struct ip_conntrack_expect *this)
+{
+	WRITE_LOCK(&ip_conntrack_lock);
+	new->helper = &h245;
+	DEBUGP("h225_expect: helper for %p added\n", new);
+	WRITE_UNLOCK(&ip_conntrack_lock);
+}
+EXPORT_SYMBOL_GPL(ip_conntrack_h245_expect);


--W5WqUoFLvi1M7tJE--
