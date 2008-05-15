From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ULOGD 3/4] cleanup for key builder and fix IPv6 support
Date: Thu, 15 May 2008 15:50:20 +0200
Message-ID: <482C3F9C.3000903@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000706010501070703050008"
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51672 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751882AbYEONu2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 May 2008 09:50:28 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000706010501070703050008
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

This patch cleans up the key building by breaking lines at 80 columns
and it fixes the IPv6 support (use of a pointer after free) by
introducing a new 128 bit type.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------000706010501070703050008
Content-Type: text/x-patch;
 name="02cleanup.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02cleanup.patch"

[PATCH] cleanup for key builder and fix IPv6 support

This patch cleans up the key building by breaking lines at 80 columns and
it fixes the IPv6 support (use of a pointer after free) by introducing a new
128 bit type.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: ulogd2/input/flow/ulogd_inpflow_NFCT.c
===================================================================
--- ulogd2.orig/input/flow/ulogd_inpflow_NFCT.c	2008-05-14 13:49:53.000000000 +0200
+++ ulogd2/input/flow/ulogd_inpflow_NFCT.c	2008-05-14 13:50:59.000000000 +0200
@@ -453,77 +453,112 @@ static int propagate_ct(struct ulogd_plu
 	ret[NFCT_OOB_PROTOCOL].flags |= ULOGD_RETF_VALID;
 
 	switch (nfct_get_attr_u8(ct, ATTR_L3PROTO)) {
-		case AF_INET:
-			ret[NFCT_ORIG_IP_SADDR].u.value.ui32 = nfct_get_attr_u32(ct, ATTR_ORIG_IPV4_SRC);
-			ret[NFCT_ORIG_IP_SADDR].flags |= ULOGD_RETF_VALID;
-			ret[NFCT_ORIG_IP_DADDR].u.value.ui32 = nfct_get_attr_u32(ct, ATTR_ORIG_IPV4_DST);
-			ret[NFCT_ORIG_IP_DADDR].flags |= ULOGD_RETF_VALID;
-
-			ret[NFCT_REPLY_IP_SADDR].u.value.ui32 = nfct_get_attr_u32(ct, ATTR_REPL_IPV4_SRC);
-			ret[NFCT_REPLY_IP_SADDR].flags |= ULOGD_RETF_VALID;
-			ret[NFCT_REPLY_IP_DADDR].u.value.ui32 = nfct_get_attr_u32(ct, ATTR_REPL_IPV4_DST);
-			ret[NFCT_REPLY_IP_DADDR].flags |= ULOGD_RETF_VALID;
+	case AF_INET:
+		ret[NFCT_ORIG_IP_SADDR].u.value.ui32 =
+			nfct_get_attr_u32(ct, ATTR_ORIG_IPV4_SRC);
+		ret[NFCT_ORIG_IP_SADDR].flags |= ULOGD_RETF_VALID;
+
+		ret[NFCT_ORIG_IP_DADDR].u.value.ui32 =
+			nfct_get_attr_u32(ct, ATTR_ORIG_IPV4_DST);
+		ret[NFCT_ORIG_IP_DADDR].flags |= ULOGD_RETF_VALID;
+
+		ret[NFCT_REPLY_IP_SADDR].u.value.ui32 =
+			nfct_get_attr_u32(ct, ATTR_REPL_IPV4_SRC);
+		ret[NFCT_REPLY_IP_SADDR].flags |= ULOGD_RETF_VALID;
+
+		ret[NFCT_REPLY_IP_DADDR].u.value.ui32 =
+			nfct_get_attr_u32(ct, ATTR_REPL_IPV4_DST);
+		ret[NFCT_REPLY_IP_DADDR].flags |= ULOGD_RETF_VALID;
 
-			break;
-		case AF_INET6:
-			ret[NFCT_ORIG_IP_SADDR].u.value.ptr = (struct in6_addr *)nfct_get_attr(ct, ATTR_ORIG_IPV6_SRC);
-			ret[NFCT_ORIG_IP_SADDR].flags |= ULOGD_RETF_VALID;
-			ret[NFCT_ORIG_IP_DADDR].u.value.ptr = (struct in6_addr *)nfct_get_attr(ct, ATTR_ORIG_IPV6_DST);
-			ret[NFCT_ORIG_IP_DADDR].flags |= ULOGD_RETF_VALID;
-
-			ret[NFCT_REPLY_IP_SADDR].u.value.ptr = (struct in6_addr *)nfct_get_attr(ct, ATTR_REPL_IPV6_SRC);
-			ret[NFCT_REPLY_IP_SADDR].flags |= ULOGD_RETF_VALID;
-			ret[NFCT_REPLY_IP_DADDR].u.value.ptr = (struct in6_addr *)nfct_get_attr(ct, ATTR_REPL_IPV6_DST);
-			ret[NFCT_REPLY_IP_DADDR].flags |= ULOGD_RETF_VALID;
+		break;
+	case AF_INET6:
+		memcpy(ret[NFCT_ORIG_IP_SADDR].u.value.ui128,
+		       nfct_get_attr(ct, ATTR_ORIG_IPV6_SRC),
+		       sizeof(int32_t) * 4);
+		ret[NFCT_ORIG_IP_SADDR].flags |= ULOGD_RETF_VALID;
+
+		memcpy(ret[NFCT_ORIG_IP_DADDR].u.value.ui128,
+		       nfct_get_attr(ct, ATTR_ORIG_IPV6_DST),
+		       sizeof(int32_t) * 4);
+		ret[NFCT_ORIG_IP_DADDR].flags |= ULOGD_RETF_VALID;
+
+		memcpy(ret[NFCT_REPLY_IP_SADDR].u.value.ui128,
+		       nfct_get_attr(ct, ATTR_REPL_IPV6_SRC),
+		       sizeof(int32_t) * 4);
+		ret[NFCT_REPLY_IP_SADDR].flags |= ULOGD_RETF_VALID;
+
+		memcpy(ret[NFCT_REPLY_IP_DADDR].u.value.ui128,
+		       nfct_get_attr(ct, ATTR_REPL_IPV6_DST),
+		       sizeof(int32_t) * 4);
+		ret[NFCT_REPLY_IP_DADDR].flags |= ULOGD_RETF_VALID;
 
-			break;
-		default:
-			ulogd_log(ULOGD_NOTICE, "Unknown protocol family (%d)\n",
-				  nfct_get_attr_u8(ct, ATTR_L3PROTO));
+		break;
+	default:
+		ulogd_log(ULOGD_NOTICE, "Unknown protocol family (%d)\n",
+			  nfct_get_attr_u8(ct, ATTR_L3PROTO));
 	}
-	ret[NFCT_ORIG_IP_PROTOCOL].u.value.ui8 = nfct_get_attr_u8(ct, ATTR_ORIG_L4PROTO);
+	ret[NFCT_ORIG_IP_PROTOCOL].u.value.ui8 =
+		nfct_get_attr_u8(ct, ATTR_ORIG_L4PROTO);
 	ret[NFCT_ORIG_IP_PROTOCOL].flags |= ULOGD_RETF_VALID;
-	ret[NFCT_REPLY_IP_PROTOCOL].u.value.ui8 = nfct_get_attr_u8(ct, ATTR_REPL_L4PROTO);
+
+	ret[NFCT_REPLY_IP_PROTOCOL].u.value.ui8 =
+		nfct_get_attr_u8(ct, ATTR_REPL_L4PROTO);
 	ret[NFCT_REPLY_IP_PROTOCOL].flags |= ULOGD_RETF_VALID;
 
 	switch (nfct_get_attr_u8(ct, ATTR_ORIG_L4PROTO)) {
 	case IPPROTO_TCP:
 	case IPPROTO_UDP:
+	case IPPROTO_UDPLITE:
 	case IPPROTO_SCTP:
-		/* FIXME: DCCP */
-		ret[NFCT_ORIG_L4_SPORT].u.value.ui16 = htons(nfct_get_attr_u16(ct, ATTR_ORIG_PORT_SRC));
+	case IPPROTO_DCCP:
+		ret[NFCT_ORIG_L4_SPORT].u.value.ui16 =
+			htons(nfct_get_attr_u16(ct, ATTR_ORIG_PORT_SRC));
 		ret[NFCT_ORIG_L4_SPORT].flags |= ULOGD_RETF_VALID;
-		ret[NFCT_ORIG_L4_DPORT].u.value.ui16 = htons(nfct_get_attr_u16(ct, ATTR_ORIG_PORT_DST));
+
+		ret[NFCT_ORIG_L4_DPORT].u.value.ui16 =
+			htons(nfct_get_attr_u16(ct, ATTR_ORIG_PORT_DST));
 		ret[NFCT_ORIG_L4_DPORT].flags |= ULOGD_RETF_VALID;
 		break;
 	case IPPROTO_ICMP:
-		ret[NFCT_ICMP_CODE].u.value.ui8 = nfct_get_attr_u8(ct, ATTR_ICMP_CODE);
+		ret[NFCT_ICMP_CODE].u.value.ui8 =
+			nfct_get_attr_u8(ct, ATTR_ICMP_CODE);
 		ret[NFCT_ICMP_CODE].flags |= ULOGD_RETF_VALID;
-		ret[NFCT_ICMP_TYPE].u.value.ui8 = nfct_get_attr_u8(ct, ATTR_ICMP_TYPE);
+
+		ret[NFCT_ICMP_TYPE].u.value.ui8 =
+			nfct_get_attr_u8(ct, ATTR_ICMP_TYPE);
 		ret[NFCT_ICMP_TYPE].flags |= ULOGD_RETF_VALID;
 		break;
 	}
 
 	switch (nfct_get_attr_u8(ct, ATTR_REPL_L4PROTO)) {
-		case IPPROTO_TCP:
-		case IPPROTO_UDP:
-		case IPPROTO_SCTP:
-			ret[NFCT_REPLY_L4_SPORT].u.value.ui16 = htons(nfct_get_attr_u16(ct, ATTR_REPL_PORT_SRC));
-			ret[NFCT_REPLY_L4_SPORT].flags |= ULOGD_RETF_VALID;
-			ret[NFCT_REPLY_L4_DPORT].u.value.ui16 = htons(nfct_get_attr_u16(ct, ATTR_REPL_PORT_DST));
-			ret[NFCT_REPLY_L4_DPORT].flags |= ULOGD_RETF_VALID;
+	case IPPROTO_TCP:
+	case IPPROTO_UDP:
+	case IPPROTO_UDPLITE:
+	case IPPROTO_SCTP:
+	case IPPROTO_DCCP:
+		ret[NFCT_REPLY_L4_SPORT].u.value.ui16 =
+			htons(nfct_get_attr_u16(ct, ATTR_REPL_PORT_SRC));
+		ret[NFCT_REPLY_L4_SPORT].flags |= ULOGD_RETF_VALID;
+
+		ret[NFCT_REPLY_L4_DPORT].u.value.ui16 =
+			htons(nfct_get_attr_u16(ct, ATTR_REPL_PORT_DST));
+		ret[NFCT_REPLY_L4_DPORT].flags |= ULOGD_RETF_VALID;
 	}
 
-	ret[NFCT_ORIG_RAW_PKTLEN].u.value.ui32 = nfct_get_attr_u32(ct, ATTR_ORIG_COUNTER_BYTES);
+	ret[NFCT_ORIG_RAW_PKTLEN].u.value.ui32 =
+		nfct_get_attr_u32(ct, ATTR_ORIG_COUNTER_BYTES);
 	ret[NFCT_ORIG_RAW_PKTLEN].flags |= ULOGD_RETF_VALID;
 
-	ret[NFCT_ORIG_RAW_PKTCOUNT].u.value.ui32 = nfct_get_attr_u32(ct, ATTR_ORIG_COUNTER_PACKETS);
+	ret[NFCT_ORIG_RAW_PKTCOUNT].u.value.ui32 =
+		nfct_get_attr_u32(ct, ATTR_ORIG_COUNTER_PACKETS);
 	ret[NFCT_ORIG_RAW_PKTCOUNT].flags |= ULOGD_RETF_VALID;
 
-	ret[NFCT_REPLY_RAW_PKTLEN].u.value.ui32 = nfct_get_attr_u32(ct, ATTR_REPL_COUNTER_BYTES);;
+	ret[NFCT_REPLY_RAW_PKTLEN].u.value.ui32 =
+		nfct_get_attr_u32(ct, ATTR_REPL_COUNTER_BYTES);;
 	ret[NFCT_REPLY_RAW_PKTLEN].flags |= ULOGD_RETF_VALID;
 
-	ret[NFCT_REPLY_RAW_PKTCOUNT].u.value.ui32 = nfct_get_attr_u32(ct, ATTR_REPL_COUNTER_PACKETS);
+	ret[NFCT_REPLY_RAW_PKTCOUNT].u.value.ui32 =
+		nfct_get_attr_u32(ct, ATTR_REPL_COUNTER_PACKETS);
 	ret[NFCT_REPLY_RAW_PKTCOUNT].flags |= ULOGD_RETF_VALID;
 
 	ret[NFCT_CT_MARK].u.value.ui32 = nfct_get_attr_u32(ct, ATTR_MARK);
@@ -535,10 +570,13 @@ static int propagate_ct(struct ulogd_plu
 	if (ts) {
 		ret[NFCT_FLOW_START_SEC].u.value.ui32 = ts->time[START].tv_sec;
 		ret[NFCT_FLOW_START_SEC].flags |= ULOGD_RETF_VALID;
+
 		ret[NFCT_FLOW_START_USEC].u.value.ui32 = ts->time[START].tv_usec;
 		ret[NFCT_FLOW_START_USEC].flags |= ULOGD_RETF_VALID;
+
 		ret[NFCT_FLOW_END_SEC].u.value.ui32 = ts->time[STOP].tv_sec;
 		ret[NFCT_FLOW_END_SEC].flags |= ULOGD_RETF_VALID;
+
 		ret[NFCT_FLOW_END_USEC].u.value.ui32 = ts->time[STOP].tv_usec;
 		ret[NFCT_FLOW_END_USEC].flags |= ULOGD_RETF_VALID;
 	}
Index: ulogd2/include/ulogd/ulogd.h
===================================================================
--- ulogd2.orig/include/ulogd/ulogd.h	2008-05-14 13:49:53.000000000 +0200
+++ ulogd2/include/ulogd/ulogd.h	2008-05-14 13:50:59.000000000 +0200
@@ -105,10 +105,12 @@ struct ulogd_key {
 			u_int16_t	ui16;
 			u_int32_t	ui32;
 			u_int64_t	ui64;
+			u_int32_t	ui128[4];
 			int8_t		i8;
 			int16_t		i16;
 			int32_t		i32;
 			int64_t		i64;
+			int32_t		i128[4];
 			void		*ptr;
 		} value;
 		struct ulogd_key *source;
@@ -252,4 +254,16 @@ int ulogd_select_main(struct timeval *tv
  ***********************************************************************/
 #include <ulogd/timer.h>
 
+/***********************************************************************
+ * other declarations
+ ***********************************************************************/
+
+#ifndef IPPROTO_DCCP
+#define IPPROTO_DCCP 33
+#endif
+
+#ifndef IPPROTO_UDPLITE
+#define IPPROTO_UDPLITE 136
+#endif
+
 #endif /* _ULOGD_H */

--------------000706010501070703050008--
