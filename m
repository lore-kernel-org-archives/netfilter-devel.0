From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 4/5] Use ULOGD_IRET_* as return for all interp functions.
Date: Fri,  6 Jun 2008 15:13:54 +0200
Message-ID: <1212758035-19538-5-git-send-email-eric@inl.fr>
References: <>
 <1212758035-19538-1-git-send-email-eric@inl.fr>
 <1212758035-19538-2-git-send-email-eric@inl.fr>
 <1212758035-19538-3-git-send-email-eric@inl.fr>
 <1212758035-19538-4-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:43255 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752016AbYFFNME (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jun 2008 09:12:04 -0400
In-Reply-To: <1212758035-19538-4-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch modifies plugins to use the already defined but not used
define. This also fixes some weird behaviours in error treatment (like
not stopping after OOM).

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 filter/raw2packet/ulogd_raw2packet_BASE.c |   50 ++++++++++++++--------------
 filter/ulogd_filter_IFINDEX.c             |    2 +-
 filter/ulogd_filter_IP2BIN.c              |    2 +-
 filter/ulogd_filter_IP2STR.c              |    2 +-
 filter/ulogd_filter_MAC2STR.c             |    4 +-
 filter/ulogd_filter_PRINTFLOW.c           |    2 +-
 filter/ulogd_filter_PRINTPKT.c            |    2 +-
 filter/ulogd_filter_PWSNIFF.c             |   12 +++---
 output/pcap/ulogd_output_PCAP.c           |    6 ++--
 output/ulogd_output_IPFIX.c               |    4 +-
 output/ulogd_output_LOGEMU.c              |    2 +-
 output/ulogd_output_NACCT.c               |    2 +-
 output/ulogd_output_OPRINT.c              |    2 +-
 output/ulogd_output_SYSLOG.c              |    2 +-
 14 files changed, 47 insertions(+), 47 deletions(-)

diff --git a/filter/raw2packet/ulogd_raw2packet_BASE.c b/filter/raw2packet/ulogd_raw2packet_BASE.c
index a5312e4..dde1cf3 100644
--- a/filter/raw2packet/ulogd_raw2packet_BASE.c
+++ b/filter/raw2packet/ulogd_raw2packet_BASE.c
@@ -519,7 +519,7 @@ static int _interp_tcp(struct ulogd_pluginstance *pi, struct tcphdr *tcph,
 	struct ulogd_key *ret = pi->output.keys;
 
 	if (len < sizeof(struct tcphdr))
-		return 0;
+		return ULOGD_IRET_OK;
 	
 	ret[KEY_TCP_SPORT].u.value.ui16 = ntohs(tcph->source);
 	ret[KEY_TCP_SPORT].flags |= ULOGD_RETF_VALID;
@@ -559,7 +559,7 @@ static int _interp_tcp(struct ulogd_pluginstance *pi, struct tcphdr *tcph,
 	ret[KEY_TCP_CSUM].u.value.ui16 = ntohs(tcph->check);
 	ret[KEY_TCP_CSUM].u.value.ui16 = ULOGD_RETF_VALID;
 	
-	return 0;
+	return ULOGD_IRET_OK;
 }
 
 /***********************************************************************
@@ -573,7 +573,7 @@ static int _interp_udp(struct ulogd_pluginstance *pi, struct udphdr *udph,
 	struct ulogd_key *ret = pi->output.keys;
 
 	if (len < sizeof(struct udphdr))
-		return 0;
+		return ULOGD_IRET_OK;
 
 	ret[KEY_UDP_SPORT].u.value.ui16 = ntohs(udph->source);
 	ret[KEY_UDP_SPORT].flags |= ULOGD_RETF_VALID;
@@ -584,7 +584,7 @@ static int _interp_udp(struct ulogd_pluginstance *pi, struct udphdr *udph,
 	ret[KEY_UDP_CSUM].u.value.ui16 = ntohs(udph->check);
 	ret[KEY_UDP_CSUM].flags |= ULOGD_RETF_VALID;
 	
-	return 0;
+	return ULOGD_IRET_OK;
 }
 
 /***********************************************************************
@@ -597,7 +597,7 @@ static int _interp_icmp(struct ulogd_pluginstance *pi, struct icmphdr *icmph,
 	struct ulogd_key *ret = pi->output.keys;
 
 	if (len < sizeof(struct icmphdr))
-		return 0;
+		return ULOGD_IRET_OK;
 
 	ret[KEY_ICMP_TYPE].u.value.ui8 = icmph->type;
 	ret[KEY_ICMP_TYPE].flags |= ULOGD_RETF_VALID;
@@ -627,7 +627,7 @@ static int _interp_icmp(struct ulogd_pluginstance *pi, struct icmphdr *icmph,
 	ret[KEY_ICMP_CSUM].u.value.ui16 = icmph->checksum;
 	ret[KEY_ICMP_CSUM].flags |= ULOGD_RETF_VALID;
 
-	return 0;
+	return ULOGD_IRET_OK;
 }
 
 /***********************************************************************
@@ -640,7 +640,7 @@ static int _interp_icmpv6(struct ulogd_pluginstance *pi, struct icmp6_hdr *icmph
 	struct ulogd_key *ret = pi->output.keys;
 
 	if (len < sizeof(struct icmp6_hdr))
-		return 0;
+		return ULOGD_IRET_OK;
 
 	ret[KEY_ICMPV6_TYPE].u.value.ui8 = icmph->icmp6_type;
 	ret[KEY_ICMPV6_TYPE].flags |= ULOGD_RETF_VALID;
@@ -659,7 +659,7 @@ static int _interp_icmpv6(struct ulogd_pluginstance *pi, struct icmp6_hdr *icmph
 	ret[KEY_ICMPV6_CSUM].u.value.ui16 = icmph->icmp6_cksum;
 	ret[KEY_ICMPV6_CSUM].flags |= ULOGD_RETF_VALID;
 
-	return 0;
+	return ULOGD_IRET_OK;
 }
 
 
@@ -680,7 +680,7 @@ static int _interp_ahesp(struct ulogd_pluginstance *pi, void *protoh,
 	ret[KEY_AHESP_SPI].flags |= ULOGD_RETF_VALID;
 #endif
 
-	return 0;
+	return ULOGD_IRET_OK;
 }
 
 /***********************************************************************
@@ -695,7 +695,7 @@ static int _interp_iphdr(struct ulogd_pluginstance *pi, u_int32_t len)
 	void *nexthdr = (u_int32_t *)iph + iph->ihl;
 
 	if (len < sizeof(struct iphdr) || len <= iph->ihl * 4)
-		return 0;
+		return ULOGD_IRET_OK;
 	len -= iph->ihl * 4;
 
 	ret[KEY_IP_SADDR].u.value.ui32 = iph->saddr;
@@ -735,7 +735,7 @@ static int _interp_iphdr(struct ulogd_pluginstance *pi, u_int32_t len)
 		break;
 	}
 
-	return 0;
+	return ULOGD_IRET_OK;
 }
 
 /***********************************************************************
@@ -751,9 +751,9 @@ static int ip6_ext_hdr(u_int8_t nexthdr)
 	case IPPROTO_ESP:
 	case IPPROTO_AH:
 	case IPPROTO_DSTOPTS:
-		return 1;
+		return ULOGD_IRET_OK;
 	default:
-		return 0;
+		return ULOGD_IRET_STOP;
 	}
 }
 
@@ -767,7 +767,7 @@ static int _interp_ipv6hdr(struct ulogd_pluginstance *pi, u_int32_t len)
 	int fragment = 0;
 
 	if (len < sizeof(struct ip6_hdr))
-		return 0;
+		return ULOGD_IRET_OK;
 
 	memcpy(ret[KEY_IP_SADDR].u.value.ui128, &ipv6h->ip6_src,
 	       sizeof(ipv6h->ip6_src));
@@ -792,7 +792,7 @@ static int _interp_ipv6hdr(struct ulogd_pluginstance *pi, u_int32_t len)
 		struct ip6_ext *ext = (void *)ipv6h + ptr;
 
 		if (len < sizeof(struct ip6_ext))
-			return 0;
+			return ULOGD_IRET_OK;
 
 		switch (curhdr) {
 		case IPPROTO_FRAGMENT: {
@@ -800,7 +800,7 @@ static int _interp_ipv6hdr(struct ulogd_pluginstance *pi, u_int32_t len)
 
 			hdrlen = sizeof(struct ip6_frag);
 			if (len < hdrlen)
-				return 0;
+				return ULOGD_IRET_OK;
 			len -= hdrlen;
 
 			ret[KEY_IP6_FRAG_OFF].u.value.ui16 = ntohs(fh->ip6f_offlg & IP6F_OFF_MASK);
@@ -820,7 +820,7 @@ static int _interp_ipv6hdr(struct ulogd_pluginstance *pi, u_int32_t len)
 
 			hdrlen = (ext->ip6e_len + 1) << 3;
 			if (len < hdrlen)
-				return 0;
+				return ULOGD_IRET_OK;
 			len -= hdrlen;
 			break;
 		case IPPROTO_AH:
@@ -829,7 +829,7 @@ static int _interp_ipv6hdr(struct ulogd_pluginstance *pi, u_int32_t len)
 
 			hdrlen = (ext->ip6e_len + 2) << 2;
 			if (len < hdrlen)
-				return 0;
+				return ULOGD_IRET_OK;
 			len -= hdrlen;
 
 			_interp_ahesp(pi, (void *)ext, len);
@@ -840,13 +840,13 @@ static int _interp_ipv6hdr(struct ulogd_pluginstance *pi, u_int32_t len)
 
 			hdrlen = (ext->ip6e_len + 2) << 2;
 			if (len < hdrlen)
-				return 0;
+				return ULOGD_IRET_OK;
 			len -= hdrlen;
 
 			_interp_ahesp(pi, (void *)ext, len);
 			goto out;
 		default:
-			return 0;
+			return ULOGD_IRET_OK;
 		}
 
 		curhdr = ext->ip6e_nxt;
@@ -875,7 +875,7 @@ static int _interp_ipv6hdr(struct ulogd_pluginstance *pi, u_int32_t len)
 out:
 	ret[KEY_IP6_NEXTHDR].u.value.ui8 = curhdr;
 	ret[KEY_IP6_NEXTHDR].flags |= ULOGD_RETF_VALID;
-	return 0;
+	return ULOGD_IRET_OK;
 }
 
 /***********************************************************************
@@ -888,7 +888,7 @@ static int _interp_arp(struct ulogd_pluginstance *pi, u_int32_t len)
 		GET_VALUE(pi->input.keys, INKEY_RAW_PCKT).ptr;
 
 	if (len < sizeof(struct ether_arp))
-		return 0;
+		return ULOGD_IRET_OK;
 
 	ret[KEY_ARP_HTYPE].u.value.ui16 = ntohs(arph->arp_hrd);
 	SET_VALID(ret[KEY_ARP_HTYPE]);
@@ -911,7 +911,7 @@ static int _interp_arp(struct ulogd_pluginstance *pi, u_int32_t len)
 	       sizeof(u_int32_t));
 	SET_VALID(ret[KEY_ARP_TPA]);
 
-	return 0;
+	return ULOGD_IRET_OK;
 }
 
 /***********************************************************************
@@ -939,7 +939,7 @@ static int _interp_bridge(struct ulogd_pluginstance *pi, u_int32_t len)
 	/* ETH_P_8021Q ?? others? */
 	};
 
-	return 0;
+	return ULOGD_IRET_OK;
 }
 
 
