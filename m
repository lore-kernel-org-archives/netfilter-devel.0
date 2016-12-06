From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next] netfilter: nft_quota: don't read quota twice on reset
Date: Tue,  6 Dec 2016 15:03:33 +0100
Message-ID: <1481033013-2073-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48996 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752910AbcLFODl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Dec 2016 09:03:41 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 34BBAC1256
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 15:03:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 23FAADA85D
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 15:03:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E9E51DA85D
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 15:03:36 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The quota is already fetched before reset, so there is no need to
re-fetch it, otherwise userspace reports consumed quota is always zero
on reset. This problem was likely introduced when rebasing this
patchset.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_quota.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
index 7e825e7f6210..2cfcdd1d4d45 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -112,7 +112,6 @@ static int nft_quota_do_dump(struct sk_buff *skb, struct nft_quota *priv,
 		consumed = atomic64_read(&priv->consumed);
 	}
 
-	consumed = atomic64_read(&priv->consumed);
 	/* Since we inconditionally increment consumed quota for each packet
 	 * that we see, don't go over the quota boundary in what we send to
 	 * userspace.
-- 
2.1.4

