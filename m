Return-Path: <SRS0=Os8a=S2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30F87C10F11
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Apr 2019 14:48:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3403218FD
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Apr 2019 14:48:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=untangle.com header.i=@untangle.com header.b="JMdomLpj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731042AbfDXOsz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Apr 2019 10:48:55 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:46698 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731852AbfDXOst (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Apr 2019 10:48:49 -0400
Received: by mail-qt1-f196.google.com with SMTP id w26so13775308qto.13
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Apr 2019 07:48:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=untangle.com; s=google;
        h=from:to:subject:date:message-id;
        bh=oyrOKYG3UnGfs8RtFrj+HOqvHjAAYdkKDQx9/ghtJoQ=;
        b=JMdomLpjq+RxaqsRO7mlKwMuxGnA95R5Ae/AGUtmArm12up0tCJRG76y4ATtJcLUQU
         17R9bISCE9WWpQHllRTSXliA86guQWa0wzmorP0Ycun2PRitIUBGQA6M1lqaw3WHycAC
         ogHO/H9GJqSVb4M6MC0zaHlmysqVY6Vd0TQDI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=oyrOKYG3UnGfs8RtFrj+HOqvHjAAYdkKDQx9/ghtJoQ=;
        b=SLL4M+cE/k+0fYrTiUs/+H6Kig/CBQmDciGy7IDIYfOuPseZArcF/gunH42cBmOJVY
         4uYfaf/Z++XQ9okRpllAw4SeAqDEIj+w9TEYfu7u6+7HGM2Z7LbO9bWkemtQZhO7vSX1
         ugDU1uIBv92rLQJr7xCGmhIx5WUdyQuTG9CY3YOKPgPHaRjgLpSe354MKXeaL1pwQ6Mk
         7FTPXnyRfLQGiWRdwadGlaWa+qjF5xpdCt5TJKCAJDmfrj+wATlYES23krQZ6wRJcIx7
         9qdVd/YXegeNNNCTM3eew7BvuHe9UbWMLwyp8cg9g5oPxYM61r8Ag+9QDLUq488xUHtj
         B8LA==
X-Gm-Message-State: APjAAAU/CJzoQ844ci1ejSOHFpt1RfHCrQA39kFjbtLhnLboU9yAzQfn
        7EaL93JM4nMelAp/94Xznjw50sqXw7g=
X-Google-Smtp-Source: APXvYqzzdG0eplTSY4xGB1IlDDJEdg9Vfh1JE9xjthCxhk4Byp0ykS3xzilkKoSB9opG+9wSjV4+Ww==
X-Received: by 2002:a0c:d2f2:: with SMTP id x47mr25809405qvh.90.1556117328539;
        Wed, 24 Apr 2019 07:48:48 -0700 (PDT)
Received: from osboxes.example.com (cpe-74-137-94-90.kya.res.rr.com. [74.137.94.90])
        by smtp.gmail.com with ESMTPSA id d41sm12058396qtd.90.2019.04.24.07.48.47
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Apr 2019 07:48:48 -0700 (PDT)
From:   Brett Mastbergen <bmastbergen@untangle.com>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH v2] netfilter: nft_ct: Add ct id support
Date:   Wed, 24 Apr 2019 10:48:44 -0400
Message-Id: <20190424144844.20345-1-bmastbergen@untangle.com>
X-Mailer: git-send-email 2.11.0
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The 'id' key returns the unique id of the conntrack entry as returned
by nf_ct_get_id()

v2: Add nfct_is_confirmed check

Signed-off-by: Brett Mastbergen <bmastbergen@untangle.com>
---
 include/uapi/linux/netfilter/nf_tables.h | 2 ++
 net/netfilter/nft_ct.c                   | 8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 061bb3eb20c3..f0cf7b0f4f35 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -967,6 +967,7 @@ enum nft_socket_keys {
  * @NFT_CT_SRC_IP6: conntrack layer 3 protocol source (IPv6 address)
  * @NFT_CT_DST_IP6: conntrack layer 3 protocol destination (IPv6 address)
  * @NFT_CT_TIMEOUT: connection tracking timeout policy assigned to conntrack
+ * @NFT_CT_ID: conntrack id
  */
 enum nft_ct_keys {
 	NFT_CT_STATE,
@@ -993,6 +994,7 @@ enum nft_ct_keys {
 	NFT_CT_SRC_IP6,
 	NFT_CT_DST_IP6,
 	NFT_CT_TIMEOUT,
+	NFT_CT_ID,
 	__NFT_CT_MAX
 };
 #define NFT_CT_MAX		(__NFT_CT_MAX - 1)
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 7b717fad6cdc..7706db36f8b9 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -178,6 +178,11 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
 		return;
 	}
 #endif
+	case NFT_CT_ID:
+		if (!nf_ct_is_confirmed(ct))
+			goto err;
+		*dest = nf_ct_get_id(ct);
+		return;
 	default:
 		break;
 	}
@@ -479,6 +484,9 @@ static int nft_ct_get_init(const struct nft_ctx *ctx,
 		len = sizeof(u16);
 		break;
 #endif
+	case NFT_CT_ID:
+		len = sizeof(u32);
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.11.0

