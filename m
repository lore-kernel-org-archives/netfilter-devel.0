From: Kevin Cernekee <cernekee@chromium.org>
Subject: [PATCH 1/2 conntrack-tools] conntrackd: cthelper: Free pktb after use
Date: Fri, 27 Jan 2017 12:38:46 -0800
Message-ID: <20170127203847.10785-1-cernekee@chromium.org>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:36614 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750783AbdA0Ui5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Jan 2017 15:38:57 -0500
Received: by mail-pg0-f51.google.com with SMTP id 3so25192817pgj.3
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Jan 2017 12:38:56 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

According to valgrind, this currently leaks ~512B to 2kB for each
packet sent to the userspace helper.

Signed-off-by: Kevin Cernekee <cernekee@chromium.org>
---
 src/cthelper.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/cthelper.c b/src/cthelper.c
index 54eb830..f01c509 100644
--- a/src/cthelper.c
+++ b/src/cthelper.c
@@ -325,6 +325,7 @@ static int nfq_queue_cb(const struct nlmsghdr *nlh, void *data)
 	if (pkt_verdict_issue(helper, myct, queue_num, id, verdict, pktb) < 0)
 		goto err4;
 
+	pktb_free(pktb);
 	nfct_destroy(ct);
 	if (myct->exp != NULL)
 		nfexp_destroy(myct->exp);
-- 
2.7.4

