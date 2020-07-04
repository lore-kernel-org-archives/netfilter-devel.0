Return-Path: <SRS0=AjNT=AP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1302EC433E0
	for <netfilter-devel@archiver.kernel.org>; Sat,  4 Jul 2020 00:45:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8E4920723
	for <netfilter-devel@archiver.kernel.org>; Sat,  4 Jul 2020 00:44:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbgGDAo7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Jul 2020 20:44:59 -0400
Received: from correo.us.es ([193.147.175.20]:59170 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726455AbgGDAo7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Jul 2020 20:44:59 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F3BC6ED5BE
        for <netfilter-devel@vger.kernel.org>; Sat,  4 Jul 2020 02:44:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E48C0DA722
        for <netfilter-devel@vger.kernel.org>; Sat,  4 Jul 2020 02:44:57 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D9F2FDA73D; Sat,  4 Jul 2020 02:44:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ADE2CDA722
        for <netfilter-devel@vger.kernel.org>; Sat,  4 Jul 2020 02:44:55 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 04 Jul 2020 02:44:55 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 9854542EF529
        for <netfilter-devel@vger.kernel.org>; Sat,  4 Jul 2020 02:44:55 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 1/2] datatype: convert chain name from gmp value to string
Date:   Sat,  4 Jul 2020 02:44:51 +0200
Message-Id: <20200704004452.2347-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add expr_chain_export() helper function to convert the chain name that
is stored in a gmp value variable to string.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/datatype.h |  2 ++
 src/datatype.c     | 21 +++++++++++++--------
 src/datatype.cc    |  0
 3 files changed, 15 insertions(+), 8 deletions(-)
 create mode 100644 src/datatype.cc

diff --git a/include/datatype.h b/include/datatype.h
index 04b4892b29ac..1061a389b0f0 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -305,4 +305,6 @@ extern struct error_record *rate_parse(const struct location *loc,
 extern struct error_record *data_unit_parse(const struct location *loc,
 					    const char *str, uint64_t *rate);
 
+extern void expr_chain_export(const struct expr *e, char *chain);
+
 #endif /* NFTABLES_DATATYPE_H */
diff --git a/src/datatype.c b/src/datatype.c
index 90905258bc30..7382307e9909 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -247,20 +247,25 @@ const struct datatype invalid_type = {
 	.print		= invalid_type_print,
 };
 
+void expr_chain_export(const struct expr *e, char *chain_name)
+{
+	unsigned int len;
+
+	len = e->len / BITS_PER_BYTE;
+	if (len >= NFT_CHAIN_MAXNAMELEN)
+		BUG("verdict expression length %u is too large (%u bits max)",
+		    e->len, NFT_CHAIN_MAXNAMELEN * BITS_PER_BYTE);
+
+	mpz_export_data(chain_name, e->value, BYTEORDER_HOST_ENDIAN, len);
+}
+
 static void verdict_jump_chain_print(const char *what, const struct expr *e,
 				     struct output_ctx *octx)
 {
 	char chain[NFT_CHAIN_MAXNAMELEN];
-	unsigned int len;
 
 	memset(chain, 0, sizeof(chain));
-
-	len = e->len / BITS_PER_BYTE;
-	if (len >= sizeof(chain))
-		BUG("verdict expression length %u is too large (%lu bits max)",
-		    e->len, (unsigned long)sizeof(chain) * BITS_PER_BYTE);
-
-	mpz_export_data(chain, e->value, BYTEORDER_HOST_ENDIAN, len);
+	expr_chain_export(e, chain);
 	nft_print(octx, "%s %s", what, chain);
 }
 
diff --git a/src/datatype.cc b/src/datatype.cc
new file mode 100644
index 000000000000..e69de29bb2d1
-- 
2.20.1