@@ -961,7 +961,7 @@ static int _interp_pkt(struct ulogd_pluginstance *pi)
 	case AF_BRIDGE:
 		return _interp_bridge(pi, len);
 	}
-	return 0;
+	return ULOGD_IRET_OK;
 }
 
 static struct ulogd_key base_inp[] = {
diff --git a/filter/ulogd_filter_IFINDEX.c b/filter/ulogd_filter_IFINDEX.c
index 468a4c4..6491127 100644
--- a/filter/ulogd_filter_IFINDEX.c
+++ b/filter/ulogd_filter_IFINDEX.c
@@ -76,7 +76,7 @@ static int interp_ifindex(struct ulogd_pluginstance *pi)
 		((char *)(ret[1].u.value.ptr))[0] = 0; 
 	ret[1].flags |= ULOGD_RETF_VALID;
 
-	return 0;
+	return ULOGD_IRET_OK;
 }
 
 static int nlif_read_cb(int fd, unsigned int what, void *param)
diff --git a/filter/ulogd_filter_IP2BIN.c b/filter/ulogd_filter_IP2BIN.c
index 7412e38..d1b3c47 100644
--- a/filter/ulogd_filter_IP2BIN.c
+++ b/filter/ulogd_filter_IP2BIN.c
@@ -186,7 +186,7 @@ static int interp_ip2bin(struct ulogd_pluginstance *pi)
 		}
 	}
 
