Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73EEFC2FC08
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 20:57:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbjITU5n (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 16:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbjITU5k (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 16:57:40 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A8BACC
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 13:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1SBVPWMpAcffQefywT0Vyy5VYDSgdxBhmc0c09Hd5Cw=; b=pT/XZAFK3Nf2vkRCN7OhnKivps
        CmGbyutGMtlciNYTE8Xeg+udc+XbfM1tEyUdysdw6B4lBBBJLCYAQ66wRsR4yo5GBmflJjPr5DYsI
        Me/dyOtwLHJwI6zc9e/qWW0OcwoAhpl23P5fnXW/wt2lBkXg9PDuybD6Drm8oE75S8TED8XWYx/0J
        vV9tZxNtB6kPIR2yktMrsUOfJVQan4qTgFNz1RGw86g2OY4fj7c4Jtx9/a/7PWAhKCI6tDNnJ5oIm
        KOGsv6Zyb51ek6OnO01RAQ9j7li3yJViSo5MSMxVgRZ+mIj7UVYo/TK35n/2cU1Xt8afpHfYvWIRX
        iJ4VpjnQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qj4GK-0007qF-CV; Wed, 20 Sep 2023 22:57:32 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 9/9] parser_json: Default meter size to zero
Date:   Wed, 20 Sep 2023 22:57:27 +0200
Message-ID: <20230920205727.22103-10-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230920205727.22103-1-phil@nwl.cc>
References: <20230920205727.22103-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

JSON parser was missed when performing the same change in standard
syntax parser.

Fixes: c2cad53ffc22a ("meters: do not set a defaut meter size from userspace")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/parser_json.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index 15bb79a52bcc0..7549fc85c48b2 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -2687,7 +2687,7 @@ static struct stmt *json_parse_meter_stmt(struct json_ctx *ctx,
 	json_t *jkey, *jstmt;
 	struct stmt *stmt;
 	const char *name;
-	uint32_t size = 0xffff;
+	uint32_t size = 0;
 
 	if (json_unpack_err(ctx, value, "{s:s, s:o, s:o}",
 			    "name", &name, "key", &jkey, "stmt", &jstmt))
-- 
2.41.0

