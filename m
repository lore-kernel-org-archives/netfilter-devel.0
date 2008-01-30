From: heitzenberger@astaro.com
Subject: [ULOGD RFC 17/30] NFCT: use localtime for timestamps
Date: Wed, 30 Jan 2008 19:59:04 +0100
Message-ID: <20080130190128.616820118@kruemel.intranet.astaro.de>
References: <20080130185847.693274384@kruemel.intranet.astaro.de>
Cc: holger@eitzenberger.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-48.dex002.intermedia.net ([64.78.21.144]:9357 "EHLO
	dhost002-48.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756249AbYA3TBr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:01:47 -0500
Content-Disposition: inline; filename=ulogd-NFCT-use-localtime.diff
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: ulogd-netfilter/input/flow/ulogd_inpflow_NFCT.c
===================================================================
--- ulogd-netfilter.orig/input/flow/ulogd_inpflow_NFCT.c
+++ ulogd-netfilter/input/flow/ulogd_inpflow_NFCT.c
@@ -655,7 +655,7 @@ cache_add(struct cache *c, struct conntr
 {
 	ct_get(ct);
 
-	ct->time[UPDATE].tv_sec = ct->time[START].tv_sec = t_now;
+	ct->time[UPDATE].tv_sec = ct->time[START].tv_sec = t_now_local;
 
 	/* order of these two is important for debugging purposes */
 	c->c_cnt++;
@@ -777,7 +777,7 @@ propagate_ct(struct ulogd_pluginstance *
 			|| nfct->tuple[NFCT_DIR_ORIGINAL].dst.v4 == INADDR_LOOPBACK)
 			break;
 
-		ct->time[STOP].tv_sec = t_now;
+		ct->time[STOP].tv_sec = t_now_local;
 
 		propagate_ct_flow(upi, nfct, flags, NFCT_DIR_ORIGINAL, ct);
 	} while (0);
@@ -828,7 +828,7 @@ do_nfct_msg(struct nlmsghdr *nlh, void *
 			break;
 		}
 
-		ct->time[UPDATE].tv_sec = t_now;
+		ct->time[UPDATE].tv_sec = t_now_local;
 
 		if (ct->used > 1) {
 			struct conntrack *ct_tmp = scache_find(pi, nlh->nlmsg_seq);

-- 
