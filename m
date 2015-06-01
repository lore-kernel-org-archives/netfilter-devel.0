From: Paul Aitken <paitken@brocade.com>
Subject: [PATCH] Optimise nfq_queue_cb
Date: Mon, 1 Jun 2015 10:22:00 +0100
Message-ID: <556C2438.3060203@brocade.com>
References: <md5:KJl5IfCAjtPWb+o93HAjWA==>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:5496 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751750AbbFAJWv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Jun 2015 05:22:51 -0400
In-Reply-To: <md5:KJl5IfCAjtPWb+o93HAjWA==>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ct and myct have both already been checked for non-NULL,
so there's no need to check either of them again later.

Signed-off-by: Paul Aitken <paitken@brocade.com>
---
  src/cthelper.c | 8 +++-----
  1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/src/cthelper.c b/src/cthelper.c
index 15d5126..6537515 100644
--- a/src/cthelper.c
+++ b/src/cthelper.c
@@ -325,14 +325,12 @@ static int nfq_queue_cb(const struct nlmsghdr *nlh, void *data)
  	if (pkt_verdict_issue(helper, myct, queue_num, id, verdict, pktb) < 0)
  		goto err_pktb;
  
-	if (ct != NULL)
-		nfct_destroy(ct);
+	nfct_destroy(ct);
  	if (myct->exp != NULL)
  		nfexp_destroy(myct->exp);
-	if (myct && myct->priv_data != NULL)
+	if (myct->priv_data != NULL)
  		free(myct->priv_data);
-	if (myct != NULL)
-		free(myct);
+	free(myct);
  
  	return MNL_CB_OK;
  err_pktb:
-- 
1.9.1

