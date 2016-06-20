From: Florian Westphal <fw@strlen.de>
Subject: [PATCH libnetfilter_queue] src: make nfq_open_nfnl thread-safe
Date: Mon, 20 Jun 2016 13:19:52 +0200
Message-ID: <1466421592-9164-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:55633 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752517AbcFTLUV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Jun 2016 07:20:21 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nfq_open_nfnl uses an intermediate static object, so when
it is invoked by distinct threads at the same time there is a small
chance that some threads end up with another threads nfq_handle pointer
stored in ->data.

Tested-by: Michal Tesar <mtesar@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/libnetfilter_queue.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index 740b340..ce16f95 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -216,11 +216,6 @@ static int __nfq_rcv_pkt(struct nlmsghdr *nlh, struct nfattr *nfa[],
 	return qh->cb(qh, nfmsg, &nfqa, qh->data);
 }
 
-static struct nfnl_callback pkt_cb = {
-	.call		= &__nfq_rcv_pkt,
-	.attr_count	= NFQA_MAX,
-};
-
 /* public interface */
 
 struct nfnl_handle *nfq_nfnlh(struct nfq_handle *h)
@@ -389,6 +384,10 @@ EXPORT_SYMBOL(nfq_open);
  */
 struct nfq_handle *nfq_open_nfnl(struct nfnl_handle *nfnlh)
 {
+	struct nfnl_callback pkt_cb = {
+		.call		= __nfq_rcv_pkt,
+		.attr_count	= NFQA_MAX,
+	};
 	struct nfq_handle *h;
 	int err;
 
-- 
2.7.3

