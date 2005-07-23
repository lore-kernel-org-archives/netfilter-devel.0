From: Sven Schuster <schuster.sven@gmx.de>
Subject: Re: lockhelp.h missing
Date: Sat, 23 Jul 2005 22:52:06 +0200
Message-ID: <20050723205206.GA29011@zion.homelinux.com>
References: <debc30fc050721223469bd79d6@mail.gmail.com>
	<42E08A7A.6010204@trash.net>
	<20050722125205.GA17750@zion.homelinux.com>
	<debc30fc0507230238427b0290@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vGgW1X5XWziG23Ko"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: =?iso-8859-1?B?Suly9G1l?= Poulin <jeromepoulin@gmail.com>
Content-Disposition: inline
In-Reply-To: <debc30fc0507230238427b0290@mail.gmail.com>
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


--vGgW1X5XWziG23Ko
Content-Type: multipart/mixed; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hi J=E9r=F4me,

On Sat, Jul 23, 2005 at 05:38:23AM -0400, J=E9r=F4me Poulin told us:
> Thanks, MMS compiled without any error or warning, h323 still misses
> the file on its side.

here is a patch against current pom-ng svn to update h323-conntrack-nat
for current kernels. Please apply to your pom-ng and test it. Compile-
tested with 2.6.13-rc3-mm1.


Kind regards,

Sven

--=20
Linux zion 2.6.13-rc3-mm1 #6 PREEMPT Mon Jul 18 19:42:52 CEST 2005 i686 ath=
lon i386 GNU/Linux
 22:50:36 up 1 day,  6:00,  2 users,  load average: 0.36, 0.48, 0.27

--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="h323-2.6.12.patch"
Content-Transfer-Encoding: quoted-printable

