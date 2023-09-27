Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9AA8E7F150
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Sep 2023 02:52:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235498AbjI0Cwg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Sep 2023 22:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbjI0Cuf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Sep 2023 22:50:35 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16D347DB4
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Sep 2023 18:26:57 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1c60a514f3aso57847935ad.3
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Sep 2023 18:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695778016; x=1696382816; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=69dJPGgHfaS6qnakY5SGCPzF/PEninLXDe01S2qhYLE=;
        b=RFQxMJXek9qYPS8pRGfQuGSVMR42Vi2vutDmMqjN0ayjvPVAXe3jRtbnUIL6HbbfwC
         lBnjZDiaZUeNlsnCQiFlnd4epBcAU6p9aiYsHyLt5fykoaI4vQxJl83dHLPgnnJan9ZD
         mkhtJ1e8xZFQC31vAmzBbZQXWphhdrKNj+FsPep73RMYgTl0T2H6BHvP38jaAmoAQ7cM
         6CHPt5ltn6Msj1gttRSQadeNgrNEXmPdEeWEFtRs25XpXyOV68cyHt/eu2Pss6mUylc+
         1/mE2wCRGPAqe3o5xPx3Waa/c/l6DZraTZHqgxsszIeFKtPz0N+dq2gai5g6z5JdK/Y7
         GKDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695778016; x=1696382816;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=69dJPGgHfaS6qnakY5SGCPzF/PEninLXDe01S2qhYLE=;
        b=jdZPLQVXbgN1ouHq5+j4NQEms0SBNRbdIhbkgZrH7K5YoE9u+DDow+LjxFtH6zY8lB
         mvrWoAArHBKkaznDnDvjvwFV1m6XOy62GDAie8RyMg50Z9EymX6PHJtAHeUIEYNHdasj
         WW9YSPZ1TzPuTwFgALkMjH6a1JM4HyS70o3j0zT49RkStYmUP8pNw+mpKEB/Sl//pZC9
         a4lWNFpKTbBDz/P/MvCh4E8AH4h5LgYNzKSQg7/dtjVQbMtWSz2hRZZu1cJYSiZK0t9R
         qkRYP7eksw7CN8puPuKpoo/oC5AbApp6969i9C+rIO23nLwRED6oDNywQ569o7ZN7VZt
         U40g==
X-Gm-Message-State: AOJu0YwlDZYsuYolYQoop9xM2PDJqLsH1PgX0UyLjNw9bUFu5EGWkfKY
        OI76VoN6lMdklf3KgDIMzAtqljiWf8E=
X-Google-Smtp-Source: AGHT+IGgPLgf4gv/kwEF9sIIMh+loRwytPwrJewy9XvasWMS0WR6purSOsoUnCR5HuFnwovh+4iKHw==
X-Received: by 2002:a17:902:fb07:b0:1c6:294c:f89c with SMTP id le7-20020a170902fb0700b001c6294cf89cmr413800plb.63.1695778016549;
        Tue, 26 Sep 2023 18:26:56 -0700 (PDT)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id q14-20020a170902dace00b001b890009634sm11658432plx.139.2023.09.26.18.26.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Sep 2023 18:26:56 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue] Fix typo in examples/nf-queue.c from patch 9a8e4c3
Date:   Wed, 27 Sep 2023 11:26:51 +1000
Message-Id: <20230927012651.24721-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 examples/nf-queue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/examples/nf-queue.c b/examples/nf-queue.c
index baff5c2..1ae52e4 100644
--- a/examples/nf-queue.c
+++ b/examples/nf-queue.c
@@ -106,7 +106,7 @@ static int queue_cb(const struct nlmsghdr *nlh, void *data)
 	printf("packet received (id=%u hw=0x%04x hook=%u, payload len %u",
 		id, ntohs(ph->hw_protocol), ph->hook, plen);
 
-	/* Fetch ethernet destionation address. */
+	/* Fetch ethernet destination address. */
 	if (attr[NFQA_HWADDR]) {
 		struct nfqnl_msg_packet_hw *hw = mnl_attr_get_payload(attr[NFQA_HWADDR]);
 		unsigned int hwlen = ntohs(hw->hw_addrlen);
-- 
2.35.8

