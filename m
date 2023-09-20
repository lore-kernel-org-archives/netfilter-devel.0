Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C734C05023
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 20:57:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbjITU5o (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 16:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbjITU5k (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 16:57:40 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDBBED6
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 13:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=iDu697f2b5XxOrXr6wzNZ7wMzEh47L0ykALZBQhR8Tk=; b=VU+zGnU0WkBNc/5+vV6hBvtkm+
        8oz3LH+ZK2CLM0JNijqmQsIzpCAy9B3BZHObBMFGsi9niAom9RQ6hICuPqapBMGuYvj9BCC2+caHF
        r1nah4INXJcLnAim4vZ4linVy3kihv+OhKgohLz/Ud+bquQbbhEpoKLPlfzKa679DYxJJy9dlCB9V
        6OxBYY0M+HZT+a+T85o8sEGxaNWLPHrMyqYtPemIMf2Nv9x9VGiwB9TTs0KSoX7CEHMxQM68UtP32
        5IOAuhzYgpmq7iSzMCZ+b+hoTfbOxQZBCrgCrWQu2NRsatBDs2T+xYJ3Y1KabSkyb16c0z+zBLxi5
        qkVF5K5A==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qj4GL-0007qU-7d; Wed, 20 Sep 2023 22:57:33 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 2/9] parser_json: Fix typo in json_parse_cmd_add_object()
Date:   Wed, 20 Sep 2023 22:57:20 +0200
Message-ID: <20230920205727.22103-3-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230920205727.22103-1-phil@nwl.cc>
References: <20230920205727.22103-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

A case of bad c'n'p in the fixed commit broke ct timeout objects
parsing.

Fixes: c7a5401943df8 ("parser_json: Fix for ineffective family value checks")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/parser_json.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index 242f05eece58c..045bee1d8edaa 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -3570,7 +3570,7 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 			obj_free(obj);
 			return NULL;
 		}
-		obj->ct_helper.l3proto = l3proto;
+		obj->ct_timeout.l3proto = l3proto;
 
 		init_list_head(&obj->ct_timeout.timeout_list);
 		if (json_parse_ct_timeout_policy(ctx, root, obj)) {
-- 
2.41.0

