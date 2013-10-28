From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: [PATCH FIX] NFQUEUE: fix --queue-bypass regression
Date: Mon, 28 Oct 2013 14:42:33 +0100
Message-ID: <20131028134233.GZ13405@imap.eitzenberger.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="eHmdSDY+kY2au76U"
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
	Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:64838 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756563Ab3J1Nmj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Oct 2013 09:42:39 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--eHmdSDY+kY2au76U
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Pablo,

Florian reported a regression when using the --queue-bypass with v3 of
the target.

Regression is in since 8746ddcf12bb26 ("netfilter: xt_NFQUEUE:
introduce CPU fanout").

The attached patch fixes that for me.

 /Holger


--eHmdSDY+kY2au76U
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline; filename="nfqueue-fix-bypass.diff"

[27428] NFQUEUE: fix bypass on v3

V3 of the NFQUEUE target ignores the --queue-bypass flag,
causing packets to be dropped when the userspace listener
isn't running.

Regression is in since 8746ddcf12bb26 ("netfilter: xt_NFQUEUE:
introduce CPU fanout").

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: net-next/net/netfilter/xt_NFQUEUE.c
===================================================================
--- net-next.orig/net/netfilter/xt_NFQUEUE.c
+++ net-next/net/netfilter/xt_NFQUEUE.c
@@ -147,6 +147,7 @@ nfqueue_tg_v3(struct sk_buff *skb, const
 {
 	const struct xt_NFQ_info_v3 *info = par->targinfo;
 	u32 queue = info->queuenum;
+	int ret;
 
 	if (info->queues_total > 1) {
 		if (info->flags & NFQ_FLAG_CPU_FANOUT) {
@@ -157,7 +158,11 @@ nfqueue_tg_v3(struct sk_buff *skb, const
 			queue = nfqueue_hash(skb, par);
 	}
 
-	return NF_QUEUE_NR(queue);
+	ret = NF_QUEUE_NR(queue);
+	if (info->flags & NFQ_FLAG_BYPASS)
+		ret |= NF_VERDICT_FLAG_QUEUE_BYPASS;
+
+	return ret;
 }
 
 static struct xt_target nfqueue_tg_reg[] __read_mostly = {

--eHmdSDY+kY2au76U--
