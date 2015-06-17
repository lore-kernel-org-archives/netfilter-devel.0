From: Markus Koetter <koetter@rrzn.uni-hannover.de>
Subject: [PATCH 5/5] trace: add log for packets
Date: Wed, 17 Jun 2015 22:07:37 +0200
Message-ID: <1434571657-20047-6-git-send-email-koetter@rrzn.uni-hannover.de>
References: <1434571657-20047-1-git-send-email-koetter@rrzn.uni-hannover.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout2.uni-hannover.de ([130.75.2.114]:38456 "EHLO
	mailout2.uni-hannover.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbbFQUO2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Jun 2015 16:14:28 -0400
Received: from localhost (localhost [127.0.0.1])
	by mailout2.uni-hannover.de (Postfix) with ESMTP id F002560AC
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Jun 2015 22:04:01 +0200 (CEST)
Received: from mailout2.uni-hannover.de ([127.0.0.1])
	by localhost (mailout2.uni-hannover.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1Ptvz0zl4CJQ for <netfilter-devel@vger.kernel.org>;
	Wed, 17 Jun 2015 22:04:01 +0200 (CEST)
Received: from hass1404.example.prv (p4FDA71FA.dip0.t-ipconnect.de [79.218.113.250])
	(Authenticated sender: koetter@rrzn.uni-hannover.de)
	by mailout2.uni-hannover.de (Postfix) with ESMTPSA id BF5A060AA
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Jun 2015 22:04:01 +0200 (CEST)
In-Reply-To: <1434571657-20047-1-git-send-email-koetter@rrzn.uni-hannover.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

use kernel packet logging code, just adding some compat skbuff/nf_log_buf
and disable some blocks using ifdefs.
---
 include/Makefile.am |   1 +
 include/log.h       |  17 ++
 src/Makefile.am     |   1 +
 src/log.c           | 779 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 798 insertions(+)
 create mode 100644 include/log.h
 create mode 100644 src/log.c

diff --git a/include/Makefile.am b/include/Makefile.am
index c351b55..7951587 100644
--- a/include/Makefile.am
+++ b/include/Makefile.am
@@ -20,4 +20,5 @@ noinst_HEADERS = 	cli.h		\
 			proto.h		\
 			rule.h		\
 			trace.h		\
+			log.h		\
 			utils.h
diff --git a/include/log.h b/include/log.h
new file mode 100644
index 0000000..22545f4
--- /dev/null
+++ b/include/log.h
@@ -0,0 +1,17 @@
+#include <stdint.h>
+#include <inttypes.h>
+
+struct nf_log_buf;
+
+void nf_log_buf_init(struct nf_log_buf *);
+int nf_log_buf_add(struct nf_log_buf *m, const char *f, ...);
+void nf_log_buf_exit(struct nf_log_buf *m);
+
+struct nlattr;
+void nf_log_packet(struct nlattr *tb[]);
+
+#define IP_CE           0x8000          /* Flag: "Congestion"           */
+#define IP_DF           0x4000          /* Flag: "Don't Fragment"       */
+#define IP_MF           0x2000          /* Flag: "More Fragments"       */
+#define IP_OFFSET       0x1FFF          /* "Fragment Offset" part       */
+
diff --git a/src/Makefile.am b/src/Makefile.am
index db77e8e..3fd07ca 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -46,6 +46,7 @@ nft_SOURCES =	main.c				\
 		mnl.c				\
 		scanner.l			\
 		trace.c				\
+		log.c				\
 		parser_bison.y
 
 if BUILD_CLI
diff --git a/src/log.c b/src/log.c
new file mode 100644
index 0000000..410c21e
--- /dev/null
+++ b/src/log.c
@@ -0,0 +1,779 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdarg.h>
+
+#include <stddef.h>
+#include <stdint.h>
+#include <string.h>
+#include <net/if_arp.h>
+#include <net/ethernet.h>
+#include <net/if.h>
+#include <arpa/inet.h>
+
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/icmp.h>
+#include <linux/icmpv6.h>
+#include <linux/if_ether.h>
+#include <linux/tcp.h>
+#include <linux/udp.h>
+
+#include <log.h>
+#include <linux/netfilter/nfnetlink_log.h>
+#include <libnfnetlink/libnfnetlink.h>
+
+
+#include <libmnl/libmnl.h>
+
+#define S_SIZE (1024 - (sizeof(unsigned int) + 1))
+
+struct nf_log_buf {
+	unsigned int	count;
+	char		buf[S_SIZE + 1];
+};
+
+int nf_log_buf_add(struct nf_log_buf *m, const char *f, ...)
+{
+	va_list args;
+	int len;
+
+	if (m->count < S_SIZE) {
+		va_start(args, f);
+		len = vsnprintf(m->buf + m->count, S_SIZE - m->count, f, args);
+		va_end(args);
+		if (m->count + len < S_SIZE) {
+			m->count += len;
+			return 0;
+		}
+	}
+	m->count = S_SIZE;
+	return -1;
+}
+
+void nf_log_buf_init(struct nf_log_buf *m)
+{
+	m->count = 0;
+}
+
+void nf_log_buf_exit(struct nf_log_buf *m)
+{
+	m->buf[m->count] = 0;
+}
+
+struct sk_buff
+{
+	void *data;
+	uint16_t len;
+	uint32_t mark;
+};
+
+static void *skb_header_pointer(const struct sk_buff *skb, int offset, int len, void *dest)
+{
+	if (skb->len-offset < len)
+		return NULL;
+	memcpy(dest, &((unsigned char *)skb->data)[offset], len);
+	return dest;
+}
+
+struct nf_loginfo
+{
+	int type;
+};
+
+#define u8 uint8_t
+
+static int nf_log_dump_udp_header(struct nf_log_buf *m, const struct sk_buff *skb,
+			   u8 proto, int fragment, unsigned int offset)
+{
+	struct udphdr _udph;
+	const struct udphdr *uh;
+
+	if (proto == IPPROTO_UDP)
+		/* Max length: 10 "PROTO=UDP "     */
+		nf_log_buf_add(m, "PROTO=UDP ");
+	else	/* Max length: 14 "PROTO=UDPLITE " */
+		nf_log_buf_add(m, "PROTO=UDPLITE ");
+
+	if (fragment)
+		goto out;
+
+	/* Max length: 25 "INCOMPLETE [65535 bytes] " */
+	uh = skb_header_pointer(skb, offset, sizeof(_udph), &_udph);
+	if (uh == NULL) {
+		nf_log_buf_add(m, "INCOMPLETE [%u bytes] ", skb->len - offset);
+
+		return 1;
+	}
+
+	/* Max length: 20 "SPT=65535 DPT=65535 " */
+	nf_log_buf_add(m, "SPT=%u DPT=%u LEN=%u ",
+		       ntohs(uh->source), ntohs(uh->dest), ntohs(uh->len));
+
+out:
+	return 0;
+}
+
+static int nf_log_dump_tcp_header(struct nf_log_buf *m, const struct sk_buff *skb,
+			   u8 proto, int fragment, unsigned int offset,
+			   unsigned int logflags)
+{
+	struct tcphdr _tcph;
+	const struct tcphdr *th;
+
+	/* Max length: 10 "PROTO=TCP " */
+	nf_log_buf_add(m, "PROTO=TCP ");
+
+	if (fragment)
+		return 0;
+
+	/* Max length: 25 "INCOMPLETE [65535 bytes] " */
+	th = skb_header_pointer(skb, offset, sizeof(_tcph), &_tcph);
+	if (th == NULL) {
+		nf_log_buf_add(m, "INCOMPLETE [%u bytes] ", skb->len - offset);
+		return 1;
+	}
+
+	/* Max length: 20 "SPT=65535 DPT=65535 " */
+	nf_log_buf_add(m, "SPT=%u DPT=%u ",
+		       ntohs(th->source), ntohs(th->dest));
+
+#ifdef XT_LOG_TCPSEQ
+	/* Max length: 30 "SEQ=4294967295 ACK=4294967295 " */
+	if (logflags & XT_LOG_TCPSEQ) {
+		nf_log_buf_add(m, "SEQ=%u ACK=%u ",
+			       ntohl(th->seq), ntohl(th->ack_seq));
+	}
+#endif
+
+	/* Max length: 13 "WINDOW=65535 " */
+	nf_log_buf_add(m, "WINDOW=%u ", ntohs(th->window));
+	/* Max length: 9 "RES=0x3C " */
+	nf_log_buf_add(m, "RES=0x%02x ", (u_int8_t)(ntohl(tcp_flag_word(th) &
+					    TCP_RESERVED_BITS) >> 22));
+	/* Max length: 32 "CWR ECE URG ACK PSH RST SYN FIN " */
+	if (th->cwr)
+		nf_log_buf_add(m, "CWR ");
+	if (th->ece)
+		nf_log_buf_add(m, "ECE ");
+	if (th->urg)
+		nf_log_buf_add(m, "URG ");
+	if (th->ack)
+		nf_log_buf_add(m, "ACK ");
+	if (th->psh)
+		nf_log_buf_add(m, "PSH ");
+	if (th->rst)
+		nf_log_buf_add(m, "RST ");
+	if (th->syn)
+		nf_log_buf_add(m, "SYN ");
+	if (th->fin)
+		nf_log_buf_add(m, "FIN ");
+	/* Max length: 11 "URGP=65535 " */
+	nf_log_buf_add(m, "URGP=%u ", ntohs(th->urg_ptr));
+
+#ifdef XT_LOG_TCPOPT
+	if ((logflags & XT_LOG_TCPOPT) && th->doff*4 > sizeof(struct tcphdr)) {
+		u_int8_t _opt[60 - sizeof(struct tcphdr)];
+		const u_int8_t *op;
+		unsigned int i;
+		unsigned int optsize = th->doff*4 - sizeof(struct tcphdr);
+
+		op = skb_header_pointer(skb, offset + sizeof(struct tcphdr),
+					optsize, _opt);
+		if (op == NULL) {
+			nf_log_buf_add(m, "OPT (TRUNCATED)");
+			return 1;
+		}
+
+		/* Max length: 127 "OPT (" 15*4*2chars ") " */
+		nf_log_buf_add(m, "OPT (");
+		for (i = 0; i < optsize; i++)
+			nf_log_buf_add(m, "%02X", op[i]);
+
+		nf_log_buf_add(m, ") ");
+	}
+#endif
+	return 0;
+}
+
+#define NEXTHDR_NONE            59
+static inline int
+ip6t_ext_hdr(u8 nexthdr)
+{       return (nexthdr == IPPROTO_HOPOPTS) ||
+			   (nexthdr == IPPROTO_ROUTING) ||
+			   (nexthdr == IPPROTO_FRAGMENT) ||
+			   (nexthdr == IPPROTO_ESP) ||
+			   (nexthdr == IPPROTO_AH) ||
+			   (nexthdr == IPPROTO_NONE) ||
+			   (nexthdr == IPPROTO_DSTOPTS);
+}
+
+/* One level of recursion won't kill us */
+static void dump_ipv6_packet(struct nf_log_buf *m,
+			     const struct nf_loginfo *info,
+			     const struct sk_buff *skb, unsigned int ip6hoff,
+			     int recurse)
+{
+	u_int8_t currenthdr;
+	int fragment;
+	struct ipv6hdr _ip6h;
+	const struct ipv6hdr *ih;
+	unsigned int ptr;
+	unsigned int hdrlen = 0;
+	unsigned int logflags;
+
+#ifdef NF_LOG_TYPE_LOG
+	if (info->type == NF_LOG_TYPE_LOG)
+		logflags = info->u.log.logflags;
+	else
+		logflags = NF_LOG_MASK;
+#endif
+
+	ih = skb_header_pointer(skb, ip6hoff, sizeof(_ip6h), &_ip6h);
+	if (ih == NULL) {
+		nf_log_buf_add(m, "TRUNCATED");
+		return;
+	}
+
+	/* Max length: 88 "SRC=0000.0000.0000.0000.0000.0000.0000.0000 DST=0000.0000.0000.0000.0000.0000.0000.0000 " */
+//	nf_log_buf_add(m, "SRC=%pI6 DST=%pI6 ", &ih->saddr, &ih->daddr);
+	{
+		char src[INET6_ADDRSTRLEN+1], dst[INET6_ADDRSTRLEN+1];
+		nf_log_buf_add(m, "SRC=%s DST=%s ",
+				 inet_ntop(AF_INET6, (void *)&ih->saddr, src, sizeof(src)),
+				 inet_ntop(AF_INET6, (void *)&ih->daddr, dst, sizeof(dst)));
+	}
+
+	/* Max length: 44 "LEN=65535 TC=255 HOPLIMIT=255 FLOWLBL=FFFFF " */
+	nf_log_buf_add(m, "LEN=%Zu TC=%u HOPLIMIT=%u FLOWLBL=%u ",
+	       ntohs(ih->payload_len) + sizeof(struct ipv6hdr),
+	       (ntohl(*(__be32 *)ih) & 0x0ff00000) >> 20,
+	       ih->hop_limit,
+	       (ntohl(*(__be32 *)ih) & 0x000fffff));
+
+	fragment = 0;
+	ptr = ip6hoff + sizeof(struct ipv6hdr);
+	currenthdr = ih->nexthdr;
+	while (currenthdr != NEXTHDR_NONE && ip6t_ext_hdr(currenthdr)) {
+		struct ipv6_opt_hdr _hdr;
+		const struct ipv6_opt_hdr *hp;
+
+		hp = skb_header_pointer(skb, ptr, sizeof(_hdr), &_hdr);
+		if (hp == NULL) {
+			nf_log_buf_add(m, "TRUNCATED");
+			return;
+		}
+
+#ifdef XT_LOG_IPOPT
+		/* Max length: 48 "OPT (...) " */
+		if (logflags & XT_LOG_IPOPT)
+			nf_log_buf_add(m, "OPT ( ");
+
+		switch (currenthdr) {
+		case IPPROTO_FRAGMENT: {
+			struct frag_hdr _fhdr;
+			const struct frag_hdr *fh;
+
+			nf_log_buf_add(m, "FRAG:");
+			fh = skb_header_pointer(skb, ptr, sizeof(_fhdr),
+						&_fhdr);
+			if (fh == NULL) {
+				nf_log_buf_add(m, "TRUNCATED ");
+				return;
+			}
+
+			/* Max length: 6 "65535 " */
+			nf_log_buf_add(m, "%u ", ntohs(fh->frag_off) & 0xFFF8);
+
+			/* Max length: 11 "INCOMPLETE " */
+			if (fh->frag_off & htons(0x0001))
+				nf_log_buf_add(m, "INCOMPLETE ");
+
+			nf_log_buf_add(m, "ID:%08x ",
+				       ntohl(fh->identification));
+
+			if (ntohs(fh->frag_off) & 0xFFF8)
+				fragment = 1;
+
+			hdrlen = 8;
+
+			break;
+		}
+		case IPPROTO_DSTOPTS:
+		case IPPROTO_ROUTING:
+		case IPPROTO_HOPOPTS:
+			if (fragment) {
+				if (logflags & XT_LOG_IPOPT)
+					nf_log_buf_add(m, ")");
+				return;
+			}
+			hdrlen = ipv6_optlen(hp);
+			break;
+		/* Max Length */
+		case IPPROTO_AH:
+			if (logflags & XT_LOG_IPOPT) {
+				struct ip_auth_hdr _ahdr;
+				const struct ip_auth_hdr *ah;
+
+				/* Max length: 3 "AH " */
+				nf_log_buf_add(m, "AH ");
+
+				if (fragment) {
+					nf_log_buf_add(m, ")");
+					return;
+				}
+
+				ah = skb_header_pointer(skb, ptr, sizeof(_ahdr),
+							&_ahdr);
+				if (ah == NULL) {
+					/*
+					 * Max length: 26 "INCOMPLETE [65535
+					 *  bytes] )"
+					 */
+					nf_log_buf_add(m, "INCOMPLETE [%u bytes] )",
+						       skb->len - ptr);
+					return;
+				}
+
+				/* Length: 15 "SPI=0xF1234567 */
+				nf_log_buf_add(m, "SPI=0x%x ", ntohl(ah->spi));
+
+			}
+
+			hdrlen = (hp->hdrlen+2)<<2;
+			break;
+		case IPPROTO_ESP:
+			if (logflags & XT_LOG_IPOPT) {
+				struct ip_esp_hdr _esph;
+				const struct ip_esp_hdr *eh;
+
+				/* Max length: 4 "ESP " */
+				nf_log_buf_add(m, "ESP ");
+
+				if (fragment) {
+					nf_log_buf_add(m, ")");
+					return;
+				}
+
+				/*
+				 * Max length: 26 "INCOMPLETE [65535 bytes] )"
+				 */
+				eh = skb_header_pointer(skb, ptr, sizeof(_esph),
+							&_esph);
+				if (eh == NULL) {
+					nf_log_buf_add(m, "INCOMPLETE [%u bytes] )",
+						       skb->len - ptr);
+					return;
+				}
+
+				/* Length: 16 "SPI=0xF1234567 )" */
+				nf_log_buf_add(m, "SPI=0x%x )",
+					       ntohl(eh->spi));
+			}
+			return;
+		default:
+			/* Max length: 20 "Unknown Ext Hdr 255" */
+			nf_log_buf_add(m, "Unknown Ext Hdr %u", currenthdr);
+			return;
+		}
+		if (logflags & XT_LOG_IPOPT)
+			nf_log_buf_add(m, ") ");
+#endif
+
+		currenthdr = hp->nexthdr;
+		ptr += hdrlen;
+	}
+
+	switch (currenthdr) {
+	case IPPROTO_TCP:
+		if (nf_log_dump_tcp_header(m, skb, currenthdr, fragment,
+					   ptr, logflags))
+			return;
+		break;
+	case IPPROTO_UDP:
+	case IPPROTO_UDPLITE:
+		if (nf_log_dump_udp_header(m, skb, currenthdr, fragment, ptr))
+			return;
+		break;
+	case IPPROTO_ICMPV6: {
+		struct icmp6hdr _icmp6h;
+		const struct icmp6hdr *ic;
+
+		/* Max length: 13 "PROTO=ICMPv6 " */
+		nf_log_buf_add(m, "PROTO=ICMPv6 ");
+
+		if (fragment)
+			break;
+
+		/* Max length: 25 "INCOMPLETE [65535 bytes] " */
+		ic = skb_header_pointer(skb, ptr, sizeof(_icmp6h), &_icmp6h);
+		if (ic == NULL) {
+			nf_log_buf_add(m, "INCOMPLETE [%u bytes] ",
+				       skb->len - ptr);
+			return;
+		}
+
+		/* Max length: 18 "TYPE=255 CODE=255 " */
+		nf_log_buf_add(m, "TYPE=%u CODE=%u ",
+			       ic->icmp6_type, ic->icmp6_code);
+
+		switch (ic->icmp6_type) {
+		case ICMPV6_ECHO_REQUEST:
+		case ICMPV6_ECHO_REPLY:
+			/* Max length: 19 "ID=65535 SEQ=65535 " */
+			nf_log_buf_add(m, "ID=%u SEQ=%u ",
+				ntohs(ic->icmp6_identifier),
+				ntohs(ic->icmp6_sequence));
+			break;
+		case ICMPV6_MGM_QUERY:
+		case ICMPV6_MGM_REPORT:
+		case ICMPV6_MGM_REDUCTION:
+			break;
+
+		case ICMPV6_PARAMPROB:
+			/* Max length: 17 "POINTER=ffffffff " */
+			nf_log_buf_add(m, "POINTER=%08x ",
+				       ntohl(ic->icmp6_pointer));
+			/* Fall through */
+		case ICMPV6_DEST_UNREACH:
+		case ICMPV6_PKT_TOOBIG:
+		case ICMPV6_TIME_EXCEED:
+			/* Max length: 3+maxlen */
+			if (recurse) {
+				nf_log_buf_add(m, "[");
+				dump_ipv6_packet(m, info, skb,
+						 ptr + sizeof(_icmp6h), 0);
+				nf_log_buf_add(m, "] ");
+			}
+
+			/* Max length: 10 "MTU=65535 " */
+			if (ic->icmp6_type == ICMPV6_PKT_TOOBIG) {
+				nf_log_buf_add(m, "MTU=%u ",
+					       ntohl(ic->icmp6_mtu));
+			}
+		}
+		break;
+	}
+	/* Max length: 10 "PROTO=255 " */
+	default:
+		nf_log_buf_add(m, "PROTO=%u ", currenthdr);
+	}
+
+#ifdef XT_LOG_UID
+	/* Max length: 15 "UID=4294967295 " */
+	if ((logflags & XT_LOG_UID) && recurse)
+		nf_log_dump_sk_uid_gid(m, skb->sk);
+#endif
+
+	/* Max length: 16 "MARK=0xFFFFFFFF " */
+	if (recurse && skb->mark)
+		nf_log_buf_add(m, "MARK=0x%x ", skb->mark);
+}
+
+/* One level of recursion won't kill us */
+static void dump_ipv4_packet(struct nf_log_buf *m,
+			     const struct nf_loginfo *info,
+			     const struct sk_buff *skb, unsigned int iphoff)
+{
+	struct iphdr _iph;
+	const struct iphdr *ih;
+	unsigned int logflags;
+
+#ifdef NF_LOG_TYPE_LOG
+	if (info->type == NF_LOG_TYPE_LOG)
+		logflags = info->u.log.logflags;
+	else
+		logflags = NF_LOG_MASK;
+#endif
+
+	ih = skb_header_pointer(skb, iphoff, sizeof(_iph), &_iph);
+	if (ih == NULL) {
+		nf_log_buf_add(m, "TRUNCATED");
+		return;
+	}
+
+	/* Important fields:
+	 * TOS, len, DF/MF, fragment offset, TTL, src, dst, options. */
+	/* Max length: 40 "SRC=255.255.255.255 DST=255.255.255.255 " */
+//	nf_log_buf_add(m, "SRC=%pI4 DST=%pI4 ", &ih->saddr, &ih->daddr);
+	{
+		char src[INET_ADDRSTRLEN+1], dst[INET_ADDRSTRLEN+1];
+		nf_log_buf_add(m, "SRC=%s DST=%s ",
+				 inet_ntop(AF_INET, (void *)&ih->saddr, src, sizeof(src)),
+				 inet_ntop(AF_INET, (void *)&ih->daddr, dst, sizeof(dst)));
+	}
+
+	/* Max length: 46 "LEN=65535 TOS=0xFF PREC=0xFF TTL=255 ID=65535 " */
+	nf_log_buf_add(m, "LEN=%u TOS=0x%02X PREC=0x%02X TTL=%u ID=%u ",
+		       ntohs(ih->tot_len), ih->tos & IPTOS_TOS_MASK,
+		       ih->tos & IPTOS_PREC_MASK, ih->ttl, ntohs(ih->id));
+
+	/* Max length: 6 "CE DF MF " */
+	if (ntohs(ih->frag_off) & IP_CE)
+		nf_log_buf_add(m, "CE ");
+	if (ntohs(ih->frag_off) & IP_DF)
+		nf_log_buf_add(m, "DF ");
+	if (ntohs(ih->frag_off) & IP_MF)
+		nf_log_buf_add(m, "MF ");
+
+	/* Max length: 11 "FRAG:65535 " */
+	if (ntohs(ih->frag_off) & IP_OFFSET)
+		nf_log_buf_add(m, "FRAG:%u ", ntohs(ih->frag_off) & IP_OFFSET);
+
+#ifdef XT_LOG_IPOPT
+	if ( (logflags & XT_LOG_IPOPT) && ih->ihl * 4 > sizeof(struct iphdr)) {
+		const unsigned char *op;
+		unsigned char _opt[4 * 15 - sizeof(struct iphdr)];
+		unsigned int i, optsize;
+
+		optsize = ih->ihl * 4 - sizeof(struct iphdr);
+		op = skb_header_pointer(skb, iphoff+sizeof(_iph),
+					optsize, _opt);
+		if (op == NULL) {
+			nf_log_buf_add(m, "TRUNCATED");
+			return;
+		}
+
+		/* Max length: 127 "OPT (" 15*4*2chars ") " */
+		nf_log_buf_add(m, "OPT (");
+		for (i = 0; i < optsize; i++)
+			nf_log_buf_add(m, "%02X", op[i]);
+		nf_log_buf_add(m, ") ");
+	}
+#endif
+
+	switch (ih->protocol) {
+	case IPPROTO_TCP:
+		if (nf_log_dump_tcp_header(m, skb, ih->protocol,
+					   ntohs(ih->frag_off) & IP_OFFSET,
+					   iphoff+ih->ihl*4, logflags))
+			return;
+		break;
+	case IPPROTO_UDP:
+	case IPPROTO_UDPLITE:
+		if (nf_log_dump_udp_header(m, skb, ih->protocol,
+					   ntohs(ih->frag_off) & IP_OFFSET,
+					   iphoff+ih->ihl*4))
+			return;
+		break;
+	case IPPROTO_ICMP: {
+		struct icmphdr _icmph;
+		const struct icmphdr *ich;
+		static const size_t required_len[NR_ICMP_TYPES+1]
+			= { [ICMP_ECHOREPLY] = 4,
+			    [ICMP_DEST_UNREACH]
+			    = 8 + sizeof(struct iphdr),
+			    [ICMP_SOURCE_QUENCH]
+			    = 8 + sizeof(struct iphdr),
+			    [ICMP_REDIRECT]
+			    = 8 + sizeof(struct iphdr),
+			    [ICMP_ECHO] = 4,
+			    [ICMP_TIME_EXCEEDED]
+			    = 8 + sizeof(struct iphdr),
+			    [ICMP_PARAMETERPROB]
+			    = 8 + sizeof(struct iphdr),
+			    [ICMP_TIMESTAMP] = 20,
+			    [ICMP_TIMESTAMPREPLY] = 20,
+			    [ICMP_ADDRESS] = 12,
+			    [ICMP_ADDRESSREPLY] = 12 };
+
+		/* Max length: 11 "PROTO=ICMP " */
+		nf_log_buf_add(m, "PROTO=ICMP ");
+
+		if (ntohs(ih->frag_off) & IP_OFFSET)
+			break;
+
+		/* Max length: 25 "INCOMPLETE [65535 bytes] " */
+		ich = skb_header_pointer(skb, iphoff + ih->ihl * 4,
+					 sizeof(_icmph), &_icmph);
+		if (ich == NULL) {
+			nf_log_buf_add(m, "INCOMPLETE [%u bytes] ",
+				       skb->len - iphoff - ih->ihl*4);
+			break;
+		}
+
+		/* Max length: 18 "TYPE=255 CODE=255 " */
+		nf_log_buf_add(m, "TYPE=%u CODE=%u ", ich->type, ich->code);
+
+		/* Max length: 25 "INCOMPLETE [65535 bytes] " */
+		if (ich->type <= NR_ICMP_TYPES &&
+		    required_len[ich->type] &&
+		    skb->len-iphoff-ih->ihl*4 < required_len[ich->type]) {
+			nf_log_buf_add(m, "INCOMPLETE [%u bytes] ",
+				       skb->len - iphoff - ih->ihl*4);
+			break;
+		}
+
+		switch (ich->type) {
+		case ICMP_ECHOREPLY:
+		case ICMP_ECHO:
+			/* Max length: 19 "ID=65535 SEQ=65535 " */
+			nf_log_buf_add(m, "ID=%u SEQ=%u ",
+				       ntohs(ich->un.echo.id),
+				       ntohs(ich->un.echo.sequence));
+			break;
+
+		case ICMP_PARAMETERPROB:
+			/* Max length: 14 "PARAMETER=255 " */
+			nf_log_buf_add(m, "PARAMETER=%u ",
+				       ntohl(ich->un.gateway) >> 24);
+			break;
+		case ICMP_REDIRECT:
+			/* Max length: 24 "GATEWAY=255.255.255.255 " */
+			nf_log_buf_add(m, "GATEWAY=%pI4 ", &ich->un.gateway);
+			/* Fall through */
+		case ICMP_DEST_UNREACH:
+		case ICMP_SOURCE_QUENCH:
+		case ICMP_TIME_EXCEEDED:
+			/* Max length: 3+maxlen */
+			if (!iphoff) { /* Only recurse once. */
+				nf_log_buf_add(m, "[");
+				dump_ipv4_packet(m, info, skb,
+					    iphoff + ih->ihl*4+sizeof(_icmph));
+				nf_log_buf_add(m, "] ");
+			}
+
+			/* Max length: 10 "MTU=65535 " */
+			if (ich->type == ICMP_DEST_UNREACH &&
+			    ich->code == ICMP_FRAG_NEEDED) {
+				nf_log_buf_add(m, "MTU=%u ",
+					       ntohs(ich->un.frag.mtu));
+			}
+		}
+		break;
+	}
+	/* Max Length */
+	case IPPROTO_AH: {
+		struct ip_auth_hdr _ahdr;
+		const struct ip_auth_hdr *ah;
+
+		if (ntohs(ih->frag_off) & IP_OFFSET)
+			break;
+
+		/* Max length: 9 "PROTO=AH " */
+		nf_log_buf_add(m, "PROTO=AH ");
+
+		/* Max length: 25 "INCOMPLETE [65535 bytes] " */
+		ah = skb_header_pointer(skb, iphoff+ih->ihl*4,
+					sizeof(_ahdr), &_ahdr);
+		if (ah == NULL) {
+			nf_log_buf_add(m, "INCOMPLETE [%u bytes] ",
+				       skb->len - iphoff - ih->ihl*4);
+			break;
+		}
+
+		/* Length: 15 "SPI=0xF1234567 " */
+		nf_log_buf_add(m, "SPI=0x%x ", ntohl(ah->spi));
+		break;
+	}
+	case IPPROTO_ESP: {
+		struct ip_esp_hdr _esph;
+		const struct ip_esp_hdr *eh;
+
+		/* Max length: 10 "PROTO=ESP " */
+		nf_log_buf_add(m, "PROTO=ESP ");
+
+		if (ntohs(ih->frag_off) & IP_OFFSET)
+			break;
+
+		/* Max length: 25 "INCOMPLETE [65535 bytes] " */
+		eh = skb_header_pointer(skb, iphoff+ih->ihl*4,
+					sizeof(_esph), &_esph);
+		if (eh == NULL) {
+			nf_log_buf_add(m, "INCOMPLETE [%u bytes] ",
+				       skb->len - iphoff - ih->ihl*4);
+			break;
+		}
+
+		/* Length: 15 "SPI=0xF1234567 " */
+		nf_log_buf_add(m, "SPI=0x%x ", ntohl(eh->spi));
+		break;
+	}
+	/* Max length: 10 "PROTO 255 " */
+	default:
+		nf_log_buf_add(m, "PROTO=%u ", ih->protocol);
+	}
+
+#ifdef XT_LOG_UID
+	/* Max length: 15 "UID=4294967295 " */
+	if ((logflags & XT_LOG_UID) && !iphoff)
+		nf_log_dump_sk_uid_gid(m, skb->sk);
+#endif
+
+	/* Max length: 16 "MARK=0xFFFFFFFF " */
+	if (!iphoff && skb->mark)
+		nf_log_buf_add(m, "MARK=0x%x ", skb->mark);
+
+	/* Proto    Max log string length */
+	/* IP:	    40+46+6+11+127 = 230 */
+	/* TCP:     10+max(25,20+30+13+9+32+11+127) = 252 */
+	/* UDP:     10+max(25,20) = 35 */
+	/* UDPLITE: 14+max(25,20) = 39 */
+	/* ICMP:    11+max(25, 18+25+max(19,14,24+3+n+10,3+n+10)) = 91+n */
+	/* ESP:     10+max(25)+15 = 50 */
+	/* AH:	    9+max(25)+15 = 49 */
+	/* unknown: 10 */
+
+	/* (ICMP allows recursion one level deep) */
+	/* maxlen =  IP + ICMP +  IP + max(TCP,UDP,ICMP,unknown) */
+	/* maxlen = 230+   91  + 230 + 252 = 803 */
+}
+
+void nf_log_packet(struct nlattr *tb[])
+{
+	struct nf_log_buf m;
+	struct nfulnl_msg_packet_hdr *ph = NULL;
+
+	nf_log_buf_init(&m);
+
+	if (tb[NFULA_IFINDEX_INDEV]) {
+		char ifname[IFNAMSIZ];
+		if_indextoname(ntohl(mnl_attr_get_u32(tb[NFULA_IFINDEX_INDEV])), ifname);
+		nf_log_buf_add(&m, "IN=%s ", ifname);
+	}else
+		nf_log_buf_add(&m, "IN= ");
+
+	if (tb[NFULA_IFINDEX_OUTDEV]) {
+		char ifname[IFNAMSIZ];
+		if_indextoname(ntohl(mnl_attr_get_u32(tb[NFULA_IFINDEX_OUTDEV])), ifname);
+		nf_log_buf_add(&m, "OUT=%s ", ifname);
+	}else
+		nf_log_buf_add(&m, "OUT= ");
+
+	/*
+	if (tb[NFULA_HWHEADER] && tb[NFULA_HWLEN])
+	{
+		uint16_t hwlen = ntohs(mnl_attr_get_u16(tb[NFULA_HWLEN]));
+		unsigned char *hwheader = mnl_attr_get_payload(tb[NFULA_HWHEADER]);
+	}
+	*/
+
+	if (tb[NFULA_PACKET_HDR])
+		ph = mnl_attr_get_payload(tb[NFULA_PACKET_HDR]);
+
+	if(ph && tb[NFULA_PAYLOAD])
+	{
+		struct sk_buff skb =
+		{
+			.data = mnl_attr_get_payload(tb[NFULA_PAYLOAD]),
+			.len = NFA_PAYLOAD((struct nfattr *)tb[NFULA_PAYLOAD]),
+			.mark = 0,
+		};
+
+		switch (ntohs(ph->hw_protocol)) {
+		case ETHERTYPE_IP:
+			dump_ipv4_packet(&m, NULL, &skb, 0);
+			break;
+
+		case ETHERTYPE_IPV6:
+			dump_ipv6_packet(&m, NULL, &skb, 0, 1);
+			break;
+
+		default:
+			nf_log_buf_add(&m, "NOT IMPLEMENTED");
+		}
+
+	}
+
+	nf_log_buf_exit(&m);
+	printf("%s\n", m.buf);
+}
-- 
1.9.1

