Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53C6CC433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Sep 2021 22:10:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35AED600AA
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Sep 2021 22:10:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240936AbhIQWLl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Sep 2021 18:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344034AbhIQWLh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Sep 2021 18:11:37 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A685C061757
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Sep 2021 15:10:15 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id v19so7871626pjh.2
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Sep 2021 15:10:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tlpOR2Q6qKqqH14Veg4f6UN1Pw9wWw5MCHzJToFK/78=;
        b=UQyg8tGxvAiLTPOIwcV+K8OYoDHA89d2Ma3TuxXpjhF0RZcc1tKTOQANKdJEwPCYpD
         VPY8zoBLuZkRjfan7n7u7Ac7k6ggN4KMUOcJ3DXvarFZHz3L7V2/381Am0Y4HLZ3wKYk
         XAge2yNjOhCcChdPgJOap3cpxVxnNF/vWu8p1+dr86X3lUJS2DTlV7fLcpBaKkjnkjHS
         WnBMA2O8o9b4qcCQJo74Ma1uUw6OXElTTdcFKPFgIe58/XBZZiOq0m1Zn582es2n11t2
         RaOA/0NPA6LScW8eF39ZYq+hVfe5YEj6QVk0P2RHpI5f2Aaf/w9kcw0ecNNycUeOPYxO
         nEjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=tlpOR2Q6qKqqH14Veg4f6UN1Pw9wWw5MCHzJToFK/78=;
        b=AqAXxtElKlh1S2l0SPdPREZ8RHOuP9N7vTMpUnnfhfz1D4OFbA7Gk8oc0dF0EkJi6o
         9UeezTlzeHVWH6DlTRneYYT7+yp7JG++eeVuFCte+1jpZjn+gc2Q08cnUdGKRqk2Gb4L
         J/SKDAclm6N7d3K6j9uBM9Fz1Vc+rzBe1rfcq/0AA0Nfge15p6ji/GAP+jAvcmTxpKaK
         18zXZUZ/uLB9NjuaERvd1wVRVEbjzAWaCMw5K0LcMXwstfFx9OUifdr+1m7tGrjMZK3Y
         RAHLXW5Fq72WJDzwX3GRqBx/qpO4gUB7f8IpBRI8oI4p5JpPkG4sBXCKieo/ZeItx4ER
         eMLQ==
X-Gm-Message-State: AOAM530W+qtdEp31hFC3FZQgowgbGQ6+8+lnpxz2PTfXouRnZXbXzCaq
        BU1asel+hZgY6WLfXHRDHfHkzzcG6tQ=
X-Google-Smtp-Source: ABdhPJzncQBFAP5inb7iCe5k8zw1vuWZfPkX8qnKrQ6waL/37mgWLZYj7gLvqp/B0v1eHfSFVvnJuw==
X-Received: by 2002:a17:90b:17cb:: with SMTP id me11mr23690899pjb.109.1631916614709;
        Fri, 17 Sep 2021 15:10:14 -0700 (PDT)
Received: from faith.kottiga.ml ([240f:82:1adf:1:cee1:d5ff:fe3f:5153])
        by smtp.gmail.com with ESMTPSA id 19sm11687352pjd.42.2021.09.17.15.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 15:10:14 -0700 (PDT)
Sender: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
From:   Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
To:     netfilter-devel@vger.kernel.org
Cc:     Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
Subject: [PATCH ulogd] NFLOG: fix seq global flag setting
Date:   Sat, 18 Sep 2021 07:09:29 +0900
Message-Id: <20210917220928.37078-1-chamas@h4.dion.ne.jp>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 input/packet/ulogd_inppkt_NFLOG.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/input/packet/ulogd_inppkt_NFLOG.c b/input/packet/ulogd_inppkt_NFLOG.c
index a367959..c314433 100644
--- a/input/packet/ulogd_inppkt_NFLOG.c
+++ b/input/packet/ulogd_inppkt_NFLOG.c
@@ -595,7 +595,7 @@ static int start(struct ulogd_pluginstance *upi)
 	flags = 0;
 	if (seq_ce(upi->config_kset).u.value != 0)
 		flags = NFULNL_CFG_F_SEQ;
-	if (seq_ce(upi->config_kset).u.value != 0)
+	if (seq_global_ce(upi->config_kset).u.value != 0)
 		flags |= NFULNL_CFG_F_SEQ_GLOBAL;
 	if (flags) {
 		if (nflog_set_flags(ui->nful_gh, flags) < 0)
-- 
2.30.2

