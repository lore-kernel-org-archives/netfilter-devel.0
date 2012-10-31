From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables - PATCH 1/5] headers: Make nf_tables.h up to date
Date: Wed, 31 Oct 2012 11:31:04 +0200
Message-ID: <1351675868-14302-2-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1351675868-14302-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:33152 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932190Ab2JaJbN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Oct 2012 05:31:13 -0400
In-Reply-To: <1351675868-14302-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 include/linux/netfilter/nf_tables.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index a6d5137..74a521a 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -65,6 +65,8 @@ enum nft_chain_attributes {
 	NFTA_CHAIN_TABLE,
 	NFTA_CHAIN_NAME,
 	NFTA_CHAIN_HOOK,
+	NFTA_CHAIN_POLICY,
+	NFTA_CHAIN_USE,
 	__NFTA_CHAIN_MAX
 };
 #define NFTA_CHAIN_MAX		(__NFTA_CHAIN_MAX - 1)
-- 
1.7.12.4

