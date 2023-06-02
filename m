Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D70E0C77B7A
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Jun 2023 11:32:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235152AbjFBLcS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 2 Jun 2023 07:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233858AbjFBLcS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Jun 2023 07:32:18 -0400
Received: from m126.mail.126.com (m126.mail.126.com [220.181.12.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4A455196
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Jun 2023 04:32:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=mk2La
        Rnj9k+l/wJnY2FAIgOQ1I9Y+YgYfVYIt3HBAmg=; b=oScs1YIusxSgtgcEDswgt
        LVXuoAjaAVssoAs0rR9fD/kwvDtZZi5/ipzEXNiLObycO6AKoWoYKkzSVVTC/QgX
        W5wnI6uA6luONl3VLOqOJBtNQfX1EWMde1MbS0Owlh0qPVoJrBw41lse4mWaWgXs
        E64boAtafGEAtrITaGlZLc=
Received: from localhost.localdomain (unknown [58.101.35.131])
        by zwqz-smtp-mta-g0-1 (Coremail) with SMTP id _____wCHwRAr03lkqlK6Ag--.14561S4;
        Fri, 02 Jun 2023 19:31:56 +0800 (CST)
From:   tongxiaoge1001@126.com
To:     tongxiaoge1001@126.com
Cc:     netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        shixuantong1@huawei.com
Subject: [PATCH] fix typo
Date:   Fri,  2 Jun 2023 19:31:53 +0800
Message-Id: <20230602113153.75428-1-tongxiaoge1001@126.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230601155323.65484-1-tongxiaoge1001@126.com>
References: <20230601155323.65484-1-tongxiaoge1001@126.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wCHwRAr03lkqlK6Ag--.14561S4
X-Coremail-Antispam: 1Uf129KBjvdXoW7XF1DtrWkAF18CF1xAFy3twb_yoW3Grg_G3
        45ZFsrW3yjyF1vvw4kXas5A3s7GrnrJr1xXwn3JF9rtryjyr4Yk3WkWFW8Aw1UWrW5KasI
        qwnFvrykGw47WjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU11EE7UUUUU==
X-Originating-IP: [58.101.35.131]
X-CM-SenderInfo: pwrqw55ldrwvirqqiqqrswhudrp/1tbiHA+CWlpEKGjKagAAs1
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: shixuantong <tongxiaoge1001@126.com>

Fix: https://bugzilla.netfilter.org/show_bug.cgi?id=1681
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

