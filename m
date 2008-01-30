From: heitzenberger@astaro.com
Subject: [ULOGD RFC 18/30] NFCT: properly account both directions in all cases
Date: Wed, 30 Jan 2008 19:59:05 +0100
Message-ID: <20080130190128.754170896@kruemel.intranet.astaro.de>
References: <20080130185847.693274384@kruemel.intranet.astaro.de>
Cc: holger@eitzenberger.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-64.dex002.intermedia.net ([64.78.20.13]:4031 "EHLO
	dhost002-64.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754266AbYA3TBm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:01:42 -0500
Content-Disposition: inline; filename=ulogd-NFCT-accounting-fix.diff
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: ulogd-netfilter/input/flow/ulogd_inpflow_NFCT.c
===================================================================
--- ulogd-netfilter.orig/input/flow/ulogd_inpflow_NFCT.c
+++ ulogd-netfilter/input/flow/ulogd_inpflow_NFCT.c
@@ -696,10 +696,10 @@ propagate_ct_flow(struct ulogd_pluginsta
 {
 	struct ulogd_key *ret = upi->output.keys;
 
-	ret[O_IP_SADDR].u.value.ui32 = htonl(nfct->tuple[dir].src.v4);
+	ret[O_IP_SADDR].u.value.ui32 = htonl(nfct->tuple[0].src.v4);
 	ret[O_IP_SADDR].flags |= ULOGD_RETF_VALID;
 
-	ret[O_IP_DADDR].u.value.ui32 = htonl(nfct->tuple[dir].dst.v4);
+	ret[O_IP_DADDR].u.value.ui32 = htonl(nfct->tuple[1].src.v4);
 	ret[O_IP_DADDR].flags |= ULOGD_RETF_VALID;
 
 	ret[O_IP_PROTO].u.value.ui8 = nfct->tuple[dir].protonum;
@@ -710,9 +710,9 @@ propagate_ct_flow(struct ulogd_pluginsta
 	case IPPROTO_UDP:
 	case IPPROTO_SCTP:
 		/* FIXME: DCCP */
-		ret[O_L4_SPORT].u.value.ui16 = htons(nfct->tuple[dir].l4src.tcp.port);
+		ret[O_L4_SPORT].u.value.ui16 = htons(nfct->tuple[0].l4src.tcp.port);
 		ret[O_L4_SPORT].flags |= ULOGD_RETF_VALID;
-		ret[O_L4_DPORT].u.value.ui16 = htons(nfct->tuple[dir].l4dst.tcp.port);
+		ret[O_L4_DPORT].u.value.ui16 = htons(nfct->tuple[1].l4src.tcp.port);
 		ret[O_L4_DPORT].flags |= ULOGD_RETF_VALID;
 		break;
 	case IPPROTO_ICMP:

-- 
