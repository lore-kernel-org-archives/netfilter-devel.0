From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH] examples: nft-table-add: fix wrong buffer pointer
Date: Mon, 29 Sep 2014 22:41:05 +0200
Message-ID: <20140929204104.16927.59891.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:48395 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751742AbaI2UlJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Sep 2014 16:41:09 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We should point to the batch buffer as returned by the libmnl helper.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 examples/nft-table-add.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/examples/nft-table-add.c b/examples/nft-table-add.c
index 828091e..9340128 100644
--- a/examples/nft-table-add.c
+++ b/examples/nft-table-add.c
@@ -85,7 +85,8 @@ int main(int argc, char *argv[])
 
 	table_seq = seq;
 	family = nft_table_attr_get_u32(t, NFT_TABLE_ATTR_FAMILY);
-	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_NEWTABLE, family,
+	nlh = nft_table_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+					NFT_MSG_NEWTABLE, family,
 					NLM_F_ACK, seq++);
 	nft_table_nlmsg_build_payload(nlh, t);
 	nft_table_free(t);

