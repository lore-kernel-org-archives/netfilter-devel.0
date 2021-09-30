Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D04A4C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Sep 2021 06:24:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B36496141B
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Sep 2021 06:24:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348260AbhI3GZv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Sep 2021 02:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348249AbhI3GZv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Sep 2021 02:25:51 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A0EEC06161C
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Sep 2021 23:24:09 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id m26so4735914qtn.1
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Sep 2021 23:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=qubercomm.com; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=JKcU4W3jMaQPAuEuFwaSR5sUdAVWcjNrOOli+XMrryw=;
        b=PfWqc1nCdNRW73KoQOjKqXno55KOGOwjvyGnimNCx4verJkIu0JJVFLYT1xCnBaaFD
         6dlr5keFUH3wkVCfuIEaj2xG80VaDeFVZ6NImDg5t7MmyEw+FUc1Nc7zk3m3cCTCak9P
         zl4ljBa4hsCVOJSW0QyJQk23fY4DNwi/38Rx8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=JKcU4W3jMaQPAuEuFwaSR5sUdAVWcjNrOOli+XMrryw=;
        b=oqtP/ZH846vAnD84g45AqvEARkjdqKK02f/lLpFXE6OHhx0bJcU5iwzOjMdTooCkIE
         GYgTxzOAmIosDLMvY6JtgKqsV46pawSwWvogT2B8HTxqx2scwnu/9aRRyfIGP75Ul/lV
         WOsINVyY/UAqiPk0bzMtW1c5wi4OhjMeTxn2FthKdVgCi5D0KJWdWhdnl4I2NwQXOJk9
         DMAa40CgmZ8bkYSen9h0ugnF0uKvmvQyM2j3znrMTZu3qiqX4zSr9WxOivsawjK4I8/v
         1Ha5vtS98TS1mr8G8Lqe9MO2zzXZF+2UkU7y7cSfGfkswBM6Bs07BaEjUHWBrhr5paVS
         Vxmw==
X-Gm-Message-State: AOAM533mKmUnWZeT5nD5IbO2FFyUgSupEdnN2dIiPL6NOVY2GjJkEyl1
        5fzfD7vg+SoGawXegQ/pPGmUfDrGYyZSYqOXkhnNodzo+wCY0xEE
X-Google-Smtp-Source: ABdhPJzYTW2bhZejzqrZYzbgZzFlCXzpAsNMkMJDrO/4NUl1Rpu66+XHo1JlrRiahfD3oXZoJqndMe+F9YSgLL4hT4M=
X-Received: by 2002:a05:622a:3cb:: with SMTP id k11mr4466477qtx.233.1632983047905;
 Wed, 29 Sep 2021 23:24:07 -0700 (PDT)
MIME-Version: 1.0
From:   Senthil Kumar Balasubramanian <senthilb@qubercomm.com>
Date:   Thu, 30 Sep 2021 11:53:32 +0530
Message-ID: <CA+6nuS7f=bLh56k463rJSPn7P3PvwW-kzAz2oYx2wiw24_9_Mw@mail.gmail.com>
Subject: ebtables behaving weirdly on MIPS platform
To:     netfilter-devel@vger.kernel.org
Cc:     pablo@netfilter.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

We are running OpenWRT/Tp-Link Archer A6 HW v2... (openwrt : 21.02
ebtables v2.0.10-4)

and when we run this ebtables with nflog extension as mentioned below

ebtables -I FORWARD -o eth1 -p ip  --ip-protocol udp --ip-source-port
68 --nflog-group 1  --nflog-prefix "ENTRY1" -j ACCEPT

, we are running into the following issues..

Unable to update the kernel. Two possible causes:
1. Multiple ebtables programs were executing simultaneously. The ebtables
   userspace tool doesn't by default support multiple ebtables programs running
   concurrently. The ebtables option --concurrent or a tool like flock can be
   used to support concurrent scripts that update the ebtables kernel tables.
2. The kernel doesn't support a certain ebtables extension, consider
   recompiling your kernel or insmod the extension.

We have confirmed the required kernel configs are enabled and ensured
the same with a ARM platform where the same command works..

However, dumping the data that goes to the kernel, we see a huge
difference between MIPS and ARM..

in ARM platform
 w_l->w:
  0000  6e 66 6c 6f 67 00 ff b6 00 00 00 00 00 00 00 00  nflog...........
  0010  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0020  50 00 00 00 00 00 00 00 01 00 01 00 00 00 00 00  P...............
  0030  45 4e 54 52 59 31 00 00 00 00 00 00 00 00 00 00  ENTRY1..........
  0040  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0050  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0060  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0070  00 00 00 00

in tplink a6 (MIPS platform)

 w_l->w:
  0000  6e 66 6c 6f 67 00 b2 e0 69 6d 69 74 20 65 78 63    nflog...imit exc
  0010  65 65 64 65 64 00 56 69 72 74 75 61 6c 20 74 69    eeded.Virtual ti
  0020  00 00 00 50 65 78 70 69 00 01 00 01 50 72 6f 66     ...Pexpi....Prof
  0030  45 4e 54 52 59 31 00 69 6d 65 72 20 65 78 70 69    ENTRY1.imer expi
  0040  72 65 64 00 57 69 6e 64 6f 77 20 63 68 61 6e 67     red.Window chang
  0050  65 64 00 49 2f 4f 20 70 6f 73 73 69 62 6c 65 00        ed.I/O possible.
  0060  50 6f 77 65 72 20 66 61 69 6c 75 72 65 00 42 61       Power failure.Ba
  0070  64 20 73 79
              d sy

Can you please let me know what's going wrong with this?

Thanks
Senthil
