Return-Path: <SRS0=M2Uw=SZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC9D1C10F03
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Apr 2019 20:17:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 943AE208E4
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Apr 2019 20:17:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=untangle.com header.i=@untangle.com header.b="Kei1k+BR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbfDWUR6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Apr 2019 16:17:58 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:44741 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbfDWUR6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Apr 2019 16:17:58 -0400
Received: by mail-qt1-f194.google.com with SMTP id s10so6885500qtc.11
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Apr 2019 13:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=untangle.com; s=google;
        h=from:to:subject:date:message-id;
        bh=/UPlqUMCcRWNar8McmP6bKAi0Dn5WBJ+Ykw/TwYNTcw=;
        b=Kei1k+BRrpgRxLCYtR0hjcppAnK7ToVkfMyph5yM//4My9P9CN0fuwfP62SnDWbdO6
         UTAgS78Y8jb94L22kk9GWMrzLxg3Gsb52FA0yXRu+R8Ro+lRt+wL6rb4e0X2n25BCr6q
         wkFId7SPZI+k4cPe8t18INXHjSKQNST7YA4ho=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=/UPlqUMCcRWNar8McmP6bKAi0Dn5WBJ+Ykw/TwYNTcw=;
        b=TLJfS9N3SPC3MXgcQ5V7cXuHunr+WRkZNFxl3eX5gHWkjDssJYxfKfdV9mK6wNYHgA
         jdrZbEWVk2IIhIUJFP4RjNCA5Wew32LBcsxggzxMk4iFWkpmUUdWkN9yU67lBvmecZ1O
         zTrhWcfmYlIM2Xv2YENdYHph5QluU3JSk2ZRrt7YvjaXif1is6G9iV0gNzrdfSW05iW/
         gwKWHMTNNx1chvkJIpMy8jrkAxpYlP47slqr95bC+hC7PTRk7Vi9phGg4ao+k9gtO+9p
         SZqahsuF5KZcmA+AiQE5m4sFFoXxrbRyVhlrZmvtD1RGhpSfw1NYzLcN6IuHgg13gyT+
         Rh3Q==
X-Gm-Message-State: APjAAAVtEA2bGIpqUrF/gGu+zM6ogLmMP11H3dEPWSNZ8bCyp+J1DKK6
        A+lcpx2eNgHsUyQtNV+BnQFwEEPUdcs=
X-Google-Smtp-Source: APXvYqydeLcU6rrO3NvH5mwXK3TTaRelG5AeufrcULfCFB1UM982D+uuVrlU70xJKgqYkIL00lW/rA==
X-Received: by 2002:ac8:744b:: with SMTP id h11mr19539656qtr.324.1556050676941;
        Tue, 23 Apr 2019 13:17:56 -0700 (PDT)
Received: from osboxes.example.com (cpe-74-137-94-90.kya.res.rr.com. [74.137.94.90])
        by smtp.gmail.com with ESMTPSA id f2sm911508qtd.67.2019.04.23.13.17.56
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Apr 2019 13:17:56 -0700 (PDT)
From:   Brett Mastbergen <bmastbergen@untangle.com>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH] netfilter: nft_ct: Add ct id support
Date:   Tue, 23 Apr 2019 16:17:51 -0400
Message-Id: <20190423201751.8447-1-bmastbergen@untangle.com>
X-Mailer: git-send-email 2.11.0
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The 'id' key returns the unique id of the conntrack entry as returned
by nf_ct_get_id()

Signed-off-by: Brett Mastbergen <bmastbergen@untangle.com>
---
 include/uapi/linux/netfilter/nf_tables.h | 2 ++
 net/netfilter/nft_ct.c                   | 6 ++++++
 2 files changed, 8 insertions(+)

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
index 7b717fad6cdc..418a17d2df31 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -178,6 +178,9 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
 		return;
 	}
 #endif
+	case NFT_CT_ID:
+		*dest = nf_ct_get_id(ct);
+		return;
 	default:
 		break;
 	}
@@ -479,6 +482,9 @@ static int nft_ct_get_init(const struct nft_ctx *ctx,
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

