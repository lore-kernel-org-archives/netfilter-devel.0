Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 433D7EB64D9
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Jun 2023 11:46:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbjFSLqr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 19 Jun 2023 07:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjFSLqq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Jun 2023 07:46:46 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD3D9D1
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2023 04:46:43 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id 2adb3069b0e04-4f63ab1ac4aso4154603e87.0
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2023 04:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687175202; x=1689767202;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tMo0C27ggZtkOZ0WpUZDH3YN5tE6nnUOSePoLm18uuo=;
        b=aLyStKE64rYfiSzeyczLc41u9c0qDOiNps9a7K+B3xqgOPwMVYYv+OexvSBJ4fNc3e
         kUfIklju2Zd71gDOr1FRu3K8Tv5LtwTssOCuBKnnmF1UtYCFo2SAzKlrTi7ZbT3/FbNy
         g9ubY6Hf7sB1Kp+fnO9A5REjJxrGURVFu6SSMhYluuYO4QXQ6THhIKIPy4V6UoOSFeZt
         TMQuYIZNODsFcidYuP8K8zZeLwUGmerM6F2OxSp8VAOR/J5xQ1yaqwL53l1fVhNmN8mt
         gnAVaNMoEA4M/4iyIkPYFgArUB/1rmF09Od0nKvyzGfmG8ublxtl0Fn0J5Yeex7wCDgh
         Dq3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687175202; x=1689767202;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tMo0C27ggZtkOZ0WpUZDH3YN5tE6nnUOSePoLm18uuo=;
        b=a86do1QASb/H+jnvVEnv1xl7pdl2OoLjuE1drempUXDg1uN9OesGZoPjiRIeLREYd1
         tXM0yiTeLTUnzNAgk8yNXPm4kwSXfBv4Zb0WJVycYUUaYIVP1wKpjY512t7HOOVin5LX
         MrXDYeCKzYTP/rTv/LHwK61nmu2x3u8QFfab3y9BmEoDNCUlofVBJ2a6jrF9KA9nesrR
         eGQwJABCnFP7iHVW9D0kjZrEO3MrGniBxcinFHXFLc5pLk3BvUlhN3SC9SZ7g/WJF9Wv
         h0MRpuuY6ySEKSqC2qa3dKG7OEBU5MJpzsDlv6dcdMm07w8GvvCfPWiGsQiXDKZctM68
         48Aw==
X-Gm-Message-State: AC+VfDxnTUTGoUvNnwZIOsshfSehSDclmGSkL20FZrrXFpigbKQVP7iB
        wvcj183bYV7zGd/9jJSx0OjzH/TOzkwhgg==
X-Google-Smtp-Source: ACHHUZ7PYyW6xjNO3rC7HWNLipHFmmg6jXI3BpIfeCA3PDxSclvgKEZ3azXtcIpkzlfoGtkMe89DEg==
X-Received: by 2002:a19:ca07:0:b0:4f7:63f4:d2a9 with SMTP id a7-20020a19ca07000000b004f763f4d2a9mr4399299lfg.10.1687175201867;
        Mon, 19 Jun 2023 04:46:41 -0700 (PDT)
Received: from linux-ti96.home.skz-net.net ([80.68.235.246])
        by smtp.gmail.com with ESMTPSA id a9-20020ac25209000000b004f866200361sm950194lfl.164.2023.06.19.04.46.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jun 2023 04:46:41 -0700 (PDT)
From:   Jacek Tomasiak <jacek.tomasiak@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Jacek Tomasiak <jacek.tomasiak@gmail.com>,
        Jacek Tomasiak <jtomasiak@arista.com>
Subject: [iptables PATCH] iptables: Fix handling of non-existent chains
Date:   Mon, 19 Jun 2023 13:46:36 +0200
Message-Id: <20230619114636.7672-1-jacek.tomasiak@gmail.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Since 694612adf87 the "compatibility" check considers non-existent
chains as "incompatible". This broke some scripts which used calls
like `iptables -L CHAIN404` to test for chain existence and expect
"No chain/target/match by that name." in the output.

This patch changes the logic of `nft_is_table_compatible()` to
report non-existent chains as "compatible" which restores the old
behavior.

Fixes: 694612adf87 ("nft: Fix selective chain compatibility checks")
Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1648
Signed-off-by: Jacek Tomasiak <jtomasiak@arista.com>
Signed-off-by: Jacek Tomasiak <jacek.tomasiak@gmail.com>
---
 iptables/nft.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 1cb104e7..020553a4 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -3860,7 +3860,7 @@ bool nft_is_table_compatible(struct nft_handle *h,
 	if (chain) {
 		struct nft_chain *c = nft_chain_find(h, table, chain);
 
-		return c && !nft_is_chain_compatible(c, h);
+		return !c || !nft_is_chain_compatible(c, h);
 	}
 
 	return !nft_chain_foreach(h, table, nft_is_chain_compatible, h);
-- 
2.35.3

