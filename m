Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD25AC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Nov 2021 11:08:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A482E61BA1
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Nov 2021 11:08:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343538AbhKRLK7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Nov 2021 06:10:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235730AbhKRLK5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Nov 2021 06:10:57 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC85C061570
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Nov 2021 03:07:57 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id n26so5624877pff.3
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Nov 2021 03:07:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eWNmEjzOtW/1cKyh7uWAZJwbIkS1Gril5+6Jkk5q5Mc=;
        b=er4CU/LQsdD3ak/tEcRGxQ0BaT4l5Wx3FFOw3xSYE5vDI5uRRevdRseYGG3/h9ll4F
         /q9Rh9rdNv6sWHJkXuEvjnrjVSzPOUCPRuHWUEGSfGXkRBGMnIlQgt1X3ZhN6/+qrqCd
         iUgoWdC3Uxnsz3MPcSgj6oNQ9GZN2Pl89WFzu+QnaiMxs9z9XmITu/8FXAhhbCTwg1cK
         SiMO17NWycb/AoSclIM6Tt/g7Gf7C29xPqAL4Q9mghRQUJLM9D0FvlUkFi+NI380wyax
         vlRzR1DVHWK5v2WxNndk1AeR49BxhCXRMPQdw0u3AejKaPfhWuzpTgyPqS51XI8j1D3m
         JKCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=eWNmEjzOtW/1cKyh7uWAZJwbIkS1Gril5+6Jkk5q5Mc=;
        b=WD6+lMhY4/y6mVkEsEwqEetmLS+lguSzxbO/Hlw9VD+g7DfvNmJ6n0r0vJBXB1lATZ
         q0Ro6fke7hA4rFzJp73mcpjV0YvLHykYJkUu9x970NmbpQF4NHo2zwoSzbRXuKkG8N5a
         1PxYUgXKOt0LlQRfQM+A/EPIVLJrvLZbBO/uw+cRxWLSh8N7Cr65JCbnPz8+WbZggn1I
         z+XLQfb+Edbx1Ntv44+vsD6OiDjBbShWbizmDLVVFD9U7uvi41KL2NH3HVzJjFQRfk7x
         g1JMBCcFbTwlbHqiBB0dwbdpjeiuzWRJlgVeGG0BL0IadgM+JBLmdFhrXu5JybGbsWiy
         dWVw==
X-Gm-Message-State: AOAM5336kVJ6WYbA8kT13eH/7f/lcDffiF6V15Z5r8HIsKmncnowv/X4
        AZukwkaj8k5/4OwtDD0tgr+3m8SM+2FojQ==
X-Google-Smtp-Source: ABdhPJxQshIjV5jsmJcu3HBq+MrscJWWA9BrJ1n8krQ9+yyvjOTIiS4iC1arJOuNZo1urPG1CriWEw==
X-Received: by 2002:aa7:8204:0:b0:494:68ea:ea89 with SMTP id k4-20020aa78204000000b0049468eaea89mr55676849pfi.74.1637233677170;
        Thu, 18 Nov 2021 03:07:57 -0800 (PST)
Received: from faith.kottiga.ml ([240f:82:1adf:1:cee1:d5ff:fe3f:5153])
        by smtp.gmail.com with ESMTPSA id s7sm3185501pfu.139.2021.11.18.03.07.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 03:07:56 -0800 (PST)
Sender: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
From:   Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
To:     netfilter-devel@vger.kernel.org
Cc:     Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
Subject: [PATCHv2 ulogd 1/2] NFLOG: add NFULNL_CFG_F_CONNTRACK flag
Date:   Thu, 18 Nov 2021 20:07:24 +0900
Message-Id: <20211118110723.18855-1-chamas@h4.dion.ne.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <YX1Bs7C5KIBvw6QC@azazel.net>
References: <YX1Bs7C5KIBvw6QC@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

acquiring conntrack information by specifying "attack_conntrack=1"

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 input/packet/ulogd_inppkt_NFLOG.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/input/packet/ulogd_inppkt_NFLOG.c b/input/packet/ulogd_inppkt_NFLOG.c
index c314433..449c0c6 100644
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
+	if (attach_conntrack_ce(upi->config_kset).u.value != 0)
+		flags |= NFULNL_CFG_F_CONNTRACK;
 	if (flags) {
 		if (nflog_set_flags(ui->nful_gh, flags) < 0)
 			ulogd_log(ULOGD_ERROR, "unable to set flags 0x%x\n",
-- 
2.30.2

