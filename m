Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3749C05025
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 20:57:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjITU5l (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 16:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbjITU5k (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 16:57:40 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E41BB
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 13:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=u+s2jInuvmiWDvA4SFHrMBS27WUM5NXDebnPZ3fG09Y=; b=R7QWE6epMecW3IcxB7kq51vu32
        afZ7Oxq/Gx+Pi09cMSy6d7AQS5RmU1/CanzJYcqUH/dp4pmPg8+KIO8m89st+7p/uvC5rpYgGuBmg
        rWhdutdQe0nQYqF/zkQlVbCLzSK3WQqudwbuDWqOqT7RuO/Pa5pvs7mFa9bS5lxQ6fsZedbMOUU2Q
        5L+EzXOi/bwqboCqPpQGVaEvgBaC4DP6ScCpfvqfXAQIwJcVd+Rx+kazeLL8t/FOT4dkPvnnuPsEB
        rAbmzR/c9DXqB57RSNCbgtXHNSOQ9zHSGxPrpnHTTo+rf2gqT9A6BMTLoJCQ4nLUlWZ0/5dVpKIha
        ysnsNeEg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qj4GJ-0007pt-7h; Wed, 20 Sep 2023 22:57:31 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 5/9] parser_json: Fix limit object burst value parsing
Date:   Wed, 20 Sep 2023 22:57:23 +0200
Message-ID: <20230920205727.22103-6-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230920205727.22103-1-phil@nwl.cc>
References: <20230920205727.22103-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The field is of type uint32_t, use lower case 'i' format specifier.

Fixes: c36288dbe2ba3 ("JSON: Fix parsing and printing of limit objects")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/parser_json.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index 1921f301c51be..2b244783c442d 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -3616,7 +3616,7 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 		}
 		json_unpack(root, "{s:s}", "rate_unit", &rate_unit);
 		json_unpack(root, "{s:b}", "inv", &inv);
-		json_unpack(root, "{s:I}", "burst", &obj->limit.burst);
+		json_unpack(root, "{s:i}", "burst", &obj->limit.burst);
 		json_unpack(root, "{s:s}", "burst_unit", &burst_unit);
 
 		if (!strcmp(rate_unit, "packets")) {
-- 
2.41.0

