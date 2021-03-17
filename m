Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8BC0C433DB
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Mar 2021 12:43:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B13564F26
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Mar 2021 12:43:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbhCQMm4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Mar 2021 08:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbhCQMmv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Mar 2021 08:42:51 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F2BDC06174A
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Mar 2021 05:42:51 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id lr13so2347999ejb.8
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Mar 2021 05:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JACiD2znjPkMuaJe8csoZJNOuBc4Lj5Sv6XiuQrVzuE=;
        b=elW73irbJEbXRK8+V9cfj8NqY1fWeCCNmP88Mr3Pjcdy6e0IBlxfQEIjryjjhT8qmw
         RfPsKgwV2JJd+BrhLlqSnfeDvHnvksXw8DzCQPjd0Yruh4HZ8zAEOnfMUHVDgAYmM8TC
         l18SBolO0mHUmbR8wrr9Cy228sYnx1OiJFxEARNVvLDUQTLqAGAcXje9OOzBWLXEGIXa
         OqqJj3QgntOueUI5LdWXsos1A31527q5YgxTlpS8kr7JOEa8CXhxOT3396bTntNGoXWq
         1shgKqiQKkgHG1FY+Mt4cC5gmw1SDev3CnL7Il8xoLgf8CnG81yvBYsVf+88kqPfvb9Q
         RS+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JACiD2znjPkMuaJe8csoZJNOuBc4Lj5Sv6XiuQrVzuE=;
        b=PMmW2QMimZUpyH5G9bGwSFFKw6nc0vtShCk7xzihmWYd+NuxHQWk3fMngkDT3PL3tl
         djWuG2VpLgnSMp1PdESvNU73X4Cg+umW1ka+niSD+yT7f8niRs1AMsjzXdNMMtJ4DKII
         0d6SCc23N82UWlsD4DZ1SNZMv1y3s1UvsnU/0tu+rC1ebwrU0NvYC9Bt9CeV34HSYBa3
         ztr+MBzkRiPbHlC2NaW8bHToVM5yIG7bHCEp4kyEs2awPrW9F0g/2t7+swA7avhbCHYe
         IwV8XL2q6UiRfK0mzWLrsS+AE3mljgMKlfEsjbZMjwtJ3QZBiPrxVTM78zMQcOpVCuLF
         axgw==
X-Gm-Message-State: AOAM531V6VqW3OiZjtdsv8G5Du+fmRiwb1qleSqJzOLToekLeW7tIb/T
        fdndwiWO5lrVj9Fzy8yj/8sWGrBl4uaVv23T6tQB9UFu2BN88h6EXbSj2sLBTagbvmVQ7X0gmWh
        OGoM7z/fN5HjjRp+NgS2YgEuBbTq3X3D1ZH+1pUENgSOCa9DArFFP0AUqaB3awikZMlpn1b7QNl
        cuzz2pLuLA53xZSg==
X-Google-Smtp-Source: ABdhPJyhZ41+HU3WjipDFehPan1Mofh/uts55WAMv6hqHQNXKYrXUMHXOQ7oc2zcDGIqKoJrMe2arA==
X-Received: by 2002:a17:906:86c1:: with SMTP id j1mr36223981ejy.373.1615984969385;
        Wed, 17 Mar 2021 05:42:49 -0700 (PDT)
Received: from madeliefje.horms.nl ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id r17sm12599760edm.89.2021.03.17.05.42.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 05:42:48 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     netfilter-devel@vger.kernel.org
Cc:     oss-drivers@netronome.com,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH nf] netfilter: flowtable: Make sure GC works periodically in idle system
Date:   Wed, 17 Mar 2021 13:42:24 +0100
Message-Id: <20210317124224.16665-1-simon.horman@netronome.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

Currently flowtable's GC work is initialized as deferrable, which
means GC cannot work on time when system is idle. So the hardware
offloaded flow may be deleted for timeout, since its used time is
not timely updated.

Resolve it by initializing the GC work as delayed work instead of
deferrable.

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
---
 net/netfilter/nf_flow_table_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 5fa657b8e03d..c77ba8690ed8 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -506,7 +506,7 @@ int nf_flow_table_init(struct nf_flowtable *flowtable)
 {
 	int err;
 
-	INIT_DEFERRABLE_WORK(&flowtable->gc_work, nf_flow_offload_work_gc);
+	INIT_DELAYED_WORK(&flowtable->gc_work, nf_flow_offload_work_gc);
 	flow_block_init(&flowtable->flow_block);
 	init_rwsem(&flowtable->flow_block_lock);
 
-- 
2.20.1

