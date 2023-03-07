Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62F3BC678D5
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Mar 2023 05:23:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbjCGFXH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Mar 2023 00:23:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbjCGFXF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Mar 2023 00:23:05 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C3F16ACF
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Mar 2023 21:23:00 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id w5-20020a253005000000b00aedd4305ff2so12402190ybw.13
        for <netfilter-devel@vger.kernel.org>; Mon, 06 Mar 2023 21:23:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678166579;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5c2qBcJ04eV7YVtQK+t3Nhusvz3yml0SyLi5SuWLvlg=;
        b=FZ2J4HbnA/QOgWewiOjHj1n8me9whff+Kbrxh3GLKvbvOYK4gj8heFoAWHda8twlbY
         Zc3tUDOfFKAnN/NlQlBnpe6lRnM7zYnXBo3Smy/LZ5IFBR6cBe9YDBo7z3ViwtCsXn0a
         E2ReUmuTYj9oG1VXLKLRSbybo5aP59UGUghu2ZrRPKLUMpuIxbv5LcFLEwCOFZSwLZqp
         VUIHCYl3K8KX28SDrfk2BvQUWSS/Dz1GGSvZLLjOans+RyWmu3Dut+iqLTy3l4GGLdVK
         BTsJ7ERONlhnOyZEFmT3f/gkLtXTdnRXHMzF8ilTeCSKK0v4llL0LNjes7hZS7aYMZjh
         tQzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678166579;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5c2qBcJ04eV7YVtQK+t3Nhusvz3yml0SyLi5SuWLvlg=;
        b=wBxjbshGF9LHfv0qRc0Skmboxczf/8SOd8dvT5N9IraJpb2wC8TeE6q+A8JnBFAPex
         VwWTuodW6hjgGjWrsIZw4EDimWIzAyftxpcpXs26DqmL1/9hLTMYgoagnyVcnsUmwuhM
         0Zc403Monf3XJDbQnt/SNVYpLP0Y3Uf5K4zyWmaV3nYySEvDsVt707K/1KOfbSPnIWvR
         9JzOUCmer/KBwemWrOxonubyklkk+OVMiKPKKX05cKjMVv56Xj4tauObeWkV4dQ7cV3o
         ODOEfqXqXFbA4Md/NVsGh6PDA2pNRZJjgJk2bVmkOitfKq/zFtGI6TU9ODcL32Smz5HD
         6Z3g==
X-Gm-Message-State: AO0yUKVZ4g8pg38iaOtJoqjkk8+V4LiJB0jNv/qVuV6iUipBj8i7en66
        QJsWVcbXIr7OZrGkv7UBphemCbqkmHS1yQ==
X-Google-Smtp-Source: AK7set8goaU2HYVUe77wQjsPKU46e24ElljGtVwOGVjpWSQm0DcIrUnIUZZBgAT5tz/3np9XVOC2zR8K8nL5/Q==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:4c3:b0:a6a:3356:6561 with SMTP
 id v3-20020a05690204c300b00a6a33566561mr6270870ybs.1.1678166579357; Mon, 06
 Mar 2023 21:22:59 -0800 (PST)
Date:   Tue,  7 Mar 2023 05:22:54 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230307052254.198305-1-edumazet@google.com>
Subject: [PATCH net] netfilter: conntrack:
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Customers using GKE 1.25 and 1.26 are facing conntrack issues
root caused to commit c9c3b6811f74 ("netfilter: conntrack: make
max chain length random").

Even if we assume Uniform Hashing, a bucket often reachs 8 chained
items while the load factor of the hash table is smaller than 0.5

With a limit of 16, we reach load factors of 3.
With a limit of 32, we reach load factors of 11.
With a limit of 40, we reach load factors of 15.
With a limit of 50, we reach load factors of 24.

This patch changes MIN_CHAINLEN to 50, to minimize risks.

Ideally, we could in the future add a cushion based on expected
load factor (2 * nf_conntrack_max / nf_conntrack_buckets),
because some setups might expect unusual values.

Fixes: c9c3b6811f74 ("netfilter: conntrack: make max chain length random")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/netfilter/nf_conntrack_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 7250082e7de56c77298b0d3b62c4f0dff95b77cc..c6a6a6099b4e2200951367ccd90c12c0ac800a6a 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -96,8 +96,8 @@ static DEFINE_MUTEX(nf_conntrack_mutex);
 #define GC_SCAN_MAX_DURATION	msecs_to_jiffies(10)
 #define GC_SCAN_EXPIRED_MAX	(64000u / HZ)
 
-#define MIN_CHAINLEN	8u
-#define MAX_CHAINLEN	(32u - MIN_CHAINLEN)
+#define MIN_CHAINLEN	50u
+#define MAX_CHAINLEN	(80u - MIN_CHAINLEN)
 
 static struct conntrack_gc_work conntrack_gc_work;
 
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

