Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2C5FC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Feb 2022 18:13:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234932AbiBVSOF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Feb 2022 13:14:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234339AbiBVSOE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Feb 2022 13:14:04 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DFD865431;
        Tue, 22 Feb 2022 10:13:39 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id x11so16334851pll.10;
        Tue, 22 Feb 2022 10:13:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UaYk7nVE6cDdy8gCfTkB8D/D30yf076KmJkHTi6AZSM=;
        b=dAEYXkVQRPacgGema/JtVxGzXJWA+m4CuYnupC76TrDlHu/c6UUm5c29Snzow/sYt2
         TFsXwSrX5ZHmtO0US0XTkuLcPV2n9uLddIG+S2yjohNFcWLrStgXFQCNWb+OrvHCXC09
         59S8F0WHNgOMj49FBJwksN9xqC+y87KKIhJ1g3j3sBnv0AQ9VX/LV6IvkcOyvHvBiv19
         bZxZJJpufMbfEVoyJJsQjujWmSwPJTnncrrJ77nUNL9ea1zo7NxzxYdmOPT+BMGE50+Z
         PeUuwXm4Zz6A8RdNZ1R58VUWxIHwujXEf+XoD7vri2Cdd0y3RbZzamXKm4zmpx5GNcFa
         vnEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UaYk7nVE6cDdy8gCfTkB8D/D30yf076KmJkHTi6AZSM=;
        b=h8751LH1suTE74CfFw+Kq1fLWDSzrXZCSzu3rSrteXmlaoxnqfYtXB6FSsI7s6Boph
         dh+14Mqx32wttTFKuHjpCBaPvs+TsctP7KYUGKNVa4UbJl7a3dsB6yFiRVzfgGbl6CEn
         UqWxufNHW6sdJwVUukNZGxso+/E8/ky2kGxHEvidDOtbRBIxYm74xRvUFVm9/8/DOAHL
         QgDT/FrEl6QcxE39UnMiUg4417NpqEGZx3VGdgIt2I081J74SkU4ZuwpJf076ynqXlUS
         mVDYApTtYozlpDWgKl9jWsDHYDkdFVgjL3ylSWl9zdEepeqy9QbNe7toM5p25WmsF0SU
         A+DQ==
X-Gm-Message-State: AOAM533nYqm4L9AE1vjycTJLnTiq0w5nHNJLCW22sdtpXPDWbzjUc2PN
        BfZ/cXrbCi2hv9Uopz1YmNA=
X-Google-Smtp-Source: ABdhPJwvMlfDxf/GmbrzQhmBrH3nInFy4hkvQh1Vi4yeH7sBKJNqiNK6twpoOsiCrikcwTkpMP8ftQ==
X-Received: by 2002:a17:902:6b8b:b0:14d:66c4:f704 with SMTP id p11-20020a1709026b8b00b0014d66c4f704mr24513470plk.53.1645553616116;
        Tue, 22 Feb 2022 10:13:36 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:f99a:9263:216c:fd72])
        by smtp.gmail.com with ESMTPSA id 142sm18542968pfy.11.2022.02.22.10.13.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 10:13:35 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net] netfilter: nf_tables: prefer kfree_rcu(ptr, rcu) variant
Date:   Tue, 22 Feb 2022 10:13:31 -0800
Message-Id: <20220222181331.811085-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

While kfree_rcu(ptr) _is_ supported, it has some limitations.

Given that 99.99% of kfree_rcu() users [1] use the legacy
two parameters variant, and @catchall objects do have an rcu head,
simply use it.

Choice of kfree_rcu(ptr) variant was probably not intentional.

[1] including calls from net/netfilter/nf_tables_api.c

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/netfilter/nf_tables_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 5fa16990da95177791dfaa9e7bb31c92f3cae096..ef79d8d09773588cc399113fd5bcf584c592f039 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4502,7 +4502,7 @@ static void nft_set_catchall_destroy(const struct nft_ctx *ctx,
 	list_for_each_entry_safe(catchall, next, &set->catchall_list, list) {
 		list_del_rcu(&catchall->list);
 		nft_set_elem_destroy(set, catchall->elem, true);
-		kfree_rcu(catchall);
+		kfree_rcu(catchall, rcu);
 	}
 }
 
@@ -5669,7 +5669,7 @@ static void nft_setelem_catchall_remove(const struct net *net,
 	list_for_each_entry_safe(catchall, next, &set->catchall_list, list) {
 		if (catchall->elem == elem->priv) {
 			list_del_rcu(&catchall->list);
-			kfree_rcu(catchall);
+			kfree_rcu(catchall, rcu);
 			break;
 		}
 	}
-- 
2.35.1.473.g83b2b277ed-goog

