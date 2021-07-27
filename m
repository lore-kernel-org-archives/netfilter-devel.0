Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D5AAC4338F
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Jul 2021 21:45:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D4A660F23
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Jul 2021 21:45:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232314AbhG0Vo7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Jul 2021 17:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232105AbhG0Vo7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Jul 2021 17:44:59 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16537C061765
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Jul 2021 14:44:59 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id b6so1955430pji.4
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Jul 2021 14:44:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RfgDHMUec9+wVkID26xSl8008ahCk/fggJ3JlLD9c5U=;
        b=EnA4iiMtW8N9C7txFmWDjJMK7zhwXlga6204mphuSmeaQuf9sQc3sxaZ7jvkLpvUYd
         7h2oCYmyfhNezELTugPUd7onfdU3cG77IY/xEWGKhh+sho32dwz5ryrlPFujSLO9X0hI
         OK7UOMafl5moF+os7BvRtPk4OcPDx9Hu+Gr/k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RfgDHMUec9+wVkID26xSl8008ahCk/fggJ3JlLD9c5U=;
        b=fJWT8qaoUrBt3LdXThWvdJMT6dLK0qGeTjDDrT6D+1xqIW16eFb3/uVmMUQ7aZzY4u
         YTYnzjUQsCeWo5ExmA8qvyWukkACXJkseVcnSAWIP+UUurx3NCzZKu9RUZRycQ5ILQ4K
         vzaXWrUcTLHBP99KTxb/c33aSFkmk+ERDLjR1yjZ4aDlSMWMz+lzfcu6Ktqmu+zt8FXz
         aG2fxHdIVBavR+0rSMm7H2FGu+95WFhIlzrJ+TgkHqq/0STiw0mvkrbOkoIlfSdjP7DX
         0ed/HiAygKIDbxVdDOURFP8hajfj9fcMN+ciclA66bS9A1eGrRP1S3be8g/yoWaPPL3g
         O3Dw==
X-Gm-Message-State: AOAM532/REmXSRCBLrawbWZ8zSqSHsPb1WVbZNqd4Prx1k0wsN7lf43m
        2bViSfbrXXYpWIOF4iWeMgH9bB90VZxgpKgaMlv7hQ==
X-Google-Smtp-Source: ABdhPJzrcjU3d2o77c4q3K9yi+NENzM3iqP9EUm7DQejc+zSk8XHK7bTkFanFiuLl6pmQ/cdhVvIcx0/mmrgNhYcMRM=
X-Received: by 2002:aa7:9dc8:0:b029:35f:7eca:72cf with SMTP id
 g8-20020aa79dc80000b029035f7eca72cfmr25066252pfq.77.1627422298562; Tue, 27
 Jul 2021 14:44:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210727190001.914-1-kbowman@cloudflare.com> <20210727195459.GA15181@salvia>
 <CAKxSbF0tjY7EV=OOyfND8CxSmusfghvURQYnBxMz=DoNtGrfSg@mail.gmail.com>
 <20210727211029.GA17432@salvia> <CAKxSbF1bMzTc8sTQLFZpeY5XsymL+njKaTJOCb93RT6aj2NPVw@mail.gmail.com>
 <20210727212730.GA20772@salvia>
In-Reply-To: <20210727212730.GA20772@salvia>
From:   Alex Forster <aforster@cloudflare.com>
Date:   Tue, 27 Jul 2021 16:44:42 -0500
Message-ID: <CAKxSbF3ZLjFo2TaWATCA8L-xQOEppUOhveybgtQrma=SjVoCeg@mail.gmail.com>
Subject: Re: [PATCH] netfilter: xt_NFLOG: allow 128 character log prefixes
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Kyle Bowman <kbowman@cloudflare.com>,
        kernel-team <kernel-team@cloudflare.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

> I'm not refering to nftables, I'm refering to iptables-nft.

Possibly I'm misunderstanding. Here's a realistic-ish example of a
rule we might install:

    iptables -A INPUT -d 11.22.33.44/32 -m bpf --bytecode "43,0 0 0
0,48 0 0 0,...sic..." -m statistic --mode random --probability 0.0001
-j NFLOG --nflog-prefix "drop 10000 c37904a83b344404
e4ec6050966d4d2f9952745de09d1308"

Is there a way to install such a rule with an nflog prefix that is >63 chars?
