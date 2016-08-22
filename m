From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] netfilter: nf_tables: typo in trace attribute definition
Date: Mon, 22 Aug 2016 11:37:36 +0200
Message-ID: <1471858656-6553-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49840 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753485AbcHVJhs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Aug 2016 05:37:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0C77A16417D
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 11:37:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F0A5DFAB4F
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 11:37:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ADAC8FAB4F
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 11:37:43 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Should be attributes, instead of attibutes, for consistency with other
definitions.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 9841f79..6a7a9b7 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1071,7 +1071,7 @@ enum nft_gen_attributes {
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

