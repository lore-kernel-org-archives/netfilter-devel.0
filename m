Return-Path: <SRS0=q2Xo=RC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 348B7C43381
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Feb 2019 18:19:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0509D20C01
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Feb 2019 18:19:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kBY+67Rn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbfB0STY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Feb 2019 13:19:24 -0500
Received: from mail-qt1-f202.google.com ([209.85.160.202]:53375 "EHLO
        mail-qt1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730211AbfB0STR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Feb 2019 13:19:17 -0500
Received: by mail-qt1-f202.google.com with SMTP id k37so16133549qtb.20
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Feb 2019 10:19:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=UpQ34x9CJVo3jIMuwrBGFvwnwF44v09YiYrvYmOwAnw=;
        b=kBY+67RnConXudAKvBsaaC/cxQHODIak9C5jRm/kYX6Xs9VWyQuFJMpLGonDuRuCwc
         cUOqVFSUAaRS7sudGD6pNMX2GGjHvc+r7nevfstPhDUMNZUfMVlx7CpyljKMGiOamLxa
         hLnhNxcepKnr/T5zTYEiGor79r/0g4GnC6nD/Ke2Tt0Vj8JP6jTuCX3x3y6NV7tWhvTc
         6qxsEUyM9dvTmVv+0IMt4I9niLEgC/bWN3mqu8o9oudt3Uw3NZWKEceaDoGzNF4TPEU4
         scwRM2+CLZReB+pmDED7HA9dR3EnlTTpzYTxFbxryiHhrKFGquemMw9QtsyeaqlVYbr4
         MGVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=UpQ34x9CJVo3jIMuwrBGFvwnwF44v09YiYrvYmOwAnw=;
        b=UnRTdGeuKyg4ZiowTJeF2RXd2pEGha0yzX0DejyZFXkSYDNIJXNg4k/AkarSmCCgG7
         qs69ZMTWxO13SG+avQmetjgzFcMlXAt7LmIUjDLe3CmNVDhfOc1K4jrjtMHt2WHgT3gs
         IBqrVEBFqgXqRq9696KEEzT1U/dUiOGeQiwKSV0g4nkViKNe/fH0Hq+gRffAoIr/9f6d
         xnI4HAtTM2w1/D4uwmGYgDmhTHiadTn9wihxhBsUH6kjVoQdQW22noTIGP/BwbmgfGE6
         bn9iHnL6hHALzPWA1UOyziv8ZxmAAQnvV6lm9xEMcG/zu6z2OlGtg71HWGaCcYfUl6e6
         mFlA==
X-Gm-Message-State: APjAAAVLY7l1jXH4BFUtoW06V+iJAlF3Ismg/8iyfGqnP5yxLOzmv06j
        H+SDvSw2WxW9Q2xGPxCJ+j1YEs13ZI0Q0ySUqWQ=
X-Google-Smtp-Source: APXvYqyTEcfylfczLKKO+Uy3tBvxna+EpFnnsCLzBzUf1+5vsWgzdiYRmBZMAZARQaM4nKu2x2jqf/A/627mC/pZyrE=
X-Received: by 2002:a05:6214:1048:: with SMTP id l8mr1473264qvr.46.1551291556128;
 Wed, 27 Feb 2019 10:19:16 -0800 (PST)
Date:   Wed, 27 Feb 2019 10:19:10 -0800
Message-Id: <20190227181910.229008-1-samitolvanen@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.21.0.rc2.261.ga7da99ff1b-goog
Subject: [PATCH] netfilter: xt_IDLETIMER: fix sysfs callback function type
From:   Sami Tolvanen <samitolvanen@google.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use struct device_attribute instead of struct idletimer_tg_attr, and
the correct callback function type to avoid indirect call mismatches
with Control Flow Integrity checking.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 net/netfilter/xt_IDLETIMER.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/xt_IDLETIMER.c b/net/netfilter/xt_IDLETIMER.c
index eb4cbd244c3d..5f9b37e12801 100644
--- a/net/netfilter/xt_IDLETIMER.c
+++ b/net/netfilter/xt_IDLETIMER.c
@@ -41,19 +41,13 @@
 #include <linux/workqueue.h>
 #include <linux/sysfs.h>
 
-struct idletimer_tg_attr {
-	struct attribute attr;
-	ssize_t	(*show)(struct kobject *kobj,
-			struct attribute *attr, char *buf);
-};
-
 struct idletimer_tg {
 	struct list_head entry;
 	struct timer_list timer;
 	struct work_struct work;
 
 	struct kobject *kobj;
-	struct idletimer_tg_attr attr;
+	struct device_attribute attr;
 
 	unsigned int refcnt;
 };
@@ -76,15 +70,15 @@ struct idletimer_tg *__idletimer_tg_find_by_label(const char *label)
 	return NULL;
 }
 
-static ssize_t idletimer_tg_show(struct kobject *kobj, struct attribute *attr,
-				 char *buf)
+static ssize_t idletimer_tg_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
 {
 	struct idletimer_tg *timer;
 	unsigned long expires = 0;
 
 	mutex_lock(&list_mutex);
 
-	timer =	__idletimer_tg_find_by_label(attr->name);
+	timer =	__idletimer_tg_find_by_label(attr->attr.name);
 	if (timer)
 		expires = timer->timer.expires;
 
-- 
2.21.0.rc2.261.ga7da99ff1b-goog

