From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf] netfilter: nf_tables_trace: fix endiness when dump chain policy
Date: Fri,  2 Sep 2016 20:49:12 +0800
Message-ID: <1472820552-7803-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-13.163.com ([220.181.12.13]:54999 "EHLO m12-13.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752609AbcIBMts (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Sep 2016 08:49:48 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

NFTA_TRACE_POLICY attribute is big endian, but we forget to call
htonl to convert it. Fortunately, this attribute is parsed as big
endian in libnftnl.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
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
2.5.5


