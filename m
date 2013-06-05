From: Arturo Borrero <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 2/2] examples: unset chain & rule handle
Date: Wed, 05 Jun 2013 23:37:18 +0200
Message-ID: <20130605213718.11415.44102.stgit@nfdev.cica.es>
References: <20130605213713.11415.64106.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: giuseppelng@gmail.com, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:36835 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933051Ab3FEVhV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:37:21 -0400
In-Reply-To: <20130605213713.11415.64106.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use _unset functions to delete handle so test don't fail.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 examples/nft-chain-xml-add.c |    1 +
 examples/nft-rule-xml-add.c  |    1 +
 2 files changed, 2 insertions(+)

diff --git a/examples/nft-chain-xml-add.c b/examples/nft-chain-xml-add.c
index c8b0fdc..80a513d 100644
--- a/examples/nft-chain-xml-add.c
+++ b/examples/nft-chain-xml-add.c
@@ -69,6 +69,7 @@ int main(int argc, char *argv[])
 	nft_chain_snprintf(reprint, sizeof(reprint), c, NFT_CHAIN_O_XML, 0);
 	printf("Parsed:\n%s\n", reprint);
 
+	nft_chain_attr_unset(c, NFT_CHAIN_ATTR_HANDLE);
 	family = (uint16_t)nft_chain_attr_get_u32(c, NFT_CHAIN_ATTR_FAMILY);
 
 	seq = time(NULL);
diff --git a/examples/nft-rule-xml-add.c b/examples/nft-rule-xml-add.c
index bce3411..7bd44ff 100644
--- a/examples/nft-rule-xml-add.c
+++ b/examples/nft-rule-xml-add.c
@@ -67,6 +67,7 @@ int main(int argc, char *argv[])
 	nft_rule_snprintf(reprint, sizeof(reprint), r, NFT_RULE_O_XML, 0);
 	printf("Parsed:\n%s\n", reprint);
 
+	nft_rule_attr_unset(r, NFT_RULE_ATTR_HANDLE);
 	family = nft_rule_attr_get_u8(r, NFT_RULE_ATTR_FAMILY);
 
 	seq = time(NULL);

