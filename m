From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH -stable] netfilter: nf_tables: fix bogus warning in nft_data_uninit()
Date: Mon, 14 Dec 2015 13:17:15 +0100
Message-ID: <1450095436-24855-5-git-send-email-pablo@netfilter.org>
References: <1450095436-24855-1-git-send-email-pablo@netfilter.org>
Cc: stable@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38460 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752907AbbLNMR2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Dec 2015 07:17:28 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 8F7305C02D
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Dec 2015 13:17:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 86B28DA80B
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Dec 2015 13:17:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7FB61DA804
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Dec 2015 13:17:23 +0100 (CET)
In-Reply-To: <1450095436-24855-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Mirek Kratochvil <exa.exa@gmail.com>

[ upstream commit 960bd2c26421d321e890f1936938196ead41976f ]

The values 0x00000000-0xfffffeff are reserved for userspace datatype. When,
deleting set elements with maps, a bogus warning is triggered.

WARNING: CPU: 0 PID: 11133 at net/netfilter/nf_tables_api.c:4481 nft_data_uninit+0x35/0x40 [nf_tables]()

This fixes the check accordingly to enum definition in
include/linux/netfilter/nf_tables.h

Fixes: https://bugzilla.netfilter.org/show_bug.cgi?id=1013
Cc: <stable@vger.kernel.org> # 3.14.x
Cc: <stable@vger.kernel.org> # 3.18.x
Signed-off-by: Mirek Kratochvil <exa.exa@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 4 ++--
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
2.1.4

