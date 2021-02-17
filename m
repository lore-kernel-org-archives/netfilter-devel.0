Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F049C433DB
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Feb 2021 20:47:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E21F164E6C
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Feb 2021 20:47:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234636AbhBQUrd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Feb 2021 15:47:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49772 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235048AbhBQUrQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Feb 2021 15:47:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613594750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=w+DiD35xdNi8av5PDEFgoqTvgnRDjIKDhokap1iQulY=;
        b=JjRw5gvoLUCX4Ung77n/OvcxxU5i3KLTqTvlXP2iFoEmSvIO27gDO4aWjcG74ZCLADI9tk
        xpv0mvaOBc52y5mmBUbPt99A8YqbIdRICS4pOY7LvVU8EHPymh/6AJGBCRTcCfD7kB1gf4
        B7ZcA3hlBIgQLrle8UuFCHPNt57q/hE=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-n2SmLWiCPtu06ixMhlp6Ww-1; Wed, 17 Feb 2021 15:45:48 -0500
X-MC-Unique: n2SmLWiCPtu06ixMhlp6Ww-1
Received: by mail-ed1-f72.google.com with SMTP id m16so11236225edd.21
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Feb 2021 12:45:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=w+DiD35xdNi8av5PDEFgoqTvgnRDjIKDhokap1iQulY=;
        b=ujnmHuWWpa7SXUGVGOKGKLCgQpk5+lpizCGvM/VSV5S7uY7Db+lKaKHJid3x1Mz86u
         jT052P7L25KLL8FPIZSl8YYrirzKUMA7w3wV7iJr6WfCIBevDNEt13sjDwf1y4frOYiH
         wAcC94A6Y7g78ehD9XfVzRyv3H6acAEh4Xu6SVc50EdWEU97tRLUZ3oNSoKesz/7dlCJ
         b/DcMUJt6Rtb54SZieFyzug6xLuYsRI1vHAtfh0QY8szCGRg/PlJXpinWiGe3wqhjh1Q
         mlgUAvwg5NCC4pC7OiffKXh32HiwnuDL4rcUyNOg5qbHYP3BO1cl9ndY0DphIiZZEWa8
         AFoQ==
X-Gm-Message-State: AOAM531BlU7VIwrD8Mp58u32V0arKFB76Jo2BE3PXJeDoCJ12BMTi4zh
        JyQU4E4c3I5X+Zb4R3zBA8o8xV5pgBnASk6+OUH++tK5ghijbvvb2EhGodNjt8qYmQpdgzHe0em
        QrJEydjV0pXSFauNWbIpPzLyTIwOkGmzalyIs1h8e4/hRnXpskk5sV/nZ67t+Bt1kVXjlTx4ZPm
        ge7GpL
X-Received: by 2002:a17:906:259a:: with SMTP id m26mr723833ejb.399.1613594747468;
        Wed, 17 Feb 2021 12:45:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJywvYrYEd53CS0elv/kMwzquKm/Yi6nfJIV4y64th5Ek4bkzazzOp4LREnbevvonRGcmjaRMw==
X-Received: by 2002:a17:906:259a:: with SMTP id m26mr723819ejb.399.1613594747134;
        Wed, 17 Feb 2021 12:45:47 -0800 (PST)
Received: from localhost.localdomain ([2a02:ed3:472:7000::1000])
        by smtp.gmail.com with ESMTPSA id ar9sm1662872ejc.32.2021.02.17.12.45.46
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Feb 2021 12:45:46 -0800 (PST)
To:     netfilter-devel@vger.kernel.org
From:   Maya Rashish <mrashish@redhat.com>
Subject: [libnftnl PATCH 1/2] Avoid out of bound reads in tests.
Message-ID: <6b4add9f-7947-9f81-48c9-83b77286d2e6@redhat.com>
Date:   Wed, 17 Feb 2021 22:45:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Our string isn't NUL-terminated. To avoid reading past
the last character, use strndup.

Signed-off-by: Maya Rashish <mrashish@redhat.com>
---
  tests/nft-expr_match-test.c  | 2 +-
  tests/nft-expr_target-test.c | 2 +-
  2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/nft-expr_match-test.c b/tests/nft-expr_match-test.c
index 39a49d8..f6b7bc0 100644
--- a/tests/nft-expr_match-test.c
+++ b/tests/nft-expr_match-test.c
@@ -71,7 +71,7 @@ int main(int argc, char *argv[])

  	nftnl_expr_set_str(ex, NFTNL_EXPR_MT_NAME, "Tests");
  	nftnl_expr_set_u32(ex, NFTNL_EXPR_MT_REV, 0x12345678);
-	nftnl_expr_set(ex, NFTNL_EXPR_MT_INFO, strdup(data), sizeof(data));
+	nftnl_expr_set(ex, NFTNL_EXPR_MT_INFO, strndup(data, sizeof(data)), sizeof(data));
  	nftnl_rule_add_expr(a, ex);

  	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
diff --git a/tests/nft-expr_target-test.c b/tests/nft-expr_target-test.c
index ba56b27..a135b9c 100644
--- a/tests/nft-expr_target-test.c
+++ b/tests/nft-expr_target-test.c
@@ -71,7 +71,7 @@ int main(int argc, char *argv[])

  	nftnl_expr_set(ex, NFTNL_EXPR_TG_NAME, "test", strlen("test"));
  	nftnl_expr_set_u32(ex, NFTNL_EXPR_TG_REV, 0x56781234);
-	nftnl_expr_set(ex, NFTNL_EXPR_TG_INFO, strdup(data), sizeof(data));
+	nftnl_expr_set(ex, NFTNL_EXPR_TG_INFO, strndup(data, sizeof(data)), sizeof(data));
  	nftnl_rule_add_expr(a, ex);

  	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
-- 
2.29.2

