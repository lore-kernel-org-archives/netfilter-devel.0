From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 6/6] ulogd: use snprintf instead of sprintf in printpkt
Date: Wed, 22 Sep 2010 02:47:22 +0200
Message-ID: <1285116442-32490-7-git-send-email-eric@inl.fr>
References: <1285116442-32490-1-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:33898 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755587Ab0IVAzE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Sep 2010 20:55:04 -0400
In-Reply-To: <1285116442-32490-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch modifies printpkt to use snprintf instead of sprintf.
As the buffer size is arbitrary fixed and as printed part include
some user entry it is safer to use snprintf.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 filter/ulogd_filter_PRINTPKT.c |    4 +-
 include/ulogd/printpkt.h       |    3 +-
 util/printpkt.c                |  166 +++++++++++++++++++++-------------------
 3 files changed, 91 insertions(+), 82 deletions(-)

diff --git a/filter/ulogd_filter_PRINTPKT.c b/filter/ulogd_filter_PRINTPKT.c
index 3313194..16a4741 100644
--- a/filter/ulogd_filter_PRINTPKT.c
+++ b/filter/ulogd_filter_PRINTPKT.c
@@ -34,9 +34,9 @@ static int printpkt_interp(struct ulogd_pluginstance *upi)
 {
 	struct ulogd_key *inp = upi->input.keys;
 	struct ulogd_key *ret = upi->output.keys;
-	static char buf[4096];
+	static char buf[PRINTPKT_BUF_SIZE];
 
-	printpkt_print(inp, buf);
+	printpkt_print(inp, buf, PRINTPKT_BUF_SIZE);
 	okey_set_ptr(&ret[0], buf);
 	return ULOGD_IRET_OK;
 }
diff --git a/include/ulogd/printpkt.h b/include/ulogd/printpkt.h
index a11ce4a..882dbf5 100644
--- a/include/ulogd/printpkt.h
+++ b/include/ulogd/printpkt.h
@@ -67,8 +67,9 @@ enum pkt_keys {
 };
 #define PRINTPKT_KEYS (__PRINTPKT_KEYS)
 
+#define PRINTPKT_BUF_SIZE 4096
 extern struct ulogd_key printpkt_keys[PRINTPKT_KEYS];
 
-int printpkt_print(struct ulogd_key *res, char *buf);
+int printpkt_print(struct ulogd_key *res, char *buf, size_t bufsiz);
 
 #endif
diff --git a/util/printpkt.c b/util/printpkt.c
index 5250792..a800555 100644
--- a/util/printpkt.c
+++ b/util/printpkt.c
@@ -106,91 +106,93 @@ struct ulogd_key printpkt_keys[] = {
 	[KEY_SCTP_DPORT]	= { .name = "sctp.dport", },
 };
 
