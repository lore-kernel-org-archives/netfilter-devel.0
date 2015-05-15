From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf] nf_tables: fix bogus warning in nft_data_uninit()
Date: Fri, 15 May 2015 22:05:55 +0200
Message-ID: <1431720355-3604-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, exa.exa@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38025 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934201AbbEOUBX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 May 2015 16:01:23 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.orgi>

From: Mirek Kratochvil <exa.exa@gmail.com>

The values 0x00000000-0xfffffeff are reserved for userspace datatype. When,
deleting set elements with maps, a bogus warning is triggered.

WARNING: CPU: 0 PID: 11133 at net/netfilter/nf_tables_api.c:4481 nft_data_uninit+0x35/0x40 [nf_tables]()

This fixes the check accordingly to enum definition in
include/linux/netfilter/nf_tables.h

Based on patch from Mirek.

Fixes: https://bugzilla.netfilter.org/show_bug.cgi?id=1013
Reported-by: Mirek Kratochvil <exa.exa@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
I'm sending a v2 of this patch:

http://patchwork.ozlabs.org/patch/465960/

It doesn't apply cleanly to the nf tree and I have adjusted the indentation.
If no objections, I'll apply this to the nf tree. Thanks.

 net/netfilter/nf_tables_api.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ad9d11f..34ded09 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4472,9 +4472,9 @@ EXPORT_SYMBOL_GPL(nft_data_init);
  */
 void nft_data_uninit(const struct nft_data *data, enum nft_data_types type)
 {
-	switch (type) {
-	case NFT_DATA_VALUE:
+	if (type < NFT_DATA_VERDICT)
 		return;
+	switch (type) {
 	case NFT_DATA_VERDICT:
 		return nft_verdict_uninit(data);
 	default:
-- 
1.7.10.4

