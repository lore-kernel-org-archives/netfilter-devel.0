From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 5/6] Port of NFCT plugin to new libnetfilter_conntrack API.
Date: Wed, 26 Mar 2008 23:49:10 +0100
Message-ID: <1206571752607-git-send-email-eric@inl.fr>
References: <12065717514081-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:36541 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754060AbYCZWtO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Mar 2008 18:49:14 -0400
In-Reply-To: <12065717514081-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch is a port to the new libnetfilter_conntrack API of the NFCT
plugin. To be able to send IP addresses to the IP2STR and IP2BIN module
oob.family and oob.protocol keys have been added.

There is only a single function which is marked as deprecated. This is
nfct_dump_conntrack_table_reset_counters. This function is used to dump
periodically counters. By default, this feature is not used. IMHO we could
suppress this code and use conntrackd for similar tasks.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
:100644 100644 19df32f... 5e5af87... M	input/flow/ulogd_inpflow_NFCT.c
 input/flow/ulogd_inpflow_NFCT.c |  146 ++++++++++++++++++++++-----------------
 1 files changed, 82 insertions(+), 64 deletions(-)

diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
index 19df32f..5e5af87 100644
--- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -141,6 +141,8 @@ enum nfct_keys {
 	NFCT_FLOW_START_USEC,
 	NFCT_FLOW_END_SEC,
 	NFCT_FLOW_END_USEC,
+	NFCT_OOB_FAMILY,
+	NFCT_OOB_PROTOCOL,
 };
 
 static struct ulogd_key nfct_okeys[] = {
@@ -352,6 +354,16 @@ static struct ulogd_key nfct_okeys[] = {
 			.field_id	= IPFIX_flowEndSeconds,
 		},
 	},
+	{
+		.type	= ULOGD_RET_UINT8,
+		.flags	= ULOGD_RETF_NONE,
+		.name	= "oob.family",
+	},
+	{
+		.type	= ULOGD_RET_UINT8,
+		.flags	= ULOGD_RETF_NONE,
+		.name	= "oob.protocol",
+	},
 };
 
 static struct ct_htable *htable_alloc(int htable_size, int prealloc)