-	return 0;
+	return ULOGD_IRET_OK;
 }
 
 static struct ulogd_plugin ip2bin_pluging = {
diff --git a/filter/ulogd_filter_IP2STR.c b/filter/ulogd_filter_IP2STR.c
index 9ad3b81..a1c1e87 100644
--- a/filter/ulogd_filter_IP2STR.c
+++ b/filter/ulogd_filter_IP2STR.c
@@ -204,7 +204,7 @@ static int interp_ip2str(struct ulogd_pluginstance *pi)
 		}
 	}
 
-	return 0;
+	return ULOGD_IRET_OK;
 }
 
 static struct ulogd_plugin ip2str_pluging = {
diff --git a/filter/ulogd_filter_MAC2STR.c b/filter/ulogd_filter_MAC2STR.c
index 38d0565..0035886 100644
--- a/filter/ulogd_filter_MAC2STR.c
+++ b/filter/ulogd_filter_MAC2STR.c
@@ -74,7 +74,7 @@ static int interp_mac2str(struct ulogd_pluginstance *pi)
 		int i;
 		
 		if (mac_str == NULL)
-			return -1;
+			return ULOGD_IRET_ERR;
 
 		for (i = 0; i < len; i++)
 			buf_cur += sprintf(buf_cur, "%02x%c", mac[i],
@@ -84,7 +84,7 @@ static int interp_mac2str(struct ulogd_pluginstance *pi)
 		ret[KEY_MAC_SADDR].flags |= ULOGD_RETF_VALID;
 	}
 
-	return 0;
+	return ULOGD_IRET_OK;
 }
 
 static struct ulogd_plugin mac2str_pluging = {
diff --git a/filter/ulogd_filter_PRINTFLOW.c b/filter/ulogd_filter_PRINTFLOW.c
index 181c09e..b78c37b 100644
--- a/filter/ulogd_filter_PRINTFLOW.c
+++ b/filter/ulogd_filter_PRINTFLOW.c
@@ -39,7 +39,7 @@ static int printflow_interp(struct ulogd_pluginstance *upi)
 	printflow_print(inp, buf);
 	ret[0].u.value.ptr = buf;
 	ret[0].flags |= ULOGD_RETF_VALID;
-	return 0;
+	return ULOGD_IRET_OK;
 }
 
 static struct ulogd_plugin printflow_plugin = {
diff --git a/filter/ulogd_filter_PRINTPKT.c b/filter/ulogd_filter_PRINTPKT.c
index 09f0fdf..62a3cf7 100644
--- a/filter/ulogd_filter_PRINTPKT.c
+++ b/filter/ulogd_filter_PRINTPKT.c
@@ -39,7 +39,7 @@ static int printpkt_interp(struct ulogd_pluginstance *upi)
 	printpkt_print(inp, buf);
 	ret[0].u.value.ptr = buf;
 	ret[0].flags |= ULOGD_RETF_VALID;
-	return 0;
+	return ULOGD_IRET_OK;
 }
 
 static struct ulogd_plugin printpkt_plugin = {
diff --git a/filter/ulogd_filter_PWSNIFF.c b/filter/ulogd_filter_PWSNIFF.c
index 2efc07d..95d92b5 100644
--- a/filter/ulogd_filter_PWSNIFF.c
+++ b/filter/ulogd_filter_PWSNIFF.c
@@ -70,7 +70,7 @@ static int interp_pwsniff(struct ulogd_pluginstance *pi)
 	int len, pw_len, i, cont = 0;
 
 	if (!IS_VALID(pi->input.keys[0]))
-		return 0;
+		return ULOGD_IRET_STOP;
 	
 	iph = (struct iphdr *) pi->input.keys[0].u.value.ptr;
 	protoh = (u_int32_t *)iph + iph->ihl;
@@ -81,7 +81,7 @@ static int interp_pwsniff(struct ulogd_pluginstance *pi)
 	begp = pw_begp = NULL;
 
 	if (iph->protocol != IPPROTO_TCP)
-		return 0;
+		return ULOGD_IRET_STOP;
 	
 	for (i = 0; i < ARRAY_SIZE(pwsniff_ports); i++)
 	{
@@ -91,7 +91,7 @@ static int interp_pwsniff(struct ulogd_pluginstance *pi)
 		}
 	}
 	if (!cont)
