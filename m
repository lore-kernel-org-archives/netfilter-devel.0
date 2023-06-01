Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ECFFC7EE2A
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Jun 2023 16:06:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233912AbjFAQGO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Jun 2023 12:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233687AbjFAQGN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Jun 2023 12:06:13 -0400
Received: from m126.mail.126.com (m126.mail.126.com [220.181.12.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8962218F
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Jun 2023 09:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=NhchK
        NA7+KCHagGl2wrKXzXrB5jvEsSy0NCb3iSY8Bc=; b=bhLGmUxcaOu1LiKiIHW0G
        4lIUUGnz4Eu+LwH4xzoDtrs99E7nmDJd9m9iqeH6b98dDg76KmDIHMRDPQdHMoKP
        UUBcfv7BfL+w9SULP4sdzIE7mHqLgHrjxWzVxcp+IqrPwZkmZzNYbxHE59VFAqWC
        pop1l5Z0HFZSqZGzSeydN8=
Received: from localhost.localdomain (unknown [58.101.35.131])
        by zwqz-smtp-mta-g0-1 (Coremail) with SMTP id _____wBnChndwXhk68qlAg--.46177S4;
        Fri, 02 Jun 2023 00:05:51 +0800 (CST)
From:   tongxiaoge1001@126.com
To:     pablo@netfilter.org, netfilter-devel@vger.kernel.org
Cc:     shixuantong1@huawei.com, shixuantong <tongxiaoge1001@126.com>
Subject: [PATCH] Add test cases to improve code coverage
Date:   Fri,  2 Jun 2023 00:05:37 +0800
Message-Id: <20230601160537.72366-1-tongxiaoge1001@126.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wBnChndwXhk68qlAg--.46177S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7AFWfZFWDur1UXrWrKF1DGFg_yoW8Xw17pa
        1YqryUCrsayFnrGrs2kw4q9as5C3WIyF18Kryrur1xCrs8X3y8X3srtrnxGrZxZrZ5A3Wf
        u3WUZFWDK34qy3JanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jOkuxUUUUU=
X-Originating-IP: [58.101.35.131]
X-CM-SenderInfo: pwrqw55ldrwvirqqiqqrswhudrp/1tbiHAKBWlpEKGCiPgAAsP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: shixuantong <tongxiaoge1001@126.com>

---
 tests/nft-rule-test.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tests/nft-rule-test.c b/tests/nft-rule-test.c
index 3652bf6..3a92223 100644
--- a/tests/nft-rule-test.c
+++ b/tests/nft-rule-test.c
@@ -48,6 +48,12 @@ static void cmp_nftnl_rule(struct nftnl_rule *a, struct nftnl_rule *b)
 	if (nftnl_rule_get_u32(a, NFTNL_RULE_COMPAT_FLAGS) !=
 	    nftnl_rule_get_u32(b, NFTNL_RULE_COMPAT_FLAGS))
 		print_err("Rule compat_flags mismatches");
+	if (nftnl_rule_get_u32(a, NFTNL_RULE_ID) !=
+            nftnl_rule_get_u32(b, NFTNL_RULE_ID))
+                print_err("Rule id mismatches");
+	if (nftnl_rule_get_u32(a, NFTNL_RULE_POSITION_ID) !=
+            nftnl_rule_get_u32(b, NFTNL_RULE_POSITION_ID))
+                print_err("Rule position_id mismatches");
 	if (nftnl_rule_get_u64(a, NFTNL_RULE_POSITION) !=
 	    nftnl_rule_get_u64(b, NFTNL_RULE_POSITION))
 		print_err("Rule compat_position mismatches");
@@ -84,6 +90,8 @@ int main(int argc, char *argv[])
 	nftnl_rule_set_u64(a, NFTNL_RULE_HANDLE, 0x1234567812345678);
 	nftnl_rule_set_u32(a, NFTNL_RULE_COMPAT_PROTO, 0x12345678);
 	nftnl_rule_set_u32(a, NFTNL_RULE_COMPAT_FLAGS, 0x12345678);
+	nftnl_rule_set_u32(a, NFTNL_RULE_ID, 0x12345678);
+	nftnl_rule_set_u32(a, NFTNL_RULE_POSITION_ID, 0x12345678);
 	nftnl_rule_set_u64(a, NFTNL_RULE_POSITION, 0x1234567812345678);
 	nftnl_rule_set_data(a, NFTNL_RULE_USERDATA,
 			    nftnl_udata_buf_data(udata),
-- 
2.33.0

