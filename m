Return-Path: <SRS0=suW2=DF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E886C2D0A8
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Sep 2020 07:18:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31946207F7
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Sep 2020 07:18:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nThYQSip"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgI1HSw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Sep 2020 03:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbgI1HSv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Sep 2020 03:18:51 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7EF3C0613CE
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Sep 2020 00:18:51 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id e5so186807ilr.8
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Sep 2020 00:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=hBCwY12fbhQ97Sow1AZcoeytvc3Oc3qVzcmSFC74EPY=;
        b=nThYQSipcLIF13AsbDQVy9Q78Eagy5mNWzxuoXmzr3AiQvwoL3AUkCtThHym/+SuP4
         9q8aG0kDdFN6uYUCCz+7Ws2TOmvu26VdYfR/EGwJINO/OsObNYCeTvvCS/By6FnP2msJ
         UjSXp1hxLdwTP1g377IiZxTATjtk61JkRA3ar2BDSG2mH7BitqE7tFUxkm5Bbnb+UvHo
         ffdsUYsuH0edH73s1pOZ7xrmK6GpBTBgb9nsjSS3waDi4JG6MK/CNihQVQL9GU7hUaXb
         6QpS/FmXRGmNdgGc/c5hZMGR4xQZ1pnuY4oemTityiwX602pwhNfF1wCkHMcRlhKjWra
         tzyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=hBCwY12fbhQ97Sow1AZcoeytvc3Oc3qVzcmSFC74EPY=;
        b=ShnduKwWbdHC7SXYqAWtA4k+rGM4MBY1f/+/05GygaNXPviegnJcXOpTm9Hkm8m17r
         b6bxEbFsTJkXVykqEYxiWqBVG65ADCWJqnBFJ+TxDCBAwt41F4zb24WvZ5J8jSjoCo49
         JgixkoIiOVNfhABOH/NPY+qUyu/Nl1hxAbQ2Z0nLzMxr+flasPZ6cgO1pFGgem5AJ6hx
         D/upl67l8p+vLzZIOkY2j8fllJPxqez5vBmgBveAk+d8L5sFykhudckflz1ra4PgNo0M
         lPeMSlwSrlO+Neqc1Ya7xXbwSYDktIwyETjETTtEE21FR7My4Z5k68uEbKpgjBMd0UZ4
         sYRg==
X-Gm-Message-State: AOAM532+yy04gjj55HUUArpSWlPD0cLjOhXkL3C+h6c9GCvn2iaezB/j
        qxtbC2hyaeGdz7OHFns7qi+X966eF2MSsm+udifHPjbJA3eWSg==
X-Google-Smtp-Source: ABdhPJwSvjze9a2ZFYui8/Fcdu5lqcBs7yDo8KuLxqDBmscph4iRkttxd9wHQB4NkKdVzGTqm02lv3IIX6rBUyxTLvs=
X-Received: by 2002:a92:ce05:: with SMTP id b5mr55227ilo.239.1601277530711;
 Mon, 28 Sep 2020 00:18:50 -0700 (PDT)
MIME-Version: 1.0
From:   Gopal Yadav <gopunop@gmail.com>
Date:   Mon, 28 Sep 2020 12:48:39 +0530
Message-ID: <CAAUOv8iOGYqi9YvvszTJ40b8bqAWT3dzhDbjdHHJTPQtnaseSw@mail.gmail.com>
Subject: [nftables] counter not working on kernel 5.6
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Running the below commands:

nft add table inet dev
nft add set inet dev ports_udp { type inet_service\; size 65536\;
flags dynamic, timeout\; timeout 30d\; }
nft add element inet dev ports_udp { 53 timeout 30d counter }
nft list ruleset

Output:
table inet dev {
set ports_udp {
type inet_service
size 65536
flags dynamic,timeout
timeout 30d
elements = { 53 expires 29d23h59m56s184ms }
}
}

Expected Output:
table inet dev {
set ports_udp {
type inet_service
size 65536
flags dynamic,timeout
timeout 30d
elements = { 53 expires 29d23h59m56s184ms counter packets 0 bytes 0 }
}
}

Am I doing something wrong?
