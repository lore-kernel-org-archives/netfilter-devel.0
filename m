Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04B63C77B7E
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Jun 2023 16:07:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234584AbjFAQHC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Jun 2023 12:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234196AbjFAQHA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Jun 2023 12:07:00 -0400
X-Greylist: delayed 957 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 01 Jun 2023 09:06:58 PDT
Received: from m126.mail.126.com (m126.mail.126.com [220.181.12.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 46268199
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Jun 2023 09:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=jz9J1
        7qPdzKxSrE6AEZwO9U/5asKmv5w1Avw9vbbjEU=; b=aQ2YcjP9duUWY1jyxrJMs
        t5kHhEZQg+azeRmAEvIVz5lR+HcVDOnuSUXs/zlpjCtlSeG1kjmGDOX0NAzJZO42
        S/uHo80r+g/y1TNM++Wlx3t8VyZbESXaq+PYRG/b+XjlQ7woRDgGzZRMdtQoBgk8
        tlZ/ZrhdtF8QJXXUayNfFg=
Received: from localhost.localdomain (unknown [101.71.37.67])
        by zwqz-smtp-mta-g0-1 (Coremail) with SMTP id _____wCHOwQevnhknYqlAg--.13462S2;
        Thu, 01 Jun 2023 23:49:52 +0800 (CST)
From:   tongxiaoge1001@126.com
To:     netfilter-devel@vger.kernel.org
Cc:     shixuantong1@huawei.com, shixuantong <tongxiaoge1001@126.com>
Subject: [PATCH] fix typo
Date:   Thu,  1 Jun 2023 23:49:45 +0800
Message-Id: <20230601154945.65460-1-tongxiaoge1001@126.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wCHOwQevnhknYqlAg--.13462S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Jr43KryxZrW5Aw4DWF17KFg_yoWxCFX_G3
        45ZFs7Way2yF1qva1kX3Z5A34xGrnrJr1xXwn3JFnrt3yUAr4Yk3WkWFW8Aw1UWrW5KasI
        qwnIvrykCw47GjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUUfOz3UUUUU==
X-Originating-IP: [101.71.37.67]
X-CM-SenderInfo: pwrqw55ldrwvirqqiqqrswhudrp/1tbiHASBWlpEKGCLhgAAsY
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: shixuantong <tongxiaoge1001@126.com>

---
 tests/nft-table-test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/nft-table-test.c b/tests/nft-table-test.c
index 1b2f280..53cf3d1 100644
--- a/tests/nft-table-test.c
+++ b/tests/nft-table-test.c
@@ -34,7 +34,7 @@ static void cmp_nftnl_table(struct nftnl_table *a, struct nftnl_table *b)
 		print_err("table flags mismatches");
 	if (nftnl_table_get_u32(a, NFTNL_TABLE_FAMILY) !=
 	    nftnl_table_get_u32(b, NFTNL_TABLE_FAMILY))
-		print_err("tabke family mismatches");
+		print_err("table family mismatches");
 }
 
 int main(int argc, char *argv[])
-- 
2.33.0