-		return 0;
+		return ULOGD_IRET_STOP;
 
 	DEBUGP("----> pwsniff detected, tcplen=%d, struct=%d, iphtotlen=%d, "
 		"ihl=%d\n", tcplen, sizeof(struct tcphdr), ntohs(iph->tot_len),
@@ -120,7 +120,7 @@ static int interp_pwsniff(struct ulogd_pluginstance *pi)
 		ret[0].flags |= ULOGD_RETF_VALID;
 		if (!ret[0].u.value.ptr) {
 			ulogd_log(ULOGD_ERROR, "OOM (size=%u)\n", len);
-			return 0;
+			return ULOGD_IRET_ERR;
 		}
 		strncpy((char *) ret[0].u.value.ptr, (char *)begp, len);
 		*((char *)ret[0].u.value.ptr + len) = '\0';
@@ -130,13 +130,13 @@ static int interp_pwsniff(struct ulogd_pluginstance *pi)
 		ret[1].flags |= ULOGD_RETF_VALID;
 		if (!ret[1].u.value.ptr){
 			ulogd_log(ULOGD_ERROR, "OOM (size=%u)\n", pw_len);
-			return 0;
+			return ULOGD_IRET_ERR;
 		}
 		strncpy((char *)ret[1].u.value.ptr, (char *)pw_begp, pw_len);
 		*((char *)ret[1].u.value.ptr + pw_len) = '\0';
 
 	}
