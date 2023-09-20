Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76085C05023
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 20:57:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbjITU5l (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 16:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbjITU5k (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 16:57:40 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 483ED91
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 13:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=WGZ6a679fwvCCCReBxV/nkmR+0ZQYJj3IXsQklk+bWk=; b=cLM0KPFWkYzWdgEGnfWuIrpEdc
        JJASIjl0NNisO4zZizMxryhU/E7E4F6QFVtsJz4w3TzeRFfSE/H5SYaZtHhwvcsMbtaPWCiLo8JaW
        xp+OpARXxHKjcaqozQygl62lpjYdev3vp2IdNDTzEUxB+VxIQcjPPWvBiq/LWpzKJH/AhJ5mt8zwt
        2kwxDBvvk+lndezCzsf+BPeO1CWpgjZfDFA3q45dhxMPTZLD9Q6udVACSSM7ubn59BBoA0p2G1vHy
        wP1DNGGdn26jFpo+RXlSs9jckoj6XxPoT8vEXc3McYpjZNj367iXzyLqytxtqRNSEILdq1z9D+yi0
        tzPD6mLQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qj4GJ-0007pz-HC; Wed, 20 Sep 2023 22:57:31 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 7/9] parser_json: Wrong check in json_parse_ct_timeout_policy()
Date:   Wed, 20 Sep 2023 22:57:25 +0200
Message-ID: <20230920205727.22103-8-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230920205727.22103-1-phil@nwl.cc>
References: <20230920205727.22103-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The conditional around json_unpack() was meant to accept a missing
policy attribute. But the accidentally inverted check made the function
either ignore a given policy or access uninitialized memory.

Fixes: c82a26ebf7e9f ("json: Add ct timeout support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/parser_json.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index 8ec11083f463c..e33c470c7e224 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -3415,7 +3415,7 @@ static int json_parse_ct_timeout_policy(struct json_ctx *ctx,
 	json_t *tmp, *val;
 	const char *key;
 
-	if (!json_unpack(root, "{s:o}", "policy", &tmp))
+	if (json_unpack(root, "{s:o}", "policy", &tmp))
 		return 0;
 
 	if (!json_is_object(tmp)) {
-- 
2.41.0

