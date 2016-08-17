From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/2 nft] ct: release ct_label table on exit
Date: Wed, 17 Aug 2016 13:13:03 +0200
Message-ID: <1471432383-4318-2-git-send-email-pablo@netfilter.org>
References: <1471432383-4318-1-git-send-email-pablo@netfilter.org>
Cc: fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42866 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294AbcHQLNR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Aug 2016 07:13:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id E2BAAE8E8A
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 13:13:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D1BB1FB469
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 13:13:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 81856100A58
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 13:13:12 +0200 (CEST)
In-Reply-To: <1471432383-4318-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Just like we do with other symbol tables.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/ct.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/src/ct.c b/src/ct.c
index f6b1dc1..f6018d8 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -164,6 +164,11 @@ static void __init ct_label_table_init(void)
 	ct_label_tbl = rt_symbol_table_init(CONNLABEL_CONF);
 }
 
+static void __exit ct_label_table_exit(void)
+{
+	rt_symbol_table_free(ct_label_tbl);
+}
+
 #ifndef NF_CT_HELPER_NAME_LEN
 #define NF_CT_HELPER_NAME_LEN	16
 #endif
-- 
2.1.4

