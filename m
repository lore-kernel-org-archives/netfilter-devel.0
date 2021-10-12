Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB286C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Oct 2021 11:16:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C991C6101D
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Oct 2021 11:16:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232475AbhJLLSV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Oct 2021 07:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236096AbhJLLSU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Oct 2021 07:18:20 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80954C06161C
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Oct 2021 04:16:19 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id h125so7343036pfe.0
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Oct 2021 04:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dZLfvNVAOyT37qXjb2skGu7ySJs2BBypzuqsPlVlSrI=;
        b=LzG3sSgmfqAYIgyoPGeL+5nJryh6bXA1QTWVvDJC1lCX3Fjw8f3/kByFB6K8mLErzI
         JlhgsSmArffOEKMCqBHTfz4/VuD/Pa1SEp4KCI61TvcV6k8FbTG27g/yzpW4ZTWyhEz5
         BSuTJNRsjdUL1esCficc+MddYRvIZQUmgkyRZDH9k8jKLgwndtn7u5NOOMdxIRoQWV9K
         t3iU5iMzGq4Uz6UOqtSS7sIXuV/i59NUadi5b8mQYmR94qRAZZtL79WOtIm9h7/WopeR
         CI/FkzlPomonRpZ6mRa97nwHHN6sN5KXwO14F11wTZXtKptXXv8wGUNcYd++qo3J74gY
         kCTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=dZLfvNVAOyT37qXjb2skGu7ySJs2BBypzuqsPlVlSrI=;
        b=HRFKcN78SZt3dXBYiwBQCmHyQy7yGIampgKFfa7VJ9oF7xNeO4423xE6cxVo+TrtSb
         aoQm2/8T5Z2mwa9eUpglXC2pzFibF4XM0LaknjJESPWlkP04qrHHf6fo4ESjFsjGGaH1
         tOBboq2xNdBow4bWDHu2gRdXBTgFLTlyF6TqjPHkD1QSHEogH7RM0mFIBN92jFZtBqYp
         k9iqlO317ws/SzV5UPKFuJde11sPzd07xXu6DjyFtRjp5gUpw6mhz2+vmcflDWe8wjfa
         sLyTx4MXH8nr4u1pvpap+xC9Nmxi1szUaXyP+Y6KjKnfl06UWB96Mvthz2gkvzmgcxng
         nUCg==
X-Gm-Message-State: AOAM530TWgCV6UlJwgHGM7fgrpha5Ug+qhdiDsYoJ6PcZOFqW4XjkBzj
        rjIPkzBI4DdWFFNI+CjSfKk7hhTS9gU=
X-Google-Smtp-Source: ABdhPJyjwoyAGNKGGkKD22S/HIF/Qg2GYZQOVHRLqfvViUCrOg5c8MOrEEuIb2+4xRei5z1awGZVNA==
X-Received: by 2002:a63:ff0a:: with SMTP id k10mr22221309pgi.363.1634037379016;
        Tue, 12 Oct 2021 04:16:19 -0700 (PDT)
Received: from faith.kottiga.ml ([240f:82:1adf:1:cee1:d5ff:fe3f:5153])
        by smtp.gmail.com with ESMTPSA id u25sm10418775pfh.132.2021.10.12.04.16.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 04:16:18 -0700 (PDT)
Sender: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
From:   Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
To:     netfilter-devel@vger.kernel.org
Cc:     Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
Subject: [PATCH ulogd 1/2] NFLOG: add NFULNL_CFG_F_CONNTRACK flag
Date:   Tue, 12 Oct 2021 20:15:30 +0900
Message-Id: <20211012111529.81354-1-chamas@h4.dion.ne.jp>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

acquiring conntrack information by specifying 'attack_conntrack=1'

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 input/packet/ulogd_inppkt_NFLOG.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/input/packet/ulogd_inppkt_NFLOG.c b/input/packet/ulogd_inppkt_NFLOG.c
index c314433..ea6fb0e 100644
--- a/input/packet/ulogd_inppkt_NFLOG.c
+++ b/input/packet/ulogd_inppkt_NFLOG.c
@@ -33,7 +33,7 @@ struct nflog_input {
 /* configuration entries */
 
 static struct config_keyset libulog_kset = {
-	.num_ces = 11,
+	.num_ces = 12,
 	.ces = {
 		{
 			.key 	 = "bufsize",
@@ -102,6 +102,12 @@ static struct config_keyset libulog_kset = {
 			.options = CONFIG_OPT_NONE,
 			.u.value = 0,
 		},
+		{
+			.key     = "attach_conntrack",
+			.type    = CONFIG_TYPE_INT,
+			.options = CONFIG_OPT_NONE,
+			.u.value = 0,
+		},
 	}
 };
 
@@ -116,6 +122,7 @@ static struct config_keyset libulog_kset = {
 #define nlsockbufmaxsize_ce(x) (x->ces[8])
 #define nlthreshold_ce(x) (x->ces[9])
 #define nltimeout_ce(x) (x->ces[10])
+#define attach_conntrack_ce(x) (x->ces[11])
 
 enum nflog_keys {
 	NFLOG_KEY_RAW_MAC = 0,
@@ -597,6 +604,8 @@ static int start(struct ulogd_pluginstance *upi)
 		flags = NFULNL_CFG_F_SEQ;
 	if (seq_global_ce(upi->config_kset).u.value != 0)
 		flags |= NFULNL_CFG_F_SEQ_GLOBAL;
+        if (attach_conntrack_ce(upi->config_kset).u.value != 0)
+                flags |= NFULNL_CFG_F_CONNTRACK;
 	if (flags) {
 		if (nflog_set_flags(ui->nful_gh, flags) < 0)
 			ulogd_log(ULOGD_ERROR, "unable to set flags 0x%x\n",
-- 
2.30.2

