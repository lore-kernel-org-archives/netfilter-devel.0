From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH] nf_tables.h: add NFTA_MASQ_UNSPEC
Date: Thu, 11 Sep 2014 18:56:34 +0200
Message-ID: <20140911165633.7270.7557.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:45328 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755154AbaIKQ4n (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Sep 2014 12:56:43 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

To keep this consistent with other nft_*_attributes.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 include/linux/netfilter/nf_tables.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 9bbcb7b..36c4ca2 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -806,6 +806,7 @@ enum nft_nat_attributes {
  * @NFTA_MASQ_FLAGS: additional masquerade configuration (NF_NAT_RANGE_*) (NLA_U32)
  */
 enum nft_masq_attributes {
+	NFTA_MASQ_UNSPEC,
 	NFTA_MASQ_FLAGS,
 	__NFTA_MASQ_MAX
 };

