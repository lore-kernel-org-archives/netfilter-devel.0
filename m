Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A24FEB64DD
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Jul 2023 14:52:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbjGCOwZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 Jul 2023 10:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbjGCOwY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Jul 2023 10:52:24 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21B71E67
        for <netfilter-devel@vger.kernel.org>; Mon,  3 Jul 2023 07:52:23 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-3fba8e2aa52so54714515e9.1
        for <netfilter-devel@vger.kernel.org>; Mon, 03 Jul 2023 07:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1688395941; x=1690987941;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+3KjuLBngLO3rai8mrqNkWZ2OBnCS0ojb/WfZfP0ytU=;
        b=KFYcQJIC/LHmqIQeVankvlb89fFhXYJ2u4CRhT6/pS3M2Mop+/IKcNS6tZ4P3Wel4B
         4812aItVGnJv3Opnl116QiQO7pXEjK6Fe0MXtMVzVAx03vxCOot9tHZcEF778K3ijkGZ
         8ehBVmANtCmTN66OCjq2uFuheE7ql4BEsAXiI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688395941; x=1690987941;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+3KjuLBngLO3rai8mrqNkWZ2OBnCS0ojb/WfZfP0ytU=;
        b=NmFkcK0Y04jljZb8cY5OKFdMkcRT5JGChWb4cDuFKHM5s5f2JyAWfyih20Vehj+LOo
         GGJ2eAdXZFEN3cKJbWs2Ha7K9tZ/LJr+tpPbEZVqpItWr5qYIId7ni/KZ+TbutLt06cr
         T1nZpEA4BdcTzwDqlPIsoztAoTA9d7HkxzZt83NU5xzoeybklfhipe9nlUq2tgObYzFB
         voUY/YP5Vok2ilpAMV1z1x3Ij3H2taNTcu+VYjJmk4nw7m/HZDkdbyQsRjiFIUO8ZO5S
         v6+yS6IYxg4A9CZ3IS5JqrnmaTQk7HPGZFNmYyU/nsMwxZmTSVsiDw3cukA12vEDOX7k
         c6lA==
X-Gm-Message-State: AC+VfDzteVT+A5QOgsZ95bYf2nJ3PSgSz39JjZQa0h+BcVsaWWJYaXtF
        /riIknmFMmmd8lS9TrMqXY0fx89O6x7z21ztDbs=
X-Google-Smtp-Source: ACHHUZ7JLYiih/sZAgY31lyo8PL1r1xW+5cJuN3mzYzCpWVCujuece0APXkMinyxrAGdwGlWBqHPNw==
X-Received: by 2002:a7b:c38f:0:b0:3fb:a46c:7eac with SMTP id s15-20020a7bc38f000000b003fba46c7eacmr9214337wmj.7.1688395940886;
        Mon, 03 Jul 2023 07:52:20 -0700 (PDT)
Received: from revest.zrh.corp.google.com ([2a00:79e0:9d:6:34e3:ca8b:5d5c:2c66])
        by smtp.gmail.com with ESMTPSA id 12-20020a05600c028c00b003fbaade072dsm16878177wmk.23.2023.07.03.07.52.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jul 2023 07:52:20 -0700 (PDT)
From:   Florent Revest <revest@chromium.org>
To:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, kpsingh@kernel.org, stable@vger.kernel.org,
        Florent Revest <revest@chromium.org>
Subject: [PATCH nf v2] netfilter: conntrack: Avoid nf_ct_helper_hash uses after free
Date:   Mon,  3 Jul 2023 16:52:16 +0200
Message-ID: <20230703145216.1096265-1-revest@chromium.org>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If nf_conntrack_init_start() fails (for example due to a
register_nf_conntrack_bpf() failure), the nf_conntrack_helper_fini()
clean-up path frees the nf_ct_helper_hash map.

When built with NF_CONNTRACK=y, further netfilter modules (e.g:
netfilter_conntrack_ftp) can still be loaded and call
nf_conntrack_helpers_register(), independently of whether nf_conntrack
initialized correctly. This accesses the nf_ct_helper_hash dangling
pointer and causes a uaf, possibly leading to random memory corruption.

This patch guards nf_conntrack_helper_register() from accessing a freed
or uninitialized nf_ct_helper_hash pointer and fixes possible
uses-after-free when loading a conntrack module.

Cc: stable@vger.kernel.org
Fixes: 12f7a505331e ("netfilter: add user-space connection tracking helper infrastructure")
Signed-off-by: Florent Revest <revest@chromium.org>
---
 net/netfilter/nf_conntrack_helper.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 0c4db2f2ac43..f22691f83853 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -360,6 +360,9 @@ int nf_conntrack_helper_register(struct nf_conntrack_helper *me)
 	BUG_ON(me->expect_class_max >= NF_CT_MAX_EXPECT_CLASSES);
 	BUG_ON(strlen(me->name) > NF_CT_HELPER_NAME_LEN - 1);
 
+	if (!nf_ct_helper_hash)
+		return -ENOENT;
+
 	if (me->expect_policy->max_expected > NF_CT_EXPECT_MAX_CNT)
 		return -EINVAL;
 
@@ -515,4 +518,5 @@ int nf_conntrack_helper_init(void)
 void nf_conntrack_helper_fini(void)
 {
 	kvfree(nf_ct_helper_hash);
+	nf_ct_helper_hash = NULL;
 }
-- 
2.41.0.255.g8b1d071c50-goog

