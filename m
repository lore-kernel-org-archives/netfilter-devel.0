Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3808BC433F5
	for <netfilter-devel@archiver.kernel.org>; Sun, 27 Mar 2022 05:59:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232607AbiC0GBN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 27 Mar 2022 02:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235376AbiC0GBK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 27 Mar 2022 02:01:10 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20E47BF70
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Mar 2022 22:59:31 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id w8so12120350pll.10
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Mar 2022 22:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8zsvcAzBQEFNpvsQwZcj14p9GgrCyMDBFBFv+w0DmHw=;
        b=FcmLmI3Tnq2BQJiwVqd5XgPlv4Pj7TTLwvMwxHrbqhPpyl3om+MEjsg45ehkSORFkX
         WYvByhCA6NnOz8qd7MQKTosyEm1KbKcudfEj8ERyCwxs6jbE6tN8b5SIxRB39VEjiXsB
         OcXCQDLo7wJh01gW7DfcyA3Dfg8bs5nxE7NWXpUgl8oVEZKBGWcrLi/1iHwrielfvyAU
         QokbytVm/b6pdIxigayimh/4Ck0YZfOQfI/23bME4nA0Xe+Rw0gkokxG3Z8Agyof4AnZ
         2fwfU/bUbEVPU+6SDbb87lYHqzSAi989hj/bc03b0NrY8TbMyOok/bmhz1XcG3ILRf9l
         CL4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=8zsvcAzBQEFNpvsQwZcj14p9GgrCyMDBFBFv+w0DmHw=;
        b=thgqKNzjQH+qMJ3smmGBnRBMf+8iMOA51yHrd9Be7ahwUjJVErYy6CzRqTnVW7bdMN
         JHyq2DzlpP5hSCwID0KKtZ7LM5zuOiXpIzh/8JPgDAzUwMRBBsQ2MQ2D9/aoYTMwYAIZ
         IMQXXg4l32CRtUD4U+caBPMthkoVT+iOlf9eZntGBfltmWo0k7FJGeaHQqDKQkFS0FFE
         z796/De2h+dIzfLKc2Rk6RzObl/i0AWd8uGZfQhW+hyVX7OwUCR3R7Rx4dnj5hj6yGQm
         FFi9IYpFDRWHU0qvqMERTidv4kR37ETopiEZ/0b7J2O3YUbq40T7PXNOFEi00DXId4vW
         TCpg==
X-Gm-Message-State: AOAM531whAGUEl70/cXNkkVx62/Qmt8KQatz53jKCsO2VgWg0pWowyBW
        BNGmIq6OvycKSnDGKtS3vdszsaAUT2w=
X-Google-Smtp-Source: ABdhPJyyE4c+b0dvCD2fiQZYQAERDINP2BwBWOujyX3fxD1AWTRl49sTOoHYReoR9Ns4S6UxFaM6og==
X-Received: by 2002:a17:90a:a58e:b0:1bd:4752:90cf with SMTP id b14-20020a17090aa58e00b001bd475290cfmr22188216pjq.54.1648360770635;
        Sat, 26 Mar 2022 22:59:30 -0700 (PDT)
Received: from slk1.local.net (n110-23-108-30.sun3.vic.optusnet.com.au. [110.23.108.30])
        by smtp.gmail.com with ESMTPSA id p128-20020a625b86000000b004fa666a1327sm11381082pfb.102.2022.03.26.22.59.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Mar 2022 22:59:30 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue] examples: fix compiler warning
Date:   Sun, 27 Mar 2022 16:59:25 +1100
Message-Id: <20220327055925.9063-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

(introduced by c3bada27)

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 examples/nf-queue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/examples/nf-queue.c b/examples/nf-queue.c
index 6983418..4466ca8 100644
--- a/examples/nf-queue.c
+++ b/examples/nf-queue.c
@@ -89,7 +89,7 @@ static int queue_cb(const struct nlmsghdr *nlh, void *data)
 	if (attr[NFQA_HWADDR]) {
 		struct nfqnl_msg_packet_hw *hw = mnl_attr_get_payload(attr[NFQA_HWADDR]);
 		unsigned int hwlen = ntohs(hw->hw_addrlen);
-		const char *addr = hw->hw_addr;
+		const unsigned char *addr = hw->hw_addr;
 		unsigned int i;
 
 		printf(", hwaddr %02x", addr[0]);
-- 
2.17.5

