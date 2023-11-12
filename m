Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF3B7C4332F
	for <netfilter-devel@archiver.kernel.org>; Sun, 12 Nov 2023 22:12:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbjKLWMr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 12 Nov 2023 17:12:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbjKLWMq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 12 Nov 2023 17:12:46 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A538E2699
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Nov 2023 14:12:41 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1cc58219376so34119145ad.1
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Nov 2023 14:12:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699827161; x=1700431961; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=59pQCrmVbcYBZfr2SOg+vAxTkQ7cFQOlVugDKsMfTSI=;
        b=jiH6cf0bv/LoPBwxXD4kSys5YX5DZYUmOkrHQ5gQjxXhXFWfJkx7GVs+FHckfYx3+y
         F/c61j6Yv5R/fHLieNDfaxkC4xIwjGz1LAyYm0xMLNu0tke63FKOX5Vd7HyL4k5tmnmV
         IiiFgRX1TwCRGCS7iG82rf/sS3kz1A7V/NjFz93Yn0wI4eHPAbkWlCQVREZzTbSv+Eda
         Iqqu1rcN79TnXhJY5paCrzYd0kHX+JhjnCw+NT+FcQ1zUXUNe8OZAFzDoCI6LEYqSGxW
         ymL6H5fD8S91gMb7z9WKbX9YHhPdx50XR3e2hNu7N+GvvMMdJu7bopATF+BO5vMqpA5E
         +h1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699827161; x=1700431961;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=59pQCrmVbcYBZfr2SOg+vAxTkQ7cFQOlVugDKsMfTSI=;
        b=ciP92COq0PCVCF0SZKK6J2L7T6VBywm+En3WyOk8sz448Fj/qeVkRloMAS7KSod69+
         ucutz3FnG0YTuPPyOXNOUkMeVSGuD98ZuBBt9zLZMnCeru2IdBmExZDtvknBqGbGFzOO
         H2Ee1Ifg4YLJ6f3Op24wsin29UZNd2pjhyUuswsVOuC5n+rAOAy3Ku3Rlnd4MyHtwVh0
         0eCym2Z9YiQpOi3HBAPN0lISTplk437R68z3Xtuengn2W7TZ4gJBwLpwkM6bP0/i/7Md
         iIuWlCETjEs/+HJgas352bXLmLNG3N8NNt29fC0h06Gw2s9O9oJzloe8glScTFaEHxCi
         mOcw==
X-Gm-Message-State: AOJu0YzAt1KbQUpJXXPxUsW7iAzN6Z+Hj2gNZgE5NR1YhKUJ+gWOZYiz
        DlkSILIHfOvXVbpdSgZa+vhslb86qVw=
X-Google-Smtp-Source: AGHT+IF6YhfSjbW9r6aRWB9xOICOsgdXfxhj6iPg7IGnQgkD1Fxu+dliU3ZHSN2qS/Rj0xM4trjhMw==
X-Received: by 2002:a17:903:248:b0:1cc:78a5:50a2 with SMTP id j8-20020a170903024800b001cc78a550a2mr7311894plh.39.1699827161043;
        Sun, 12 Nov 2023 14:12:41 -0800 (PST)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id q18-20020a170902dad200b001cc530c495asm2943128plx.113.2023.11.12.14.12.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Nov 2023 14:12:40 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 0/1] libnfnetlink dependency elimination
Date:   Mon, 13 Nov 2023 09:12:34 +1100
Message-Id: <20231112221235.4086-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

We need this patch for mnl cut-over of nfnl API.
It's just an added function, should be fine to apply straight away(?)

Cheers ... Duncan.

Duncan Roe (1):
  src: Add nfq_nlmsg_put2() - header flags include NLM_F_ACK

 .../libnetfilter_queue/libnetfilter_queue.h   |  1 +
 src/nlmsg.c                                   | 72 ++++++++++++++++---
 2 files changed, 65 insertions(+), 8 deletions(-)

-- 
2.35.8