-	return 0;
+	return ULOGD_IRET_OK;
 }
 
 static struct ulogd_key pwsniff_inp[] = {
diff --git a/output/pcap/ulogd_output_PCAP.c b/output/pcap/ulogd_output_PCAP.c
index 69656b1..0a714e6 100644
--- a/output/pcap/ulogd_output_PCAP.c
+++ b/output/pcap/ulogd_output_PCAP.c
@@ -154,18 +154,18 @@ static int interp_pcap(struct ulogd_pluginstance *upi)
 	if (fwrite(&pchdr, sizeof(pchdr), 1, pi->of) != 1) {
 		ulogd_log(ULOGD_ERROR, "Error during write: %s\n",
 			  strerror(errno));
-		return 1;
+		return ULOGD_IRET_ERR;
 	}
 	if (fwrite(GET_VALUE(res, 0).ptr, pchdr.caplen, 1, pi->of) != 1) {
 		ulogd_log(ULOGD_ERROR, "Error during write: %s\n",
 			  strerror(errno));
-		return 1;
+		return ULOGD_IRET_ERR;
 	}
 
 	if (upi->config_kset->ces[1].u.value)
 		fflush(pi->of);
 
-	return 0;
+	return ULOGD_IRET_OK;
 }
 
 /* stolen from libpcap savefile.c */
