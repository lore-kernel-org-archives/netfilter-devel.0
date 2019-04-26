Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20E10C43219
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 16:52:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA263206E0
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 16:52:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BoTUe07l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbfDZQwu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Apr 2019 12:52:50 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41419 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfDZQwu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Apr 2019 12:52:50 -0400
Received: by mail-pf1-f194.google.com with SMTP id 188so2000646pfd.8
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 09:52:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=g1NV987nIasJH0jxNYsARIKFuKgn+cGF7pdxklw19YI=;
        b=BoTUe07lYgf+OVj8GllqYPSHMPT711rV4FybjawERBJolzAB5I/xmtt1O73QklSORH
         wWz09VkZe1e3Ouj+AW3wjyuTEiPyJRiJCZIQi5tU0EzHryEq123tfJnACpHUl8iYGq9a
         VKO+YNDotHMXl3TNSuabWO7C0lU8UzJPNe1VBxbuUVcAp+GcKiJzciK+1zfu5rH81LWD
         /vVvxFSwmHor/ELMeOYzFJnU0RaZLlmf0F+RKYGvDFG6ucfP8z3aGwbR5tgBrd0DO77A
         9xqjg13t9MZ6yHFjUtIzHdrC0cCzpjdkjuKI92llp0bA6VEe9I1tiv9ueJ0MS5FgIPcx
         Lcvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=g1NV987nIasJH0jxNYsARIKFuKgn+cGF7pdxklw19YI=;
        b=sCwLy1c6OG+/fLTyFIs/iwdSGw3ML7Rg1GEAmiAVAF9VXV72bZIyEjdb5lfpHhSHmH
         SOnuWrkMr4vrhIxciqpyTEWL1HXdWHWeMAks3L63iWlCrKu+8q9HPXZJm0xUrJ/n/uF0
         3jtUO2A+SCRfwiR8CtAKAZWcFbCLLal5GojEc1l5Mzwi+g0b4tK5iZ5HlQBy3dfOnoY5
         3RK977SYVWjoAOzvW+hMnIdK6kPS+Na7jf9JVOwkmbGV3hWELpQJu1++II0uk2Xq9BHl
         8pA1CeZt3Exds/6y5W+WBVkxRwSwOrlElUGRQ/ddi5SeDZsDhRTOWTW1aUg7Bd8JrFZ5
         gvSw==
X-Gm-Message-State: APjAAAXKOPrt2SEb4yYxNJ7xGGATxNxTGDyJ4qW/1tXFdfULitItRdKt
        VyFbOlp9+exs5lTjX5dGg+M=
X-Google-Smtp-Source: APXvYqxS7B+uR0MkbaV+8QtA6l0jKqcchpqxbxjbbpVtkmYy+pYCbvUf9jtQBqiCTHI5It0WiLA+bg==
X-Received: by 2002:a62:61c2:: with SMTP id v185mr47967821pfb.117.1556297569366;
        Fri, 26 Apr 2019 09:52:49 -0700 (PDT)
Received: from ap-To-be-filled-by-O-E-M.8.8.8.8 ([14.33.120.60])
        by smtp.gmail.com with ESMTPSA id j19sm38360463pfr.155.2019.04.26.09.52.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Apr 2019 09:52:48 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     pablo@netfilter.org, netfilter-devel@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH nf 1/4] netfilter: nf_flow_table: fix netdev refcnt leak
Date:   Sat, 27 Apr 2019 01:52:42 +0900
Message-Id: <20190426165242.2993-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

flow_offload_alloc() calls nf_route() to get a dst_entry.
Internally, nf_route() calls ip_route_output_key() that allocates
a dst_entry and holds it.
So, a dst_entry should be released by dst_release() if nf_route() is
successful.

Because of that problem, netns exit routine can not be finished and
below message will be printed.
[  257.490952] unregister_netdevice: waiting for lo to become free. Usage count = 1

Fixes: ac2a66665e23 ("netfilter: add generic flow table infrastructure")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/netfilter/nft_flow_offload.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 6e6b9adf7d38..ff50bc1b144f 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -113,6 +113,7 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	if (ret < 0)
 		goto err_flow_add;
 
+	dst_release(route.tuple[!dir].dst);
 	return;
 
 err_flow_add:
-- 
2.17.1

