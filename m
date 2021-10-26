Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4767DC433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Oct 2021 19:56:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D62760F9B
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Oct 2021 19:56:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239059AbhJZT6h (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Oct 2021 15:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239026AbhJZT6b (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Oct 2021 15:58:31 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F6ACC061745
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Oct 2021 12:56:07 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id w193so258688oie.1
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Oct 2021 12:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=aebUN+L7yTqDFm44GRKjCBuLtZS4LpqCT6Ivl5Nvg2g=;
        b=r6+kGtCzbe1Ys/V0MP4SFe1NtVos7e15Z9/zCwUpIL4Fg8/0VNTf9E6j9bbuHneOfF
         H+YVYIEuXoViq7Fh2J6VJF9W9l0gGU4KVOP6kcuOSzZntNWtZQV+I85wDSOwdbzg/LKv
         mgdmhgesy44oWBRx5/B7t8Eaer+sz7TgqsH6M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=aebUN+L7yTqDFm44GRKjCBuLtZS4LpqCT6Ivl5Nvg2g=;
        b=ZDqpuAJpMUGv9XPrE5fzFMuI4ueHv4E+bf3FHwu8QwDT12IGNE55GUUZI4076dm2uK
         7MKVnGXT97ZOhIzrSubKNVbicDT4WWcwYD2HKjyFJh7wCKZW+yCIUXnFGu2DHRroNhem
         8vlh5H233we+1tfH/XbBTQ0CM5wxGCL1mIiydacQQP4ZFmOOt4RtDb+1ph8508zowkrg
         OBAgmudcplC5PjCmZjBWm9ZhVNs+dPjBNduY6qS45HF6iIFkJEmHUEpeOgJxM8/Ojcd9
         HgvT6EbdF7a4JSeK4mCT6KQlAmZWRpcjCx2Mbu2/l0Wuhk6jwFtFF+VNS1TQVpA7rd7P
         XNlA==
X-Gm-Message-State: AOAM5300zWVM5ABKPg2/I3WIVxJebCthoGITTLXjNH8WfDgrgeArjuXX
        yLCjHeHuUjE7EapPut8qdUak+yL6akh4pA==
X-Google-Smtp-Source: ABdhPJw+tt+puKtIYRGm70MizcpFjkemCuukw4BvQL2PB3Ta44BlCWpmoZLzUFmYAbGiVwyFfOLi+A==
X-Received: by 2002:aca:4283:: with SMTP id p125mr593212oia.81.1635278166509;
        Tue, 26 Oct 2021 12:56:06 -0700 (PDT)
Received: from [192.168.1.230] (cpe-68-203-7-69.austin.res.rr.com. [68.203.7.69])
        by smtp.gmail.com with ESMTPSA id c17sm5180649ots.35.2021.10.26.12.56.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Oct 2021 12:56:05 -0700 (PDT)
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org
From:   Chris Arges <carges@cloudflare.com>
Subject: [PATCH nft] cache: ensure evaluate_cache_list flags are set correctly
Message-ID: <4ffb3529-5f80-608b-497f-b0cb82a2dd3d@cloudflare.com>
Date:   Tue, 26 Oct 2021 14:56:04 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This change ensures that when listing rulesets with the terse flag that the
terse flag is maintained.

Fixes: 6bcd0d57 ("cache: unset NFT_CACHE_SETELEM with --terse listing")
Signed-off-by: Chris Arges <carges@cloudflare.com>
---
  src/cache.c | 1 +
  1 file changed, 1 insertion(+)

diff --git a/src/cache.c b/src/cache.c
index c602f93a..bc90233f 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -164,6 +164,7 @@ static unsigned int evaluate_cache_list(struct nft_ctx *nft, struct cmd *cmd,
  			flags |= (NFT_CACHE_FULL & ~NFT_CACHE_SETELEM) | NFT_CACHE_REFRESH;
  		else
  			flags |= NFT_CACHE_FULL | NFT_CACHE_REFRESH;
+		break;
  	default:
  		flags |= NFT_CACHE_FULL | NFT_CACHE_REFRESH;
  		break;
-- 
2.25.1

