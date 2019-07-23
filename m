Return-Path: <SRS0=NVo7=VU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 266F2C76186
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jul 2019 17:36:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E61F4218B0
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jul 2019 17:36:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=untangle.com header.i=@untangle.com header.b="fVe5U0ho"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390800AbfGWRg4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Jul 2019 13:36:56 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:45690 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388454AbfGWRg4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Jul 2019 13:36:56 -0400
Received: by mail-io1-f67.google.com with SMTP id g20so83585743ioc.12
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jul 2019 10:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=untangle.com; s=google;
        h=from:to:subject:date:message-id;
        bh=Vm3tp+4RZl6OrTlImKeU02AIIHcufkyXr8xz2M3+Hy4=;
        b=fVe5U0hoR1J8+wd/riHYCoI0IHk3j05T4p/rjY2Ca++hPZ7KWTyArhVlqM2dop8eW/
         sAfR/DZ9g/qR12jUJ4B9HubsQtelI64tjIQEElruXCRpQs4+drJR8OeAKWuy0v21PpxJ
         TeTQUIp6r76Me/Yul5o7aV5yaCBjmDgc8V/34=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=Vm3tp+4RZl6OrTlImKeU02AIIHcufkyXr8xz2M3+Hy4=;
        b=IOEdUebl5q9yzg5GlSD8/ryTgkTF5qdsPxd1Jt/RSZ7jQaWvsCwhxagt+7D0soLL+1
         dpXfHUsyWwZtn3g6mDD9elnawmXJJp63Mau1PO6uQGSlc32mNdfAYY02kdeo6H19FQ1g
         /iOFZRPGzB8Qh52GhrjMoJFXgksywb1TM7PtS7pWHAhsb2cRZHwDE+xmq5O0M8rk/57A
         7k7Jbq4lRhmP5Ju82xB1vUa1yLMI5RQosaGNY0G3LHKKFM/LbJ5rMLqmLGhBdIva1O5A
         /VcBWbvgLqQI4LgLrNe3kY3ozKdWyMJkTR4DaVjv4mz8gcmnMeP21tBKkoJn9/oUrPMy
         LH0A==
X-Gm-Message-State: APjAAAXwoxhZ2v/QkZ3MfJo6mzsqERxirmrCP1zmXkNfU8mxnAd6hioe
        uisV6U41/yQwr8mBvxp2x7AqE8soERUtgQ==
X-Google-Smtp-Source: APXvYqx6MNUX0E/GZFSMe6wMkAr3/yMTt1NkuiIb4TTZNgxjN9+85OxG76EDdPUheAIjM1Iyhnf4KQ==
X-Received: by 2002:a02:5ec9:: with SMTP id h192mr78110717jab.25.1563903415281;
        Tue, 23 Jul 2019 10:36:55 -0700 (PDT)
Received: from pinebook.zebraskunk.int (cpe-74-137-94-90.kya.res.rr.com. [74.137.94.90])
        by smtp.gmail.com with ESMTPSA id c14sm34103325ioa.22.2019.07.23.10.36.54
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 10:36:54 -0700 (PDT)
From:   Brett Mastbergen <bmastbergen@untangle.com>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] src: Sync comments with current expr definition
Date:   Tue, 23 Jul 2019 13:36:49 -0400
Message-Id: <20190723173649.3855-1-bmastbergen@untangle.com>
X-Mailer: git-send-email 2.17.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

ops has been removed, and etype has been added

Signed-off-by: Brett Mastbergen <bmastbergen@untangle.com>
---
 include/expression.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 4de53682..717b6755 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -208,9 +208,9 @@ enum expr_flags {
  * @flags:	mask of enum expr_flags
  * @dtype:	data type of expression
  * @byteorder:	byteorder of expression
- * @len:	length of expression
- * @ops:	expression ops
+ * @etype:	expression type
  * @op:		operation for unary, binary and relational expressions
+ * @len:	length of expression
  * @union:	type specific data
  */
 struct expr {
-- 
2.17.1