diff -Nrup pom-ng-svn/patchlets/h323-conntrack-nat/linux-2.6.12/include/lin=
ux/netfilter_ipv4/ip_conntrack_h323.h pom-ng-h323/patchlets/h323-conntrack-=
nat/linux-2.6.12/include/linux/netfilter_ipv4/ip_conntrack_h323.h
--- pom-ng-svn/patchlets/h323-conntrack-nat/linux-2.6.12/include/linux/netf=
ilter_ipv4/ip_conntrack_h323.h	1970-01-01 01:00:00.000000000 +0100
+++ pom-ng-h323/patchlets/h323-conntrack-nat/linux-2.6.12/include/linux/net=
filter_ipv4/ip_conntrack_h323.h	2005-07-03 22:40:12.000000000 +0200
@@ -0,0 +1,38 @@
+#ifndef _IP_CONNTRACK_H323_H
+#define _IP_CONNTRACK_H323_H
+/* H.323 connection tracking. */
+
+#ifdef __KERNEL__
+
+/* Default H.225 port */
+#define H225_PORT	1720
+
+struct ip_conntrack_expect;
+struct ip_conntrack;
+struct ip_conntrack_helper;
+
+extern int (*ip_nat_h245_hook)(struct sk_buff **pskb,
+			       enum ip_conntrack_info ctinfo,
+			       unsigned int offset,
+			       struct ip_conntrack_expect *exp);
+
+extern int (*ip_nat_h225_hook)(struct sk_buff **pskb,
+			       enum ip_conntrack_info ctinfo,
+			       unsigned int offset,
+			       struct ip_conntrack_expect *exp);
+
+extern void (*ip_nat_h225_signal_hook)(struct sk_buff **pskb,
+				       struct ip_conntrack *ct,
+				       enum ip_conntrack_info ctinfo,
+				       unsigned int offset,
+				       int dir,
+				       int orig_dir);
+
+extern struct ip_conntrack_helper ip_conntrack_helper_h225;
+
+void ip_conntrack_h245_expect(struct ip_conntrack *new,
+			      struct ip_conntrack_expect *this);
+
+#endif /* __KERNEL__ */
+
+#endif /* _IP_CONNTRACK_H323_H */
diff -Nrup pom-ng-svn/patchlets/h323-conntrack-nat/linux-2.6.12/net/ipv4/ne=
tfilter/asn1_per.c pom-ng-h323/patchlets/h323-conntrack-nat/linux-2.6.12/ne=
t/ipv4/netfilter/asn1_per.c
--- pom-ng-svn/patchlets/h323-conntrack-nat/linux-2.6.12/net/ipv4/netfilter=
/asn1_per.c	1970-01-01 01:00:00.000000000 +0100
+++ pom-ng-h323/patchlets/h323-conntrack-nat/linux-2.6.12/net/ipv4/netfilte=
r/asn1_per.c	2005-07-03 22:40:12.000000000 +0200
@@ -0,0 +1,353 @@
+/*
+ * Tiny ASN.1 packet encoding rules (PER) library.
+ *
+ * This is a tiny library which helps parsing ASN.1/PER packets
+ * (i.e. read only). It is meant to be secure and small.
+ *
+ * Warning, this library may still be incomplete and buggy.
+ *
+ * (c) 2005 Max Kellermann <max@duempel.org>
+ */
+
+#include <linux/kernel.h>
+#include <linux/string.h>
+
+#include "asn1_per.h"
+
+void asn1_per_initialize(struct asn1_per_buffer *bb,
+			 const unsigned char *data,
+			 unsigned length, unsigned position) {
+	*bb =3D (struct asn1_per_buffer){
+		.data =3D data,
+		.length =3D length,
+		.i =3D position,
+		.bit =3D 8,
+		.error =3D 0,
+	};
+}
+
+int asn1_per_read_bit(struct asn1_per_buffer *bb) {
+	int value;
+
+	if (bb->error)
+		return 0;
+
+	if (bb->i >=3D bb->length) {
+		bb->error =3D 1;
+		return 0;
+	}
+
+	bb->bit--;
+
+	value =3D (bb->data[bb->i] & (1 << bb->bit)) !=3D 0;
+
+	if (bb->bit =3D=3D 0) {
+		bb->bit =3D 8;
+		bb->i++;
+	}
+
+	return value;
+}
+
+unsigned asn1_per_read_bits(struct asn1_per_buffer *bb, unsigned count) {
+	unsigned value;
+
+	if (bb->error)
+		return 0;
+	if (bb->i >=3D bb->length) {
+		bb->error =3D 1;
+		return 0;
+	}
+
+	if (count > 32) {
+		/* XXX support more than 32 bits in the future here? */
+		bb->error =3D 1;
+		return 0;
+	}
+
+	if (count <=3D bb->bit) {
+		value =3D (bb->data[bb->i] >> (bb->bit - count)) & (0xff >> (8 - count));
+
+		bb->bit -=3D count;
+		if (bb->bit =3D=3D 0) {
+			bb->bit =3D 8;
+			bb->i++;
+		}
+
+		return value;
+	}
+
+	count -=3D bb->bit;
+
+	value =3D bb->data[bb->i] & (0xff >> (8 - bb->bit));
+	bb->i++;
+
+	while (count >=3D 8) {
+		if (bb->i >=3D bb->length) {
+			bb->error =3D 1;
+			return 0;
+		}
+
+		value =3D (value << 8) | bb->data[bb->i];
+
+		bb->i++;
+		count -=3D 8;
+	}
+
+	if (count > 0) {
+		if (bb->i >=3D bb->length) {
+			bb->error =3D 1;
+			return 0;
+		}
+
+		value =3D (value << count) | (bb->data[bb->i] >> (8 - count));
+	}
+
+	bb->bit =3D 8 - count;
+
+	return value;
+}
+
+void asn1_per_read_bitmap(struct asn1_per_buffer *bb, unsigned count,
+			  struct asn1_per_bitmap *bitmap) {
+	unsigned char *p;
+
+	memset(bitmap, 0, sizeof(*bitmap));
+
+	if (bb->error)
+		return;
+
+	if (count > sizeof(bitmap->data) * 8) {
+		/* XXX limited bit map support */
+		bb->error =3D 1;
+		return;
+	}
+
+	for (p =3D bitmap->data; count > 8; count -=3D 8)
+		*p++ =3D (unsigned char)asn1_per_read_bits(bb, 8);
+
+	if (count > 0)
+		*p =3D asn1_per_read_bits(bb, count) << (8 - count);
+
+	return;
+}
+
+void asn1_per_read_bytes(struct asn1_per_buffer *bb,
+			 void *buffer, unsigned count) {
+	if (bb->error)
+		return;
+
+	if (bb->bit !=3D 8) {
+		bb->error =3D 1;
+		return;
+	}
+
+	if (bb->i + count > bb->length) {
+		bb->error =3D 1;
+		return;
+	}
+
+	memcpy(buffer, bb->data + bb->i, count);
+
+	bb->i +=3D count;
+}
+
+void asn1_per_byte_align(struct asn1_per_buffer *bb) {
+	if (bb->bit < 8) {
+		bb->bit =3D 8;
+		bb->i++;
+	}
+}
+
+static unsigned count_bits(unsigned range) {
+	unsigned bits =3D 0;
+
+	if (range =3D=3D 0)
+		return 32;
+
+	if (range =3D=3D 1)
+		return 1;
+
+	while (bits < 32 && range > (unsigned)(1 << bits))
+		bits++;
+
+	return bits;
+}
+
+unsigned asn1_per_read_unsigned(struct asn1_per_buffer *bb,
+				unsigned lower, unsigned upper) {
+	unsigned range =3D (upper - lower) + 1;
+	unsigned bits =3D count_bits(range);
+
+	if (lower =3D=3D upper)
+		return lower;
+
+	if (range =3D=3D 0 || range > 255) {
+		if (bits > 16)
+			bits =3D asn1_per_read_length(bb, 1, (bits+7)/8) * 8;
+		else if (bits > 8)
+			bits =3D 16;
+		asn1_per_byte_align(bb);
+	}
+
+	return lower + asn1_per_read_bits(bb, bits);
+}
+
+unsigned asn1_per_read_length(struct asn1_per_buffer *bb,
+			      unsigned lower, unsigned upper) {
+	if (upper < 65536)
+		return asn1_per_read_unsigned(bb, lower, upper);
+
+	asn1_per_byte_align(bb);
+
+	if (!asn1_per_read_bit(bb))
+		return asn1_per_read_bits(bb, 7);
+
+	if (!asn1_per_read_bit(bb))
+		return asn1_per_read_bits(bb, 14);
+
+	bb->error =3D 1;
+	return 0;
+}
+
+unsigned asn1_per_read_small(struct asn1_per_buffer *bb) {
+	unsigned length;
+
+	if (!asn1_per_read_bit(bb))
+		return asn1_per_read_bits(bb, 6);
+
+	length =3D asn1_per_read_length(bb, 0, INT_MAX);
+
+	asn1_per_byte_align(bb);
+
+	return asn1_per_read_bits(bb, length * 8);
+}
+
+unsigned asn1_per_read_choice_header(struct asn1_per_buffer *bb,
+				     int extendable,
+				     unsigned options, unsigned *after) {
+	int extended;
+	unsigned choice;
+
+	extended =3D extendable && asn1_per_read_bit(bb);
+	if (extended) {
+		unsigned length;
+
+		choice =3D asn1_per_read_small(bb) + options;
+		length =3D asn1_per_read_length(bb, 0, INT_MAX);
+		*after =3D bb->i + length;
+	} else if (options < 2) {
+		choice =3D 0;
+		*after =3D 0;
+	} else {
+		choice =3D asn1_per_read_bits(bb, count_bits(options));
+		*after =3D 0;
+	}
+
+	return choice;
+}
+
+void asn1_per_read_sequence_header(struct asn1_per_buffer *bb, int extenda=
ble,
+				   unsigned optional_count,
+				   struct asn1_per_sequence_header *hdr) {
+	hdr->extended =3D extendable && asn1_per_read_bit(bb);
+	asn1_per_read_bitmap(bb, optional_count, &hdr->present);
+}
+
+void asn1_per_read_sequence_extension_header(struct asn1_per_buffer *bb,
+					     const struct asn1_per_sequence_header *hdr,
+					     struct asn1_per_sequence_extension_header *ext) {
+	if (!hdr->extended) {
+		memset(ext, 0, sizeof(*ext));
+		return;
+	}
+
+	ext->count =3D asn1_per_read_small(bb) + 1;
+	if (bb->error)
+		return;
+
+	asn1_per_read_bitmap(bb, ext->count, &ext->present);
+}
+
+void asn1_per_skip_sequence_extension(struct asn1_per_buffer *bb,
+				      const struct asn1_per_sequence_header *hdr) {
+	struct asn1_per_sequence_extension_header ext;
+	unsigned i;
+
+	asn1_per_read_sequence_extension_header(bb, hdr, &ext);
+	if (bb->error)
+		return;
+
+	for (i =3D 0; i < ext.count && !bb->error; i++) {
+		if (asn1_per_bitmap_get(&ext.present, i))
+			asn1_per_skip_octet_string(bb);
+	}
+}
+
+void asn1_per_skip_object_id(struct asn1_per_buffer *bb) {
+	unsigned length;
+
+	length =3D asn1_per_read_length(bb, 0, 255);
+	switch (length) {
+	case 0:
+		break;
+
+	case 1:
+		asn1_per_read_bits(bb, 8);
+		break;
+
+	case 2:
+		asn1_per_read_bits(bb, 16);
+		break;
+
+	default:
+		asn1_per_byte_align(bb);
+
+		bb->i +=3D length;
+		if (bb->i > bb->length)
+			bb->error =3D 1;
+	}
+}
+
+unsigned asn1_per_read_octet_string_header(struct asn1_per_buffer *bb) {
+	unsigned length;
+
+	length =3D asn1_per_read_length(bb, 0, INT_MAX);
+	if (length > 2)
+		asn1_per_byte_align(bb);
+
+	return length;
+}
+
+void asn1_per_skip_octet_string(struct asn1_per_buffer *bb) {
+	unsigned length;
+
+	length =3D asn1_per_read_length(bb, 0, INT_MAX);
+	switch (length) {
+	case 0:
+		break;
+
+	case 1:
+		asn1_per_read_bits(bb, 8);
+		break;
+
+	case 2:
+		asn1_per_read_bits(bb, 16);
+		break;
+
+	default:
+		asn1_per_byte_align(bb);
+
+		bb->i +=3D length;
+		if (bb->i > bb->length)
+			bb->error =3D 1;
+	}
+}
+
+
+int asn1_per_bitmap_get(const struct asn1_per_bitmap *bitmap, unsigned i) {
+	if (i >=3D sizeof(bitmap->data) * 8)
+		return 0;
+
+	return (bitmap->data[i / 8] & (1 << (7 - (i % 8)))) !=3D 0;
+}
diff -Nrup pom-ng-svn/patchlets/h323-conntrack-nat/linux-2.6.12/net/ipv4/ne=
tfilter/asn1_per.h pom-ng-h323/patchlets/h323-conntrack-nat/linux-2.6.12/ne=
t/ipv4/netfilter/asn1_per.h
--- pom-ng-svn/patchlets/h323-conntrack-nat/linux-2.6.12/net/ipv4/netfilter=
/asn1_per.h	1970-01-01 01:00:00.000000000 +0100
+++ pom-ng-h323/patchlets/h323-conntrack-nat/linux-2.6.12/net/ipv4/netfilte=
r/asn1_per.h	2005-07-03 22:40:12.000000000 +0200
@@ -0,0 +1,83 @@
+/*
+ * Tiny ASN.1 packet encoding rules (PER) library.
+ *
+ * This is a tiny library which helps parsing ASN.1/PER packets
+ * (i.e. read only). It is meant to be secure and small.
+ *
+ * Warning, this library may still be incomplete and buggy.
+ *
+ * (c) 2005 Max Kellermann <max@duempel.org>
+ */
+
+#ifndef __ASN1_PER_H
+#define __ASN1_PER_H
+
+struct asn1_per_buffer {
+	const unsigned char *data;
+	unsigned length, i, bit;
+	int error;
+};
+
+struct asn1_per_bitmap {
+	unsigned char data[16];
+};
+
+struct asn1_per_sequence_header {
+	int extended;
+	struct asn1_per_bitmap present;
+};
+
+struct asn1_per_sequence_extension_header {
+	unsigned count;
+	struct asn1_per_bitmap present;
+};
+
+void asn1_per_initialize(struct asn1_per_buffer *bb,
+			 const unsigned char *data,
+			 unsigned length, unsigned position);
+
+int asn1_per_read_bit(struct asn1_per_buffer *bb);
+
+unsigned asn1_per_read_bits(struct asn1_per_buffer *bb, unsigned count);
+
+void asn1_per_read_bitmap(struct asn1_per_buffer *bb, unsigned count,
+			  struct asn1_per_bitmap *bitmap);
+
+void asn1_per_read_bytes(struct asn1_per_buffer *bb,
+			 void *buffer, unsigned count);
+
+void asn1_per_byte_align(struct asn1_per_buffer *bb);
+
+unsigned asn1_per_read_unsigned(struct asn1_per_buffer *bb,
+				unsigned lower, unsigned upper);
+
+unsigned asn1_per_read_length(struct asn1_per_buffer *bb,
+			      unsigned lower, unsigned upper);
+
+unsigned asn1_per_read_small(struct asn1_per_buffer *bb);
+
+unsigned asn1_per_read_choice_header(struct asn1_per_buffer *bb,
+				     int extendable,
+				     unsigned options, unsigned *after);
+
+void asn1_per_read_sequence_header(struct asn1_per_buffer *bb, int extenda=
ble,
+				   unsigned optional_count,
+				   struct asn1_per_sequence_header *hdr);
+
+void asn1_per_read_sequence_extension_header(struct asn1_per_buffer *bb,
+					     const struct asn1_per_sequence_header *hdr,
+					     struct asn1_per_sequence_extension_header *ext);
+
+void asn1_per_skip_sequence_extension(struct asn1_per_buffer *bb,
+				      const struct asn1_per_sequence_header *hdr);
+
+void asn1_per_skip_object_id(struct asn1_per_buffer *bb);
+
+unsigned asn1_per_read_octet_string_header(struct asn1_per_buffer *bb);
+
+void asn1_per_skip_octet_string(struct asn1_per_buffer *bb);
+
+
+int asn1_per_bitmap_get(const struct asn1_per_bitmap *bitmap, unsigned i);
+
+#endif
diff -Nrup pom-ng-svn/patchlets/h323-conntrack-nat/linux-2.6.12/net/ipv4/ne=
tfilter/ip_conntrack_h323.c pom-ng-h323/patchlets/h323-conntrack-nat/linux-=
2.6.12/net/ipv4/netfilter/ip_conntrack_h323.c
--- pom-ng-svn/patchlets/h323-conntrack-nat/linux-2.6.12/net/ipv4/netfilter=
/ip_conntrack_h323.c	1970-01-01 01:00:00.000000000 +0100
+++ pom-ng-h323/patchlets/h323-conntrack-nat/linux-2.6.12/net/ipv4/netfilte=
r/ip_conntrack_h323.c	2005-07-23 22:43:12.000000000 +0200
@@ -0,0 +1,447 @@
+/*
+ * H.323 'brute force' extension for H.323 connection tracking.
+ * Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+ * (c) 2005 Max Kellermann <max@duempel.org>
+ *
+ * Based on ip_masq_h323.c for 2.2 kernels from CoRiTel, Sofia project.
+ * (http://www.coritel.it/projects/sofia/nat/)
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
+#include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/netfilter_ipv4/ip_conntrack_core.h>
+#include <linux/netfilter_ipv4/ip_conntrack_helper.h>
+#include <linux/netfilter_ipv4/ip_conntrack_tuple.h>
+#include <linux/netfilter_ipv4/ip_conntrack_h323.h>
+
+MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
+MODULE_DESCRIPTION("H.323 'brute force' connection tracking module");
+MODULE_LICENSE("GPL");
+
+/* This is slow, but it's simple. --RR */
+static char h323_buffer[65536];
+
+static DEFINE_SPINLOCK(ip_h323_lock);
+
+struct module *ip_conntrack_h323 =3D THIS_MODULE;
+
+int (*ip_nat_h245_hook)(struct sk_buff **pskb,
+			enum ip_conntrack_info ctinfo,
+			unsigned int offset,
+			struct ip_conntrack_expect *exp);
+EXPORT_SYMBOL_GPL(ip_nat_h245_hook);
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
+/* FIXME: This should be in userspace.  Later. */
+static int h245_help(struct sk_buff **pskb,
+		     struct ip_conntrack *ct,
+		     enum ip_conntrack_info ctinfo)
+{
+	struct tcphdr _tcph, *tcph;
+	unsigned char *data;
+	unsigned char *data_limit;
+	unsigned dataoff, datalen;
+	int dir =3D CTINFO2DIR(ctinfo);
+	struct ip_conntrack_expect *exp;
+	u_int16_t data_port;
+	u_int32_t data_ip;
+	unsigned int i;
+	int ret;
+
+	/* Until there's been traffic both ways, don't look in packets. */
+	if (ctinfo !=3D IP_CT_ESTABLISHED
+	    && ctinfo !=3D IP_CT_ESTABLISHED + IP_CT_IS_REPLY) {
+		DEBUGP("ct_h245_help: Conntrackinfo =3D %u\n", ctinfo);
+		return NF_ACCEPT;
+	}
+
+	tcph =3D skb_header_pointer(*pskb, (*pskb)->nh.iph->ihl*4,
+				  sizeof(_tcph), &_tcph);
+	if (tcph =3D=3D NULL)
+		return NF_ACCEPT;
+
+	DEBUGP("ct_h245_help: help entered %u.%u.%u.%u:%u->%u.%u.%u.%u:%u\n",
+		NIPQUAD((*pskb)->nh.iph->saddr), ntohs(tcph->source),
+		NIPQUAD((*pskb)->nh.iph->daddr), ntohs(tcph->dest));
+
+	dataoff =3D (*pskb)->nh.iph->ihl*4 + tcph->doff*4;
+	/* No data? */
+	if (dataoff >=3D (*pskb)->len) {
+		DEBUGP("ct_h245_help: skblen =3D %u\n", (*pskb)->len);
+		return NF_ACCEPT;
+	}
+	datalen =3D (*pskb)->len - dataoff;
+
+	spin_lock_bh(&ip_h323_lock);
+	data =3D skb_header_pointer((*pskb), dataoff,
+				  datalen, h323_buffer);
+	BUG_ON(data =3D=3D NULL);
+
+	data_limit =3D data + datalen - 6;
+	/* bytes: 0123   45
+	          ipadrr port */
+	for (i =3D 0; data <=3D data_limit; data++, i++) {
+		data_ip =3D *((u_int32_t *)data);
+		if (data_ip =3D=3D ct->tuplehash[dir].tuple.src.ip) {
+			data_port =3D *((u_int16_t *)(data + 4));
+
+			/* update the H.225 info */
+			DEBUGP("ct_h245_help: new RTCP/RTP requested %u.%u.%u.%u:->%u.%u.%u.%u:=
%u\n",
+				NIPQUAD(ct->tuplehash[!dir].tuple.src.ip),
+				NIPQUAD((*pskb)->nh.iph->saddr), ntohs(data_port));
+
+			exp =3D ip_conntrack_expect_alloc();
+			if (exp =3D=3D NULL) {
+				ret =3D NF_ACCEPT;
+				goto out;
+			}
+
+			exp->tuple =3D ((struct ip_conntrack_tuple)
+				{ { ct->tuplehash[!dir].tuple.src.ip,
+				    { 0 } },
+				  { data_ip,
+				    { .tcp =3D { data_port } },
+				    IPPROTO_UDP }});
+			exp->mask =3D ((struct ip_conntrack_tuple)
+				{ { 0xFFFFFFFF, { 0 } },
+				  { 0xFFFFFFFF, { .tcp =3D { 0xFFFF } }, 0xFF }});
+
+			exp->expectfn =3D NULL;
+			exp->master =3D ct;
+
+			if (ip_nat_h245_hook !=3D NULL) {
+				ret =3D ip_nat_h245_hook(pskb, ctinfo, i,
+						       exp);
+			} else {
+				/* Can't expect this?  Best to drop packet now. */
+				if (ip_conntrack_expect_related(exp) !=3D 0) {
+					ip_conntrack_expect_free(exp);
+					ret =3D NF_DROP;
+				} else
+					ret =3D NF_ACCEPT;
+			}
+
+			break;
+		}
+	}
+
+	ret =3D NF_ACCEPT;
+ out:
+	spin_unlock_bh(&ip_h323_lock);
+	return ret;
+}
+
+/* H.245 helper is not registered! */
+static struct ip_conntrack_helper h245 =3D
+{
+	.name =3D "H.245",
+	.max_expected =3D 8,
+	.timeout =3D 240,
+	.tuple =3D { .dst =3D { .protonum =3D IPPROTO_TCP } },
+	.mask =3D { .src =3D { .u =3D { 0xFFFF } },
+		  .dst =3D { .protonum =3D 0xFF } },
+	.help =3D h245_help
+};
+
+void ip_conntrack_h245_expect(struct ip_conntrack *new,
+			      struct ip_conntrack_expect *this)
+{
+	write_lock_bh(&ip_conntrack_lock);
+	new->helper =3D &h245;
+	DEBUGP("h225_expect: helper for %p added\n", new);
+	write_unlock_bh(&ip_conntrack_lock);
+}
+EXPORT_SYMBOL_GPL(ip_conntrack_h245_expect);
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
+	int dir =3D CTINFO2DIR(ctinfo);
+	u_int32_t data_ip;
+	u_int16_t data_port;
+	struct ip_conntrack_expect *exp;
+
+	/* protocol(1) + header(3) + protocolIdentifier(6) +
+	   h245ipAddress(1) + h245ipv4(4) + h245ipv4port(2) */
+	if (length < 17)
+		return NF_ACCEPT;
+
+	if (data[i++] !=3D 0x05) /* X.208 / X.209 */
+		return NF_ACCEPT;
+
+	/* XXX: h225 header connect? */
+	if (data[i++] !=3D 0x22 || data[i++] !=3D 0xc0 || data[i++] !=3D 0x06)
+		return NF_ACCEPT;
+
+	/* protocolIdentifier, ignore the last 2 bytes (minor
+	   version) */
+	if (memcmp(data + i, "\x00\x08\x91\x4a", 4) !=3D 0)
+		return NF_ACCEPT;
+
+	i +=3D 6;
+
+	if (data[i++] !=3D 0x00) /* h245ipAddress? */
+		return NF_ACCEPT;
+
+	/* compare the IP address - this is only a valid H.245
+	   transport address, if it equals the source address of the
+	   packet */
+	data_ip =3D *(u_int32_t *)(data + i);
+	if (data_ip !=3D ct->tuplehash[dir].tuple.src.ip)
+		return NF_ACCEPT;
+
+
+	data_port =3D *((u_int16_t *)(data + i + 4));
+
+	/* match found: create an expectation */
+	exp =3D ip_conntrack_expect_alloc();
+	if (exp =3D=3D NULL)
+		return NF_ACCEPT;
+
+	exp->tuple =3D ((struct ip_conntrack_tuple)
+			{ { ct->tuplehash[!dir].tuple.src.ip,
+			    { 0 } },
+			  { ct->tuplehash[!dir].tuple.dst.ip,
+			    { .tcp =3D { data_port } },
+			    IPPROTO_TCP }});
+	exp->mask =3D ((struct ip_conntrack_tuple)
+			{ { 0xFFFFFFFF, { 0 } },
+			  { 0xFFFFFFFF, { .tcp =3D { 0xFFFF } }, 0xFF }});
+
+	exp->expectfn =3D ip_conntrack_h245_expect;
+	exp->master =3D ct;
+
+	/* call NAT hook and register expectation */
+	if (ip_nat_h225_hook !=3D NULL) {
+		return ip_nat_h225_hook(pskb, ctinfo, i,
+					exp);
+	} else {
+		/* Can't expect this?  Best to drop packet now. */
+		if (ip_conntrack_expect_related(exp) !=3D 0) {
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
+	while (i + 2 <=3D datalen) {
+		type =3D data[i++];
+
+		/* highest bit set means one-byte IE */
+		if (type & 0x80)
+			continue;
+
+		length =3D data[i++];
+
+		if (type =3D=3D 0x7e) { /* user-to-user */
+			/* user-to-user IEs have a 16 bit length
+			   field */
+			length =3D (length << 8) | data[i++];
+			if (i + length > datalen)
+				return 0;
+
+			*lengthp =3D length;
+			return i;
+		}
+
+		i +=3D length;
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
+	if (data[i++] !=3D 0x08) /* protocol discriminator */
+		return NF_ACCEPT;
+
+	/* call reference */
+	i +=3D 1 + data[i];
+	if (i >=3D datalen)
+		return NF_ACCEPT;
+
+	/* only some Q.931 message types can contain a H.245 transport
+	   address - we can ignore the rest in this module */
+	q931_message_type =3D data[i++];
+	if (q931_message_type =3D=3D 0x07) {
+		/* CONNECT */
+
+		/* find a user-to-user information element (IE) */
+		i =3D q931_find_u2u(data, datalen, i, &length);
+		if (i =3D=3D 0)
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
+	unsigned int i =3D 0;
+	u_int16_t tpkt_len;
+
+	/* expect TPKT header, see RFC 1006 */
+	if (data[0] !=3D 0x03 || data[1] !=3D 0x00)
+		return NF_ACCEPT;
+
+	i +=3D 2;
+
+	tpkt_len =3D ntohs(*(u_int16_t*)(data + i));
+	if (tpkt_len < 16)
+		return NF_ACCEPT;
+
+	if (tpkt_len < datalen)
+		datalen =3D tpkt_len;
+
+	i +=3D 2;
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
+	int ret =3D NF_ACCEPT;
+
+	/* Until there's been traffic both ways, don't look in packets. */
+	if (ctinfo !=3D IP_CT_ESTABLISHED
+	    && ctinfo !=3D IP_CT_ESTABLISHED + IP_CT_IS_REPLY) {
+		DEBUGP("ct_h225_help: Conntrackinfo =3D %u\n", ctinfo);
+		return NF_ACCEPT;
+	}
+
+	tcph =3D skb_header_pointer((*pskb), (*pskb)->nh.iph->ihl*4,
+				  sizeof(_tcph), &_tcph);
+	if (tcph =3D=3D NULL)
+		return NF_ACCEPT;
+
+	DEBUGP("ct_h225_help: help entered %u.%u.%u.%u:%u->%u.%u.%u.%u:%u\n",
+		NIPQUAD((*pskb)->nh.iph->saddr), ntohs(tcph->source),
+		NIPQUAD((*pskb)->nh.iph->daddr), ntohs(tcph->dest));
+
+	dataoff =3D (*pskb)->nh.iph->ihl*4 + tcph->doff*4;
+	/* No data? */
+	if (dataoff >=3D (*pskb)->len) {
+		DEBUGP("ct_h225_help: skblen =3D %u\n", (*pskb)->len);
+		return NF_ACCEPT;
+	}
+	datalen =3D (*pskb)->len - dataoff;
+
+	if (datalen < 32)
+		return NF_ACCEPT;
+
+	/* get data portion, and evaluate it */
+	spin_lock_bh(&ip_h323_lock);
+	data =3D skb_header_pointer((*pskb), dataoff,
+				  datalen, h323_buffer);
+	BUG_ON(data =3D=3D NULL);
+
+	ret =3D h225_parse_tpkt(pskb, ct, ctinfo,
+			      data, datalen);
+
+	spin_unlock_bh(&ip_h323_lock);
+	return ret;
+}
+
+static struct ip_conntrack_helper h225 =3D
+{
+	.name =3D "H.225",
+	.me =3D THIS_MODULE,
+	.max_expected =3D 2,
+	.timeout =3D 240,
+	.tuple =3D { .src =3D { .u =3D { __constant_htons(H225_PORT) } },
+		   .dst =3D { .protonum =3D IPPROTO_TCP } },
+	.mask =3D { .src =3D { .u =3D { 0xFFFF } },
+		  .dst =3D { .protonum =3D 0xFF } },
+	.help =3D h225_help
+};
+
+static int __init init(void)
+{
+	return ip_conntrack_helper_register(&h225);
+}
+
+static void __exit fini(void)
+{
+	/* Unregister H.225 helper */
+	ip_conntrack_helper_unregister(&h225);
+}
+
+module_init(init);
+module_exit(fini);
diff -Nrup pom-ng-svn/patchlets/h323-conntrack-nat/linux-2.6.12/net/ipv4/ne=
tfilter/ip_conntrack_h323_core.c pom-ng-h323/patchlets/h323-conntrack-nat/l=
inux-2.6.12/net/ipv4/netfilter/ip_conntrack_h323_core.c
--- pom-ng-svn/patchlets/h323-conntrack-nat/linux-2.6.12/net/ipv4/netfilter=
/ip_conntrack_h323_core.c	1970-01-01 01:00:00.000000000 +0100
+++ pom-ng-h323/patchlets/h323-conntrack-nat/linux-2.6.12/net/ipv4/netfilte=
r/ip_conntrack_h323_core.c	2005-07-23 22:44:53.000000000 +0200
@@ -0,0 +1,37 @@
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
diff -Nrup pom-ng-svn/patchlets/h323-conntrack-nat/linux-2.6.12/net/ipv4/ne=
tfilter/ip_conntrack_h323_h225.c pom-ng-h323/patchlets/h323-conntrack-nat/l=
inux-2.6.12/net/ipv4/netfilter/ip_conntrack_h323_h225.c
--- pom-ng-svn/patchlets/h323-conntrack-nat/linux-2.6.12/net/ipv4/netfilter=
/ip_conntrack_h323_h225.c	1970-01-01 01:00:00.000000000 +0100
+++ pom-ng-h323/patchlets/h323-conntrack-nat/linux-2.6.12/net/ipv4/netfilte=
r/ip_conntrack_h323_h225.c	2005-07-23 22:43:39.000000000 +0200
@@ -0,0 +1,405 @@
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
+#include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/netfilter_ipv4/ip_conntrack_core.h>
+#include <linux/netfilter_ipv4/ip_conntrack_helper.h>
+#include <linux/netfilter_ipv4/ip_conntrack_tuple.h>
+#include <linux/netfilter_ipv4/ip_conntrack_h323.h>
+
+#include "asn1_per.h"
+
+/* This is slow, but it's simple. --RR */
+static char h225_buffer[65536];
+
+static DEFINE_SPINLOCK(ip_h225_lock);
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
+ * Parse an H.225 TransportAddress and return the position of the IP
+ * address (if present). Returns 1 on success.
+ */
+static int h225_parse_transport_address(struct asn1_per_buffer *bb, unsign=
ed *i,
+					u_int32_t *ip, u_int16_t *port) {
+	unsigned choice, after;
+
+	choice =3D asn1_per_read_choice_header(bb, 1, 7, &after);
+	if (bb->error)
+		return 0;
+
+	switch (choice) {
+	case 0: /* ipAddress */
+		asn1_per_byte_align(bb);
+		*i =3D bb->i;
+		asn1_per_read_bytes(bb, ip, sizeof(*ip));
+		asn1_per_read_bytes(bb, port, sizeof(*port));
+		return !bb->error;
+
+	default:
+		if (after =3D=3D 0) {
+			DEBUGP("TransportAddress %u not yet supported\n", choice);
+			bb->error =3D 1;
+		} else {
+			bb->i =3D after;
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
+		int dir =3D CTINFO2DIR(ctinfo);
+		struct ip_conntrack_expect *exp;
+		int ret;
+		unsigned i;
+		u_int32_t ip;
+		u_int16_t port;
+
+		ret =3D h225_parse_transport_address(bb, &i, &ip, &port);
+		if (ret) {
+			DEBUGP("H.245 transportAddress: %u.%u.%u.%u:%u\n",
+			       NIPQUAD(ip), ntohs(port));
+		}
+		if (ret && ip =3D=3D ct->tuplehash[dir].tuple.src.ip) {
+			/* match found: create an expectation */
+			exp =3D ip_conntrack_expect_alloc();
+			if (exp =3D=3D NULL)
+				return NF_ACCEPT;
+
+			exp->tuple =3D ((struct ip_conntrack_tuple)
+					{ { ct->tuplehash[!dir].tuple.src.ip,
+					    { 0 } },
+					  { ct->tuplehash[!dir].tuple.dst.ip,
+					    { .tcp =3D { port } },
+					    IPPROTO_TCP }});
+			exp->mask =3D ((struct ip_conntrack_tuple)
+					{ { 0xFFFFFFFF, { 0 } },
+					  { 0xFFFFFFFF, { .tcp =3D { 0xFFFF } }, 0xFF }});
+
+			exp->expectfn =3D ip_conntrack_h245_expect;
+			exp->master =3D ct;
+
+			/* call NAT hook and register expectation */
+			if (ip_nat_h225_hook !=3D NULL) {
+				return ip_nat_h225_hook(pskb, ctinfo, i,
+							exp);
+			} else {
+				/* Can't expect this?  Best to drop packet now. */
+				if (ip_conntrack_expect_related(exp) !=3D 0) {
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
+	bb->error =3D 1;
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
+	choice =3D asn1_per_read_choice_header(bb, 1, 7, &after);
+	switch (choice) {
+	case 2: /* connect */
+		ret =3D h225_parse_connect_uuie(pskb, ct, ctinfo, bb);
+		if (ret !=3D NF_ACCEPT)
+			return ret;
+		break;
+
+	default:
+		if (after =3D=3D 0) {
+			bb->error =3D 1;
+			return NF_ACCEPT;
+		}
+
+		bb->i =3D after;
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
+ * Parse a Q.931 CONNECT packet and handle NAT/expectations for the
+ * H.245 transport address.
+ */
+static int h225_parse_q931_connect(struct sk_buff **pskb,
+				   struct ip_conntrack *ct,
+				   enum ip_conntrack_info ctinfo,
+				   const unsigned char *data,
+				   unsigned i, unsigned length)
+{
+	struct asn1_per_buffer bb;
+
+	if (i + 2 > length)
+		return NF_ACCEPT;
+
+	if (data[i++] !=3D 0x05) /* X.208 / X.209 */
+		return NF_ACCEPT;
+
+	asn1_per_initialize(&bb, data, length, i);
+
+	return h225_parse(pskb, ct, ctinfo, &bb);
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
+	while (i + 2 <=3D datalen) {
+		type =3D data[i++];
+
+		/* highest bit set means one-byte IE */
+		if (type & 0x80)
+			continue;
+
+		length =3D data[i++];
+
+		if (type =3D=3D 0x7e) { /* user-to-user */
+			/* user-to-user IEs have a 16 bit length
+			   field */
+			length =3D (length << 8) | data[i++];
+			if (i + length > datalen)
+				return 0;
+
+			*lengthp =3D length;
+			return i;
+		}
+
+		i +=3D length;
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
+	if (i + 3 > datalen)
+		return NF_ACCEPT;
+
+	/* parse Q.931 packet */
+	if (data[i++] !=3D 0x08) /* protocol discriminator */
+		return NF_ACCEPT;
+
+	/* call reference */
+	i +=3D 1 + data[i];
+	if (i >=3D datalen)
+		return NF_ACCEPT;
+
+	/* only some Q.931 message types can contain a H.245 transport
+	   address - we can ignore the rest in this module */
+	q931_message_type =3D data[i++];
+	if (q931_message_type =3D=3D 0x07) {
+		/* CONNECT */
+
+		/* find a user-to-user information element (IE) */
+		i =3D q931_find_u2u(data, datalen, i, &length);
+		if (i =3D=3D 0)
+			return NF_ACCEPT;
+
+		/* the length returned by q931_find_u2u() is relative
+		   to i */
+		length +=3D i;
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
+	unsigned int i =3D 0;
+	u_int16_t tpkt_len;
+
+	if (i + 4 > datalen)
+		return NF_ACCEPT;
+
+	/* expect TPKT header, see RFC 1006 */
+	if (data[0] !=3D 0x03 || data[1] !=3D 0x00)
+		return NF_ACCEPT;
+
+	i +=3D 2;
+
+	tpkt_len =3D ntohs(*(u_int16_t*)(data + i));
+	if (tpkt_len < datalen)
+		datalen =3D tpkt_len;
+
+	i +=3D 2;
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
+	int ret =3D NF_ACCEPT;
+
+	/* Until there's been traffic both ways, don't look in packets. */
+	if (ctinfo !=3D IP_CT_ESTABLISHED
+	    && ctinfo !=3D IP_CT_ESTABLISHED + IP_CT_IS_REPLY) {
+		DEBUGP("ct_h225_help: Conntrackinfo =3D %u\n", ctinfo);
+		return NF_ACCEPT;
+	}
+
+	tcph =3D skb_header_pointer((*pskb), (*pskb)->nh.iph->ihl*4,
+				  sizeof(_tcph), &_tcph);
+	if (tcph =3D=3D NULL)
+		return NF_ACCEPT;
+
+	DEBUGP("ct_h225_help: help entered %u.%u.%u.%u:%u->%u.%u.%u.%u:%u\n",
+		NIPQUAD((*pskb)->nh.iph->saddr), ntohs(tcph->source),
+		NIPQUAD((*pskb)->nh.iph->daddr), ntohs(tcph->dest));
+
+	dataoff =3D (*pskb)->nh.iph->ihl*4 + tcph->doff*4;
+	/* No data? */
+	if (dataoff >=3D (*pskb)->len) {
+		DEBUGP("ct_h225_help: skblen =3D %u\n", (*pskb)->len);
+		return NF_ACCEPT;
+	}
+	datalen =3D (*pskb)->len - dataoff;
+
+	if (datalen < 16)
+		return NF_ACCEPT;
+
+	/* get data portion, and evaluate it */
+	spin_lock_bh(&ip_h225_lock);
+	data =3D skb_header_pointer((*pskb), dataoff,
+				  datalen, h225_buffer);
+	BUG_ON(data =3D=3D NULL);
+
+	ret =3D h225_parse_tpkt(pskb, ct, ctinfo,
+			      data, datalen);
+
+	spin_unlock_bh(&ip_h225_lock);
+	return ret;
+}
+
+struct ip_conntrack_helper ip_conntrack_helper_h225 =3D
+{
+	.name =3D "H.225",
+	.me =3D THIS_MODULE,
+	.max_expected =3D 2,
+	.timeout =3D 240,
+	.tuple =3D { .src =3D { .u =3D { __constant_htons(H225_PORT) } },
+		   .dst =3D { .protonum =3D IPPROTO_TCP } },
+	.mask =3D { .src =3D { .u =3D { 0xFFFF } },
+		  .dst =3D { .protonum =3D 0xFF } },
+	.help =3D h225_help
+};
+EXPORT_SYMBOL_GPL(ip_conntrack_helper_h225);
diff -Nrup pom-ng-svn/patchlets/h323-conntrack-nat/linux-2.6.12/net/ipv4/ne=
tfilter/ip_conntrack_h323_h245.c pom-ng-h323/patchlets/h323-conntrack-nat/l=
inux-2.6.12/net/ipv4/netfilter/ip_conntrack_h323_h245.c
--- pom-ng-svn/patchlets/h323-conntrack-nat/linux-2.6.12/net/ipv4/netfilter=
/ip_conntrack_h323_h245.c	1970-01-01 01:00:00.000000000 +0100
+++ pom-ng-h323/patchlets/h323-conntrack-nat/linux-2.6.12/net/ipv4/netfilte=
r/ip_conntrack_h323_h245.c	2005-07-23 22:44:22.000000000 +0200
@@ -0,0 +1,959 @@
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
+#include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/netfilter_ipv4/ip_conntrack_core.h>
+#include <linux/netfilter_ipv4/ip_conntrack_helper.h>
+#include <linux/netfilter_ipv4/ip_conntrack_tuple.h>
+#include <linux/netfilter_ipv4/ip_conntrack_h323.h>
+
+#include "asn1_per.h"
+
+/* This is slow, but it's simple. --RR */
+static char h245_buffer[65536];
+
+static DEFINE_SPINLOCK(ip_h245_lock);
+
+struct module *ip_conntrack_h245 =3D THIS_MODULE;
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
+/**
+ * Skip an H.245 NonStandardIdentifier, discarding its value.
+ */
+static void h245_skip_nonstandard_id(struct asn1_per_buffer *bb) {
+	unsigned choice;
+
+	choice =3D asn1_per_read_bits(bb, 1);
+	switch (choice) {
+	case 0:
+		asn1_per_skip_object_id(bb);
+		break;
+
+	case 1:
+		asn1_per_read_unsigned(bb, 0, 255);
+		asn1_per_read_unsigned(bb, 0, 255);
+		asn1_per_read_unsigned(bb, 0, 65535);
+		break;
+	}
+}
+
+/**
+ * Skip an H.245 NonStandardParameter, discarding its value.
+ */
+static void h245_skip_nonstandard_param(struct asn1_per_buffer *bb) {
+	h245_skip_nonstandard_id(bb);
+	asn1_per_skip_octet_string(bb);
+}
+
+/**
+ * Skip an H.245 VideoCapability, discarding its value.
+ */
+static void h245_skip_video_capability(struct asn1_per_buffer *bb) {
+	unsigned choice, after;
+
+	choice =3D asn1_per_read_choice_header(bb, 1, 5, &after);
+	DEBUGP("video_capability: choice=3D%u after=3D%u error=3D%d\n",
+	       choice, after, bb->error);
+
+	if (bb->error)
+		return;
+
+	/* XXX support the rest */
+	switch (choice) {
+	case 0: /* nonStandard */
+		h245_skip_nonstandard_param(bb);
+		break;
+
+	default:
+		if (after =3D=3D 0) {
+			DEBUGP("unsupported audio_capability %u\n", choice);
+			bb->error =3D 1;
+		}
+	}
+
+	if (after > 0)
+		bb->i =3D after;
+}
+
+/**
+ * Skip an H.245 AudioCapability, discarding its value.
+ */
+static void h245_skip_audio_capability(struct asn1_per_buffer *bb) {
+	unsigned choice, after;
+
+	choice =3D asn1_per_read_choice_header(bb, 1, 14, &after);
+	DEBUGP("audio_capability: audio_capability=3D%u after=3D%u error=3D%d\n",=
 choice, after, bb->error);
+
+	if (bb->error)
+		return;
+
+	/* XXX support the rest */
+	switch (choice) {
+		unsigned value;
+
+	case 0: /* nonStandard */
+		h245_skip_nonstandard_param(bb);
+		break;
+
+	case 1:
+	case 2:
+	case 3:
+	case 4:
+	case 5:
+	case 6:
+	case 7:
+	case 9:
+	case 10:
+	case 11:
+	case 14:
+	case 17:
+		value =3D asn1_per_read_unsigned(bb, 1, 256);
+		DEBUGP("value %u =3D %u\n", choice, value);
+		break;
+	default:
+		if (after =3D=3D 0) {
+			DEBUGP("unsupported audio_capability %u\n", choice);
+			bb->error =3D 1;
+		}
+	}
+
+	if (after > 0)
+		bb->i =3D after;
+}
+
+/**
+ * Skip an H.245 DataType, discarding its value.
+ */
+static void h245_skip_data_type(struct asn1_per_buffer *bb) {
+	unsigned choice, after;
+
+	choice =3D asn1_per_read_choice_header(bb, 1, 6, &after);
+
+	if (bb->error)
+		return;
+
+	/* XXX support the rest */
+	switch (choice) {
+	case 0: /* nonStandard */
+		h245_skip_nonstandard_param(bb);
+		break;
+
+	case 1: /* nullData */
+		break;
+
+	case 2: /* videoData */
+		h245_skip_video_capability(bb);
+		break;
+
+	case 3: /* audioData */
+		h245_skip_audio_capability(bb);
+		break;
+
+	default:
+		if (after =3D=3D 0) {
+			DEBUGP("unsupported data_type %u\n", choice);
+			bb->error =3D 1;
+		}
+	}
+
+	if (after > 0)
+		bb->i =3D after;
+}
+
+/**
+ * Parse an H.245 UnicastAddress and return the position of the IP
+ * address (if present). Returns 1 on success.
+ */
+static int h245_parse_unicast_address(struct asn1_per_buffer *bb, unsigned=
 *i,
+				      u_int32_t *ip, u_int16_t *port) {
+	unsigned choice, after;
+
+	choice =3D asn1_per_read_choice_header(bb, 1, 5, &after);
+	DEBUGP("Parsing UnicastAddress choice=3D%u after=3D%u\n", choice, after);
+	switch (choice) {
+	case 0: /* iPAddress */
+		asn1_per_read_bit(bb); /* XXX use this bit */
+		asn1_per_byte_align(bb);
+		*i =3D bb->i;
+		asn1_per_read_bytes(bb, ip, sizeof(*ip));
+		asn1_per_read_bytes(bb, port, sizeof(*port));
+		return !bb->error;
+	default:
+		if (after =3D=3D 0) {
+			DEBUGP("UnicastAddress %u not yet supported\n", choice);
+			bb->error =3D 1;
+		} else {
+			bb->i =3D after;
+		}
+		return 0;
+	}
+}
+
+/**
+ * Parse an H.245 TransportAddress and return the position of the
+ * Unicast IP address (if present). Returns 1 on success.
+ */
+static int h245_parse_transport_address(struct asn1_per_buffer *bb, unsign=
ed *i,
+					u_int32_t *ip, u_int16_t *port) {
+	unsigned choice, after;
+
+	choice =3D asn1_per_read_choice_header(bb, 1, 2, &after);
+	switch (choice) {
+	case 0: /* UnicastAddress */
+		return h245_parse_unicast_address(bb, i, ip, port);
+	case 1: /* MulticastAddress */
+		/* XXX */
+		DEBUGP("MulticastAddress not yet supported\n");
+		bb->error =3D 1;
+		return 0;
+	default:
+		if (after =3D=3D 0) {
+			DEBUGP("ERROR7\n");
+			bb->error =3D 1;
+		} else {
+			bb->i =3D after;
+		}
+		return 0;
+	}
+}
+
+/**
+ * Skip an H.245 TerminalLabel, discarding its value.
+ */
+static void h245_skip_terminal_label(struct asn1_per_buffer *bb) {
+	struct asn1_per_sequence_header hdr;
+
+	asn1_per_read_sequence_header(bb, 1, 0, &hdr);
+
+	/* mcuNumber */
+	asn1_per_read_unsigned(bb, 0, 192);
+	/* terminalNumber */
+	asn1_per_read_unsigned(bb, 0, 192);
+
+	asn1_per_skip_sequence_extension(bb, &hdr);
+}
+
+/**
+ * Parse an H.245 H2250LogicalChannelParameters request packet and
+ * handle NAT/expectations for the logical channel address.
+ */
+static int h245_parse_h2250_lchannel_params(struct sk_buff **pskb,
+					    struct ip_conntrack *ct,
+					    enum ip_conntrack_info ctinfo,
+					    struct asn1_per_buffer *bb) {
+	struct asn1_per_sequence_header hdr;
+	unsigned session_id;
+
+	asn1_per_read_sequence_header(bb, 1, 10, &hdr);
+
+	/* nonStandard */
+	if (asn1_per_bitmap_get(&hdr.present, 0))
+		h245_skip_nonstandard_param(bb);
+
+	/* sessionID */
+	session_id =3D asn1_per_read_unsigned(bb, 0, 255);
+
+	/* associatedSessionID */
+	if (asn1_per_bitmap_get(&hdr.present, 1))
+		asn1_per_read_unsigned(bb, 1, 255);
+
+	/* mediaChannel */
+	DEBUGP("lchannel_params mediaChannel: i=3D%u bit=3D%u\n", bb->i, bb->bit);
+	if (asn1_per_bitmap_get(&hdr.present, 2)) {
+		int dir =3D CTINFO2DIR(ctinfo);
+		struct ip_conntrack_expect *exp;
+		int ret;
+		unsigned i;
+		u_int32_t ip;
+		u_int16_t port;
+
+		ret =3D h245_parse_transport_address(bb, &i, &ip, &port);
+		if (ret)
+			DEBUGP("mediaChannel IPv4 address: %u.%u.%u.%u:%u\n",
+			       NIPQUAD(ip), ntohs(port));
+		if (ret && ip =3D=3D ct->tuplehash[dir].tuple.src.ip) {
+			/* match found: create an expectation */
+			exp =3D ip_conntrack_expect_alloc();
+			if (exp =3D=3D NULL)
+				return NF_ACCEPT;
+
+			exp->tuple =3D ((struct ip_conntrack_tuple)
+					{ { ct->tuplehash[!dir].tuple.src.ip,
+					    { 0 } },
+					  { ct->tuplehash[!dir].tuple.dst.ip,
+					    { .udp =3D { port } },
+					    IPPROTO_UDP }});
+			exp->mask =3D ((struct ip_conntrack_tuple)
+					{ { 0xFFFFFFFF, { 0 } },
+					  { 0xFFFFFFFF, { .udp =3D { 0xFFFF } }, 0xFF }});
+
+			exp->master =3D ct;
+
+			/* call NAT hook and register expectation */
+			if (ip_nat_h245_hook !=3D NULL) {
+				return ip_nat_h245_hook(pskb, ctinfo, i,
+							exp);
+			} else {
+				/* Can't expect this?  Best to drop packet now. */
+				if (ip_conntrack_expect_related(exp) !=3D 0) {
+					ip_conntrack_expect_free(exp);
+					return NF_DROP;
+				} else {
+					return NF_ACCEPT;
+				}
+			}
+		}
+	}
+
+	/* mediaGuaranteedDelivery */
+	if (asn1_per_bitmap_get(&hdr.present, 3))
+		asn1_per_read_bit(bb);
+
+	/* mediaControlChannel */
+	DEBUGP("lchannel_params controlChannel: i=3D%u bit=3D%u\n", bb->i, bb->bi=
t);
+	if (asn1_per_bitmap_get(&hdr.present, 4)) {
+		int dir =3D CTINFO2DIR(ctinfo);
+		struct ip_conntrack_expect *exp;
+		int ret;
+		unsigned i;
+		u_int32_t ip;
+		u_int16_t port;
+
+		ret =3D h245_parse_transport_address(bb, &i, &ip, &port);
+		if (ret)
+			DEBUGP("mediaControlChannel IPv4 address: %u.%u.%u.%u:%u\n",
+			       NIPQUAD(ip), ntohs(port));
+		if (ret && ip =3D=3D ct->tuplehash[dir].tuple.src.ip) {
+			/* match found: create an expectation */
+			exp =3D ip_conntrack_expect_alloc();
+			if (exp =3D=3D NULL)
+				return NF_ACCEPT;
+
+			exp->tuple =3D ((struct ip_conntrack_tuple)
+					{ { ct->tuplehash[!dir].tuple.src.ip,
+					    { 0 } },
+					  { ct->tuplehash[!dir].tuple.dst.ip,
+					    { .udp =3D { port } },
+					    IPPROTO_UDP }});
+			exp->mask =3D ((struct ip_conntrack_tuple)
+					{ { 0xFFFFFFFF, { 0 } },
+					  { 0xFFFFFFFF, { .udp =3D { 0xFFFF } }, 0xFF }});
+
+			exp->master =3D ct;
+
+			/* call NAT hook and register expectation */
+			if (ip_nat_h245_hook !=3D NULL) {
+				return ip_nat_h245_hook(pskb, ctinfo, i,
+							exp);
+			} else {
+				/* Can't expect this?  Best to drop packet now. */
+				if (ip_conntrack_expect_related(exp) !=3D 0) {
+					ip_conntrack_expect_free(exp);
+					return NF_DROP;
+				} else {
+					return NF_ACCEPT;
+				}
+			}
+		}
+	}
+
+	/* mediaControlGuaranteedDelivery */
+	if (asn1_per_bitmap_get(&hdr.present, 5))
+		asn1_per_read_bit(bb);
+
+	/* silenceSuppression */
+	if (asn1_per_bitmap_get(&hdr.present, 6))
+		asn1_per_read_bit(bb);
+
+	/* destination */
+	if (asn1_per_bitmap_get(&hdr.present, 7))
+		h245_skip_terminal_label(bb);
+
+	/* dynamicRTPPayloadType */
+	if (asn1_per_bitmap_get(&hdr.present, 8))
+		asn1_per_read_unsigned(bb, 96, 127);
+
+	/* mediaPacketization */
+	if (asn1_per_bitmap_get(&hdr.present, 9)) {
+		unsigned choice, after;
+
+		choice =3D asn1_per_read_choice_header(bb, 1, 1, &after);
+		switch (choice) {
+		case 0: /* h261aVideoPacketization */
+			break;
+
+		default:
+			if (after =3D=3D 0) {
+				DEBUGP("ERROR7\n");
+				bb->error =3D 1;
+				return NF_ACCEPT;
+			}
+
+			bb->i =3D after;
+		}
+	}
+
+	/* XXX */
+
+	asn1_per_skip_sequence_extension(bb, &hdr);
+
+	return NF_ACCEPT;
+}
+
+/**
+ * Parse an H.245 OpenLogicalChannel request packet and handle
+ * NAT/expectations for the logical channel address.
+ */
+static int h245_parse_open_lchannel(struct sk_buff **pskb,
+				    struct ip_conntrack *ct,
+				    enum ip_conntrack_info ctinfo,
+				    struct asn1_per_buffer *bb) {
+	struct asn1_per_sequence_header hdr, hdr2;
+	unsigned forwardLogicalChannelNumber;
+	unsigned choice, after;
+
+	asn1_per_read_sequence_header(bb, 1, 1, &hdr);
+
+	forwardLogicalChannelNumber =3D asn1_per_read_unsigned(bb, 1, 65535);
+
+	/* entering forwardLogicalChannelParameters */
+	asn1_per_read_sequence_header(bb, 1, 1, &hdr2);
+	if (asn1_per_bitmap_get(&hdr2.present, 0))
+		asn1_per_read_unsigned(bb, 0, 65535);
+
+	h245_skip_data_type(bb);
+
+	/* multiplexParameters */
+	choice =3D asn1_per_read_choice_header(bb, 1, 3, &after);
+	if (bb->error)
+		return NF_ACCEPT;
+
+	switch (choice) {
+	case 3: /* h2250LogicalChannelParameters */
+		h245_parse_h2250_lchannel_params(pskb, ct, ctinfo, bb);
+		break;
+	default:
+		if (after =3D=3D 0) {
+			DEBUGP("unsupported multiplex_parameter %u\n", choice);
+			bb->error =3D 1;
+			return NF_ACCEPT;
+		}
+	}
+
+	if (bb->error)
+		return NF_ACCEPT;
+
+	if (after > 0)
+		bb->i =3D after;
+
+	asn1_per_skip_sequence_extension(bb, &hdr2);
+
+	/* leaving multiplexParameters, forwardLogicalChannelParameters */
+
+	/* reverseLogicalChannelParameters */
+	if (asn1_per_bitmap_get(&hdr.present, 0)) {
+		asn1_per_read_sequence_header(bb, 1, 1, &hdr2);
+
+		h245_skip_data_type(bb);
+
+		/* multiplexParameters */
+		if (asn1_per_bitmap_get(&hdr2.present, 0)) {
+			choice =3D asn1_per_read_choice_header(bb, 1, 2, &after);
+			if (bb->error)
+				return NF_ACCEPT;
+
+			DEBUGP("reverse_parameter multiplex=3D%u after=3D%u\n", choice, after);
+
+			switch (choice) {
+			case 2: /* h2250LogicalChannelParameters */
+				h245_parse_h2250_lchannel_params(pskb, ct, ctinfo, bb);
+				break;
+			default:
+				if (after =3D=3D 0) {
+					DEBUGP("unsupported multiplex_parameter %u\n", choice);
+					bb->error =3D 1;
+					return NF_ACCEPT;
+				}
+			}
+
+			if (bb->error)
+				return NF_ACCEPT;
+
+			if (after > 0)
+				bb->i =3D after;
+		}
+
+		asn1_per_skip_sequence_extension(bb, &hdr2);
+	}
+
+	asn1_per_skip_sequence_extension(bb, &hdr);
+
+	/* XXX */
+	return NF_ACCEPT;
+}
+
+/**
+ * Parse an H.245 request packet and handle NAT/expectations for the
+ * logical channel address.
+ */
+static int h245_parse_request(struct sk_buff **pskb,
+			      struct ip_conntrack *ct,
+			      enum ip_conntrack_info ctinfo,
+			      struct asn1_per_buffer *bb) {
+	unsigned choice, after;
+
+	choice =3D asn1_per_read_choice_header(bb, 1, 11, &after);
+	DEBUGP("H.245: message_type=3D%u\n", choice);
+	switch (choice) {
+	case 3:
+		return h245_parse_open_lchannel(pskb, ct, ctinfo, bb);
+	default:
+		return NF_ACCEPT;
+	}
+}
+
+/**
+ * Parse an H.245 H222LogicalChannelParameters response packet and
+ * handle NAT/expectations for the logical channel address.
+ */
+static int h245_parse_h222_lchannel_params(struct sk_buff **pskb,
+					   struct ip_conntrack *ct,
+					   enum ip_conntrack_info ctinfo,
+					   struct asn1_per_buffer *bb) {
+	struct asn1_per_sequence_header hdr;
+
+	asn1_per_read_sequence_header(bb, 1, 3, &hdr);
+
+	if (bb->error)
+		return NF_ACCEPT;
+
+	/* resourceID */
+	asn1_per_read_unsigned(bb, 0, 65535);
+
+	/* subChannelID */
+	asn1_per_read_unsigned(bb, 0, 8191);
+
+	/* pcr-pid */
+	if (asn1_per_bitmap_get(&hdr.present, 0))
+		asn1_per_read_unsigned(bb, 0, 8191);
+
+	/* programDescriptors */
+	if (asn1_per_bitmap_get(&hdr.present, 1))
+		asn1_per_skip_octet_string(bb);
+
+	/* streamDescriptors */
+	if (asn1_per_bitmap_get(&hdr.present, 2))
+		asn1_per_skip_octet_string(bb);
+
+	asn1_per_skip_sequence_extension(bb, &hdr);
+
+	return NF_ACCEPT;
+}
+
+/**
+ * Parse an H.245 H2250LogicalChannelAckParameters response packet and
+ * handle NAT/expectations for the logical channel address.
+ */
+static int h245_parse_h2250_lchannel_ack_params(struct sk_buff **pskb,
+						struct ip_conntrack *ct,
+						enum ip_conntrack_info ctinfo,
+						struct asn1_per_buffer *bb) {
+	struct asn1_per_sequence_header hdr;
+	unsigned count;
+
+	DEBUGP("entering h245_parse_h2250_lchannel_ack_params\n");
+
+	asn1_per_read_sequence_header(bb, 1, 5, &hdr);
+
+	/* nonStandard */
+	if (asn1_per_bitmap_get(&hdr.present, 0)) {
+		count =3D asn1_per_read_length(bb, 0, UINT_MAX);
+		while (count > 0) {
+			h245_skip_nonstandard_param(bb);
+			if (bb->error)
+				return NF_ACCEPT;
+		}
+	}
+
+	/* sessionID */
+	if (asn1_per_bitmap_get(&hdr.present, 1))
+		asn1_per_read_unsigned(bb, 1, 255);
+
+	/* mediaChannel */
+	if (asn1_per_bitmap_get(&hdr.present, 2)) {
+		int ret;
+		unsigned i;
+		u_int32_t ip;
+		u_int16_t port;
+		int dir =3D CTINFO2DIR(ctinfo);
+		struct ip_conntrack_expect *exp;
+
+		ret =3D h245_parse_transport_address(bb, &i, &ip, &port);
+		DEBUGP("entering mediaChannel ret=3D%d i=3D%u ip=3D%x port=3D%u\n",
+		       ret, i, ip, port);
+		if (ret && ip =3D=3D ct->tuplehash[dir].tuple.src.ip) {
+			/* match found: create an expectation */
+			exp =3D ip_conntrack_expect_alloc();
+			if (exp =3D=3D NULL)
+				return NF_ACCEPT;
+
+			exp->tuple =3D ((struct ip_conntrack_tuple)
+					{ { ct->tuplehash[!dir].tuple.src.ip,
+					    { 0 } },
+					  { ct->tuplehash[!dir].tuple.dst.ip,
+					    { .udp =3D { port } },
+					    IPPROTO_UDP }});
+			exp->mask =3D ((struct ip_conntrack_tuple)
+					{ { 0xFFFFFFFF, { 0 } },
+					  { 0xFFFFFFFF, { .udp =3D { 0xFFFF } }, 0xFF }});
+
+			exp->master =3D ct;
+
+			/* call NAT hook and register expectation */
+			if (ip_nat_h245_hook !=3D NULL) {
+				ret =3D ip_nat_h245_hook(pskb, ctinfo, i, exp);
+				if (ret !=3D NF_ACCEPT)
+					return ret;
+			} else {
+				/* Can't expect this?  Best to drop packet now. */
+				if (ip_conntrack_expect_related(exp) !=3D 0) {
+					ip_conntrack_expect_free(exp);
+					return NF_DROP;
+				} else {
+					return NF_ACCEPT;
+				}
+			}
+		}
+	}
+
+	/* mediaControlChannel */
+	if (asn1_per_bitmap_get(&hdr.present, 3)) {
+		int ret;
+		unsigned i;
+		u_int32_t ip;
+		u_int16_t port;
+		int dir =3D CTINFO2DIR(ctinfo);
+		struct ip_conntrack_expect *exp;
+
+		ret =3D h245_parse_transport_address(bb, &i, &ip, &port);
+		DEBUGP("entering mediaControlChannel ret=3D%d i=3D%u ip=3D%x port=3D%u\n=
",
+		       ret, i, ip, port);
+		if (ret && ip =3D=3D ct->tuplehash[dir].tuple.src.ip) {
+			/* match found: create an expectation */
+			exp =3D ip_conntrack_expect_alloc();
+			if (exp =3D=3D NULL)
+				return NF_ACCEPT;
+
+			exp->tuple =3D ((struct ip_conntrack_tuple)
+					{ { ct->tuplehash[!dir].tuple.src.ip,
+					    { 0 } },
+					  { ct->tuplehash[!dir].tuple.dst.ip,
+					    { .udp =3D { port } },
+					    IPPROTO_UDP }});
+			exp->mask =3D ((struct ip_conntrack_tuple)
+					{ { 0xFFFFFFFF, { 0 } },
+					  { 0xFFFFFFFF, { .udp =3D { 0xFFFF } }, 0xFF }});
+
+			exp->master =3D ct;
+
+			/* call NAT hook and register expectation */
+			if (ip_nat_h245_hook !=3D NULL) {
+				ret =3D ip_nat_h245_hook(pskb, ctinfo, i, exp);
+				if (ret !=3D NF_ACCEPT)
+					return ret;
+			} else {
+				/* Can't expect this?  Best to drop packet now. */
+				if (ip_conntrack_expect_related(exp) !=3D 0) {
+					ip_conntrack_expect_free(exp);
+					return NF_DROP;
+				} else {
+					return NF_ACCEPT;
+				}
+			}
+		}
+	}
+
+	/* dynamicRTPPayloadType */
+	if (asn1_per_bitmap_get(&hdr.present, 1))
+		asn1_per_read_unsigned(bb, 96, 127);
+
+	asn1_per_skip_sequence_extension(bb, &hdr);
+
+	return NF_ACCEPT;
+}
+
+/**
+ * Parse an H.245 OpenLogicalChannelAck response packet and handle
+ * NAT/expectations for the logical channel address.
+ */
+static int h245_parse_open_lchannel_ack(struct sk_buff **pskb,
+					struct ip_conntrack *ct,
+					enum ip_conntrack_info ctinfo,
+					struct asn1_per_buffer *bb) {
+	struct asn1_per_sequence_header hdr, hdr2;
+	struct asn1_per_sequence_extension_header ext;
+	unsigned forwardLogicalChannelNumber;
+	unsigned choice, after, after2, i;
+
+	asn1_per_read_sequence_header(bb, 1, 1, &hdr);
+
+	forwardLogicalChannelNumber =3D asn1_per_read_unsigned(bb, 1, 65535);
+	DEBUGP("forwardLogicalChannelNumber=3D%u\n", forwardLogicalChannelNumber);
+
+	/* reverseLogicalChannelParameters */
+	if (asn1_per_bitmap_get(&hdr.present, 0)) {
+		DEBUGP("reverseLogicalChannelParameters present\n");
+		asn1_per_read_sequence_header(bb, 1, 2, &hdr2);
+
+		/* reverseLogicalChannelNumber */
+		asn1_per_read_unsigned(bb, 1, 65535);
+
+		/* portNumber */
+		if (asn1_per_bitmap_get(&hdr.present, 0))
+			asn1_per_read_unsigned(bb, 0, 65535);
+
+		/* multiplexParameters */
+		if (asn1_per_bitmap_get(&hdr2.present, 1)) {
+			choice =3D asn1_per_read_choice_header(bb, 1, 1, &after);
+			if (bb->error)
+				return NF_ACCEPT;
+
+			switch (choice) {
+			case 0: /* h222LogicalChannelParameters */
+				h245_parse_h222_lchannel_params(pskb, ct,
+								ctinfo, bb);
+				break;
+			case 1: /* h2250LogicalChannelParameters */
+				h245_parse_h2250_lchannel_params(pskb, ct,
+								 ctinfo, bb);
+				break;
+			default:
+				if (after =3D=3D 0) {
+					DEBUGP("unsupported multiplex_parameter %u\n", choice);
+					bb->error =3D 1;
+					return NF_ACCEPT;
+				}
+			}
+
+			if (bb->error)
+				return NF_ACCEPT;
+
+			if (after > 0)
+				bb->i =3D after;
+		}
+
+		asn1_per_skip_sequence_extension(bb, &hdr2);
+	}
+
+	asn1_per_read_sequence_extension_header(bb, &hdr, &ext);
+	if (bb->error)
+		return NF_ACCEPT;
+
+	/* separateStack */
+	if (asn1_per_bitmap_get(&ext.present, 0))
+		asn1_per_skip_octet_string(bb);
+
+	/* forwardMultiplexAckParameters */
+	if (asn1_per_bitmap_get(&ext.present, 1)) {
+		DEBUGP("forwardMultiplexAckParameters present\n");
+
+		after =3D asn1_per_read_octet_string_header(bb);
+		DEBUGP("forwardMultiplexAckParameters present length=3D%u i=3D%u after=
=3D%u end=3D%u\n",
+		       after, bb->i, bb->i + after, bb->length);
+		after +=3D bb->i;
+
+		choice =3D asn1_per_read_choice_header(bb, 1, 1, &after2);
+		if (bb->error)
+			return NF_ACCEPT;
+
+		DEBUGP("entering forwardMultiplexAckParameters choice=3D%u after=3D%u\n"=
, choice, after2);
+
+		switch (choice) {
+		case 0: /* h2250LogicalChannelAckParameters */
+			h245_parse_h2250_lchannel_ack_params(pskb, ct,
+							     ctinfo, bb);
+			break;
+		}
+
+		if (bb->error)
+			return NF_ACCEPT;
+
+		bb->i =3D after;
+	}
+
+	for (i =3D 2; i < ext.count; i++)
+		if (asn1_per_bitmap_get(&ext.present, i))
+			asn1_per_skip_octet_string(bb);
+
+	return NF_ACCEPT;
+}
+
+/**
+ * Parse an H.245 response packet and handle NAT/expectations for the
+ * logical channel address.
+ */
+static int h245_parse_response(struct sk_buff **pskb,
+			       struct ip_conntrack *ct,
+			       enum ip_conntrack_info ctinfo,
+			       struct asn1_per_buffer *bb) {
+	unsigned choice, after;
+
+	choice =3D asn1_per_read_choice_header(bb, 1, 19, &after);
+	DEBUGP("H.245: response type=3D%u\n", choice);
+	switch (choice) {
+	case 5: /* openLogicalChannelAck */
+		return h245_parse_open_lchannel_ack(pskb, ct, ctinfo, bb);
+
+	default:
+		return NF_ACCEPT;
+	}
+}
+
+/**
+ * Parse an H.245 packet and handle NAT/expectations for the logical
+ * channel address.
+ */
+static int h245_parse(struct sk_buff **pskb,
+		      struct ip_conntrack *ct,
+		      enum ip_conntrack_info ctinfo,
+		      struct asn1_per_buffer *bb) {
+	unsigned choice, after;
+
+	choice =3D asn1_per_read_choice_header(bb, 1, 4, &after);
+	DEBUGP("H.245: message_class=3D%u\n", choice);
+	switch (choice) {
+	case 0:
+		return h245_parse_request(pskb, ct, ctinfo, bb);
+	case 1:
+		return h245_parse_response(pskb, ct, ctinfo, bb);
+	default:
+		return NF_ACCEPT;
+	}
+}
+
+/**
+ * Parse a TPKT/H.245 packet and handle NAT/expectations for the
+ * logical channel transport address (if applicable).
+ */
+static int h245_parse_tpkt(struct sk_buff **pskb,
+			   struct ip_conntrack *ct,
+			   enum ip_conntrack_info ctinfo,
+			   const unsigned char *data,
+			   unsigned datalen) {
+	unsigned int i =3D 0;
+	u_int16_t tpkt_len;
+	struct asn1_per_buffer bb;
+
+	if (i + 4 > datalen)
+		return NF_ACCEPT;
+
+	/* expect TPKT header, see RFC 1006 */
+	if (data[0] !=3D 0x03 || data[1] !=3D 0x00)
+		return NF_ACCEPT;
+
+	i +=3D 2;
+
+	tpkt_len =3D ntohs(*(u_int16_t*)(data + i));
+	if (tpkt_len < datalen)
+		datalen =3D tpkt_len;
+
+	i +=3D 2;
+
+	/* parse H.245 packet (ASN.1 PER) */
+	asn1_per_initialize(&bb, data, datalen, i);
+
+	return h245_parse(pskb, ct, ctinfo, &bb);
+}
+
+static int h245_help(struct sk_buff **pskb,
+		     struct ip_conntrack *ct,
+		     enum ip_conntrack_info ctinfo)
+{
+	struct tcphdr _tcph, *tcph;
+	unsigned char *data;
+	unsigned dataoff, datalen;
+	int ret;
+
+	/* Until there's been traffic both ways, don't look in packets. */
+	if (ctinfo !=3D IP_CT_ESTABLISHED
+	    && ctinfo !=3D IP_CT_ESTABLISHED + IP_CT_IS_REPLY) {
+		DEBUGP("ct_h245_help: Conntrackinfo =3D %u\n", ctinfo);
+		return NF_ACCEPT;
+	}
+
+	tcph =3D skb_header_pointer(*pskb, (*pskb)->nh.iph->ihl*4,
+				  sizeof(_tcph), &_tcph);
+	if (tcph =3D=3D NULL)
+		return NF_ACCEPT;
+
+	DEBUGP("ct_h245_help: help entered %u.%u.%u.%u:%u->%u.%u.%u.%u:%u\n",
+		NIPQUAD((*pskb)->nh.iph->saddr), ntohs(tcph->source),
+		NIPQUAD((*pskb)->nh.iph->daddr), ntohs(tcph->dest));
+
+	dataoff =3D (*pskb)->nh.iph->ihl*4 + tcph->doff*4;
+	/* No data? */
+	if (dataoff >=3D (*pskb)->len) {
+		DEBUGP("ct_h245_help: skblen =3D %u\n", (*pskb)->len);
+		return NF_ACCEPT;
+	}
+	datalen =3D (*pskb)->len - dataoff;
+
+	if (datalen < 16)
+		return NF_ACCEPT;
+
+	spin_lock_bh(&ip_h245_lock);
+	data =3D skb_header_pointer((*pskb), dataoff,
+				  datalen, h245_buffer);
+	BUG_ON(data =3D=3D NULL);
+
+	ret =3D h245_parse_tpkt(pskb, ct, ctinfo,
+			      data, datalen);
+
+	spin_unlock_bh(&ip_h245_lock);
+	return ret;
+}
+
+/* H.245 helper is not registered! */
+static struct ip_conntrack_helper h245 =3D
+{
+	.name =3D "H.245",
+	.max_expected =3D 8,
+	.timeout =3D 240,
+	.tuple =3D { .dst =3D { .protonum =3D IPPROTO_TCP } },
+	.mask =3D { .src =3D { .u =3D { 0xFFFF } },
+		  .dst =3D { .protonum =3D 0xFF } },
+	.help =3D h245_help
+};
+
+void ip_conntrack_h245_expect(struct ip_conntrack *new,
+			      struct ip_conntrack_expect *this)
+{
+	write_lock_bh(&ip_conntrack_lock);
+	new->helper =3D &h245;
+	DEBUGP("h225_expect: helper for %p added\n", new);
+	write_unlock_bh(&ip_conntrack_lock);
+}
+EXPORT_SYMBOL_GPL(ip_conntrack_h245_expect);
diff -Nrup pom-ng-svn/patchlets/h323-conntrack-nat/linux-2.6.12/net/ipv4/ne=
tfilter/ip_nat_h323.c pom-ng-h323/patchlets/h323-conntrack-nat/linux-2.6.12=
/net/ipv4/netfilter/ip_nat_h323.c
--- pom-ng-svn/patchlets/h323-conntrack-nat/linux-2.6.12/net/ipv4/netfilter=
/ip_nat_h323.c	1970-01-01 01:00:00.000000000 +0100
+++ pom-ng-h323/patchlets/h323-conntrack-nat/linux-2.6.12/net/ipv4/netfilte=
r/ip_nat_h323.c	2005-07-23 22:44:56.000000000 +0200
@@ -0,0 +1,196 @@
+/*
+ * H.323 'brute force' extension for NAT alteration.
+ * Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+ * (c) 2005 Max Kellermann <max@duempel.org>
+ *
+ * Based on ip_masq_h323.c for 2.2 kernels from CoRiTel, Sofia project.
+ * (http://www.coritel.it/projects/sofia/nat.html)
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
+#include <linux/netfilter_ipv4/ip_nat.h>
+#include <linux/netfilter_ipv4/ip_nat_helper.h>
+#include <linux/netfilter_ipv4/ip_nat_rule.h>
+#include <linux/netfilter_ipv4/ip_conntrack_tuple.h>
+#include <linux/netfilter_ipv4/ip_conntrack_helper.h>
+#include <linux/netfilter_ipv4/ip_conntrack_h323.h>
+
+MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
+MODULE_DESCRIPTION("H.323 'brute force' connection tracking module");
+MODULE_LICENSE("GPL");
+
+struct module *ip_nat_h323 =3D THIS_MODULE;
+
+#if 0
+#define DEBUGP printk
+#else
+#define DEBUGP(format, args...)
+#endif
+
+static void ip_nat_h225_signal(struct sk_buff **pskb,
+			       struct ip_conntrack *ct,
+			       enum ip_conntrack_info ctinfo,
+			       unsigned int offset,
+			       int dir,
+			       int orig_dir)
+{
+	struct {
+		u_int32_t ip;
+		u_int16_t port;
+	} __attribute__ ((__packed__)) newdata;
+
+	/* Change address inside packet to match way we're mapping
+	   this connection. */
+	if (dir =3D=3D IP_CT_DIR_ORIGINAL) {
+		newdata.ip =3D ct->tuplehash[!orig_dir].tuple.dst.ip;
+		newdata.port =3D ct->tuplehash[!orig_dir].tuple.dst.u.tcp.port;
+	} else {
+		newdata.ip =3D ct->tuplehash[!orig_dir].tuple.src.ip;
+		newdata.port =3D ct->tuplehash[!orig_dir].tuple.src.u.tcp.port;
+	}
+
+	/* Modify the packet */
+	ip_nat_mangle_tcp_packet(pskb, ct, ctinfo,
+				 offset,
+				 sizeof(newdata),
+				 (const char*)&newdata, sizeof(newdata));
+}
+
+/**
+ * This conntrack expect function replaces ip_conntrack_h245_expect()
+ * which was set by ip_conntrack_h323.c. It calls both
+ * ip_nat_follow_master() and ip_conntrack_h245_expect().
+ */
+static void ip_nat_h245_expect(struct ip_conntrack *new,
+			       struct ip_conntrack_expect *this)
+{
+	ip_nat_follow_master(new, this);
+	ip_conntrack_h245_expect(new, this);
+}
+
+static int ip_nat_h225(struct sk_buff **pskb,
+		       enum ip_conntrack_info ctinfo,
+		       unsigned int offset,
+		       struct ip_conntrack_expect *exp)
+{
+	u_int16_t port;
+	struct {
+		u_int32_t ip;
+		u_int16_t port;
+	} __attribute__ ((__packed__)) newdata;
+	int dir =3D CTINFO2DIR(ctinfo);
+	struct ip_conntrack *ct =3D exp->master;
+	int ret;
+
+	/* Connection will come from wherever this packet goes, hence !dir */
+	newdata.ip =3D ct->tuplehash[!dir].tuple.dst.ip;
+	exp->saved_proto.tcp.port =3D exp->tuple.dst.u.tcp.port;
+	exp->dir =3D !dir;
+
+	/* When you see the packet, we need to NAT it the same as the
+	 * this one. */
+	BUG_ON(exp->expectfn !=3D ip_conntrack_h245_expect);
+	exp->expectfn =3D ip_nat_h245_expect;
+
+	/* Try to get same port: if not, try to change it. */
+	for (port =3D ntohs(exp->saved_proto.tcp.port); port !=3D 0; port++) {
+		exp->tuple.dst.u.tcp.port =3D htons(port);
+		if (ip_conntrack_expect_related(exp) =3D=3D 0)
+			break;
+	}
+
+	if (port =3D=3D 0) {
+		ip_conntrack_expect_free(exp);
+		return NF_DROP;
+	}
+
+	newdata.port =3D htons(port);
+
+	/* now mangle packet */
+	ret =3D ip_nat_mangle_tcp_packet(pskb, ct, ctinfo,
+				       offset,
+				       sizeof(newdata),
+				       (const char*)&newdata, sizeof(newdata));
+	if (!ret)
+		return NF_DROP;
+
+	return NF_ACCEPT;
+}
+
+static int ip_nat_h245(struct sk_buff **pskb,
+		       enum ip_conntrack_info ctinfo,
+		       unsigned int offset,
+		       struct ip_conntrack_expect *exp)
+{
+	u_int16_t port;
+	struct {
+		u_int32_t ip;
+		u_int16_t port;
+	} __attribute__ ((__packed__)) newdata;
+	int dir =3D CTINFO2DIR(ctinfo);
+	struct ip_conntrack *ct =3D exp->master;
+	int ret;
+
+	/* Connection will come from wherever this packet goes, hence !dir */
+	newdata.ip =3D ct->tuplehash[!dir].tuple.dst.ip;
+	exp->saved_proto.tcp.port =3D exp->tuple.dst.u.tcp.port;
+	exp->dir =3D !dir;
+
+	/* When you see the packet, we need to NAT it the same as the
+	 * this one. */
+	exp->expectfn =3D ip_nat_follow_master;
+
+	/* Try to get same port: if not, try to change it. */
+	for (port =3D ntohs(exp->saved_proto.tcp.port); port !=3D 0; port++) {
+		exp->tuple.dst.u.tcp.port =3D htons(port);
+		if (ip_conntrack_expect_related(exp) =3D=3D 0)
+			break;
+	}
+
+	if (port =3D=3D 0) {
+		ip_conntrack_expect_free(exp);
+		return NF_DROP;
+	}
+
+	newdata.port =3D htons(port);
+
+	/* now mangle packet */
+	ret =3D ip_nat_mangle_tcp_packet(pskb, ct, ctinfo,
+				       offset,
+				       sizeof(newdata),
+				       (const char*)&newdata, sizeof(newdata));
+	if (!ret)
+		return NF_DROP;
+
+	return NF_ACCEPT;
+}
+
+static int __init init(void)
+{
+	BUG_ON(ip_nat_h225_hook !=3D NULL);
+	BUG_ON(ip_nat_h245_hook !=3D NULL);
+
+	ip_nat_h225_hook =3D ip_nat_h225;
+	ip_nat_h225_signal_hook =3D ip_nat_h225_signal;
+	ip_nat_h245_hook =3D ip_nat_h245;
+
+	return 0;
+}
+
+static void __exit fini(void)
+{
+	ip_nat_h225_hook =3D NULL;
+	ip_nat_h225_signal_hook =3D NULL;
+	ip_nat_h245_hook =3D NULL;
+}
+
+module_init(init);
+module_exit(fini);
diff -Nrup pom-ng-svn/patchlets/h323-conntrack-nat/linux-2.6.12/net/ipv4/ne=
tfilter/Kconfig.ladd pom-ng-h323/patchlets/h323-conntrack-nat/linux-2.6.12/=
net/ipv4/netfilter/Kconfig.ladd
--- pom-ng-svn/patchlets/h323-conntrack-nat/linux-2.6.12/net/ipv4/netfilter=
/Kconfig.ladd	1970-01-01 01:00:00.000000000 +0100
+++ pom-ng-h323/patchlets/h323-conntrack-nat/linux-2.6.12/net/ipv4/netfilte=
r/Kconfig.ladd	2005-07-03 22:40:12.000000000 +0200
@@ -0,0 +1,17 @@
+config IP_NF_NAT_H323
+	tristate
+	depends on IP_NF_CONNTRACK!=3Dn && IP_NF_NAT!=3Dn
+	default IP_NF_NAT if IP_NF_H323=3Dy
+	default m if IP_NF_H323=3Dm
+
+config IP_NF_H323
+	tristate  'H.323 (netmeeting) support'
+	depends on IP_NF_CONNTRACK
+	help
+	  H.323 is a standard signalling protocol used by teleconferencing
+	  softwares like netmeeting. With the ip_conntrack_h323 and
+	  the ip_nat_h323 modules you can support the protocol on a connection
+	  tracking/NATing firewall.
+=09
+	  If you want to compile it as a module, say 'M' here and read
+	  Documentation/modules.txt.  If unsure, say 'N'.
diff -Nrup pom-ng-svn/patchlets/h323-conntrack-nat/linux-2.6.12/net/ipv4/ne=
tfilter/Makefile.ladd pom-ng-h323/patchlets/h323-conntrack-nat/linux-2.6.12=
/net/ipv4/netfilter/Makefile.ladd
--- pom-ng-svn/patchlets/h323-conntrack-nat/linux-2.6.12/net/ipv4/netfilter=
/Makefile.ladd	1970-01-01 01:00:00.000000000 +0100
+++ pom-ng-h323/patchlets/h323-conntrack-nat/linux-2.6.12/net/ipv4/netfilte=
r/Makefile.ladd	2005-07-03 22:40:12.000000000 +0200
@@ -0,0 +1,7 @@
+obj-$(CONFIG_IP_NF_CONNTRACK) +=3D ip_conntrack.o
+=20
+# H.323 support
+obj-$(CONFIG_IP_NF_H323) +=3D ip_conntrack_h323.o
+ip_conntrack_h323-objs :=3D ip_conntrack_h323_core.o ip_conntrack_h323_h22=
5.o ip_conntrack_h323_h245.o asn1_per.o
+obj-$(CONFIG_IP_NF_NAT_H323) +=3D ip_nat_h323.o
+

--5mCyUwZo2JvN/JJP--

--vGgW1X5XWziG23Ko
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFC4q32o4FAdB2PneQRAv2PAJ987tZ1dKFgmTIuJBtqwq8UsK5KqQCeJgzJ
kkQlFXGYWZwgfQgkhe7Pa9Y=
=VXmM
-----END PGP SIGNATURE-----

--vGgW1X5XWziG23Ko--
