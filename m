From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next] netfilter: nft_meta: permit pkttype mangling in ip/ip6 prerouting
Date: Wed, 19 Oct 2016 23:31:29 +0800
Message-ID: <1476891089-3744-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-13.163.com ([220.181.12.13]:54104 "EHLO m12-13.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S938798AbcJSPcB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Oct 2016 11:32:01 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

After supporting this, we can combine it with hash expression to emulate
the 'cluster match'.

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 net/netfilter/nft_meta.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 6c1e024..6499402 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -310,6 +310,11 @@ int nft_meta_set_validate(const struct nft_ctx *ctx,
 	case NFPROTO_NETDEV:
 		hooks = 1 << NF_NETDEV_INGRESS;
 		break;
+	case NFPROTO_IPV4:
+	case NFPROTO_IPV6:
+	case NFPROTO_INET:
+		hooks = 1 << NF_INET_PRE_ROUTING;
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.5.5


