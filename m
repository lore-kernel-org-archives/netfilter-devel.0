Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC608C2FC0A
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 20:57:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbjITU5o (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 16:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbjITU5l (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 16:57:41 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C28A5D9
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 13:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=RsIkuGu+dnKU7Q2Yvi8TNp6OsDpMApDB00778S5vlic=; b=CypPAy/Jyx1Kz8NgvGMQVhuzVq
        G3mgnK77RaUeyuWs341JmbYtiSXVW+yxds8bBEh0b7ITa7/U8UBmkGTYmPo08wjyF6YcgJn+2Kdb/
        XnxGd6F2Us2WzRZml+nv010qAAo8ZTCCxYpNtJDZfuQv/q4fQ2qksoKicGTrA80wilKCSF5oGvfnt
        89X0OoteSMZizC5YYh66mI/PM/VbFWd1f/BhuwXyPNFNHpJJAyntWxIbAf1W1mjKpCXyfJkpzkS6C
        HhqE+akiwbMXMxWqz4Q4kMzcYm4IeYfQjsx74cckspO9sdvK9WYsCo4FFehPkFJc2VifOd69LQquw
        6m1zyVYQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qj4GM-0007qg-3U; Wed, 20 Sep 2023 22:57:34 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 3/9] parser_json: Proper ct expectation attribute parsing
Date:   Wed, 20 Sep 2023 22:57:21 +0200
Message-ID: <20230920205727.22103-4-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230920205727.22103-1-phil@nwl.cc>
References: <20230920205727.22103-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Parts of the code were unsafe (parsing 'I' format into uint32_t), the
rest just plain wrong (parsing 'o' format into char *tmp). Introduce a
temporary int variable to parse into.

Fixes: 1dd08fcfa07a4 ("src: add ct expectations support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/parser_json.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index 045bee1d8edaa..92168b9ab580e 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -3447,8 +3447,8 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 {
 	const char *family, *tmp, *rate_unit = "packets", *burst_unit = "bytes";
 	uint32_t l3proto = NFPROTO_UNSPEC;
+	int inv = 0, flags = 0, i;
 	struct handle h = { 0 };
-	int inv = 0, flags = 0;
 	struct obj *obj;
 	json_t *jflags;
 
@@ -3599,11 +3599,12 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 				return NULL;
 			}
 		}
-		if (!json_unpack(root, "{s:o}", "dport", &tmp))
-			obj->ct_expect.dport = atoi(tmp);
-		json_unpack(root, "{s:I}", "timeout", &obj->ct_expect.timeout);
-		if (!json_unpack(root, "{s:o}", "size", &tmp))
-			obj->ct_expect.size = atoi(tmp);
+		if (!json_unpack(root, "{s:i}", "dport", &i))
+			obj->ct_expect.dport = i;
+		if (!json_unpack(root, "{s:i}", "timeout", &i))
+			obj->ct_expect.timeout = i;
+		if (!json_unpack(root, "{s:i}", "size", &i))
+			obj->ct_expect.size = i;
 		break;
 	case CMD_OBJ_LIMIT:
 		obj->type = NFT_OBJECT_LIMIT;
-- 
2.41.0

