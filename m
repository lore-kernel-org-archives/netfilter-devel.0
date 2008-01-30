From: heitzenberger@astaro.com
Subject: [ULOGD RFC 27/30] NFCT: cleanup direction handling
Date: Wed, 30 Jan 2008 19:59:14 +0100
Message-ID: <20080130190130.067827371@kruemel.intranet.astaro.de>
References: <20080130185847.693274384@kruemel.intranet.astaro.de>
Cc: holger@eitzenberger.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-82.dex002.intermedia.net ([64.78.20.215]:38024 "EHLO
	dhost002-82.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756568AbYA3TBs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:01:48 -0500
Content-Disposition: inline; filename=ulogd-NFCT-tuple-indexing-cleanup.diff
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: ulogd-netfilter/input/flow/ulogd_inpflow_NFCT.c
===================================================================
--- ulogd-netfilter.orig/input/flow/ulogd_inpflow_NFCT.c
+++ ulogd-netfilter/input/flow/ulogd_inpflow_NFCT.c
@@ -41,6 +41,9 @@
 						 | NF_NETLINK_CONNTRACK_UPDATE \
 						 | NF_NETLINK_CONNTRACK_DESTROY)
 
+#define ORIG	NFCT_DIR_ORIGINAL
+#define REPL	NFCT_DIR_REPLY
+
 /* configuration defaults */
 #define TCACHE_SIZE		8192
 #define SCACHE_SIZE		512
@@ -425,14 +428,17 @@ nfct_msg_type(const struct nlmsghdr *nlh
 }
 
 
-/* seq: sequence number used for the request */
+/*
+ * nfct_get_conntrack_seq()
+ *
+ * Do GET_CONNTRACK, return seq# used.
+ */
 static int
