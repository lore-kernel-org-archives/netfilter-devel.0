From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/4] netfilter: nf_tables_trace: fix endiness when dump chain policy
Date: Tue, 13 Sep 2016 11:05:14 +0200
Message-ID: <1473757517-3764-2-git-send-email-pablo@netfilter.org>
References: <1473757517-3764-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59240 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757240AbcIMJF3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Sep 2016 05:05:29 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C0D5C140AAD
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Sep 2016 11:05:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 782B815D643
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Sep 2016 11:05:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C604B15D639
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Sep 2016 11:05:22 +0200 (CEST)
In-Reply-To: <1473757517-3764-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

NFTA_TRACE_POLICY attribute is big endian, but we forget to call
htonl to convert it. Fortunately, this attribute is parsed as big
endian in libnftnl.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_trace.c b/net/netfilter/nf_tables_trace.c
index 39eb1cc..fa24a5b 100644
--- a/net/netfilter/nf_tables_trace.c
+++ b/net/netfilter/nf_tables_trace.c
@@ -237,7 +237,7 @@ void nft_trace_notify(struct nft_traceinfo *info)
 		break;
 	case NFT_TRACETYPE_POLICY:
 		if (nla_put_be32(skb, NFTA_TRACE_POLICY,
-				 info->basechain->policy))
+				 htonl(info->basechain->policy)))
 			goto nla_put_failure;
 		break;
 	}
-- 
2.1.4

