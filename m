From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 05/18] Add SCTP support to BASE plugin.
Date: Mon,  1 Dec 2008 22:36:03 +0100
Message-ID: <1228167376-22101-6-git-send-email-eric@inl.fr>
References: <1228167376-22101-1-git-send-email-eric@inl.fr>
Cc: pablo@netfilter.org, Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:39298 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752133AbYLAVgU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Dec 2008 16:36:20 -0500
In-Reply-To: <1228167376-22101-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

THis patch adds basic support for SCTP in the BASE plugin.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 filter/raw2packet/ulogd_raw2packet_BASE.c |   53 +++++++++++++++++++++++++++++
 1 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/filter/raw2packet/ulogd_raw2packet_BASE.c b/filter/raw2packet/ulogd_raw2packet_BASE.c
index c38c696..584d1c4 100644
--- a/filter/raw2packet/ulogd_raw2packet_BASE.c
+++ b/filter/raw2packet/ulogd_raw2packet_BASE.c
@@ -113,6 +113,10 @@ enum output_keys {
 	KEY_ARP_SPA,
 	KEY_ARP_THA,
 	KEY_ARP_TPA,
+	KEY_SCTP_SPORT,
+	KEY_SCTP_DPORT,
+	KEY_SCTP_CSUM,
+
 };
 
 static struct ulogd_key iphdr_rets[] = {
@@ -507,6 +511,21 @@ static struct ulogd_key iphdr_rets[] = {
 		.flags = ULOGD_RETF_NONE,
 		.name = "arp.daddr",
 	},
+	[KEY_SCTP_SPORT] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "sctp.sport", 
+	},
+	[KEY_SCTP_DPORT] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "sctp.dport", 
+	},
+	[KEY_SCTP_CSUM] = {
+		.type = ULOGD_RET_UINT32,
+		.flags = ULOGD_RETF_NONE,
+		.name = "sctp.csum",
+	},
 };
 
 /***********************************************************************
@@ -566,6 +585,37 @@ static int _interp_udp(struct ulogd_pluginstance *pi, struct udphdr *udph,
 }
 
 /***********************************************************************
+ * 			SCTP HEADER
+ ***********************************************************************/
+
+/* Section 3.1.  SCTP Common Header Format */
+typedef struct sctphdr {
+	__be16 source;
+	__be16 dest;
+	__be32 vtag;
+	__be32 checksum;
+} __attribute__((packed)) sctp_sctphdr_t;
+
+static int _interp_sctp(struct ulogd_pluginstance *pi, struct sctphdr *sctph,
+		       u_int32_t len)
+		
+{
+	struct ulogd_key *ret = pi->output.keys;
+
+	if (len < sizeof(struct sctphdr))
+		return ULOGD_IRET_OK;
+
+	ret[KEY_SCTP_SPORT].u.value.ui16 = ntohs(sctph->source);
+	ret[KEY_SCTP_SPORT].flags |= ULOGD_RETF_VALID;
+	ret[KEY_SCTP_DPORT].u.value.ui16 = ntohs(sctph->dest);
+	ret[KEY_SCTP_DPORT].flags |= ULOGD_RETF_VALID;
+	ret[KEY_SCTP_CSUM].u.value.ui32 = ntohl(sctph->checksum);
+	ret[KEY_SCTP_CSUM].flags |= ULOGD_RETF_VALID;
+	
+	return ULOGD_IRET_OK;
+}
+
+/***********************************************************************
  * 			ICMP HEADER
  ***********************************************************************/
 
@@ -688,6 +738,9 @@ static int _interp_iphdr(struct ulogd_pluginstance *pi, u_int32_t len)
 	case IPPROTO_ICMP:
 		_interp_icmp(pi, nexthdr, len);
 		break;
+	case IPPROTO_SCTP:
+		_interp_sctp(pi, nexthdr, len);
+		break;
 	case IPPROTO_AH:
 	case IPPROTO_ESP:
 		_interp_ahesp(pi, nexthdr, len);
-- 
1.5.6.3

