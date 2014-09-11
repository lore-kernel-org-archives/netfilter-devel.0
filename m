From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 1/3] netfilter: nf_tables: add NFTA_MASQ_UNSPEC to nft_masq_attributes
Date: Thu, 11 Sep 2014 17:20:17 +0200
Message-ID: <1410448819-6694-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, arturo.borrero.glez@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47110 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434AbaIKPT2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Sep 2014 11:19:28 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

To keep this consistent with other nft_*_attributes.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index eeec0ae..66d66dd 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -806,6 +806,7 @@ enum nft_nat_attributes {
  * @NFTA_MASQ_FLAGS: NAT flags (see NF_NAT_RANGE_* in linux/netfilter/nf_nat.h) (NLA_U32)
  */
 enum nft_masq_attributes {
+	NFTA_MASQ_UNSPEC,
 	NFTA_MASQ_FLAGS,
 	__NFTA_MASQ_MAX
 };
-- 
1.7.10.4

