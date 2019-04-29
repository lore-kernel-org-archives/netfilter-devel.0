Return-Path: <SRS0=bgPs=S7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A088BC43219
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Apr 2019 16:55:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70B182087B
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Apr 2019 16:55:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UqSu/yyM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728719AbfD2Qzl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 29 Apr 2019 12:55:41 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41956 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728520AbfD2Qzk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 Apr 2019 12:55:40 -0400
Received: by mail-pl1-f194.google.com with SMTP id d9so5347140pls.8
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Apr 2019 09:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=g1NV987nIasJH0jxNYsARIKFuKgn+cGF7pdxklw19YI=;
        b=UqSu/yyMa8vUSQZWpRZm8aDIJHMnGoSCty59bRxuWtUjcGc31FKaiBh4FH3/aRU3xk
         yGPZTddbdi7QSt8SnWawwppiL7Qpo4j234s97HvHZCVjN6u1tO+j4fOGLvWk47SQ1ItS
         kf3NAjpbP9CDNgcJrM14f9uM1Hs5lEniO87Yl1x3DwNiO3JL/N4cP3fRmPr4CJQZsh9F
         iU18rAIqYeTQoaVx/8ioU68eitlfcpCPVwFREEiAaixaYKojZtpYDEM3RBwdc/pdw2WZ
         u5LnQnLEHfnhxk4+ySHZI3w0QzTHYLvEtIi8eZkwceHPsEmg5phoD61vGYI668+eNBXv
         edWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=g1NV987nIasJH0jxNYsARIKFuKgn+cGF7pdxklw19YI=;
        b=Emp3GToH1YW2AOfYgO4C5rHv+qZ2GraMFib0QiZaD4xo2g4GnJ9+ueAd+965wscAMy
         Ml3Y6N4aG+Sgb4HJf3yKOWLffnCEOyx+SD8KXftFYd4BV6DvC2dkLLMI3mB8XN6ZznXZ
         DKCI2RLrEFHMKunhJhutA59d6fT6O7D2PR9C9Es1z+ZbVYPGYmdGV51gRt74NQTLvzXX
         x7ZsdFqJf5VkMgCg4TjCV1/vWRyoG6c0Dc9LEZLmZSpJ8fu+HND5G8cYjWeh70lDHcqF
         ObyAEspk/YLUZjqvvLC9a7NEysQXmlpBPuOYCMcEEBK+eoXbXTZRy3plRLUQymLueFbe
         JI5g==
X-Gm-Message-State: APjAAAX0Y0oYZz/EmHiKpm4azAivCCZn8IDSKk5ePpGvr9n1FIfGwRrq
        wQ+HXFVHrv+2xeQhkH6QTwU=
X-Google-Smtp-Source: APXvYqwrS9Pm9ZXVkr4XKWnfN6kSh+DBwD3sVm9o/HR82VCThlbfOiJbyFO2HFpW2QBFd7xkCK2oLw==
X-Received: by 2002:a17:902:b70c:: with SMTP id d12mr55477167pls.178.1556556939996;
        Mon, 29 Apr 2019 09:55:39 -0700 (PDT)
Received: from ap-To-be-filled-by-O-E-M.8.8.8.8 ([14.33.120.60])
        by smtp.gmail.com with ESMTPSA id h19sm55858816pfd.130.2019.04.29.09.55.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2019 09:55:37 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     pablo@netfilter.org, netfilter-devel@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH nf v2 1/3] netfilter: nf_flow_table: fix netdev refcnt leak
Date:   Tue, 30 Apr 2019 01:55:29 +0900
Message-Id: <20190429165529.1325-1-ap420073@gmail.com>
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

