From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 02/34] [Resend] Do not propagate one conntrack event via 2 messages
Date: Sat,  2 Feb 2008 22:23:57 +0100
Message-ID: <12019874692227-git-send-email-eric@inl.fr>
References: <1201987469575-git-send-email-eric@inl.fr>
 <1201987469368-git-send-email-eric@inl.fr>
Cc: Eric leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:46035 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762243AbYBBWP5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 17:15:57 -0500
In-Reply-To: <1201987469368-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Eric leblond <eric@inl.fr>

Ulogd2 was propagating through a stack 2 message for one single conntrack event.
This patch provides a fall back to on message per event. It also uses an enum to improve
code readability instead of direct access to array via numerical index.

Signed-off-by: Eric leblond <eric@inl.fr>
---
:100644 100644 d3cd20c... bf6587d... M	input/flow/ulogd_inpflow_NFCT.c
 input/flow/ulogd_inpflow_NFCT.c |  236 ++++++++++++++++++++++++++++-----------
 1 files changed, 168 insertions(+), 68 deletions(-)

diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
index d3cd20c..bf6587d 100644
--- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -106,11 +106,101 @@ static struct config_keyset nfct_kset = {
 #define buckets_ce(x)	(x->ces[3])
 #define maxentries_ce(x) (x->ces[4])
 
+enum nfct_keys {
+	NFCT_ORIG_IP_SADDR = 0,
+	NFCT_ORIG_IP_DADDR,
+	NFCT_ORIG_IP_PROTOCOL,
+	NFCT_ORIG_L4_SPORT,
+	NFCT_ORIG_L4_DPORT,
+	NFCT_ORIG_RAW_PKTLEN,
+	NFCT_ORIG_RAW_PKTCOUNT,
+	NFCT_REPLY_IP_SADDR,
+	NFCT_REPLY_IP_DADDR,
+	NFCT_REPLY_IP_PROTOCOL,
+	NFCT_REPLY_L4_SPORT,
+	NFCT_REPLY_L4_DPORT,
+	NFCT_REPLY_RAW_PKTLEN,
+	NFCT_REPLY_RAW_PKTCOUNT,
+	NFCT_ICMP_CODE,
+	NFCT_ICMP_TYPE,
+	NFCT_CT_MARK,
+	NFCT_CT_ID,
+	NFCT_FLOW_START_SEC,
+	NFCT_FLOW_START_USEC,
+	NFCT_FLOW_END_SEC,
+	NFCT_FLOW_END_USEC,
+};
+
 static struct ulogd_key nfct_okeys[] = {
 	{
 		.type 	= ULOGD_RET_IPADDR,
 		.flags 	= ULOGD_RETF_NONE,
-		.name	= "ip.saddr",
+		.name	= "orig.ip.saddr",
+		.ipfix	= { 
+			.vendor = IPFIX_VENDOR_IETF,
+			.field_id = IPFIX_sourceIPv4Address,
+		},
+	},
+	{
+		.type	= ULOGD_RET_IPADDR,
+		.flags	= ULOGD_RETF_NONE,
+		.name	= "orig.ip.daddr",
+		.ipfix	= {
+			.vendor = IPFIX_VENDOR_IETF,
+			.field_id = IPFIX_destinationIPv4Address,
+		},
+	},
+	{
+		.type	= ULOGD_RET_UINT8,
+		.flags	= ULOGD_RETF_NONE,
+		.name	= "orig.ip.protocol",
+		.ipfix	= { 
+			.vendor = IPFIX_VENDOR_IETF,
+			.field_id = IPFIX_protocolIdentifier,
+		},
+	},
+	{
+		.type	= ULOGD_RET_UINT16,
+		.flags 	= ULOGD_RETF_NONE,
+		.name	= "orig.l4.sport",
+		.ipfix	= {
+			.vendor 	= IPFIX_VENDOR_IETF,
+			.field_id 	= IPFIX_sourceTransportPort,
+		},
+	},
+	{
+		.type	= ULOGD_RET_UINT16,
+		.flags 	= ULOGD_RETF_NONE,
+		.name	= "orig.l4.dport",
+		.ipfix	= {
+			.vendor 	= IPFIX_VENDOR_IETF,
+			.field_id 	= IPFIX_destinationTransportPort,
+		},
+	},
+	{
+		.type	= ULOGD_RET_UINT32,
+		.flags	= ULOGD_RETF_NONE,
+		.name	= "orig.raw.pktlen",
+		.ipfix	= { 
+			.vendor 	= IPFIX_VENDOR_IETF,
+			.field_id 	= IPFIX_octetTotalCount,
+			/* FIXME: this could also be octetDeltaCount */
+		},
+	},
+	{
+		.type	= ULOGD_RET_UINT32,
+		.flags	= ULOGD_RETF_NONE,
+		.name	= "orig.raw.pktcount",
+		.ipfix	= { 
+			.vendor 	= IPFIX_VENDOR_IETF,
+			.field_id 	= IPFIX_packetTotalCount,
+			/* FIXME: this could also be packetDeltaCount */
+		},
+	},
+	{
+		.type 	= ULOGD_RET_IPADDR,
+		.flags 	= ULOGD_RETF_NONE,
+		.name	= "reply.ip.saddr",
 		.ipfix	= { 
 			.vendor = IPFIX_VENDOR_IETF,
 			.field_id = IPFIX_sourceIPv4Address,
@@ -119,7 +209,7 @@ static struct ulogd_key nfct_okeys[] = {
 	{
 		.type	= ULOGD_RET_IPADDR,
 		.flags	= ULOGD_RETF_NONE,
-		.name	= "ip.daddr",
+		.name	= "reply.ip.daddr",
 		.ipfix	= {
 			.vendor = IPFIX_VENDOR_IETF,
 			.field_id = IPFIX_destinationIPv4Address,
@@ -128,7 +218,7 @@ static struct ulogd_key nfct_okeys[] = {
 	{
 		.type	= ULOGD_RET_UINT8,
 		.flags	= ULOGD_RETF_NONE,
-		.name	= "ip.protocol",
+		.name	= "reply.ip.protocol",
 		.ipfix	= { 
 			.vendor = IPFIX_VENDOR_IETF,
 			.field_id = IPFIX_protocolIdentifier,
@@ -137,7 +227,7 @@ static struct ulogd_key nfct_okeys[] = {
 	{
 		.type	= ULOGD_RET_UINT16,
 		.flags 	= ULOGD_RETF_NONE,
-		.name	= "l4.sport",
+		.name	= "reply.l4.sport",
 		.ipfix	= {
 			.vendor 	= IPFIX_VENDOR_IETF,
 			.field_id 	= IPFIX_sourceTransportPort,
@@ -146,7 +236,7 @@ static struct ulogd_key nfct_okeys[] = {
 	{
 		.type	= ULOGD_RET_UINT16,
 		.flags 	= ULOGD_RETF_NONE,
-		.name	= "l4.dport",
+		.name	= "reply.l4.dport",
 		.ipfix	= {
 			.vendor 	= IPFIX_VENDOR_IETF,
 			.field_id 	= IPFIX_destinationTransportPort,
@@ -155,7 +245,7 @@ static struct ulogd_key nfct_okeys[] = {
 	{
 		.type	= ULOGD_RET_UINT32,
 		.flags	= ULOGD_RETF_NONE,
-		.name	= "raw.pktlen",
+		.name	= "reply.raw.pktlen",
 		.ipfix	= { 
 			.vendor 	= IPFIX_VENDOR_IETF,
 			.field_id 	= IPFIX_octetTotalCount,
@@ -165,7 +255,7 @@ static struct ulogd_key nfct_okeys[] = {
 	{
 		.type	= ULOGD_RET_UINT32,
 		.flags	= ULOGD_RETF_NONE,
-		.name	= "raw.pktcount",
+		.name	= "reply.raw.pktcount",
 		.ipfix	= { 
 			.vendor 	= IPFIX_VENDOR_IETF,
 			.field_id 	= IPFIX_packetTotalCount,
@@ -244,11 +334,6 @@ static struct ulogd_key nfct_okeys[] = {
 			.field_id	= IPFIX_flowEndSeconds,
 		},
 	},
-	{
-		.type = ULOGD_RET_BOOL,
-		.flags = ULOGD_RETF_NONE,
-		.name = "dir",
-	},
 };
 
 static struct ct_htable *htable_alloc(int htable_size, int prealloc)
@@ -364,93 +449,108 @@ static struct ct_timestamp *ct_hash_get(struct ct_htable *htable, uint32_t id)
 	return ct;
 }
 
-static int propagate_ct_flow(struct ulogd_pluginstance *upi, 
-		             struct nfct_conntrack *ct,
-			     unsigned int flags,
-			     int dir,
-			     struct ct_timestamp *ts)
+static int propagate_ct(struct ulogd_pluginstance *upi,
+			struct nfct_conntrack *ct,
+			unsigned int flags,
+			struct ct_timestamp *ts)
 {
 	struct ulogd_key *ret = upi->output.keys;
+	int dir;
+	
+	dir = NFCT_DIR_ORIGINAL;
+	ret[NFCT_ORIG_IP_SADDR].u.value.ui32 = htonl(ct->tuple[dir].src.v4);
+	ret[NFCT_ORIG_IP_SADDR].flags |= ULOGD_RETF_VALID;
 
-	ret[0].u.value.ui32 = htonl(ct->tuple[dir].src.v4);
-	ret[0].flags |= ULOGD_RETF_VALID;
-
-	ret[1].u.value.ui32 = htonl(ct->tuple[dir].dst.v4);
-	ret[1].flags |= ULOGD_RETF_VALID;
+	ret[NFCT_ORIG_IP_DADDR].u.value.ui32 = htonl(ct->tuple[dir].dst.v4);
+	ret[NFCT_ORIG_IP_DADDR].flags |= ULOGD_RETF_VALID;
 
-	ret[2].u.value.ui8 = ct->tuple[dir].protonum;
-	ret[2].flags |= ULOGD_RETF_VALID;
+	ret[NFCT_ORIG_IP_PROTOCOL].u.value.ui8 = ct->tuple[dir].protonum;
+	ret[NFCT_ORIG_IP_PROTOCOL].flags |= ULOGD_RETF_VALID;
 
-	switch (ct->tuple[1].protonum) {
+	switch (ct->tuple[dir].protonum) {
 	case IPPROTO_TCP:
 	case IPPROTO_UDP:
 	case IPPROTO_SCTP:
 		/* FIXME: DCCP */
-		ret[3].u.value.ui16 = htons(ct->tuple[dir].l4src.tcp.port);
-		ret[3].flags |= ULOGD_RETF_VALID;
-		ret[4].u.value.ui16 = htons(ct->tuple[dir].l4dst.tcp.port);
-		ret[4].flags |= ULOGD_RETF_VALID;
+		ret[NFCT_ORIG_L4_SPORT].u.value.ui16 = htons(ct->tuple[dir].l4src.tcp.port);
+		ret[NFCT_ORIG_L4_SPORT].flags |= ULOGD_RETF_VALID;
+		ret[NFCT_ORIG_L4_DPORT].u.value.ui16 = htons(ct->tuple[dir].l4dst.tcp.port);
+		ret[NFCT_ORIG_L4_DPORT].flags |= ULOGD_RETF_VALID;
 		break;
 	case IPPROTO_ICMP:
-		ret[7].u.value.ui8 = ct->tuple[dir].l4src.icmp.code;
-		ret[7].flags |= ULOGD_RETF_VALID;
-		ret[8].u.value.ui8 = ct->tuple[dir].l4src.icmp.type;
-		ret[8].flags |= ULOGD_RETF_VALID;
+		ret[NFCT_ICMP_CODE].u.value.ui8 = ct->tuple[dir].l4src.icmp.code;
+		ret[NFCT_ICMP_CODE].flags |= ULOGD_RETF_VALID;
+		ret[NFCT_ICMP_TYPE].u.value.ui8 = ct->tuple[dir].l4src.icmp.type;
+		ret[NFCT_ICMP_TYPE].flags |= ULOGD_RETF_VALID;
 		break;
 	}
 
-	if ((dir == NFCT_DIR_ORIGINAL && flags & NFCT_COUNTERS_ORIG) ||
-	    (dir == NFCT_DIR_REPLY && flags & NFCT_COUNTERS_RPLY)) {
-		ret[5].u.value.ui64 = ct->counters[dir].bytes;
-		ret[5].flags |= ULOGD_RETF_VALID;
+	ret[NFCT_ORIG_RAW_PKTLEN].u.value.ui64 = ct->counters[dir].bytes;
+	ret[NFCT_ORIG_RAW_PKTLEN].flags |= ULOGD_RETF_VALID;
+
+	ret[NFCT_ORIG_RAW_PKTCOUNT].u.value.ui64 = ct->counters[dir].packets;
+	ret[NFCT_ORIG_RAW_PKTCOUNT].flags |= ULOGD_RETF_VALID;
+
+	dir = NFCT_DIR_REPLY;
+	ret[NFCT_REPLY_IP_SADDR].u.value.ui32 = htonl(ct->tuple[dir].src.v4);
+	ret[NFCT_REPLY_IP_SADDR].flags |= ULOGD_RETF_VALID;
 
-		ret[6].u.value.ui64 = ct->counters[dir].packets;
-		ret[6].flags |= ULOGD_RETF_VALID;
+	ret[NFCT_REPLY_IP_DADDR].u.value.ui32 = htonl(ct->tuple[dir].dst.v4);
+	ret[NFCT_REPLY_IP_DADDR].flags |= ULOGD_RETF_VALID;
+
+	ret[NFCT_REPLY_IP_PROTOCOL].u.value.ui8 = ct->tuple[dir].protonum;
+	ret[NFCT_REPLY_IP_PROTOCOL].flags |= ULOGD_RETF_VALID;
+
+	switch (ct->tuple[dir].protonum) {
+	case IPPROTO_TCP:
+	case IPPROTO_UDP:
+	case IPPROTO_SCTP:
+		/* FIXME: DCCP */
+		ret[NFCT_REPLY_L4_SPORT].u.value.ui16 = htons(ct->tuple[dir].l4src.tcp.port);
+		ret[NFCT_REPLY_L4_SPORT].flags |= ULOGD_RETF_VALID;
+		ret[NFCT_REPLY_L4_DPORT].u.value.ui16 = htons(ct->tuple[dir].l4dst.tcp.port);
+		ret[NFCT_REPLY_L4_DPORT].flags |= ULOGD_RETF_VALID;
+		break;
+	case IPPROTO_ICMP:
+		ret[NFCT_ICMP_CODE].u.value.ui8 = ct->tuple[dir].l4src.icmp.code;
+		ret[NFCT_ICMP_CODE].flags |= ULOGD_RETF_VALID;
+		ret[NFCT_ICMP_TYPE].u.value.ui8 = ct->tuple[dir].l4src.icmp.type;
+		ret[NFCT_ICMP_TYPE].flags |= ULOGD_RETF_VALID;
+		break;
 	}
 
+	ret[NFCT_REPLY_RAW_PKTLEN].u.value.ui64 = ct->counters[dir].bytes;
+	ret[NFCT_REPLY_RAW_PKTLEN].flags |= ULOGD_RETF_VALID;
+
+	ret[NFCT_REPLY_RAW_PKTCOUNT].u.value.ui64 = ct->counters[dir].packets;
+	ret[NFCT_REPLY_RAW_PKTCOUNT].flags |= ULOGD_RETF_VALID;
+
 	if (flags & NFCT_MARK) {
-		ret[9].u.value.ui32 = ct->mark;
-		ret[9].flags |= ULOGD_RETF_VALID;
+		ret[NFCT_CT_MARK].u.value.ui32 = ct->mark;
+		ret[NFCT_CT_MARK].flags |= ULOGD_RETF_VALID;
 	}
 
 	if (flags & NFCT_ID) {
-		ret[10].u.value.ui32 = ct->id;
-		ret[10].flags |= ULOGD_RETF_VALID;
+		ret[NFCT_CT_ID].u.value.ui32 = ct->id;
+		ret[NFCT_CT_ID].flags |= ULOGD_RETF_VALID;
 	}
 
 	if (ts) {
-		ret[11].u.value.ui32 = ts->time[START].tv_sec;
-		ret[11].flags |= ULOGD_RETF_VALID;
-		ret[12].u.value.ui32 = ts->time[START].tv_usec;
-		ret[12].flags |= ULOGD_RETF_VALID;
-		ret[13].u.value.ui32 = ts->time[STOP].tv_sec;
-		ret[13].flags |= ULOGD_RETF_VALID;
-		ret[14].u.value.ui32 = ts->time[STOP].tv_usec;
-		ret[14].flags |= ULOGD_RETF_VALID;
+		ret[NFCT_FLOW_START_SEC].u.value.ui32 = ts->time[START].tv_sec;
+		ret[NFCT_FLOW_START_SEC].flags |= ULOGD_RETF_VALID;
+		ret[NFCT_FLOW_START_USEC].u.value.ui32 = ts->time[START].tv_usec;
+		ret[NFCT_FLOW_START_USEC].flags |= ULOGD_RETF_VALID;
+		ret[NFCT_FLOW_END_SEC].u.value.ui32 = ts->time[STOP].tv_sec;
+		ret[NFCT_FLOW_END_SEC].flags |= ULOGD_RETF_VALID;
+		ret[NFCT_FLOW_END_USEC].u.value.ui32 = ts->time[STOP].tv_usec;
+		ret[NFCT_FLOW_END_USEC].flags |= ULOGD_RETF_VALID;
 	}
 
-	ret[15].u.value.b = (dir == NFCT_DIR_ORIGINAL) ? 0 : 1;
-	ret[15].flags |= ULOGD_RETF_VALID;
-
 	ulogd_propagate_results(upi);
 
 	return 0;
 }
 
-static int propagate_ct(struct ulogd_pluginstance *upi,
-			struct nfct_conntrack *ct,
-			unsigned int flags,
-			struct ct_timestamp *ctstamp)
-{
-	int rc;
-
-	rc = propagate_ct_flow(upi, ct, flags, NFCT_DIR_ORIGINAL, ctstamp);
-	if (rc < 0)
-		return rc;
-
-	return propagate_ct_flow(upi, ct, flags, NFCT_DIR_REPLY, ctstamp);
-}
-
 static int event_handler(void *arg, unsigned int flags, int type,
 			 void *data)
 {
-- 
1.5.2.5

