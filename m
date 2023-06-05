Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D847EC7EE24
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Jun 2023 16:14:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbjFEQOX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 5 Jun 2023 12:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbjFEQOX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Jun 2023 12:14:23 -0400
Received: from m126.mail.126.com (m126.mail.126.com [220.181.12.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6E4D4B7
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Jun 2023 09:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=atRbz
        VD5gzHRWW5/k9kAN454+QkrwNfWBMgp+CfsT8E=; b=DvNo6CNlb0E+jZSRW4hoK
        A+AVbC92FSs1lmDBGWK73pnYIECNLsoIseGEUOc59QFnoJZw+0kGfS+H05n2iyCh
        UF5P+p3L1tpazncm4g8fM8SPyM9fkTxvFyEbIYEKxY7KlqbeghvtRC8//JaEZEIK
        SsIrJQ3bWsubGzXFt8frL0=
Received: from localhost.localdomain (unknown [58.101.35.131])
        by zwqz-smtp-mta-g3-1 (Coremail) with SMTP id _____wCnUpXOCX5kAfQIAw--.19198S4;
        Tue, 06 Jun 2023 00:14:07 +0800 (CST)
From:   tongxiaoge1001@126.com
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, shixuantong1@huawei.com,
        tongxiaoge1001@126.com
Subject: [PATCH] add some test cases to improve code coverage
Date:   Tue,  6 Jun 2023 00:14:04 +0800
Message-Id: <20230605161404.117404-1-tongxiaoge1001@126.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wCnUpXOCX5kAfQIAw--.19198S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7AFWxZFW7uFyxtrWfCrWktFb_yoW8CF4kpa
        n0vry7Kr4rAFnrt3Z2kwsFgFn5Cw1vkr18Cr9F9r17Ar4rXay8JFsrKF93GFn5Jr4rXwn3
        Zw1qyFWUKrsYvaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jz1v3UUUUU=
X-Originating-IP: [58.101.35.131]
X-CM-SenderInfo: pwrqw55ldrwvirqqiqqrswhudrp/1tbibRaFWlpEDnkKngACsb
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: shixuantong <tongxiaoge1001@126.com>

---
 tests/nft-rule-test.c  | 3 +++
 tests/nft-table-test.c | 8 ++++++++
 2 files changed, 11 insertions(+)

diff --git a/tests/nft-rule-test.c b/tests/nft-rule-test.c
index 3a92223..8cbd961 100644
--- a/tests/nft-rule-test.c
+++ b/tests/nft-rule-test.c
@@ -106,6 +106,9 @@ int main(int argc, char *argv[])
 
 	cmp_nftnl_rule(a,b);
 
+	nftnl_rule_unset(a, NFTNL_RULE_TABLE);
+	nftnl_rule_unset(a, NFTNL_RULE_CHAIN);
+	nftnl_rule_unset(a, NFTNL_RULE_USERDATA);
 	nftnl_rule_free(a);
 	nftnl_rule_free(b);
 	if (!test_ok)
diff --git a/tests/nft-table-test.c b/tests/nft-table-test.c
index 53cf3d1..61becd4 100644
--- a/tests/nft-table-test.c
+++ b/tests/nft-table-test.c
@@ -35,6 +35,12 @@ static void cmp_nftnl_table(struct nftnl_table *a, struct nftnl_table *b)
 	if (nftnl_table_get_u32(a, NFTNL_TABLE_FAMILY) !=
 	    nftnl_table_get_u32(b, NFTNL_TABLE_FAMILY))
 		print_err("table family mismatches");
+	if (nftnl_table_get_u64(a, NFTNL_TABLE_HANDLE) !=
+            nftnl_table_get_u64(b, NFTNL_TABLE_HANDLE))
+                print_err("tabke handle mismatches");
+	if (strcmp(nftnl_table_get_str(a, NFTNL_TABLE_USERDATA),
+                   nftnl_table_get_str(b, NFTNL_TABLE_USERDATA)) != 0)
+                print_err("table userdata mismatches");
 }
 
 int main(int argc, char *argv[])
@@ -53,6 +59,8 @@ int main(int argc, char *argv[])
 	nftnl_table_set_str(a, NFTNL_TABLE_NAME, "test");
 	nftnl_table_set_u32(a, NFTNL_TABLE_FAMILY, AF_INET);
 	nftnl_table_set_u32(a, NFTNL_TABLE_FLAGS, 0);
+	nftnl_table_set_u64(a, NFTNL_TABLE_HANDLE, 0x12345678);
+	nftnl_table_set_str(a, NFTNL_TABLE_USERDATA, "test for userdata");
 
 	/* cmd extracted from include/linux/netfilter/nf_tables.h */
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWTABLE, AF_INET, 0, 1234);
-- 
2.33.0

