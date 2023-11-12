Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7201DC4332F
	for <netfilter-devel@archiver.kernel.org>; Sun, 12 Nov 2023 22:53:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbjKLWyA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 12 Nov 2023 17:54:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbjKLWx7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 12 Nov 2023 17:53:59 -0500
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9619211D
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Nov 2023 14:53:55 -0800 (PST)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-1ea82246069so2298782fac.3
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Nov 2023 14:53:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699829635; x=1700434435; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=2cCTIG3b6ubCfQawwyBaMiOlz5CNPSsr0V0IlkJ3jwY=;
        b=kgrHKPvYkXXk4T1BPw+PrAYh9Y/IBwivxB0BOWGhZ7WeOGG65wzepuWvFo84qoy6ml
         A2v8z4Ih0oncUE8VnIZgnCp07DQigYvIjNO4fWFjqbyIWy72JbIg7yzRYARZjVT5WINJ
         CnwlMwtA17tgEXAog0gj8GikzzLPwRLCLjnSkNo8vWbpYnIZAbnj5lqWWv+WZmF3kahG
         OzTaD14WU3JoJzoKftlCPqBi5X65L4yuYV/5ERyGuqMDBABqzf9T1xc4KxEo9lqddbuC
         Fxvx7l9cvfGuWhBOZxi3vJ2ptOU2okEWJjui3IalVP0PgX40y65QK8EqPJUOnah8joBN
         Q6sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699829635; x=1700434435;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2cCTIG3b6ubCfQawwyBaMiOlz5CNPSsr0V0IlkJ3jwY=;
        b=OhZMNg+mMBBI2av+2gEX3N9JKdIlSDX+JNu71SplmL+40pVZKtiJhxqXiRIhRyaOol
         wdxmnrCCgr4MBC2xtcCQFXz1IwBQWq7bRgsyxlERIoy2rEE+sBRECHADE7Atmycj4jFC
         iysU+IxkNUbNpeHi3aTJkfNoNobHG3uvx9IJpyV1O3sunQW7q1ZTUBDGg7bjorAap+u8
         8UqTqn1+Q6M33Kxz+RHXHWuYvU1jx17dwwOKnEHCXiE0jIXlXcXWZve0BOIALbT7DHJD
         nWVRQE8BGmqaWQLf0z3TJAFfFF/kEoVlyZ1liUTREkA6s4Wlb48DdMBSDAVgHYysgO+Q
         BT1Q==
X-Gm-Message-State: AOJu0Yzk/EkUnxtn4UvaQpP8cdlKtC+dmvXGL357sHVw++rlQ82FlkEL
        8CcsAuQ+actFbiPca1IPgrxDiSb4yAE=
X-Google-Smtp-Source: AGHT+IGGCUpH7zTiAHx2vudku9YRroa6gJsPw6zN62iq7ZEFjCq8voqLwDUvsTmUikKmSVqFnZuWdg==
X-Received: by 2002:a05:6870:8e06:b0:1e9:b08d:69ef with SMTP id lw6-20020a0568708e0600b001e9b08d69efmr7997937oab.48.1699829635062;
        Sun, 12 Nov 2023 14:53:55 -0800 (PST)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id ij27-20020a170902ab5b00b001b8a3e2c241sm3077734plb.14.2023.11.12.14.53.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Nov 2023 14:53:54 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 0/1] libnfnetlink dependency elimination
Date:   Mon, 13 Nov 2023 09:53:49 +1100
Message-Id: <20231112225350.4134-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

Maybe park this one until mnl cut-over is complete(?)

Cheers ... Duncan.

Duncan Roe (1):
  Remove libnfnetlink from the build

 Make_global.am           | 2 +-
 configure.ac             | 1 -
 libnetfilter_queue.pc.in | 1 -
 src/Makefile.am          | 2 +-
 4 files changed, 2 insertions(+), 4 deletions(-)

-- 
2.35.8

