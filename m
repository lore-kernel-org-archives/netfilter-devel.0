From: "Jing Min Zhao" <zhaojingmin@hotmail.com>
Subject: Re: New H.323 conntrack & NAT helper module
Date: Fri, 17 Mar 2006 09:56:05 -0500
Message-ID: <BAY109-DAV32A984CAAF6764E3B7601B3E40@phx.gbl>
References: <925A849792280C4E80C5461017A4B8A2032119@mail733.InfraSupportEtc.com><BAY109-DAV1E3EEAC01132FB3EE2E2EB3F00@phx.gbl><44001CDD.3030305@trash.net><BAY109-DAV1A4C43C331B9AEBC1F22EB3F00@phx.gbl><4400A541.9080901@trash.net><BAY109-DAV96ADAFAB4170550F4A52FB3F40@phx.gbl><440960E4.80601@trash.net><BAY109-DAV1330DD37E6D3BA0FF46E0DB3E00@phx.gbl><44158920.30700@trash.net><BAY109-DAV757C3488B317953CCA29AB3E70@phx.gbl>
	<4419281D.6050702@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0022_01C649A9.019ACA20"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Patrick McHardy" <kaber@trash.net>
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

This is a multi-part message in MIME format.

------=_NextPart_000_0022_01C649A9.019ACA20
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit


----- Original Message ----- 
From: "Patrick McHardy" <kaber@trash.net>
To: "Jing Min Zhao" <zhaojingmin@hotmail.com>
Cc: <netfilter-devel@lists.netfilter.org>
Sent: Thursday, March 16, 2006 3:55 AM
Subject: Re: New H.323 conntrack & NAT helper module


> Jing Min Zhao wrote:
>>> Great, thanks. When you release the new version, please also post
>>> the patch to netfilter-devel and add a Signed-off-by: line (see
>>> Documentation/SubmittingPatches in the kernel source).
>>>
>>>
>> 
>> I have finished the new release. The new parameter and T.120 support
>> have been added. But the uncompressed patch is pretty big, about 228KB.
>> Do you think it's ok to post it here?
> 
> We used to have a pretty small size limit, but I think it has been
> lifted. Just try if it works.
> 
>

Here comes the latest release. 

The main new feature of this release is T.120 support. 
So chat, whiteboard, file transfer and other T.120 applications are 
supported now.  
 
The second new feature is a parameter "gkrouted_only" for 
ip_conntrack_h323 module. If you set gkrouted_only to 1, only calls from 
the gatekeeper will be forwarded to the registered endpoint. 
 
Change log:  

1. Added support for T.120 channels  
2. Added parameter gkrouted_only (suggested by Patrick McHardy)  
3. Splitted ASN.1 code and data (suggested by Patrick McHardy)  
4. Sort ASN.1 data to avoid forwarding declarations (suggested by Patrick McHardy)  
5. Reset next TPKT data length in get_tpkt_data() 

Best regards.

Jing Min Zhao

------=_NextPart_000_0022_01C649A9.019ACA20
Content-Type: application/octet-stream;
	name="patch-2.6.15-nath323-0.4"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch-2.6.15-nath323-0.4"

diff -pruN linux-2.6.15.orig/include/linux/netfilter_ipv4/ip_conntrack.h =
linux-2.6.15/include/linux/netfilter_ipv4/ip_conntrack.h=0A=
--- linux-2.6.15.orig/include/linux/netfilter_ipv4/ip_conntrack.h	=
2006-01-02 22:21:10.000000000 -0500=0A=
+++ linux-2.6.15/include/linux/netfilter_ipv4/ip_conntrack.h	2006-02-01 =
21:40:02.000000000 -0500=0A=
@@ -29,6 +29,7 @@ union ip_conntrack_expect_proto {=0A=
 };=0A=
 =0A=
 /* Add protocol helper include file here */=0A=
+#include <linux/netfilter_ipv4/ip_conntrack_h323.h>=0A=
 #include <linux/netfilter_ipv4/ip_conntrack_pptp.h>=0A=
 #include <linux/netfilter_ipv4/ip_conntrack_amanda.h>=0A=
 #include <linux/netfilter_ipv4/ip_conntrack_ftp.h>=0A=
@@ -37,6 +38,7 @@ union ip_conntrack_expect_proto {=0A=
 /* per conntrack: application helper private data */=0A=
 union ip_conntrack_help {=0A=
 	/* insert conntrack helper private data (master) here */=0A=
+	struct ip_ct_h323_master ct_h323_info;=0A=
 	struct ip_ct_pptp_master ct_pptp_info;=0A=
 	struct ip_ct_ftp_master ct_ftp_info;=0A=
 	struct ip_ct_irc_master ct_irc_info;=0A=
diff -pruN =
linux-2.6.15.orig/include/linux/netfilter_ipv4/ip_conntrack_h323.h =
linux-2.6.15/include/linux/netfilter_ipv4/ip_conntrack_h323.h=0A=
--- linux-2.6.15.orig/include/linux/netfilter_ipv4/ip_conntrack_h323.h	=
1969-12-31 19:00:00.000000000 -0500=0A=
+++ linux-2.6.15/include/linux/netfilter_ipv4/ip_conntrack_h323.h	=
2006-03-15 19:30:48.000000000 -0500=0A=
@@ -0,0 +1,30 @@=0A=
+#ifndef _IP_CONNTRACK_H323_H=0A=
+#define _IP_CONNTRACK_H323_H=0A=
+=0A=
+#ifdef __KERNEL__=0A=
+=0A=
+#define RAS_PORT 1719=0A=
+#define Q931_PORT 1720=0A=
+#define H323_RTP_CHANNEL_MAX 4	/* Audio, video, FAX and other */=0A=
+=0A=
+/* This structure exists only once per master */=0A=
+struct ip_ct_h323_master {=0A=
+=0A=
+	/* Original and NATed Q.931 or H.245 signal ports */=0A=
+	u_int16_t sig_port[IP_CT_DIR_MAX];=0A=
+=0A=
+	/* Original and NATed RTP ports */=0A=
+	u_int16_t rtp_port[H323_RTP_CHANNEL_MAX][IP_CT_DIR_MAX];=0A=
+=0A=
+	union {=0A=
+		/* RAS connection timeout */=0A=
+		u_int32_t timeout;=0A=
+=0A=
+		/* Next TPKT length (for separate TPKT header and data) */=0A=
+		u_int16_t tpkt_len[IP_CT_DIR_MAX];=0A=
+	};=0A=
+};=0A=
+=0A=
+#endif=0A=
+=0A=
+#endif=0A=
diff -pruN =
linux-2.6.15.orig/net/ipv4/netfilter/ip_conntrack_helper_h323_asn1.c =
linux-2.6.15/net/ipv4/netfilter/ip_conntrack_helper_h323_asn1.c=0A=
--- linux-2.6.15.orig/net/ipv4/netfilter/ip_conntrack_helper_h323_asn1.c	=
1969-12-31 19:00:00.000000000 -0500=0A=
+++ linux-2.6.15/net/ipv4/netfilter/ip_conntrack_helper_h323_asn1.c	=
2006-03-15 19:33:54.000000000 -0500=0A=
@@ -0,0 +1,874 @@=0A=
+/***********************************************************************=
*****=0A=
+ * ip_conntrack_helper_h323_asn1.c - BER and PER decoding library for =
H.323=0A=
+ * 			      	     conntrack/NAT module.=0A=
+ *=0A=
+ * Copyright (c) 2006 by Jing Min Zhao <zhaojingmin@hotmail.com>=0A=
+ * =0A=
+ * This source code is licensed under General Public License version 2.=0A=
+ *=0A=
+ * See ip_conntrack_helper_h323_asn1.h for details.=0A=
+ *=0A=
+ =
*************************************************************************=
***/=0A=
+=0A=
+#ifdef __KERNEL__=0A=
+#include <linux/kernel.h>=0A=
+#else=0A=
+#include <stdio.h>=0A=
+#endif=0A=
+#include "ip_conntrack_helper_h323_asn1.h"=0A=
+=0A=
+/* Trace Flag */=0A=
+#ifndef H323_TRACE=0A=
+#define H323_TRACE 0=0A=
+#endif=0A=
+=0A=
+#ifndef offsetof=0A=
+#define offsetof(p_type,field) ((size_t)&(((p_type *)0)->field))=0A=
+#endif=0A=
+=0A=
+#if H323_TRACE=0A=
+#define TAB_SIZE 4=0A=
+#define IFTHEN(cond, act) if(cond){act;}=0A=
+#ifdef __KERNEL__=0A=
+#define PRINT printk=0A=
+#else=0A=
+#define PRINT printf=0A=
+#endif=0A=
+#define FNAME(name) name,=0A=
+#else=0A=
+#define IFTHEN(cond, act)=0A=
+#define PRINT(fmt, args...)=0A=
+#define FNAME(name)=0A=
+#endif=0A=
+=0A=
+/* ASN.1 Types */=0A=
+#define NUL 0=0A=
+#define BOOL 1=0A=
+#define OID 2=0A=
+#define INT 3=0A=
+#define ENUM 4=0A=
+#define BITSTR 5=0A=
+#define NUMSTR 6=0A=
+#define NUMDGT 6=0A=
+#define TBCDSTR 6=0A=
+#define OCTSTR 7=0A=
+#define PRTSTR 7=0A=
+#define IA5STR 7=0A=
+#define GENSTR 7=0A=
+#define BMPSTR 8=0A=
+#define SEQ 9=0A=
+#define SET 9=0A=
+#define SEQOF 10=0A=
+#define SETOF 10=0A=
+#define CHOICE 11=0A=
+=0A=
+/* Constraint Types */=0A=
+#define FIXD 0=0A=
+/* #define BITS 1-8 */=0A=
+#define BYTE 9=0A=
+#define WORD 10=0A=
+#define CONS 11=0A=
+#define SEMI 12=0A=
+#define UNCO 13=0A=
+=0A=
+/* ASN.1 Type Attributes */=0A=
+#define SKIP 0=0A=
+#define STOP 1=0A=
+#define DECODE 2=0A=
+#define EXT 4=0A=
+#define OPEN 8=0A=
+#define OPT 16=0A=
+=0A=
+=0A=
+/* ASN.1 Field Structure */=0A=
+typedef struct field_t {=0A=
+#if H323_TRACE=0A=
+	char *name;=0A=
+#endif=0A=
+	unsigned char type;=0A=
+	unsigned char sz;=0A=
+	unsigned char lb;=0A=
+	unsigned char ub;=0A=
+	unsigned short attr;=0A=
+	unsigned short offset;=0A=
+	struct field_t *fields;=0A=
+} field_t;=0A=
+=0A=
+/* Bit Stream */=0A=
+typedef struct {=0A=
+	unsigned char *buf;=0A=
+	unsigned char *beg;=0A=
+	unsigned char *end;=0A=
+	unsigned char *cur;=0A=
+	unsigned bit;=0A=
+} bitstr_t;=0A=
+=0A=
+/* Tool Functions */=0A=
+#define INC_BIT(bs) if((++bs->bit)>7){bs->cur++;bs->bit=3D0;}=0A=
+#define INC_BITS(bs,b) =
if((bs->bit+=3Db)>7){bs->cur+=3Dbs->bit>>3;bs->bit&=3D7;}=0A=
+#define BYTE_ALIGN(bs) if(bs->bit){bs->cur++;bs->bit=3D0;}=0A=
+#define CHECK_BOUND(bs,n) =
if(bs->cur+(n)>bs->end)return(H323_ERROR_BOUND)=0A=
+static unsigned get_len(bitstr_t * bs);=0A=
+static unsigned get_bit(bitstr_t * bs);=0A=
+static unsigned get_bits(bitstr_t * bs, unsigned b);=0A=
+static unsigned get_bitmap(bitstr_t * bs, unsigned b);=0A=
+static unsigned get_uint(bitstr_t * bs, int b);=0A=
+=0A=
+/* Decoder Functions */=0A=
+static int decode_nul(bitstr_t * bs, field_t * f, char *base, int =
level);=0A=
+static int decode_bool(bitstr_t * bs, field_t * f, char *base, int =
level);=0A=
+static int decode_oid(bitstr_t * bs, field_t * f, char *base, int =
level);=0A=
+static int decode_int(bitstr_t * bs, field_t * f, char *base, int =
level);=0A=
+static int decode_enum(bitstr_t * bs, field_t * f, char *base, int =
level);=0A=
+static int decode_bitstr(bitstr_t * bs, field_t * f, char *base, int =
level);=0A=
+static int decode_numstr(bitstr_t * bs, field_t * f, char *base, int =
level);=0A=
+static int decode_octstr(bitstr_t * bs, field_t * f, char *base, int =
level);=0A=
+static int decode_bmpstr(bitstr_t * bs, field_t * f, char *base, int =
level);=0A=
+static int decode_seq(bitstr_t * bs, field_t * f, char *base, int =
level);=0A=
+static int decode_seqof(bitstr_t * bs, field_t * f, char *base, int =
level);=0A=
+static int decode_choice(bitstr_t * bs, field_t * f, char *base, int =
level);=0A=
+=0A=
+/* Decoder Functions Vector */=0A=
+typedef int (*decoder_t) (bitstr_t *, field_t *, char *, int);=0A=
+static decoder_t Decoders[] =3D {=0A=
+	decode_nul,=0A=
+	decode_bool,=0A=
+	decode_oid,=0A=
+	decode_int,=0A=
+	decode_enum,=0A=
+	decode_bitstr,=0A=
+	decode_numstr,=0A=
+	decode_octstr,=0A=
+	decode_bmpstr,=0A=
+	decode_seq,=0A=
+	decode_seqof,=0A=
+	decode_choice,=0A=
+};=0A=
+=0A=
+/***********************************************************************=
*****=0A=
+ * H.323 Types=0A=
+ =
*************************************************************************=
***/=0A=
+#include "ip_conntrack_helper_h323_types.c"=0A=
+=0A=
+/***********************************************************************=
*****=0A=
+ * Functions=0A=
+ =
*************************************************************************=
***/=0A=
+/* Assume bs is aligned && v < 16384 */=0A=
+unsigned get_len(bitstr_t * bs)=0A=
+{=0A=
+	unsigned v;=0A=
+=0A=
+	v =3D *bs->cur++;=0A=
+=0A=
+	if (v & 0x80) {=0A=
+		v &=3D 0x3f;=0A=
+		v <<=3D 8;=0A=
+		v +=3D *bs->cur++;=0A=
+	}=0A=
+=0A=
+	return v;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+unsigned get_bit(bitstr_t * bs)=0A=
+{=0A=
+	unsigned b =3D (*bs->cur) & (0x80 >> bs->bit);=0A=
+=0A=
+	INC_BIT(bs);=0A=
+=0A=
+	return b;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+/* Assume b <=3D 8 */=0A=
+unsigned get_bits(bitstr_t * bs, unsigned b)=0A=
+{=0A=
+	unsigned v, l;=0A=
+=0A=
+	v =3D (*bs->cur) & (0xffU >> bs->bit);=0A=
+	l =3D b + bs->bit;=0A=
+=0A=
+	if (l < 8) {=0A=
+		v >>=3D 8 - l;=0A=
+		bs->bit =3D l;=0A=
+	} else if (l =3D=3D 8) {=0A=
+		bs->cur++;=0A=
+		bs->bit =3D 0;=0A=
+	} else {		/* l > 8 */=0A=
+=0A=
+		v <<=3D 8;=0A=
+		v +=3D *(++bs->cur);=0A=
+		v >>=3D 16 - l;=0A=
+		bs->bit =3D l - 8;=0A=
+	}=0A=
+=0A=
+	return v;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+/* Assume b <=3D 32 */=0A=
+unsigned get_bitmap(bitstr_t * bs, unsigned b)=0A=
+{=0A=
+	unsigned v, l, shift, bytes;=0A=
+=0A=
+	if (!b)=0A=
+		return 0;=0A=
+=0A=
+	l =3D bs->bit + b;=0A=
+=0A=
+	if (l < 8) {=0A=
+		v =3D (unsigned) (*bs->cur) << (bs->bit + 24);=0A=
+		bs->bit =3D l;=0A=
+	} else if (l =3D=3D 8) {=0A=
+		v =3D (unsigned) (*bs->cur++) << (bs->bit + 24);=0A=
+		bs->bit =3D 0;=0A=
+	} else {=0A=
+		for (bytes =3D l >> 3, shift =3D 24, v =3D 0; bytes;=0A=
+		     bytes--, shift -=3D 8)=0A=
+			v |=3D (unsigned) (*bs->cur++) << shift;=0A=
+=0A=
+		if (l < 32) {=0A=
+			v |=3D (unsigned) (*bs->cur) << shift;=0A=
+			v <<=3D bs->bit;=0A=
+		} else if (l > 32) {=0A=
+			v <<=3D bs->bit;=0A=
+			v |=3D (*bs->cur) >> (8 - bs->bit);=0A=
+		}=0A=
+=0A=
+		bs->bit =3D l & 0x7;=0A=
+	}=0A=
+=0A=
+	v &=3D 0xffffffff << (32 - b);=0A=
+=0A=
+	return v;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****=0A=
+ * Assume bs is aligned and sizeof(unsigned int) =3D=3D 4=0A=
+ =
*************************************************************************=
***/=0A=
+unsigned get_uint(bitstr_t * bs, int b)=0A=
+{=0A=
+	unsigned v =3D 0;=0A=
+=0A=
+	switch (b) {=0A=
+	case 4:=0A=
+		v |=3D *bs->cur++;=0A=
+		v <<=3D 8;=0A=
+	case 3:=0A=
+		v |=3D *bs->cur++;=0A=
+		v <<=3D 8;=0A=
+	case 2:=0A=
+		v |=3D *bs->cur++;=0A=
+		v <<=3D 8;=0A=
+	case 1:=0A=
+		v |=3D *bs->cur++;=0A=
+		break;=0A=
+	}=0A=
+	return v;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+int decode_nul(bitstr_t * bs, field_t * f, char *base, int level)=0A=
+{=0A=
+	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);=0A=
+=0A=
+	return H323_ERROR_NONE;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+int decode_bool(bitstr_t * bs, field_t * f, char *base, int level)=0A=
+{=0A=
+	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);=0A=
+=0A=
+	INC_BIT(bs);=0A=
+=0A=
+	CHECK_BOUND(bs, 0);=0A=
+	return H323_ERROR_NONE;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+int decode_oid(bitstr_t * bs, field_t * f, char *base, int level)=0A=
+{=0A=
+	int len;=0A=
+=0A=
+	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);=0A=
+=0A=
+	BYTE_ALIGN(bs);=0A=
+	CHECK_BOUND(bs, 1);=0A=
+	len =3D *bs->cur++;=0A=
+	bs->cur +=3D len;=0A=
+=0A=
+	CHECK_BOUND(bs, 0);=0A=
+	return H323_ERROR_NONE;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+int decode_int(bitstr_t * bs, field_t * f, char *base, int level)=0A=
+{=0A=
+	unsigned len;=0A=
+=0A=
+	PRINT("%*.s%s", level * TAB_SIZE, " ", f->name);=0A=
+=0A=
+	switch (f->sz) {=0A=
+	case BYTE:		/* Range =3D=3D 256 */=0A=
+		BYTE_ALIGN(bs);=0A=
+		bs->cur++;=0A=
+		break;=0A=
+	case WORD:		/* 257 <=3D Range <=3D 64K */=0A=
+		BYTE_ALIGN(bs);=0A=
+		bs->cur +=3D 2;=0A=
+		break;=0A=
+	case CONS:		/* 64K < Range < 4G */=0A=
+		len =3D get_bits(bs, 2) + 1;=0A=
+		BYTE_ALIGN(bs);=0A=
+		if (base && (f->attr & DECODE)) {	/* timeToLive */=0A=
+			unsigned v =3D get_uint(bs, len) + f->lb;=0A=
+			PRINT(" =3D %u", v);=0A=
+			*((unsigned *) (base + f->offset)) =3D v;=0A=
+		}=0A=
+		bs->cur +=3D len;=0A=
+		break;=0A=
+	case UNCO:=0A=
+		BYTE_ALIGN(bs);=0A=
+		CHECK_BOUND(bs, 2);=0A=
+		len =3D get_len(bs);=0A=
+		bs->cur +=3D len;=0A=
+		break;=0A=
+	default:		/* 2 <=3D Range <=3D 255 */=0A=
+		INC_BITS(bs, f->sz);=0A=
+		break;=0A=
+	}=0A=
+=0A=
+	PRINT("\n");=0A=
+=0A=
+	CHECK_BOUND(bs, 0);=0A=
+	return H323_ERROR_NONE;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+int decode_enum(bitstr_t * bs, field_t * f, char *base, int level)=0A=
+{=0A=
+	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);=0A=
+=0A=
+	if ((f->attr & EXT) && get_bit(bs)) {=0A=
+		INC_BITS(bs, 7);=0A=
+	} else {=0A=
+		INC_BITS(bs, f->sz);=0A=
+	}=0A=
+=0A=
+	CHECK_BOUND(bs, 0);=0A=
+	return H323_ERROR_NONE;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+int decode_bitstr(bitstr_t * bs, field_t * f, char *base, int level)=0A=
+{=0A=
+	unsigned len;=0A=
+=0A=
+	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);=0A=
+=0A=
+	BYTE_ALIGN(bs);=0A=
+	switch (f->sz) {=0A=
+	case FIXD:		/* fixed length > 16 */=0A=
+		len =3D f->lb;=0A=
+		break;=0A=
+	case WORD:		/* 2-byte length */=0A=
+		CHECK_BOUND(bs, 2);=0A=
+		len =3D (*bs->cur++) << 8;=0A=
+		len +=3D (*bs->cur++) + f->lb;=0A=
+		break;=0A=
+	case SEMI:=0A=
+		CHECK_BOUND(bs, 2);=0A=
+		len =3D get_len(bs);=0A=
+		break;=0A=
+	default:=0A=
+		len =3D 0;=0A=
+		break;=0A=
+	}=0A=
+=0A=
+	bs->cur +=3D len >> 3;=0A=
+	bs->bit =3D len & 7;=0A=
+=0A=
+	CHECK_BOUND(bs, 0);=0A=
+	return H323_ERROR_NONE;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+int decode_numstr(bitstr_t * bs, field_t * f, char *base, int level)=0A=
+{=0A=
+	unsigned len;=0A=
+=0A=
+	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);=0A=
+=0A=
+	/* 2 <=3D Range <=3D 255 */=0A=
+	len =3D get_bits(bs, f->sz) + f->lb;=0A=
+=0A=
+	BYTE_ALIGN(bs);=0A=
+	INC_BITS(bs, (len << 2));=0A=
+=0A=
+	CHECK_BOUND(bs, 0);=0A=
+	return H323_ERROR_NONE;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+int decode_octstr(bitstr_t * bs, field_t * f, char *base, int level)=0A=
+{=0A=
+	unsigned len;=0A=
+=0A=
+	PRINT("%*.s%s", level * TAB_SIZE, " ", f->name);=0A=
+=0A=
+	switch (f->sz) {=0A=
+	case FIXD:		/* Range =3D=3D 1 */=0A=
+		if (f->lb > 2) {=0A=
+			BYTE_ALIGN(bs);=0A=
+			if (base && (f->attr & DECODE)) {=0A=
+				/* The IP Address */=0A=
+				IFTHEN(f->lb =3D=3D 4,=0A=
+				       PRINT(" =3D %d.%d.%d.%d:%d",=0A=
+					     bs->cur[0], bs->cur[1],=0A=
+					     bs->cur[2], bs->cur[3],=0A=
+					     bs->cur[4] * 256 + bs->cur[5]));=0A=
+				*((unsigned *) (base + f->offset)) =3D=0A=
+				    bs->cur - bs->buf;=0A=
+			}=0A=
+		}=0A=
+		len =3D f->lb;=0A=
+		break;=0A=
+	case BYTE:		/* Range =3D=3D 256 */=0A=
+		BYTE_ALIGN(bs);=0A=
+		CHECK_BOUND(bs, 1);=0A=
+		len =3D (*bs->cur++) + f->lb;=0A=
+		break;=0A=
+	case SEMI:=0A=
+		BYTE_ALIGN(bs);=0A=
+		CHECK_BOUND(bs, 2);=0A=
+		len =3D get_len(bs) + f->lb;=0A=
+		break;=0A=
+	default:		/* 2 <=3D Range <=3D 255 */=0A=
+		len =3D get_bits(bs, f->sz) + f->lb;=0A=
+		BYTE_ALIGN(bs);=0A=
+		break;=0A=
+	}=0A=
+=0A=
+	bs->cur +=3D len;=0A=
+=0A=
+	PRINT("\n");=0A=
+=0A=
+	CHECK_BOUND(bs, 0);=0A=
+	return H323_ERROR_NONE;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+int decode_bmpstr(bitstr_t * bs, field_t * f, char *base, int level)=0A=
+{=0A=
+	unsigned len;=0A=
+=0A=
+	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);=0A=
+=0A=
+	switch (f->sz) {=0A=
+	case BYTE:		/* Range =3D=3D 256 */=0A=
+		BYTE_ALIGN(bs);=0A=
+		CHECK_BOUND(bs, 1);=0A=
+		len =3D (*bs->cur++) + f->lb;=0A=
+		break;=0A=
+	default:		/* 2 <=3D Range <=3D 255 */=0A=
+		len =3D get_bits(bs, f->sz) + f->lb;=0A=
+		BYTE_ALIGN(bs);=0A=
+		break;=0A=
+	}=0A=
+=0A=
+	bs->cur +=3D len << 1;=0A=
+=0A=
+	CHECK_BOUND(bs, 0);=0A=
+	return H323_ERROR_NONE;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+int decode_seq(bitstr_t * bs, field_t * f, char *base, int level)=0A=
+{=0A=
+	unsigned ext, bmp, i, opt, len =3D 0, bmp2, bmp2_len;=0A=
+	int err;=0A=
+	field_t *son;=0A=
+	unsigned char *beg =3D NULL;=0A=
+=0A=
+	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);=0A=
+=0A=
+	/* Decode? */=0A=
+	base =3D (base && (f->attr & DECODE)) ? base + f->offset : NULL;=0A=
+=0A=
+	/* Extensible? */=0A=
+	ext =3D (f->attr & EXT) ? get_bit(bs) : 0;=0A=
+=0A=
+	/* Get fields bitmap */=0A=
+	bmp =3D get_bitmap(bs, f->sz);=0A=
+	if (base)=0A=
+		*(unsigned *) base =3D bmp;=0A=
+=0A=
+	/* Decode the root components */=0A=
+	for (i =3D opt =3D 0, son =3D f->fields; i < f->lb; i++, son++) {=0A=
+		if (son->attr & STOP) {=0A=
+			PRINT("%*.s%s\n", (level + 1) * TAB_SIZE, " ",=0A=
+			      son->name);=0A=
+			return H323_ERROR_STOP;=0A=
+		}=0A=
+=0A=
+		if (son->attr & OPT) {	/* Optional component */=0A=
+			if (!((0x80000000U >> (opt++)) & bmp))	/* Not exist */=0A=
+				continue;=0A=
+		}=0A=
+=0A=
+		/* Decode */=0A=
+		if (son->attr & OPEN) {	/* Open field */=0A=
+			CHECK_BOUND(bs, 2);=0A=
+			len =3D get_len(bs);=0A=
+			CHECK_BOUND(bs, len);=0A=
+			if (!base) {=0A=
+				PRINT("%*.s%s\n", (level + 1) * TAB_SIZE,=0A=
+				      " ", son->name);=0A=
+				bs->cur +=3D len;=0A=
+				continue;=0A=
+			}=0A=
+			beg =3D bs->cur;=0A=
+=0A=
+			/* Decode */=0A=
+			if ((err =3D (Decoders[son->type]) (bs, son, base,=0A=
+							  level + 1)) >=0A=
+			    H323_ERROR_STOP)=0A=
+				return err;=0A=
+=0A=
+			bs->cur =3D beg + len;=0A=
+			bs->bit =3D 0;=0A=
+		} else if ((err =3D (Decoders[son->type]) (bs, son, base,=0A=
+							 level + 1)))=0A=
+			return err;=0A=
+	}=0A=
+=0A=
+	/* No extension? */=0A=
+	if (!ext)=0A=
+		return H323_ERROR_NONE;=0A=
+=0A=
+	/* Get the extension bitmap */=0A=
+	bmp2_len =3D get_bits(bs, 7) + 1;=0A=
+	CHECK_BOUND(bs, (bmp2_len + 7) >> 3);=0A=
+	bmp2 =3D get_bitmap(bs, bmp2_len);=0A=
+	bmp |=3D bmp2 >> f->sz;=0A=
+	if (base)=0A=
+		*(unsigned *) base =3D bmp;=0A=
+	BYTE_ALIGN(bs);=0A=
+=0A=
+	/* Decode the extension components */=0A=
+	for (opt =3D 0; opt < bmp2_len; opt++, i++, son++) {=0A=
+		if (son->attr & STOP) {=0A=
+			PRINT("%*.s%s\n", (level + 1) * TAB_SIZE, " ",=0A=
+			      son->name);=0A=
+			return H323_ERROR_STOP;=0A=
+		}=0A=
+=0A=
+		if (!((0x80000000 >> opt) & bmp2))	/* Not present */=0A=
+			continue;=0A=
+=0A=
+		/* Check Range */=0A=
+		if (i >=3D f->ub) {	/* Newer Version? */=0A=
+			CHECK_BOUND(bs, 2);=0A=
+			len =3D get_len(bs);=0A=
+			CHECK_BOUND(bs, len);=0A=
+			bs->cur +=3D len;=0A=
+			continue;=0A=
+		}=0A=
+=0A=
+		CHECK_BOUND(bs, 2);=0A=
+		len =3D get_len(bs);=0A=
+		CHECK_BOUND(bs, len);=0A=
+		if (!base || !(son->attr & DECODE)) {=0A=
+			PRINT("%*.s%s\n", (level + 1) * TAB_SIZE, " ",=0A=
+			      son->name);=0A=
+			bs->cur +=3D len;=0A=
+			continue;=0A=
+		}=0A=
+		beg =3D bs->cur;=0A=
+=0A=
+		if ((err =3D (Decoders[son->type]) (bs, son, base,=0A=
+						  level + 1)) >=0A=
+		    H323_ERROR_STOP)=0A=
+			return err;=0A=
+=0A=
+		bs->cur =3D beg + len;=0A=
+		bs->bit =3D 0;=0A=
+	}=0A=
+	return H323_ERROR_NONE;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+int decode_seqof(bitstr_t * bs, field_t * f, char *base, int level)=0A=
+{=0A=
+	unsigned count, effective_count =3D 0, i, len =3D 0;=0A=
+	int err;=0A=
+	field_t *son;=0A=
+	unsigned char *beg =3D NULL;=0A=
+=0A=
+	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);=0A=
+=0A=
+	/* Decode? */=0A=
+	base =3D (base && (f->attr & DECODE)) ? base + f->offset : NULL;=0A=
+=0A=
+	/* Decode item count */=0A=
+	switch (f->sz) {=0A=
+	case BYTE:=0A=
+		BYTE_ALIGN(bs);=0A=
+		CHECK_BOUND(bs, 1);=0A=
+		count =3D *bs->cur++;=0A=
+		break;=0A=
+	case WORD:=0A=
+		BYTE_ALIGN(bs);=0A=
+		CHECK_BOUND(bs, 2);=0A=
+		count =3D *bs->cur++;=0A=
+		count <<=3D 8;=0A=
+		count =3D *bs->cur++;=0A=
+		break;=0A=
+	case SEMI:=0A=
+		BYTE_ALIGN(bs);=0A=
+		CHECK_BOUND(bs, 2);=0A=
+		count =3D get_len(bs);=0A=
+		break;=0A=
+	default:=0A=
+		count =3D get_bits(bs, f->sz);=0A=
+		break;=0A=
+	}=0A=
+	count +=3D f->lb;=0A=
+=0A=
+	/* Write Count */=0A=
+	if (base) {=0A=
+		effective_count =3D count > f->ub ? f->ub : count;=0A=
+		*(unsigned *) base =3D effective_count;=0A=
+		base +=3D sizeof(unsigned);=0A=
+	}=0A=
+=0A=
+	/* Decode nested field */=0A=
+	son =3D f->fields;=0A=
+	if (base)=0A=
+		base -=3D son->offset;=0A=
+	for (i =3D 0; i < count; i++) {=0A=
+		if (son->attr & OPEN) {=0A=
+			BYTE_ALIGN(bs);=0A=
+			len =3D get_len(bs);=0A=
+			CHECK_BOUND(bs, len);=0A=
+			if (!base || !(son->attr & DECODE)) {=0A=
+				PRINT("%*.s%s\n", (level + 1) * TAB_SIZE,=0A=
+				      " ", son->name);=0A=
+				bs->cur +=3D len;=0A=
+				continue;=0A=
+			}=0A=
+			beg =3D bs->cur;=0A=
+=0A=
+			if ((err =3D (Decoders[son->type]) (bs, son,=0A=
+							  i <=0A=
+							  effective_count ?=0A=
+							  base : NULL,=0A=
+							  level + 1)) >=0A=
+			    H323_ERROR_STOP)=0A=
+				return err;=0A=
+=0A=
+			bs->cur =3D beg + len;=0A=
+			bs->bit =3D 0;=0A=
+		} else=0A=
+		    if ((err =3D (Decoders[son->type]) (bs, son,=0A=
+						      i < effective_count ?=0A=
+						      base : NULL,=0A=
+						      level + 1)))=0A=
+			return err;=0A=
+=0A=
+		if (base)=0A=
+			base +=3D son->offset;=0A=
+	}=0A=
+=0A=
+	return H323_ERROR_NONE;=0A=
+}=0A=
+=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+int decode_choice(bitstr_t * bs, field_t * f, char *base, int level)=0A=
+{=0A=
+	unsigned type, ext, len =3D 0;=0A=
+	int err;=0A=
+	field_t *son;=0A=
+	unsigned char *beg =3D NULL;=0A=
+=0A=
+	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);=0A=
+=0A=
+	/* Decode? */=0A=
+	base =3D (base && (f->attr & DECODE)) ? base + f->offset : NULL;=0A=
+=0A=
+	/* Decode the choice index number */=0A=
+	if ((f->attr & EXT) && get_bit(bs)) {=0A=
+		ext =3D 1;=0A=
+		type =3D get_bits(bs, 7) + f->lb;=0A=
+	} else {=0A=
+		ext =3D 0;=0A=
+		type =3D get_bits(bs, f->sz);=0A=
+	}=0A=
+=0A=
+	/* Check Range */=0A=
+	if (type >=3D f->ub) {	/* Newer version? */=0A=
+		BYTE_ALIGN(bs);=0A=
+		len =3D get_len(bs);=0A=
+		CHECK_BOUND(bs, len);=0A=
+		bs->cur +=3D len;=0A=
+		return H323_ERROR_NONE;=0A=
+	}=0A=
+=0A=
+	/* Write Type */=0A=
+	if (base)=0A=
+		*(unsigned *) base =3D type;=0A=
+=0A=
+	/* Transfer to son level */=0A=
+	son =3D &f->fields[type];=0A=
+	if (son->attr & STOP) {=0A=
+		PRINT("%*.s%s\n", (level + 1) * TAB_SIZE, " ", son->name);=0A=
+		return H323_ERROR_STOP;=0A=
+	}=0A=
+=0A=
+	if (ext || (son->attr & OPEN)) {=0A=
+		BYTE_ALIGN(bs);=0A=
+		len =3D get_len(bs);=0A=
+		CHECK_BOUND(bs, len);=0A=
+		if (!base || !(son->attr & DECODE)) {=0A=
+			PRINT("%*.s%s\n", (level + 1) * TAB_SIZE, " ",=0A=
+			      son->name);=0A=
+			bs->cur +=3D len;=0A=
+			return H323_ERROR_NONE;=0A=
+		}=0A=
+		beg =3D bs->cur;=0A=
+=0A=
+		if ((err =3D (Decoders[son->type]) (bs, son, base, level + 1)) >=0A=
+		    H323_ERROR_STOP)=0A=
+			return err;=0A=
+=0A=
+		bs->cur =3D beg + len;=0A=
+		bs->bit =3D 0;=0A=
+	} else if ((err =3D (Decoders[son->type]) (bs, son, base, level + 1)))=0A=
+		return err;=0A=
+=0A=
+	return H323_ERROR_NONE;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+int DecodeRasMessage(unsigned char *buf, size_t sz, RasMessage * ras)=0A=
+{=0A=
+	static field_t ras_message =3D {=0A=
+		FNAME("RasMessage") CHOICE, 5, 24, 32, DECODE | EXT,=0A=
+		0, _RasMessage=0A=
+	};=0A=
+	bitstr_t bs;=0A=
+=0A=
+	bs.buf =3D bs.beg =3D bs.cur =3D buf;=0A=
+	bs.end =3D buf + sz;=0A=
+	bs.bit =3D 0;=0A=
+=0A=
+	return decode_choice(&bs, &ras_message, (char *) ras, 0);=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static int DecodeH323_UserInformation(unsigned char *buf, unsigned char =
*beg,=0A=
+				      size_t sz, H323_UserInformation * uuie)=0A=
+{=0A=
+	static field_t h323_userinformation =3D {=0A=
+		FNAME("H323-UserInformation") SEQ, 1, 2, 2, DECODE | EXT,=0A=
+		0, _H323_UserInformation=0A=
+	};=0A=
+	bitstr_t bs;=0A=
+=0A=
+	bs.buf =3D buf;=0A=
+	bs.beg =3D bs.cur =3D beg;=0A=
+	bs.end =3D beg + sz;=0A=
+	bs.bit =3D 0;=0A=
+=0A=
+	return decode_seq(&bs, &h323_userinformation, (char *) uuie, 0);=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+int DecodeMultimediaSystemControlMessage(unsigned char *buf, size_t sz,=0A=
+					 MultimediaSystemControlMessage *=0A=
+					 mscm)=0A=
+{=0A=
+	static field_t multimediasystemcontrolmessage =3D {=0A=
+		FNAME("MultimediaSystemControlMessage") CHOICE, 2, 4, 4,=0A=
+		DECODE | EXT, 0, _MultimediaSystemControlMessage=0A=
+	};=0A=
+	bitstr_t bs;=0A=
+=0A=
+	bs.buf =3D bs.beg =3D bs.cur =3D buf;=0A=
+	bs.end =3D buf + sz;=0A=
+	bs.bit =3D 0;=0A=
+=0A=
+	return decode_choice(&bs, &multimediasystemcontrolmessage,=0A=
+			     (char *) mscm, 0);=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+int DecodeQ931(unsigned char *buf, size_t sz, Q931 * q931)=0A=
+{=0A=
+	unsigned char *p =3D buf;=0A=
+	int len;=0A=
+=0A=
+	if (!p || sz < 1)=0A=
+		return H323_ERROR_BOUND;=0A=
+=0A=
+	/* Protocol Discriminator */=0A=
+	if (*p !=3D 0x08) {=0A=
+		PRINT("Unknown Protocol Discriminator\n");=0A=
+		return H323_ERROR_RANGE;=0A=
+	}=0A=
+	p++;=0A=
+	sz--;=0A=
+=0A=
+	/* CallReferenceValue */=0A=
+	if (sz < 1)=0A=
+		return H323_ERROR_BOUND;=0A=
+	len =3D *p++;=0A=
+	sz--;=0A=
+	if (sz < len)=0A=
+		return H323_ERROR_BOUND;=0A=
+	p +=3D len;=0A=
+	sz -=3D len;=0A=
+=0A=
+	/* Message Type */=0A=
+	if (sz < 1)=0A=
+		return H323_ERROR_BOUND;=0A=
+	q931->MessageType =3D *p++;=0A=
+	PRINT("MessageType =3D %02X\n", q931->MessageType);=0A=
+	if (*p & 0x80) {=0A=
+		p++;=0A=
+		sz--;=0A=
+	}=0A=
+=0A=
+	/* Decode Information Elements */=0A=
+	while (sz > 0) {=0A=
+		if (*p =3D=3D 0x7e) {	/* UserUserIE */=0A=
+			if (sz < 3)=0A=
+				break;=0A=
+			p++;=0A=
+			len =3D *p++ << 8;=0A=
+			len |=3D *p++;=0A=
+			sz -=3D 3;=0A=
+			if (sz < len)=0A=
+				break;=0A=
+			p++;=0A=
+			len--;=0A=
+			return DecodeH323_UserInformation(buf, p, len,=0A=
+							  &q931->UUIE);=0A=
+		}=0A=
+		p++;=0A=
+		sz--;=0A=
+		if (sz < 1)=0A=
+			break;=0A=
+		len =3D *p++;=0A=
+		if (sz < len)=0A=
+			break;=0A=
+		p +=3D len;=0A=
+		sz -=3D len;=0A=
+	}=0A=
+=0A=
+	PRINT("Q.931 UUIE not found\n");=0A=
+=0A=
+	return H323_ERROR_BOUND;=0A=
+}=0A=
diff -pruN =
linux-2.6.15.orig/net/ipv4/netfilter/ip_conntrack_helper_h323_asn1.h =
linux-2.6.15/net/ipv4/netfilter/ip_conntrack_helper_h323_asn1.h=0A=
--- linux-2.6.15.orig/net/ipv4/netfilter/ip_conntrack_helper_h323_asn1.h	=
1969-12-31 19:00:00.000000000 -0500=0A=
+++ linux-2.6.15/net/ipv4/netfilter/ip_conntrack_helper_h323_asn1.h	=
2006-03-15 19:33:50.000000000 -0500=0A=
@@ -0,0 +1,98 @@=0A=
+/***********************************************************************=
*****=0A=
+ * ip_conntrack_helper_h323_asn1.h - BER and PER decoding library for =
H.323=0A=
+ * 			      	     conntrack/NAT module.=0A=
+ *=0A=
+ * Copyright (c) 2006 by Jing Min Zhao <zhaojingmin@hotmail.com>=0A=
+ * =0A=
+ * This source code is licensed under General Public License version 2.=0A=
+ * =0A=
+ * =0A=
+ * This library is based on H.225 version 4, H.235 version 2 and H.245 =0A=
+ * version 7. It is extremely optimized to decode only the absolutely =0A=
+ * necessary objects in a signal for Linux kernel NAT module use, so =
don't =0A=
+ * expect it to be a full ASN.1 library.=0A=
+ * =0A=
+ * Features:=0A=
+ *=0A=
+ * 1. Small. The total size of code plus data is less than 20 KB (IA32).=0A=
+ * 2. Fast. Decoding Netmeeting's Setup signal 1 million times on a =
PIII 866 =0A=
+ *    takes only 3.9 seconds.=0A=
+ * 3. No memory allocation. It uses a static object. No need to =
initialize or=0A=
+ *    cleanup.=0A=
+ * 4. Thread safe.=0A=
+ * 5. Support embedded architectures that has no misaligned memory =
access =0A=
+ *    support.=0A=
+ *=0A=
+ * Limitations:=0A=
+ *=0A=
+ * 1. At most 30 faststart entries. Actually this is limited by =
ethernet's MTU.=0A=
+ *    If a Setup signal contains more than 30 faststart, the packet =
size will =0A=
+ *    very likely exceed the MTU size, then the TPKT will be =
fragmented. I =0A=
+ *    don't know how to handle this in a Netfilter module. Anybody can =
help? =0A=
+ *    Although I think 30 is enough for most of the cases.=0A=
+ * 2. IPv4 addresses only.=0A=
+ *=0A=
+ =
*************************************************************************=
***/=0A=
+=0A=
+#ifndef _IP_CONNTRACK_HELPER_H323_ASN1_H_=0A=
+#define _IP_CONNTRACK_HELPER_H323_ASN1_H_=0A=
+=0A=
+/***********************************************************************=
******=0A=
+ * H.323 Types=0A=
+ =
*************************************************************************=
***/=0A=
+#include "ip_conntrack_helper_h323_types.h"=0A=
+=0A=
+typedef struct {=0A=
+	enum {=0A=
+		Q931_NationalEscape =3D 0x00,=0A=
+		Q931_Alerting =3D 0x01,=0A=
+		Q931_CallProceeding =3D 0x02,=0A=
+		Q931_Connect =3D 0x07,=0A=
+		Q931_ConnectAck =3D 0x0F,=0A=
+		Q931_Progress =3D 0x03,=0A=
+		Q931_Setup =3D 0x05,=0A=
+		Q931_SetupAck =3D 0x0D,=0A=
+		Q931_Resume =3D 0x26,=0A=
+		Q931_ResumeAck =3D 0x2E,=0A=
+		Q931_ResumeReject =3D 0x22,=0A=
+		Q931_Suspend =3D 0x25,=0A=
+		Q931_SuspendAck =3D 0x2D,=0A=
+		Q931_SuspendReject =3D 0x21,=0A=
+		Q931_UserInformation =3D 0x20,=0A=
+		Q931_Disconnect =3D 0x45,=0A=
+		Q931_Release =3D 0x4D,=0A=
+		Q931_ReleaseComplete =3D 0x5A,=0A=
+		Q931_Restart =3D 0x46,=0A=
+		Q931_RestartAck =3D 0x4E,=0A=
+		Q931_Segment =3D 0x60,=0A=
+		Q931_CongestionCtrl =3D 0x79,=0A=
+		Q931_Information =3D 0x7B,=0A=
+		Q931_Notify =3D 0x6E,=0A=
+		Q931_Status =3D 0x7D,=0A=
+		Q931_StatusEnquiry =3D 0x75,=0A=
+		Q931_Facility =3D 0x62=0A=
+	} MessageType;=0A=
+	H323_UserInformation UUIE;=0A=
+} Q931;=0A=
+=0A=
+/***********************************************************************=
******=0A=
+ * Decode Functions Return Codes=0A=
+ =
*************************************************************************=
***/=0A=
+=0A=
+#define H323_ERROR_NONE 0	/* Decoded successfully */=0A=
+#define H323_ERROR_STOP 1	/* Decoding stopped, not really an error */=0A=
+#define H323_ERROR_BOUND -1=0A=
+#define H323_ERROR_RANGE -2=0A=
+=0A=
+=0A=
+/***********************************************************************=
******=0A=
+ * Decode Functions=0A=
+ =
*************************************************************************=
***/=0A=
+=0A=
+int DecodeRasMessage(unsigned char *buf, size_t sz, RasMessage * ras);=0A=
+int DecodeQ931(unsigned char *buf, size_t sz, Q931 * q931);=0A=
+int DecodeMultimediaSystemControlMessage(unsigned char *buf, size_t sz,=0A=
+					 MultimediaSystemControlMessage *=0A=
+					 mscm);=0A=
+=0A=
+#endif=0A=
diff -pruN =
linux-2.6.15.orig/net/ipv4/netfilter/ip_conntrack_helper_h323.c =
linux-2.6.15/net/ipv4/netfilter/ip_conntrack_helper_h323.c=0A=
--- linux-2.6.15.orig/net/ipv4/netfilter/ip_conntrack_helper_h323.c	=
1969-12-31 19:00:00.000000000 -0500=0A=
+++ linux-2.6.15/net/ipv4/netfilter/ip_conntrack_helper_h323.c	=
2006-03-15 19:29:59.000000000 -0500=0A=
@@ -0,0 +1,1731 @@=0A=
+/*=0A=
+ * H.323 connection tracking helper=0A=
+ * =0A=
+ * Copyright (c) 2006 Jing Min Zhao <zhaojingmin@users.sourceforge.net>=0A=
+ *=0A=
+ * This source code is licensed under General Public License version 2.=0A=
+ *=0A=
+ * Based on the 'brute force' H.323 connection tracking module by=0A=
+ * Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>=0A=
+ *   =0A=
+ * For more information, please see http://nath323.sourceforge.net/=0A=
+ *=0A=
+ * Changes:=0A=
+ * 	2006-02-01 - initial version 0.1=0A=
+ *	=0A=
+ *	2006-02-20 - version 0.2=0A=
+ *	  1. Changed source format to follow kernel conventions=0A=
+ *	  2. Deleted some unnecessary structures=0A=
+ *	  3. Minor fixes=0A=
+ *	  =0A=
+ * 	2006-03-10 - version 0.3=0A=
+ * 	  1. Added support for multiple TPKTs in one packet (suggested by=0A=
+ * 	     Patrick McHardy)=0A=
+ * 	  2. Avoid excessive stack usage (based on Patrick McHardy's patch)=0A=
+ * 	  3. Added support for non-linear skb (based on Patrick McHardy's =
patch)=0A=
+ * 	  4. Fixed missing H.245 module owner (Patrick McHardy)=0A=
+ * 	  5. Avoid long RAS expectation chains (Patrick McHardy)=0A=
+ * 	  6. Fixed incorrect __exit attribute (Patrick McHardy)=0A=
+ * 	  7. Eliminated unnecessary return code=0A=
+ * 	  8. Fixed incorrect use of NAT data from conntrack code (suggested =
by=0A=
+ * 	     Patrick McHardy)=0A=
+ * 	  9. Fixed TTL calculation error in RCF=0A=
+ * 	  10. Added TTL support in RRQ=0A=
+ * 	  11. Better support for separate TPKT header and data=0A=
+ * 	  =0A=
+ * 	2006-03-15 - version 0.4=0A=
+ * 	  1. Added support for T.120 channels=0A=
+ * 	  2. Added parameter gkrouted_only (suggested by Patrick McHardy)=0A=
+ * 	  3. Splitted ASN.1 code and data (suggested by Patrick McHardy)=0A=
+ * 	  4. Sort ASN.1 data to avoid forwarding declarations (suggested by =0A=
+ * 	     Patrick McHardy)=0A=
+ * 	  5. Reset next TPKT data length in get_tpkt_data()=0A=
+ */=0A=
+=0A=
+#include <linux/config.h>=0A=
+#include <linux/module.h>=0A=
+#include <linux/netfilter.h>=0A=
+#include <linux/ip.h>=0A=
+#include <net/tcp.h>=0A=
+#include <linux/netfilter_ipv4/ip_conntrack.h>=0A=
+#include <linux/netfilter_ipv4/ip_conntrack_core.h>=0A=
+#include <linux/netfilter_ipv4/ip_conntrack_helper.h>=0A=
+#include <linux/netfilter_ipv4/ip_conntrack_tuple.h>=0A=
+#include <linux/netfilter_ipv4/ip_conntrack_h323.h>=0A=
+#include <linux/moduleparam.h>=0A=
+=0A=
+#include "ip_conntrack_helper_h323_asn1.h"=0A=
+=0A=
+#if 0=0A=
+#define DEBUGP printk=0A=
+#else=0A=
+#define DEBUGP(format, args...)=0A=
+#endif=0A=
+=0A=
+/* Parameters */=0A=
+static int gkrouted_only;=0A=
+module_param(gkrouted_only, int, 0600);=0A=
+MODULE_PARM_DESC(gkrouted_only, "only accept calls from gatekeeper");=0A=
+=0A=
+/* Hooks for NAT */=0A=
+int (*set_h245_addr_hook) (struct sk_buff ** pskb,=0A=
+			   unsigned char **data, int dataoff,=0A=
+			   H245_TransportAddress * addr,=0A=
+			   u_int32_t ip, u_int16_t port);=0A=
+int (*set_h225_addr_hook) (struct sk_buff ** pskb,=0A=
+			   unsigned char **data, int dataoff,=0A=
+			   TransportAddress * addr,=0A=
+			   u_int32_t ip, u_int16_t port);=0A=
+int (*set_sig_addr_hook) (struct sk_buff ** pskb,=0A=
+			  struct ip_conntrack * ct,=0A=
+			  enum ip_conntrack_info ctinfo,=0A=
+			  unsigned char **data,=0A=
+			  TransportAddress * addr, int count);=0A=
+int (*set_ras_addr_hook) (struct sk_buff ** pskb,=0A=
+			  struct ip_conntrack * ct,=0A=
+			  enum ip_conntrack_info ctinfo,=0A=
+			  unsigned char **data,=0A=
+			  TransportAddress * addr, int count);=0A=
+int (*nat_rtp_rtcp_hook) (struct sk_buff ** pskb,=0A=
+			  struct ip_conntrack * ct,=0A=
+			  enum ip_conntrack_info ctinfo,=0A=
+			  unsigned char **data, int dataoff,=0A=
+			  H245_TransportAddress * addr,=0A=
+			  u_int16_t port, u_int16_t rtp_port,=0A=
+			  struct ip_conntrack_expect * rtp_exp,=0A=
+			  struct ip_conntrack_expect * rtcp_exp);=0A=
+int (*nat_t120_hook) (struct sk_buff ** pskb,=0A=
+		      struct ip_conntrack * ct,=0A=
+		      enum ip_conntrack_info ctinfo,=0A=
+		      unsigned char **data, int dataoff,=0A=
+		      H245_TransportAddress * addr, u_int16_t port,=0A=
+		      struct ip_conntrack_expect * exp);=0A=
+int (*nat_h245_hook) (struct sk_buff ** pskb,=0A=
+		      struct ip_conntrack * ct,=0A=
+		      enum ip_conntrack_info ctinfo,=0A=
+		      unsigned char **data, int dataoff,=0A=
+		      TransportAddress * addr, u_int16_t port,=0A=
+		      struct ip_conntrack_expect * exp);=0A=
+int (*nat_q931_hook) (struct sk_buff ** pskb,=0A=
+		      struct ip_conntrack * ct,=0A=
+		      enum ip_conntrack_info ctinfo,=0A=
+		      unsigned char **data, TransportAddress * addr, int idx,=0A=
+		      u_int16_t port, struct ip_conntrack_expect * exp);=0A=
+=0A=
+=0A=
+static DEFINE_SPINLOCK(ip_h323_lock);=0A=
+static char *h323_buffer;=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static int get_tpkt_data(struct sk_buff **pskb, struct ip_conntrack *ct,=0A=
+			 enum ip_conntrack_info ctinfo,=0A=
+			 unsigned char **data, int *datalen, int *dataoff)=0A=
+{=0A=
+	struct ip_ct_h323_master *info =3D &ct->help.ct_h323_info;=0A=
+	int dir =3D CTINFO2DIR(ctinfo);=0A=
+	struct tcphdr _tcph, *th;=0A=
+	int tcpdatalen;=0A=
+	int tcpdataoff;=0A=
+	unsigned char *tpkt;=0A=
+	int tpktlen;=0A=
+	int tpktoff;=0A=
+=0A=
+	/* Get TCP header */=0A=
+	th =3D skb_header_pointer(*pskb, (*pskb)->nh.iph->ihl * 4,=0A=
+				sizeof(_tcph), &_tcph);=0A=
+	if (th =3D=3D NULL)=0A=
+		return 0;=0A=
+=0A=
+	/* Get TCP data offset */=0A=
+	tcpdataoff =3D (*pskb)->nh.iph->ihl * 4 + th->doff * 4;=0A=
+=0A=
+	/* Get TCP data length */=0A=
+	tcpdatalen =3D (*pskb)->len - tcpdataoff;=0A=
+	if (tcpdatalen <=3D 0)	/* No TCP data */=0A=
+		goto clear_out;=0A=
+=0A=
+	if (*data =3D=3D NULL) {	/* first TPKT */=0A=
+		/* Get first TPKT pointer */=0A=
+		tpkt =3D skb_header_pointer(*pskb, tcpdataoff, tcpdatalen,=0A=
+					  h323_buffer);=0A=
+		BUG_ON(tpkt =3D=3D NULL);=0A=
+=0A=
+		/* Validate TPKT identifier */=0A=
+		if (tcpdatalen < 4 || tpkt[0] !=3D 0x03 || tpkt[1] !=3D 0) {=0A=
+			/* Netmeeting sends TPKT header and data separately */=0A=
+			if (info->tpkt_len[dir] > 0) {=0A=
+				DEBUGP("ip_ct_h323: previous packet "=0A=
+				       "indicated separate TPKT data of %hu "=0A=
+				       "bytes\n", info->tpkt_len[dir]);=0A=
+				if (info->tpkt_len[dir] <=3D tcpdatalen) {=0A=
+					/* Yes, there was a TPKT header =0A=
+					 * received */=0A=
+					*data =3D tpkt;=0A=
+					*datalen =3D info->tpkt_len[dir];=0A=
+					*dataoff =3D 0;=0A=
+					goto out;=0A=
+				}=0A=
+=0A=
+				/* Fragmented TPKT */=0A=
+				if (net_ratelimit())=0A=
+					printk("ip_ct_h323: "=0A=
+					       "fragmented TPKT\n");=0A=
+				goto clear_out;=0A=
+			}=0A=
+=0A=
+			/* It is not even a TPKT */=0A=
+			return 0;=0A=
+		}=0A=
+		tpktoff =3D 0;=0A=
+	} else {		/* Next TPKT */=0A=
+		tpktoff =3D *dataoff + *datalen;=0A=
+		tcpdatalen -=3D tpktoff;=0A=
+		if (tcpdatalen <=3D 4)	/* No more TPKT */=0A=
+			goto clear_out;=0A=
+		tpkt =3D *data + *datalen;=0A=
+=0A=
+		/* Validate TPKT identifier */=0A=
+		if (tpkt[0] !=3D 0x03 || tpkt[1] !=3D 0)=0A=
+			goto clear_out;=0A=
+	}=0A=
+=0A=
+	/* Validate TPKT length */=0A=
+	tpktlen =3D tpkt[2] * 256 + tpkt[3];=0A=
+	if (tpktlen > tcpdatalen) {=0A=
+		if (tcpdatalen =3D=3D 4) {	/* Separate TPKT header */=0A=
+			/* Netmeeting sends TPKT header and data separately */=0A=
+			DEBUGP("ip_ct_h323: separate TPKT header indicates "=0A=
+			       "there will be TPKT data of %hu bytes\n",=0A=
+			       tpktlen - 4);=0A=
+			info->tpkt_len[dir] =3D tpktlen - 4;=0A=
+			return 0;=0A=
+		}=0A=
+=0A=
+		if (net_ratelimit())=0A=
+			printk("ip_ct_h323: incomplete TPKT (fragmented?)\n");=0A=
+		goto clear_out;=0A=
+	}=0A=
+=0A=
+	/* This is the encapsulated data */=0A=
+	*data =3D tpkt + 4;=0A=
+	*datalen =3D tpktlen - 4;=0A=
+	*dataoff =3D tpktoff + 4;=0A=
+=0A=
+      out:=0A=
+	/* Clear TPKT length */=0A=
+	info->tpkt_len[dir] =3D 0;=0A=
+	return 1;=0A=
+=0A=
+      clear_out:=0A=
+	info->tpkt_len[dir] =3D 0;=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+int get_h245_addr(unsigned char *data, H245_TransportAddress * addr,=0A=
+		  u_int32_t * ip, u_int16_t * port)=0A=
+{=0A=
+	unsigned char *p;=0A=
+=0A=
+	if (addr->choice !=3D eH245_TransportAddress_unicastAddress ||=0A=
+	    addr->unicastAddress.choice !=3D eUnicastAddress_iPAddress)=0A=
+		return 0;=0A=
+=0A=
+	p =3D data + addr->unicastAddress.iPAddress.network;=0A=
+	*ip =3D htonl((p[0] << 24) | (p[1] << 16) | (p[2] << 8) | (p[3]));=0A=
+	*port =3D (p[4] << 8) | (p[5]);=0A=
+=0A=
+	return 1;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static int expect_rtp_rtcp(struct sk_buff **pskb, struct ip_conntrack =
*ct,=0A=
+			   enum ip_conntrack_info ctinfo,=0A=
+			   unsigned char **data, int dataoff,=0A=
+			   H245_TransportAddress * addr)=0A=
+{=0A=
+	int dir =3D CTINFO2DIR(ctinfo);=0A=
+	int ret =3D 0;=0A=
+	u_int32_t ip;=0A=
+	u_int16_t port;=0A=
+	u_int16_t rtp_port;=0A=
+	struct ip_conntrack_expect *rtp_exp;=0A=
+	struct ip_conntrack_expect *rtcp_exp;=0A=
+=0A=
+	/* Read RTP or RTCP address */=0A=
+	if (!get_h245_addr(*data, addr, &ip, &port) ||=0A=
+	    ip !=3D ct->tuplehash[dir].tuple.src.ip || port =3D=3D 0)=0A=
+		return 0;=0A=
+=0A=
+	/* RTP port is even */=0A=
+	rtp_port =3D port & (~1);=0A=
+=0A=
+	/* Create expect for RTP */=0A=
+	if ((rtp_exp =3D ip_conntrack_expect_alloc(ct)) =3D=3D NULL)=0A=
+		return -1;=0A=
+	rtp_exp->tuple.src.ip =3D ct->tuplehash[!dir].tuple.src.ip;=0A=
+	rtp_exp->tuple.src.u.udp.port =3D 0;=0A=
+	rtp_exp->tuple.dst.ip =3D ct->tuplehash[!dir].tuple.dst.ip;=0A=
+	rtp_exp->tuple.dst.u.udp.port =3D htons(rtp_port);=0A=
+	rtp_exp->tuple.dst.protonum =3D IPPROTO_UDP;=0A=
+	rtp_exp->mask.src.ip =3D 0xFFFFFFFF;=0A=
+	rtp_exp->mask.src.u.udp.port =3D 0;=0A=
+	rtp_exp->mask.dst.ip =3D 0xFFFFFFFF;=0A=
+	rtp_exp->mask.dst.u.udp.port =3D 0xFFFF;=0A=
+	rtp_exp->mask.dst.protonum =3D 0xFF;=0A=
+	rtp_exp->flags =3D 0;=0A=
+=0A=
+	/* Create expect for RTCP */=0A=
+	if ((rtcp_exp =3D ip_conntrack_expect_alloc(ct)) =3D=3D NULL) {=0A=
+		ip_conntrack_expect_put(rtp_exp);=0A=
+		return -1;=0A=
+	}=0A=
+	rtcp_exp->tuple.src.ip =3D ct->tuplehash[!dir].tuple.src.ip;=0A=
+	rtcp_exp->tuple.src.u.udp.port =3D 0;=0A=
+	rtcp_exp->tuple.dst.ip =3D ct->tuplehash[!dir].tuple.dst.ip;=0A=
+	rtcp_exp->tuple.dst.u.udp.port =3D htons(rtp_port + 1);=0A=
+	rtcp_exp->tuple.dst.protonum =3D IPPROTO_UDP;=0A=
+	rtcp_exp->mask.src.ip =3D 0xFFFFFFFF;=0A=
+	rtcp_exp->mask.src.u.udp.port =3D 0;=0A=
+	rtcp_exp->mask.dst.ip =3D 0xFFFFFFFF;=0A=
+	rtcp_exp->mask.dst.u.udp.port =3D 0xFFFF;=0A=
+	rtcp_exp->mask.dst.protonum =3D 0xFF;=0A=
+	rtcp_exp->flags =3D 0;=0A=
+=0A=
+	if (ct->tuplehash[dir].tuple.src.ip !=3D=0A=
+	    ct->tuplehash[!dir].tuple.dst.ip && nat_rtp_rtcp_hook) {=0A=
+		/* NAT needed */=0A=
+		ret =3D nat_rtp_rtcp_hook(pskb, ct, ctinfo, data, dataoff,=0A=
+					addr, port, rtp_port, rtp_exp,=0A=
+					rtcp_exp);=0A=
+	} else {		/* Conntrack only */=0A=
+		rtp_exp->expectfn =3D NULL;=0A=
+		rtcp_exp->expectfn =3D NULL;=0A=
+=0A=
+		if (ip_conntrack_expect_related(rtp_exp) =3D=3D 0) {=0A=
+			if (ip_conntrack_expect_related(rtcp_exp) =3D=3D 0) {=0A=
+				DEBUGP("ip_ct_h323: expect RTP "=0A=
+				       "%u.%u.%u.%u:%hu->%u.%u.%u.%u:%hu\n",=0A=
+				       NIPQUAD(rtp_exp->tuple.src.ip),=0A=
+				       ntohs(rtp_exp->tuple.src.u.udp.port),=0A=
+				       NIPQUAD(rtp_exp->tuple.dst.ip),=0A=
+				       ntohs(rtp_exp->tuple.dst.u.udp.port));=0A=
+				DEBUGP("ip_ct_h323: expect RTCP "=0A=
+				       "%u.%u.%u.%u:%hu->%u.%u.%u.%u:%hu\n",=0A=
+				       NIPQUAD(rtcp_exp->tuple.src.ip),=0A=
+				       ntohs(rtcp_exp->tuple.src.u.udp.port),=0A=
+				       NIPQUAD(rtcp_exp->tuple.dst.ip),=0A=
+				       ntohs(rtcp_exp->tuple.dst.u.udp.port));=0A=
+			} else {=0A=
+				ip_conntrack_unexpect_related(rtp_exp);=0A=
+				ret =3D -1;=0A=
+			}=0A=
+		} else=0A=
+			ret =3D -1;=0A=
+	}=0A=
+=0A=
+	ip_conntrack_expect_put(rtp_exp);=0A=
+	ip_conntrack_expect_put(rtcp_exp);=0A=
+=0A=
+	return ret;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static int expect_t120(struct sk_buff **pskb,=0A=
+		       struct ip_conntrack *ct,=0A=
+		       enum ip_conntrack_info ctinfo,=0A=
+		       unsigned char **data, int dataoff,=0A=
+		       H245_TransportAddress * addr)=0A=
+{=0A=
+	int dir =3D CTINFO2DIR(ctinfo);=0A=
+	int ret =3D 0;=0A=
+	u_int32_t ip;=0A=
+	u_int16_t port;=0A=
+	struct ip_conntrack_expect *exp =3D NULL;=0A=
+=0A=
+	/* Read T.120 address */=0A=
+	if (!get_h245_addr(*data, addr, &ip, &port) ||=0A=
+	    ip !=3D ct->tuplehash[dir].tuple.src.ip || port =3D=3D 0)=0A=
+		return 0;=0A=
+=0A=
+	/* Create expect for T.120 connections */=0A=
+	if ((exp =3D ip_conntrack_expect_alloc(ct)) =3D=3D NULL)=0A=
+		return -1;=0A=
+	exp->tuple.src.ip =3D ct->tuplehash[!dir].tuple.src.ip;=0A=
+	exp->tuple.src.u.tcp.port =3D 0;=0A=
+	exp->tuple.dst.ip =3D ct->tuplehash[!dir].tuple.dst.ip;=0A=
+	exp->tuple.dst.u.tcp.port =3D htons(port);=0A=
+	exp->tuple.dst.protonum =3D IPPROTO_TCP;=0A=
+	exp->mask.src.ip =3D 0xFFFFFFFF;=0A=
+	exp->mask.src.u.tcp.port =3D 0;=0A=
+	exp->mask.dst.ip =3D 0xFFFFFFFF;=0A=
+	exp->mask.dst.u.tcp.port =3D 0xFFFF;=0A=
+	exp->mask.dst.protonum =3D 0xFF;=0A=
+	exp->flags =3D IP_CT_EXPECT_PERMANENT;	/* Accept multiple channels */=0A=
+=0A=
+	if (ct->tuplehash[dir].tuple.src.ip !=3D=0A=
+	    ct->tuplehash[!dir].tuple.dst.ip && nat_t120_hook) {=0A=
+		/* NAT needed */=0A=
+		ret =3D nat_t120_hook(pskb, ct, ctinfo, data, dataoff, addr,=0A=
+				    port, exp);=0A=
+	} else {		/* Conntrack only */=0A=
+		exp->expectfn =3D NULL;=0A=
+		if (ip_conntrack_expect_related(exp) =3D=3D 0) {=0A=
+			DEBUGP("ip_ct_h323: expect T.120 "=0A=
+			       "%u.%u.%u.%u:%hu->%u.%u.%u.%u:%hu\n",=0A=
+			       NIPQUAD(exp->tuple.src.ip),=0A=
+			       ntohs(exp->tuple.src.u.tcp.port),=0A=
+			       NIPQUAD(exp->tuple.dst.ip),=0A=
+			       ntohs(exp->tuple.dst.u.tcp.port));=0A=
+		} else=0A=
+			ret =3D -1;=0A=
+	}=0A=
+=0A=
+	ip_conntrack_expect_put(exp);=0A=
+=0A=
+	return ret;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static int process_h245_channel(struct sk_buff **pskb,=0A=
+				struct ip_conntrack *ct,=0A=
+				enum ip_conntrack_info ctinfo,=0A=
+				unsigned char **data, int dataoff,=0A=
+				H2250LogicalChannelParameters * channel)=0A=
+{=0A=
+	int ret;=0A=
+=0A=
+	if (channel->options & eH2250LogicalChannelParameters_mediaChannel) {=0A=
+		/* RTP */=0A=
+		ret =3D expect_rtp_rtcp(pskb, ct, ctinfo, data, dataoff,=0A=
+				      &channel->mediaChannel);=0A=
+		if (ret < 0)=0A=
+			return -1;=0A=
+	}=0A=
+=0A=
+	if (channel->=0A=
+	    options & eH2250LogicalChannelParameters_mediaControlChannel) {=0A=
+		/* RTCP */=0A=
+		ret =3D expect_rtp_rtcp(pskb, ct, ctinfo, data, dataoff,=0A=
+				      &channel->mediaControlChannel);=0A=
+		if (ret < 0)=0A=
+			return -1;=0A=
+	}=0A=
+=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static int process_olc(struct sk_buff **pskb, struct ip_conntrack *ct,=0A=
+		       enum ip_conntrack_info ctinfo,=0A=
+		       unsigned char **data, int dataoff,=0A=
+		       OpenLogicalChannel * olc)=0A=
+{=0A=
+	int ret;=0A=
+=0A=
+	DEBUGP("ip_ct_h323: OpenLogicalChannel\n");=0A=
+=0A=
+	if (olc->forwardLogicalChannelParameters.multiplexParameters.choice =
=3D=3D=0A=
+	    =
eOpenLogicalChannel_forwardLogicalChannelParameters_multiplexParameters_h=
2250LogicalChannelParameters)=0A=
+	{=0A=
+		ret =3D process_h245_channel(pskb, ct, ctinfo, data, dataoff,=0A=
+					   &olc->=0A=
+					   forwardLogicalChannelParameters.=0A=
+					   multiplexParameters.=0A=
+					   h2250LogicalChannelParameters);=0A=
+		if (ret < 0)=0A=
+			return -1;=0A=
+	}=0A=
+=0A=
+	if ((olc->options &=0A=
+	     eOpenLogicalChannel_reverseLogicalChannelParameters) &&=0A=
+	    (olc->reverseLogicalChannelParameters.options &=0A=
+	     =
eOpenLogicalChannel_reverseLogicalChannelParameters_multiplexParameters)=0A=
+	    && (olc->reverseLogicalChannelParameters.multiplexParameters.=0A=
+		choice =3D=3D=0A=
+		=
eOpenLogicalChannel_reverseLogicalChannelParameters_multiplexParameters_h=
2250LogicalChannelParameters))=0A=
+	{=0A=
+		ret =3D=0A=
+		    process_h245_channel(pskb, ct, ctinfo, data, dataoff,=0A=
+					 &olc->=0A=
+					 reverseLogicalChannelParameters.=0A=
+					 multiplexParameters.=0A=
+					 h2250LogicalChannelParameters);=0A=
+		if (ret < 0)=0A=
+			return -1;=0A=
+	}=0A=
+=0A=
+	if ((olc->options & eOpenLogicalChannel_separateStack) &&=0A=
+	    olc->forwardLogicalChannelParameters.dataType.choice =3D=3D=0A=
+	    eDataType_data &&=0A=
+	    olc->forwardLogicalChannelParameters.dataType.data.application.=0A=
+	    choice =3D=3D eDataApplicationCapability_application_t120 &&=0A=
+	    olc->forwardLogicalChannelParameters.dataType.data.application.=0A=
+	    t120.choice =3D=3D eDataProtocolCapability_separateLANStack &&=0A=
+	    olc->separateStack.networkAddress.choice =3D=3D=0A=
+	    eNetworkAccessParameters_networkAddress_localAreaAddress) {=0A=
+		ret =3D expect_t120(pskb, ct, ctinfo, data, dataoff,=0A=
+				  &olc->separateStack.networkAddress.=0A=
+				  localAreaAddress);=0A=
+		if (ret < 0)=0A=
+			return -1;=0A=
+	}=0A=
+=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static int process_olca(struct sk_buff **pskb, struct ip_conntrack *ct,=0A=
+			enum ip_conntrack_info ctinfo,=0A=
+			unsigned char **data, int dataoff,=0A=
+			OpenLogicalChannelAck * olca)=0A=
+{=0A=
+	H2250LogicalChannelAckParameters *ack;=0A=
+	int ret;=0A=
+=0A=
+	DEBUGP("ip_ct_h323: OpenLogicalChannelAck\n");=0A=
+=0A=
+	if ((olca->options &=0A=
+	     eOpenLogicalChannelAck_reverseLogicalChannelParameters) &&=0A=
+	    (olca->reverseLogicalChannelParameters.options &=0A=
+	     =
eOpenLogicalChannelAck_reverseLogicalChannelParameters_multiplexParameter=
s)=0A=
+	    && (olca->reverseLogicalChannelParameters.multiplexParameters.=0A=
+		choice =3D=3D=0A=
+		=
eOpenLogicalChannelAck_reverseLogicalChannelParameters_multiplexParameter=
s_h2250LogicalChannelParameters))=0A=
+	{=0A=
+		ret =3D process_h245_channel(pskb, ct, ctinfo, data, dataoff,=0A=
+					   &olca->=0A=
+					   reverseLogicalChannelParameters.=0A=
+					   multiplexParameters.=0A=
+					   h2250LogicalChannelParameters);=0A=
+		if (ret < 0)=0A=
+			return -1;=0A=
+	}=0A=
+=0A=
+	if ((olca->options &=0A=
+	     eOpenLogicalChannelAck_forwardMultiplexAckParameters) &&=0A=
+	    (olca->forwardMultiplexAckParameters.choice =3D=3D=0A=
+	     =
eOpenLogicalChannelAck_forwardMultiplexAckParameters_h2250LogicalChannelA=
ckParameters))=0A=
+	{=0A=
+		ack =3D &olca->forwardMultiplexAckParameters.=0A=
+		    h2250LogicalChannelAckParameters;=0A=
+		if (ack->options &=0A=
+		    eH2250LogicalChannelAckParameters_mediaChannel) {=0A=
+			/* RTP */=0A=
+			ret =3D expect_rtp_rtcp(pskb, ct, ctinfo, data, dataoff,=0A=
+					      &ack->mediaChannel);=0A=
+			if (ret < 0)=0A=
+				return -1;=0A=
+		}=0A=
+=0A=
+		if (ack->options &=0A=
+		    eH2250LogicalChannelAckParameters_mediaControlChannel) {=0A=
+			/* RTCP */=0A=
+			ret =3D expect_rtp_rtcp(pskb, ct, ctinfo, data, dataoff,=0A=
+					      &ack->mediaControlChannel);=0A=
+			if (ret < 0)=0A=
+				return -1;=0A=
+		}=0A=
+	}=0A=
+=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static int process_h245(struct sk_buff **pskb, struct ip_conntrack *ct,=0A=
+			enum ip_conntrack_info ctinfo,=0A=
+			unsigned char **data, int dataoff,=0A=
+			MultimediaSystemControlMessage * mscm)=0A=
+{=0A=
+	switch (mscm->choice) {=0A=
+	case eMultimediaSystemControlMessage_request:=0A=
+		if (mscm->request.choice =3D=3D=0A=
+		    eRequestMessage_openLogicalChannel) {=0A=
+			return process_olc(pskb, ct, ctinfo, data, dataoff,=0A=
+					   &mscm->request.openLogicalChannel);=0A=
+		}=0A=
+		DEBUGP("ip_ct_h323: H.245 Request %d\n",=0A=
+		       mscm->request.choice);=0A=
+		break;=0A=
+	case eMultimediaSystemControlMessage_response:=0A=
+		if (mscm->response.choice =3D=3D=0A=
+		    eResponseMessage_openLogicalChannelAck) {=0A=
+			return process_olca(pskb, ct, ctinfo, data, dataoff,=0A=
+					    &mscm->response.=0A=
+					    openLogicalChannelAck);=0A=
+		}=0A=
+		DEBUGP("ip_ct_h323: H.245 Response %d\n",=0A=
+		       mscm->response.choice);=0A=
+		break;=0A=
+	default:=0A=
+		DEBUGP("ip_ct_h323: H.245 signal %d\n", mscm->choice);=0A=
+		break;=0A=
+	}=0A=
+=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static int h245_help(struct sk_buff **pskb, struct ip_conntrack *ct,=0A=
+		     enum ip_conntrack_info ctinfo)=0A=
+{=0A=
+	static MultimediaSystemControlMessage mscm;=0A=
+	unsigned char *data =3D NULL;=0A=
+	int datalen;=0A=
+	int dataoff;=0A=
+	int ret;=0A=
+=0A=
+	/* Until there's been traffic both ways, don't look in packets. */=0A=
+	if (ctinfo !=3D IP_CT_ESTABLISHED=0A=
+	    && ctinfo !=3D IP_CT_ESTABLISHED + IP_CT_IS_REPLY) {=0A=
+		return NF_ACCEPT;=0A=
+	}=0A=
+	DEBUGP("ip_ct_h245: skblen =3D %u\n", (*pskb)->len);=0A=
+=0A=
+	spin_lock_bh(&ip_h323_lock);=0A=
+=0A=
+	/* Process each TPKT */=0A=
+	while (get_tpkt_data(pskb, ct, ctinfo, &data, &datalen, &dataoff)) {=0A=
+		DEBUGP("ip_ct_h245: TPKT %u.%u.%u.%u->%u.%u.%u.%u, len=3D%d\n",=0A=
+		       NIPQUAD((*pskb)->nh.iph->saddr),=0A=
+		       NIPQUAD((*pskb)->nh.iph->daddr), datalen);=0A=
+=0A=
+		/* Decode H.245 signal */=0A=
+		ret =3D DecodeMultimediaSystemControlMessage(data, datalen,=0A=
+							   &mscm);=0A=
+		if (ret < 0) {=0A=
+			if (net_ratelimit())=0A=
+				printk("ip_ct_h245: decoding error: %s\n",=0A=
+				       ret =3D=3D H323_ERROR_BOUND ?=0A=
+				       "out of bound" : "out of range");=0A=
+			/* We don't drop when decoding error */=0A=
+			break;=0A=
+		}=0A=
+=0A=
+		/* Process H.245 signal */=0A=
+		if (process_h245(pskb, ct, ctinfo, &data, dataoff, &mscm) < 0)=0A=
+			goto drop;=0A=
+	}=0A=
+=0A=
+	spin_unlock_bh(&ip_h323_lock);=0A=
+	return NF_ACCEPT;=0A=
+=0A=
+      drop:=0A=
+	spin_unlock_bh(&ip_h323_lock);=0A=
+	if (net_ratelimit())=0A=
+		printk("ip_ct_h245: packet dropped\n");=0A=
+	return NF_DROP;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static struct ip_conntrack_helper ip_conntrack_helper_h245 =3D {=0A=
+	.name =3D "H.245",=0A=
+	.me =3D THIS_MODULE,=0A=
+	.max_expected =3D H323_RTP_CHANNEL_MAX * 4 + 2 /* T.120 */ ,=0A=
+	.timeout =3D 240,=0A=
+	.tuple =3D {.dst =3D {.protonum =3D IPPROTO_TCP}},=0A=
+	.mask =3D {.src =3D {.u =3D {0xFFFF}},=0A=
+		 .dst =3D {.protonum =3D 0xFF}},=0A=
+	.help =3D h245_help=0A=
+};=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+void ip_conntrack_h245_expect(struct ip_conntrack *new,=0A=
+			      struct ip_conntrack_expect *this)=0A=
+{=0A=
+	write_lock_bh(&ip_conntrack_lock);=0A=
+	new->helper =3D &ip_conntrack_helper_h245;=0A=
+	write_unlock_bh(&ip_conntrack_lock);=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static int get_h225_addr(unsigned char *data, TransportAddress * addr,=0A=
+			 u_int32_t * ip, u_int16_t * port)=0A=
+{=0A=
+	unsigned char *p;=0A=
+=0A=
+	if (addr->choice !=3D eTransportAddress_ipAddress)=0A=
+		return 0;=0A=
+=0A=
+	p =3D data + addr->ipAddress.ip;=0A=
+	*ip =3D htonl((p[0] << 24) | (p[1] << 16) | (p[2] << 8) | (p[3]));=0A=
+	*port =3D (p[4] << 8) | (p[5]);=0A=
+=0A=
+	return 1;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static int expect_h245(struct sk_buff **pskb, struct ip_conntrack *ct,=0A=
+		       enum ip_conntrack_info ctinfo,=0A=
+		       unsigned char **data, int dataoff,=0A=
+		       TransportAddress * addr)=0A=
+{=0A=
+	int dir =3D CTINFO2DIR(ctinfo);=0A=
+	int ret =3D 0;=0A=
+	u_int32_t ip;=0A=
+	u_int16_t port;=0A=
+	struct ip_conntrack_expect *exp =3D NULL;=0A=
+=0A=
+	/* Read h245Address */=0A=
+	if (!get_h225_addr(*data, addr, &ip, &port) ||=0A=
+	    ip !=3D ct->tuplehash[dir].tuple.src.ip || port =3D=3D 0)=0A=
+		return 0;=0A=
+=0A=
+	/* Create expect for h245 connection */=0A=
+	if ((exp =3D ip_conntrack_expect_alloc(ct)) =3D=3D NULL)=0A=
+		return -1;=0A=
+	exp->tuple.src.ip =3D ct->tuplehash[!dir].tuple.src.ip;=0A=
+	exp->tuple.src.u.tcp.port =3D 0;=0A=
+	exp->tuple.dst.ip =3D ct->tuplehash[!dir].tuple.dst.ip;=0A=
+	exp->tuple.dst.u.tcp.port =3D htons(port);=0A=
+	exp->tuple.dst.protonum =3D IPPROTO_TCP;=0A=
+	exp->mask.src.ip =3D 0xFFFFFFFF;=0A=
+	exp->mask.src.u.tcp.port =3D 0;=0A=
+	exp->mask.dst.ip =3D 0xFFFFFFFF;=0A=
+	exp->mask.dst.u.tcp.port =3D 0xFFFF;=0A=
+	exp->mask.dst.protonum =3D 0xFF;=0A=
+	exp->flags =3D 0;=0A=
+=0A=
+	if (ct->tuplehash[dir].tuple.src.ip !=3D=0A=
+	    ct->tuplehash[!dir].tuple.dst.ip && nat_h245_hook) {=0A=
+		/* NAT needed */=0A=
+		ret =3D nat_h245_hook(pskb, ct, ctinfo, data, dataoff, addr,=0A=
+				    port, exp);=0A=
+	} else {		/* Conntrack only */=0A=
+		exp->expectfn =3D ip_conntrack_h245_expect;=0A=
+=0A=
+		if (ip_conntrack_expect_related(exp) =3D=3D 0) {=0A=
+			DEBUGP("ip_ct_q931: expect H.245 "=0A=
+			       "%u.%u.%u.%u:%hu->%u.%u.%u.%u:%hu\n",=0A=
+			       NIPQUAD(exp->tuple.src.ip),=0A=
+			       ntohs(exp->tuple.src.u.tcp.port),=0A=
+			       NIPQUAD(exp->tuple.dst.ip),=0A=
+			       ntohs(exp->tuple.dst.u.tcp.port));=0A=
+		} else=0A=
+			ret =3D -1;=0A=
+	}=0A=
+=0A=
+	ip_conntrack_expect_put(exp);=0A=
+=0A=
+	return ret;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static int process_setup(struct sk_buff **pskb, struct ip_conntrack *ct,=0A=
+			 enum ip_conntrack_info ctinfo,=0A=
+			 unsigned char **data, int dataoff,=0A=
+			 Setup_UUIE * setup)=0A=
+{=0A=
+	int dir =3D CTINFO2DIR(ctinfo);=0A=
+	int ret;=0A=
+	int i;=0A=
+	u_int32_t ip;=0A=
+	u_int16_t port;=0A=
+=0A=
+	DEBUGP("ip_ct_q931: Setup\n");=0A=
+=0A=
+	if (setup->options & eSetup_UUIE_h245Address) {=0A=
+		ret =3D expect_h245(pskb, ct, ctinfo, data, dataoff,=0A=
+				  &setup->h245Address);=0A=
+		if (ret < 0)=0A=
+			return -1;=0A=
+	}=0A=
+=0A=
+	if ((setup->options & eSetup_UUIE_destCallSignalAddress) &&=0A=
+	    (set_h225_addr_hook) &&=0A=
+	    get_h225_addr(*data, &setup->destCallSignalAddress, &ip, &port) &&=0A=
+	    ip !=3D ct->tuplehash[!dir].tuple.src.ip) {=0A=
+		DEBUGP("ip_ct_q931: set destCallSignalAddress "=0A=
+		       "%u.%u.%u.%u:%hu->%u.%u.%u.%u:%hu\n",=0A=
+		       NIPQUAD(ip), port,=0A=
+		       NIPQUAD(ct->tuplehash[!dir].tuple.src.ip),=0A=
+		       ntohs(ct->tuplehash[!dir].tuple.src.u.tcp.port));=0A=
+		ret =3D set_h225_addr_hook(pskb, data, dataoff,=0A=
+					 &setup->destCallSignalAddress,=0A=
+					 ct->tuplehash[!dir].tuple.src.ip,=0A=
+					 ntohs(ct->tuplehash[!dir].tuple.src.=0A=
+					       u.tcp.port));=0A=
+		if (ret < 0)=0A=
+			return -1;=0A=
+	}=0A=
+=0A=
+	if ((setup->options & eSetup_UUIE_sourceCallSignalAddress) &&=0A=
+	    (set_h225_addr_hook) &&=0A=
+	    get_h225_addr(*data, &setup->sourceCallSignalAddress, &ip, &port)=0A=
+	    && ip !=3D ct->tuplehash[!dir].tuple.dst.ip) {=0A=
+		DEBUGP("ip_ct_q931: set sourceCallSignalAddress "=0A=
+		       "%u.%u.%u.%u:%hu->%u.%u.%u.%u:%hu\n",=0A=
+		       NIPQUAD(ip), port,=0A=
+		       NIPQUAD(ct->tuplehash[!dir].tuple.dst.ip),=0A=
+		       ntohs(ct->tuplehash[!dir].tuple.dst.u.tcp.port));=0A=
+		ret =3D set_h225_addr_hook(pskb, data, dataoff,=0A=
+					 &setup->sourceCallSignalAddress,=0A=
+					 ct->tuplehash[!dir].tuple.dst.ip,=0A=
+					 ntohs(ct->tuplehash[!dir].tuple.dst.=0A=
+					       u.tcp.port));=0A=
+		if (ret < 0)=0A=
+			return -1;=0A=
+	}=0A=
+=0A=
+	if (setup->options & eSetup_UUIE_fastStart) {=0A=
+		for (i =3D 0; i < setup->fastStart.count; i++) {=0A=
+			ret =3D process_olc(pskb, ct, ctinfo, data, dataoff,=0A=
+					  &setup->fastStart.item[i]);=0A=
+			if (ret < 0)=0A=
+				return -1;=0A=
+		}=0A=
+	}=0A=
+=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static int process_callproceeding(struct sk_buff **pskb,=0A=
+				  struct ip_conntrack *ct,=0A=
+				  enum ip_conntrack_info ctinfo,=0A=
+				  unsigned char **data, int dataoff,=0A=
+				  CallProceeding_UUIE * callproc)=0A=
+{=0A=
+	int ret;=0A=
+	int i;=0A=
+=0A=
+	DEBUGP("ip_ct_q931: CallProceeding\n");=0A=
+=0A=
+	if (callproc->options & eCallProceeding_UUIE_h245Address) {=0A=
+		ret =3D expect_h245(pskb, ct, ctinfo, data, dataoff,=0A=
+				  &callproc->h245Address);=0A=
+		if (ret < 0)=0A=
+			return -1;=0A=
+	}=0A=
+=0A=
+	if (callproc->options & eCallProceeding_UUIE_fastStart) {=0A=
+		for (i =3D 0; i < callproc->fastStart.count; i++) {=0A=
+			ret =3D process_olc(pskb, ct, ctinfo, data, dataoff,=0A=
+					  &callproc->fastStart.item[i]);=0A=
+			if (ret < 0)=0A=
+				return -1;=0A=
+		}=0A=
+	}=0A=
+=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static int process_connect(struct sk_buff **pskb, struct ip_conntrack =
*ct,=0A=
+			   enum ip_conntrack_info ctinfo,=0A=
+			   unsigned char **data, int dataoff,=0A=
+			   Connect_UUIE * connect)=0A=
+{=0A=
+	int ret;=0A=
+	int i;=0A=
+=0A=
+	DEBUGP("ip_ct_q931: Connect\n");=0A=
+=0A=
+	if (connect->options & eConnect_UUIE_h245Address) {=0A=
+		ret =3D expect_h245(pskb, ct, ctinfo, data, dataoff,=0A=
+				  &connect->h245Address);=0A=
+		if (ret < 0)=0A=
+			return -1;=0A=
+	}=0A=
+=0A=
+	if (connect->options & eConnect_UUIE_fastStart) {=0A=
+		for (i =3D 0; i < connect->fastStart.count; i++) {=0A=
+			ret =3D process_olc(pskb, ct, ctinfo, data, dataoff,=0A=
+					  &connect->fastStart.item[i]);=0A=
+			if (ret < 0)=0A=
+				return -1;=0A=
+		}=0A=
+	}=0A=
+=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static int process_alerting(struct sk_buff **pskb, struct ip_conntrack =
*ct,=0A=
+			    enum ip_conntrack_info ctinfo,=0A=
+			    unsigned char **data, int dataoff,=0A=
+			    Alerting_UUIE * alert)=0A=
+{=0A=
+	int ret;=0A=
+	int i;=0A=
+=0A=
+	DEBUGP("ip_ct_q931: Alerting\n");=0A=
+=0A=
+	if (alert->options & eAlerting_UUIE_h245Address) {=0A=
+		ret =3D expect_h245(pskb, ct, ctinfo, data, dataoff,=0A=
+				  &alert->h245Address);=0A=
+		if (ret < 0)=0A=
+			return -1;=0A=
+	}=0A=
+=0A=
+	if (alert->options & eAlerting_UUIE_fastStart) {=0A=
+		for (i =3D 0; i < alert->fastStart.count; i++) {=0A=
+			ret =3D process_olc(pskb, ct, ctinfo, data, dataoff,=0A=
+					  &alert->fastStart.item[i]);=0A=
+			if (ret < 0)=0A=
+				return -1;=0A=
+		}=0A=
+	}=0A=
+=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static int process_information(struct sk_buff **pskb,=0A=
+			       struct ip_conntrack *ct,=0A=
+			       enum ip_conntrack_info ctinfo,=0A=
+			       unsigned char **data, int dataoff,=0A=
+			       Information_UUIE * info)=0A=
+{=0A=
+	int ret;=0A=
+	int i;=0A=
+=0A=
+	DEBUGP("ip_ct_q931: Information\n");=0A=
+=0A=
+	if (info->options & eInformation_UUIE_fastStart) {=0A=
+		for (i =3D 0; i < info->fastStart.count; i++) {=0A=
+			ret =3D process_olc(pskb, ct, ctinfo, data, dataoff,=0A=
+					  &info->fastStart.item[i]);=0A=
+			if (ret < 0)=0A=
+				return -1;=0A=
+		}=0A=
+	}=0A=
+=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static int process_facility(struct sk_buff **pskb, struct ip_conntrack =
*ct,=0A=
+			    enum ip_conntrack_info ctinfo,=0A=
+			    unsigned char **data, int dataoff,=0A=
+			    Facility_UUIE * facility)=0A=
+{=0A=
+	int ret;=0A=
+	int i;=0A=
+=0A=
+	DEBUGP("ip_ct_q931: Facility\n");=0A=
+=0A=
+	if (facility->options & eFacility_UUIE_h245Address) {=0A=
+		ret =3D expect_h245(pskb, ct, ctinfo, data, dataoff,=0A=
+				  &facility->h245Address);=0A=
+		if (ret < 0)=0A=
+			return -1;=0A=
+	}=0A=
+=0A=
+	if (facility->options & eFacility_UUIE_fastStart) {=0A=
+		for (i =3D 0; i < facility->fastStart.count; i++) {=0A=
+			ret =3D process_olc(pskb, ct, ctinfo, data, dataoff,=0A=
+					  &facility->fastStart.item[i]);=0A=
+			if (ret < 0)=0A=
+				return -1;=0A=
+		}=0A=
+	}=0A=
+=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static int process_progress(struct sk_buff **pskb, struct ip_conntrack =
*ct,=0A=
+			    enum ip_conntrack_info ctinfo,=0A=
+			    unsigned char **data, int dataoff,=0A=
+			    Progress_UUIE * progress)=0A=
+{=0A=
+	int ret;=0A=
+	int i;=0A=
+=0A=
+	DEBUGP("ip_ct_q931: Progress\n");=0A=
+=0A=
+	if (progress->options & eProgress_UUIE_h245Address) {=0A=
+		ret =3D expect_h245(pskb, ct, ctinfo, data, dataoff,=0A=
+				  &progress->h245Address);=0A=
+		if (ret < 0)=0A=
+			return -1;=0A=
+	}=0A=
+=0A=
+	if (progress->options & eProgress_UUIE_fastStart) {=0A=
+		for (i =3D 0; i < progress->fastStart.count; i++) {=0A=
+			ret =3D process_olc(pskb, ct, ctinfo, data, dataoff,=0A=
+					  &progress->fastStart.item[i]);=0A=
+			if (ret < 0)=0A=
+				return -1;=0A=
+		}=0A=
+	}=0A=
+=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static int process_q931(struct sk_buff **pskb, struct ip_conntrack *ct,=0A=
+			enum ip_conntrack_info ctinfo,=0A=
+			unsigned char **data, int dataoff, Q931 * q931)=0A=
+{=0A=
+	H323_UU_PDU *pdu =3D &q931->UUIE.h323_uu_pdu;=0A=
+	int i;=0A=
+	int ret =3D 0;=0A=
+=0A=
+	switch (pdu->h323_message_body.choice) {=0A=
+	case eH323_UU_PDU_h323_message_body_setup:=0A=
+		ret =3D process_setup(pskb, ct, ctinfo, data, dataoff,=0A=
+				    &pdu->h323_message_body.setup);=0A=
+		break;=0A=
+	case eH323_UU_PDU_h323_message_body_callProceeding:=0A=
+		ret =3D process_callproceeding(pskb, ct, ctinfo, data, dataoff,=0A=
+					     &pdu->h323_message_body.=0A=
+					     callProceeding);=0A=
+		break;=0A=
+	case eH323_UU_PDU_h323_message_body_connect:=0A=
+		ret =3D process_connect(pskb, ct, ctinfo, data, dataoff,=0A=
+				      &pdu->h323_message_body.connect);=0A=
+		break;=0A=
+	case eH323_UU_PDU_h323_message_body_alerting:=0A=
+		ret =3D process_alerting(pskb, ct, ctinfo, data, dataoff,=0A=
+				       &pdu->h323_message_body.alerting);=0A=
+		break;=0A=
+	case eH323_UU_PDU_h323_message_body_information:=0A=
+		ret =3D process_information(pskb, ct, ctinfo, data, dataoff,=0A=
+					  &pdu->h323_message_body.=0A=
+					  information);=0A=
+		break;=0A=
+	case eH323_UU_PDU_h323_message_body_facility:=0A=
+		ret =3D process_facility(pskb, ct, ctinfo, data, dataoff,=0A=
+				       &pdu->h323_message_body.facility);=0A=
+		break;=0A=
+	case eH323_UU_PDU_h323_message_body_progress:=0A=
+		ret =3D process_progress(pskb, ct, ctinfo, data, dataoff,=0A=
+				       &pdu->h323_message_body.progress);=0A=
+		break;=0A=
+	default:=0A=
+		DEBUGP("ip_ct_q931: Q.931 signal %d\n",=0A=
+		       pdu->h323_message_body.choice);=0A=
+		break;=0A=
+	}=0A=
+=0A=
+	if (ret < 0)=0A=
+		return -1;=0A=
+=0A=
+	if (pdu->options & eH323_UU_PDU_h245Control) {=0A=
+		for (i =3D 0; i < pdu->h245Control.count; i++) {=0A=
+			ret =3D process_h245(pskb, ct, ctinfo, data, dataoff,=0A=
+					   &pdu->h245Control.item[i]);=0A=
+			if (ret < 0)=0A=
+				return -1;=0A=
+		}=0A=
+	}=0A=
+=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static int q931_help(struct sk_buff **pskb, struct ip_conntrack *ct,=0A=
+		     enum ip_conntrack_info ctinfo)=0A=
+{=0A=
+	static Q931 q931;=0A=
+	unsigned char *data =3D NULL;=0A=
+	int datalen;=0A=
+	int dataoff;=0A=
+	int ret;=0A=
+=0A=
+	/* Until there's been traffic both ways, don't look in packets. */=0A=
+	if (ctinfo !=3D IP_CT_ESTABLISHED=0A=
+	    && ctinfo !=3D IP_CT_ESTABLISHED + IP_CT_IS_REPLY) {=0A=
+		return NF_ACCEPT;=0A=
+	}=0A=
+	DEBUGP("ip_ct_q931: skblen =3D %u\n", (*pskb)->len);=0A=
+=0A=
+	spin_lock_bh(&ip_h323_lock);=0A=
+=0A=
+	/* Process each TPKT */=0A=
+	while (get_tpkt_data(pskb, ct, ctinfo, &data, &datalen, &dataoff)) {=0A=
+		DEBUGP("ip_ct_q931: TPKT %u.%u.%u.%u->%u.%u.%u.%u, len=3D%d\n",=0A=
+		       NIPQUAD((*pskb)->nh.iph->saddr),=0A=
+		       NIPQUAD((*pskb)->nh.iph->daddr), datalen);=0A=
+=0A=
+		/* Decode Q.931 signal */=0A=
+		ret =3D DecodeQ931(data, datalen, &q931);=0A=
+		if (ret < 0) {=0A=
+			if (net_ratelimit())=0A=
+				printk("ip_ct_q931: decoding error: %s\n",=0A=
+				       ret =3D=3D H323_ERROR_BOUND ?=0A=
+				       "out of bound" : "out of range");=0A=
+			/* We don't drop when decoding error */=0A=
+			break;=0A=
+		}=0A=
+=0A=
+		/* Process Q.931 signal */=0A=
+		if (process_q931(pskb, ct, ctinfo, &data, dataoff, &q931) < 0)=0A=
+			goto drop;=0A=
+	}=0A=
+=0A=
+	spin_unlock_bh(&ip_h323_lock);=0A=
+	return NF_ACCEPT;=0A=
+=0A=
+      drop:=0A=
+	spin_unlock_bh(&ip_h323_lock);=0A=
+	if (net_ratelimit())=0A=
+		printk("ip_ct_q931: packet dropped\n");=0A=
+	return NF_DROP;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static struct ip_conntrack_helper ip_conntrack_helper_q931 =3D {=0A=
+	.name =3D "Q.931",=0A=
+	.me =3D THIS_MODULE,=0A=
+	.max_expected =3D H323_RTP_CHANNEL_MAX * 4 + 4 /* T.120 and H.245 */ ,=0A=
+	.timeout =3D 240,=0A=
+	.tuple =3D {.src =3D {.u =3D {__constant_htons(Q931_PORT)}},=0A=
+		  .dst =3D {.protonum =3D IPPROTO_TCP}},=0A=
+	.mask =3D {.src =3D {.u =3D {0xFFFF}},=0A=
+		 .dst =3D {.protonum =3D 0xFF}},=0A=
+	.help =3D q931_help=0A=
+};=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+void ip_conntrack_q931_expect(struct ip_conntrack *new,=0A=
+			      struct ip_conntrack_expect *this)=0A=
+{=0A=
+	write_lock_bh(&ip_conntrack_lock);=0A=
+	new->helper =3D &ip_conntrack_helper_q931;=0A=
+	write_unlock_bh(&ip_conntrack_lock);=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static unsigned char *get_udp_data(struct sk_buff **pskb, int *datalen)=0A=
+{=0A=
+	struct udphdr _uh, *uh;=0A=
+	int dataoff;=0A=
+=0A=
+	uh =3D skb_header_pointer(*pskb, (*pskb)->nh.iph->ihl * 4, sizeof(_uh),=0A=
+				&_uh);=0A=
+	if (uh =3D=3D NULL)=0A=
+		return NULL;=0A=
+	dataoff =3D (*pskb)->nh.iph->ihl * 4 + sizeof(_uh);=0A=
+	if (dataoff >=3D (*pskb)->len)=0A=
+		return NULL;=0A=
+	*datalen =3D (*pskb)->len - dataoff;=0A=
+	return skb_header_pointer(*pskb, dataoff, *datalen, h323_buffer);=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static struct ip_conntrack_expect *find_expect(struct ip_conntrack *ct,=0A=
+					       u_int32_t ip, u_int16_t port)=0A=
+{=0A=
+	struct ip_conntrack_expect *exp;=0A=
+	struct ip_conntrack_tuple tuple;=0A=
+=0A=
+	tuple.src.ip =3D 0;=0A=
+	tuple.src.u.tcp.port =3D 0;=0A=
+	tuple.dst.ip =3D ip;=0A=
+	tuple.dst.u.tcp.port =3D htons(port);=0A=
+	tuple.dst.protonum =3D IPPROTO_TCP;=0A=
+=0A=
+	exp =3D __ip_conntrack_expect_find(&tuple);=0A=
+	if (exp->master =3D=3D ct)=0A=
+		return exp;=0A=
+	return NULL;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static int set_expect_timeout(struct ip_conntrack_expect *exp,=0A=
+			      unsigned timeout)=0A=
+{=0A=
+	if (!exp || !del_timer(&exp->timeout))=0A=
+		return 0;=0A=
+=0A=
+	exp->timeout.expires =3D jiffies + timeout * HZ;=0A=
+	add_timer(&exp->timeout);=0A=
+=0A=
+	return 1;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static int expect_q931(struct sk_buff **pskb, struct ip_conntrack *ct,=0A=
+		       enum ip_conntrack_info ctinfo,=0A=
+		       unsigned char **data,=0A=
+		       TransportAddress * addr, int count)=0A=
+{=0A=
+	struct ip_ct_h323_master *info =3D &ct->help.ct_h323_info;=0A=
+	int dir =3D CTINFO2DIR(ctinfo);=0A=
+	int ret =3D 0;=0A=
+	int i;=0A=
+	u_int32_t ip;=0A=
+	u_int16_t port;=0A=
+	struct ip_conntrack_expect *exp;=0A=
+=0A=
+	/* Look for the first related address */=0A=
+	for (i =3D 0; i < count; i++) {=0A=
+		if (get_h225_addr(*data, &addr[i], &ip, &port) &&=0A=
+		    ip =3D=3D ct->tuplehash[dir].tuple.src.ip && port !=3D 0)=0A=
+			break;=0A=
+	}=0A=
+=0A=
+	if (i >=3D count)		/* Not found */=0A=
+		return 0;=0A=
+=0A=
+	/* Create expect for Q.931 */=0A=
+	if ((exp =3D ip_conntrack_expect_alloc(ct)) =3D=3D NULL)=0A=
+		return -1;=0A=
+	exp->tuple.src.ip =3D gkrouted_only ?	/* only accept calls from GK? */=0A=
+	    ct->tuplehash[!dir].tuple.src.ip : 0;=0A=
+	exp->tuple.src.u.tcp.port =3D 0;=0A=
+	exp->tuple.dst.ip =3D ct->tuplehash[!dir].tuple.dst.ip;=0A=
+	exp->tuple.dst.u.tcp.port =3D htons(port);=0A=
+	exp->tuple.dst.protonum =3D IPPROTO_TCP;=0A=
+	exp->mask.src.ip =3D gkrouted_only ? 0xFFFFFFFF : 0;=0A=
+	exp->mask.src.u.tcp.port =3D 0;=0A=
+	exp->mask.dst.ip =3D 0xFFFFFFFF;=0A=
+	exp->mask.dst.u.tcp.port =3D 0xFFFF;=0A=
+	exp->mask.dst.protonum =3D 0xFF;=0A=
+	exp->flags =3D IP_CT_EXPECT_PERMANENT;	/* Accept multiple calls */=0A=
+=0A=
+	if (nat_q931_hook) {	/* Need NAT */=0A=
+		ret =3D nat_q931_hook(pskb, ct, ctinfo, data, addr, i,=0A=
+				    port, exp);=0A=
+	} else {		/* Conntrack only */=0A=
+		exp->expectfn =3D ip_conntrack_q931_expect;=0A=
+=0A=
+		if (ip_conntrack_expect_related(exp) =3D=3D 0) {=0A=
+			DEBUGP("ip_ct_ras: expect Q.931 "=0A=
+			       "%u.%u.%u.%u:%hu->%u.%u.%u.%u:%hu\n",=0A=
+			       NIPQUAD(exp->tuple.src.ip),=0A=
+			       ntohs(exp->tuple.src.u.tcp.port),=0A=
+			       NIPQUAD(exp->tuple.dst.ip),=0A=
+			       ntohs(exp->tuple.dst.u.tcp.port));=0A=
+=0A=
+			/* Save port for looking up expect in processing RCF */=0A=
+			info->sig_port[dir] =3D port;=0A=
+		} else=0A=
+			ret =3D -1;=0A=
+	}=0A=
+=0A=
+	ip_conntrack_expect_put(exp);=0A=
+=0A=
+	return ret;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static int process_grq(struct sk_buff **pskb, struct ip_conntrack *ct,=0A=
+		       enum ip_conntrack_info ctinfo,=0A=
+		       unsigned char **data, GatekeeperRequest * grq)=0A=
+{=0A=
+	DEBUGP("ip_ct_ras: GRQ\n");=0A=
+=0A=
+	if (set_ras_addr_hook)	/* NATed */=0A=
+		return set_ras_addr_hook(pskb, ct, ctinfo, data,=0A=
+					 &grq->rasAddress, 1);=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/* Declare before using */=0A=
+static void ip_conntrack_ras_expect(struct ip_conntrack *new,=0A=
+				    struct ip_conntrack_expect *this);=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static int process_gcf(struct sk_buff **pskb, struct ip_conntrack *ct,=0A=
+		       enum ip_conntrack_info ctinfo,=0A=
+		       unsigned char **data, GatekeeperConfirm * gcf)=0A=
+{=0A=
+	int dir =3D CTINFO2DIR(ctinfo);=0A=
+	int ret =3D 0;=0A=
+	u_int32_t ip;=0A=
+	u_int16_t port;=0A=
+	struct ip_conntrack_expect *exp;=0A=
+=0A=
+	DEBUGP("ip_ct_ras: GCF\n");=0A=
+=0A=
+	if (!get_h225_addr(*data, &gcf->rasAddress, &ip, &port))=0A=
+		return 0;=0A=
+=0A=
+	/* Registration port is the same as discovery port */=0A=
+	if (ip =3D=3D ct->tuplehash[dir].tuple.src.ip &&=0A=
+	    port =3D=3D ntohs(ct->tuplehash[dir].tuple.src.u.udp.port))=0A=
+		return 0;=0A=
+=0A=
+	/* Avoid RAS expectation loops. A GCF is never expected. */=0A=
+	if (test_bit(IPS_EXPECTED_BIT, &ct->status))=0A=
+		return 0;=0A=
+=0A=
+	/* Need new expect */=0A=
+	if ((exp =3D ip_conntrack_expect_alloc(ct)) =3D=3D NULL)=0A=
+		return -1;=0A=
+	exp->tuple.src.ip =3D ct->tuplehash[!dir].tuple.src.ip;=0A=
+	exp->tuple.src.u.tcp.port =3D 0;=0A=
+	exp->tuple.dst.ip =3D ip;=0A=
+	exp->tuple.dst.u.tcp.port =3D htons(port);=0A=
+	exp->tuple.dst.protonum =3D IPPROTO_UDP;=0A=
+	exp->mask.src.ip =3D 0xFFFFFFFF;=0A=
+	exp->mask.src.u.tcp.port =3D 0;=0A=
+	exp->mask.dst.ip =3D 0xFFFFFFFF;=0A=
+	exp->mask.dst.u.tcp.port =3D 0xFFFF;=0A=
+	exp->mask.dst.protonum =3D 0xFF;=0A=
+	exp->flags =3D 0;=0A=
+	exp->expectfn =3D ip_conntrack_ras_expect;=0A=
+	if (ip_conntrack_expect_related(exp) =3D=3D 0) {=0A=
+		DEBUGP("ip_ct_ras: expect RAS "=0A=
+		       "%u.%u.%u.%u:%hu->%u.%u.%u.%u:%hu\n",=0A=
+		       NIPQUAD(exp->tuple.src.ip),=0A=
+		       ntohs(exp->tuple.src.u.tcp.port),=0A=
+		       NIPQUAD(exp->tuple.dst.ip),=0A=
+		       ntohs(exp->tuple.dst.u.tcp.port));=0A=
+	} else=0A=
+		ret =3D -1;=0A=
+=0A=
+	ip_conntrack_expect_put(exp);=0A=
+=0A=
+	return ret;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static int process_rrq(struct sk_buff **pskb, struct ip_conntrack *ct,=0A=
+		       enum ip_conntrack_info ctinfo,=0A=
+		       unsigned char **data, RegistrationRequest * rrq)=0A=
+{=0A=
+	struct ip_ct_h323_master *info =3D &ct->help.ct_h323_info;=0A=
+	int ret;=0A=
+=0A=
+	DEBUGP("ip_ct_ras: RRQ\n");=0A=
+=0A=
+	ret =3D expect_q931(pskb, ct, ctinfo, data,=0A=
+			  rrq->callSignalAddress.item,=0A=
+			  rrq->callSignalAddress.count);=0A=
+	if (ret < 0)=0A=
+		return -1;=0A=
+=0A=
+	if (set_ras_addr_hook) {=0A=
+		ret =3D set_ras_addr_hook(pskb, ct, ctinfo, data,=0A=
+					rrq->rasAddress.item,=0A=
+					rrq->rasAddress.count);=0A=
+		if (ret < 0)=0A=
+			return -1;=0A=
+	}=0A=
+=0A=
+	if (rrq->options & eRegistrationRequest_timeToLive) {=0A=
+		DEBUGP("ip_ct_ras: RRQ TTL =3D %u seconds\n", rrq->timeToLive);=0A=
+		info->timeout =3D rrq->timeToLive;=0A=
+	} else=0A=
+		info->timeout =3D 0;=0A=
+=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static int process_rcf(struct sk_buff **pskb, struct ip_conntrack *ct,=0A=
+		       enum ip_conntrack_info ctinfo,=0A=
+		       unsigned char **data, RegistrationConfirm * rcf)=0A=
+{=0A=
+	struct ip_ct_h323_master *info =3D &ct->help.ct_h323_info;=0A=
+	int dir =3D CTINFO2DIR(ctinfo);=0A=
+	int ret;=0A=
+	struct ip_conntrack_expect *exp;=0A=
+=0A=
+	DEBUGP("ip_ct_ras: RCF\n");=0A=
+=0A=
+	if (set_sig_addr_hook) {=0A=
+		ret =3D set_sig_addr_hook(pskb, ct, ctinfo, data,=0A=
+					rcf->callSignalAddress.item,=0A=
+					rcf->callSignalAddress.count);=0A=
+		if (ret < 0)=0A=
+			return -1;=0A=
+	}=0A=
+=0A=
+	if (rcf->options & eRegistrationConfirm_timeToLive) {=0A=
+		DEBUGP("ip_ct_ras: RCF TTL =3D %u seconds\n", rcf->timeToLive);=0A=
+		info->timeout =3D rcf->timeToLive;=0A=
+	}=0A=
+=0A=
+	if (info->timeout > 0) {=0A=
+		DEBUGP=0A=
+		    ("ip_ct_ras: set RAS connection timeout to %u seconds\n",=0A=
+		     info->timeout);=0A=
+		ip_ct_refresh_acct(ct, ctinfo, NULL, info->timeout * HZ);=0A=
+=0A=
+		/* Set expect timeout */=0A=
+		read_lock_bh(&ip_conntrack_lock);=0A=
+		exp =3D find_expect(ct, ct->tuplehash[dir].tuple.dst.ip,=0A=
+				  info->sig_port[!dir]);=0A=
+		if (exp) {=0A=
+			DEBUGP("ip_ct_ras: set Q.931 expect "=0A=
+			       "(%u.%u.%u.%u:%hu->%u.%u.%u.%u:%hu) "=0A=
+			       "timeout to %u seconds\n",=0A=
+			       NIPQUAD(exp->tuple.src.ip),=0A=
+			       ntohs(exp->tuple.src.u.tcp.port),=0A=
+			       NIPQUAD(exp->tuple.dst.ip),=0A=
+			       ntohs(exp->tuple.dst.u.tcp.port),=0A=
+			       info->timeout);=0A=
+			set_expect_timeout(exp, info->timeout);=0A=
+		}=0A=
+		read_unlock_bh(&ip_conntrack_lock);=0A=
+	}=0A=
+=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static int process_urq(struct sk_buff **pskb, struct ip_conntrack *ct,=0A=
+		       enum ip_conntrack_info ctinfo,=0A=
+		       unsigned char **data, UnregistrationRequest * urq)=0A=
+{=0A=
+	struct ip_ct_h323_master *info =3D &ct->help.ct_h323_info;=0A=
+	int dir =3D CTINFO2DIR(ctinfo);=0A=
+	int ret;=0A=
+=0A=
+	DEBUGP("ip_ct_ras: URQ\n");=0A=
+=0A=
+	if (set_sig_addr_hook) {=0A=
+		ret =3D set_sig_addr_hook(pskb, ct, ctinfo, data,=0A=
+					urq->callSignalAddress.item,=0A=
+					urq->callSignalAddress.count);=0A=
+		if (ret < 0)=0A=
+			return -1;=0A=
+	}=0A=
+=0A=
+	/* Clear old expect */=0A=
+	ip_ct_remove_expectations(ct);=0A=
+	info->sig_port[dir] =3D 0;=0A=
+	info->sig_port[!dir] =3D 0;=0A=
+=0A=
+	/* Give it 30 seconds for UCF or URJ */=0A=
+	ip_ct_refresh_acct(ct, ctinfo, NULL, 30 * HZ);=0A=
+=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static int process_arq(struct sk_buff **pskb, struct ip_conntrack *ct,=0A=
+		       enum ip_conntrack_info ctinfo,=0A=
+		       unsigned char **data, AdmissionRequest * arq)=0A=
+{=0A=
+	struct ip_ct_h323_master *info =3D &ct->help.ct_h323_info;=0A=
+	int dir =3D CTINFO2DIR(ctinfo);=0A=
+	u_int32_t ip;=0A=
+	u_int16_t port;=0A=
+=0A=
+	DEBUGP("ip_ct_ras: ARQ\n");=0A=
+=0A=
+	if ((arq->options & eAdmissionRequest_destCallSignalAddress) &&=0A=
+	    get_h225_addr(*data, &arq->destCallSignalAddress, &ip, &port) &&=0A=
+	    ip =3D=3D ct->tuplehash[dir].tuple.src.ip &&=0A=
+	    port =3D=3D info->sig_port[dir] && set_h225_addr_hook) {=0A=
+		/* Answering ARQ */=0A=
+		return set_h225_addr_hook(pskb, data, 0,=0A=
+					  &arq->destCallSignalAddress,=0A=
+					  ct->tuplehash[!dir].tuple.dst.ip,=0A=
+					  info->sig_port[!dir]);=0A=
+	}=0A=
+=0A=
+	if ((arq->options & eAdmissionRequest_srcCallSignalAddress) &&=0A=
+	    get_h225_addr(*data, &arq->srcCallSignalAddress, &ip, &port) &&=0A=
+	    ip =3D=3D ct->tuplehash[dir].tuple.src.ip && set_h225_addr_hook) {=0A=
+		/* Calling ARQ */=0A=
+		return set_h225_addr_hook(pskb, data, 0,=0A=
+					  &arq->srcCallSignalAddress,=0A=
+					  ct->tuplehash[!dir].tuple.dst.ip,=0A=
+					  port);=0A=
+	}=0A=
+=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static int process_acf(struct sk_buff **pskb, struct ip_conntrack *ct,=0A=
+		       enum ip_conntrack_info ctinfo,=0A=
+		       unsigned char **data, AdmissionConfirm * acf)=0A=
+{=0A=
+	int dir =3D CTINFO2DIR(ctinfo);=0A=
+	int ret =3D 0;=0A=
+	u_int32_t ip;=0A=
+	u_int16_t port;=0A=
+	struct ip_conntrack_expect *exp;=0A=
+=0A=
+	DEBUGP("ip_ct_ras: ACF\n");=0A=
+=0A=
+	if (!get_h225_addr(*data, &acf->destCallSignalAddress, &ip, &port))=0A=
+		return 0;=0A=
+=0A=
+	if (ip =3D=3D ct->tuplehash[dir].tuple.dst.ip) {	/* Answering ACF */=0A=
+		if (set_sig_addr_hook)=0A=
+			return set_sig_addr_hook(pskb, ct, ctinfo, data,=0A=
+						 &acf->destCallSignalAddress,=0A=
+						 1);=0A=
+		return 0;=0A=
+	}=0A=
+=0A=
+	/* Need new expect */=0A=
+	if ((exp =3D ip_conntrack_expect_alloc(ct)) =3D=3D NULL)=0A=
+		return -1;=0A=
+	exp->tuple.src.ip =3D ct->tuplehash[!dir].tuple.src.ip;=0A=
+	exp->tuple.src.u.tcp.port =3D 0;=0A=
+	exp->tuple.dst.ip =3D ip;=0A=
+	exp->tuple.dst.u.tcp.port =3D htons(port);=0A=
+	exp->tuple.dst.protonum =3D IPPROTO_TCP;=0A=
+	exp->mask.src.ip =3D 0xFFFFFFFF;=0A=
+	exp->mask.src.u.tcp.port =3D 0;=0A=
+	exp->mask.dst.ip =3D 0xFFFFFFFF;=0A=
+	exp->mask.dst.u.tcp.port =3D 0xFFFF;=0A=
+	exp->mask.dst.protonum =3D 0xFF;=0A=
+	exp->flags =3D IP_CT_EXPECT_PERMANENT;=0A=
+	exp->expectfn =3D ip_conntrack_q931_expect;=0A=
+=0A=
+	if (ip_conntrack_expect_related(exp) =3D=3D 0) {=0A=
+		DEBUGP("ip_ct_ras: expect Q.931 "=0A=
+		       "%u.%u.%u.%u:%hu->%u.%u.%u.%u:%hu\n",=0A=
+		       NIPQUAD(exp->tuple.src.ip),=0A=
+		       ntohs(exp->tuple.src.u.tcp.port),=0A=
+		       NIPQUAD(exp->tuple.dst.ip),=0A=
+		       ntohs(exp->tuple.dst.u.tcp.port));=0A=
+	} else=0A=
+		ret =3D -1;=0A=
+=0A=
+	ip_conntrack_expect_put(exp);=0A=
+=0A=
+	return ret;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static int process_lrq(struct sk_buff **pskb, struct ip_conntrack *ct,=0A=
+		       enum ip_conntrack_info ctinfo,=0A=
+		       unsigned char **data, LocationRequest * lrq)=0A=
+{=0A=
+	DEBUGP("ip_ct_ras: LRQ\n");=0A=
+=0A=
+	if (set_ras_addr_hook)=0A=
+		return set_ras_addr_hook(pskb, ct, ctinfo, data,=0A=
+					 &lrq->replyAddress, 1);=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static int process_lcf(struct sk_buff **pskb, struct ip_conntrack *ct,=0A=
+		       enum ip_conntrack_info ctinfo,=0A=
+		       unsigned char **data, LocationConfirm * lcf)=0A=
+{=0A=
+	int dir =3D CTINFO2DIR(ctinfo);=0A=
+	int ret =3D 0;=0A=
+	u_int32_t ip;=0A=
+	u_int16_t port;=0A=
+	struct ip_conntrack_expect *exp =3D NULL;=0A=
+=0A=
+	DEBUGP("ip_ct_ras: LCF\n");=0A=
+=0A=
+	if (!get_h225_addr(*data, &lcf->callSignalAddress, &ip, &port))=0A=
+		return 0;=0A=
+=0A=
+	/* Need new expect for call signal */=0A=
+	if ((exp =3D ip_conntrack_expect_alloc(ct)) =3D=3D NULL)=0A=
+		return -1;=0A=
+	exp->tuple.src.ip =3D ct->tuplehash[!dir].tuple.src.ip;=0A=
+	exp->tuple.src.u.tcp.port =3D 0;=0A=
+	exp->tuple.dst.ip =3D ip;=0A=
+	exp->tuple.dst.u.tcp.port =3D htons(port);=0A=
+	exp->tuple.dst.protonum =3D IPPROTO_TCP;=0A=
+	exp->mask.src.ip =3D 0xFFFFFFFF;=0A=
+	exp->mask.src.u.tcp.port =3D 0;=0A=
+	exp->mask.dst.ip =3D 0xFFFFFFFF;=0A=
+	exp->mask.dst.u.tcp.port =3D 0xFFFF;=0A=
+	exp->mask.dst.protonum =3D 0xFF;=0A=
+	exp->flags =3D IP_CT_EXPECT_PERMANENT;=0A=
+	exp->expectfn =3D ip_conntrack_q931_expect;=0A=
+=0A=
+	if (ip_conntrack_expect_related(exp) =3D=3D 0) {=0A=
+		DEBUGP("ip_ct_ras: expect Q.931 "=0A=
+		       "%u.%u.%u.%u:%hu->%u.%u.%u.%u:%hu\n",=0A=
+		       NIPQUAD(exp->tuple.src.ip),=0A=
+		       ntohs(exp->tuple.src.u.tcp.port),=0A=
+		       NIPQUAD(exp->tuple.dst.ip),=0A=
+		       ntohs(exp->tuple.dst.u.tcp.port));=0A=
+	} else=0A=
+		ret =3D -1;=0A=
+=0A=
+	ip_conntrack_expect_put(exp);=0A=
+=0A=
+	/* Ignore rasAddress */=0A=
+=0A=
+	return ret;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static int process_irr(struct sk_buff **pskb, struct ip_conntrack *ct,=0A=
+		       enum ip_conntrack_info ctinfo,=0A=
+		       unsigned char **data, InfoRequestResponse * irr)=0A=
+{=0A=
+	int ret;=0A=
+=0A=
+	DEBUGP("ip_ct_ras: IRR\n");=0A=
+=0A=
+	if (set_ras_addr_hook) {=0A=
+		ret =3D set_ras_addr_hook(pskb, ct, ctinfo, data,=0A=
+					&irr->rasAddress, 1);=0A=
+		if (ret < 0)=0A=
+			return -1;=0A=
+	}=0A=
+=0A=
+	if (set_sig_addr_hook) {=0A=
+		ret =3D set_sig_addr_hook(pskb, ct, ctinfo, data,=0A=
+					irr->callSignalAddress.item,=0A=
+					irr->callSignalAddress.count);=0A=
+		if (ret < 0)=0A=
+			return -1;=0A=
+	}=0A=
+=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static int process_ras(struct sk_buff **pskb, struct ip_conntrack *ct,=0A=
+		       enum ip_conntrack_info ctinfo,=0A=
+		       unsigned char **data, RasMessage * ras)=0A=
+{=0A=
+	switch (ras->choice) {=0A=
+	case eRasMessage_gatekeeperRequest:=0A=
+		return process_grq(pskb, ct, ctinfo, data,=0A=
+				   &ras->gatekeeperRequest);=0A=
+	case eRasMessage_gatekeeperConfirm:=0A=
+		return process_gcf(pskb, ct, ctinfo, data,=0A=
+				   &ras->gatekeeperConfirm);=0A=
+	case eRasMessage_registrationRequest:=0A=
+		return process_rrq(pskb, ct, ctinfo, data,=0A=
+				   &ras->registrationRequest);=0A=
+	case eRasMessage_registrationConfirm:=0A=
+		return process_rcf(pskb, ct, ctinfo, data,=0A=
+				   &ras->registrationConfirm);=0A=
+	case eRasMessage_unregistrationRequest:=0A=
+		return process_urq(pskb, ct, ctinfo, data,=0A=
+				   &ras->unregistrationRequest);=0A=
+	case eRasMessage_admissionRequest:=0A=
+		return process_arq(pskb, ct, ctinfo, data,=0A=
+				   &ras->admissionRequest);=0A=
+	case eRasMessage_admissionConfirm:=0A=
+		return process_acf(pskb, ct, ctinfo, data,=0A=
+				   &ras->admissionConfirm);=0A=
+	case eRasMessage_locationRequest:=0A=
+		return process_lrq(pskb, ct, ctinfo, data,=0A=
+				   &ras->locationRequest);=0A=
+	case eRasMessage_locationConfirm:=0A=
+		return process_lcf(pskb, ct, ctinfo, data,=0A=
+				   &ras->locationConfirm);=0A=
+	case eRasMessage_infoRequestResponse:=0A=
+		return process_irr(pskb, ct, ctinfo, data,=0A=
+				   &ras->infoRequestResponse);=0A=
+	default:=0A=
+		DEBUGP("ip_ct_ras: RAS message %d\n", ras->choice);=0A=
+		break;=0A=
+	}=0A=
+=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static int ras_help(struct sk_buff **pskb, struct ip_conntrack *ct,=0A=
+		    enum ip_conntrack_info ctinfo)=0A=
+{=0A=
+	static RasMessage ras;=0A=
+	unsigned char *data;=0A=
+	int datalen;=0A=
+	int ret;=0A=
+=0A=
+	DEBUGP("ip_ct_ras: skblen =3D %u\n", (*pskb)->len);=0A=
+=0A=
+	spin_lock_bh(&ip_h323_lock);=0A=
+=0A=
+	/* Get UDP data */=0A=
+	data =3D get_udp_data(pskb, &datalen);=0A=
+	if (data =3D=3D NULL)=0A=
+		goto accept;=0A=
+	DEBUGP("ip_ct_ras: RAS message %u.%u.%u.%u->%u.%u.%u.%u, len=3D%d\n",=0A=
+	       NIPQUAD((*pskb)->nh.iph->saddr),=0A=
+	       NIPQUAD((*pskb)->nh.iph->daddr), datalen);=0A=
+=0A=
+	/* Decode RAS message */=0A=
+	ret =3D DecodeRasMessage(data, datalen, &ras);=0A=
+	if (ret < 0) {=0A=
+		if (net_ratelimit())=0A=
+			printk("ip_ct_ras: decoding error: %s\n",=0A=
+			       ret =3D=3D H323_ERROR_BOUND ?=0A=
+			       "out of bound" : "out of range");=0A=
+		goto accept;=0A=
+	}=0A=
+=0A=
+	/* Process RAS message */=0A=
+	if (process_ras(pskb, ct, ctinfo, &data, &ras) < 0)=0A=
+		goto drop;=0A=
+=0A=
+      accept:=0A=
+	spin_unlock_bh(&ip_h323_lock);=0A=
+	return NF_ACCEPT;=0A=
+=0A=
+      drop:=0A=
+	spin_unlock_bh(&ip_h323_lock);=0A=
+	if (net_ratelimit())=0A=
+		printk("ip_ct_ras: packet dropped\n");=0A=
+	return NF_DROP;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static struct ip_conntrack_helper ip_conntrack_helper_ras =3D {=0A=
+	.name =3D "RAS",=0A=
+	.me =3D THIS_MODULE,=0A=
+	.max_expected =3D 32,=0A=
+	.timeout =3D 240,=0A=
+	.tuple =3D {.src =3D {.u =3D {__constant_htons(RAS_PORT)}},=0A=
+		  .dst =3D {.protonum =3D IPPROTO_UDP}},=0A=
+	.mask =3D {.src =3D {.u =3D {0xFFFE}},=0A=
+		 .dst =3D {.protonum =3D 0xFF}},=0A=
+	.help =3D ras_help,=0A=
+};=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static void ip_conntrack_ras_expect(struct ip_conntrack *new,=0A=
+				    struct ip_conntrack_expect *this)=0A=
+{=0A=
+	write_lock_bh(&ip_conntrack_lock);=0A=
+	new->helper =3D &ip_conntrack_helper_ras;=0A=
+	write_unlock_bh(&ip_conntrack_lock);=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+/* Not __exit - called from init() */=0A=
+static void fini(void)=0A=
+{=0A=
+	ip_conntrack_helper_unregister(&ip_conntrack_helper_ras);=0A=
+	ip_conntrack_helper_unregister(&ip_conntrack_helper_q931);=0A=
+	kfree(h323_buffer);=0A=
+	DEBUGP("ip_ct_h323: fini\n");=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static int __init init(void)=0A=
+{=0A=
+	int ret;=0A=
+=0A=
+	h323_buffer =3D kmalloc(65536, GFP_KERNEL);=0A=
+	if (!h323_buffer)=0A=
+		return -ENOMEM;=0A=
+	if ((ret =3D ip_conntrack_helper_register(&ip_conntrack_helper_q931)) =
||=0A=
+	    (ret =3D ip_conntrack_helper_register(&ip_conntrack_helper_ras))) {=0A=
+		fini();=0A=
+		return ret;=0A=
+	}=0A=
+=0A=
+	DEBUGP("ip_ct_h323: init success\n");=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+module_init(init);=0A=
+module_exit(fini);=0A=
+=0A=
+EXPORT_SYMBOL(get_h245_addr);=0A=
+EXPORT_SYMBOL(get_h225_addr);=0A=
+EXPORT_SYMBOL(ip_conntrack_h245_expect);=0A=
+EXPORT_SYMBOL(ip_conntrack_q931_expect);=0A=
+EXPORT_SYMBOL(set_h245_addr_hook);=0A=
+EXPORT_SYMBOL(set_h225_addr_hook);=0A=
+EXPORT_SYMBOL(set_sig_addr_hook);=0A=
+EXPORT_SYMBOL(set_ras_addr_hook);=0A=
+EXPORT_SYMBOL(nat_rtp_rtcp_hook);=0A=
+EXPORT_SYMBOL(nat_t120_hook);=0A=
+EXPORT_SYMBOL(nat_h245_hook);=0A=
+EXPORT_SYMBOL(nat_q931_hook);=0A=
+=0A=
+MODULE_AUTHOR("Jing Min Zhao <zhaojingmin@users.sourceforge.net>");=0A=
+MODULE_DESCRIPTION("H.323 connection tracking helper");=0A=
+MODULE_LICENSE("GPL");=0A=
diff -pruN =
linux-2.6.15.orig/net/ipv4/netfilter/ip_conntrack_helper_h323_types.c =
linux-2.6.15/net/ipv4/netfilter/ip_conntrack_helper_h323_types.c=0A=
--- =
linux-2.6.15.orig/net/ipv4/netfilter/ip_conntrack_helper_h323_types.c	=
1969-12-31 19:00:00.000000000 -0500=0A=
+++ linux-2.6.15/net/ipv4/netfilter/ip_conntrack_helper_h323_types.c	=
2006-03-15 19:34:05.000000000 -0500=0A=
@@ -0,0 +1,1926 @@=0A=
+/* Generated by Jing Min Zhao's ASN.1 parser, Mar 15 2006=0A=
+ *=0A=
+ * Copyright (c) 2006 Jing Min Zhao <zhaojingmin@users.sourceforge.net>=0A=
+ *=0A=
+ * This source code is licensed under General Public License version 2.=0A=
+ */=0A=
+=0A=
+static field_t _TransportAddress_ipAddress[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("ip") OCTSTR, FIXD, 4, 0, DECODE,=0A=
+	 offsetof(TransportAddress_ipAddress, ip), NULL},=0A=
+	{FNAME("port") INT, WORD, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _TransportAddress_ipSourceRoute_route[] =3D {	/* =
SEQUENCE OF */=0A=
+	{FNAME("item") OCTSTR, FIXD, 4, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _TransportAddress_ipSourceRoute_routing[] =3D {	/* =
CHOICE */=0A=
+	{FNAME("strict") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("loose") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _TransportAddress_ipSourceRoute[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("ip") OCTSTR, FIXD, 4, 0, SKIP, 0, NULL},=0A=
+	{FNAME("port") INT, WORD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("route") SEQOF, SEMI, 0, 0, SKIP, 0,=0A=
+	 _TransportAddress_ipSourceRoute_route},=0A=
+	{FNAME("routing") CHOICE, 1, 2, 2, SKIP | EXT, 0,=0A=
+	 _TransportAddress_ipSourceRoute_routing},=0A=
+};=0A=
+=0A=
+static field_t _TransportAddress_ipxAddress[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("node") OCTSTR, FIXD, 6, 0, SKIP, 0, NULL},=0A=
+	{FNAME("netnum") OCTSTR, FIXD, 4, 0, SKIP, 0, NULL},=0A=
+	{FNAME("port") OCTSTR, FIXD, 2, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _TransportAddress_ip6Address[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("ip") OCTSTR, FIXD, 16, 0, SKIP, 0, NULL},=0A=
+	{FNAME("port") INT, WORD, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _H221NonStandard[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("t35CountryCode") INT, BYTE, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("t35Extension") INT, BYTE, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("manufacturerCode") INT, WORD, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _NonStandardIdentifier[] =3D {	/* CHOICE */=0A=
+	{FNAME("object") OID, BYTE, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("h221NonStandard") SEQ, 0, 3, 3, SKIP | EXT, 0,=0A=
+	 _H221NonStandard},=0A=
+};=0A=
+=0A=
+static field_t _NonStandardParameter[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("nonStandardIdentifier") CHOICE, 1, 2, 2, SKIP | EXT, 0,=0A=
+	 _NonStandardIdentifier},=0A=
+	{FNAME("data") OCTSTR, SEMI, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _TransportAddress[] =3D {	/* CHOICE */=0A=
+	{FNAME("ipAddress") SEQ, 0, 2, 2, DECODE,=0A=
+	 offsetof(TransportAddress, ipAddress), _TransportAddress_ipAddress},=0A=
+	{FNAME("ipSourceRoute") SEQ, 0, 4, 4, SKIP | EXT, 0,=0A=
+	 _TransportAddress_ipSourceRoute},=0A=
+	{FNAME("ipxAddress") SEQ, 0, 3, 3, SKIP, 0,=0A=
+	 _TransportAddress_ipxAddress},=0A=
+	{FNAME("ip6Address") SEQ, 0, 2, 2, SKIP | EXT, 0,=0A=
+	 _TransportAddress_ip6Address},=0A=
+	{FNAME("netBios") OCTSTR, FIXD, 16, 0, SKIP, 0, NULL},=0A=
+	{FNAME("nsap") OCTSTR, 5, 1, 0, SKIP, 0, NULL},=0A=
+	{FNAME("nonStandardAddress") SEQ, 0, 2, 2, SKIP, 0,=0A=
+	 _NonStandardParameter},=0A=
+};=0A=
+=0A=
+static field_t _AliasAddress[] =3D {	/* CHOICE */=0A=
+	{FNAME("dialedDigits") NUMDGT, 7, 1, 0, SKIP, 0, NULL},=0A=
+	{FNAME("h323-ID") BMPSTR, BYTE, 1, 0, SKIP, 0, NULL},=0A=
+	{FNAME("url-ID") IA5STR, WORD, 1, 0, SKIP, 0, NULL},=0A=
+	{FNAME("transportID") CHOICE, 3, 7, 7, SKIP | EXT, 0, NULL},=0A=
+	{FNAME("email-ID") IA5STR, WORD, 1, 0, SKIP, 0, NULL},=0A=
+	{FNAME("partyNumber") CHOICE, 3, 5, 5, SKIP | EXT, 0, NULL},=0A=
+	{FNAME("mobileUIM") CHOICE, 1, 2, 2, SKIP | EXT, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _Setup_UUIE_sourceAddress[] =3D {	/* SEQUENCE OF */=0A=
+	{FNAME("item") CHOICE, 1, 2, 7, SKIP | EXT, 0, _AliasAddress},=0A=
+};=0A=
+=0A=
+static field_t _VendorIdentifier[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("vendor") SEQ, 0, 3, 3, SKIP | EXT, 0, _H221NonStandard},=0A=
+	{FNAME("productId") OCTSTR, BYTE, 1, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("versionId") OCTSTR, BYTE, 1, 0, SKIP | OPT, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _GatekeeperInfo[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("nonStandardData") SEQ, 0, 2, 2, SKIP | OPT, 0,=0A=
+	 _NonStandardParameter},=0A=
+};=0A=
+=0A=
+static field_t _H310Caps[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("nonStandardData") SEQ, 0, 2, 2, SKIP | OPT, 0,=0A=
+	 _NonStandardParameter},=0A=
+	{FNAME("dataRatesSupported") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("supportedPrefixes") SEQOF, SEMI, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _H320Caps[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("nonStandardData") SEQ, 0, 2, 2, SKIP | OPT, 0,=0A=
+	 _NonStandardParameter},=0A=
+	{FNAME("dataRatesSupported") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("supportedPrefixes") SEQOF, SEMI, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _H321Caps[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("nonStandardData") SEQ, 0, 2, 2, SKIP | OPT, 0,=0A=
+	 _NonStandardParameter},=0A=
+	{FNAME("dataRatesSupported") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("supportedPrefixes") SEQOF, SEMI, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _H322Caps[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("nonStandardData") SEQ, 0, 2, 2, SKIP | OPT, 0,=0A=
+	 _NonStandardParameter},=0A=
+	{FNAME("dataRatesSupported") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("supportedPrefixes") SEQOF, SEMI, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _H323Caps[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("nonStandardData") SEQ, 0, 2, 2, SKIP | OPT, 0,=0A=
+	 _NonStandardParameter},=0A=
+	{FNAME("dataRatesSupported") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("supportedPrefixes") SEQOF, SEMI, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _H324Caps[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("nonStandardData") SEQ, 0, 2, 2, SKIP | OPT, 0,=0A=
+	 _NonStandardParameter},=0A=
+	{FNAME("dataRatesSupported") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("supportedPrefixes") SEQOF, SEMI, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _VoiceCaps[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("nonStandardData") SEQ, 0, 2, 2, SKIP | OPT, 0,=0A=
+	 _NonStandardParameter},=0A=
+	{FNAME("dataRatesSupported") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("supportedPrefixes") SEQOF, SEMI, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _T120OnlyCaps[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("nonStandardData") SEQ, 0, 2, 2, SKIP | OPT, 0,=0A=
+	 _NonStandardParameter},=0A=
+	{FNAME("dataRatesSupported") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("supportedPrefixes") SEQOF, SEMI, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _SupportedProtocols[] =3D {	/* CHOICE */=0A=
+	{FNAME("nonStandardData") SEQ, 0, 2, 2, SKIP, 0,=0A=
+	 _NonStandardParameter},=0A=
+	{FNAME("h310") SEQ, 1, 1, 3, SKIP | EXT, 0, _H310Caps},=0A=
+	{FNAME("h320") SEQ, 1, 1, 3, SKIP | EXT, 0, _H320Caps},=0A=
+	{FNAME("h321") SEQ, 1, 1, 3, SKIP | EXT, 0, _H321Caps},=0A=
+	{FNAME("h322") SEQ, 1, 1, 3, SKIP | EXT, 0, _H322Caps},=0A=
+	{FNAME("h323") SEQ, 1, 1, 3, SKIP | EXT, 0, _H323Caps},=0A=
+	{FNAME("h324") SEQ, 1, 1, 3, SKIP | EXT, 0, _H324Caps},=0A=
+	{FNAME("voice") SEQ, 1, 1, 3, SKIP | EXT, 0, _VoiceCaps},=0A=
+	{FNAME("t120-only") SEQ, 1, 1, 3, SKIP | EXT, 0, _T120OnlyCaps},=0A=
+	{FNAME("nonStandardProtocol") SEQ, 2, 3, 3, SKIP | EXT, 0, NULL},=0A=
+	{FNAME("t38FaxAnnexbOnly") SEQ, 2, 5, 5, SKIP | EXT, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _GatewayInfo_protocol[] =3D {	/* SEQUENCE OF */=0A=
+	{FNAME("item") CHOICE, 4, 9, 11, SKIP | EXT, 0, _SupportedProtocols},=0A=
+};=0A=
+=0A=
+static field_t _GatewayInfo[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("protocol") SEQOF, SEMI, 0, 0, SKIP | OPT, 0,=0A=
+	 _GatewayInfo_protocol},=0A=
+	{FNAME("nonStandardData") SEQ, 0, 2, 2, SKIP | OPT, 0,=0A=
+	 _NonStandardParameter},=0A=
+};=0A=
+=0A=
+static field_t _McuInfo[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("nonStandardData") SEQ, 0, 2, 2, SKIP | OPT, 0,=0A=
+	 _NonStandardParameter},=0A=
+	{FNAME("protocol") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _TerminalInfo[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("nonStandardData") SEQ, 0, 2, 2, SKIP | OPT, 0,=0A=
+	 _NonStandardParameter},=0A=
+};=0A=
+=0A=
+static field_t _EndpointType[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("nonStandardData") SEQ, 0, 2, 2, SKIP | OPT, 0,=0A=
+	 _NonStandardParameter},=0A=
+	{FNAME("vendor") SEQ, 2, 3, 3, SKIP | EXT | OPT, 0,=0A=
+	 _VendorIdentifier},=0A=
+	{FNAME("gatekeeper") SEQ, 1, 1, 1, SKIP | EXT | OPT, 0,=0A=
+	 _GatekeeperInfo},=0A=
+	{FNAME("gateway") SEQ, 2, 2, 2, SKIP | EXT | OPT, 0, _GatewayInfo},=0A=
+	{FNAME("mcu") SEQ, 1, 1, 2, SKIP | EXT | OPT, 0, _McuInfo},=0A=
+	{FNAME("terminal") SEQ, 1, 1, 1, SKIP | EXT | OPT, 0, _TerminalInfo},=0A=
+	{FNAME("mc") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("undefinedNode") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("set") BITSTR, FIXD, 32, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("supportedTunnelledProtocols") SEQOF, SEMI, 0, 0, SKIP | OPT,=0A=
+	 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _Setup_UUIE_destinationAddress[] =3D {	/* SEQUENCE OF */=0A=
+	{FNAME("item") CHOICE, 1, 2, 7, SKIP | EXT, 0, _AliasAddress},=0A=
+};=0A=
+=0A=
+static field_t _Setup_UUIE_destExtraCallInfo[] =3D {	/* SEQUENCE OF */=0A=
+	{FNAME("item") CHOICE, 1, 2, 7, SKIP | EXT, 0, _AliasAddress},=0A=
+};=0A=
+=0A=
+static field_t _Setup_UUIE_destExtraCRV[] =3D {	/* SEQUENCE OF */=0A=
+	{FNAME("item") INT, WORD, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _Setup_UUIE_conferenceGoal[] =3D {	/* CHOICE */=0A=
+	{FNAME("create") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("join") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("invite") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("capability-negotiation") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("callIndependentSupplementaryService") NUL, FIXD, 0, 0, SKIP,=0A=
+	 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _Q954Details[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("conferenceCalling") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("threePartyService") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _QseriesOptions[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("q932Full") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("q951Full") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("q952Full") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("q953Full") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("q955Full") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("q956Full") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("q957Full") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("q954Info") SEQ, 0, 2, 2, SKIP | EXT, 0, _Q954Details},=0A=
+};=0A=
+=0A=
+static field_t _CallType[] =3D {	/* CHOICE */=0A=
+	{FNAME("pointToPoint") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("oneToN") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("nToOne") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("nToN") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _H245_NonStandardIdentifier_h221NonStandard[] =3D {	/* =
SEQUENCE */=0A=
+	{FNAME("t35CountryCode") INT, BYTE, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("t35Extension") INT, BYTE, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("manufacturerCode") INT, WORD, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _H245_NonStandardIdentifier[] =3D {	/* CHOICE */=0A=
+	{FNAME("object") OID, BYTE, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("h221NonStandard") SEQ, 0, 3, 3, SKIP, 0,=0A=
+	 _H245_NonStandardIdentifier_h221NonStandard},=0A=
+};=0A=
+=0A=
+static field_t _H245_NonStandardParameter[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("nonStandardIdentifier") CHOICE, 1, 2, 2, SKIP, 0,=0A=
+	 _H245_NonStandardIdentifier},=0A=
+	{FNAME("data") OCTSTR, SEMI, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _H261VideoCapability[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("qcifMPI") INT, 2, 1, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("cifMPI") INT, 2, 1, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("temporalSpatialTradeOffCapability") BOOL, FIXD, 0, 0, SKIP, 0,=0A=
+	 NULL},=0A=
+	{FNAME("maxBitRate") INT, WORD, 1, 0, SKIP, 0, NULL},=0A=
+	{FNAME("stillImageTransmission") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("videoBadMBsCap") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _H262VideoCapability[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("profileAndLevel-SPatML") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("profileAndLevel-MPatLL") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("profileAndLevel-MPatML") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("profileAndLevel-MPatH-14") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("profileAndLevel-MPatHL") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("profileAndLevel-SNRatLL") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("profileAndLevel-SNRatML") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("profileAndLevel-SpatialatH-14") BOOL, FIXD, 0, 0, SKIP, 0,=0A=
+	 NULL},=0A=
+	{FNAME("profileAndLevel-HPatML") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("profileAndLevel-HPatH-14") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("profileAndLevel-HPatHL") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("videoBitRate") INT, CONS, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("vbvBufferSize") INT, CONS, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("samplesPerLine") INT, WORD, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("linesPerFrame") INT, WORD, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("framesPerSecond") INT, 4, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("luminanceSampleRate") INT, CONS, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("videoBadMBsCap") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _H263VideoCapability[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("sqcifMPI") INT, 5, 1, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("qcifMPI") INT, 5, 1, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("cifMPI") INT, 5, 1, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("cif4MPI") INT, 5, 1, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("cif16MPI") INT, 5, 1, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("maxBitRate") INT, CONS, 1, 0, SKIP, 0, NULL},=0A=
+	{FNAME("unrestrictedVector") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("arithmeticCoding") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("advancedPrediction") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("pbFrames") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("temporalSpatialTradeOffCapability") BOOL, FIXD, 0, 0, SKIP, 0,=0A=
+	 NULL},=0A=
+	{FNAME("hrd-B") INT, CONS, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("bppMaxKb") INT, WORD, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("slowSqcifMPI") INT, WORD, 1, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("slowQcifMPI") INT, WORD, 1, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("slowCifMPI") INT, WORD, 1, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("slowCif4MPI") INT, WORD, 1, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("slowCif16MPI") INT, WORD, 1, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("errorCompensation") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("enhancementLayerInfo") SEQ, 3, 4, 4, SKIP | EXT | OPT, 0,=0A=
+	 NULL},=0A=
+	{FNAME("h263Options") SEQ, 5, 29, 31, SKIP | EXT | OPT, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _IS11172VideoCapability[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("constrainedBitstream") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("videoBitRate") INT, CONS, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("vbvBufferSize") INT, CONS, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("samplesPerLine") INT, WORD, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("linesPerFrame") INT, WORD, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("pictureRate") INT, 4, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("luminanceSampleRate") INT, CONS, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("videoBadMBsCap") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _VideoCapability[] =3D {	/* CHOICE */=0A=
+	{FNAME("nonStandard") SEQ, 0, 2, 2, SKIP, 0,=0A=
+	 _H245_NonStandardParameter},=0A=
+	{FNAME("h261VideoCapability") SEQ, 2, 5, 6, SKIP | EXT, 0,=0A=
+	 _H261VideoCapability},=0A=
+	{FNAME("h262VideoCapability") SEQ, 6, 17, 18, SKIP | EXT, 0,=0A=
+	 _H262VideoCapability},=0A=
+	{FNAME("h263VideoCapability") SEQ, 7, 13, 21, SKIP | EXT, 0,=0A=
+	 _H263VideoCapability},=0A=
+	{FNAME("is11172VideoCapability") SEQ, 6, 7, 8, SKIP | EXT, 0,=0A=
+	 _IS11172VideoCapability},=0A=
+	{FNAME("genericVideoCapability") SEQ, 5, 6, 6, SKIP | EXT, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _AudioCapability_g7231[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("maxAl-sduAudioFrames") INT, BYTE, 1, 0, SKIP, 0, NULL},=0A=
+	{FNAME("silenceSuppression") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _IS11172AudioCapability[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("audioLayer1") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("audioLayer2") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("audioLayer3") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("audioSampling32k") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("audioSampling44k1") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("audioSampling48k") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("singleChannel") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("twoChannels") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("bitRate") INT, WORD, 1, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _IS13818AudioCapability[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("audioLayer1") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("audioLayer2") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("audioLayer3") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("audioSampling16k") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("audioSampling22k05") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("audioSampling24k") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("audioSampling32k") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("audioSampling44k1") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("audioSampling48k") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("singleChannel") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("twoChannels") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("threeChannels2-1") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("threeChannels3-0") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("fourChannels2-0-2-0") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("fourChannels2-2") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("fourChannels3-1") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("fiveChannels3-0-2-0") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("fiveChannels3-2") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("lowFrequencyEnhancement") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("multilingual") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("bitRate") INT, WORD, 1, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _AudioCapability[] =3D {	/* CHOICE */=0A=
+	{FNAME("nonStandard") SEQ, 0, 2, 2, SKIP, 0,=0A=
+	 _H245_NonStandardParameter},=0A=
+	{FNAME("g711Alaw64k") INT, BYTE, 1, 0, SKIP, 0, NULL},=0A=
+	{FNAME("g711Alaw56k") INT, BYTE, 1, 0, SKIP, 0, NULL},=0A=
+	{FNAME("g711Ulaw64k") INT, BYTE, 1, 0, SKIP, 0, NULL},=0A=
+	{FNAME("g711Ulaw56k") INT, BYTE, 1, 0, SKIP, 0, NULL},=0A=
+	{FNAME("g722-64k") INT, BYTE, 1, 0, SKIP, 0, NULL},=0A=
+	{FNAME("g722-56k") INT, BYTE, 1, 0, SKIP, 0, NULL},=0A=
+	{FNAME("g722-48k") INT, BYTE, 1, 0, SKIP, 0, NULL},=0A=
+	{FNAME("g7231") SEQ, 0, 2, 2, SKIP, 0, _AudioCapability_g7231},=0A=
+	{FNAME("g728") INT, BYTE, 1, 0, SKIP, 0, NULL},=0A=
+	{FNAME("g729") INT, BYTE, 1, 0, SKIP, 0, NULL},=0A=
+	{FNAME("g729AnnexA") INT, BYTE, 1, 0, SKIP, 0, NULL},=0A=
+	{FNAME("is11172AudioCapability") SEQ, 0, 9, 9, SKIP | EXT, 0,=0A=
+	 _IS11172AudioCapability},=0A=
+	{FNAME("is13818AudioCapability") SEQ, 0, 21, 21, SKIP | EXT, 0,=0A=
+	 _IS13818AudioCapability},=0A=
+	{FNAME("g729wAnnexB") INT, BYTE, 1, 0, SKIP, 0, NULL},=0A=
+	{FNAME("g729AnnexAwAnnexB") INT, BYTE, 1, 0, SKIP, 0, NULL},=0A=
+	{FNAME("g7231AnnexCCapability") SEQ, 1, 3, 3, SKIP | EXT, 0, NULL},=0A=
+	{FNAME("gsmFullRate") SEQ, 0, 3, 3, SKIP | EXT, 0, NULL},=0A=
+	{FNAME("gsmHalfRate") SEQ, 0, 3, 3, SKIP | EXT, 0, NULL},=0A=
+	{FNAME("gsmEnhancedFullRate") SEQ, 0, 3, 3, SKIP | EXT, 0, NULL},=0A=
+	{FNAME("genericAudioCapability") SEQ, 5, 6, 6, SKIP | EXT, 0, NULL},=0A=
+	{FNAME("g729Extensions") SEQ, 1, 8, 8, SKIP | EXT, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _DataProtocolCapability[] =3D {	/* CHOICE */=0A=
+	{FNAME("nonStandard") SEQ, 0, 2, 2, SKIP, 0,=0A=
+	 _H245_NonStandardParameter},=0A=
+	{FNAME("v14buffered") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("v42lapm") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("hdlcFrameTunnelling") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("h310SeparateVCStack") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("h310SingleVCStack") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("transparent") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("segmentationAndReassembly") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("hdlcFrameTunnelingwSAR") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("v120") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("separateLANStack") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("v76wCompression") CHOICE, 2, 3, 3, SKIP | EXT, 0, NULL},=0A=
+	{FNAME("tcp") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("udp") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _T84Profile_t84Restricted[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("qcif") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("cif") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("ccir601Seq") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("ccir601Prog") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("hdtvSeq") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("hdtvProg") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("g3FacsMH200x100") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("g3FacsMH200x200") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("g4FacsMMR200x100") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("g4FacsMMR200x200") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("jbig200x200Seq") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("jbig200x200Prog") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("jbig300x300Seq") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("jbig300x300Prog") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("digPhotoLow") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("digPhotoMedSeq") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("digPhotoMedProg") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("digPhotoHighSeq") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("digPhotoHighProg") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _T84Profile[] =3D {	/* CHOICE */=0A=
+	{FNAME("t84Unrestricted") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("t84Restricted") SEQ, 0, 19, 19, SKIP | EXT, 0,=0A=
+	 _T84Profile_t84Restricted},=0A=
+};=0A=
+=0A=
+static field_t _DataApplicationCapability_application_t84[] =3D {	/* =
SEQUENCE */=0A=
+	{FNAME("t84Protocol") CHOICE, 3, 7, 14, SKIP | EXT, 0,=0A=
+	 _DataProtocolCapability},=0A=
+	{FNAME("t84Profile") CHOICE, 1, 2, 2, SKIP, 0, _T84Profile},=0A=
+};=0A=
+=0A=
+static field_t _DataApplicationCapability_application_nlpid[] =3D {	/* =
SEQUENCE */=0A=
+	{FNAME("nlpidProtocol") CHOICE, 3, 7, 14, SKIP | EXT, 0,=0A=
+	 _DataProtocolCapability},=0A=
+	{FNAME("nlpidData") OCTSTR, SEMI, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _DataApplicationCapability_application[] =3D {	/* CHOICE =
*/=0A=
+	{FNAME("nonStandard") SEQ, 0, 2, 2, SKIP, 0,=0A=
+	 _H245_NonStandardParameter},=0A=
+	{FNAME("t120") CHOICE, 3, 7, 14, DECODE | EXT,=0A=
+	 offsetof(DataApplicationCapability_application, t120),=0A=
+	 _DataProtocolCapability},=0A=
+	{FNAME("dsm-cc") CHOICE, 3, 7, 14, SKIP | EXT, 0,=0A=
+	 _DataProtocolCapability},=0A=
+	{FNAME("userData") CHOICE, 3, 7, 14, SKIP | EXT, 0,=0A=
+	 _DataProtocolCapability},=0A=
+	{FNAME("t84") SEQ, 0, 2, 2, SKIP, 0,=0A=
+	 _DataApplicationCapability_application_t84},=0A=
+	{FNAME("t434") CHOICE, 3, 7, 14, SKIP | EXT, 0,=0A=
+	 _DataProtocolCapability},=0A=
+	{FNAME("h224") CHOICE, 3, 7, 14, SKIP | EXT, 0,=0A=
+	 _DataProtocolCapability},=0A=
+	{FNAME("nlpid") SEQ, 0, 2, 2, SKIP, 0,=0A=
+	 _DataApplicationCapability_application_nlpid},=0A=
+	{FNAME("dsvdControl") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("h222DataPartitioning") CHOICE, 3, 7, 14, SKIP | EXT, 0,=0A=
+	 _DataProtocolCapability},=0A=
+	{FNAME("t30fax") CHOICE, 3, 7, 14, SKIP | EXT, 0, NULL},=0A=
+	{FNAME("t140") CHOICE, 3, 7, 14, SKIP | EXT, 0, NULL},=0A=
+	{FNAME("t38fax") SEQ, 0, 2, 2, SKIP, 0, NULL},=0A=
+	{FNAME("genericDataCapability") SEQ, 5, 6, 6, SKIP | EXT, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _DataApplicationCapability[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("application") CHOICE, 4, 10, 14, DECODE | EXT,=0A=
+	 offsetof(DataApplicationCapability, application),=0A=
+	 _DataApplicationCapability_application},=0A=
+	{FNAME("maxBitRate") INT, CONS, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _EncryptionMode[] =3D {	/* CHOICE */=0A=
+	{FNAME("nonStandard") SEQ, 0, 2, 2, SKIP, 0,=0A=
+	 _H245_NonStandardParameter},=0A=
+	{FNAME("h233Encryption") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _DataType[] =3D {	/* CHOICE */=0A=
+	{FNAME("nonStandard") SEQ, 0, 2, 2, SKIP, 0,=0A=
+	 _H245_NonStandardParameter},=0A=
+	{FNAME("nullData") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("videoData") CHOICE, 3, 5, 6, SKIP | EXT, 0, _VideoCapability},=0A=
+	{FNAME("audioData") CHOICE, 4, 14, 22, SKIP | EXT, 0,=0A=
+	 _AudioCapability},=0A=
+	{FNAME("data") SEQ, 0, 2, 2, DECODE | EXT, offsetof(DataType, data),=0A=
+	 _DataApplicationCapability},=0A=
+	{FNAME("encryptionData") CHOICE, 1, 2, 2, SKIP | EXT, 0,=0A=
+	 _EncryptionMode},=0A=
+	{FNAME("h235Control") SEQ, 0, 2, 2, SKIP, 0, NULL},=0A=
+	{FNAME("h235Media") SEQ, 0, 2, 2, SKIP | EXT, 0, NULL},=0A=
+	{FNAME("multiplexedStream") SEQ, 0, 2, 2, SKIP | EXT, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _H222LogicalChannelParameters[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("resourceID") INT, WORD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("subChannelID") INT, WORD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("pcr-pid") INT, WORD, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("programDescriptors") OCTSTR, SEMI, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("streamDescriptors") OCTSTR, SEMI, 0, 0, SKIP | OPT, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _H223LogicalChannelParameters_adaptationLayerType_al3[] =
=3D {	/* SEQUENCE */=0A=
+	{FNAME("controlFieldOctets") INT, 2, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("sendBufferSize") INT, CONS, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _H223LogicalChannelParameters_adaptationLayerType[] =3D =
{	/* CHOICE */=0A=
+	{FNAME("nonStandard") SEQ, 0, 2, 2, SKIP, 0,=0A=
+	 _H245_NonStandardParameter},=0A=
+	{FNAME("al1Framed") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("al1NotFramed") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("al2WithoutSequenceNumbers") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("al2WithSequenceNumbers") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("al3") SEQ, 0, 2, 2, SKIP, 0,=0A=
+	 _H223LogicalChannelParameters_adaptationLayerType_al3},=0A=
+	{FNAME("al1M") SEQ, 0, 7, 8, SKIP | EXT, 0, NULL},=0A=
+	{FNAME("al2M") SEQ, 0, 2, 2, SKIP | EXT, 0, NULL},=0A=
+	{FNAME("al3M") SEQ, 0, 5, 6, SKIP | EXT, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _H223LogicalChannelParameters[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("adaptationLayerType") CHOICE, 3, 6, 9, SKIP | EXT, 0,=0A=
+	 _H223LogicalChannelParameters_adaptationLayerType},=0A=
+	{FNAME("segmentableFlag") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _CRCLength[] =3D {	/* CHOICE */=0A=
+	{FNAME("crc8bit") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("crc16bit") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("crc32bit") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _V76HDLCParameters[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("crcLength") CHOICE, 2, 3, 3, SKIP | EXT, 0, _CRCLength},=0A=
+	{FNAME("n401") INT, WORD, 1, 0, SKIP, 0, NULL},=0A=
+	{FNAME("loopbackTestProcedure") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _V76LogicalChannelParameters_suspendResume[] =3D {	/* =
CHOICE */=0A=
+	{FNAME("noSuspendResume") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("suspendResumewAddress") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("suspendResumewoAddress") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _V76LogicalChannelParameters_mode_eRM_recovery[] =3D {	=
/* CHOICE */=0A=
+	{FNAME("rej") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("sREJ") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("mSREJ") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _V76LogicalChannelParameters_mode_eRM[] =3D {	/* =
SEQUENCE */=0A=
+	{FNAME("windowSize") INT, 7, 1, 0, SKIP, 0, NULL},=0A=
+	{FNAME("recovery") CHOICE, 2, 3, 3, SKIP | EXT, 0,=0A=
+	 _V76LogicalChannelParameters_mode_eRM_recovery},=0A=
+};=0A=
+=0A=
+static field_t _V76LogicalChannelParameters_mode[] =3D {	/* CHOICE */=0A=
+	{FNAME("eRM") SEQ, 0, 2, 2, SKIP | EXT, 0,=0A=
+	 _V76LogicalChannelParameters_mode_eRM},=0A=
+	{FNAME("uNERM") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _V75Parameters[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("audioHeaderPresent") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _V76LogicalChannelParameters[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("hdlcParameters") SEQ, 0, 3, 3, SKIP | EXT, 0,=0A=
+	 _V76HDLCParameters},=0A=
+	{FNAME("suspendResume") CHOICE, 2, 3, 3, SKIP | EXT, 0,=0A=
+	 _V76LogicalChannelParameters_suspendResume},=0A=
+	{FNAME("uIH") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("mode") CHOICE, 1, 2, 2, SKIP | EXT, 0,=0A=
+	 _V76LogicalChannelParameters_mode},=0A=
+	{FNAME("v75Parameters") SEQ, 0, 1, 1, SKIP | EXT, 0, _V75Parameters},=0A=
+};=0A=
+=0A=
+static field_t _H2250LogicalChannelParameters_nonStandard[] =3D {	/* =
SEQUENCE OF */=0A=
+	{FNAME("item") SEQ, 0, 2, 2, SKIP, 0, _H245_NonStandardParameter},=0A=
+};=0A=
+=0A=
+static field_t _UnicastAddress_iPAddress[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("network") OCTSTR, FIXD, 4, 0, DECODE,=0A=
+	 offsetof(UnicastAddress_iPAddress, network), NULL},=0A=
+	{FNAME("tsapIdentifier") INT, WORD, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _UnicastAddress_iPXAddress[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("node") OCTSTR, FIXD, 6, 0, SKIP, 0, NULL},=0A=
+	{FNAME("netnum") OCTSTR, FIXD, 4, 0, SKIP, 0, NULL},=0A=
+	{FNAME("tsapIdentifier") OCTSTR, FIXD, 2, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _UnicastAddress_iP6Address[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("network") OCTSTR, FIXD, 16, 0, SKIP, 0, NULL},=0A=
+	{FNAME("tsapIdentifier") INT, WORD, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _UnicastAddress_iPSourceRouteAddress_routing[] =3D {	/* =
CHOICE */=0A=
+	{FNAME("strict") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("loose") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _UnicastAddress_iPSourceRouteAddress_route[] =3D {	/* =
SEQUENCE OF */=0A=
+	{FNAME("item") OCTSTR, FIXD, 4, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _UnicastAddress_iPSourceRouteAddress[] =3D {	/* SEQUENCE =
*/=0A=
+	{FNAME("routing") CHOICE, 1, 2, 2, SKIP, 0,=0A=
+	 _UnicastAddress_iPSourceRouteAddress_routing},=0A=
+	{FNAME("network") OCTSTR, FIXD, 4, 0, SKIP, 0, NULL},=0A=
+	{FNAME("tsapIdentifier") INT, WORD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("route") SEQOF, SEMI, 0, 0, SKIP, 0,=0A=
+	 _UnicastAddress_iPSourceRouteAddress_route},=0A=
+};=0A=
+=0A=
+static field_t _UnicastAddress[] =3D {	/* CHOICE */=0A=
+	{FNAME("iPAddress") SEQ, 0, 2, 2, DECODE | EXT,=0A=
+	 offsetof(UnicastAddress, iPAddress), _UnicastAddress_iPAddress},=0A=
+	{FNAME("iPXAddress") SEQ, 0, 3, 3, SKIP | EXT, 0,=0A=
+	 _UnicastAddress_iPXAddress},=0A=
+	{FNAME("iP6Address") SEQ, 0, 2, 2, SKIP | EXT, 0,=0A=
+	 _UnicastAddress_iP6Address},=0A=
+	{FNAME("netBios") OCTSTR, FIXD, 16, 0, SKIP, 0, NULL},=0A=
+	{FNAME("iPSourceRouteAddress") SEQ, 0, 4, 4, SKIP | EXT, 0,=0A=
+	 _UnicastAddress_iPSourceRouteAddress},=0A=
+	{FNAME("nsap") OCTSTR, 5, 1, 0, SKIP, 0, NULL},=0A=
+	{FNAME("nonStandardAddress") SEQ, 0, 2, 2, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _MulticastAddress_iPAddress[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("network") OCTSTR, FIXD, 4, 0, SKIP, 0, NULL},=0A=
+	{FNAME("tsapIdentifier") INT, WORD, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _MulticastAddress_iP6Address[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("network") OCTSTR, FIXD, 16, 0, SKIP, 0, NULL},=0A=
+	{FNAME("tsapIdentifier") INT, WORD, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _MulticastAddress[] =3D {	/* CHOICE */=0A=
+	{FNAME("iPAddress") SEQ, 0, 2, 2, SKIP | EXT, 0,=0A=
+	 _MulticastAddress_iPAddress},=0A=
+	{FNAME("iP6Address") SEQ, 0, 2, 2, SKIP | EXT, 0,=0A=
+	 _MulticastAddress_iP6Address},=0A=
+	{FNAME("nsap") OCTSTR, 5, 1, 0, SKIP, 0, NULL},=0A=
+	{FNAME("nonStandardAddress") SEQ, 0, 2, 2, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _H245_TransportAddress[] =3D {	/* CHOICE */=0A=
+	{FNAME("unicastAddress") CHOICE, 3, 5, 7, DECODE | EXT,=0A=
+	 offsetof(H245_TransportAddress, unicastAddress), _UnicastAddress},=0A=
+	{FNAME("multicastAddress") CHOICE, 1, 2, 4, SKIP | EXT, 0,=0A=
+	 _MulticastAddress},=0A=
+};=0A=
+=0A=
+static field_t _H2250LogicalChannelParameters[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("nonStandard") SEQOF, SEMI, 0, 0, SKIP | OPT, 0,=0A=
+	 _H2250LogicalChannelParameters_nonStandard},=0A=
+	{FNAME("sessionID") INT, BYTE, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("associatedSessionID") INT, 8, 1, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("mediaChannel") CHOICE, 1, 2, 2, DECODE | EXT | OPT,=0A=
+	 offsetof(H2250LogicalChannelParameters, mediaChannel),=0A=
+	 _H245_TransportAddress},=0A=
+	{FNAME("mediaGuaranteedDelivery") BOOL, FIXD, 0, 0, SKIP | OPT, 0,=0A=
+	 NULL},=0A=
+	{FNAME("mediaControlChannel") CHOICE, 1, 2, 2, DECODE | EXT | OPT,=0A=
+	 offsetof(H2250LogicalChannelParameters, mediaControlChannel),=0A=
+	 _H245_TransportAddress},=0A=
+	{FNAME("mediaControlGuaranteedDelivery") BOOL, FIXD, 0, 0, STOP | OPT,=0A=
+	 0, NULL},=0A=
+	{FNAME("silenceSuppression") BOOL, FIXD, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("destination") SEQ, 0, 2, 2, STOP | EXT | OPT, 0, NULL},=0A=
+	{FNAME("dynamicRTPPayloadType") INT, 5, 96, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("mediaPacketization") CHOICE, 0, 1, 2, STOP | EXT | OPT, 0,=0A=
+	 NULL},=0A=
+	{FNAME("transportCapability") SEQ, 3, 3, 3, STOP | EXT | OPT, 0,=0A=
+	 NULL},=0A=
+	{FNAME("redundancyEncoding") SEQ, 1, 2, 2, STOP | EXT | OPT, 0, NULL},=0A=
+	{FNAME("source") SEQ, 0, 2, 2, SKIP | EXT | OPT, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t =
_OpenLogicalChannel_forwardLogicalChannelParameters_multiplexParameters[]=
 =3D {	/* CHOICE */=0A=
+	{FNAME("h222LogicalChannelParameters") SEQ, 3, 5, 5, SKIP | EXT, 0,=0A=
+	 _H222LogicalChannelParameters},=0A=
+	{FNAME("h223LogicalChannelParameters") SEQ, 0, 2, 2, SKIP | EXT, 0,=0A=
+	 _H223LogicalChannelParameters},=0A=
+	{FNAME("v76LogicalChannelParameters") SEQ, 0, 5, 5, SKIP | EXT, 0,=0A=
+	 _V76LogicalChannelParameters},=0A=
+	{FNAME("h2250LogicalChannelParameters") SEQ, 10, 11, 14, DECODE | EXT,=0A=
+	 offsetof=0A=
+	 =
(OpenLogicalChannel_forwardLogicalChannelParameters_multiplexParameters,=0A=
+	  h2250LogicalChannelParameters), _H2250LogicalChannelParameters},=0A=
+	{FNAME("none") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _OpenLogicalChannel_forwardLogicalChannelParameters[] =
=3D {	/* SEQUENCE */=0A=
+	{FNAME("portNumber") INT, WORD, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("dataType") CHOICE, 3, 6, 9, DECODE | EXT,=0A=
+	 offsetof(OpenLogicalChannel_forwardLogicalChannelParameters,=0A=
+		  dataType), _DataType},=0A=
+	{FNAME("multiplexParameters") CHOICE, 2, 3, 5, DECODE | EXT,=0A=
+	 offsetof(OpenLogicalChannel_forwardLogicalChannelParameters,=0A=
+		  multiplexParameters),=0A=
+	 =
_OpenLogicalChannel_forwardLogicalChannelParameters_multiplexParameters},=0A=
+	{FNAME("forwardLogicalChannelDependency") INT, WORD, 1, 0, SKIP | OPT,=0A=
+	 0, NULL},=0A=
+	{FNAME("replacementFor") INT, WORD, 1, 0, SKIP | OPT, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t =
_OpenLogicalChannel_reverseLogicalChannelParameters_multiplexParameters[]=
 =3D {	/* CHOICE */=0A=
+	{FNAME("h223LogicalChannelParameters") SEQ, 0, 2, 2, SKIP | EXT, 0,=0A=
+	 _H223LogicalChannelParameters},=0A=
+	{FNAME("v76LogicalChannelParameters") SEQ, 0, 5, 5, SKIP | EXT, 0,=0A=
+	 _V76LogicalChannelParameters},=0A=
+	{FNAME("h2250LogicalChannelParameters") SEQ, 10, 11, 14, DECODE | EXT,=0A=
+	 offsetof=0A=
+	 =
(OpenLogicalChannel_reverseLogicalChannelParameters_multiplexParameters,=0A=
+	  h2250LogicalChannelParameters), _H2250LogicalChannelParameters},=0A=
+};=0A=
+=0A=
+static field_t _OpenLogicalChannel_reverseLogicalChannelParameters[] =
=3D {	/* SEQUENCE */=0A=
+	{FNAME("dataType") CHOICE, 3, 6, 9, SKIP | EXT, 0, _DataType},=0A=
+	{FNAME("multiplexParameters") CHOICE, 1, 2, 3, DECODE | EXT | OPT,=0A=
+	 offsetof(OpenLogicalChannel_reverseLogicalChannelParameters,=0A=
+		  multiplexParameters),=0A=
+	 =
_OpenLogicalChannel_reverseLogicalChannelParameters_multiplexParameters},=0A=
+	{FNAME("reverseLogicalChannelDependency") INT, WORD, 1, 0, SKIP | OPT,=0A=
+	 0, NULL},=0A=
+	{FNAME("replacementFor") INT, WORD, 1, 0, SKIP | OPT, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _NetworkAccessParameters_distribution[] =3D {	/* CHOICE =
*/=0A=
+	{FNAME("unicast") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("multicast") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _Q2931Address_address[] =3D {	/* CHOICE */=0A=
+	{FNAME("internationalNumber") NUMSTR, 4, 1, 0, SKIP, 0, NULL},=0A=
+	{FNAME("nsapAddress") OCTSTR, 5, 1, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _Q2931Address[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("address") CHOICE, 1, 2, 2, SKIP | EXT, 0,=0A=
+	 _Q2931Address_address},=0A=
+	{FNAME("subaddress") OCTSTR, 5, 1, 0, SKIP | OPT, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _NetworkAccessParameters_networkAddress[] =3D {	/* =
CHOICE */=0A=
+	{FNAME("q2931Address") SEQ, 1, 2, 2, SKIP | EXT, 0, _Q2931Address},=0A=
+	{FNAME("e164Address") NUMDGT, 7, 1, 0, SKIP, 0, NULL},=0A=
+	{FNAME("localAreaAddress") CHOICE, 1, 2, 2, DECODE | EXT,=0A=
+	 offsetof(NetworkAccessParameters_networkAddress, localAreaAddress),=0A=
+	 _H245_TransportAddress},=0A=
+};=0A=
+=0A=
+static field_t _NetworkAccessParameters[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("distribution") CHOICE, 1, 2, 2, SKIP | EXT | OPT, 0,=0A=
+	 _NetworkAccessParameters_distribution},=0A=
+	{FNAME("networkAddress") CHOICE, 2, 3, 3, DECODE | EXT,=0A=
+	 offsetof(NetworkAccessParameters, networkAddress),=0A=
+	 _NetworkAccessParameters_networkAddress},=0A=
+	{FNAME("associateConference") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("externalReference") OCTSTR, 8, 1, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("t120SetupProcedure") CHOICE, 2, 3, 3, SKIP | EXT | OPT, 0,=0A=
+	 NULL},=0A=
+};=0A=
+=0A=
+static field_t _OpenLogicalChannel[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("forwardLogicalChannelNumber") INT, WORD, 1, 0, SKIP, 0, NULL},=0A=
+	{FNAME("forwardLogicalChannelParameters") SEQ, 1, 3, 5, DECODE | EXT,=0A=
+	 offsetof(OpenLogicalChannel, forwardLogicalChannelParameters),=0A=
+	 _OpenLogicalChannel_forwardLogicalChannelParameters},=0A=
+	{FNAME("reverseLogicalChannelParameters") SEQ, 1, 2, 4,=0A=
+	 DECODE | EXT | OPT, offsetof(OpenLogicalChannel,=0A=
+				      reverseLogicalChannelParameters),=0A=
+	 _OpenLogicalChannel_reverseLogicalChannelParameters},=0A=
+	{FNAME("separateStack") SEQ, 2, 4, 5, DECODE | EXT | OPT,=0A=
+	 offsetof(OpenLogicalChannel, separateStack),=0A=
+	 _NetworkAccessParameters},=0A=
+	{FNAME("encryptionSync") SEQ, 2, 4, 4, STOP | EXT | OPT, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _Setup_UUIE_fastStart[] =3D {	/* SEQUENCE OF */=0A=
+	{FNAME("item") SEQ, 1, 3, 5, DECODE | OPEN | EXT,=0A=
+	 sizeof(OpenLogicalChannel), _OpenLogicalChannel}=0A=
+	,=0A=
+};=0A=
+=0A=
+static field_t _Setup_UUIE[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("protocolIdentifier") OID, BYTE, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("h245Address") CHOICE, 3, 7, 7, DECODE | EXT | OPT,=0A=
+	 offsetof(Setup_UUIE, h245Address), _TransportAddress},=0A=
+	{FNAME("sourceAddress") SEQOF, SEMI, 0, 0, SKIP | OPT, 0,=0A=
+	 _Setup_UUIE_sourceAddress},=0A=
+	{FNAME("sourceInfo") SEQ, 6, 8, 10, SKIP | EXT, 0, _EndpointType},=0A=
+	{FNAME("destinationAddress") SEQOF, SEMI, 0, 0, SKIP | OPT, 0,=0A=
+	 _Setup_UUIE_destinationAddress},=0A=
+	{FNAME("destCallSignalAddress") CHOICE, 3, 7, 7, DECODE | EXT | OPT,=0A=
+	 offsetof(Setup_UUIE, destCallSignalAddress), _TransportAddress},=0A=
+	{FNAME("destExtraCallInfo") SEQOF, SEMI, 0, 0, SKIP | OPT, 0,=0A=
+	 _Setup_UUIE_destExtraCallInfo},=0A=
+	{FNAME("destExtraCRV") SEQOF, SEMI, 0, 0, SKIP | OPT, 0,=0A=
+	 _Setup_UUIE_destExtraCRV},=0A=
+	{FNAME("activeMC") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("conferenceID") OCTSTR, FIXD, 16, 0, SKIP, 0, NULL},=0A=
+	{FNAME("conferenceGoal") CHOICE, 2, 3, 5, SKIP | EXT, 0,=0A=
+	 _Setup_UUIE_conferenceGoal},=0A=
+	{FNAME("callServices") SEQ, 0, 8, 8, SKIP | EXT | OPT, 0,=0A=
+	 _QseriesOptions},=0A=
+	{FNAME("callType") CHOICE, 2, 4, 4, SKIP | EXT, 0, _CallType},=0A=
+	{FNAME("sourceCallSignalAddress") CHOICE, 3, 7, 7, DECODE | EXT | OPT,=0A=
+	 offsetof(Setup_UUIE, sourceCallSignalAddress), _TransportAddress},=0A=
+	{FNAME("remoteExtensionAddress") CHOICE, 1, 2, 7, SKIP | EXT | OPT, 0,=0A=
+	 NULL},=0A=
+	{FNAME("callIdentifier") SEQ, 0, 1, 1, SKIP | EXT, 0, NULL},=0A=
+	{FNAME("h245SecurityCapability") SEQOF, SEMI, 0, 0, SKIP | OPT, 0,=0A=
+	 NULL},=0A=
+	{FNAME("tokens") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("cryptoTokens") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("fastStart") SEQOF, SEMI, 0, 30, DECODE | OPT,=0A=
+	 offsetof(Setup_UUIE, fastStart), _Setup_UUIE_fastStart},=0A=
+	{FNAME("mediaWaitForConnect") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("canOverlapSend") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("endpointIdentifier") BMPSTR, 7, 1, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("multipleCalls") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("maintainConnection") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("connectionParameters") SEQ, 0, 3, 3, SKIP | EXT | OPT, 0,=0A=
+	 NULL},=0A=
+	{FNAME("language") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("presentationIndicator") CHOICE, 2, 3, 3, SKIP | EXT | OPT, 0,=0A=
+	 NULL},=0A=
+	{FNAME("screeningIndicator") ENUM, 2, 0, 0, SKIP | EXT | OPT, 0,=0A=
+	 NULL},=0A=
+	{FNAME("serviceControl") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("symmetricOperationRequired") NUL, FIXD, 0, 0, SKIP | OPT, 0,=0A=
+	 NULL},=0A=
+	{FNAME("capacity") SEQ, 2, 2, 2, SKIP | EXT | OPT, 0, NULL},=0A=
+	{FNAME("circuitInfo") SEQ, 3, 3, 3, SKIP | EXT | OPT, 0, NULL},=0A=
+	{FNAME("desiredProtocols") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("neededFeatures") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("desiredFeatures") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("supportedFeatures") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("parallelH245Control") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("additionalSourceAddresses") SEQOF, SEMI, 0, 0, SKIP | OPT, 0,=0A=
+	 NULL},=0A=
+};=0A=
+=0A=
+static field_t _CallProceeding_UUIE_fastStart[] =3D {	/* SEQUENCE OF */=0A=
+	{FNAME("item") SEQ, 1, 3, 5, DECODE | OPEN | EXT,=0A=
+	 sizeof(OpenLogicalChannel), _OpenLogicalChannel}=0A=
+	,=0A=
+};=0A=
+=0A=
+static field_t _CallProceeding_UUIE[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("protocolIdentifier") OID, BYTE, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("destinationInfo") SEQ, 6, 8, 10, SKIP | EXT, 0,=0A=
+	 _EndpointType},=0A=
+	{FNAME("h245Address") CHOICE, 3, 7, 7, DECODE | EXT | OPT,=0A=
+	 offsetof(CallProceeding_UUIE, h245Address), _TransportAddress},=0A=
+	{FNAME("callIdentifier") SEQ, 0, 1, 1, SKIP | EXT, 0, NULL},=0A=
+	{FNAME("h245SecurityMode") CHOICE, 2, 4, 4, SKIP | EXT | OPT, 0,=0A=
+	 NULL},=0A=
+	{FNAME("tokens") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("cryptoTokens") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("fastStart") SEQOF, SEMI, 0, 30, DECODE | OPT,=0A=
+	 offsetof(CallProceeding_UUIE, fastStart),=0A=
+	 _CallProceeding_UUIE_fastStart},=0A=
+	{FNAME("multipleCalls") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("maintainConnection") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("fastConnectRefused") NUL, FIXD, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("featureSet") SEQ, 3, 4, 4, SKIP | EXT | OPT, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _Connect_UUIE_fastStart[] =3D {	/* SEQUENCE OF */=0A=
+	{FNAME("item") SEQ, 1, 3, 5, DECODE | OPEN | EXT,=0A=
+	 sizeof(OpenLogicalChannel), _OpenLogicalChannel}=0A=
+	,=0A=
+};=0A=
+=0A=
+static field_t _Connect_UUIE[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("protocolIdentifier") OID, BYTE, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("h245Address") CHOICE, 3, 7, 7, DECODE | EXT | OPT,=0A=
+	 offsetof(Connect_UUIE, h245Address), _TransportAddress},=0A=
+	{FNAME("destinationInfo") SEQ, 6, 8, 10, SKIP | EXT, 0,=0A=
+	 _EndpointType},=0A=
+	{FNAME("conferenceID") OCTSTR, FIXD, 16, 0, SKIP, 0, NULL},=0A=
+	{FNAME("callIdentifier") SEQ, 0, 1, 1, SKIP | EXT, 0, NULL},=0A=
+	{FNAME("h245SecurityMode") CHOICE, 2, 4, 4, SKIP | EXT | OPT, 0,=0A=
+	 NULL},=0A=
+	{FNAME("tokens") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("cryptoTokens") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("fastStart") SEQOF, SEMI, 0, 30, DECODE | OPT,=0A=
+	 offsetof(Connect_UUIE, fastStart), _Connect_UUIE_fastStart},=0A=
+	{FNAME("multipleCalls") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("maintainConnection") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("language") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("connectedAddress") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("presentationIndicator") CHOICE, 2, 3, 3, SKIP | EXT | OPT, 0,=0A=
+	 NULL},=0A=
+	{FNAME("screeningIndicator") ENUM, 2, 0, 0, SKIP | EXT | OPT, 0,=0A=
+	 NULL},=0A=
+	{FNAME("fastConnectRefused") NUL, FIXD, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("serviceControl") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("capacity") SEQ, 2, 2, 2, SKIP | EXT | OPT, 0, NULL},=0A=
+	{FNAME("featureSet") SEQ, 3, 4, 4, SKIP | EXT | OPT, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _Alerting_UUIE_fastStart[] =3D {	/* SEQUENCE OF */=0A=
+	{FNAME("item") SEQ, 1, 3, 5, DECODE | OPEN | EXT,=0A=
+	 sizeof(OpenLogicalChannel), _OpenLogicalChannel}=0A=
+	,=0A=
+};=0A=
+=0A=
+static field_t _Alerting_UUIE[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("protocolIdentifier") OID, BYTE, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("destinationInfo") SEQ, 6, 8, 10, SKIP | EXT, 0,=0A=
+	 _EndpointType},=0A=
+	{FNAME("h245Address") CHOICE, 3, 7, 7, DECODE | EXT | OPT,=0A=
+	 offsetof(Alerting_UUIE, h245Address), _TransportAddress},=0A=
+	{FNAME("callIdentifier") SEQ, 0, 1, 1, SKIP | EXT, 0, NULL},=0A=
+	{FNAME("h245SecurityMode") CHOICE, 2, 4, 4, SKIP | EXT | OPT, 0,=0A=
+	 NULL},=0A=
+	{FNAME("tokens") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("cryptoTokens") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("fastStart") SEQOF, SEMI, 0, 30, DECODE | OPT,=0A=
+	 offsetof(Alerting_UUIE, fastStart), _Alerting_UUIE_fastStart},=0A=
+	{FNAME("multipleCalls") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("maintainConnection") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("alertingAddress") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("presentationIndicator") CHOICE, 2, 3, 3, SKIP | EXT | OPT, 0,=0A=
+	 NULL},=0A=
+	{FNAME("screeningIndicator") ENUM, 2, 0, 0, SKIP | EXT | OPT, 0,=0A=
+	 NULL},=0A=
+	{FNAME("fastConnectRefused") NUL, FIXD, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("serviceControl") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("capacity") SEQ, 2, 2, 2, SKIP | EXT | OPT, 0, NULL},=0A=
+	{FNAME("featureSet") SEQ, 3, 4, 4, SKIP | EXT | OPT, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _Information_UUIE_fastStart[] =3D {	/* SEQUENCE OF */=0A=
+	{FNAME("item") SEQ, 1, 3, 5, DECODE | OPEN | EXT,=0A=
+	 sizeof(OpenLogicalChannel), _OpenLogicalChannel}=0A=
+	,=0A=
+};=0A=
+=0A=
+static field_t _Information_UUIE[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("protocolIdentifier") OID, BYTE, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("callIdentifier") SEQ, 0, 1, 1, SKIP | EXT, 0, NULL},=0A=
+	{FNAME("tokens") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("cryptoTokens") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("fastStart") SEQOF, SEMI, 0, 30, DECODE | OPT,=0A=
+	 offsetof(Information_UUIE, fastStart), _Information_UUIE_fastStart},=0A=
+	{FNAME("fastConnectRefused") NUL, FIXD, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("circuitInfo") SEQ, 3, 3, 3, SKIP | EXT | OPT, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _ReleaseCompleteReason[] =3D {	/* CHOICE */=0A=
+	{FNAME("noBandwidth") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("gatekeeperResources") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("unreachableDestination") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("destinationRejection") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("invalidRevision") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("noPermission") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("unreachableGatekeeper") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("gatewayResources") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("badFormatAddress") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("adaptiveBusy") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("inConf") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("undefinedReason") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("facilityCallDeflection") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("securityDenied") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("calledPartyNotRegistered") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("callerNotRegistered") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("newConnectionNeeded") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("nonStandardReason") SEQ, 0, 2, 2, SKIP, 0, NULL},=0A=
+	{FNAME("replaceWithConferenceInvite") OCTSTR, FIXD, 16, 0, SKIP, 0,=0A=
+	 NULL},=0A=
+	{FNAME("genericDataReason") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("neededFeatureNotSupported") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("tunnelledSignallingRejected") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _ReleaseComplete_UUIE[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("protocolIdentifier") OID, BYTE, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("reason") CHOICE, 4, 12, 22, SKIP | EXT | OPT, 0,=0A=
+	 _ReleaseCompleteReason},=0A=
+	{FNAME("callIdentifier") SEQ, 0, 1, 1, SKIP | EXT, 0, NULL},=0A=
+	{FNAME("tokens") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("cryptoTokens") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("busyAddress") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("presentationIndicator") CHOICE, 2, 3, 3, SKIP | EXT | OPT, 0,=0A=
+	 NULL},=0A=
+	{FNAME("screeningIndicator") ENUM, 2, 0, 0, SKIP | EXT | OPT, 0,=0A=
+	 NULL},=0A=
+	{FNAME("capacity") SEQ, 2, 2, 2, SKIP | EXT | OPT, 0, NULL},=0A=
+	{FNAME("serviceControl") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("featureSet") SEQ, 3, 4, 4, SKIP | EXT | OPT, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _Facility_UUIE_alternativeAliasAddress[] =3D {	/* =
SEQUENCE OF */=0A=
+	{FNAME("item") CHOICE, 1, 2, 7, SKIP | EXT, 0, _AliasAddress},=0A=
+};=0A=
+=0A=
+static field_t _FacilityReason[] =3D {	/* CHOICE */=0A=
+	{FNAME("routeCallToGatekeeper") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("callForwarded") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("routeCallToMC") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("undefinedReason") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("conferenceListChoice") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("startH245") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("noH245") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("newTokens") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("featureSetUpdate") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("forwardedElements") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("transportedInformation") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _Facility_UUIE_fastStart[] =3D {	/* SEQUENCE OF */=0A=
+	{FNAME("item") SEQ, 1, 3, 5, DECODE | OPEN | EXT,=0A=
+	 sizeof(OpenLogicalChannel), _OpenLogicalChannel}=0A=
+	,=0A=
+};=0A=
+=0A=
+static field_t _Facility_UUIE[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("protocolIdentifier") OID, BYTE, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("alternativeAddress") CHOICE, 3, 7, 7, SKIP | EXT | OPT, 0,=0A=
+	 _TransportAddress},=0A=
+	{FNAME("alternativeAliasAddress") SEQOF, SEMI, 0, 0, SKIP | OPT, 0,=0A=
+	 _Facility_UUIE_alternativeAliasAddress},=0A=
+	{FNAME("conferenceID") OCTSTR, FIXD, 16, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("reason") CHOICE, 2, 4, 11, DECODE | EXT,=0A=
+	 offsetof(Facility_UUIE, reason), _FacilityReason},=0A=
+	{FNAME("callIdentifier") SEQ, 0, 1, 1, SKIP | EXT, 0, NULL},=0A=
+	{FNAME("destExtraCallInfo") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("remoteExtensionAddress") CHOICE, 1, 2, 7, SKIP | EXT | OPT, 0,=0A=
+	 NULL},=0A=
+	{FNAME("tokens") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("cryptoTokens") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("conferences") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("h245Address") CHOICE, 3, 7, 7, DECODE | EXT | OPT,=0A=
+	 offsetof(Facility_UUIE, h245Address), _TransportAddress},=0A=
+	{FNAME("fastStart") SEQOF, SEMI, 0, 30, DECODE | OPT,=0A=
+	 offsetof(Facility_UUIE, fastStart), _Facility_UUIE_fastStart},=0A=
+	{FNAME("multipleCalls") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("maintainConnection") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("fastConnectRefused") NUL, FIXD, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("serviceControl") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("circuitInfo") SEQ, 3, 3, 3, SKIP | EXT | OPT, 0, NULL},=0A=
+	{FNAME("featureSet") SEQ, 3, 4, 4, SKIP | EXT | OPT, 0, NULL},=0A=
+	{FNAME("destinationInfo") SEQ, 6, 8, 10, SKIP | EXT | OPT, 0, NULL},=0A=
+	{FNAME("h245SecurityMode") CHOICE, 2, 4, 4, SKIP | EXT | OPT, 0,=0A=
+	 NULL},=0A=
+};=0A=
+=0A=
+static field_t _CallIdentifier[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("guid") OCTSTR, FIXD, 16, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _SecurityServiceMode[] =3D {	/* CHOICE */=0A=
+	{FNAME("nonStandard") SEQ, 0, 2, 2, SKIP, 0, _NonStandardParameter},=0A=
+	{FNAME("none") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("default") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _SecurityCapabilities[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("nonStandard") SEQ, 0, 2, 2, SKIP | OPT, 0,=0A=
+	 _NonStandardParameter},=0A=
+	{FNAME("encryption") CHOICE, 2, 3, 3, SKIP | EXT, 0,=0A=
+	 _SecurityServiceMode},=0A=
+	{FNAME("authenticaton") CHOICE, 2, 3, 3, SKIP | EXT, 0,=0A=
+	 _SecurityServiceMode},=0A=
+	{FNAME("integrity") CHOICE, 2, 3, 3, SKIP | EXT, 0,=0A=
+	 _SecurityServiceMode},=0A=
+};=0A=
+=0A=
+static field_t _H245Security[] =3D {	/* CHOICE */=0A=
+	{FNAME("nonStandard") SEQ, 0, 2, 2, SKIP, 0, _NonStandardParameter},=0A=
+	{FNAME("noSecurity") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("tls") SEQ, 1, 4, 4, SKIP | EXT, 0, _SecurityCapabilities},=0A=
+	{FNAME("ipsec") SEQ, 1, 4, 4, SKIP | EXT, 0, _SecurityCapabilities},=0A=
+};=0A=
+=0A=
+static field_t _DHset[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("halfkey") BITSTR, WORD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("modSize") BITSTR, WORD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("generator") BITSTR, WORD, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _TypedCertificate[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("type") OID, BYTE, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("certificate") OCTSTR, SEMI, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _H235_NonStandardParameter[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("nonStandardIdentifier") OID, BYTE, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("data") OCTSTR, SEMI, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _ClearToken[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("tokenOID") OID, BYTE, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("timeStamp") INT, CONS, 1, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("password") BMPSTR, 7, 1, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("dhkey") SEQ, 0, 3, 3, SKIP | EXT | OPT, 0, _DHset},=0A=
+	{FNAME("challenge") OCTSTR, 7, 8, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("random") INT, UNCO, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("certificate") SEQ, 0, 2, 2, SKIP | EXT | OPT, 0,=0A=
+	 _TypedCertificate},=0A=
+	{FNAME("generalID") BMPSTR, 7, 1, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("nonStandard") SEQ, 0, 2, 2, SKIP | OPT, 0,=0A=
+	 _H235_NonStandardParameter},=0A=
+	{FNAME("eckasdhkey") CHOICE, 1, 2, 2, SKIP | EXT | OPT, 0, NULL},=0A=
+	{FNAME("sendersID") BMPSTR, 7, 1, 0, SKIP | OPT, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _Progress_UUIE_tokens[] =3D {	/* SEQUENCE OF */=0A=
+	{FNAME("item") SEQ, 8, 9, 11, SKIP | EXT, 0, _ClearToken},=0A=
+};=0A=
+=0A=
+static field_t _Params[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("ranInt") INT, UNCO, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("iv8") OCTSTR, FIXD, 8, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("iv16") OCTSTR, FIXD, 16, 0, SKIP | OPT, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _CryptoH323Token_cryptoEPPwdHash_token[] =3D {	/* =
SEQUENCE */=0A=
+	{FNAME("algorithmOID") OID, BYTE, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("paramS") SEQ, 2, 2, 3, SKIP | EXT, 0, _Params},=0A=
+	{FNAME("hash") BITSTR, SEMI, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _CryptoH323Token_cryptoEPPwdHash[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("alias") CHOICE, 1, 2, 7, SKIP | EXT, 0, _AliasAddress},=0A=
+	{FNAME("timeStamp") INT, CONS, 1, 0, SKIP, 0, NULL},=0A=
+	{FNAME("token") SEQ, 0, 3, 3, SKIP, 0,=0A=
+	 _CryptoH323Token_cryptoEPPwdHash_token},=0A=
+};=0A=
+=0A=
+static field_t _CryptoH323Token_cryptoGKPwdHash_token[] =3D {	/* =
SEQUENCE */=0A=
+	{FNAME("algorithmOID") OID, BYTE, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("paramS") SEQ, 2, 2, 3, SKIP | EXT, 0, _Params},=0A=
+	{FNAME("hash") BITSTR, SEMI, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _CryptoH323Token_cryptoGKPwdHash[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("gatekeeperId") BMPSTR, 7, 1, 0, SKIP, 0, NULL},=0A=
+	{FNAME("timeStamp") INT, CONS, 1, 0, SKIP, 0, NULL},=0A=
+	{FNAME("token") SEQ, 0, 3, 3, SKIP, 0,=0A=
+	 _CryptoH323Token_cryptoGKPwdHash_token},=0A=
+};=0A=
+=0A=
+static field_t _CryptoH323Token_cryptoEPPwdEncr[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("algorithmOID") OID, BYTE, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("paramS") SEQ, 2, 2, 3, SKIP | EXT, 0, _Params},=0A=
+	{FNAME("encryptedData") OCTSTR, SEMI, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _CryptoH323Token_cryptoGKPwdEncr[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("algorithmOID") OID, BYTE, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("paramS") SEQ, 2, 2, 3, SKIP | EXT, 0, _Params},=0A=
+	{FNAME("encryptedData") OCTSTR, SEMI, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _CryptoH323Token_cryptoEPCert[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("toBeSigned") SEQ, 8, 9, 11, SKIP | OPEN | EXT, 0, NULL},=0A=
+	{FNAME("algorithmOID") OID, BYTE, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("paramS") SEQ, 2, 2, 3, SKIP | EXT, 0, _Params},=0A=
+	{FNAME("signature") BITSTR, SEMI, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _CryptoH323Token_cryptoGKCert[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("toBeSigned") SEQ, 8, 9, 11, SKIP | OPEN | EXT, 0, NULL},=0A=
+	{FNAME("algorithmOID") OID, BYTE, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("paramS") SEQ, 2, 2, 3, SKIP | EXT, 0, _Params},=0A=
+	{FNAME("signature") BITSTR, SEMI, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _CryptoH323Token_cryptoFastStart[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("toBeSigned") SEQ, 8, 9, 11, SKIP | OPEN | EXT, 0, NULL},=0A=
+	{FNAME("algorithmOID") OID, BYTE, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("paramS") SEQ, 2, 2, 3, SKIP | EXT, 0, _Params},=0A=
+	{FNAME("signature") BITSTR, SEMI, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _CryptoToken_cryptoEncryptedToken_token[] =3D {	/* =
SEQUENCE */=0A=
+	{FNAME("algorithmOID") OID, BYTE, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("paramS") SEQ, 2, 2, 3, SKIP | EXT, 0, _Params},=0A=
+	{FNAME("encryptedData") OCTSTR, SEMI, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _CryptoToken_cryptoEncryptedToken[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("tokenOID") OID, BYTE, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("token") SEQ, 0, 3, 3, SKIP, 0,=0A=
+	 _CryptoToken_cryptoEncryptedToken_token},=0A=
+};=0A=
+=0A=
+static field_t _CryptoToken_cryptoSignedToken_token[] =3D {	/* SEQUENCE =
*/=0A=
+	{FNAME("toBeSigned") SEQ, 8, 9, 11, SKIP | OPEN | EXT, 0, NULL},=0A=
+	{FNAME("algorithmOID") OID, BYTE, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("paramS") SEQ, 2, 2, 3, SKIP | EXT, 0, _Params},=0A=
+	{FNAME("signature") BITSTR, SEMI, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _CryptoToken_cryptoSignedToken[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("tokenOID") OID, BYTE, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("token") SEQ, 0, 4, 4, SKIP, 0,=0A=
+	 _CryptoToken_cryptoSignedToken_token},=0A=
+};=0A=
+=0A=
+static field_t _CryptoToken_cryptoHashedToken_token[] =3D {	/* SEQUENCE =
*/=0A=
+	{FNAME("algorithmOID") OID, BYTE, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("paramS") SEQ, 2, 2, 3, SKIP | EXT, 0, _Params},=0A=
+	{FNAME("hash") BITSTR, SEMI, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _CryptoToken_cryptoHashedToken[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("tokenOID") OID, BYTE, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("hashedVals") SEQ, 8, 9, 11, SKIP | EXT, 0, _ClearToken},=0A=
+	{FNAME("token") SEQ, 0, 3, 3, SKIP, 0,=0A=
+	 _CryptoToken_cryptoHashedToken_token},=0A=
+};=0A=
+=0A=
+static field_t _CryptoToken_cryptoPwdEncr[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("algorithmOID") OID, BYTE, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("paramS") SEQ, 2, 2, 3, SKIP | EXT, 0, _Params},=0A=
+	{FNAME("encryptedData") OCTSTR, SEMI, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _CryptoToken[] =3D {	/* CHOICE */=0A=
+	{FNAME("cryptoEncryptedToken") SEQ, 0, 2, 2, SKIP, 0,=0A=
+	 _CryptoToken_cryptoEncryptedToken},=0A=
+	{FNAME("cryptoSignedToken") SEQ, 0, 2, 2, SKIP, 0,=0A=
+	 _CryptoToken_cryptoSignedToken},=0A=
+	{FNAME("cryptoHashedToken") SEQ, 0, 3, 3, SKIP, 0,=0A=
+	 _CryptoToken_cryptoHashedToken},=0A=
+	{FNAME("cryptoPwdEncr") SEQ, 0, 3, 3, SKIP, 0,=0A=
+	 _CryptoToken_cryptoPwdEncr},=0A=
+};=0A=
+=0A=
+static field_t _CryptoH323Token[] =3D {	/* CHOICE */=0A=
+	{FNAME("cryptoEPPwdHash") SEQ, 0, 3, 3, SKIP, 0,=0A=
+	 _CryptoH323Token_cryptoEPPwdHash},=0A=
+	{FNAME("cryptoGKPwdHash") SEQ, 0, 3, 3, SKIP, 0,=0A=
+	 _CryptoH323Token_cryptoGKPwdHash},=0A=
+	{FNAME("cryptoEPPwdEncr") SEQ, 0, 3, 3, SKIP, 0,=0A=
+	 _CryptoH323Token_cryptoEPPwdEncr},=0A=
+	{FNAME("cryptoGKPwdEncr") SEQ, 0, 3, 3, SKIP, 0,=0A=
+	 _CryptoH323Token_cryptoGKPwdEncr},=0A=
+	{FNAME("cryptoEPCert") SEQ, 0, 4, 4, SKIP, 0,=0A=
+	 _CryptoH323Token_cryptoEPCert},=0A=
+	{FNAME("cryptoGKCert") SEQ, 0, 4, 4, SKIP, 0,=0A=
+	 _CryptoH323Token_cryptoGKCert},=0A=
+	{FNAME("cryptoFastStart") SEQ, 0, 4, 4, SKIP, 0,=0A=
+	 _CryptoH323Token_cryptoFastStart},=0A=
+	{FNAME("nestedcryptoToken") CHOICE, 2, 4, 4, SKIP | EXT, 0,=0A=
+	 _CryptoToken},=0A=
+};=0A=
+=0A=
+static field_t _Progress_UUIE_cryptoTokens[] =3D {	/* SEQUENCE OF */=0A=
+	{FNAME("item") CHOICE, 3, 8, 8, SKIP | EXT, 0, _CryptoH323Token},=0A=
+};=0A=
+=0A=
+static field_t _Progress_UUIE_fastStart[] =3D {	/* SEQUENCE OF */=0A=
+	{FNAME("item") SEQ, 1, 3, 5, DECODE | OPEN | EXT,=0A=
+	 sizeof(OpenLogicalChannel), _OpenLogicalChannel}=0A=
+	,=0A=
+};=0A=
+=0A=
+static field_t _Progress_UUIE[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("protocolIdentifier") OID, BYTE, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("destinationInfo") SEQ, 6, 8, 10, SKIP | EXT, 0,=0A=
+	 _EndpointType},=0A=
+	{FNAME("h245Address") CHOICE, 3, 7, 7, DECODE | EXT | OPT,=0A=
+	 offsetof(Progress_UUIE, h245Address), _TransportAddress},=0A=
+	{FNAME("callIdentifier") SEQ, 0, 1, 1, SKIP | EXT, 0,=0A=
+	 _CallIdentifier},=0A=
+	{FNAME("h245SecurityMode") CHOICE, 2, 4, 4, SKIP | EXT | OPT, 0,=0A=
+	 _H245Security},=0A=
+	{FNAME("tokens") SEQOF, SEMI, 0, 0, SKIP | OPT, 0,=0A=
+	 _Progress_UUIE_tokens},=0A=
+	{FNAME("cryptoTokens") SEQOF, SEMI, 0, 0, SKIP | OPT, 0,=0A=
+	 _Progress_UUIE_cryptoTokens},=0A=
+	{FNAME("fastStart") SEQOF, SEMI, 0, 30, DECODE | OPT,=0A=
+	 offsetof(Progress_UUIE, fastStart), _Progress_UUIE_fastStart},=0A=
+	{FNAME("multipleCalls") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("maintainConnection") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("fastConnectRefused") NUL, FIXD, 0, 0, SKIP | OPT, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _H323_UU_PDU_h323_message_body[] =3D {	/* CHOICE */=0A=
+	{FNAME("setup") SEQ, 7, 13, 39, DECODE | EXT,=0A=
+	 offsetof(H323_UU_PDU_h323_message_body, setup), _Setup_UUIE},=0A=
+	{FNAME("callProceeding") SEQ, 1, 3, 12, DECODE | EXT,=0A=
+	 offsetof(H323_UU_PDU_h323_message_body, callProceeding),=0A=
+	 _CallProceeding_UUIE},=0A=
+	{FNAME("connect") SEQ, 1, 4, 19, DECODE | EXT,=0A=
+	 offsetof(H323_UU_PDU_h323_message_body, connect), _Connect_UUIE},=0A=
+	{FNAME("alerting") SEQ, 1, 3, 17, DECODE | EXT,=0A=
+	 offsetof(H323_UU_PDU_h323_message_body, alerting), _Alerting_UUIE},=0A=
+	{FNAME("information") SEQ, 0, 1, 7, DECODE | EXT,=0A=
+	 offsetof(H323_UU_PDU_h323_message_body, information),=0A=
+	 _Information_UUIE},=0A=
+	{FNAME("releaseComplete") SEQ, 1, 2, 11, SKIP | EXT, 0,=0A=
+	 _ReleaseComplete_UUIE},=0A=
+	{FNAME("facility") SEQ, 3, 5, 21, DECODE | EXT,=0A=
+	 offsetof(H323_UU_PDU_h323_message_body, facility), _Facility_UUIE},=0A=
+	{FNAME("progress") SEQ, 5, 8, 11, DECODE | EXT,=0A=
+	 offsetof(H323_UU_PDU_h323_message_body, progress), _Progress_UUIE},=0A=
+	{FNAME("empty") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("status") SEQ, 2, 4, 4, SKIP | EXT, 0, NULL},=0A=
+	{FNAME("statusInquiry") SEQ, 2, 4, 4, SKIP | EXT, 0, NULL},=0A=
+	{FNAME("setupAcknowledge") SEQ, 2, 4, 4, SKIP | EXT, 0, NULL},=0A=
+	{FNAME("notify") SEQ, 2, 4, 4, SKIP | EXT, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _RequestMessage[] =3D {	/* CHOICE */=0A=
+	{FNAME("nonStandard") SEQ, 0, 1, 1, STOP | EXT, 0, NULL},=0A=
+	{FNAME("masterSlaveDetermination") SEQ, 0, 2, 2, STOP | EXT, 0, NULL},=0A=
+	{FNAME("terminalCapabilitySet") SEQ, 3, 5, 5, STOP | EXT, 0, NULL},=0A=
+	{FNAME("openLogicalChannel") SEQ, 1, 3, 5, DECODE | EXT,=0A=
+	 offsetof(RequestMessage, openLogicalChannel), _OpenLogicalChannel},=0A=
+	{FNAME("closeLogicalChannel") SEQ, 0, 2, 3, STOP | EXT, 0, NULL},=0A=
+	{FNAME("requestChannelClose") SEQ, 0, 1, 3, STOP | EXT, 0, NULL},=0A=
+	{FNAME("multiplexEntrySend") SEQ, 0, 2, 2, STOP | EXT, 0, NULL},=0A=
+	{FNAME("requestMultiplexEntry") SEQ, 0, 1, 1, STOP | EXT, 0, NULL},=0A=
+	{FNAME("requestMode") SEQ, 0, 2, 2, STOP | EXT, 0, NULL},=0A=
+	{FNAME("roundTripDelayRequest") SEQ, 0, 1, 1, STOP | EXT, 0, NULL},=0A=
+	{FNAME("maintenanceLoopRequest") SEQ, 0, 1, 1, STOP | EXT, 0, NULL},=0A=
+	{FNAME("communicationModeRequest") SEQ, 0, 0, 0, STOP | EXT, 0, NULL},=0A=
+	{FNAME("conferenceRequest") CHOICE, 3, 8, 16, STOP | EXT, 0, NULL},=0A=
+	{FNAME("multilinkRequest") CHOICE, 3, 5, 5, STOP | EXT, 0, NULL},=0A=
+	{FNAME("logicalChannelRateRequest") SEQ, 0, 3, 3, STOP | EXT, 0,=0A=
+	 NULL},=0A=
+};=0A=
+=0A=
+static field_t =
_OpenLogicalChannelAck_reverseLogicalChannelParameters_multiplexParameter=
s[] =3D {	/* CHOICE */=0A=
+	{FNAME("h222LogicalChannelParameters") SEQ, 3, 5, 5, SKIP | EXT, 0,=0A=
+	 _H222LogicalChannelParameters},=0A=
+	{FNAME("h2250LogicalChannelParameters") SEQ, 10, 11, 14, DECODE | EXT,=0A=
+	 offsetof=0A=
+	 =
(OpenLogicalChannelAck_reverseLogicalChannelParameters_multiplexParameter=
s,=0A=
+	  h2250LogicalChannelParameters), _H2250LogicalChannelParameters},=0A=
+};=0A=
+=0A=
+static field_t _OpenLogicalChannelAck_reverseLogicalChannelParameters[] =
=3D {	/* SEQUENCE */=0A=
+	{FNAME("reverseLogicalChannelNumber") INT, WORD, 1, 0, SKIP, 0, NULL},=0A=
+	{FNAME("portNumber") INT, WORD, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("multiplexParameters") CHOICE, 0, 1, 2, DECODE | EXT | OPT,=0A=
+	 offsetof(OpenLogicalChannelAck_reverseLogicalChannelParameters,=0A=
+		  multiplexParameters),=0A=
+	 =
_OpenLogicalChannelAck_reverseLogicalChannelParameters_multiplexParameter=
s},=0A=
+	{FNAME("replacementFor") INT, WORD, 1, 0, SKIP | OPT, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _H2250LogicalChannelAckParameters_nonStandard[] =3D {	/* =
SEQUENCE OF */=0A=
+	{FNAME("item") SEQ, 0, 2, 2, SKIP, 0, _H245_NonStandardParameter},=0A=
+};=0A=
+=0A=
+static field_t _H2250LogicalChannelAckParameters[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("nonStandard") SEQOF, SEMI, 0, 0, SKIP | OPT, 0,=0A=
+	 _H2250LogicalChannelAckParameters_nonStandard},=0A=
+	{FNAME("sessionID") INT, 8, 1, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("mediaChannel") CHOICE, 1, 2, 2, DECODE | EXT | OPT,=0A=
+	 offsetof(H2250LogicalChannelAckParameters, mediaChannel),=0A=
+	 _H245_TransportAddress},=0A=
+	{FNAME("mediaControlChannel") CHOICE, 1, 2, 2, DECODE | EXT | OPT,=0A=
+	 offsetof(H2250LogicalChannelAckParameters, mediaControlChannel),=0A=
+	 _H245_TransportAddress},=0A=
+	{FNAME("dynamicRTPPayloadType") INT, 5, 96, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("flowControlToZero") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("portNumber") INT, WORD, 0, 0, SKIP | OPT, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _OpenLogicalChannelAck_forwardMultiplexAckParameters[] =
=3D {	/* CHOICE */=0A=
+	{FNAME("h2250LogicalChannelAckParameters") SEQ, 5, 5, 7, DECODE | EXT,=0A=
+	 offsetof(OpenLogicalChannelAck_forwardMultiplexAckParameters,=0A=
+		  h2250LogicalChannelAckParameters),=0A=
+	 _H2250LogicalChannelAckParameters},=0A=
+};=0A=
+=0A=
+static field_t _OpenLogicalChannelAck[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("forwardLogicalChannelNumber") INT, WORD, 1, 0, SKIP, 0, NULL},=0A=
+	{FNAME("reverseLogicalChannelParameters") SEQ, 2, 3, 4,=0A=
+	 DECODE | EXT | OPT, offsetof(OpenLogicalChannelAck,=0A=
+				      reverseLogicalChannelParameters),=0A=
+	 _OpenLogicalChannelAck_reverseLogicalChannelParameters},=0A=
+	{FNAME("separateStack") SEQ, 2, 4, 5, SKIP | EXT | OPT, 0, NULL},=0A=
+	{FNAME("forwardMultiplexAckParameters") CHOICE, 0, 1, 1,=0A=
+	 DECODE | EXT | OPT, offsetof(OpenLogicalChannelAck,=0A=
+				      forwardMultiplexAckParameters),=0A=
+	 _OpenLogicalChannelAck_forwardMultiplexAckParameters},=0A=
+	{FNAME("encryptionSync") SEQ, 2, 4, 4, STOP | EXT | OPT, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _ResponseMessage[] =3D {	/* CHOICE */=0A=
+	{FNAME("nonStandard") SEQ, 0, 1, 1, STOP | EXT, 0, NULL},=0A=
+	{FNAME("masterSlaveDeterminationAck") SEQ, 0, 1, 1, STOP | EXT, 0,=0A=
+	 NULL},=0A=
+	{FNAME("masterSlaveDeterminationReject") SEQ, 0, 1, 1, STOP | EXT, 0,=0A=
+	 NULL},=0A=
+	{FNAME("terminalCapabilitySetAck") SEQ, 0, 1, 1, STOP | EXT, 0, NULL},=0A=
+	{FNAME("terminalCapabilitySetReject") SEQ, 0, 2, 2, STOP | EXT, 0,=0A=
+	 NULL},=0A=
+	{FNAME("openLogicalChannelAck") SEQ, 1, 2, 5, DECODE | EXT,=0A=
+	 offsetof(ResponseMessage, openLogicalChannelAck),=0A=
+	 _OpenLogicalChannelAck},=0A=
+	{FNAME("openLogicalChannelReject") SEQ, 0, 2, 2, STOP | EXT, 0, NULL},=0A=
+	{FNAME("closeLogicalChannelAck") SEQ, 0, 1, 1, STOP | EXT, 0, NULL},=0A=
+	{FNAME("requestChannelCloseAck") SEQ, 0, 1, 1, STOP | EXT, 0, NULL},=0A=
+	{FNAME("requestChannelCloseReject") SEQ, 0, 2, 2, STOP | EXT, 0,=0A=
+	 NULL},=0A=
+	{FNAME("multiplexEntrySendAck") SEQ, 0, 2, 2, STOP | EXT, 0, NULL},=0A=
+	{FNAME("multiplexEntrySendReject") SEQ, 0, 2, 2, STOP | EXT, 0, NULL},=0A=
+	{FNAME("requestMultiplexEntryAck") SEQ, 0, 1, 1, STOP | EXT, 0, NULL},=0A=
+	{FNAME("requestMultiplexEntryReject") SEQ, 0, 2, 2, STOP | EXT, 0,=0A=
+	 NULL},=0A=
+	{FNAME("requestModeAck") SEQ, 0, 2, 2, STOP | EXT, 0, NULL},=0A=
+	{FNAME("requestModeReject") SEQ, 0, 2, 2, STOP | EXT, 0, NULL},=0A=
+	{FNAME("roundTripDelayResponse") SEQ, 0, 1, 1, STOP | EXT, 0, NULL},=0A=
+	{FNAME("maintenanceLoopAck") SEQ, 0, 1, 1, STOP | EXT, 0, NULL},=0A=
+	{FNAME("maintenanceLoopReject") SEQ, 0, 2, 2, STOP | EXT, 0, NULL},=0A=
+	{FNAME("communicationModeResponse") CHOICE, 0, 1, 1, STOP | EXT, 0,=0A=
+	 NULL},=0A=
+	{FNAME("conferenceResponse") CHOICE, 3, 8, 16, STOP | EXT, 0, NULL},=0A=
+	{FNAME("multilinkResponse") CHOICE, 3, 5, 5, STOP | EXT, 0, NULL},=0A=
+	{FNAME("logicalChannelRateAcknowledge") SEQ, 0, 3, 3, STOP | EXT, 0,=0A=
+	 NULL},=0A=
+	{FNAME("logicalChannelRateReject") SEQ, 1, 4, 4, STOP | EXT, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _MultimediaSystemControlMessage[] =3D {	/* CHOICE */=0A=
+	{FNAME("request") CHOICE, 4, 11, 15, DECODE | EXT,=0A=
+	 offsetof(MultimediaSystemControlMessage, request), _RequestMessage},=0A=
+	{FNAME("response") CHOICE, 5, 19, 24, DECODE | EXT,=0A=
+	 offsetof(MultimediaSystemControlMessage, response),=0A=
+	 _ResponseMessage},=0A=
+	{FNAME("command") CHOICE, 3, 7, 12, STOP | EXT, 0, NULL},=0A=
+	{FNAME("indication") CHOICE, 4, 14, 23, STOP | EXT, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _H323_UU_PDU_h245Control[] =3D {	/* SEQUENCE OF */=0A=
+	{FNAME("item") CHOICE, 2, 4, 4, DECODE | OPEN | EXT,=0A=
+	 sizeof(MultimediaSystemControlMessage),=0A=
+	 _MultimediaSystemControlMessage}=0A=
+	,=0A=
+};=0A=
+=0A=
+static field_t _H323_UU_PDU[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("h323-message-body") CHOICE, 3, 7, 13, DECODE | EXT,=0A=
+	 offsetof(H323_UU_PDU, h323_message_body),=0A=
+	 _H323_UU_PDU_h323_message_body},=0A=
+	{FNAME("nonStandardData") SEQ, 0, 2, 2, SKIP | OPT, 0,=0A=
+	 _NonStandardParameter},=0A=
+	{FNAME("h4501SupplementaryService") SEQOF, SEMI, 0, 0, SKIP | OPT, 0,=0A=
+	 NULL},=0A=
+	{FNAME("h245Tunneling") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("h245Control") SEQOF, SEMI, 0, 4, DECODE | OPT,=0A=
+	 offsetof(H323_UU_PDU, h245Control), _H323_UU_PDU_h245Control},=0A=
+	{FNAME("nonStandardControl") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("callLinkage") SEQ, 2, 2, 2, STOP | EXT | OPT, 0, NULL},=0A=
+	{FNAME("tunnelledSignallingMessage") SEQ, 2, 4, 4, STOP | EXT | OPT,=0A=
+	 0, NULL},=0A=
+	{FNAME("provisionalRespToH245Tunneling") NUL, FIXD, 0, 0, STOP | OPT,=0A=
+	 0, NULL},=0A=
+	{FNAME("stimulusControl") SEQ, 3, 3, 3, STOP | EXT | OPT, 0, NULL},=0A=
+	{FNAME("genericData") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _H323_UserInformation[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("h323-uu-pdu") SEQ, 1, 2, 11, DECODE | EXT,=0A=
+	 offsetof(H323_UserInformation, h323_uu_pdu), _H323_UU_PDU},=0A=
+	{FNAME("user-data") SEQ, 0, 2, 2, STOP | EXT | OPT, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _GatekeeperRequest[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("requestSeqNum") INT, WORD, 1, 0, SKIP, 0, NULL},=0A=
+	{FNAME("protocolIdentifier") OID, BYTE, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("nonStandardData") SEQ, 0, 2, 2, SKIP | OPT, 0,=0A=
+	 _NonStandardParameter},=0A=
+	{FNAME("rasAddress") CHOICE, 3, 7, 7, DECODE | EXT,=0A=
+	 offsetof(GatekeeperRequest, rasAddress), _TransportAddress},=0A=
+	{FNAME("endpointType") SEQ, 6, 8, 10, STOP | EXT, 0, NULL},=0A=
+	{FNAME("gatekeeperIdentifier") BMPSTR, 7, 1, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("callServices") SEQ, 0, 8, 8, STOP | EXT | OPT, 0, NULL},=0A=
+	{FNAME("endpointAlias") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("alternateEndpoints") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("tokens") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("cryptoTokens") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("authenticationCapability") SEQOF, SEMI, 0, 0, STOP | OPT, 0,=0A=
+	 NULL},=0A=
+	{FNAME("algorithmOIDs") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("integrity") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("integrityCheckValue") SEQ, 0, 2, 2, STOP | OPT, 0, NULL},=0A=
+	{FNAME("supportsAltGK") NUL, FIXD, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("featureSet") SEQ, 3, 4, 4, STOP | EXT | OPT, 0, NULL},=0A=
+	{FNAME("genericData") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _GatekeeperConfirm[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("requestSeqNum") INT, WORD, 1, 0, SKIP, 0, NULL},=0A=
+	{FNAME("protocolIdentifier") OID, BYTE, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("nonStandardData") SEQ, 0, 2, 2, SKIP | OPT, 0,=0A=
+	 _NonStandardParameter},=0A=
+	{FNAME("gatekeeperIdentifier") BMPSTR, 7, 1, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("rasAddress") CHOICE, 3, 7, 7, DECODE | EXT,=0A=
+	 offsetof(GatekeeperConfirm, rasAddress), _TransportAddress},=0A=
+	{FNAME("alternateGatekeeper") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("authenticationMode") CHOICE, 3, 7, 8, STOP | EXT | OPT, 0,=0A=
+	 NULL},=0A=
+	{FNAME("tokens") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("cryptoTokens") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("algorithmOID") OID, BYTE, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("integrity") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("integrityCheckValue") SEQ, 0, 2, 2, STOP | OPT, 0, NULL},=0A=
+	{FNAME("featureSet") SEQ, 3, 4, 4, STOP | EXT | OPT, 0, NULL},=0A=
+	{FNAME("genericData") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _RegistrationRequest_callSignalAddress[] =3D {	/* =
SEQUENCE OF */=0A=
+	{FNAME("item") CHOICE, 3, 7, 7, DECODE | EXT,=0A=
+	 sizeof(TransportAddress), _TransportAddress}=0A=
+	,=0A=
+};=0A=
+=0A=
+static field_t _RegistrationRequest_rasAddress[] =3D {	/* SEQUENCE OF */=0A=
+	{FNAME("item") CHOICE, 3, 7, 7, DECODE | EXT,=0A=
+	 sizeof(TransportAddress), _TransportAddress}=0A=
+	,=0A=
+};=0A=
+=0A=
+static field_t _RegistrationRequest_terminalAlias[] =3D {	/* SEQUENCE =
OF */=0A=
+	{FNAME("item") CHOICE, 1, 2, 7, SKIP | EXT, 0, _AliasAddress},=0A=
+};=0A=
+=0A=
+static field_t _RegistrationRequest[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("requestSeqNum") INT, WORD, 1, 0, SKIP, 0, NULL},=0A=
+	{FNAME("protocolIdentifier") OID, BYTE, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("nonStandardData") SEQ, 0, 2, 2, SKIP | OPT, 0,=0A=
+	 _NonStandardParameter},=0A=
+	{FNAME("discoveryComplete") BOOL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("callSignalAddress") SEQOF, SEMI, 0, 10, DECODE,=0A=
+	 offsetof(RegistrationRequest, callSignalAddress),=0A=
+	 _RegistrationRequest_callSignalAddress},=0A=
+	{FNAME("rasAddress") SEQOF, SEMI, 0, 10, DECODE,=0A=
+	 offsetof(RegistrationRequest, rasAddress),=0A=
+	 _RegistrationRequest_rasAddress},=0A=
+	{FNAME("terminalType") SEQ, 6, 8, 10, SKIP | EXT, 0, _EndpointType},=0A=
+	{FNAME("terminalAlias") SEQOF, SEMI, 0, 0, SKIP | OPT, 0,=0A=
+	 _RegistrationRequest_terminalAlias},=0A=
+	{FNAME("gatekeeperIdentifier") BMPSTR, 7, 1, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("endpointVendor") SEQ, 2, 3, 3, SKIP | EXT, 0,=0A=
+	 _VendorIdentifier},=0A=
+	{FNAME("alternateEndpoints") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("timeToLive") INT, CONS, 1, 0, DECODE | OPT,=0A=
+	 offsetof(RegistrationRequest, timeToLive), NULL},=0A=
+	{FNAME("tokens") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("cryptoTokens") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("integrityCheckValue") SEQ, 0, 2, 2, STOP | OPT, 0, NULL},=0A=
+	{FNAME("keepAlive") BOOL, FIXD, 0, 0, STOP, 0, NULL},=0A=
+	{FNAME("endpointIdentifier") BMPSTR, 7, 1, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("willSupplyUUIEs") BOOL, FIXD, 0, 0, STOP, 0, NULL},=0A=
+	{FNAME("maintainConnection") BOOL, FIXD, 0, 0, STOP, 0, NULL},=0A=
+	{FNAME("alternateTransportAddresses") SEQ, 1, 1, 1, STOP | EXT | OPT,=0A=
+	 0, NULL},=0A=
+	{FNAME("additiveRegistration") NUL, FIXD, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("terminalAliasPattern") SEQOF, SEMI, 0, 0, STOP | OPT, 0,=0A=
+	 NULL},=0A=
+	{FNAME("supportsAltGK") NUL, FIXD, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("usageReportingCapability") SEQ, 3, 4, 4, STOP | EXT | OPT, 0,=0A=
+	 NULL},=0A=
+	{FNAME("multipleCalls") BOOL, FIXD, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("supportedH248Packages") SEQOF, SEMI, 0, 0, STOP | OPT, 0,=0A=
+	 NULL},=0A=
+	{FNAME("callCreditCapability") SEQ, 2, 2, 2, STOP | EXT | OPT, 0,=0A=
+	 NULL},=0A=
+	{FNAME("capacityReportingCapability") SEQ, 0, 1, 1, STOP | EXT | OPT,=0A=
+	 0, NULL},=0A=
+	{FNAME("capacity") SEQ, 2, 2, 2, STOP | EXT | OPT, 0, NULL},=0A=
+	{FNAME("featureSet") SEQ, 3, 4, 4, STOP | EXT | OPT, 0, NULL},=0A=
+	{FNAME("genericData") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _RegistrationConfirm_callSignalAddress[] =3D {	/* =
SEQUENCE OF */=0A=
+	{FNAME("item") CHOICE, 3, 7, 7, DECODE | EXT,=0A=
+	 sizeof(TransportAddress), _TransportAddress}=0A=
+	,=0A=
+};=0A=
+=0A=
+static field_t _RegistrationConfirm_terminalAlias[] =3D {	/* SEQUENCE =
OF */=0A=
+	{FNAME("item") CHOICE, 1, 2, 7, SKIP | EXT, 0, _AliasAddress},=0A=
+};=0A=
+=0A=
+static field_t _RegistrationConfirm[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("requestSeqNum") INT, WORD, 1, 0, SKIP, 0, NULL},=0A=
+	{FNAME("protocolIdentifier") OID, BYTE, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("nonStandardData") SEQ, 0, 2, 2, SKIP | OPT, 0,=0A=
+	 _NonStandardParameter},=0A=
+	{FNAME("callSignalAddress") SEQOF, SEMI, 0, 10, DECODE,=0A=
+	 offsetof(RegistrationConfirm, callSignalAddress),=0A=
+	 _RegistrationConfirm_callSignalAddress},=0A=
+	{FNAME("terminalAlias") SEQOF, SEMI, 0, 0, SKIP | OPT, 0,=0A=
+	 _RegistrationConfirm_terminalAlias},=0A=
+	{FNAME("gatekeeperIdentifier") BMPSTR, 7, 1, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("endpointIdentifier") BMPSTR, 7, 1, 0, SKIP, 0, NULL},=0A=
+	{FNAME("alternateGatekeeper") SEQOF, SEMI, 0, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("timeToLive") INT, CONS, 1, 0, DECODE | OPT,=0A=
+	 offsetof(RegistrationConfirm, timeToLive), NULL},=0A=
+	{FNAME("tokens") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("cryptoTokens") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("integrityCheckValue") SEQ, 0, 2, 2, STOP | OPT, 0, NULL},=0A=
+	{FNAME("willRespondToIRR") BOOL, FIXD, 0, 0, STOP, 0, NULL},=0A=
+	{FNAME("preGrantedARQ") SEQ, 0, 4, 8, STOP | EXT | OPT, 0, NULL},=0A=
+	{FNAME("maintainConnection") BOOL, FIXD, 0, 0, STOP, 0, NULL},=0A=
+	{FNAME("serviceControl") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("supportsAdditiveRegistration") NUL, FIXD, 0, 0, STOP | OPT, 0,=0A=
+	 NULL},=0A=
+	{FNAME("terminalAliasPattern") SEQOF, SEMI, 0, 0, STOP | OPT, 0,=0A=
+	 NULL},=0A=
+	{FNAME("supportedPrefixes") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("usageSpec") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("featureServerAlias") CHOICE, 1, 2, 7, STOP | EXT | OPT, 0,=0A=
+	 NULL},=0A=
+	{FNAME("capacityReportingSpec") SEQ, 0, 1, 1, STOP | EXT | OPT, 0,=0A=
+	 NULL},=0A=
+	{FNAME("featureSet") SEQ, 3, 4, 4, STOP | EXT | OPT, 0, NULL},=0A=
+	{FNAME("genericData") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _UnregistrationRequest_callSignalAddress[] =3D {	/* =
SEQUENCE OF */=0A=
+	{FNAME("item") CHOICE, 3, 7, 7, DECODE | EXT,=0A=
+	 sizeof(TransportAddress), _TransportAddress}=0A=
+	,=0A=
+};=0A=
+=0A=
+static field_t _UnregistrationRequest[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("requestSeqNum") INT, WORD, 1, 0, SKIP, 0, NULL},=0A=
+	{FNAME("callSignalAddress") SEQOF, SEMI, 0, 10, DECODE,=0A=
+	 offsetof(UnregistrationRequest, callSignalAddress),=0A=
+	 _UnregistrationRequest_callSignalAddress},=0A=
+	{FNAME("endpointAlias") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("nonStandardData") SEQ, 0, 2, 2, STOP | OPT, 0, NULL},=0A=
+	{FNAME("endpointIdentifier") BMPSTR, 7, 1, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("alternateEndpoints") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("gatekeeperIdentifier") BMPSTR, 7, 1, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("tokens") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("cryptoTokens") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("integrityCheckValue") SEQ, 0, 2, 2, STOP | OPT, 0, NULL},=0A=
+	{FNAME("reason") CHOICE, 2, 4, 5, STOP | EXT | OPT, 0, NULL},=0A=
+	{FNAME("endpointAliasPattern") SEQOF, SEMI, 0, 0, STOP | OPT, 0,=0A=
+	 NULL},=0A=
+	{FNAME("supportedPrefixes") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("alternateGatekeeper") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("genericData") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _CallModel[] =3D {	/* CHOICE */=0A=
+	{FNAME("direct") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("gatekeeperRouted") NUL, FIXD, 0, 0, SKIP, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _AdmissionRequest_destinationInfo[] =3D {	/* SEQUENCE OF =
*/=0A=
+	{FNAME("item") CHOICE, 1, 2, 7, SKIP | EXT, 0, _AliasAddress},=0A=
+};=0A=
+=0A=
+static field_t _AdmissionRequest_destExtraCallInfo[] =3D {	/* SEQUENCE =
OF */=0A=
+	{FNAME("item") CHOICE, 1, 2, 7, SKIP | EXT, 0, _AliasAddress},=0A=
+};=0A=
+=0A=
+static field_t _AdmissionRequest_srcInfo[] =3D {	/* SEQUENCE OF */=0A=
+	{FNAME("item") CHOICE, 1, 2, 7, SKIP | EXT, 0, _AliasAddress},=0A=
+};=0A=
+=0A=
+static field_t _AdmissionRequest[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("requestSeqNum") INT, WORD, 1, 0, SKIP, 0, NULL},=0A=
+	{FNAME("callType") CHOICE, 2, 4, 4, SKIP | EXT, 0, _CallType},=0A=
+	{FNAME("callModel") CHOICE, 1, 2, 2, SKIP | EXT | OPT, 0, _CallModel},=0A=
+	{FNAME("endpointIdentifier") BMPSTR, 7, 1, 0, SKIP, 0, NULL},=0A=
+	{FNAME("destinationInfo") SEQOF, SEMI, 0, 0, SKIP | OPT, 0,=0A=
+	 _AdmissionRequest_destinationInfo},=0A=
+	{FNAME("destCallSignalAddress") CHOICE, 3, 7, 7, DECODE | EXT | OPT,=0A=
+	 offsetof(AdmissionRequest, destCallSignalAddress),=0A=
+	 _TransportAddress},=0A=
+	{FNAME("destExtraCallInfo") SEQOF, SEMI, 0, 0, SKIP | OPT, 0,=0A=
+	 _AdmissionRequest_destExtraCallInfo},=0A=
+	{FNAME("srcInfo") SEQOF, SEMI, 0, 0, SKIP, 0,=0A=
+	 _AdmissionRequest_srcInfo},=0A=
+	{FNAME("srcCallSignalAddress") CHOICE, 3, 7, 7, DECODE | EXT | OPT,=0A=
+	 offsetof(AdmissionRequest, srcCallSignalAddress), _TransportAddress},=0A=
+	{FNAME("bandWidth") INT, CONS, 0, 0, STOP, 0, NULL},=0A=
+	{FNAME("callReferenceValue") INT, WORD, 0, 0, STOP, 0, NULL},=0A=
+	{FNAME("nonStandardData") SEQ, 0, 2, 2, STOP | OPT, 0, NULL},=0A=
+	{FNAME("callServices") SEQ, 0, 8, 8, STOP | EXT | OPT, 0, NULL},=0A=
+	{FNAME("conferenceID") OCTSTR, FIXD, 16, 0, STOP, 0, NULL},=0A=
+	{FNAME("activeMC") BOOL, FIXD, 0, 0, STOP, 0, NULL},=0A=
+	{FNAME("answerCall") BOOL, FIXD, 0, 0, STOP, 0, NULL},=0A=
+	{FNAME("canMapAlias") BOOL, FIXD, 0, 0, STOP, 0, NULL},=0A=
+	{FNAME("callIdentifier") SEQ, 0, 1, 1, STOP | EXT, 0, NULL},=0A=
+	{FNAME("srcAlternatives") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("destAlternatives") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("gatekeeperIdentifier") BMPSTR, 7, 1, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("tokens") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("cryptoTokens") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("integrityCheckValue") SEQ, 0, 2, 2, STOP | OPT, 0, NULL},=0A=
+	{FNAME("transportQOS") CHOICE, 2, 3, 3, STOP | EXT | OPT, 0, NULL},=0A=
+	{FNAME("willSupplyUUIEs") BOOL, FIXD, 0, 0, STOP, 0, NULL},=0A=
+	{FNAME("callLinkage") SEQ, 2, 2, 2, STOP | EXT | OPT, 0, NULL},=0A=
+	{FNAME("gatewayDataRate") SEQ, 2, 3, 3, STOP | EXT | OPT, 0, NULL},=0A=
+	{FNAME("capacity") SEQ, 2, 2, 2, STOP | EXT | OPT, 0, NULL},=0A=
+	{FNAME("circuitInfo") SEQ, 3, 3, 3, STOP | EXT | OPT, 0, NULL},=0A=
+	{FNAME("desiredProtocols") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("desiredTunnelledProtocol") SEQ, 1, 2, 2, STOP | EXT | OPT, 0,=0A=
+	 NULL},=0A=
+	{FNAME("featureSet") SEQ, 3, 4, 4, STOP | EXT | OPT, 0, NULL},=0A=
+	{FNAME("genericData") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _AdmissionConfirm[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("requestSeqNum") INT, WORD, 1, 0, SKIP, 0, NULL},=0A=
+	{FNAME("bandWidth") INT, CONS, 0, 0, SKIP, 0, NULL},=0A=
+	{FNAME("callModel") CHOICE, 1, 2, 2, SKIP | EXT, 0, _CallModel},=0A=
+	{FNAME("destCallSignalAddress") CHOICE, 3, 7, 7, DECODE | EXT,=0A=
+	 offsetof(AdmissionConfirm, destCallSignalAddress),=0A=
+	 _TransportAddress},=0A=
+	{FNAME("irrFrequency") INT, WORD, 1, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("nonStandardData") SEQ, 0, 2, 2, STOP | OPT, 0, NULL},=0A=
+	{FNAME("destinationInfo") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("destExtraCallInfo") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("destinationType") SEQ, 6, 8, 10, STOP | EXT | OPT, 0, NULL},=0A=
+	{FNAME("remoteExtensionAddress") SEQOF, SEMI, 0, 0, STOP | OPT, 0,=0A=
+	 NULL},=0A=
+	{FNAME("alternateEndpoints") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("tokens") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("cryptoTokens") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("integrityCheckValue") SEQ, 0, 2, 2, STOP | OPT, 0, NULL},=0A=
+	{FNAME("transportQOS") CHOICE, 2, 3, 3, STOP | EXT | OPT, 0, NULL},=0A=
+	{FNAME("willRespondToIRR") BOOL, FIXD, 0, 0, STOP, 0, NULL},=0A=
+	{FNAME("uuiesRequested") SEQ, 0, 9, 13, STOP | EXT, 0, NULL},=0A=
+	{FNAME("language") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("alternateTransportAddresses") SEQ, 1, 1, 1, STOP | EXT | OPT,=0A=
+	 0, NULL},=0A=
+	{FNAME("useSpecifiedTransport") CHOICE, 1, 2, 2, STOP | EXT | OPT, 0,=0A=
+	 NULL},=0A=
+	{FNAME("circuitInfo") SEQ, 3, 3, 3, STOP | EXT | OPT, 0, NULL},=0A=
+	{FNAME("usageSpec") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("supportedProtocols") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("serviceControl") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("multipleCalls") BOOL, FIXD, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("featureSet") SEQ, 3, 4, 4, STOP | EXT | OPT, 0, NULL},=0A=
+	{FNAME("genericData") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _LocationRequest_destinationInfo[] =3D {	/* SEQUENCE OF =
*/=0A=
+	{FNAME("item") CHOICE, 1, 2, 7, SKIP | EXT, 0, _AliasAddress},=0A=
+};=0A=
+=0A=
+static field_t _LocationRequest[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("requestSeqNum") INT, WORD, 1, 0, SKIP, 0, NULL},=0A=
+	{FNAME("endpointIdentifier") BMPSTR, 7, 1, 0, SKIP | OPT, 0, NULL},=0A=
+	{FNAME("destinationInfo") SEQOF, SEMI, 0, 0, SKIP, 0,=0A=
+	 _LocationRequest_destinationInfo},=0A=
+	{FNAME("nonStandardData") SEQ, 0, 2, 2, SKIP | OPT, 0,=0A=
+	 _NonStandardParameter},=0A=
+	{FNAME("replyAddress") CHOICE, 3, 7, 7, DECODE | EXT,=0A=
+	 offsetof(LocationRequest, replyAddress), _TransportAddress},=0A=
+	{FNAME("sourceInfo") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("canMapAlias") BOOL, FIXD, 0, 0, STOP, 0, NULL},=0A=
+	{FNAME("gatekeeperIdentifier") BMPSTR, 7, 1, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("tokens") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("cryptoTokens") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("integrityCheckValue") SEQ, 0, 2, 2, STOP | OPT, 0, NULL},=0A=
+	{FNAME("desiredProtocols") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("desiredTunnelledProtocol") SEQ, 1, 2, 2, STOP | EXT | OPT, 0,=0A=
+	 NULL},=0A=
+	{FNAME("featureSet") SEQ, 3, 4, 4, STOP | EXT | OPT, 0, NULL},=0A=
+	{FNAME("genericData") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("hopCount") INT, 8, 1, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("circuitInfo") SEQ, 3, 3, 3, STOP | EXT | OPT, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _LocationConfirm[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("requestSeqNum") INT, WORD, 1, 0, SKIP, 0, NULL},=0A=
+	{FNAME("callSignalAddress") CHOICE, 3, 7, 7, DECODE | EXT,=0A=
+	 offsetof(LocationConfirm, callSignalAddress), _TransportAddress},=0A=
+	{FNAME("rasAddress") CHOICE, 3, 7, 7, DECODE | EXT,=0A=
+	 offsetof(LocationConfirm, rasAddress), _TransportAddress},=0A=
+	{FNAME("nonStandardData") SEQ, 0, 2, 2, STOP | OPT, 0, NULL},=0A=
+	{FNAME("destinationInfo") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("destExtraCallInfo") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("destinationType") SEQ, 6, 8, 10, STOP | EXT | OPT, 0, NULL},=0A=
+	{FNAME("remoteExtensionAddress") SEQOF, SEMI, 0, 0, STOP | OPT, 0,=0A=
+	 NULL},=0A=
+	{FNAME("alternateEndpoints") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("tokens") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("cryptoTokens") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("integrityCheckValue") SEQ, 0, 2, 2, STOP | OPT, 0, NULL},=0A=
+	{FNAME("alternateTransportAddresses") SEQ, 1, 1, 1, STOP | EXT | OPT,=0A=
+	 0, NULL},=0A=
+	{FNAME("supportedProtocols") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("multipleCalls") BOOL, FIXD, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("featureSet") SEQ, 3, 4, 4, STOP | EXT | OPT, 0, NULL},=0A=
+	{FNAME("genericData") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("circuitInfo") SEQ, 3, 3, 3, STOP | EXT | OPT, 0, NULL},=0A=
+	{FNAME("serviceControl") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _InfoRequestResponse_callSignalAddress[] =3D {	/* =
SEQUENCE OF */=0A=
+	{FNAME("item") CHOICE, 3, 7, 7, DECODE | EXT,=0A=
+	 sizeof(TransportAddress), _TransportAddress}=0A=
+	,=0A=
+};=0A=
+=0A=
+static field_t _InfoRequestResponse[] =3D {	/* SEQUENCE */=0A=
+	{FNAME("nonStandardData") SEQ, 0, 2, 2, SKIP | OPT, 0,=0A=
+	 _NonStandardParameter},=0A=
+	{FNAME("requestSeqNum") INT, WORD, 1, 0, SKIP, 0, NULL},=0A=
+	{FNAME("endpointType") SEQ, 6, 8, 10, SKIP | EXT, 0, _EndpointType},=0A=
+	{FNAME("endpointIdentifier") BMPSTR, 7, 1, 0, SKIP, 0, NULL},=0A=
+	{FNAME("rasAddress") CHOICE, 3, 7, 7, DECODE | EXT,=0A=
+	 offsetof(InfoRequestResponse, rasAddress), _TransportAddress},=0A=
+	{FNAME("callSignalAddress") SEQOF, SEMI, 0, 10, DECODE,=0A=
+	 offsetof(InfoRequestResponse, callSignalAddress),=0A=
+	 _InfoRequestResponse_callSignalAddress},=0A=
+	{FNAME("endpointAlias") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("perCallInfo") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("tokens") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("cryptoTokens") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+	{FNAME("integrityCheckValue") SEQ, 0, 2, 2, STOP | OPT, 0, NULL},=0A=
+	{FNAME("needResponse") BOOL, FIXD, 0, 0, STOP, 0, NULL},=0A=
+	{FNAME("capacity") SEQ, 2, 2, 2, STOP | EXT | OPT, 0, NULL},=0A=
+	{FNAME("irrStatus") CHOICE, 2, 4, 4, STOP | EXT | OPT, 0, NULL},=0A=
+	{FNAME("unsolicited") BOOL, FIXD, 0, 0, STOP, 0, NULL},=0A=
+	{FNAME("genericData") SEQOF, SEMI, 0, 0, STOP | OPT, 0, NULL},=0A=
+};=0A=
+=0A=
+static field_t _RasMessage[] =3D {	/* CHOICE */=0A=
+	{FNAME("gatekeeperRequest") SEQ, 4, 8, 18, DECODE | EXT,=0A=
+	 offsetof(RasMessage, gatekeeperRequest), _GatekeeperRequest},=0A=
+	{FNAME("gatekeeperConfirm") SEQ, 2, 5, 14, DECODE | EXT,=0A=
+	 offsetof(RasMessage, gatekeeperConfirm), _GatekeeperConfirm},=0A=
+	{FNAME("gatekeeperReject") SEQ, 2, 5, 11, STOP | EXT, 0, NULL},=0A=
+	{FNAME("registrationRequest") SEQ, 3, 10, 31, DECODE | EXT,=0A=
+	 offsetof(RasMessage, registrationRequest), _RegistrationRequest},=0A=
+	{FNAME("registrationConfirm") SEQ, 3, 7, 24, DECODE | EXT,=0A=
+	 offsetof(RasMessage, registrationConfirm), _RegistrationConfirm},=0A=
+	{FNAME("registrationReject") SEQ, 2, 5, 11, STOP | EXT, 0, NULL},=0A=
+	{FNAME("unregistrationRequest") SEQ, 3, 5, 15, DECODE | EXT,=0A=
+	 offsetof(RasMessage, unregistrationRequest), _UnregistrationRequest},=0A=
+	{FNAME("unregistrationConfirm") SEQ, 1, 2, 6, STOP | EXT, 0, NULL},=0A=
+	{FNAME("unregistrationReject") SEQ, 1, 3, 8, STOP | EXT, 0, NULL},=0A=
+	{FNAME("admissionRequest") SEQ, 7, 16, 34, DECODE | EXT,=0A=
+	 offsetof(RasMessage, admissionRequest), _AdmissionRequest},=0A=
+	{FNAME("admissionConfirm") SEQ, 2, 6, 27, DECODE | EXT,=0A=
+	 offsetof(RasMessage, admissionConfirm), _AdmissionConfirm},=0A=
+	{FNAME("admissionReject") SEQ, 1, 3, 11, STOP | EXT, 0, NULL},=0A=
+	{FNAME("bandwidthRequest") SEQ, 2, 7, 18, STOP | EXT, 0, NULL},=0A=
+	{FNAME("bandwidthConfirm") SEQ, 1, 3, 8, STOP | EXT, 0, NULL},=0A=
+	{FNAME("bandwidthReject") SEQ, 1, 4, 9, STOP | EXT, 0, NULL},=0A=
+	{FNAME("disengageRequest") SEQ, 1, 6, 19, STOP | EXT, 0, NULL},=0A=
+	{FNAME("disengageConfirm") SEQ, 1, 2, 9, STOP | EXT, 0, NULL},=0A=
+	{FNAME("disengageReject") SEQ, 1, 3, 8, STOP | EXT, 0, NULL},=0A=
+	{FNAME("locationRequest") SEQ, 2, 5, 17, DECODE | EXT,=0A=
+	 offsetof(RasMessage, locationRequest), _LocationRequest},=0A=
+	{FNAME("locationConfirm") SEQ, 1, 4, 19, DECODE | EXT,=0A=
+	 offsetof(RasMessage, locationConfirm), _LocationConfirm},=0A=
+	{FNAME("locationReject") SEQ, 1, 3, 10, STOP | EXT, 0, NULL},=0A=
+	{FNAME("infoRequest") SEQ, 2, 4, 15, STOP | EXT, 0, NULL},=0A=
+	{FNAME("infoRequestResponse") SEQ, 3, 8, 16, DECODE | EXT,=0A=
+	 offsetof(RasMessage, infoRequestResponse), _InfoRequestResponse},=0A=
+	{FNAME("nonStandardMessage") SEQ, 0, 2, 7, STOP | EXT, 0, NULL},=0A=
+	{FNAME("unknownMessageResponse") SEQ, 0, 1, 5, STOP | EXT, 0, NULL},=0A=
+	{FNAME("requestInProgress") SEQ, 4, 6, 6, STOP | EXT, 0, NULL},=0A=
+	{FNAME("resourcesAvailableIndicate") SEQ, 4, 9, 11, STOP | EXT, 0,=0A=
+	 NULL},=0A=
+	{FNAME("resourcesAvailableConfirm") SEQ, 4, 6, 7, STOP | EXT, 0,=0A=
+	 NULL},=0A=
+	{FNAME("infoRequestAck") SEQ, 4, 5, 5, STOP | EXT, 0, NULL},=0A=
+	{FNAME("infoRequestNak") SEQ, 5, 7, 7, STOP | EXT, 0, NULL},=0A=
+	{FNAME("serviceControlIndication") SEQ, 8, 10, 10, STOP | EXT, 0,=0A=
+	 NULL},=0A=
+	{FNAME("serviceControlResponse") SEQ, 7, 8, 8, STOP | EXT, 0, NULL},=0A=
+};=0A=
diff -pruN =
linux-2.6.15.orig/net/ipv4/netfilter/ip_conntrack_helper_h323_types.h =
linux-2.6.15/net/ipv4/netfilter/ip_conntrack_helper_h323_types.h=0A=
--- =
linux-2.6.15.orig/net/ipv4/netfilter/ip_conntrack_helper_h323_types.h	=
1969-12-31 19:00:00.000000000 -0500=0A=
+++ linux-2.6.15/net/ipv4/netfilter/ip_conntrack_helper_h323_types.h	=
2006-03-15 19:34:01.000000000 -0500=0A=
@@ -0,0 +1,938 @@=0A=
+/* Generated by Jing Min Zhao's ASN.1 parser, Mar 15 2006=0A=
+ *=0A=
+ * Copyright (c) 2006 Jing Min Zhao <zhaojingmin@users.sourceforge.net>=0A=
+ *=0A=
+ * This source code is licensed under General Public License version 2.=0A=
+ */=0A=
+=0A=
+typedef struct TransportAddress_ipAddress {	/* SEQUENCE */=0A=
+	int options;		/* No use */=0A=
+	unsigned ip;=0A=
+} TransportAddress_ipAddress;=0A=
+=0A=
+typedef struct TransportAddress {	/* CHOICE */=0A=
+	enum {=0A=
+		eTransportAddress_ipAddress,=0A=
+		eTransportAddress_ipSourceRoute,=0A=
+		eTransportAddress_ipxAddress,=0A=
+		eTransportAddress_ip6Address,=0A=
+		eTransportAddress_netBios,=0A=
+		eTransportAddress_nsap,=0A=
+		eTransportAddress_nonStandardAddress,=0A=
+	} choice;=0A=
+	union {=0A=
+		TransportAddress_ipAddress ipAddress;=0A=
+	};=0A=
+} TransportAddress;=0A=
+=0A=
+typedef struct DataProtocolCapability {	/* CHOICE */=0A=
+	enum {=0A=
+		eDataProtocolCapability_nonStandard,=0A=
+		eDataProtocolCapability_v14buffered,=0A=
+		eDataProtocolCapability_v42lapm,=0A=
+		eDataProtocolCapability_hdlcFrameTunnelling,=0A=
+		eDataProtocolCapability_h310SeparateVCStack,=0A=
+		eDataProtocolCapability_h310SingleVCStack,=0A=
+		eDataProtocolCapability_transparent,=0A=
+		eDataProtocolCapability_segmentationAndReassembly,=0A=
+		eDataProtocolCapability_hdlcFrameTunnelingwSAR,=0A=
+		eDataProtocolCapability_v120,=0A=
+		eDataProtocolCapability_separateLANStack,=0A=
+		eDataProtocolCapability_v76wCompression,=0A=
+		eDataProtocolCapability_tcp,=0A=
+		eDataProtocolCapability_udp,=0A=
+	} choice;=0A=
+} DataProtocolCapability;=0A=
+=0A=
+typedef struct DataApplicationCapability_application {	/* CHOICE */=0A=
+	enum {=0A=
+		eDataApplicationCapability_application_nonStandard,=0A=
+		eDataApplicationCapability_application_t120,=0A=
+		eDataApplicationCapability_application_dsm_cc,=0A=
+		eDataApplicationCapability_application_userData,=0A=
+		eDataApplicationCapability_application_t84,=0A=
+		eDataApplicationCapability_application_t434,=0A=
+		eDataApplicationCapability_application_h224,=0A=
+		eDataApplicationCapability_application_nlpid,=0A=
+		eDataApplicationCapability_application_dsvdControl,=0A=
+		eDataApplicationCapability_application_h222DataPartitioning,=0A=
+		eDataApplicationCapability_application_t30fax,=0A=
+		eDataApplicationCapability_application_t140,=0A=
+		eDataApplicationCapability_application_t38fax,=0A=
+		eDataApplicationCapability_application_genericDataCapability,=0A=
+	} choice;=0A=
+	union {=0A=
+		DataProtocolCapability t120;=0A=
+	};=0A=
+} DataApplicationCapability_application;=0A=
+=0A=
+typedef struct DataApplicationCapability {	/* SEQUENCE */=0A=
+	int options;		/* No use */=0A=
+	DataApplicationCapability_application application;=0A=
+} DataApplicationCapability;=0A=
+=0A=
+typedef struct DataType {	/* CHOICE */=0A=
+	enum {=0A=
+		eDataType_nonStandard,=0A=
+		eDataType_nullData,=0A=
+		eDataType_videoData,=0A=
+		eDataType_audioData,=0A=
+		eDataType_data,=0A=
+		eDataType_encryptionData,=0A=
+		eDataType_h235Control,=0A=
+		eDataType_h235Media,=0A=
+		eDataType_multiplexedStream,=0A=
+	} choice;=0A=
+	union {=0A=
+		DataApplicationCapability data;=0A=
+	};=0A=
+} DataType;=0A=
+=0A=
+typedef struct UnicastAddress_iPAddress {	/* SEQUENCE */=0A=
+	int options;		/* No use */=0A=
+	unsigned network;=0A=
+} UnicastAddress_iPAddress;=0A=
+=0A=
+typedef struct UnicastAddress {	/* CHOICE */=0A=
+	enum {=0A=
+		eUnicastAddress_iPAddress,=0A=
+		eUnicastAddress_iPXAddress,=0A=
+		eUnicastAddress_iP6Address,=0A=
+		eUnicastAddress_netBios,=0A=
+		eUnicastAddress_iPSourceRouteAddress,=0A=
+		eUnicastAddress_nsap,=0A=
+		eUnicastAddress_nonStandardAddress,=0A=
+	} choice;=0A=
+	union {=0A=
+		UnicastAddress_iPAddress iPAddress;=0A=
+	};=0A=
+} UnicastAddress;=0A=
+=0A=
+typedef struct H245_TransportAddress {	/* CHOICE */=0A=
+	enum {=0A=
+		eH245_TransportAddress_unicastAddress,=0A=
+		eH245_TransportAddress_multicastAddress,=0A=
+	} choice;=0A=
+	union {=0A=
+		UnicastAddress unicastAddress;=0A=
+	};=0A=
+} H245_TransportAddress;=0A=
+=0A=
+typedef struct H2250LogicalChannelParameters {	/* SEQUENCE */=0A=
+	enum {=0A=
+		eH2250LogicalChannelParameters_nonStandard =3D (1 << 31),=0A=
+		eH2250LogicalChannelParameters_associatedSessionID =3D=0A=
+		    (1 << 30),=0A=
+		eH2250LogicalChannelParameters_mediaChannel =3D (1 << 29),=0A=
+		eH2250LogicalChannelParameters_mediaGuaranteedDelivery =3D=0A=
+		    (1 << 28),=0A=
+		eH2250LogicalChannelParameters_mediaControlChannel =3D=0A=
+		    (1 << 27),=0A=
+		eH2250LogicalChannelParameters_mediaControlGuaranteedDelivery=0A=
+		    =3D (1 << 26),=0A=
+		eH2250LogicalChannelParameters_silenceSuppression =3D (1 << 25),=0A=
+		eH2250LogicalChannelParameters_destination =3D (1 << 24),=0A=
+		eH2250LogicalChannelParameters_dynamicRTPPayloadType =3D=0A=
+		    (1 << 23),=0A=
+		eH2250LogicalChannelParameters_mediaPacketization =3D (1 << 22),=0A=
+		eH2250LogicalChannelParameters_transportCapability =3D=0A=
+		    (1 << 21),=0A=
+		eH2250LogicalChannelParameters_redundancyEncoding =3D (1 << 20),=0A=
+		eH2250LogicalChannelParameters_source =3D (1 << 19),=0A=
+	} options;=0A=
+	H245_TransportAddress mediaChannel;=0A=
+	H245_TransportAddress mediaControlChannel;=0A=
+} H2250LogicalChannelParameters;=0A=
+=0A=
+typedef struct =
OpenLogicalChannel_forwardLogicalChannelParameters_multiplexParameters {	=
/* CHOICE */=0A=
+	enum {=0A=
+		=
eOpenLogicalChannel_forwardLogicalChannelParameters_multiplexParameters_h=
222LogicalChannelParameters,=0A=
+		=
eOpenLogicalChannel_forwardLogicalChannelParameters_multiplexParameters_h=
223LogicalChannelParameters,=0A=
+		=
eOpenLogicalChannel_forwardLogicalChannelParameters_multiplexParameters_v=
76LogicalChannelParameters,=0A=
+		=
eOpenLogicalChannel_forwardLogicalChannelParameters_multiplexParameters_h=
2250LogicalChannelParameters,=0A=
+		=
eOpenLogicalChannel_forwardLogicalChannelParameters_multiplexParameters_n=
one,=0A=
+	} choice;=0A=
+	union {=0A=
+		H2250LogicalChannelParameters h2250LogicalChannelParameters;=0A=
+	};=0A=
+} =
OpenLogicalChannel_forwardLogicalChannelParameters_multiplexParameters;=0A=
+=0A=
+typedef struct OpenLogicalChannel_forwardLogicalChannelParameters {	/* =
SEQUENCE */=0A=
+	enum {=0A=
+		eOpenLogicalChannel_forwardLogicalChannelParameters_portNumber=0A=
+		    =3D (1 << 31),=0A=
+		=
eOpenLogicalChannel_forwardLogicalChannelParameters_forwardLogicalChannel=
Dependency=0A=
+		    =3D (1 << 30),=0A=
+		eOpenLogicalChannel_forwardLogicalChannelParameters_replacementFor=0A=
+		    =3D (1 << 29),=0A=
+	} options;=0A=
+	DataType dataType;=0A=
+	OpenLogicalChannel_forwardLogicalChannelParameters_multiplexParameters=0A=
+	    multiplexParameters;=0A=
+} OpenLogicalChannel_forwardLogicalChannelParameters;=0A=
+=0A=
+typedef struct =
OpenLogicalChannel_reverseLogicalChannelParameters_multiplexParameters {	=
/* CHOICE */=0A=
+	enum {=0A=
+		=
eOpenLogicalChannel_reverseLogicalChannelParameters_multiplexParameters_h=
223LogicalChannelParameters,=0A=
+		=
eOpenLogicalChannel_reverseLogicalChannelParameters_multiplexParameters_v=
76LogicalChannelParameters,=0A=
+		=
eOpenLogicalChannel_reverseLogicalChannelParameters_multiplexParameters_h=
2250LogicalChannelParameters,=0A=
+	} choice;=0A=
+	union {=0A=
+		H2250LogicalChannelParameters h2250LogicalChannelParameters;=0A=
+	};=0A=
+} =
OpenLogicalChannel_reverseLogicalChannelParameters_multiplexParameters;=0A=
+=0A=
+typedef struct OpenLogicalChannel_reverseLogicalChannelParameters {	/* =
SEQUENCE */=0A=
+	enum {=0A=
+		=
eOpenLogicalChannel_reverseLogicalChannelParameters_multiplexParameters=0A=
+		    =3D (1 << 31),=0A=
+		=
eOpenLogicalChannel_reverseLogicalChannelParameters_reverseLogicalChannel=
Dependency=0A=
+		    =3D (1 << 30),=0A=
+		eOpenLogicalChannel_reverseLogicalChannelParameters_replacementFor=0A=
+		    =3D (1 << 29),=0A=
+	} options;=0A=
+	OpenLogicalChannel_reverseLogicalChannelParameters_multiplexParameters=0A=
+	    multiplexParameters;=0A=
+} OpenLogicalChannel_reverseLogicalChannelParameters;=0A=
+=0A=
+typedef struct NetworkAccessParameters_networkAddress {	/* CHOICE */=0A=
+	enum {=0A=
+		eNetworkAccessParameters_networkAddress_q2931Address,=0A=
+		eNetworkAccessParameters_networkAddress_e164Address,=0A=
+		eNetworkAccessParameters_networkAddress_localAreaAddress,=0A=
+	} choice;=0A=
+	union {=0A=
+		H245_TransportAddress localAreaAddress;=0A=
+	};=0A=
+} NetworkAccessParameters_networkAddress;=0A=
+=0A=
+typedef struct NetworkAccessParameters {	/* SEQUENCE */=0A=
+	enum {=0A=
+		eNetworkAccessParameters_distribution =3D (1 << 31),=0A=
+		eNetworkAccessParameters_externalReference =3D (1 << 30),=0A=
+		eNetworkAccessParameters_t120SetupProcedure =3D (1 << 29),=0A=
+	} options;=0A=
+	NetworkAccessParameters_networkAddress networkAddress;=0A=
+} NetworkAccessParameters;=0A=
+=0A=
+typedef struct OpenLogicalChannel {	/* SEQUENCE */=0A=
+	enum {=0A=
+		eOpenLogicalChannel_reverseLogicalChannelParameters =3D=0A=
+		    (1 << 31),=0A=
+		eOpenLogicalChannel_separateStack =3D (1 << 30),=0A=
+		eOpenLogicalChannel_encryptionSync =3D (1 << 29),=0A=
+	} options;=0A=
+	OpenLogicalChannel_forwardLogicalChannelParameters=0A=
+	    forwardLogicalChannelParameters;=0A=
+	OpenLogicalChannel_reverseLogicalChannelParameters=0A=
+	    reverseLogicalChannelParameters;=0A=
+	NetworkAccessParameters separateStack;=0A=
+} OpenLogicalChannel;=0A=
+=0A=
+typedef struct Setup_UUIE_fastStart {	/* SEQUENCE OF */=0A=
+	int count;=0A=
+	OpenLogicalChannel item[30];=0A=
+} Setup_UUIE_fastStart;=0A=
+=0A=
+typedef struct Setup_UUIE {	/* SEQUENCE */=0A=
+	enum {=0A=
+		eSetup_UUIE_h245Address =3D (1 << 31),=0A=
+		eSetup_UUIE_sourceAddress =3D (1 << 30),=0A=
+		eSetup_UUIE_destinationAddress =3D (1 << 29),=0A=
+		eSetup_UUIE_destCallSignalAddress =3D (1 << 28),=0A=
+		eSetup_UUIE_destExtraCallInfo =3D (1 << 27),=0A=
+		eSetup_UUIE_destExtraCRV =3D (1 << 26),=0A=
+		eSetup_UUIE_callServices =3D (1 << 25),=0A=
+		eSetup_UUIE_sourceCallSignalAddress =3D (1 << 24),=0A=
+		eSetup_UUIE_remoteExtensionAddress =3D (1 << 23),=0A=
+		eSetup_UUIE_callIdentifier =3D (1 << 22),=0A=
+		eSetup_UUIE_h245SecurityCapability =3D (1 << 21),=0A=
+		eSetup_UUIE_tokens =3D (1 << 20),=0A=
+		eSetup_UUIE_cryptoTokens =3D (1 << 19),=0A=
+		eSetup_UUIE_fastStart =3D (1 << 18),=0A=
+		eSetup_UUIE_mediaWaitForConnect =3D (1 << 17),=0A=
+		eSetup_UUIE_canOverlapSend =3D (1 << 16),=0A=
+		eSetup_UUIE_endpointIdentifier =3D (1 << 15),=0A=
+		eSetup_UUIE_multipleCalls =3D (1 << 14),=0A=
+		eSetup_UUIE_maintainConnection =3D (1 << 13),=0A=
+		eSetup_UUIE_connectionParameters =3D (1 << 12),=0A=
+		eSetup_UUIE_language =3D (1 << 11),=0A=
+		eSetup_UUIE_presentationIndicator =3D (1 << 10),=0A=
+		eSetup_UUIE_screeningIndicator =3D (1 << 9),=0A=
+		eSetup_UUIE_serviceControl =3D (1 << 8),=0A=
+		eSetup_UUIE_symmetricOperationRequired =3D (1 << 7),=0A=
+		eSetup_UUIE_capacity =3D (1 << 6),=0A=
+		eSetup_UUIE_circuitInfo =3D (1 << 5),=0A=
+		eSetup_UUIE_desiredProtocols =3D (1 << 4),=0A=
+		eSetup_UUIE_neededFeatures =3D (1 << 3),=0A=
+		eSetup_UUIE_desiredFeatures =3D (1 << 2),=0A=
+		eSetup_UUIE_supportedFeatures =3D (1 << 1),=0A=
+		eSetup_UUIE_parallelH245Control =3D (1 << 0),=0A=
+	} options;=0A=
+	TransportAddress h245Address;=0A=
+	TransportAddress destCallSignalAddress;=0A=
+	TransportAddress sourceCallSignalAddress;=0A=
+	Setup_UUIE_fastStart fastStart;=0A=
+} Setup_UUIE;=0A=
+=0A=
+typedef struct CallProceeding_UUIE_fastStart {	/* SEQUENCE OF */=0A=
+	int count;=0A=
+	OpenLogicalChannel item[30];=0A=
+} CallProceeding_UUIE_fastStart;=0A=
+=0A=
+typedef struct CallProceeding_UUIE {	/* SEQUENCE */=0A=
+	enum {=0A=
+		eCallProceeding_UUIE_h245Address =3D (1 << 31),=0A=
+		eCallProceeding_UUIE_callIdentifier =3D (1 << 30),=0A=
+		eCallProceeding_UUIE_h245SecurityMode =3D (1 << 29),=0A=
+		eCallProceeding_UUIE_tokens =3D (1 << 28),=0A=
+		eCallProceeding_UUIE_cryptoTokens =3D (1 << 27),=0A=
+		eCallProceeding_UUIE_fastStart =3D (1 << 26),=0A=
+		eCallProceeding_UUIE_multipleCalls =3D (1 << 25),=0A=
+		eCallProceeding_UUIE_maintainConnection =3D (1 << 24),=0A=
+		eCallProceeding_UUIE_fastConnectRefused =3D (1 << 23),=0A=
+		eCallProceeding_UUIE_featureSet =3D (1 << 22),=0A=
+	} options;=0A=
+	TransportAddress h245Address;=0A=
+	CallProceeding_UUIE_fastStart fastStart;=0A=
+} CallProceeding_UUIE;=0A=
+=0A=
+typedef struct Connect_UUIE_fastStart {	/* SEQUENCE OF */=0A=
+	int count;=0A=
+	OpenLogicalChannel item[30];=0A=
+} Connect_UUIE_fastStart;=0A=
+=0A=
+typedef struct Connect_UUIE {	/* SEQUENCE */=0A=
+	enum {=0A=
+		eConnect_UUIE_h245Address =3D (1 << 31),=0A=
+		eConnect_UUIE_callIdentifier =3D (1 << 30),=0A=
+		eConnect_UUIE_h245SecurityMode =3D (1 << 29),=0A=
+		eConnect_UUIE_tokens =3D (1 << 28),=0A=
+		eConnect_UUIE_cryptoTokens =3D (1 << 27),=0A=
+		eConnect_UUIE_fastStart =3D (1 << 26),=0A=
+		eConnect_UUIE_multipleCalls =3D (1 << 25),=0A=
+		eConnect_UUIE_maintainConnection =3D (1 << 24),=0A=
+		eConnect_UUIE_language =3D (1 << 23),=0A=
+		eConnect_UUIE_connectedAddress =3D (1 << 22),=0A=
+		eConnect_UUIE_presentationIndicator =3D (1 << 21),=0A=
+		eConnect_UUIE_screeningIndicator =3D (1 << 20),=0A=
+		eConnect_UUIE_fastConnectRefused =3D (1 << 19),=0A=
+		eConnect_UUIE_serviceControl =3D (1 << 18),=0A=
+		eConnect_UUIE_capacity =3D (1 << 17),=0A=
+		eConnect_UUIE_featureSet =3D (1 << 16),=0A=
+	} options;=0A=
+	TransportAddress h245Address;=0A=
+	Connect_UUIE_fastStart fastStart;=0A=
+} Connect_UUIE;=0A=
+=0A=
+typedef struct Alerting_UUIE_fastStart {	/* SEQUENCE OF */=0A=
+	int count;=0A=
+	OpenLogicalChannel item[30];=0A=
+} Alerting_UUIE_fastStart;=0A=
+=0A=
+typedef struct Alerting_UUIE {	/* SEQUENCE */=0A=
+	enum {=0A=
+		eAlerting_UUIE_h245Address =3D (1 << 31),=0A=
+		eAlerting_UUIE_callIdentifier =3D (1 << 30),=0A=
+		eAlerting_UUIE_h245SecurityMode =3D (1 << 29),=0A=
+		eAlerting_UUIE_tokens =3D (1 << 28),=0A=
+		eAlerting_UUIE_cryptoTokens =3D (1 << 27),=0A=
+		eAlerting_UUIE_fastStart =3D (1 << 26),=0A=
+		eAlerting_UUIE_multipleCalls =3D (1 << 25),=0A=
+		eAlerting_UUIE_maintainConnection =3D (1 << 24),=0A=
+		eAlerting_UUIE_alertingAddress =3D (1 << 23),=0A=
+		eAlerting_UUIE_presentationIndicator =3D (1 << 22),=0A=
+		eAlerting_UUIE_screeningIndicator =3D (1 << 21),=0A=
+		eAlerting_UUIE_fastConnectRefused =3D (1 << 20),=0A=
+		eAlerting_UUIE_serviceControl =3D (1 << 19),=0A=
+		eAlerting_UUIE_capacity =3D (1 << 18),=0A=
+		eAlerting_UUIE_featureSet =3D (1 << 17),=0A=
+	} options;=0A=
+	TransportAddress h245Address;=0A=
+	Alerting_UUIE_fastStart fastStart;=0A=
+} Alerting_UUIE;=0A=
+=0A=
+typedef struct Information_UUIE_fastStart {	/* SEQUENCE OF */=0A=
+	int count;=0A=
+	OpenLogicalChannel item[30];=0A=
+} Information_UUIE_fastStart;=0A=
+=0A=
+typedef struct Information_UUIE {	/* SEQUENCE */=0A=
+	enum {=0A=
+		eInformation_UUIE_callIdentifier =3D (1 << 31),=0A=
+		eInformation_UUIE_tokens =3D (1 << 30),=0A=
+		eInformation_UUIE_cryptoTokens =3D (1 << 29),=0A=
+		eInformation_UUIE_fastStart =3D (1 << 28),=0A=
+		eInformation_UUIE_fastConnectRefused =3D (1 << 27),=0A=
+		eInformation_UUIE_circuitInfo =3D (1 << 26),=0A=
+	} options;=0A=
+	Information_UUIE_fastStart fastStart;=0A=
+} Information_UUIE;=0A=
+=0A=
+typedef struct FacilityReason {	/* CHOICE */=0A=
+	enum {=0A=
+		eFacilityReason_routeCallToGatekeeper,=0A=
+		eFacilityReason_callForwarded,=0A=
+		eFacilityReason_routeCallToMC,=0A=
+		eFacilityReason_undefinedReason,=0A=
+		eFacilityReason_conferenceListChoice,=0A=
+		eFacilityReason_startH245,=0A=
+		eFacilityReason_noH245,=0A=
+		eFacilityReason_newTokens,=0A=
+		eFacilityReason_featureSetUpdate,=0A=
+		eFacilityReason_forwardedElements,=0A=
+		eFacilityReason_transportedInformation,=0A=
+	} choice;=0A=
+} FacilityReason;=0A=
+=0A=
+typedef struct Facility_UUIE_fastStart {	/* SEQUENCE OF */=0A=
+	int count;=0A=
+	OpenLogicalChannel item[30];=0A=
+} Facility_UUIE_fastStart;=0A=
+=0A=
+typedef struct Facility_UUIE {	/* SEQUENCE */=0A=
+	enum {=0A=
+		eFacility_UUIE_alternativeAddress =3D (1 << 31),=0A=
+		eFacility_UUIE_alternativeAliasAddress =3D (1 << 30),=0A=
+		eFacility_UUIE_conferenceID =3D (1 << 29),=0A=
+		eFacility_UUIE_callIdentifier =3D (1 << 28),=0A=
+		eFacility_UUIE_destExtraCallInfo =3D (1 << 27),=0A=
+		eFacility_UUIE_remoteExtensionAddress =3D (1 << 26),=0A=
+		eFacility_UUIE_tokens =3D (1 << 25),=0A=
+		eFacility_UUIE_cryptoTokens =3D (1 << 24),=0A=
+		eFacility_UUIE_conferences =3D (1 << 23),=0A=
+		eFacility_UUIE_h245Address =3D (1 << 22),=0A=
+		eFacility_UUIE_fastStart =3D (1 << 21),=0A=
+		eFacility_UUIE_multipleCalls =3D (1 << 20),=0A=
+		eFacility_UUIE_maintainConnection =3D (1 << 19),=0A=
+		eFacility_UUIE_fastConnectRefused =3D (1 << 18),=0A=
+		eFacility_UUIE_serviceControl =3D (1 << 17),=0A=
+		eFacility_UUIE_circuitInfo =3D (1 << 16),=0A=
+		eFacility_UUIE_featureSet =3D (1 << 15),=0A=
+		eFacility_UUIE_destinationInfo =3D (1 << 14),=0A=
+		eFacility_UUIE_h245SecurityMode =3D (1 << 13),=0A=
+	} options;=0A=
+	FacilityReason reason;=0A=
+	TransportAddress h245Address;=0A=
+	Facility_UUIE_fastStart fastStart;=0A=
+} Facility_UUIE;=0A=
+=0A=
+typedef struct Progress_UUIE_fastStart {	/* SEQUENCE OF */=0A=
+	int count;=0A=
+	OpenLogicalChannel item[30];=0A=
+} Progress_UUIE_fastStart;=0A=
+=0A=
+typedef struct Progress_UUIE {	/* SEQUENCE */=0A=
+	enum {=0A=
+		eProgress_UUIE_h245Address =3D (1 << 31),=0A=
+		eProgress_UUIE_h245SecurityMode =3D (1 << 30),=0A=
+		eProgress_UUIE_tokens =3D (1 << 29),=0A=
+		eProgress_UUIE_cryptoTokens =3D (1 << 28),=0A=
+		eProgress_UUIE_fastStart =3D (1 << 27),=0A=
+		eProgress_UUIE_multipleCalls =3D (1 << 26),=0A=
+		eProgress_UUIE_maintainConnection =3D (1 << 25),=0A=
+		eProgress_UUIE_fastConnectRefused =3D (1 << 24),=0A=
+	} options;=0A=
+	TransportAddress h245Address;=0A=
+	Progress_UUIE_fastStart fastStart;=0A=
+} Progress_UUIE;=0A=
+=0A=
+typedef struct H323_UU_PDU_h323_message_body {	/* CHOICE */=0A=
+	enum {=0A=
+		eH323_UU_PDU_h323_message_body_setup,=0A=
+		eH323_UU_PDU_h323_message_body_callProceeding,=0A=
+		eH323_UU_PDU_h323_message_body_connect,=0A=
+		eH323_UU_PDU_h323_message_body_alerting,=0A=
+		eH323_UU_PDU_h323_message_body_information,=0A=
+		eH323_UU_PDU_h323_message_body_releaseComplete,=0A=
+		eH323_UU_PDU_h323_message_body_facility,=0A=
+		eH323_UU_PDU_h323_message_body_progress,=0A=
+		eH323_UU_PDU_h323_message_body_empty,=0A=
+		eH323_UU_PDU_h323_message_body_status,=0A=
+		eH323_UU_PDU_h323_message_body_statusInquiry,=0A=
+		eH323_UU_PDU_h323_message_body_setupAcknowledge,=0A=
+		eH323_UU_PDU_h323_message_body_notify,=0A=
+	} choice;=0A=
+	union {=0A=
+		Setup_UUIE setup;=0A=
+		CallProceeding_UUIE callProceeding;=0A=
+		Connect_UUIE connect;=0A=
+		Alerting_UUIE alerting;=0A=
+		Information_UUIE information;=0A=
+		Facility_UUIE facility;=0A=
+		Progress_UUIE progress;=0A=
+	};=0A=
+} H323_UU_PDU_h323_message_body;=0A=
+=0A=
+typedef struct RequestMessage {	/* CHOICE */=0A=
+	enum {=0A=
+		eRequestMessage_nonStandard,=0A=
+		eRequestMessage_masterSlaveDetermination,=0A=
+		eRequestMessage_terminalCapabilitySet,=0A=
+		eRequestMessage_openLogicalChannel,=0A=
+		eRequestMessage_closeLogicalChannel,=0A=
+		eRequestMessage_requestChannelClose,=0A=
+		eRequestMessage_multiplexEntrySend,=0A=
+		eRequestMessage_requestMultiplexEntry,=0A=
+		eRequestMessage_requestMode,=0A=
+		eRequestMessage_roundTripDelayRequest,=0A=
+		eRequestMessage_maintenanceLoopRequest,=0A=
+		eRequestMessage_communicationModeRequest,=0A=
+		eRequestMessage_conferenceRequest,=0A=
+		eRequestMessage_multilinkRequest,=0A=
+		eRequestMessage_logicalChannelRateRequest,=0A=
+	} choice;=0A=
+	union {=0A=
+		OpenLogicalChannel openLogicalChannel;=0A=
+	};=0A=
+} RequestMessage;=0A=
+=0A=
+typedef struct =
OpenLogicalChannelAck_reverseLogicalChannelParameters_multiplexParameters=
 {	/* CHOICE */=0A=
+	enum {=0A=
+		=
eOpenLogicalChannelAck_reverseLogicalChannelParameters_multiplexParameter=
s_h222LogicalChannelParameters,=0A=
+		=
eOpenLogicalChannelAck_reverseLogicalChannelParameters_multiplexParameter=
s_h2250LogicalChannelParameters,=0A=
+	} choice;=0A=
+	union {=0A=
+		H2250LogicalChannelParameters h2250LogicalChannelParameters;=0A=
+	};=0A=
+} =
OpenLogicalChannelAck_reverseLogicalChannelParameters_multiplexParameters=
;=0A=
+=0A=
+typedef struct OpenLogicalChannelAck_reverseLogicalChannelParameters {	=
/* SEQUENCE */=0A=
+	enum {=0A=
+		eOpenLogicalChannelAck_reverseLogicalChannelParameters_portNumber=0A=
+		    =3D (1 << 31),=0A=
+		=
eOpenLogicalChannelAck_reverseLogicalChannelParameters_multiplexParameter=
s=0A=
+		    =3D (1 << 30),=0A=
+		eOpenLogicalChannelAck_reverseLogicalChannelParameters_replacementFor=0A=
+		    =3D (1 << 29),=0A=
+	} options;=0A=
+	=
OpenLogicalChannelAck_reverseLogicalChannelParameters_multiplexParameters=0A=
+	    multiplexParameters;=0A=
+} OpenLogicalChannelAck_reverseLogicalChannelParameters;=0A=
+=0A=
+typedef struct H2250LogicalChannelAckParameters {	/* SEQUENCE */=0A=
+	enum {=0A=
+		eH2250LogicalChannelAckParameters_nonStandard =3D (1 << 31),=0A=
+		eH2250LogicalChannelAckParameters_sessionID =3D (1 << 30),=0A=
+		eH2250LogicalChannelAckParameters_mediaChannel =3D (1 << 29),=0A=
+		eH2250LogicalChannelAckParameters_mediaControlChannel =3D=0A=
+		    (1 << 28),=0A=
+		eH2250LogicalChannelAckParameters_dynamicRTPPayloadType =3D=0A=
+		    (1 << 27),=0A=
+		eH2250LogicalChannelAckParameters_flowControlToZero =3D=0A=
+		    (1 << 26),=0A=
+		eH2250LogicalChannelAckParameters_portNumber =3D (1 << 25),=0A=
+	} options;=0A=
+	H245_TransportAddress mediaChannel;=0A=
+	H245_TransportAddress mediaControlChannel;=0A=
+} H2250LogicalChannelAckParameters;=0A=
+=0A=
+typedef struct OpenLogicalChannelAck_forwardMultiplexAckParameters {	/* =
CHOICE */=0A=
+	enum {=0A=
+		=
eOpenLogicalChannelAck_forwardMultiplexAckParameters_h2250LogicalChannelA=
ckParameters,=0A=
+	} choice;=0A=
+	union {=0A=
+		H2250LogicalChannelAckParameters=0A=
+		    h2250LogicalChannelAckParameters;=0A=
+	};=0A=
+} OpenLogicalChannelAck_forwardMultiplexAckParameters;=0A=
+=0A=
+typedef struct OpenLogicalChannelAck {	/* SEQUENCE */=0A=
+	enum {=0A=
+		eOpenLogicalChannelAck_reverseLogicalChannelParameters =3D=0A=
+		    (1 << 31),=0A=
+		eOpenLogicalChannelAck_separateStack =3D (1 << 30),=0A=
+		eOpenLogicalChannelAck_forwardMultiplexAckParameters =3D=0A=
+		    (1 << 29),=0A=
+		eOpenLogicalChannelAck_encryptionSync =3D (1 << 28),=0A=
+	} options;=0A=
+	OpenLogicalChannelAck_reverseLogicalChannelParameters=0A=
+	    reverseLogicalChannelParameters;=0A=
+	OpenLogicalChannelAck_forwardMultiplexAckParameters=0A=
+	    forwardMultiplexAckParameters;=0A=
+} OpenLogicalChannelAck;=0A=
+=0A=
+typedef struct ResponseMessage {	/* CHOICE */=0A=
+	enum {=0A=
+		eResponseMessage_nonStandard,=0A=
+		eResponseMessage_masterSlaveDeterminationAck,=0A=
+		eResponseMessage_masterSlaveDeterminationReject,=0A=
+		eResponseMessage_terminalCapabilitySetAck,=0A=
+		eResponseMessage_terminalCapabilitySetReject,=0A=
+		eResponseMessage_openLogicalChannelAck,=0A=
+		eResponseMessage_openLogicalChannelReject,=0A=
+		eResponseMessage_closeLogicalChannelAck,=0A=
+		eResponseMessage_requestChannelCloseAck,=0A=
+		eResponseMessage_requestChannelCloseReject,=0A=
+		eResponseMessage_multiplexEntrySendAck,=0A=
+		eResponseMessage_multiplexEntrySendReject,=0A=
+		eResponseMessage_requestMultiplexEntryAck,=0A=
+		eResponseMessage_requestMultiplexEntryReject,=0A=
+		eResponseMessage_requestModeAck,=0A=
+		eResponseMessage_requestModeReject,=0A=
+		eResponseMessage_roundTripDelayResponse,=0A=
+		eResponseMessage_maintenanceLoopAck,=0A=
+		eResponseMessage_maintenanceLoopReject,=0A=
+		eResponseMessage_communicationModeResponse,=0A=
+		eResponseMessage_conferenceResponse,=0A=
+		eResponseMessage_multilinkResponse,=0A=
+		eResponseMessage_logicalChannelRateAcknowledge,=0A=
+		eResponseMessage_logicalChannelRateReject,=0A=
+	} choice;=0A=
+	union {=0A=
+		OpenLogicalChannelAck openLogicalChannelAck;=0A=
+	};=0A=
+} ResponseMessage;=0A=
+=0A=
+typedef struct MultimediaSystemControlMessage {	/* CHOICE */=0A=
+	enum {=0A=
+		eMultimediaSystemControlMessage_request,=0A=
+		eMultimediaSystemControlMessage_response,=0A=
+		eMultimediaSystemControlMessage_command,=0A=
+		eMultimediaSystemControlMessage_indication,=0A=
+	} choice;=0A=
+	union {=0A=
+		RequestMessage request;=0A=
+		ResponseMessage response;=0A=
+	};=0A=
+} MultimediaSystemControlMessage;=0A=
+=0A=
+typedef struct H323_UU_PDU_h245Control {	/* SEQUENCE OF */=0A=
+	int count;=0A=
+	MultimediaSystemControlMessage item[4];=0A=
+} H323_UU_PDU_h245Control;=0A=
+=0A=
+typedef struct H323_UU_PDU {	/* SEQUENCE */=0A=
+	enum {=0A=
+		eH323_UU_PDU_nonStandardData =3D (1 << 31),=0A=
+		eH323_UU_PDU_h4501SupplementaryService =3D (1 << 30),=0A=
+		eH323_UU_PDU_h245Tunneling =3D (1 << 29),=0A=
+		eH323_UU_PDU_h245Control =3D (1 << 28),=0A=
+		eH323_UU_PDU_nonStandardControl =3D (1 << 27),=0A=
+		eH323_UU_PDU_callLinkage =3D (1 << 26),=0A=
+		eH323_UU_PDU_tunnelledSignallingMessage =3D (1 << 25),=0A=
+		eH323_UU_PDU_provisionalRespToH245Tunneling =3D (1 << 24),=0A=
+		eH323_UU_PDU_stimulusControl =3D (1 << 23),=0A=
+		eH323_UU_PDU_genericData =3D (1 << 22),=0A=
+	} options;=0A=
+	H323_UU_PDU_h323_message_body h323_message_body;=0A=
+	H323_UU_PDU_h245Control h245Control;=0A=
+} H323_UU_PDU;=0A=
+=0A=
+typedef struct H323_UserInformation {	/* SEQUENCE */=0A=
+	enum {=0A=
+		eH323_UserInformation_user_data =3D (1 << 31),=0A=
+	} options;=0A=
+	H323_UU_PDU h323_uu_pdu;=0A=
+} H323_UserInformation;=0A=
+=0A=
+typedef struct GatekeeperRequest {	/* SEQUENCE */=0A=
+	enum {=0A=
+		eGatekeeperRequest_nonStandardData =3D (1 << 31),=0A=
+		eGatekeeperRequest_gatekeeperIdentifier =3D (1 << 30),=0A=
+		eGatekeeperRequest_callServices =3D (1 << 29),=0A=
+		eGatekeeperRequest_endpointAlias =3D (1 << 28),=0A=
+		eGatekeeperRequest_alternateEndpoints =3D (1 << 27),=0A=
+		eGatekeeperRequest_tokens =3D (1 << 26),=0A=
+		eGatekeeperRequest_cryptoTokens =3D (1 << 25),=0A=
+		eGatekeeperRequest_authenticationCapability =3D (1 << 24),=0A=
+		eGatekeeperRequest_algorithmOIDs =3D (1 << 23),=0A=
+		eGatekeeperRequest_integrity =3D (1 << 22),=0A=
+		eGatekeeperRequest_integrityCheckValue =3D (1 << 21),=0A=
+		eGatekeeperRequest_supportsAltGK =3D (1 << 20),=0A=
+		eGatekeeperRequest_featureSet =3D (1 << 19),=0A=
+		eGatekeeperRequest_genericData =3D (1 << 18),=0A=
+	} options;=0A=
+	TransportAddress rasAddress;=0A=
+} GatekeeperRequest;=0A=
+=0A=
+typedef struct GatekeeperConfirm {	/* SEQUENCE */=0A=
+	enum {=0A=
+		eGatekeeperConfirm_nonStandardData =3D (1 << 31),=0A=
+		eGatekeeperConfirm_gatekeeperIdentifier =3D (1 << 30),=0A=
+		eGatekeeperConfirm_alternateGatekeeper =3D (1 << 29),=0A=
+		eGatekeeperConfirm_authenticationMode =3D (1 << 28),=0A=
+		eGatekeeperConfirm_tokens =3D (1 << 27),=0A=
+		eGatekeeperConfirm_cryptoTokens =3D (1 << 26),=0A=
+		eGatekeeperConfirm_algorithmOID =3D (1 << 25),=0A=
+		eGatekeeperConfirm_integrity =3D (1 << 24),=0A=
+		eGatekeeperConfirm_integrityCheckValue =3D (1 << 23),=0A=
+		eGatekeeperConfirm_featureSet =3D (1 << 22),=0A=
+		eGatekeeperConfirm_genericData =3D (1 << 21),=0A=
+	} options;=0A=
+	TransportAddress rasAddress;=0A=
+} GatekeeperConfirm;=0A=
+=0A=
+typedef struct RegistrationRequest_callSignalAddress {	/* SEQUENCE OF */=0A=
+	int count;=0A=
+	TransportAddress item[10];=0A=
+} RegistrationRequest_callSignalAddress;=0A=
+=0A=
+typedef struct RegistrationRequest_rasAddress {	/* SEQUENCE OF */=0A=
+	int count;=0A=
+	TransportAddress item[10];=0A=
+} RegistrationRequest_rasAddress;=0A=
+=0A=
+typedef struct RegistrationRequest {	/* SEQUENCE */=0A=
+	enum {=0A=
+		eRegistrationRequest_nonStandardData =3D (1 << 31),=0A=
+		eRegistrationRequest_terminalAlias =3D (1 << 30),=0A=
+		eRegistrationRequest_gatekeeperIdentifier =3D (1 << 29),=0A=
+		eRegistrationRequest_alternateEndpoints =3D (1 << 28),=0A=
+		eRegistrationRequest_timeToLive =3D (1 << 27),=0A=
+		eRegistrationRequest_tokens =3D (1 << 26),=0A=
+		eRegistrationRequest_cryptoTokens =3D (1 << 25),=0A=
+		eRegistrationRequest_integrityCheckValue =3D (1 << 24),=0A=
+		eRegistrationRequest_keepAlive =3D (1 << 23),=0A=
+		eRegistrationRequest_endpointIdentifier =3D (1 << 22),=0A=
+		eRegistrationRequest_willSupplyUUIEs =3D (1 << 21),=0A=
+		eRegistrationRequest_maintainConnection =3D (1 << 20),=0A=
+		eRegistrationRequest_alternateTransportAddresses =3D (1 << 19),=0A=
+		eRegistrationRequest_additiveRegistration =3D (1 << 18),=0A=
+		eRegistrationRequest_terminalAliasPattern =3D (1 << 17),=0A=
+		eRegistrationRequest_supportsAltGK =3D (1 << 16),=0A=
+		eRegistrationRequest_usageReportingCapability =3D (1 << 15),=0A=
+		eRegistrationRequest_multipleCalls =3D (1 << 14),=0A=
+		eRegistrationRequest_supportedH248Packages =3D (1 << 13),=0A=
+		eRegistrationRequest_callCreditCapability =3D (1 << 12),=0A=
+		eRegistrationRequest_capacityReportingCapability =3D (1 << 11),=0A=
+		eRegistrationRequest_capacity =3D (1 << 10),=0A=
+		eRegistrationRequest_featureSet =3D (1 << 9),=0A=
+		eRegistrationRequest_genericData =3D (1 << 8),=0A=
+	} options;=0A=
+	RegistrationRequest_callSignalAddress callSignalAddress;=0A=
+	RegistrationRequest_rasAddress rasAddress;=0A=
+	unsigned timeToLive;=0A=
+} RegistrationRequest;=0A=
+=0A=
+typedef struct RegistrationConfirm_callSignalAddress {	/* SEQUENCE OF */=0A=
+	int count;=0A=
+	TransportAddress item[10];=0A=
+} RegistrationConfirm_callSignalAddress;=0A=
+=0A=
+typedef struct RegistrationConfirm {	/* SEQUENCE */=0A=
+	enum {=0A=
+		eRegistrationConfirm_nonStandardData =3D (1 << 31),=0A=
+		eRegistrationConfirm_terminalAlias =3D (1 << 30),=0A=
+		eRegistrationConfirm_gatekeeperIdentifier =3D (1 << 29),=0A=
+		eRegistrationConfirm_alternateGatekeeper =3D (1 << 28),=0A=
+		eRegistrationConfirm_timeToLive =3D (1 << 27),=0A=
+		eRegistrationConfirm_tokens =3D (1 << 26),=0A=
+		eRegistrationConfirm_cryptoTokens =3D (1 << 25),=0A=
+		eRegistrationConfirm_integrityCheckValue =3D (1 << 24),=0A=
+		eRegistrationConfirm_willRespondToIRR =3D (1 << 23),=0A=
+		eRegistrationConfirm_preGrantedARQ =3D (1 << 22),=0A=
+		eRegistrationConfirm_maintainConnection =3D (1 << 21),=0A=
+		eRegistrationConfirm_serviceControl =3D (1 << 20),=0A=
+		eRegistrationConfirm_supportsAdditiveRegistration =3D (1 << 19),=0A=
+		eRegistrationConfirm_terminalAliasPattern =3D (1 << 18),=0A=
+		eRegistrationConfirm_supportedPrefixes =3D (1 << 17),=0A=
+		eRegistrationConfirm_usageSpec =3D (1 << 16),=0A=
+		eRegistrationConfirm_featureServerAlias =3D (1 << 15),=0A=
+		eRegistrationConfirm_capacityReportingSpec =3D (1 << 14),=0A=
+		eRegistrationConfirm_featureSet =3D (1 << 13),=0A=
+		eRegistrationConfirm_genericData =3D (1 << 12),=0A=
+	} options;=0A=
+	RegistrationConfirm_callSignalAddress callSignalAddress;=0A=
+	unsigned timeToLive;=0A=
+} RegistrationConfirm;=0A=
+=0A=
+typedef struct UnregistrationRequest_callSignalAddress {	/* SEQUENCE OF =
*/=0A=
+	int count;=0A=
+	TransportAddress item[10];=0A=
+} UnregistrationRequest_callSignalAddress;=0A=
+=0A=
+typedef struct UnregistrationRequest {	/* SEQUENCE */=0A=
+	enum {=0A=
+		eUnregistrationRequest_endpointAlias =3D (1 << 31),=0A=
+		eUnregistrationRequest_nonStandardData =3D (1 << 30),=0A=
+		eUnregistrationRequest_endpointIdentifier =3D (1 << 29),=0A=
+		eUnregistrationRequest_alternateEndpoints =3D (1 << 28),=0A=
+		eUnregistrationRequest_gatekeeperIdentifier =3D (1 << 27),=0A=
+		eUnregistrationRequest_tokens =3D (1 << 26),=0A=
+		eUnregistrationRequest_cryptoTokens =3D (1 << 25),=0A=
+		eUnregistrationRequest_integrityCheckValue =3D (1 << 24),=0A=
+		eUnregistrationRequest_reason =3D (1 << 23),=0A=
+		eUnregistrationRequest_endpointAliasPattern =3D (1 << 22),=0A=
+		eUnregistrationRequest_supportedPrefixes =3D (1 << 21),=0A=
+		eUnregistrationRequest_alternateGatekeeper =3D (1 << 20),=0A=
+		eUnregistrationRequest_genericData =3D (1 << 19),=0A=
+	} options;=0A=
+	UnregistrationRequest_callSignalAddress callSignalAddress;=0A=
+} UnregistrationRequest;=0A=
+=0A=
+typedef struct AdmissionRequest {	/* SEQUENCE */=0A=
+	enum {=0A=
+		eAdmissionRequest_callModel =3D (1 << 31),=0A=
+		eAdmissionRequest_destinationInfo =3D (1 << 30),=0A=
+		eAdmissionRequest_destCallSignalAddress =3D (1 << 29),=0A=
+		eAdmissionRequest_destExtraCallInfo =3D (1 << 28),=0A=
+		eAdmissionRequest_srcCallSignalAddress =3D (1 << 27),=0A=
+		eAdmissionRequest_nonStandardData =3D (1 << 26),=0A=
+		eAdmissionRequest_callServices =3D (1 << 25),=0A=
+		eAdmissionRequest_canMapAlias =3D (1 << 24),=0A=
+		eAdmissionRequest_callIdentifier =3D (1 << 23),=0A=
+		eAdmissionRequest_srcAlternatives =3D (1 << 22),=0A=
+		eAdmissionRequest_destAlternatives =3D (1 << 21),=0A=
+		eAdmissionRequest_gatekeeperIdentifier =3D (1 << 20),=0A=
+		eAdmissionRequest_tokens =3D (1 << 19),=0A=
+		eAdmissionRequest_cryptoTokens =3D (1 << 18),=0A=
+		eAdmissionRequest_integrityCheckValue =3D (1 << 17),=0A=
+		eAdmissionRequest_transportQOS =3D (1 << 16),=0A=
+		eAdmissionRequest_willSupplyUUIEs =3D (1 << 15),=0A=
+		eAdmissionRequest_callLinkage =3D (1 << 14),=0A=
+		eAdmissionRequest_gatewayDataRate =3D (1 << 13),=0A=
+		eAdmissionRequest_capacity =3D (1 << 12),=0A=
+		eAdmissionRequest_circuitInfo =3D (1 << 11),=0A=
+		eAdmissionRequest_desiredProtocols =3D (1 << 10),=0A=
+		eAdmissionRequest_desiredTunnelledProtocol =3D (1 << 9),=0A=
+		eAdmissionRequest_featureSet =3D (1 << 8),=0A=
+		eAdmissionRequest_genericData =3D (1 << 7),=0A=
+	} options;=0A=
+	TransportAddress destCallSignalAddress;=0A=
+	TransportAddress srcCallSignalAddress;=0A=
+} AdmissionRequest;=0A=
+=0A=
+typedef struct AdmissionConfirm {	/* SEQUENCE */=0A=
+	enum {=0A=
+		eAdmissionConfirm_irrFrequency =3D (1 << 31),=0A=
+		eAdmissionConfirm_nonStandardData =3D (1 << 30),=0A=
+		eAdmissionConfirm_destinationInfo =3D (1 << 29),=0A=
+		eAdmissionConfirm_destExtraCallInfo =3D (1 << 28),=0A=
+		eAdmissionConfirm_destinationType =3D (1 << 27),=0A=
+		eAdmissionConfirm_remoteExtensionAddress =3D (1 << 26),=0A=
+		eAdmissionConfirm_alternateEndpoints =3D (1 << 25),=0A=
+		eAdmissionConfirm_tokens =3D (1 << 24),=0A=
+		eAdmissionConfirm_cryptoTokens =3D (1 << 23),=0A=
+		eAdmissionConfirm_integrityCheckValue =3D (1 << 22),=0A=
+		eAdmissionConfirm_transportQOS =3D (1 << 21),=0A=
+		eAdmissionConfirm_willRespondToIRR =3D (1 << 20),=0A=
+		eAdmissionConfirm_uuiesRequested =3D (1 << 19),=0A=
+		eAdmissionConfirm_language =3D (1 << 18),=0A=
+		eAdmissionConfirm_alternateTransportAddresses =3D (1 << 17),=0A=
+		eAdmissionConfirm_useSpecifiedTransport =3D (1 << 16),=0A=
+		eAdmissionConfirm_circuitInfo =3D (1 << 15),=0A=
+		eAdmissionConfirm_usageSpec =3D (1 << 14),=0A=
+		eAdmissionConfirm_supportedProtocols =3D (1 << 13),=0A=
+		eAdmissionConfirm_serviceControl =3D (1 << 12),=0A=
+		eAdmissionConfirm_multipleCalls =3D (1 << 11),=0A=
+		eAdmissionConfirm_featureSet =3D (1 << 10),=0A=
+		eAdmissionConfirm_genericData =3D (1 << 9),=0A=
+	} options;=0A=
+	TransportAddress destCallSignalAddress;=0A=
+} AdmissionConfirm;=0A=
+=0A=
+typedef struct LocationRequest {	/* SEQUENCE */=0A=
+	enum {=0A=
+		eLocationRequest_endpointIdentifier =3D (1 << 31),=0A=
+		eLocationRequest_nonStandardData =3D (1 << 30),=0A=
+		eLocationRequest_sourceInfo =3D (1 << 29),=0A=
+		eLocationRequest_canMapAlias =3D (1 << 28),=0A=
+		eLocationRequest_gatekeeperIdentifier =3D (1 << 27),=0A=
+		eLocationRequest_tokens =3D (1 << 26),=0A=
+		eLocationRequest_cryptoTokens =3D (1 << 25),=0A=
+		eLocationRequest_integrityCheckValue =3D (1 << 24),=0A=
+		eLocationRequest_desiredProtocols =3D (1 << 23),=0A=
+		eLocationRequest_desiredTunnelledProtocol =3D (1 << 22),=0A=
+		eLocationRequest_featureSet =3D (1 << 21),=0A=
+		eLocationRequest_genericData =3D (1 << 20),=0A=
+		eLocationRequest_hopCount =3D (1 << 19),=0A=
+		eLocationRequest_circuitInfo =3D (1 << 18),=0A=
+	} options;=0A=
+	TransportAddress replyAddress;=0A=
+} LocationRequest;=0A=
+=0A=
+typedef struct LocationConfirm {	/* SEQUENCE */=0A=
+	enum {=0A=
+		eLocationConfirm_nonStandardData =3D (1 << 31),=0A=
+		eLocationConfirm_destinationInfo =3D (1 << 30),=0A=
+		eLocationConfirm_destExtraCallInfo =3D (1 << 29),=0A=
+		eLocationConfirm_destinationType =3D (1 << 28),=0A=
+		eLocationConfirm_remoteExtensionAddress =3D (1 << 27),=0A=
+		eLocationConfirm_alternateEndpoints =3D (1 << 26),=0A=
+		eLocationConfirm_tokens =3D (1 << 25),=0A=
+		eLocationConfirm_cryptoTokens =3D (1 << 24),=0A=
+		eLocationConfirm_integrityCheckValue =3D (1 << 23),=0A=
+		eLocationConfirm_alternateTransportAddresses =3D (1 << 22),=0A=
+		eLocationConfirm_supportedProtocols =3D (1 << 21),=0A=
+		eLocationConfirm_multipleCalls =3D (1 << 20),=0A=
+		eLocationConfirm_featureSet =3D (1 << 19),=0A=
+		eLocationConfirm_genericData =3D (1 << 18),=0A=
+		eLocationConfirm_circuitInfo =3D (1 << 17),=0A=
+		eLocationConfirm_serviceControl =3D (1 << 16),=0A=
+	} options;=0A=
+	TransportAddress callSignalAddress;=0A=
+	TransportAddress rasAddress;=0A=
+} LocationConfirm;=0A=
+=0A=
+typedef struct InfoRequestResponse_callSignalAddress {	/* SEQUENCE OF */=0A=
+	int count;=0A=
+	TransportAddress item[10];=0A=
+} InfoRequestResponse_callSignalAddress;=0A=
+=0A=
+typedef struct InfoRequestResponse {	/* SEQUENCE */=0A=
+	enum {=0A=
+		eInfoRequestResponse_nonStandardData =3D (1 << 31),=0A=
+		eInfoRequestResponse_endpointAlias =3D (1 << 30),=0A=
+		eInfoRequestResponse_perCallInfo =3D (1 << 29),=0A=
+		eInfoRequestResponse_tokens =3D (1 << 28),=0A=
+		eInfoRequestResponse_cryptoTokens =3D (1 << 27),=0A=
+		eInfoRequestResponse_integrityCheckValue =3D (1 << 26),=0A=
+		eInfoRequestResponse_needResponse =3D (1 << 25),=0A=
+		eInfoRequestResponse_capacity =3D (1 << 24),=0A=
+		eInfoRequestResponse_irrStatus =3D (1 << 23),=0A=
+		eInfoRequestResponse_unsolicited =3D (1 << 22),=0A=
+		eInfoRequestResponse_genericData =3D (1 << 21),=0A=
+	} options;=0A=
+	TransportAddress rasAddress;=0A=
+	InfoRequestResponse_callSignalAddress callSignalAddress;=0A=
+} InfoRequestResponse;=0A=
+=0A=
+typedef struct RasMessage {	/* CHOICE */=0A=
+	enum {=0A=
+		eRasMessage_gatekeeperRequest,=0A=
+		eRasMessage_gatekeeperConfirm,=0A=
+		eRasMessage_gatekeeperReject,=0A=
+		eRasMessage_registrationRequest,=0A=
+		eRasMessage_registrationConfirm,=0A=
+		eRasMessage_registrationReject,=0A=
+		eRasMessage_unregistrationRequest,=0A=
+		eRasMessage_unregistrationConfirm,=0A=
+		eRasMessage_unregistrationReject,=0A=
+		eRasMessage_admissionRequest,=0A=
+		eRasMessage_admissionConfirm,=0A=
+		eRasMessage_admissionReject,=0A=
+		eRasMessage_bandwidthRequest,=0A=
+		eRasMessage_bandwidthConfirm,=0A=
+		eRasMessage_bandwidthReject,=0A=
+		eRasMessage_disengageRequest,=0A=
+		eRasMessage_disengageConfirm,=0A=
+		eRasMessage_disengageReject,=0A=
+		eRasMessage_locationRequest,=0A=
+		eRasMessage_locationConfirm,=0A=
+		eRasMessage_locationReject,=0A=
+		eRasMessage_infoRequest,=0A=
+		eRasMessage_infoRequestResponse,=0A=
+		eRasMessage_nonStandardMessage,=0A=
+		eRasMessage_unknownMessageResponse,=0A=
+		eRasMessage_requestInProgress,=0A=
+		eRasMessage_resourcesAvailableIndicate,=0A=
+		eRasMessage_resourcesAvailableConfirm,=0A=
+		eRasMessage_infoRequestAck,=0A=
+		eRasMessage_infoRequestNak,=0A=
+		eRasMessage_serviceControlIndication,=0A=
+		eRasMessage_serviceControlResponse,=0A=
+	} choice;=0A=
+	union {=0A=
+		GatekeeperRequest gatekeeperRequest;=0A=
+		GatekeeperConfirm gatekeeperConfirm;=0A=
+		RegistrationRequest registrationRequest;=0A=
+		RegistrationConfirm registrationConfirm;=0A=
+		UnregistrationRequest unregistrationRequest;=0A=
+		AdmissionRequest admissionRequest;=0A=
+		AdmissionConfirm admissionConfirm;=0A=
+		LocationRequest locationRequest;=0A=
+		LocationConfirm locationConfirm;=0A=
+		InfoRequestResponse infoRequestResponse;=0A=
+	};=0A=
+} RasMessage;=0A=
diff -pruN linux-2.6.15.orig/net/ipv4/netfilter/ip_nat_helper_h323.c =
linux-2.6.15/net/ipv4/netfilter/ip_nat_helper_h323.c=0A=
--- linux-2.6.15.orig/net/ipv4/netfilter/ip_nat_helper_h323.c	1969-12-31 =
19:00:00.000000000 -0500=0A=
+++ linux-2.6.15/net/ipv4/netfilter/ip_nat_helper_h323.c	2006-03-15 =
19:30:10.000000000 -0500=0A=
@@ -0,0 +1,605 @@=0A=
+/*=0A=
+ * H.323 extension for NAT alteration.=0A=
+ * =0A=
+ * Copyright (c) 2006 Jing Min Zhao <zhaojingmin@users.sourceforge.net>=0A=
+ *=0A=
+ * This source code is licensed under General Public License version 2.=0A=
+ *=0A=
+ * Based on the 'brute force' H.323 NAT module by=0A=
+ * Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>=0A=
+ * =0A=
+ * Changes:=0A=
+ *	2006-02-01 - initial version 0.1=0A=
+ *	=0A=
+ *	2006-02-20 - version 0.2=0A=
+ *	  1. Changed source format to follow kernel conventions=0A=
+ *	  2. Deleted some unnecessary structures=0A=
+ *	  3. Minor fixes=0A=
+ *	  =0A=
+ * 	2006-03-10 - version 0.3=0A=
+ * 	  1. Added support for multiple TPKTs in one packet (suggested by=0A=
+ * 	     Patrick McHardy)=0A=
+ * 	  2. Added support for non-linear skb (based on Patrick McHardy's =
patch)=0A=
+ * 	  3. Eliminated unnecessary return code=0A=
+ *=0A=
+ * 	2006-03-15 - version 0.4=0A=
+ * 	  1. Added support for T.120 channels=0A=
+ * 	  2. Added parameter gkrouted_only (suggested by Patrick McHardy)=0A=
+ */=0A=
+=0A=
+#include <linux/module.h>=0A=
+#include <linux/netfilter_ipv4.h>=0A=
+#include <linux/netfilter.h>=0A=
+#include <linux/ip.h>=0A=
+#include <linux/tcp.h>=0A=
+#include <linux/moduleparam.h>=0A=
+#include <net/tcp.h>=0A=
+#include <linux/netfilter_ipv4/ip_nat.h>=0A=
+#include <linux/netfilter_ipv4/ip_nat_helper.h>=0A=
+#include <linux/netfilter_ipv4/ip_nat_rule.h>=0A=
+#include <linux/netfilter_ipv4/ip_conntrack_tuple.h>=0A=
+#include <linux/netfilter_ipv4/ip_conntrack_h323.h>=0A=
+#include <linux/netfilter_ipv4/ip_conntrack_helper.h>=0A=
+=0A=
+#include "ip_conntrack_helper_h323_asn1.h"=0A=
+=0A=
+#if 0=0A=
+#define DEBUGP printk=0A=
+#else=0A=
+#define DEBUGP(format, args...)=0A=
+#endif=0A=
+=0A=
+extern int get_h245_addr(unsigned char *data, H245_TransportAddress * =
addr,=0A=
+			 u_int32_t * ip, u_int16_t * port);=0A=
+extern int get_h225_addr(unsigned char *data, TransportAddress * addr,=0A=
+			 u_int32_t * ip, u_int16_t * port);=0A=
+extern void ip_conntrack_h245_expect(struct ip_conntrack *new,=0A=
+				     struct ip_conntrack_expect *this);=0A=
+extern void ip_conntrack_q931_expect(struct ip_conntrack *new,=0A=
+				     struct ip_conntrack_expect *this);=0A=
+extern int (*set_h245_addr_hook) (struct sk_buff ** pskb,=0A=
+				  unsigned char **data, int dataoff,=0A=
+				  H245_TransportAddress * addr,=0A=
+				  u_int32_t ip, u_int16_t port);=0A=
+extern int (*set_h225_addr_hook) (struct sk_buff ** pskb,=0A=
+				  unsigned char **data, int dataoff,=0A=
+				  TransportAddress * addr,=0A=
+				  u_int32_t ip, u_int16_t port);=0A=
+extern int (*set_sig_addr_hook) (struct sk_buff ** pskb,=0A=
+				 struct ip_conntrack * ct,=0A=
+				 enum ip_conntrack_info ctinfo,=0A=
+				 unsigned char **data,=0A=
+				 TransportAddress * addr, int count);=0A=
+extern int (*set_ras_addr_hook) (struct sk_buff ** pskb,=0A=
+				 struct ip_conntrack * ct,=0A=
+				 enum ip_conntrack_info ctinfo,=0A=
+				 unsigned char **data,=0A=
+				 TransportAddress * addr, int count);=0A=
+extern int (*nat_rtp_rtcp_hook) (struct sk_buff ** pskb,=0A=
+				 struct ip_conntrack * ct,=0A=
+				 enum ip_conntrack_info ctinfo,=0A=
+				 unsigned char **data, int dataoff,=0A=
+				 H245_TransportAddress * addr,=0A=
+				 u_int16_t port, u_int16_t rtp_port,=0A=
+				 struct ip_conntrack_expect * rtp_exp,=0A=
+				 struct ip_conntrack_expect * rtcp_exp);=0A=
+extern int (*nat_t120_hook) (struct sk_buff ** pskb, struct =
ip_conntrack * ct,=0A=
+			     enum ip_conntrack_info ctinfo,=0A=
+			     unsigned char **data, int dataoff,=0A=
+			     H245_TransportAddress * addr, u_int16_t port,=0A=
+			     struct ip_conntrack_expect * exp);=0A=
+extern int (*nat_h245_hook) (struct sk_buff ** pskb, struct =
ip_conntrack * ct,=0A=
+			     enum ip_conntrack_info ctinfo,=0A=
+			     unsigned char **data, int dataoff,=0A=
+			     TransportAddress * addr, u_int16_t port,=0A=
+			     struct ip_conntrack_expect * exp);=0A=
+extern int (*nat_q931_hook) (struct sk_buff ** pskb, struct =
ip_conntrack * ct,=0A=
+			     enum ip_conntrack_info ctinfo,=0A=
+			     unsigned char **data, TransportAddress * addr,=0A=
+			     int idx, u_int16_t port,=0A=
+			     struct ip_conntrack_expect * exp);=0A=
+=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static int set_addr(struct sk_buff **pskb,=0A=
+		    unsigned char **data, int dataoff,=0A=
+		    unsigned int addroff, u_int32_t ip, u_int16_t port)=0A=
+{=0A=
+	enum ip_conntrack_info ctinfo;=0A=
+	struct ip_conntrack *ct =3D ip_conntrack_get(*pskb, &ctinfo);=0A=
+	struct {=0A=
+		u_int32_t ip;=0A=
+		u_int16_t port;=0A=
+	} __attribute__ ((__packed__)) buf;=0A=
+	struct tcphdr _tcph, *th;=0A=
+=0A=
+	buf.ip =3D ip;=0A=
+	buf.port =3D htons(port);=0A=
+	addroff +=3D dataoff;=0A=
+=0A=
+	if ((*pskb)->nh.iph->protocol =3D=3D IPPROTO_TCP) {=0A=
+		if (!ip_nat_mangle_tcp_packet(pskb, ct, ctinfo,=0A=
+					      addroff, sizeof(buf),=0A=
+					      (char *) &buf, sizeof(buf))) {=0A=
+			if (net_ratelimit())=0A=
+				printk("ip_nat_h323: ip_nat_mangle_tcp_packet"=0A=
+				       " error\n");=0A=
+			return -1;=0A=
+		}=0A=
+=0A=
+		/* Relocate data pointer */=0A=
+		th =3D skb_header_pointer(*pskb, (*pskb)->nh.iph->ihl * 4,=0A=
+					sizeof(_tcph), &_tcph);=0A=
+		if (th =3D=3D NULL)=0A=
+			return -1;=0A=
+		*data =3D (*pskb)->data + (*pskb)->nh.iph->ihl * 4 +=0A=
+		    th->doff * 4 + dataoff;=0A=
+	} else {=0A=
+		if (!ip_nat_mangle_udp_packet(pskb, ct, ctinfo,=0A=
+					      addroff, sizeof(buf),=0A=
+					      (char *) &buf, sizeof(buf))) {=0A=
+			if (net_ratelimit())=0A=
+				printk("ip_nat_h323: ip_nat_mangle_udp_packet"=0A=
+				       " error\n");=0A=
+			return -1;=0A=
+		}=0A=
+		/* ip_nat_mangle_udp_packet uses skb_make_writable() to copy =0A=
+		 * or pull everything in a linear buffer, so we can safely =0A=
+		 * use the skb pointers now */=0A=
+		*data =3D (*pskb)->data + (*pskb)->nh.iph->ihl * 4 +=0A=
+		    sizeof(struct udphdr);=0A=
+	}=0A=
+=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static int set_h225_addr(struct sk_buff **pskb,=0A=
+			 unsigned char **data, int dataoff,=0A=
+			 TransportAddress * addr,=0A=
+			 u_int32_t ip, u_int16_t port)=0A=
+{=0A=
+	return set_addr(pskb, data, dataoff, addr->ipAddress.ip, ip, port);=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static int set_h245_addr(struct sk_buff **pskb,=0A=
+			 unsigned char **data, int dataoff,=0A=
+			 H245_TransportAddress * addr,=0A=
+			 u_int32_t ip, u_int16_t port)=0A=
+{=0A=
+	return set_addr(pskb, data, dataoff,=0A=
+			addr->unicastAddress.iPAddress.network, ip, port);=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static int set_sig_addr(struct sk_buff **pskb, struct ip_conntrack *ct,=0A=
+			enum ip_conntrack_info ctinfo,=0A=
+			unsigned char **data,=0A=
+			TransportAddress * addr, int count)=0A=
+{=0A=
+	struct ip_ct_h323_master *info =3D &ct->help.ct_h323_info;=0A=
+	int dir =3D CTINFO2DIR(ctinfo);=0A=
+	int i;=0A=
+	u_int32_t ip;=0A=
+	u_int16_t port;=0A=
+=0A=
+	for (i =3D 0; i < count; i++) {=0A=
+		if (get_h225_addr(*data, &addr[i], &ip, &port)) {=0A=
+			if (ip =3D=3D ct->tuplehash[dir].tuple.src.ip &&=0A=
+			    port =3D=3D info->sig_port[dir]) {=0A=
+				/* GW->GK */=0A=
+=0A=
+				/* Fix for Gnomemeeting */=0A=
+				if (i > 0 &&=0A=
+				    get_h225_addr(*data, &addr[0],=0A=
+						  &ip, &port) &&=0A=
+				    (ntohl(ip) & 0xff000000) =3D=3D 0x7f000000)=0A=
+					i =3D 0;=0A=
+=0A=
+				DEBUGP=0A=
+				    ("ip_nat_ras: set signal address "=0A=
+				     "%u.%u.%u.%u:%hu->%u.%u.%u.%u:%hu\n",=0A=
+				     NIPQUAD(ip), port,=0A=
+				     NIPQUAD(ct->tuplehash[!dir].tuple.dst.=0A=
+					     ip), info->sig_port[!dir]);=0A=
+				return set_h225_addr(pskb, data, 0, &addr[i],=0A=
+						     ct->tuplehash[!dir].=0A=
+						     tuple.dst.ip,=0A=
+						     info->sig_port[!dir]);=0A=
+			} else if (ip =3D=3D ct->tuplehash[dir].tuple.dst.ip &&=0A=
+				   port =3D=3D info->sig_port[dir]) {=0A=
+				/* GK->GW */=0A=
+				DEBUGP=0A=
+				    ("ip_nat_ras: set signal address "=0A=
+				     "%u.%u.%u.%u:%hu->%u.%u.%u.%u:%hu\n",=0A=
+				     NIPQUAD(ip), port,=0A=
+				     NIPQUAD(ct->tuplehash[!dir].tuple.src.=0A=
+					     ip), info->sig_port[!dir]);=0A=
+				return set_h225_addr(pskb, data, 0, &addr[i],=0A=
+						     ct->tuplehash[!dir].=0A=
+						     tuple.src.ip,=0A=
+						     info->sig_port[!dir]);=0A=
+			}=0A=
+		}=0A=
+	}=0A=
+=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static int set_ras_addr(struct sk_buff **pskb, struct ip_conntrack *ct,=0A=
+			enum ip_conntrack_info ctinfo,=0A=
+			unsigned char **data,=0A=
+			TransportAddress * addr, int count)=0A=
+{=0A=
+	int dir =3D CTINFO2DIR(ctinfo);=0A=
+	int i;=0A=
+	u_int32_t ip;=0A=
+	u_int16_t port;=0A=
+=0A=
+	for (i =3D 0; i < count; i++) {=0A=
+		if (get_h225_addr(*data, &addr[i], &ip, &port) &&=0A=
+		    ip =3D=3D ct->tuplehash[dir].tuple.src.ip &&=0A=
+		    port =3D=3D ntohs(ct->tuplehash[dir].tuple.src.u.udp.port)) {=0A=
+			DEBUGP("ip_nat_ras: set rasAddress "=0A=
+			       "%u.%u.%u.%u:%hu->%u.%u.%u.%u:%hu\n",=0A=
+			       NIPQUAD(ip), port,=0A=
+			       NIPQUAD(ct->tuplehash[!dir].tuple.dst.ip),=0A=
+			       ntohs(ct->tuplehash[!dir].tuple.dst.u.udp.=0A=
+				     port));=0A=
+			return set_h225_addr(pskb, data, 0, &addr[i],=0A=
+					     ct->tuplehash[!dir].tuple.dst.ip,=0A=
+					     ntohs(ct->tuplehash[!dir].tuple.=0A=
+						   dst.u.udp.port));=0A=
+		}=0A=
+	}=0A=
+=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static int nat_rtp_rtcp(struct sk_buff **pskb, struct ip_conntrack *ct,=0A=
+			enum ip_conntrack_info ctinfo,=0A=
+			unsigned char **data, int dataoff,=0A=
+			H245_TransportAddress * addr,=0A=
+			u_int16_t port, u_int16_t rtp_port,=0A=
+			struct ip_conntrack_expect *rtp_exp,=0A=
+			struct ip_conntrack_expect *rtcp_exp)=0A=
+{=0A=
+	struct ip_ct_h323_master *info =3D &ct->help.ct_h323_info;=0A=
+	int dir =3D CTINFO2DIR(ctinfo);=0A=
+	int i;=0A=
+	u_int16_t nated_port;=0A=
+=0A=
+	/* Set expectations for NAT */=0A=
+	rtp_exp->saved_proto.udp.port =3D rtp_exp->tuple.dst.u.udp.port;=0A=
+	rtp_exp->expectfn =3D ip_nat_follow_master;=0A=
+	rtp_exp->dir =3D !dir;=0A=
+	rtcp_exp->saved_proto.udp.port =3D rtcp_exp->tuple.dst.u.udp.port;=0A=
+	rtcp_exp->expectfn =3D ip_nat_follow_master;=0A=
+	rtcp_exp->dir =3D !dir;=0A=
+=0A=
+	/* Lookup existing expects */=0A=
+	for (i =3D 0; i < H323_RTP_CHANNEL_MAX; i++) {=0A=
+		if (info->rtp_port[i][dir] =3D=3D rtp_port) {=0A=
+			/* Expected */=0A=
+=0A=
+			/* Use allocated ports first. This will refresh =0A=
+			 * the expects */=0A=
+			rtp_exp->tuple.dst.u.udp.port =3D=0A=
+			    htons(info->rtp_port[i][dir]);=0A=
+			rtcp_exp->tuple.dst.u.udp.port =3D=0A=
+			    htons(info->rtp_port[i][dir] + 1);=0A=
+			break;=0A=
+		} else if (info->rtp_port[i][dir] =3D=3D 0) {=0A=
+			/* Not expected */=0A=
+			break;=0A=
+		}=0A=
+	}=0A=
+=0A=
+	/* Run out of expectations */=0A=
+	if (i >=3D H323_RTP_CHANNEL_MAX) {=0A=
+		if (net_ratelimit())=0A=
+			printk("ip_nat_h323: out of expectations\n");=0A=
+		return 0;=0A=
+	}=0A=
+=0A=
+	/* Try to get a pair of ports. */=0A=
+	for (nated_port =3D ntohs(rtp_exp->tuple.dst.u.udp.port);=0A=
+	     nated_port !=3D 0; nated_port +=3D 2) {=0A=
+		rtp_exp->tuple.dst.u.udp.port =3D htons(nated_port);=0A=
+		if (ip_conntrack_expect_related(rtp_exp) =3D=3D 0) {=0A=
+			rtcp_exp->tuple.dst.u.udp.port =3D=0A=
+			    htons(nated_port + 1);=0A=
+			if (ip_conntrack_expect_related(rtcp_exp) =3D=3D 0)=0A=
+				break;=0A=
+			ip_conntrack_unexpect_related(rtp_exp);=0A=
+		}=0A=
+	}=0A=
+=0A=
+	if (nated_port =3D=3D 0) {	/* No port available */=0A=
+		if (net_ratelimit())=0A=
+			printk("ip_nat_h323: out of RTP ports\n");=0A=
+		return 0;=0A=
+	}=0A=
+=0A=
+	/* Modify signal */=0A=
+	if (set_h245_addr(pskb, data, dataoff, addr,=0A=
+			  ct->tuplehash[!dir].tuple.dst.ip,=0A=
+			  (port & 1) ? nated_port + 1 : nated_port) =3D=3D 0) {=0A=
+		/* Save ports */=0A=
+		info->rtp_port[i][dir] =3D rtp_port;=0A=
+		info->rtp_port[i][!dir] =3D nated_port;=0A=
+	} else {=0A=
+		ip_conntrack_unexpect_related(rtp_exp);=0A=
+		ip_conntrack_unexpect_related(rtcp_exp);=0A=
+		return -1;=0A=
+	}=0A=
+=0A=
+	/* Success */=0A=
+	DEBUGP("ip_nat_h323: expect RTP %u.%u.%u.%u:%hu->%u.%u.%u.%u:%hu\n",=0A=
+	       NIPQUAD(rtp_exp->tuple.src.ip),=0A=
+	       ntohs(rtp_exp->tuple.src.u.udp.port),=0A=
+	       NIPQUAD(rtp_exp->tuple.dst.ip),=0A=
+	       ntohs(rtp_exp->tuple.dst.u.udp.port));=0A=
+	DEBUGP("ip_nat_h323: expect RTCP %u.%u.%u.%u:%hu->%u.%u.%u.%u:%hu\n",=0A=
+	       NIPQUAD(rtcp_exp->tuple.src.ip),=0A=
+	       ntohs(rtcp_exp->tuple.src.u.udp.port),=0A=
+	       NIPQUAD(rtcp_exp->tuple.dst.ip),=0A=
+	       ntohs(rtcp_exp->tuple.dst.u.udp.port));=0A=
+=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static int nat_t120(struct sk_buff **pskb, struct ip_conntrack *ct,=0A=
+		    enum ip_conntrack_info ctinfo,=0A=
+		    unsigned char **data, int dataoff,=0A=
+		    H245_TransportAddress * addr, u_int16_t port,=0A=
+		    struct ip_conntrack_expect *exp)=0A=
+{=0A=
+	int dir =3D CTINFO2DIR(ctinfo);=0A=
+	u_int16_t nated_port =3D port;=0A=
+=0A=
+	/* Set expectations for NAT */=0A=
+	exp->saved_proto.tcp.port =3D exp->tuple.dst.u.tcp.port;=0A=
+	exp->expectfn =3D ip_nat_follow_master;=0A=
+	exp->dir =3D !dir;=0A=
+=0A=
+	/* Try to get same port: if not, try to change it. */=0A=
+	for (; nated_port !=3D 0; nated_port++) {=0A=
+		exp->tuple.dst.u.tcp.port =3D htons(nated_port);=0A=
+		if (ip_conntrack_expect_related(exp) =3D=3D 0)=0A=
+			break;=0A=
+	}=0A=
+=0A=
+	if (nated_port =3D=3D 0) {	/* No port available */=0A=
+		if (net_ratelimit())=0A=
+			printk("ip_nat_h323: out of TCP ports\n");=0A=
+		return 0;=0A=
+	}=0A=
+=0A=
+	/* Modify signal */=0A=
+	if (set_h245_addr(pskb, data, dataoff, addr,=0A=
+			  ct->tuplehash[!dir].tuple.dst.ip, nated_port) < 0) {=0A=
+		ip_conntrack_unexpect_related(exp);=0A=
+		return -1;=0A=
+	}=0A=
+=0A=
+	DEBUGP("ip_nat_h323: expect T.120 %u.%u.%u.%u:%hu->%u.%u.%u.%u:%hu\n",=0A=
+	       NIPQUAD(exp->tuple.src.ip), ntohs(exp->tuple.src.u.tcp.port),=0A=
+	       NIPQUAD(exp->tuple.dst.ip), ntohs(exp->tuple.dst.u.tcp.port));=0A=
+=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****=0A=
+ * This conntrack expect function replaces ip_conntrack_h245_expect()=0A=
+ * which was set by ip_conntrack_helper_h323.c. It calls both=0A=
+ * ip_nat_follow_master() and ip_conntrack_h245_expect()=0A=
+ =
*************************************************************************=
***/=0A=
+static void ip_nat_h245_expect(struct ip_conntrack *new,=0A=
+			       struct ip_conntrack_expect *this)=0A=
+{=0A=
+	ip_nat_follow_master(new, this);=0A=
+	ip_conntrack_h245_expect(new, this);=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static int nat_h245(struct sk_buff **pskb, struct ip_conntrack *ct,=0A=
+		    enum ip_conntrack_info ctinfo,=0A=
+		    unsigned char **data, int dataoff,=0A=
+		    TransportAddress * addr, u_int16_t port,=0A=
+		    struct ip_conntrack_expect *exp)=0A=
+{=0A=
+	struct ip_ct_h323_master *info =3D &ct->help.ct_h323_info;=0A=
+	int dir =3D CTINFO2DIR(ctinfo);=0A=
+	u_int16_t nated_port =3D port;=0A=
+=0A=
+	/* Set expectations for NAT */=0A=
+	exp->saved_proto.tcp.port =3D exp->tuple.dst.u.tcp.port;=0A=
+	exp->expectfn =3D ip_nat_h245_expect;=0A=
+	exp->dir =3D !dir;=0A=
+=0A=
+	/* Check existing expects */=0A=
+	if (info->sig_port[dir] =3D=3D port)=0A=
+		nated_port =3D info->sig_port[!dir];=0A=
+=0A=
+	/* Try to get same port: if not, try to change it. */=0A=
+	for (; nated_port !=3D 0; nated_port++) {=0A=
+		exp->tuple.dst.u.tcp.port =3D htons(nated_port);=0A=
+		if (ip_conntrack_expect_related(exp) =3D=3D 0)=0A=
+			break;=0A=
+	}=0A=
+=0A=
+	if (nated_port =3D=3D 0) {	/* No port available */=0A=
+		if (net_ratelimit())=0A=
+			printk("ip_nat_q931: out of TCP ports\n");=0A=
+		return 0;=0A=
+	}=0A=
+=0A=
+	/* Modify signal */=0A=
+	if (set_h225_addr(pskb, data, dataoff, addr,=0A=
+			  ct->tuplehash[!dir].tuple.dst.ip,=0A=
+			  nated_port) =3D=3D 0) {=0A=
+		/* Save ports */=0A=
+		info->sig_port[dir] =3D port;=0A=
+		info->sig_port[!dir] =3D nated_port;=0A=
+	} else {=0A=
+		ip_conntrack_unexpect_related(exp);=0A=
+		return -1;=0A=
+	}=0A=
+=0A=
+	DEBUGP("ip_nat_q931: expect H.245 %u.%u.%u.%u:%hu->%u.%u.%u.%u:%hu\n",=0A=
+	       NIPQUAD(exp->tuple.src.ip), ntohs(exp->tuple.src.u.tcp.port),=0A=
+	       NIPQUAD(exp->tuple.dst.ip), ntohs(exp->tuple.dst.u.tcp.port));=0A=
+=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****=0A=
+ * This conntrack expect function replaces ip_conntrack_q931_expect()=0A=
+ * which was set by ip_conntrack_helper_h323.c.=0A=
+ =
*************************************************************************=
***/=0A=
+static void ip_nat_q931_expect(struct ip_conntrack *new,=0A=
+			       struct ip_conntrack_expect *this)=0A=
+{=0A=
+	struct ip_nat_range range;=0A=
+=0A=
+	if (this->tuple.src.ip !=3D 0) {	/* Only accept calls from GK */=0A=
+		ip_nat_follow_master(new, this);=0A=
+		goto out;=0A=
+	}=0A=
+=0A=
+	/* This must be a fresh one. */=0A=
+	BUG_ON(new->status & IPS_NAT_DONE_MASK);=0A=
+=0A=
+	/* Change src to where master sends to */=0A=
+	range.flags =3D IP_NAT_RANGE_MAP_IPS;=0A=
+	range.min_ip =3D range.max_ip =3D =
new->tuplehash[!this->dir].tuple.src.ip;=0A=
+=0A=
+	/* hook doesn't matter, but it has to do source manip */=0A=
+	ip_nat_setup_info(new, &range, NF_IP_POST_ROUTING);=0A=
+=0A=
+	/* For DST manip, map port here to where it's expected. */=0A=
+	range.flags =3D (IP_NAT_RANGE_MAP_IPS | IP_NAT_RANGE_PROTO_SPECIFIED);=0A=
+	range.min =3D range.max =3D this->saved_proto;=0A=
+	range.min_ip =3D range.max_ip =3D=0A=
+	    new->master->tuplehash[!this->dir].tuple.src.ip;=0A=
+=0A=
+	/* hook doesn't matter, but it has to do destination manip */=0A=
+	ip_nat_setup_info(new, &range, NF_IP_PRE_ROUTING);=0A=
+=0A=
+      out:=0A=
+	ip_conntrack_q931_expect(new, this);=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static int nat_q931(struct sk_buff **pskb, struct ip_conntrack *ct,=0A=
+		    enum ip_conntrack_info ctinfo,=0A=
+		    unsigned char **data, TransportAddress * addr, int idx,=0A=
+		    u_int16_t port, struct ip_conntrack_expect *exp)=0A=
+{=0A=
+	struct ip_ct_h323_master *info =3D &ct->help.ct_h323_info;=0A=
+	int dir =3D CTINFO2DIR(ctinfo);=0A=
+	u_int16_t nated_port =3D port;=0A=
+	u_int32_t ip;=0A=
+=0A=
+	/* Set expectations for NAT */=0A=
+	exp->saved_proto.tcp.port =3D exp->tuple.dst.u.tcp.port;=0A=
+	exp->expectfn =3D ip_nat_q931_expect;=0A=
+	exp->dir =3D !dir;=0A=
+=0A=
+	/* Check existing expects */=0A=
+	if (info->sig_port[dir] =3D=3D port)=0A=
+		nated_port =3D info->sig_port[!dir];=0A=
+=0A=
+	/* Try to get same port: if not, try to change it. */=0A=
+	for (; nated_port !=3D 0; nated_port++) {=0A=
+		exp->tuple.dst.u.tcp.port =3D htons(nated_port);=0A=
+		if (ip_conntrack_expect_related(exp) =3D=3D 0)=0A=
+			break;=0A=
+	}=0A=
+=0A=
+	if (nated_port =3D=3D 0) {	/* No port available */=0A=
+		if (net_ratelimit())=0A=
+			printk("ip_nat_ras: out of TCP ports\n");=0A=
+		return 0;=0A=
+	}=0A=
+=0A=
+	/* Modify signal */=0A=
+	if (set_h225_addr(pskb, data, 0, &addr[idx],=0A=
+			  ct->tuplehash[!dir].tuple.dst.ip,=0A=
+			  nated_port) =3D=3D 0) {=0A=
+		/* Save ports */=0A=
+		info->sig_port[dir] =3D port;=0A=
+		info->sig_port[!dir] =3D nated_port;=0A=
+=0A=
+		/* Fix for Gnomemeeting */=0A=
+		if (idx > 0 &&=0A=
+		    get_h225_addr(*data, &addr[0], &ip, &port) &&=0A=
+		    (ntohl(ip) & 0xff000000) =3D=3D 0x7f000000) {=0A=
+			set_h225_addr_hook(pskb, data, 0, &addr[0],=0A=
+					   ct->tuplehash[!dir].tuple.dst.ip,=0A=
+					   info->sig_port[!dir]);=0A=
+		}=0A=
+	} else {=0A=
+		ip_conntrack_unexpect_related(exp);=0A=
+		return -1;=0A=
+	}=0A=
+=0A=
+	/* Success */=0A=
+	DEBUGP("ip_nat_ras: expect Q.931 %u.%u.%u.%u:%hu->%u.%u.%u.%u:%hu\n",=0A=
+	       NIPQUAD(exp->tuple.src.ip), ntohs(exp->tuple.src.u.tcp.port),=0A=
+	       NIPQUAD(exp->tuple.dst.ip), ntohs(exp->tuple.dst.u.tcp.port));=0A=
+=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static int __init init(void)=0A=
+{=0A=
+	BUG_ON(set_h245_addr_hook !=3D NULL);=0A=
+	BUG_ON(set_h225_addr_hook !=3D NULL);=0A=
+	BUG_ON(set_sig_addr_hook !=3D NULL);=0A=
+	BUG_ON(set_ras_addr_hook !=3D NULL);=0A=
+	BUG_ON(nat_rtp_rtcp_hook !=3D NULL);=0A=
+	BUG_ON(nat_t120_hook !=3D NULL);=0A=
+	BUG_ON(nat_h245_hook !=3D NULL);=0A=
+	BUG_ON(nat_q931_hook !=3D NULL);=0A=
+=0A=
+	set_h245_addr_hook =3D set_h245_addr;=0A=
+	set_h225_addr_hook =3D set_h225_addr;=0A=
+	set_sig_addr_hook =3D set_sig_addr;=0A=
+	set_ras_addr_hook =3D set_ras_addr;=0A=
+	nat_rtp_rtcp_hook =3D nat_rtp_rtcp;=0A=
+	nat_t120_hook =3D nat_t120;=0A=
+	nat_h245_hook =3D nat_h245;=0A=
+	nat_q931_hook =3D nat_q931;=0A=
+=0A=
+	DEBUGP("ip_nat_h323: init success\n");=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static void __exit fini(void)=0A=
+{=0A=
+	set_h245_addr_hook =3D NULL;=0A=
+	set_h225_addr_hook =3D NULL;=0A=
+	set_sig_addr_hook =3D NULL;=0A=
+	set_ras_addr_hook =3D NULL;=0A=
+	nat_rtp_rtcp_hook =3D NULL;=0A=
+	nat_t120_hook =3D NULL;=0A=
+	nat_h245_hook =3D NULL;=0A=
+	nat_q931_hook =3D NULL;=0A=
+	synchronize_net();=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+module_init(init);=0A=
+module_exit(fini);=0A=
+=0A=
+MODULE_AUTHOR("Jing Min Zhao <zhaojingmin@users.sourceforge.net>");=0A=
+MODULE_DESCRIPTION("H.323 NAT helper");=0A=
+MODULE_LICENSE("GPL");=0A=
diff -pruN linux-2.6.15.orig/net/ipv4/netfilter/Kconfig =
linux-2.6.15/net/ipv4/netfilter/Kconfig=0A=
--- linux-2.6.15.orig/net/ipv4/netfilter/Kconfig	2006-01-02 =
22:21:10.000000000 -0500=0A=
+++ linux-2.6.15/net/ipv4/netfilter/Kconfig	2006-03-15 =
19:30:15.000000000 -0500=0A=
@@ -168,6 +168,26 @@ config IP_NF_PPTP=0A=
 	  If you want to compile it as a module, say M here and read=0A=
 	  Documentation/modules.txt.  If unsure, say `N'.=0A=
 =0A=
+config IP_NF_H323=0A=
+	tristate  'H.323 protocol support'=0A=
+	depends on IP_NF_CONNTRACK=0A=
+	help=0A=
+	  H.323 is a VoIP signalling protocol from ITU-T. As one of the most=0A=
+	  important VoIP protocols, it is widely used by voice hardware and=0A=
+	  software including voice gateways, IP phones, Netmeeting, OpenPhone,=0A=
+	  Gnomemeeting, etc. =0A=
+	  =0A=
+	  With this module you can support H.323 on a connection tracking/NAT=0A=
+	  firewall.=0A=
+=0A=
+	  This module supports RAS, Fast-start, H.245 tunnelling, RTP/RTCP =0A=
+	  and T.120 based data and applications including audio, video, FAX, =0A=
+	  chat, whiteboard, file transfer, etc. For more information, please =0A=
+	  see http://nath323.sourceforge.net/.=0A=
+	=0A=
+	  If you want to compile it as a module, say 'M' here and read=0A=
+	  Documentation/modules.txt.  If unsure, say 'N'.=0A=
+=0A=
 config IP_NF_QUEUE=0A=
 	tristate "IP Userspace queueing via NETLINK (OBSOLETE)"=0A=
 	help=0A=
@@ -679,6 +699,12 @@ config IP_NF_NAT_PPTP=0A=
 	default IP_NF_NAT if IP_NF_PPTP=3Dy=0A=
 	default m if IP_NF_PPTP=3Dm=0A=
 =0A=
+config IP_NF_NAT_H323=0A=
+	tristate=0A=
+	depends on IP_NF_IPTABLES!=3Dn && IP_NF_CONNTRACK!=3Dn && =
IP_NF_NAT!=3Dn=0A=
+	default IP_NF_NAT if IP_NF_H323=3Dy=0A=
+	default m if IP_NF_H323=3Dm=0A=
+=0A=
 # mangle + specific targets=0A=
 config IP_NF_MANGLE=0A=
 	tristate "Packet mangling"=0A=
diff -pruN linux-2.6.15.orig/net/ipv4/netfilter/Makefile =
linux-2.6.15/net/ipv4/netfilter/Makefile=0A=
--- linux-2.6.15.orig/net/ipv4/netfilter/Makefile	2006-01-02 =
22:21:10.000000000 -0500=0A=
+++ linux-2.6.15/net/ipv4/netfilter/Makefile	2006-03-15 =
19:30:17.000000000 -0500=0A=
@@ -10,6 +10,9 @@ iptable_nat-objs	:=3D ip_nat_rule.o ip_nat=0A=
 ip_conntrack_pptp-objs	:=3D ip_conntrack_helper_pptp.o =
ip_conntrack_proto_gre.o=0A=
 ip_nat_pptp-objs	:=3D ip_nat_helper_pptp.o ip_nat_proto_gre.o=0A=
 =0A=
+ip_conntrack_h323-objs :=3D ip_conntrack_helper_h323.o =
ip_conntrack_helper_h323_asn1.o=0A=
+ip_nat_h323-objs :=3D ip_nat_helper_h323.o=0A=
+=0A=
 # connection tracking=0A=
 obj-$(CONFIG_IP_NF_CONNTRACK) +=3D ip_conntrack.o=0A=
 obj-$(CONFIG_IP_NF_NAT) +=3D ip_nat.o=0A=
@@ -22,6 +25,7 @@ obj-$(CONFIG_IP_NF_CONNTRACK_NETLINK) +=3D=0A=
 obj-$(CONFIG_IP_NF_CT_PROTO_SCTP) +=3D ip_conntrack_proto_sctp.o=0A=
 =0A=
 # connection tracking helpers=0A=
+obj-$(CONFIG_IP_NF_H323) +=3D ip_conntrack_h323.o=0A=
 obj-$(CONFIG_IP_NF_PPTP) +=3D ip_conntrack_pptp.o=0A=
 obj-$(CONFIG_IP_NF_AMANDA) +=3D ip_conntrack_amanda.o=0A=
 obj-$(CONFIG_IP_NF_TFTP) +=3D ip_conntrack_tftp.o=0A=
@@ -30,6 +34,7 @@ obj-$(CONFIG_IP_NF_IRC) +=3D ip_conntrack_=0A=
 obj-$(CONFIG_IP_NF_NETBIOS_NS) +=3D ip_conntrack_netbios_ns.o=0A=
 =0A=
 # NAT helpers =0A=
+obj-$(CONFIG_IP_NF_NAT_H323) +=3D ip_nat_h323.o=0A=
 obj-$(CONFIG_IP_NF_NAT_PPTP) +=3D ip_nat_pptp.o=0A=
 obj-$(CONFIG_IP_NF_NAT_AMANDA) +=3D ip_nat_amanda.o=0A=
 obj-$(CONFIG_IP_NF_NAT_TFTP) +=3D ip_nat_tftp.o=0A=

------=_NextPart_000_0022_01C649A9.019ACA20--
