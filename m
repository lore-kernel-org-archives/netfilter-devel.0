Return-Path: <SRS0=4Kr+=Y2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CC31CA9EC7
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Nov 2019 20:59:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 612FE214AF
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Nov 2019 20:59:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="F3Tgzoti"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbfKBU74 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 Nov 2019 16:59:56 -0400
Received: from mx1.riseup.net ([198.252.153.129]:39346 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726523AbfKBU7z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Nov 2019 16:59:55 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 475BJq1r16zDrK5
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Nov 2019 13:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1572728395; bh=pvZ9+nvI0WKaJ4Mf0nwfXqWD6j+p3X3dIwzwCRvg20M=;
        h=From:To:Cc:Subject:Date:From;
        b=F3Tgzoti4ovSxYP+vf22DGmsq/HIm9T0/YaC1ZD/3dMaCfVIIeokEtJoGMtz62bUs
         GmVrj8BdmT4JxbtUkn7/M6Tr/WQQlVHC+zvrTTSsj8EWvrS+0S9zWpZpewSVC+EWy8
         mgoTEvcD6xjkeIC0hHSfXQnzpLP0WkQqsa+wV4cQ=
X-Riseup-User-ID: 0C9E7CC3AD0F9FDBCCCB520AC04D39B96297983A70A8D8011256DAA77D54AC12
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 475BJp2ytRzJrZY;
        Sat,  2 Nov 2019 13:59:54 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH nf] netfilter: nf_tables: fix unexpected EOPNOTSUPP error
Date:   Sat,  2 Nov 2019 21:59:44 +0100
Message-Id: <20191102205944.22253-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If the object type doesn't implement an update operation and the user tries to
update it will silently ignore the update operation.

Fixes: aa4095a156b5 ("netfilter: nf_tables: fix possible null-pointer dereference in object update")
Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 net/netfilter/nf_tables_api.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d481f9baca2f..aa26841ad9a1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5143,9 +5143,6 @@ static int nf_tables_updobj(const struct nft_ctx *ctx,
 	struct nft_trans *trans;
 	int err;
 
-	if (!obj->ops->update)
-		return -EOPNOTSUPP;
-
 	trans = nft_trans_alloc(ctx, NFT_MSG_NEWOBJ,
 				sizeof(struct nft_trans_obj));
 	if (!trans)
@@ -6499,7 +6496,8 @@ static void nft_obj_commit_update(struct nft_trans *trans)
 	obj = nft_trans_obj(trans);
 	newobj = nft_trans_obj_newobj(trans);
 
-	obj->ops->update(obj, newobj);
+	if (obj->ops->update)
+		obj->ops->update(obj, newobj);
 
 	kfree(newobj);
 }
-- 
2.20.1

