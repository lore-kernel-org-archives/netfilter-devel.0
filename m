From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 15/29] netfilter: nf_tables: typo in trace attribute definition
Date: Mon,  5 Sep 2016 12:58:30 +0200
Message-ID: <1473073124-5015-16-git-send-email-pablo@netfilter.org>
References: <1473073124-5015-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1473073124-5015-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Pablo Neira <pablo@netfilter.org>

Should be attributes, instead of attibutes, for consistency with other
definitions.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 8c9d6ff..8a63f22 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1090,7 +1090,7 @@ enum nft_gen_attributes {
  * @NFTA_TRACE_NFPROTO: nf protocol processed (NLA_U32)
  * @NFTA_TRACE_POLICY: policy that decided fate of packet (NLA_U32)
  */
-enum nft_trace_attibutes {
+enum nft_trace_attributes {
 	NFTA_TRACE_UNSPEC,
 	NFTA_TRACE_TABLE,
 	NFTA_TRACE_CHAIN,
-- 
2.1.4
