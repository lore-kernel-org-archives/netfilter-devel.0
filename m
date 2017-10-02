From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] mnl: fix broken sequence number allocation
Date: Mon,  2 Oct 2017 14:25:06 +0200
Message-ID: <1506947106-7253-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37228 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750957AbdJBMZT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Oct 2017 08:25:19 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 829921BCFC3
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Oct 2017 14:25:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 72332B5027
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Oct 2017 14:25:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ABF96B5028
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Oct 2017 14:25:11 +0200 (CEST)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 7657F44581E2
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Oct 2017 14:25:11 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Wrong arithmetics with pointer.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1178
Fixes: 0d9d04c31481 ("src: make netlink sequence number non-static")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/mnl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/mnl.c b/src/mnl.c
index e2174925c121..808c34bf066b 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -32,7 +32,7 @@
 
 uint32_t mnl_seqnum_alloc(unsigned int *seqnum)
 {
-	return *seqnum++;
+	return (*seqnum)++;
 }
 
 /* The largest nf_tables netlink message is the set element message, which
-- 
2.1.4

