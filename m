From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH 2/2] expr: nat: add masquerade support
Date: Thu, 26 Jun 2014 14:22:20 +0200
Message-ID: <20140626122220.6913.26092.stgit@nfdev.cica.es>
References: <20140626122215.6913.15730.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:42729 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757348AbaFZMW2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Jun 2014 08:22:28 -0400
In-Reply-To: <20140626122215.6913.15730.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds masquerade support for the nat expression.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 0 files changed

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 92c211b..18c9365 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -758,10 +758,12 @@ enum nft_reject_attributes {
  *
  * @NFT_NAT_SNAT: source NAT
  * @NFT_NAT_DNAT: destination NAT
+ * @NFT_NAT_MASQUERADE: masquerade NAT
  */
 enum nft_nat_types {
 	NFT_NAT_SNAT,
 	NFT_NAT_DNAT,
+	NFT_NAT_MASQUERADE,
 };
 
 /**
diff --git a/src/expr/nat.c b/src/expr/nat.c
index 51188c1..092c871 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -205,6 +205,8 @@ static inline const char *nft_nat2str(uint16_t nat)
 		return "snat";
 	case NFT_NAT_DNAT:
 		return "dnat";
+	case NFT_NAT_MASQUERADE:
+		return "masquerade";
 	default:
 		return "unknown";
 	}
@@ -216,6 +218,8 @@ static inline int nft_str2nat(const char *nat)
 		return NFT_NAT_SNAT;
 	else if (strcmp(nat, "dnat") == 0)
 		return NFT_NAT_DNAT;
+	else if (strcmp(nat, "masquerade") == 0)
+		return NFT_NAT_MASQUERADE;
 	else {
 		errno = EINVAL;
 		return -1;

