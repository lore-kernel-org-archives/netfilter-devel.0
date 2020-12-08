Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B71BFC4361B
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Dec 2020 21:40:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F42623B26
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Dec 2020 21:40:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbgLHVkQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Dec 2020 16:40:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbgLHVkQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Dec 2020 16:40:16 -0500
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C7EC061793
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Dec 2020 13:39:29 -0800 (PST)
Received: by mail-qk1-x744.google.com with SMTP id z188so89783qke.9
        for <netfilter-devel@vger.kernel.org>; Tue, 08 Dec 2020 13:39:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4/Et4d86KkdGmzNVk90U9pry+m5DFpsHi7AF9Lmki4w=;
        b=TNoX2uGVuo4neEAJdUGSCeBP6q2oUu9QElLzxmlO7d7a8KOAs3EbLIHyIAEpw9Ro9Q
         vTU6nbGPyknXpqSBAvat8o5dVcduOicX8LY74diIxePpSDPyJ7LCT3ucfBAHJaAOYibk
         i+LBMtLiReeq1RdTLtrcPvBqEf2ZI3fNZummapEVlEBg3mqqUxpjD8alQZW8PkFM2DZQ
         eVvwCnq0yrmBDFTa+2d9LR7ls6vT1aZ75mt7qCqb+yJ8px9ZgATwf/uz2ezS/3NiqcC0
         ySlVSxEriT6G/VM/DgKp8QQqtmbpnzHeCQDttcHodcD4BEnmCCrUS2uRuWeCvePgFP5r
         yJSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4/Et4d86KkdGmzNVk90U9pry+m5DFpsHi7AF9Lmki4w=;
        b=fLa9N1TJTlW5p1LYxMNtS/D37W6sp3qDQoJsQestyoAl1VSgVUHPL9DmLOB1KD7W6S
         xd5Twa3l7D/flK2wBo7sslLHqV3hX8a5IbxDid3CMYfGfpBNJ8P/AEzqqK5MkvSudzSr
         Qbk6O9M5Zk7T6PLpcj1kcha3Nj6dNR1ujEAwuGJrJU7m5lSllRGcpvunk786VnmjZkKy
         xn4FsGDvUsv+1gsYts0RGsJr7Web4Lp3aNCcsBiyPKUIA5lLmsTGkxotdpQFuIbCotBz
         JJ2emmxRvDYpJ5zac/wlPmvFB9JlLnP00TKQSdaQfqlIJPuBWYGMHXc0Evd4e9RN+tZd
         WUkQ==
X-Gm-Message-State: AOAM5301ACVd0CUTbS1XwPA0BiCGK9TvPy/8d1cwexzX/g+E5bH7RALL
        8TbDfmaICxDSr6McIf7A0tn9dnFW09rTIg==
X-Google-Smtp-Source: ABdhPJxTgyOZwH01vyT9D/+Ch2kTJCuclo2eLFJZTMdS506Oeh6Ii4QFtP0oLqOYdEr1M91YRNjLnA==
X-Received: by 2002:a37:6244:: with SMTP id w65mr14711053qkb.307.1607463568999;
        Tue, 08 Dec 2020 13:39:28 -0800 (PST)
Received: from osboxes.zebraskunk.int (cpe-74-136-79-27.kya.res.rr.com. [74.136.79.27])
        by smtp.gmail.com with ESMTPSA id h64sm15488542qkd.42.2020.12.08.13.39.28
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 13:39:28 -0800 (PST)
From:   Brett Mastbergen <brett.mastbergen@gmail.com>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nft_ct: Remove confirmation check for NFT_CT_ID
Date:   Tue,  8 Dec 2020 16:39:24 -0500
Message-Id: <20201208213924.3106-1-brett.mastbergen@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Since commit 656c8e9cc1ba ("netfilter: conntrack: Use consistent ct id
hash calculation") the ct id will not change from initialization to
confirmation.  Removing the confirmation check allows for things like
adding an element to a 'typeof ct id' set in prerouting upon reception
of the first packet of a new connection, and then being able to
reference that set consistently both before and after the connection
is confirmed.

Signed-off-by: Brett Mastbergen <brett.mastbergen@gmail.com>
---
 net/netfilter/nft_ct.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 322bd674963e..a1b0aac46e9e 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -177,8 +177,6 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
 	}
 #endif
 	case NFT_CT_ID:
-		if (!nf_ct_is_confirmed(ct))
-			goto err;
 		*dest = nf_ct_get_id(ct);
 		return;
 	default:
-- 
2.20.1