@@ -468,94 +480,100 @@ static struct ct_timestamp *ct_hash_get(struct ct_htable *htable, uint32_t id)
 }
 
 static int propagate_ct(struct ulogd_pluginstance *upi,
-			struct nfct_conntrack *ct,
-			unsigned int flags,
+			struct nf_conntrack *ct,
 			int type,
 			struct ct_timestamp *ts)
 {
 	struct ulogd_key *ret = upi->output.keys;
-	int dir;
-
+	
 	ret[NFCT_CT_EVENT].u.value.ui32 = type;
 	ret[NFCT_CT_EVENT].flags |= ULOGD_RETF_VALID;
 
-	dir = NFCT_DIR_ORIGINAL;
-	ret[NFCT_ORIG_IP_SADDR].u.value.ui32 = htonl(ct->tuple[dir].src.v4);
-	ret[NFCT_ORIG_IP_SADDR].flags |= ULOGD_RETF_VALID;
+	ret[NFCT_OOB_FAMILY].u.value.ui8 = nfct_get_attr_u8(ct, ATTR_L3PROTO);
+	ret[NFCT_OOB_FAMILY].flags |= ULOGD_RETF_VALID;
+	/* FIXME */
+	ret[NFCT_OOB_PROTOCOL].u.value.ui8 = 0;
+	ret[NFCT_OOB_PROTOCOL].flags |= ULOGD_RETF_VALID;
 
-	ret[NFCT_ORIG_IP_DADDR].u.value.ui32 = htonl(ct->tuple[dir].dst.v4);
-	ret[NFCT_ORIG_IP_DADDR].flags |= ULOGD_RETF_VALID;
+	switch (nfct_get_attr_u8(ct, ATTR_L3PROTO)) {
+		case AF_INET:
+			ret[NFCT_ORIG_IP_SADDR].u.value.ui32 = nfct_get_attr_u32(ct, ATTR_ORIG_IPV4_SRC);
+			ret[NFCT_ORIG_IP_SADDR].flags |= ULOGD_RETF_VALID;
+			ret[NFCT_ORIG_IP_DADDR].u.value.ui32 = nfct_get_attr_u32(ct, ATTR_ORIG_IPV4_DST);
+			ret[NFCT_ORIG_IP_DADDR].flags |= ULOGD_RETF_VALID;
 
-	ret[NFCT_ORIG_IP_PROTOCOL].u.value.ui8 = ct->tuple[dir].protonum;
+			ret[NFCT_REPLY_IP_SADDR].u.value.ui32 = nfct_get_attr_u32(ct, ATTR_REPL_IPV4_SRC);
+			ret[NFCT_REPLY_IP_SADDR].flags |= ULOGD_RETF_VALID;
+			ret[NFCT_REPLY_IP_DADDR].u.value.ui32 = nfct_get_attr_u32(ct, ATTR_REPL_IPV4_DST);
+			ret[NFCT_REPLY_IP_DADDR].flags |= ULOGD_RETF_VALID;
+
+			break;
+		case AF_INET6:
+			ret[NFCT_ORIG_IP_SADDR].u.value.ptr = (struct in6_addr *)nfct_get_attr(ct, ATTR_ORIG_IPV6_SRC);
+			ret[NFCT_ORIG_IP_SADDR].flags |= ULOGD_RETF_VALID;
+			ret[NFCT_ORIG_IP_DADDR].u.value.ptr = (struct in6_addr *)nfct_get_attr(ct, ATTR_ORIG_IPV6_DST);
+			ret[NFCT_ORIG_IP_DADDR].flags |= ULOGD_RETF_VALID;
+
+			ret[NFCT_REPLY_IP_SADDR].u.value.ptr = (struct in6_addr *)nfct_get_attr(ct, ATTR_REPL_IPV6_SRC);
+			ret[NFCT_REPLY_IP_SADDR].flags |= ULOGD_RETF_VALID;
+			ret[NFCT_REPLY_IP_DADDR].u.value.ptr = (struct in6_addr *)nfct_get_attr(ct, ATTR_REPL_IPV6_DST);
+			ret[NFCT_REPLY_IP_DADDR].flags |= ULOGD_RETF_VALID;
+
+			break;
+		default:
+			ulogd_log(ULOGD_NOTICE, "Unknown protocol family (%d)\n",
+				  nfct_get_attr_u8(ct, ATTR_L3PROTO));
+	}
+	ret[NFCT_ORIG_IP_PROTOCOL].u.value.ui8 = nfct_get_attr_u8(ct, ATTR_ORIG_L4PROTO);
 	ret[NFCT_ORIG_IP_PROTOCOL].flags |= ULOGD_RETF_VALID;
+	ret[NFCT_REPLY_IP_PROTOCOL].u.value.ui8 = nfct_get_attr_u8(ct, ATTR_REPL_L4PROTO);
+	ret[NFCT_REPLY_IP_PROTOCOL].flags |= ULOGD_RETF_VALID;
 
-	switch (ct->tuple[dir].protonum) {
+	switch (nfct_get_attr_u8(ct, ATTR_ORIG_L4PROTO)) {
 	case IPPROTO_TCP:
 	case IPPROTO_UDP:
 	case IPPROTO_SCTP:
 		/* FIXME: DCCP */
-		ret[NFCT_ORIG_L4_SPORT].u.value.ui16 = htons(ct->tuple[dir].l4src.tcp.port);
+		ret[NFCT_ORIG_L4_SPORT].u.value.ui16 = htons(nfct_get_attr_u16(ct, ATTR_ORIG_PORT_SRC));
 		ret[NFCT_ORIG_L4_SPORT].flags |= ULOGD_RETF_VALID;
-		ret[NFCT_ORIG_L4_DPORT].u.value.ui16 = htons(ct->tuple[dir].l4dst.tcp.port);
+		ret[NFCT_ORIG_L4_DPORT].u.value.ui16 = htons(nfct_get_attr_u16(ct, ATTR_ORIG_PORT_DST));
 		ret[NFCT_ORIG_L4_DPORT].flags |= ULOGD_RETF_VALID;
 		break;
 	case IPPROTO_ICMP:
-		ret[NFCT_ICMP_CODE].u.value.ui8 = ct->tuple[dir].l4src.icmp.code;
+		ret[NFCT_ICMP_CODE].u.value.ui8 = nfct_get_attr_u8(ct, ATTR_ICMP_CODE);
 		ret[NFCT_ICMP_CODE].flags |= ULOGD_RETF_VALID;
-		ret[NFCT_ICMP_TYPE].u.value.ui8 = ct->tuple[dir].l4src.icmp.type;
+		ret[NFCT_ICMP_TYPE].u.value.ui8 = nfct_get_attr_u8(ct, ATTR_ICMP_TYPE);
 		ret[NFCT_ICMP_TYPE].flags |= ULOGD_RETF_VALID;
 		break;
 	}
 
-	ret[NFCT_ORIG_RAW_PKTLEN].u.value.ui64 = ct->counters[dir].bytes;
+	switch (nfct_get_attr_u8(ct, ATTR_REPL_L4PROTO)) {
+		case IPPROTO_TCP:
+		case IPPROTO_UDP:
+		case IPPROTO_SCTP:
+			ret[NFCT_REPLY_L4_SPORT].u.value.ui16 = htons(nfct_get_attr_u16(ct, ATTR_REPL_PORT_SRC));
+			ret[NFCT_REPLY_L4_SPORT].flags |= ULOGD_RETF_VALID;
+			ret[NFCT_REPLY_L4_DPORT].u.value.ui16 = htons(nfct_get_attr_u16(ct, ATTR_REPL_PORT_DST));
+			ret[NFCT_REPLY_L4_DPORT].flags |= ULOGD_RETF_VALID;
+	}
+
+	ret[NFCT_ORIG_RAW_PKTLEN].u.value.ui32 = nfct_get_attr_u32(ct, ATTR_ORIG_COUNTER_BYTES);
 	ret[NFCT_ORIG_RAW_PKTLEN].flags |= ULOGD_RETF_VALID;
 
-	ret[NFCT_ORIG_RAW_PKTCOUNT].u.value.ui64 = ct->counters[dir].packets;
+	ret[NFCT_ORIG_RAW_PKTCOUNT].u.value.ui32 = nfct_get_attr_u32(ct, ATTR_ORIG_COUNTER_PACKETS);
 	ret[NFCT_ORIG_RAW_PKTCOUNT].flags |= ULOGD_RETF_VALID;
 
-	dir = NFCT_DIR_REPLY;
-	ret[NFCT_REPLY_IP_SADDR].u.value.ui32 = htonl(ct->tuple[dir].src.v4);
-	ret[NFCT_REPLY_IP_SADDR].flags |= ULOGD_RETF_VALID;
-
-	ret[NFCT_REPLY_IP_DADDR].u.value.ui32 = htonl(ct->tuple[dir].dst.v4);
-	ret[NFCT_REPLY_IP_DADDR].flags |= ULOGD_RETF_VALID;
-
-	ret[NFCT_REPLY_IP_PROTOCOL].u.value.ui8 = ct->tuple[dir].protonum;
-	ret[NFCT_REPLY_IP_PROTOCOL].flags |= ULOGD_RETF_VALID;
-
-	switch (ct->tuple[dir].protonum) {
-	case IPPROTO_TCP:
-	case IPPROTO_UDP:
-	case IPPROTO_SCTP:
-		/* FIXME: DCCP */
-		ret[NFCT_REPLY_L4_SPORT].u.value.ui16 = htons(ct->tuple[dir].l4src.tcp.port);
-		ret[NFCT_REPLY_L4_SPORT].flags |= ULOGD_RETF_VALID;
-		ret[NFCT_REPLY_L4_DPORT].u.value.ui16 = htons(ct->tuple[dir].l4dst.tcp.port);
-		ret[NFCT_REPLY_L4_DPORT].flags |= ULOGD_RETF_VALID;
-		break;
-	case IPPROTO_ICMP:
-		ret[NFCT_ICMP_CODE].u.value.ui8 = ct->tuple[dir].l4src.icmp.code;
-		ret[NFCT_ICMP_CODE].flags |= ULOGD_RETF_VALID;
-		ret[NFCT_ICMP_TYPE].u.value.ui8 = ct->tuple[dir].l4src.icmp.type;
-		ret[NFCT_ICMP_TYPE].flags |= ULOGD_RETF_VALID;
-		break;
-	}
-
-	ret[NFCT_REPLY_RAW_PKTLEN].u.value.ui64 = ct->counters[dir].bytes;
+	ret[NFCT_REPLY_RAW_PKTLEN].u.value.ui32 = nfct_get_attr_u32(ct, ATTR_REPL_COUNTER_BYTES);;
 	ret[NFCT_REPLY_RAW_PKTLEN].flags |= ULOGD_RETF_VALID;
 
-	ret[NFCT_REPLY_RAW_PKTCOUNT].u.value.ui64 = ct->counters[dir].packets;
+	ret[NFCT_REPLY_RAW_PKTCOUNT].u.value.ui32 = nfct_get_attr_u32(ct, ATTR_REPL_COUNTER_PACKETS);
 	ret[NFCT_REPLY_RAW_PKTCOUNT].flags |= ULOGD_RETF_VALID;
 
-	if (flags & NFCT_MARK) {
-		ret[NFCT_CT_MARK].u.value.ui32 = ct->mark;
-		ret[NFCT_CT_MARK].flags |= ULOGD_RETF_VALID;
-	}
+	ret[NFCT_CT_MARK].u.value.ui32 = nfct_get_attr_u32(ct, ATTR_MARK);
+	ret[NFCT_CT_MARK].flags |= ULOGD_RETF_VALID;
 
-	if (flags & NFCT_ID) {
-		ret[NFCT_CT_ID].u.value.ui32 = ct->id;
-		ret[NFCT_CT_ID].flags |= ULOGD_RETF_VALID;
-	}
+	ret[NFCT_CT_ID].u.value.ui32 = nfct_get_attr_u32(ct, ATTR_ID);
+	ret[NFCT_CT_ID].flags |= ULOGD_RETF_VALID;
 
 	if (ts) {
 		ret[NFCT_FLOW_START_SEC].u.value.ui32 = ts->time[START].tv_sec;
@@ -574,36 +592,36 @@ static int propagate_ct(struct ulogd_pluginstance *upi,
 }
 
 /* XXX: pollinterval needs a different handler */
-static int event_handler(void *arg, unsigned int flags, int type,
+static int event_handler(enum nf_conntrack_msg_type type,
+			 struct nf_conntrack *ct,
 			 void *data)
 {
-	struct nfct_conntrack *ct = arg;
 	struct ulogd_pluginstance *upi = data;
-	struct ulogd_pluginstance *npi = NULL;
 	struct nfct_pluginstance *cpi = 
 				(struct nfct_pluginstance *) upi->private;
 	struct ct_timestamp *ts = NULL;
+	struct ulogd_pluginstance *npi = NULL;
 	int ret = 0;
 
 	if (type == NFCT_MSG_NEW) {
 		if (usehash_ce(upi->config_kset).u.value != 0) {
-			ct_hash_add(cpi->ct_active, ct->id);
+			ct_hash_add(cpi->ct_active, nfct_get_attr_u32(ct, ATTR_ID));
 			return 0;
 		}
 	} else if (type == NFCT_MSG_DESTROY) {
 		if (usehash_ce(upi->config_kset).u.value != 0)
-			ts = ct_hash_get(cpi->ct_active, ct->id);
+			ts = ct_hash_get(cpi->ct_active, nfct_get_attr_u32(ct, ATTR_ID));
 	}
 
 	/* since we support the re-use of one instance in
 	 * several different stacks, we duplicate the message
 	 * to let them know */
 	llist_for_each_entry(npi, &upi->plist, plist) {
-		ret = propagate_ct(npi, ct, flags, type, ts);
+		ret = propagate_ct(npi, ct, type, ts);
 		if (ret != 0)
 			return ret;
 	}
-	return propagate_ct(upi, ct, flags, type, ts);
+	return propagate_ct(upi, ct, type, ts);
 }
 
 static int read_cb_nfct(int fd, unsigned int what, void *param)
@@ -614,7 +632,7 @@ static int read_cb_nfct(int fd, unsigned int what, void *param)
 		return 0;
 
 	/* FIXME: implement this */
-	nfct_event_conntrack(cpi->cth);
+	nfct_catch(cpi->cth);
 	return 0;
 }
 
@@ -668,7 +686,7 @@ static int constructor_nfct(struct ulogd_pluginstance *upi)
 		return -1;
 	}
 
-	nfct_register_callback(cpi->cth, &event_handler, upi);
+	nfct_callback_register(cpi->cth, NFCT_T_ALL, &event_handler, upi);
 
 	cpi->nfct_fd.fd = nfct_fd(cpi->cth);
 	cpi->nfct_fd.cb = &read_cb_nfct;
-- 
1.5.2.5

