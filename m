From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH conntrackd 5/8] conntrackd: fix error handling in nfq_queue_cb()
Date: Tue, 18 Aug 2015 19:28:36 +0200
Message-ID: <1439918919-6937-6-git-send-email-pablo@netfilter.org>
References: <1439918919-6937-1-git-send-email-pablo@netfilter.org>
Cc: pwouters@redhat.com, fweimer@redhat.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37607 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624AbbHRRWi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Aug 2015 13:22:38 -0400
In-Reply-To: <1439918919-6937-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Make sure we have a clean exit on error, everything needs to be properly
released.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/cthelper.c |   29 +++++++++++++++--------------
 src/local.c    |    2 +-
 2 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/src/cthelper.c b/src/cthelper.c
index 6537515..54eb830 100644
--- a/src/cthelper.c
+++ b/src/cthelper.c
@@ -277,11 +277,11 @@ static int nfq_queue_cb(const struct nlmsghdr *nlh, void *data)
 
 	if (!attr[NFQA_PAYLOAD]) {
 		dlog(LOG_ERR, "packet with no payload");
-		goto err;
+		goto err1;
 	}
 	if (!attr[NFQA_CT] || !attr[NFQA_CT_INFO]) {
 		dlog(LOG_ERR, "no CT attached to this packet");
-		goto err;
+		goto err1;
 	}
 
 	pkt = mnl_attr_get_payload(attr[NFQA_PAYLOAD]);
@@ -292,22 +292,22 @@ static int nfq_queue_cb(const struct nlmsghdr *nlh, void *data)
 	queue_num = ntohs(nfg->res_id);
 
 	if (pkt_get(pkt, pktlen, ntohs(ph->hw_protocol), &protoff))
-		goto err;
+		goto err1;
 
 	ct = nfct_new();
 	if (ct == NULL)
-		goto err;
+		goto err1;
 
 	if (nfct_payload_parse(mnl_attr_get_payload(attr[NFQA_CT]),
 			       mnl_attr_get_payload_len(attr[NFQA_CT]),
 			       l3num, ct) < 0) {
 		dlog(LOG_ERR, "cannot convert message to CT");
-		goto err;
+		goto err2;
 	}
 
 	myct = calloc(1, sizeof(struct myct));
 	if (myct == NULL)
-		goto err;
+		goto err2;
 
 	myct->ct = ct;
 	ctinfo = ntohl(mnl_attr_get_u32(attr[NFQA_CT_INFO]));
@@ -315,15 +315,15 @@ static int nfq_queue_cb(const struct nlmsghdr *nlh, void *data)
 	/* XXX: 256 bytes enough for possible NAT mangling in helpers? */
 	pktb = pktb_alloc(AF_INET, pkt, pktlen, 256);
 	if (pktb == NULL)
-		goto err;
+		goto err3;
 
 	/* Misconfiguration: if no helper found, accept the packet. */
 	helper = helper_run(pktb, protoff, myct, ctinfo, queue_num, &verdict);
 	if (!helper)
-		goto err_pktb;
+		goto err4;
 
 	if (pkt_verdict_issue(helper, myct, queue_num, id, verdict, pktb) < 0)
-		goto err_pktb;
+		goto err4;
 
 	nfct_destroy(ct);
 	if (myct->exp != NULL)
@@ -333,18 +333,19 @@ static int nfq_queue_cb(const struct nlmsghdr *nlh, void *data)
 	free(myct);
 
 	return MNL_CB_OK;
-err_pktb:
+err4:
 	pktb_free(pktb);
-err:
+err3:
+	free(myct);
+err2:
+	nfct_destroy(ct);
+err1:
 	/* In case of error, we don't want to disrupt traffic. We accept all.
 	 * This is connection tracking after all. The policy is not to drop
 	 * packet unless we enter some inconsistent state.
 	 */
 	pkt_verdict_error(queue_num, id);
 
-	if (ct != NULL)
-		nfct_destroy(ct);
-
 	return MNL_CB_OK;
 }
 
diff --git a/src/local.c b/src/local.c
index 85e5180..3395b4c 100644
--- a/src/local.c
+++ b/src/local.c
@@ -77,7 +77,7 @@ int do_local_server_step(struct local_server *server, void *data,
 	int rfd;
 	struct sockaddr_un local;
 	socklen_t sin_size = sizeof(struct sockaddr_un);
-	
+
 	rfd = accept(server->fd, (struct sockaddr *) &local, &sin_size);
 	if (rfd == -1)
 		return -1;
-- 
1.7.10.4