-static int printpkt_proto(struct ulogd_key *res, char *buf, int protocol)
+static int printpkt_proto(struct ulogd_key *res, char *buf, size_t bufsiz, int protocol)
 {
 	char *buf_cur = buf;
+	char *end_buf = buf + bufsiz;
+
 
 	switch (protocol) {
 	case IPPROTO_TCP:
-		buf_cur += sprintf(buf_cur, "PROTO=TCP ");
+		buf_cur += snprintf(buf_cur, bufsiz, "PROTO=TCP ");
 
 		if (!pp_is_valid(res, KEY_TCP_SPORT)) {
-			buf_cur += sprintf(buf_cur, "INCOMPLETE");
+			buf_cur += snprintf(buf_cur, end_buf - buf_cur, "INCOMPLETE");
 			break;
 		}
 
-		buf_cur += sprintf(buf_cur, "SPT=%u DPT=%u ",
+		buf_cur += snprintf(buf_cur, end_buf - buf_cur, "SPT=%u DPT=%u ",
 				   ikey_get_u16(&res[KEY_TCP_SPORT]),
 				   ikey_get_u16(&res[KEY_TCP_DPORT]));
 		/* FIXME: config */
-		buf_cur += sprintf(buf_cur, "SEQ=%u ACK=%u ",
+		buf_cur += snprintf(buf_cur, end_buf - buf_cur, "SEQ=%u ACK=%u ",
 				   ikey_get_u32(&res[KEY_TCP_SEQ]),
 				   ikey_get_u32(&res[KEY_TCP_ACKSEQ]));
 
-		buf_cur += sprintf(buf_cur, "WINDOW=%u ",
+		buf_cur += snprintf(buf_cur, end_buf - buf_cur, "WINDOW=%u ",
 				   ikey_get_u16(&res[KEY_TCP_WINDOW]));
 
 //		buf_cur += sprintf(buf_cur, "RES=0x%02x ", 
 		
 		if (ikey_get_u8(&res[KEY_TCP_URG]))
-			buf_cur += sprintf(buf_cur, "URG ");
+			buf_cur += snprintf(buf_cur, end_buf - buf_cur, "URG ");
 
 		if (ikey_get_u8(&res[KEY_TCP_ACK]))
-			buf_cur += sprintf(buf_cur, "ACK ");
+			buf_cur += snprintf(buf_cur, end_buf - buf_cur, "ACK ");
 
 		if (ikey_get_u8(&res[KEY_TCP_PSH]))
-			buf_cur += sprintf(buf_cur, "PSH ");
+			buf_cur += snprintf(buf_cur, end_buf - buf_cur, "PSH ");
 
 		if (ikey_get_u8(&res[KEY_TCP_RST]))
-			buf_cur += sprintf(buf_cur, "RST ");
+			buf_cur += snprintf(buf_cur, end_buf - buf_cur, "RST ");
 
 		if (ikey_get_u8(&res[KEY_TCP_SYN]))
-			buf_cur += sprintf(buf_cur, "SYN ");
+			buf_cur += snprintf(buf_cur, end_buf - buf_cur, "SYN ");
 
 		if (ikey_get_u8(&res[KEY_TCP_FIN]))
-			buf_cur += sprintf(buf_cur, "FIN ");
+			buf_cur += snprintf(buf_cur, end_buf - buf_cur, "FIN ");
 
-		buf_cur += sprintf(buf_cur, "URGP=%u ",
+		buf_cur += snprintf(buf_cur, end_buf - buf_cur, "URGP=%u ",
 				   ikey_get_u16(&res[KEY_TCP_URGP]));
 
 		break;
 
 	case IPPROTO_UDP:
-		buf_cur += sprintf(buf_cur, "PROTO=UDP ");
+		buf_cur += snprintf(buf_cur, end_buf - buf_cur, "PROTO=UDP ");
 
 		if (!pp_is_valid(res, KEY_UDP_SPORT)) {
-			buf_cur += sprintf(buf_cur, "INCOMPLETE");
+			buf_cur += snprintf(buf_cur, end_buf - buf_cur, "INCOMPLETE");
 			break;
 		}
 
-		buf_cur += sprintf(buf_cur, "SPT=%u DPT=%u LEN=%u ", 
+		buf_cur += snprintf(buf_cur, end_buf - buf_cur, "SPT=%u DPT=%u LEN=%u ", 
 				   ikey_get_u16(&res[KEY_UDP_SPORT]),
 				   ikey_get_u16(&res[KEY_UDP_DPORT]), 
 				   ikey_get_u16(&res[KEY_UDP_LEN]));
 		break;
 	case IPPROTO_SCTP:
-		buf_cur += sprintf(buf_cur, "PROTO=SCTP ");
+		buf_cur += snprintf(buf_cur, end_buf - buf_cur, "PROTO=SCTP ");
 
 		if (!pp_is_valid(res, KEY_SCTP_SPORT)) {
-			buf_cur += sprintf(buf_cur, "INCOMPLETE");
+			buf_cur += snprintf(buf_cur, end_buf - buf_cur, "INCOMPLETE");
 			break;
 		}
 
-		buf_cur += sprintf(buf_cur, "SPT=%u DPT=%u ", 
+		buf_cur += snprintf(buf_cur, end_buf - buf_cur, "SPT=%u DPT=%u ", 
 				   ikey_get_u16(&res[KEY_SCTP_SPORT]),
 				   ikey_get_u16(&res[KEY_SCTP_DPORT]));
 		break;
 	case IPPROTO_ESP:
 	case IPPROTO_AH:
-		buf_cur += sprintf(buf_cur, "PROTO=%s ",
+		buf_cur += snprintf(buf_cur, end_buf - buf_cur, "PROTO=%s ",
 				   ikey_get_u8(&res[KEY_IP_PROTOCOL]) == IPPROTO_ESP ? "ESP" : "AH");
 
 		if (!pp_is_valid(res, KEY_AHESP_SPI)) {
-			buf_cur += sprintf(buf_cur, "INCOMPLETE");
+			buf_cur += snprintf(buf_cur, end_buf - buf_cur, "INCOMPLETE");
 			break;
 		}
 
-		buf_cur += sprintf(buf_cur, "SPI=0x%x ",
+		buf_cur += snprintf(buf_cur, end_buf - buf_cur, "SPI=0x%x ",
 				   ikey_get_u32(&res[KEY_AHESP_SPI]));
 		break;
 	}
@@ -198,22 +200,23 @@ static int printpkt_proto(struct ulogd_key *res, char *buf, int protocol)
 	return buf_cur - buf;
 }
 
-static int printpkt_ipv4(struct ulogd_key *res, char *buf)
+static int printpkt_ipv4(struct ulogd_key *res, char *buf, size_t bufsiz)
 {
 	char *buf_cur = buf;
+	char *end_buf = buf + bufsiz;
 	char tmp[INET_ADDRSTRLEN];
 	u_int32_t paddr;
 
 	if (pp_is_valid(res, KEY_IP_SADDR))
-		buf_cur += sprintf(buf_cur, "SRC=%s ",
+		buf_cur += snprintf(buf_cur, end_buf - buf_cur, "SRC=%s ",
 				   (char *) ikey_get_ptr(&res[KEY_IP_SADDR]));
 
 	if (pp_is_valid(res, KEY_IP_DADDR))
-		buf_cur += sprintf(buf_cur, "DST=%s ",
+		buf_cur += snprintf(buf_cur, end_buf - buf_cur, "DST=%s ",
 				   (char *) ikey_get_ptr(&res[KEY_IP_DADDR]));
 
 	/* FIXME: add pp_is_valid calls to remainder of file */
-	buf_cur += sprintf(buf_cur,"LEN=%u TOS=%02X PREC=0x%02X TTL=%u ID=%u ", 
+	buf_cur += snprintf(buf_cur, end_buf - buf_cur,"LEN=%u TOS=%02X PREC=0x%02X TTL=%u ID=%u ", 
 			   ikey_get_u16(&res[KEY_IP_TOTLEN]),
 			   ikey_get_u8(&res[KEY_IP_TOS]) & IPTOS_TOS_MASK, 
 			   ikey_get_u8(&res[KEY_IP_TOS]) & IPTOS_PREC_MASK,
@@ -221,16 +224,16 @@ static int printpkt_ipv4(struct ulogd_key *res, char *buf)
 			   ikey_get_u16(&res[KEY_IP_ID]));
 
 	if (ikey_get_u16(&res[KEY_IP_FRAGOFF]) & IP_RF) 
-		buf_cur += sprintf(buf_cur, "CE ");
+		buf_cur += snprintf(buf_cur, end_buf - buf_cur, "CE ");
 
 	if (ikey_get_u16(&res[KEY_IP_FRAGOFF]) & IP_DF)
-		buf_cur += sprintf(buf_cur, "DF ");
+		buf_cur += snprintf(buf_cur, end_buf - buf_cur, "DF ");
 
 	if (ikey_get_u16(&res[KEY_IP_FRAGOFF]) & IP_MF)
-		buf_cur += sprintf(buf_cur, "MF ");
+		buf_cur += snprintf(buf_cur, end_buf - buf_cur, "MF ");
 
 	if (ikey_get_u16(&res[KEY_IP_FRAGOFF]) & IP_OFFMASK)
-		buf_cur += sprintf(buf_cur, "FRAG:%u ", 
+		buf_cur += snprintf(buf_cur, end_buf - buf_cur, "FRAG:%u ", 
 				   ikey_get_u16(&res[KEY_IP_FRAGOFF]) & IP_OFFMASK);
 
 	switch (ikey_get_u8(&res[KEY_IP_PROTOCOL])) {
@@ -239,86 +242,87 @@ static int printpkt_ipv4(struct ulogd_key *res, char *buf)
 	case IPPROTO_SCTP:
 	case IPPROTO_ESP:
 	case IPPROTO_AH:
-		buf_cur += printpkt_proto(res, buf_cur,
+		buf_cur += printpkt_proto(res, buf_cur, end_buf - buf_cur,
 					  ikey_get_u8(&res[KEY_IP_PROTOCOL]));
 		break;
 
 	case IPPROTO_ICMP:
-		buf_cur += sprintf(buf_cur, "PROTO=ICMP ");
+		buf_cur += snprintf(buf_cur, end_buf - buf_cur, "PROTO=ICMP ");
 
 		if (!pp_is_valid(res, KEY_ICMP_TYPE)) {
-			buf_cur += sprintf(buf_cur, "INCOMPLETE");
+			buf_cur += snprintf(buf_cur, end_buf - buf_cur, "INCOMPLETE");
 			break;
 		}
 
-		buf_cur += sprintf(buf_cur, "TYPE=%u CODE=%u ",
+		buf_cur += snprintf(buf_cur, end_buf - buf_cur, "TYPE=%u CODE=%u ",
 				   ikey_get_u8(&res[KEY_ICMP_TYPE]),
 				   ikey_get_u8(&res[KEY_ICMP_CODE]));
 
 		switch (ikey_get_u8(&res[KEY_ICMP_CODE])) {
 		case ICMP_ECHO:
 		case ICMP_ECHOREPLY:
-			buf_cur += sprintf(buf_cur, "ID=%u SEQ=%u ", 
+			buf_cur += snprintf(buf_cur, end_buf - buf_cur, "ID=%u SEQ=%u ", 
 					   ikey_get_u16(&res[KEY_ICMP_ECHOID]),
 					   ikey_get_u16(&res[KEY_ICMP_ECHOSEQ]));
 			break;
 		case ICMP_PARAMETERPROB:
-			buf_cur += sprintf(buf_cur, "PARAMETER=%u ",
+			buf_cur += snprintf(buf_cur, end_buf - buf_cur, "PARAMETER=%u ",
 					   ikey_get_u32(&res[KEY_ICMP_GATEWAY]) >> 24);
 			break;
 		case ICMP_REDIRECT:
 			paddr = ikey_get_u32(&res[KEY_ICMP_GATEWAY]),
-			buf_cur += sprintf(buf_cur, "GATEWAY=%s ",
+			buf_cur += snprintf(buf_cur, end_buf - buf_cur, "GATEWAY=%s ",
 					   inet_ntop(AF_INET,
 						     &paddr,
 						     tmp, sizeof(tmp)));
 			break;
 		case ICMP_DEST_UNREACH:
 			if (ikey_get_u8(&res[KEY_ICMP_CODE]) == ICMP_FRAG_NEEDED)
-				buf_cur += sprintf(buf_cur, "MTU=%u ", 
+				buf_cur += snprintf(buf_cur, end_buf - buf_cur, "MTU=%u ", 
 						   ikey_get_u16(&res[KEY_ICMP_FRAGMTU]));
 			break;
 		}
 		break;
 	default:
-		buf_cur += sprintf(buf_cur, "PROTO=%u ",
+		buf_cur += snprintf(buf_cur, end_buf - buf_cur, "PROTO=%u ",
 				   ikey_get_u8(&res[KEY_IP_PROTOCOL]));
 	}
 
 	return buf_cur - buf;
 }
 
-static int printpkt_ipv6(struct ulogd_key *res, char *buf)
+static int printpkt_ipv6(struct ulogd_key *res, char *buf, size_t bufsiz)
 {
 	char *buf_cur = buf;
+	char *end_buf = buf + bufsiz;
 
 	if (pp_is_valid(res, KEY_IP_SADDR))
-		buf_cur += sprintf(buf_cur, "SRC=%s ",
+		buf_cur += snprintf(buf_cur, end_buf - buf_cur, "SRC=%s ",
 				   (char *) ikey_get_ptr(&res[KEY_IP_SADDR]));
 
 	if (pp_is_valid(res, KEY_IP_DADDR))
-		buf_cur += sprintf(buf_cur, "DST=%s ",
+		buf_cur += snprintf(buf_cur, end_buf - buf_cur, "DST=%s ",
 				   (char *) ikey_get_ptr(&res[KEY_IP_DADDR]));
 
 	if (pp_is_valid(res, KEY_IP6_PAYLOAD_LEN))
-		buf_cur += sprintf(buf_cur, "LEN=%Zu ",
+		buf_cur += snprintf(buf_cur, end_buf - buf_cur, "LEN=%Zu ",
 				   ikey_get_u16(&res[KEY_IP6_PAYLOAD_LEN]) +
 				   sizeof(struct ip6_hdr));
 
 	if (pp_is_valid(res, KEY_IP6_PRIORITY))
-		buf_cur += sprintf(buf_cur, "TC=%u ",
+		buf_cur += snprintf(buf_cur, end_buf - buf_cur, "TC=%u ",
 				   ikey_get_u8(&res[KEY_IP6_PRIORITY]));
 
 	if (pp_is_valid(res, KEY_IP6_HOPLIMIT))
-		buf_cur += sprintf(buf_cur, "HOPLIMIT=%u ",
+		buf_cur += snprintf(buf_cur, end_buf - buf_cur, "HOPLIMIT=%u ",
 				   ikey_get_u8(&res[KEY_IP6_HOPLIMIT]));
 	
 	if (pp_is_valid(res, KEY_IP6_FLOWLABEL))
-		buf_cur += sprintf(buf_cur, "FLOWLBL=%u ",
+		buf_cur += snprintf(buf_cur, end_buf - buf_cur, "FLOWLBL=%u ",
 				   ikey_get_u32(&res[KEY_IP6_FLOWLABEL]));
 
 	if (pp_is_valid(res, KEY_IP6_FRAG_OFF) && pp_is_valid(res, KEY_IP6_FRAG_ID))
-		buf_cur += sprintf(buf_cur, "FRAG: %u ID: %08x ",
+		buf_cur += snprintf(buf_cur, end_buf - buf_cur, "FRAG: %u ID: %08x ",
 				   ikey_get_u16(&res[KEY_IP6_FRAG_OFF]),
 				   ikey_get_u32(&res[KEY_IP6_FRAG_ID]));
 
@@ -328,31 +332,31 @@ static int printpkt_ipv6(struct ulogd_key *res, char *buf)
 	case IPPROTO_SCTP:
 	case IPPROTO_ESP:
 	case IPPROTO_AH:
-		buf_cur += printpkt_proto(res, buf_cur,
+		buf_cur += printpkt_proto(res, buf_cur, bufsiz,
 					  ikey_get_u8(&res[KEY_IP6_NEXTHDR]));
 		break;
 	case IPPROTO_ICMPV6:
-		buf_cur += sprintf(buf_cur, "PROTO=ICMPv6 ");
+		buf_cur += snprintf(buf_cur, end_buf - buf_cur, "PROTO=ICMPv6 ");
 
 		if (!pp_is_valid(res, KEY_ICMPV6_TYPE)) {
-			buf_cur += sprintf(buf_cur, "INCOMPLETE");
+			buf_cur += snprintf(buf_cur, end_buf - buf_cur, "INCOMPLETE");
 			break;
 		}
 
 		if (!(pp_is_valid(res, KEY_ICMPV6_TYPE) &&
 		      pp_is_valid(res, KEY_ICMPV6_CODE))) {
-			buf_cur += sprintf(buf_cur, "TRUNCATED");
+			buf_cur += snprintf(buf_cur, end_buf - buf_cur, "TRUNCATED");
 			break;
 		}
 
-		buf_cur += sprintf(buf_cur, "TYPE=%u CODE=%u ",
+		buf_cur += snprintf(buf_cur, end_buf - buf_cur, "TYPE=%u CODE=%u ",
 				   ikey_get_u8(&res[KEY_ICMPV6_TYPE]),
 				   ikey_get_u8(&res[KEY_ICMPV6_CODE]));
 
 		switch (ikey_get_u8(&res[KEY_ICMPV6_TYPE])) {
 		case ICMP6_ECHO_REQUEST:
 		case ICMP6_ECHO_REPLY:
-			buf_cur += sprintf(buf_cur, "ID=%u SEQ=%u ", 
+			buf_cur += snprintf(buf_cur, end_buf - buf_cur, "ID=%u SEQ=%u ", 
 					   ikey_get_u16(&res[KEY_ICMPV6_ECHOID]),
 					   ikey_get_u16(&res[KEY_ICMPV6_ECHOSEQ]));
 			break;
@@ -363,41 +367,42 @@ static int printpkt_ipv6(struct ulogd_key *res, char *buf)
 	return buf_cur - buf;
 }
 
-int printpkt_arp(struct ulogd_key *res, char *buf)
+int printpkt_arp(struct ulogd_key *res, char *buf, size_t bufsiz)
 {
 	char *buf_cur = buf;
+	char *end_buf = buf + bufsiz;
 	u_int16_t code = 0;
 	u_int8_t *mac;
 
 	if (pp_is_valid(res, KEY_ARP_SPA))
-		buf_cur += sprintf(buf_cur, "SRC=%s ",
+		buf_cur += snprintf(buf_cur, end_buf - buf_cur, "SRC=%s ",
 				   (char *) ikey_get_ptr(&res[KEY_ARP_SPA]));
 
 	if (pp_is_valid(res, KEY_ARP_TPA))
-		buf_cur += sprintf(buf_cur, "DST=%s ",
+		buf_cur += snprintf(buf_cur, end_buf - buf_cur, "DST=%s ",
 				   (char *) ikey_get_ptr(&res[KEY_ARP_TPA]));
 
-	buf_cur += sprintf(buf_cur, "PROTO=ARP ");
+	buf_cur += snprintf(buf_cur, end_buf - buf_cur, "PROTO=ARP ");
 
 	if (pp_is_valid(res, KEY_ARP_OPCODE)) {
 		code = ikey_get_u16(&res[KEY_ARP_OPCODE]);
 		switch (code) {
 		case ARPOP_REQUEST:
-			buf_cur += sprintf(buf_cur, "REQUEST ");
+			buf_cur += snprintf(buf_cur, end_buf - buf_cur, "REQUEST ");
 			break;
 		case ARPOP_REPLY:
-			buf_cur += sprintf(buf_cur, "REPLY ");
+			buf_cur += snprintf(buf_cur, end_buf - buf_cur, "REPLY ");
 			break;
 		case ARPOP_NAK:
-			buf_cur += sprintf(buf_cur, "NAK ");
+			buf_cur += snprintf(buf_cur, end_buf - buf_cur, "NAK ");
 			break;
 		default:
-			buf_cur += sprintf(buf_cur, "CODE=%u ", code);
+			buf_cur += snprintf(buf_cur, end_buf - buf_cur, "CODE=%u ", code);
 		}
 
 		if (pp_is_valid(res, KEY_ARP_SHA) && (code == ARPOP_REPLY)) {
 			mac = ikey_get_ptr(&res[KEY_ARP_SHA]);
-			buf_cur += sprintf(buf_cur, "REPLY_MAC="
+			buf_cur += snprintf(buf_cur, end_buf - buf_cur, "REPLY_MAC="
 					   "%02x:%02x:%02x:%02x:%02x:%02x ",
 					   mac[0], mac[1], mac[2],
 					   mac[3], mac[4], mac[5]);
@@ -408,38 +413,40 @@ int printpkt_arp(struct ulogd_key *res, char *buf)
 }
 
 
-int printpkt_bridge(struct ulogd_key *res, char *buf)
+int printpkt_bridge(struct ulogd_key *res, char *buf, size_t bufsiz)
 {
 	char *buf_cur = buf;
+	char *end_buf = buf + bufsiz;
 
 	switch (ikey_get_u16(&res[KEY_OOB_PROTOCOL])) {
 	case ETH_P_IP:
-		buf_cur += printpkt_ipv4(res, buf_cur);
+		buf_cur += printpkt_ipv4(res, buf_cur, bufsiz);
 		break;
 	case ETH_P_IPV6:
-		buf_cur += printpkt_ipv6(res, buf_cur);
+		buf_cur += printpkt_ipv6(res, buf_cur, end_buf - buf_cur);
 		break;
 	case ETH_P_ARP:
-		buf_cur += printpkt_arp(res, buf_cur);
+		buf_cur += printpkt_arp(res, buf_cur, end_buf - buf_cur);
 		break;
 	default:
-		buf_cur += sprintf(buf_cur, "PROTO=%u ",
+		buf_cur += snprintf(buf_cur, end_buf - buf_cur, "PROTO=%u ",
 				   ikey_get_u16(&res[KEY_OOB_PROTOCOL]));
 	}
 
 	return buf_cur - buf;
 }
 
-int printpkt_print(struct ulogd_key *res, char *buf)
+int printpkt_print(struct ulogd_key *res, char *buf, size_t bufsiz)
 {
 	char *buf_cur = buf;
+	char *end_buf = buf + bufsiz - 1; /* counting endline added */
 
 	if (pp_is_valid(res, KEY_OOB_PREFIX))
-		buf_cur += sprintf(buf_cur, "%s ",
+		buf_cur += snprintf(buf_cur, bufsiz, "%s ",
 				   (char *) ikey_get_ptr(&res[KEY_OOB_PREFIX]));
 
 	if (pp_is_valid(res, KEY_OOB_IN) && pp_is_valid(res, KEY_OOB_OUT))
-		buf_cur += sprintf(buf_cur, "IN=%s OUT=%s ", 
+		buf_cur += snprintf(buf_cur, end_buf - buf_cur, "IN=%s OUT=%s ",
 				   (char *) ikey_get_ptr(&res[KEY_OOB_IN]), 
 				   (char *) ikey_get_ptr(&res[KEY_OOB_OUT]));
 
@@ -448,33 +455,34 @@ int printpkt_print(struct ulogd_key *res, char *buf)
 		unsigned char *mac = (unsigned char *) ikey_get_ptr(&res[KEY_RAW_MAC]);
 		int i, len = ikey_get_u16(&res[KEY_RAW_MACLEN]);
 
-		buf_cur += sprintf(buf_cur, "MAC=");
+		buf_cur += snprintf(buf_cur, end_buf - buf_cur, "MAC=");
 		for (i = 0; i < len; i++)
-			buf_cur += sprintf(buf_cur, "%02x%c", mac[i],
+			buf_cur += snprintf(buf_cur, end_buf - buf_cur,
+					   "%02x%c", mac[i],
 					   i == len - 1 ? ' ' : ':');
 	} else
-		buf_cur += sprintf(buf_cur, "MAC= ");
+		buf_cur += snprintf(buf_cur, end_buf - buf_cur, "MAC= ");
 
 	switch (ikey_get_u8(&res[KEY_OOB_FAMILY])) {
 	case AF_INET:
-		buf_cur += printpkt_ipv4(res, buf_cur);
+		buf_cur += printpkt_ipv4(res, buf_cur, end_buf - buf_cur);
 		break;
 	case AF_INET6:
-		buf_cur += printpkt_ipv6(res, buf_cur);
+		buf_cur += printpkt_ipv6(res, buf_cur, end_buf - buf_cur);
 		break;
 	case AF_BRIDGE:
-		buf_cur += printpkt_bridge(res, buf_cur);
+		buf_cur += printpkt_bridge(res, buf_cur, end_buf - buf_cur);
 		break;
 	}
 
 	if (pp_is_valid(res, KEY_OOB_UID))
-		buf_cur += sprintf(buf_cur, "UID=%u ",
+		buf_cur += snprintf(buf_cur, end_buf - buf_cur, "UID=%u ",
 				   ikey_get_u32(&res[KEY_OOB_UID]));
 	if (pp_is_valid(res, KEY_OOB_GID))
-		buf_cur += sprintf(buf_cur, "GID=%u ",
+		buf_cur += snprintf(buf_cur, end_buf - buf_cur, "GID=%u ",
 				   ikey_get_u32(&res[KEY_OOB_GID]));
 	if (pp_is_valid(res, KEY_OOB_MARK))
-		buf_cur += sprintf(buf_cur, "MARK=%x ",
+		buf_cur += snprintf(buf_cur, end_buf - buf_cur, "MARK=%x ",
 				   ikey_get_u32(&res[KEY_OOB_MARK]));
 
 	strcat(buf_cur, "\n");
-- 
1.6.1

