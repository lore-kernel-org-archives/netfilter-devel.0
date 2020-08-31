Return-Path: <SRS0=WPBU=CJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6522C433E2
	for <netfilter-devel@archiver.kernel.org>; Mon, 31 Aug 2020 17:03:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94D2B206EB
	for <netfilter-devel@archiver.kernel.org>; Mon, 31 Aug 2020 17:03:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KLV+ySSz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728548AbgHaRDL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 31 Aug 2020 13:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728211AbgHaRDK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Aug 2020 13:03:10 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5D22C061573
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Aug 2020 10:03:10 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id s92so805661ybi.2
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Aug 2020 10:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=R1FHPQyRLzDGu5mnlpbw1u4cdJD49fOdIJlDZK2XX+8=;
        b=KLV+ySSzEh4Wzakjw9zTyuO9HsMFedW3g+vlyBvo2zQeZfZMu4bE5F/HBu4kM386BU
         iHsolBsNOZ+WGaQEPJOtBvmtYQ1oecOCdEXNL9W4JB6NSIbbJsr3jdoWa547IPTomqJI
         GGtCHRzxtwLR5rtvGp1cKZq7gVYBci7sLWuxLKFj0SJQ9ZficIy4HrBgRb390NO096Th
         xvhQ9sknvAeQphMSPvFzuUIeImHZ1IRZPUORuXqgP95FIbC/GOWdF7e48f/hF2q4JSxP
         aSxUT1RvtjG5CpY98dkZ6ZgUinxuYE9SQYGNIL9LNhWgYV6+KjPVPeGBgJXzUeF3YL17
         H62g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=R1FHPQyRLzDGu5mnlpbw1u4cdJD49fOdIJlDZK2XX+8=;
        b=kKxXWLbs1ThdQoP4FAO6fcbfUtf80PBXA9hzF+rdoxHb8ihQItHixC5U+Llt0Pizla
         xmSJU+QrBrRUHobwZoPjUS/8uG9x579y+qECIQldbCCBG4wcoYgtX1e3fCSdUN610XNZ
         KnbVtJ0cO7jqc+FcIjFenXvETvBaRUg0C2ImuLRmWhQUEApuWyg5Cup5o9x/wKyJxo1y
         QZWnEBd0S7FNDF+52RRVAHPAf/8rwm+sH8ZNeEPFc8HvfGf+F6wYI7MmShtWHkuI/NZo
         VqUW0d5Y+4M/K49uFuA/Y3jUshOMtTUJDt3DNbKhhC/1VPs2NoJKwIKljxwNXWoiWHZC
         qFQQ==
X-Gm-Message-State: AOAM532TG9yIylV2Rs8tmBSkwXAU1/rSgQP+HiLERdqG//UpeuFR6pkO
        swT1o6hep6P83sUDBYHymw0FR15O5A7Skk/InUPZVFgteaE=
X-Google-Smtp-Source: ABdhPJy9vxg4XPRY8w0R3cFe1BSP5jqHoYjr2chojCH0Op+DAOgpbDdvHtiJVm6vmj/qPkTEWXN7zDyx3Q5k1cCthW4=
X-Received: by 2002:a25:ad4e:: with SMTP id l14mr3534650ybe.322.1598893389209;
 Mon, 31 Aug 2020 10:03:09 -0700 (PDT)
MIME-Version: 1.0
From:   JM <jeevhi@gmail.com>
Date:   Mon, 31 Aug 2020 22:32:58 +0530
Message-ID: <CALiWujLPe4WZyUjgGzS6BTzWdTh4EDWZ7gYDUDOZYBSN4AYKqw@mail.gmail.com>
Subject: inserting rule at the top of the chain using libnftnl
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

I use libnftnl to manage our firewall and adding rules to the chain. I
am using libnftnl-1.1.7/examples/nft-rule-add.c as the reference.

I have no issues appending a rule or inserting AFTER a certain rule
using NFTNL_RULE_POSITION or NFTNL_RULE_POSITION.

However, I am struggling to insert a rule at the top of the chain. I
am unable to find a way to insert a rule BEFORE another rule or top of
the chain so that the rule is the first rule.

Can someone help, please

Jim
