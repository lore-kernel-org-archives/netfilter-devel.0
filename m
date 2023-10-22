Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D070BCDB474
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Oct 2023 04:14:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbjJVEOL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 22 Oct 2023 00:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjJVEOK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 22 Oct 2023 00:14:10 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 927E4D9
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Oct 2023 21:14:07 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1ca3a54d2c4so18128995ad.3
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Oct 2023 21:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697948046; x=1698552846; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=Qzs3zSCP6Q8WymMAhDMAsQ8WFezq9ahef9nbFIMdhfc=;
        b=Ib99VEJKYb12wHVTKSr4a7DkX/nmKIwH5lwu+bXZdBwxl6u+hrDDgboSQ3JMmo8DUp
         pT+KAacJuArfQv/AjFRri2CDwBZBeeT1d6cZm4JcNY7J9fjzsEDwVsBJ2Tb3ZBWTqLXy
         1Ndl02RCNJezuiHVjF28JpVI7VlzPn9bVz4ZqVQSNgiApHK0l1+Wo2Gbs4ntv5GrNWhO
         UxepNb6uIot3hZx48iijTMnfGMK1weEBbtQiRV0Gw6sY4w+7NSXsj68rdF/r5qjT3Xhc
         Bq4kgxp8UulBeIV2TFpSROE6asYauZoy08PIazpvJxgjiee5IYLMfg+TnmCfB82VNKS5
         oEOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697948046; x=1698552846;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qzs3zSCP6Q8WymMAhDMAsQ8WFezq9ahef9nbFIMdhfc=;
        b=Z2FhLYAfeSaxd/MqOsvgrG983Y5/VDjTI5zWqE9slvgAAdBO5Hb8ROHEGcAOMJBBa1
         QHkbgZfyazmm5FZfIDuPgQWs/qMyPOJP4MOpSDE9FWoFwXxemd544ZSJ1atuuK4U2elB
         PAAxLxDeTS0jOSmk7qkqkN7nWsEYkgImQ4TdP6+iKO88nsOOYLHE8/rCJpS2X1glAHPy
         cXmFHe5WmsHhmRo8dDgBrGoIQdZGGXOwntboKZWHqg8iAmOki9u27uRl5/Xxu/6B84ho
         zxMKtl6iotoZJjcE4mYKLRONasEeNwnm9PyqMvAkq3nEEQNYzHXXT4YLNc2kxl2UGPdO
         mJCQ==
X-Gm-Message-State: AOJu0YxcagPzBNaqZ6U1qbC+umoZxGVKqNKkrCMqsSnZSEO/dZJHiqCT
        Yf+OYHgfFgg7cw0pIsIh55U=
X-Google-Smtp-Source: AGHT+IH7F6xwrXVaoX4kLDCJR6K1u783tUo0P35UENF+S33d2aXeR2tbW9hH9yvGGhbg7Qe09XGOYg==
X-Received: by 2002:a17:902:eb51:b0:1c7:37e2:13fb with SMTP id i17-20020a170902eb5100b001c737e213fbmr6158314pli.55.1697948046387;
        Sat, 21 Oct 2023 21:14:06 -0700 (PDT)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id u12-20020a17090282cc00b001c322a41188sm3822134plz.117.2023.10.21.21.14.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Oct 2023 21:14:05 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v2 0/1] New example program nfq6
Date:   Sun, 22 Oct 2023 15:14:00 +1100
Message-Id: <20231022041401.17782-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

I've been using nfq6 as a patch testbed for some time.

Now that nfq6 has matured to only use functions from the code base,
I offer it as a second example for libnetfilter_queue.

I did fix some errors from checkpatch.
I myself disagree with those that remain.
If you think some of them warrant fixing, I'll do it of course.

Cheers ... Duncan.

Duncan Roe (1):
  examples: add an example which uses more functions

 .gitignore           |   1 +
 examples/Makefile.am |   6 +-
 examples/nfq6.c      | 692 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 698 insertions(+), 1 deletion(-)
 create mode 100644 examples/nfq6.c

-- 
2.35.8

