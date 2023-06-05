Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 783C0C77B73
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Jun 2023 16:11:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232705AbjFEQLe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 5 Jun 2023 12:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233060AbjFEQLc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Jun 2023 12:11:32 -0400
Received: from m126.mail.126.com (m126.mail.126.com [220.181.12.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9202C10C
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Jun 2023 09:11:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=ebnzK
        kOREOp78ImAI+Zo5rRhMVxXd9G/gcXNQOGIh10=; b=jcS5mbsD8np64/uZH/M7N
        A1i4H+URLDWg3GAWTTm+wcVv5rKXc7nAcFLzUTIdbYgdrebbvO/kp0tc/gBszdjJ
        cIWjTSsXhR+OuGeuSCBCKHmjDE5etozzKluJG2PTVPnj4G/s7+rFc3zB4/T0RE31
        CE6JX/bid1aT2hMBdImkxY=
Received: from localhost.localdomain (unknown [58.101.35.131])
        by zwqz-smtp-mta-g2-1 (Coremail) with SMTP id _____wA3h9scCX5kLxAIAw--.54520S4;
        Tue, 06 Jun 2023 00:11:09 +0800 (CST)
From:   tongxiaoge1001@126.com
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, shixuantong1@huawei.com,
        tongxiaoge1001@126.com
Subject: [PATCH] define "i" only if attr is NFTNL_CHAIN_DEVICES. When attr isn't NFTNL_CHAIN_DEVICES, "i" is useless.
Date:   Tue,  6 Jun 2023 00:11:04 +0800
Message-Id: <20230605161104.117375-1-tongxiaoge1001@126.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wA3h9scCX5kLxAIAw--.54520S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7WrW8GrWrXFyUXF4xXry7Wrg_yoW8WrW8pr
        W5JFyftr4fJF1xtr1rKay5ua1agw4vgr15Grn8A3W7Aws8WasYkFWUKw1SvrWYgFn3K3W3
        K3Z8XF1vga1rZFUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jz6wZUUUUU=
X-Originating-IP: [58.101.35.131]
X-CM-SenderInfo: pwrqw55ldrwvirqqiqqrswhudrp/1tbiHB6FWlpEKIDhngAAsU
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: shixuantong <tongxiaoge1001@126.com>

---
 src/chain.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index dcfcd04..f88aa7f 100644
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
@@ -209,7 +207,7 @@ int nftnl_chain_set_data(struct nftnl_chain *c, uint16_t attr,
 			 const void *data, uint32_t data_len)
 {
 	const char **dev_array;
-	int len = 0, i;
+	int len = 0;
 
 	nftnl_assert_attr_exists(attr, NFTNL_CHAIN_MAX);
 	nftnl_assert_validate(data, nftnl_chain_validate, attr, data_len);
@@ -277,7 +275,7 @@ int nftnl_chain_set_data(struct nftnl_chain *c, uint16_t attr,
 			len++;
 
 		if (c->flags & (1 << NFTNL_CHAIN_DEVICES)) {
-			for (i = 0; i < c->dev_array_len; i++)
+			for (int i = 0; i < c->dev_array_len; i++)
 				xfree(c->dev_array[i]);
 			xfree(c->dev_array);
 		}
@@ -286,7 +284,7 @@ int nftnl_chain_set_data(struct nftnl_chain *c, uint16_t attr,
 		if (!c->dev_array)
 			return -1;
 
-		for (i = 0; i < len; i++)
+		for (int i = 0; i < len; i++)
 			c->dev_array[i] = strdup(dev_array[i]);
 
 		c->dev_array_len = len;
-- 
2.33.0

