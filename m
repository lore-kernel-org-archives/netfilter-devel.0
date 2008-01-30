From: heitzenberger@astaro.com
Subject: [ULOGD RFC 29/30] NFCT: adapt to new libnetfilter_conntrack
Date: Wed, 30 Jan 2008 19:59:16 +0100
Message-ID: <20080130190130.347773797@kruemel.intranet.astaro.de>
References: <20080130185847.693274384@kruemel.intranet.astaro.de>
Cc: holger@eitzenberger.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-32.dex002.intermedia.net ([64.78.21.117]:13813 "EHLO
	dhost002-32.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755563AbYA3TBp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:01:45 -0500
Content-Disposition: inline; filename=ulogd-NFCT-new-lib.diff
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Short-term solution until using libnl for that.

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: ulogd-netfilter/input/flow/ulogd_inpflow_NFCT.c
===================================================================
--- ulogd-netfilter.orig/input/flow/ulogd_inpflow_NFCT.c
+++ ulogd-netfilter/input/flow/ulogd_inpflow_NFCT.c
@@ -84,6 +84,7 @@ struct cache {
 struct nfct_pluginstance {
 	struct nfct_handle *cth;
 	struct ulogd_fd nfct_fd;
+	struct nf_conntrack *nfct_opaque;
 	struct cache *tcache;       /* tuple cache */
 	struct cache *scache;       /* sequence cache */
 	struct ulogd_timer timer;
@@ -795,8 +796,8 @@ scache_cleanup(struct ulogd_pluginstance
 
 static int
 propagate_ct_flow(struct ulogd_pluginstance *upi, 
-				  struct nfct_conntrack *nfct, unsigned int flags,
-				  struct conntrack *ct)
+				  const struct nfct_conntrack *nfct,
+				  const struct conntrack *ct)
 {
 	struct ulogd_key *ret = upi->output.keys;
 
@@ -829,27 +830,21 @@ propagate_ct_flow(struct ulogd_pluginsta
 		break;
 	}
 
-	if (flags & NFCT_COUNTERS_ORIG) {
-		ret[O_RAW_IN_PKTLEN].u.value.ui32 = nfct->counters[ORIG].bytes;
-		ret[O_RAW_IN_PKTLEN].flags |= ULOGD_RETF_VALID;
-		ret[O_RAW_IN_PKTCOUNT].u.value.ui32 = nfct->counters[REPL].packets;
-		ret[O_RAW_IN_PKTCOUNT].flags |= ULOGD_RETF_VALID;
-
-		ret[O_RAW_OUT_PKTLEN].u.value.ui32 = nfct->counters[REPL].bytes;
-		ret[O_RAW_OUT_PKTLEN].flags |= ULOGD_RETF_VALID;
-		ret[O_RAW_OUT_PKTCOUNT].u.value.ui32 = nfct->counters[REPL].packets;
-		ret[O_RAW_OUT_PKTCOUNT].flags |= ULOGD_RETF_VALID;
-	}
+	ret[O_RAW_IN_PKTLEN].u.value.ui32 = nfct->counters[ORIG].bytes;
+	ret[O_RAW_IN_PKTLEN].flags |= ULOGD_RETF_VALID;
+	ret[O_RAW_IN_PKTCOUNT].u.value.ui32 = nfct->counters[ORIG].packets;
+	ret[O_RAW_IN_PKTCOUNT].flags |= ULOGD_RETF_VALID;
+
+	ret[O_RAW_OUT_PKTLEN].u.value.ui32 = nfct->counters[REPL].bytes;
+	ret[O_RAW_OUT_PKTLEN].flags |= ULOGD_RETF_VALID;
+	ret[O_RAW_OUT_PKTCOUNT].u.value.ui32 = nfct->counters[REPL].packets;
+	ret[O_RAW_OUT_PKTCOUNT].flags |= ULOGD_RETF_VALID;
 
-	if (flags & NFCT_MARK) {
-		ret[O_CT_MARK].u.value.ui32 = nfct->mark;
-		ret[O_CT_MARK].flags |= ULOGD_RETF_VALID;
-	}
+	ret[O_CT_MARK].u.value.ui32 = nfct->mark;
+	ret[O_CT_MARK].flags |= ULOGD_RETF_VALID;
 
-	if (flags & NFCT_ID) {
-		ret[O_CT_ID].u.value.ui32 = nfct->id;
-		ret[O_CT_ID].flags |= ULOGD_RETF_VALID;
-	}
+	ret[O_CT_ID].u.value.ui32 = nfct->id;
+	ret[O_CT_ID].flags |= ULOGD_RETF_VALID;
 
 	ret[O_FLOW_START_SEC].u.value.ui32 = ct->time[START].tv_sec;
 	ret[O_FLOW_START_SEC].flags |= ULOGD_RETF_VALID;
@@ -873,8 +868,8 @@ propagate_ct_flow(struct ulogd_pluginsta
 }
 
 static int
-propagate_ct(struct ulogd_pluginstance *upi, struct nfct_conntrack *nfct,
-			 struct conntrack *ct, unsigned int flags)
+propagate_ct(struct ulogd_pluginstance *upi,
+			 struct nfct_conntrack *nfct, struct conntrack *ct)
 {
 	struct nfct_pluginstance *priv = (void *)upi->private;
 
@@ -885,7 +880,7 @@ propagate_ct(struct ulogd_pluginstance *
 
 		ct->time[STOP].tv_sec = t_now_local;
 
-		propagate_ct_flow(upi, nfct, flags, ct);
+		propagate_ct_flow(upi, nfct, ct);
 	} while (0);
 
 	cache_del(priv->tcache, ct);
@@ -893,26 +888,97 @@ propagate_ct(struct ulogd_pluginstance *
 	return 0;
 }
 
+/* nfct_to_conntrack() - translate from opaque type to nfct_conntrack */
+static int
+nfct_to_conntrack(const struct ulogd_pluginstance *pi,
+				  const struct nf_conntrack *ct, struct nfct_conntrack *out)
+{
+	bzero(out, sizeof(struct nfct_conntrack));
+
+	assert(nfct_attr_is_set(ct, ATTR_L3PROTO));
+	out->tuple[ORIG].l3protonum = nfct_get_attr_u8(ct, ATTR_L3PROTO);
+
+	assert(nfct_attr_is_set(ct, ATTR_L4PROTO));
+	out->tuple[ORIG].protonum = nfct_get_attr_u8(ct, ATTR_L4PROTO);
+
+	out->tuple[ORIG].src.v4 = nfct_get_attr_u32(ct, ATTR_IPV4_SRC);
+	out->tuple[REPL].src.v4 = nfct_get_attr_u32(ct, ATTR_REPL_IPV4_SRC);
+	out->tuple[ORIG].dst.v4 = nfct_get_attr_u32(ct, ATTR_IPV4_DST);
+	out->tuple[REPL].dst.v4 = nfct_get_attr_u32(ct, ATTR_REPL_IPV4_DST);
+
+	if (out->tuple[ORIG].l3protonum == IPPROTO_ICMP) {
+		out->tuple[ORIG].l4src.icmp.type
+			= nfct_get_attr_u8(ct, ATTR_ICMP_TYPE);
+		out->tuple[ORIG].l4src.icmp.code
+			= nfct_get_attr_u8(ct, ATTR_ICMP_CODE);
+		out->tuple[ORIG].l4src.icmp.id
+			= nfct_get_attr_u16(ct, ATTR_ICMP_ID);
+	}
+
+	if (out->tuple[ORIG].protonum == IPPROTO_TCP
+		|| out->tuple[ORIG].protonum == IPPROTO_UDP) {
+		assert(nfct_attr_is_set(ct, ATTR_ORIG_PORT_SRC));
+		out->tuple[ORIG].l4src.tcp.port
+			= nfct_get_attr_u16(ct, ATTR_ORIG_PORT_SRC);
+
+		assert(nfct_attr_is_set(ct, ATTR_ORIG_PORT_DST));
+		out->tuple[ORIG].l4dst.tcp.port
+			= nfct_get_attr_u16(ct, ATTR_ORIG_PORT_DST);
+
+		assert(nfct_attr_is_set(ct, ATTR_REPL_PORT_SRC));
+		out->tuple[REPL].l4src.tcp.port
+			= nfct_get_attr_u16(ct, ATTR_REPL_PORT_SRC);
+
+		assert(nfct_attr_is_set(ct, ATTR_REPL_PORT_DST));
+		out->tuple[REPL].l4dst.tcp.port
+			= nfct_get_attr_u16(ct, ATTR_REPL_PORT_DST);
+
+		if (nfct_attr_is_set(ct, ATTR_TCP_STATE))
+			out->protoinfo.tcp.state = nfct_get_attr_u8(ct, ATTR_TCP_STATE);
+	}
+
+	if (nfct_attr_is_set(ct, ATTR_STATUS))
+		out->status = nfct_get_attr_u32(ct, ATTR_STATUS);
+	if (nfct_attr_is_set(ct, ATTR_TIMEOUT))
+		out->timeout = nfct_get_attr_u32(ct, ATTR_TIMEOUT);
+	if (nfct_attr_is_set(ct, ATTR_MARK))
+		out->mark = nfct_get_attr_u32(ct, ATTR_MARK);
+	if (nfct_attr_is_set(ct, ATTR_USE))
+		out->use = nfct_get_attr_u32(ct, ATTR_USE);
+
+	/* counter */
+	if (nfct_attr_is_set(ct, ATTR_ORIG_COUNTER_BYTES))
+		out->counters[ORIG].bytes
+			= nfct_get_attr_u32(ct, ATTR_ORIG_COUNTER_BYTES);
+	if (nfct_attr_is_set(ct, ATTR_ORIG_COUNTER_PACKETS))
+		out->counters[ORIG].packets
+			= nfct_get_attr_u32(ct, ATTR_ORIG_COUNTER_PACKETS);
+	if (nfct_attr_is_set(ct, ATTR_REPL_COUNTER_BYTES))
+		out->counters[ORIG].bytes
+			= nfct_get_attr_u32(ct, ATTR_REPL_COUNTER_BYTES);
+	if (nfct_attr_is_set(ct, ATTR_REPL_COUNTER_PACKETS))
+		out->counters[REPL].packets
+			= nfct_get_attr_u32(ct, ATTR_REPL_COUNTER_PACKETS);
+
+	return 0;
+}
 
 static int
 do_nfct_msg(struct nlmsghdr *nlh, void *arg)
 {
 	struct ulogd_pluginstance *pi = arg;
 	struct nfct_pluginstance *priv = (void *)pi->private;
-	struct nfgenmsg *nfh = NLMSG_DATA(nlh);
 	struct nfct_conntrack nfct;
 	struct conntrack *ct;
-	int flags, type = nfct_msg_type(nlh);
+	int type = nfct_msg_type(nlh);
 
 	if (type == NFCT_MSG_UNKNOWN)
 		return 0;
 
-	bzero(&nfct, sizeof(nfct));
-
-	nfct.tuple[ORIG].l3protonum =
-		nfct.tuple[REPL].l3protonum = nfh->nfgen_family;
+	if (nfct_parse_conntrack(NFCT_T_ALL, nlh, priv->nfct_opaque) < 0)
+		return -1;
 
-	if (nfct_netlink_to_conntrack(nlh, &nfct, &flags) < 0)
+	if (nfct_to_conntrack(pi, priv->nfct_opaque, &nfct) < 0)
 		return -1;
 
 	/* TODO handle NFCT_COUNTER_FILLING */
@@ -949,13 +1015,13 @@ do_nfct_msg(struct nlmsghdr *nlh, void *
 		   hash with many TIME_WAIT connections */
 		if (nfct.tuple[ORIG].protonum == IPPROTO_TCP) {
 			if (nfct.protoinfo.tcp.state == TCP_CONNTRACK_TIME_WAIT)
-				return propagate_ct(pi, &nfct, ct, flags);
+				return propagate_ct(pi, &nfct, ct);
 		}
 		break;
 		
 	case NFCT_MSG_DESTROY:
 		if ((ct = tcache_find(pi, &nfct.tuple[ORIG])) != NULL)
-			return propagate_ct(pi, &nfct, ct, flags);
+			return propagate_ct(pi, &nfct, ct);
 		break;
 		
 	default:
@@ -1070,8 +1136,15 @@ nfct_start(struct ulogd_pluginstance *up
 		return 0;
 	}
 
+	if (priv->nfct_opaque == NULL) {
+		if ((priv->nfct_opaque = nfct_new()) == NULL) {
+			ulogd_log(ULOGD_FATAL, "%s: out of memory\n", upi->id);
+			return -1;
+		}
+	}
+
 	if (init_caches(upi) < 0)
-		return -1;
+		goto err_free;
 
 	priv->cth = nfct_open(NFNL_SUBSYS_CTNETLINK, CT_EVENTS);
 	if (priv->cth == NULL) {
@@ -1111,6 +1184,8 @@ nfct_start(struct ulogd_pluginstance *up
 	nfct_close(priv->cth);
 	priv->cth = NULL;
  err_free:
+	free(priv->nfct_opaque);
+	priv->nfct_opaque = NULL;
 	cache_free(priv->tcache);
 	priv->tcache = NULL;
 	cache_free(priv->scache);
@@ -1148,6 +1223,9 @@ nfct_stop(struct ulogd_pluginstance *pi)
 	cache_free(priv->scache);
 	priv->scache = NULL;
 
+	free(priv->nfct_opaque);
+	priv->nfct_opaque = NULL;
+
 	return 0;
 }
 

-- 