-nfct_get_conntrack_x(struct nfct_handle *cth, struct nfct_tuple *t,
-					 int dir, uint32_t *seq)
+nfct_get_conntrack_seq(struct nfct_handle *cth, struct nfct_tuple *t,
+					  uint32_t *seq)
 {
 	static char buf[NFNL_BUFFSIZE];
 	struct nfnlhdr *req = (void *)buf;
-	int cta_dir;
 
 	memset(buf, 0, sizeof(buf));
 
@@ -444,9 +450,7 @@ nfct_get_conntrack_x(struct nfct_handle 
 	if (seq != NULL)
 		*seq = req->nlh.nlmsg_seq;
 
-	cta_dir = (dir == NFCT_DIR_ORIGINAL) ? CTA_TUPLE_ORIG : CTA_TUPLE_REPLY;
-
-	nfct_build_tuple(req, sizeof(buf), t, cta_dir);
+	nfct_build_tuple(req, sizeof(buf), t, CTA_TUPLE_ORIG);
 
 	return nfnl_send(nfct_nfnlh(cth), &req->nlh);
 }
@@ -656,8 +660,8 @@ tcache_cleanup(struct ulogd_pluginstance
 				continue;
 
 			/* check if its still there */
-			ret = nfct_get_conntrack_x(priv->cth, &ct->tuple,
-									   NFCT_DIR_ORIGINAL, &ct->last_seq);
+			ret = nfct_get_conntrack_seq(priv->cth, &ct->tuple,
+									   &ct->last_seq);
 			if (ret < 0) {
 				if (errno == EWOULDBLOCK)
 					break;
@@ -789,46 +793,48 @@ scache_cleanup(struct ulogd_pluginstance
 static int
 propagate_ct_flow(struct ulogd_pluginstance *upi, 
 				  struct nfct_conntrack *nfct, unsigned int flags,
-				  int dir, struct conntrack *ct)
+				  struct conntrack *ct)
 {
 	struct ulogd_key *ret = upi->output.keys;
 
-	ret[O_IP_SADDR].u.value.ui32 = htonl(nfct->tuple[0].src.v4);
+	ret[O_IP_SADDR].u.value.ui32 = htonl(nfct->tuple[ORIG].src.v4);
 	ret[O_IP_SADDR].flags |= ULOGD_RETF_VALID;
 
-	ret[O_IP_DADDR].u.value.ui32 = htonl(nfct->tuple[1].src.v4);
+	ret[O_IP_DADDR].u.value.ui32 = htonl(nfct->tuple[REPL].src.v4);
 	ret[O_IP_DADDR].flags |= ULOGD_RETF_VALID;
 
-	ret[O_IP_PROTO].u.value.ui8 = nfct->tuple[dir].protonum;
+	ret[O_IP_PROTO].u.value.ui8 = nfct->tuple[ORIG].protonum;
 	ret[O_IP_PROTO].flags |= ULOGD_RETF_VALID;
 
-	switch (nfct->tuple[dir].protonum) {
+	switch (nfct->tuple[ORIG].protonum) {
 	case IPPROTO_TCP:
 	case IPPROTO_UDP:
 	case IPPROTO_SCTP:
 		/* FIXME: DCCP */
-		ret[O_L4_SPORT].u.value.ui16 = htons(nfct->tuple[0].l4src.tcp.port);
+		ret[O_L4_SPORT].u.value.ui16
+			= htons(nfct->tuple[ORIG].l4src.tcp.port);
 		ret[O_L4_SPORT].flags |= ULOGD_RETF_VALID;
-		ret[O_L4_DPORT].u.value.ui16 = htons(nfct->tuple[1].l4src.tcp.port);
+		ret[O_L4_DPORT].u.value.ui16
+			= htons(nfct->tuple[REPL].l4src.tcp.port);
 		ret[O_L4_DPORT].flags |= ULOGD_RETF_VALID;
 		break;
 	case IPPROTO_ICMP:
-		ret[O_ICMP_CODE].u.value.ui8 = nfct->tuple[dir].l4src.icmp.code;
+		ret[O_ICMP_CODE].u.value.ui8 = nfct->tuple[ORIG].l4src.icmp.code;
 		ret[O_ICMP_CODE].flags |= ULOGD_RETF_VALID;
-		ret[O_ICMP_TYPE].u.value.ui8 = nfct->tuple[dir].l4src.icmp.type;
+		ret[O_ICMP_TYPE].u.value.ui8 = nfct->tuple[ORIG].l4src.icmp.type;
 		ret[O_ICMP_TYPE].flags |= ULOGD_RETF_VALID;
 		break;
 	}
 
 	if (flags & NFCT_COUNTERS_ORIG) {
-		ret[O_RAW_IN_PKTLEN].u.value.ui32 = nfct->counters[0].bytes;
+		ret[O_RAW_IN_PKTLEN].u.value.ui32 = nfct->counters[ORIG].bytes;
 		ret[O_RAW_IN_PKTLEN].flags |= ULOGD_RETF_VALID;
-		ret[O_RAW_IN_PKTCOUNT].u.value.ui32 = nfct->counters[0].packets;
+		ret[O_RAW_IN_PKTCOUNT].u.value.ui32 = nfct->counters[REPL].packets;
 		ret[O_RAW_IN_PKTCOUNT].flags |= ULOGD_RETF_VALID;
 
-		ret[O_RAW_OUT_PKTLEN].u.value.ui32 = nfct->counters[1].bytes;
+		ret[O_RAW_OUT_PKTLEN].u.value.ui32 = nfct->counters[REPL].bytes;
 		ret[O_RAW_OUT_PKTLEN].flags |= ULOGD_RETF_VALID;
-		ret[O_RAW_OUT_PKTCOUNT].u.value.ui32 = nfct->counters[1].packets;
+		ret[O_RAW_OUT_PKTCOUNT].u.value.ui32 = nfct->counters[REPL].packets;
 		ret[O_RAW_OUT_PKTCOUNT].flags |= ULOGD_RETF_VALID;
 	}
 
@@ -870,13 +876,13 @@ propagate_ct(struct ulogd_pluginstance *
 	struct nfct_pluginstance *priv = (void *)upi->private;
 
 	do {
-		if (nfct->tuple[NFCT_DIR_ORIGINAL].src.v4 == INADDR_LOOPBACK
-			|| nfct->tuple[NFCT_DIR_ORIGINAL].dst.v4 == INADDR_LOOPBACK)
+		if (nfct->tuple[ORIG].src.v4 == INADDR_LOOPBACK
+			|| nfct->tuple[ORIG].dst.v4 == INADDR_LOOPBACK)
 			break;
 
 		ct->time[STOP].tv_sec = t_now_local;
 
-		propagate_ct_flow(upi, nfct, flags, NFCT_DIR_ORIGINAL, ct);
+		propagate_ct_flow(upi, nfct, flags, ct);
 	} while (0);
 
 	cache_del(priv->tcache, ct);
@@ -900,8 +906,8 @@ do_nfct_msg(struct nlmsghdr *nlh, void *
 
 	bzero(&nfct, sizeof(nfct));
 
-	nfct.tuple[NFCT_DIR_ORIGINAL].l3protonum = 
-		nfct.tuple[NFCT_DIR_REPLY].l3protonum = nfh->nfgen_family;
+	nfct.tuple[ORIG].l3protonum =
+		nfct.tuple[REPL].l3protonum = nfh->nfgen_family;
 
 	if (nfct_netlink_to_conntrack(nlh, &nfct, &flags) < 0)
 		return -1;
@@ -910,7 +916,7 @@ do_nfct_msg(struct nlmsghdr *nlh, void *
 
 	switch (type) { 
 	case NFCT_MSG_NEW:
-		if ((ct = ct_alloc(&nfct.tuple[NFCT_DIR_ORIGINAL])) == NULL)
+		if ((ct = ct_alloc(&nfct.tuple[ORIG])) == NULL)
 			return -1;
 
 		if (cache_add(priv->tcache, ct) < 0)
@@ -918,8 +924,7 @@ do_nfct_msg(struct nlmsghdr *nlh, void *
 		break;
 
 	case NFCT_MSG_UPDATE:
-		ct = tcache_find(pi, &nfct.tuple[NFCT_DIR_ORIGINAL]);
-		if (ct == NULL) {
+		if ((ct = tcache_find(pi, &nfct.tuple[ORIG])) == NULL) {
 			/* do not add CT to cache, as there would be no start
 			   information */
 			break;
@@ -939,15 +944,14 @@ do_nfct_msg(struct nlmsghdr *nlh, void *
 
 		/* handle TCP connections differently in order not to bloat CT
 		   hash with many TIME_WAIT connections */
-		if (nfct.tuple[NFCT_DIR_ORIGINAL].protonum == IPPROTO_TCP) {
+		if (nfct.tuple[ORIG].protonum == IPPROTO_TCP) {
 			if (nfct.protoinfo.tcp.state == TCP_CONNTRACK_TIME_WAIT)
 				return propagate_ct(pi, &nfct, ct, flags);
 		}
 		break;
 		
 	case NFCT_MSG_DESTROY:
-		ct = tcache_find(pi, &nfct.tuple[NFCT_DIR_ORIGINAL]);
-		if (ct != NULL)
+		if ((ct = tcache_find(pi, &nfct.tuple[ORIG])) != NULL)
 			return propagate_ct(pi, &nfct, ct, flags);
 		break;
 		

-- 