diff --git a/output/ulogd_output_IPFIX.c b/output/ulogd_output_IPFIX.c
index 71913eb..9004e4d 100644
--- a/output/ulogd_output_IPFIX.c
+++ b/output/ulogd_output_IPFIX.c
@@ -328,7 +328,7 @@ static int output_ipfix(struct ulogd_pluginstance *upi)
 		template = build_template_for_bitmask(upi, ii->valid_bitmask);
 		if (!template) {
 			ulogd_log(ULOGD_ERROR, "can't build new template!\n");
-			return -1;
+			return ULOGD_IRET_ERR;
 		}
 		/* FIXME: prepend? */
 		list_add(&ii->template_list, &template->list);
@@ -344,7 +344,7 @@ static int output_ipfix(struct ulogd_pluginstance *upi)
 		total_size += sizeof(template->tmpl);
 	}
 
-	return 0;
+	return ULOGD_IRET_OK;
 }
 
 static int open_connect_socket(struct ulogd_pluginstance *pi)
diff --git a/output/ulogd_output_LOGEMU.c b/output/ulogd_output_LOGEMU.c
index b8d3903..cab3b0c 100644
--- a/output/ulogd_output_LOGEMU.c
+++ b/output/ulogd_output_LOGEMU.c
@@ -108,7 +108,7 @@ static int _output_logemu(struct ulogd_pluginstance *upi)
 			fflush(li->of);
 	}
 
-	return 0;
+	return ULOGD_IRET_OK;
 }
 
 static void signal_handler_logemu(struct ulogd_pluginstance *pi, int signal)
diff --git a/output/ulogd_output_NACCT.c b/output/ulogd_output_NACCT.c
index 278df36..4897959 100644
--- a/output/ulogd_output_NACCT.c
+++ b/output/ulogd_output_NACCT.c
@@ -154,7 +154,7 @@ nacct_interp(struct ulogd_pluginstance *pi)
 	if (NACCT_CFG_SYNC(pi) != 0)
 		fflush(priv->of);
 
-	return 0;
+	return ULOGD_IRET_OK;
 }
 
 static struct config_keyset nacct_kset = {
diff --git a/output/ulogd_output_OPRINT.c b/output/ulogd_output_OPRINT.c
index 6990f8c..c2fce38 100644
--- a/output/ulogd_output_OPRINT.c
+++ b/output/ulogd_output_OPRINT.c
@@ -94,7 +94,7 @@ static int oprint_interp(struct ulogd_pluginstance *upi)
 	if (upi->config_kset->ces[1].u.value != 0)
 		fflush(opi->of);
 
-	return 0;
+	return ULOGD_IRET_OK;
 }
 
 static struct config_keyset oprint_kset = {
diff --git a/output/ulogd_output_SYSLOG.c b/output/ulogd_output_SYSLOG.c
index e6c05bd..8982e7e 100644
--- a/output/ulogd_output_SYSLOG.c
+++ b/output/ulogd_output_SYSLOG.c
@@ -79,7 +79,7 @@ static int _output_syslog(struct ulogd_pluginstance *upi)
 		syslog(li->syslog_level | li->syslog_facility, "%s",
 				res[0].u.source->u.value.ptr);
 
-	return 0;
+	return ULOGD_IRET_OK;
 }
 		
 static int syslog_configure(struct ulogd_pluginstance *pi,
-- 
1.5.4.3

