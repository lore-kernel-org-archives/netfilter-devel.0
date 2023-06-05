Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78F70C7EE23
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Jun 2023 16:00:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232217AbjFEQAn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 5 Jun 2023 12:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbjFEQAm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Jun 2023 12:00:42 -0400
Received: from m126.mail.126.com (m126.mail.126.com [220.181.12.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 52AE3B7
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Jun 2023 09:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=/PprR
        OYzbNTq2/Pvl68nLVIUNed0RFA3mGYfSghbkUE=; b=o8E/xA+DpvhqKrVWFvFPx
        4KMLUw+vcv0DvZhhFSRbfjuLu+vncgkoKcyOVz1O5bcxDvaGb8v7K3ue5tNVpo7L
        iBgTPoUJXnQBRCjceIzRQs8X7XPYclQ7hNqANiC4jBiQnOvVdU+mlOBF/vI+ZqmO
        IEOzTFE7+1yTfsbKo8ZTgw=
Received: from localhost.localdomain (unknown [58.101.35.131])
        by zwqz-smtp-mta-g3-1 (Coremail) with SMTP id _____wC3CHuUBn5kW74IAw--.10668S4;
        Tue, 06 Jun 2023 00:00:22 +0800 (CST)
From:   tongxiaoge1001@126.com
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, shixuantong1@huawei.com,
        tongxiaoge1001@126.com
Subject: [PATCH] define "i" only if attr is NFTNL_CHAIN_DEVICES. When attr isn't NFTNL_CHAIN_DEVICES, "i" is useless.
Date:   Tue,  6 Jun 2023 00:00:16 +0800
Message-Id: <20230605160016.105485-1-tongxiaoge1001@126.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <ZHjqV4Nj5/ALy9fN@calendula>
References: <ZHjqV4Nj5/ALy9fN@calendula>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wC3CHuUBn5kW74IAw--.10668S4
X-Coremail-Antispam: 1Uf129KBjvdXoWrZw17ArW5KFyDGF1UKw45Jrb_yoW3Wwb_KF
        1jqFWkWFW8AF4DJ395tr92kr9aqws5Gr4xG34IyF47t3yYqws7Z3WktFZ3Wrn5JayvyF92
        ya43ArnYkrW3AjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUncAw7UUUUU==
X-Originating-IP: [58.101.35.131]
X-CM-SenderInfo: pwrqw55ldrwvirqqiqqrswhudrp/1tbiihSFWlpEDx6d+QAAsq
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: shixuantong <tongxiaoge1001@126.com>

---
 src/chain.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index dcfcd04..eb2cba7 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -150,8 +150,6 @@ bool nftnl_chain_is_set(const struct nftnl_chain *c, uint16_t attr)
 EXPORT_SYMBOL(nftnl_chain_unset);
 void nftnl_chain_unset(struct nftnl_chain *c, uint16_t attr)
 {
-	int i;
-
 	if (!(c->flags & (1 << attr)))
 		return;
 
@@ -181,7 +179,7 @@ void nftnl_chain_unset(struct nftnl_chain *c, uint16_t attr)
 		xfree(c->dev);
 		break;
 	case NFTNL_CHAIN_DEVICES:
-		for (i = 0; i < c->dev_array_len; i++)
+		for (int i = 0; i < c->dev_array_len; i++)
 			xfree(c->dev_array[i]);
 		xfree(c->dev_array);
 		break;
-- 
2.33.0

