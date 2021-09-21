Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89907C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Sep 2021 08:53:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C53F611BD
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Sep 2021 08:53:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231322AbhIUIyt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Sep 2021 04:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbhIUIys (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Sep 2021 04:54:48 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D11B7C061574
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Sep 2021 01:53:20 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id k24so20065478pgh.8
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Sep 2021 01:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dwo5PEnU4JlFpljJHDcyhdOZLOp2J/JzvzeA3bngvdE=;
        b=fNiLASssS734LTmdL8Q1Y4UrTm3MWyfbcaCLTiPr+3VT9FA1gjOL7nRz1yhptEjPBV
         aOertVCe3hPVgDXbp4wKo70UZUGwRbi6LJ3j/oQ1VKRlo2cd/TYC6tlaAylH1ZPO9VXS
         LKguszCShwVg3GM4uaNQgRy77zjOYLmFwUFLQ3evcU6On9qV3SFmAulkSV8SkjeJi4i6
         fj9FEuHG26K5LTH9llKfmm7POtHmkVPTA8NN1q/0xVSQp5/JeiIOXVF7+JzyP7mTeMuu
         bZzxTIp/rhK7IHWqi8rlkupW/EHclvCkmhILhQquQZRBIX8aXEVbfz+bth4/ocL90qTo
         nOBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=dwo5PEnU4JlFpljJHDcyhdOZLOp2J/JzvzeA3bngvdE=;
        b=4rnJcun1VGjzQdUeKSC6OSCVGicW6w2W7JCRLxxg1DV/pOXnN56Rd/kB3uCRzXjOHe
         9hDvkfJOqhyCZGqIoQZSpjLZTt7rsFtXy6/DVHLD19UXo+vLWtlJlS9FfUdAhsWWN4RY
         VPqvLEJW3AUO4jGE4f8aOtee5er8sSnO7+rkoq0WByyCMvkLRkRiBynimGw6GbZJx6jV
         8LWu9ZsD4NR6Hf/gadC12WBccmZ0CWtXmDRfE9aOjyWSJ/Mry+3j8aYS2TLr8ryOw9Io
         lCD9rTCeSJRQ/4yanavgZvZ8UlnoKxX3SUi6i2lWMpNE/eB8JVJXWuMgVRthGsdWgu3i
         /cMw==
X-Gm-Message-State: AOAM533s4DzmuZpWi2PO40yEgs7PeAloG5W/s7uUTQq0aMKasfITiXsc
        Yb5Z+z5aopuBnoSnEKJiGgX2az6uxm4=
X-Google-Smtp-Source: ABdhPJyikJGZDMsMLnAnDCIjExZ2zWIabHlaMWeZqC9mIETE1mog/XbEiMaFodKEiHzvfFyoiMq47w==
X-Received: by 2002:a62:2507:0:b0:447:a583:5a88 with SMTP id l7-20020a622507000000b00447a5835a88mr11893903pfl.43.1632214400356;
        Tue, 21 Sep 2021 01:53:20 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id w18sm4612202pff.39.2021.09.21.01.53.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 01:53:19 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_log 0/2] utils: nfulnl_test: Test nflog_get_packet_hw
Date:   Tue, 21 Sep 2021 18:53:13 +1000
Message-Id: <20210921085315.4340-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

This patchset extends utils/nfulnl_test.c to fully exercise
nflog_get_packet_hw(). I made these changes while researching how the doxygen
for nflog_get_packet_hw should read.

I was rather surprised to find the hw_addrlen field in struct
nfulnl_msg_packet_hw is in Network Byte Order, seeing as how it doesn't come off
the wire.

Is this a bug? - it's been that way for at least 5 years (Linux 4.4.14).

I'll document on the basis this is correct behaviour for now.

Cheers ... Duncan.

 --------------
Sample output:

> 17:30:51# /home/dunc/tests/netfilter/nfulnl_test/nfulnl_test
> unbinding existing nf_log handler for AF_INET (if any)
> binding nfnetlink_log to AF_INET
> binding this socket to group 0
> binding this socket to group 100
> setting copy_packet mode
> registering callback for group 0
> going into main loop
> pkt received (len=184)
> hw_addrlen = 6 (after htons)
> HW addr: 00:00:00:00:00:00
> hw_protocol=0x86dd hook=1 mark=0 indev=1 prefix="Hi there Tiger" payload_len=52
> pkt received (len=136)
> No struct nfulnl_msg_packet_hw returned
> hw_protocol=0x86dd hook=3 mark=0 outdev=2 prefix="What's new Pussycat?" payload_len=52
> pkt received (len=196)
> hw_addrlen = 6 (after htons)
> HW addr: 18:60:24:bb:02:d6
> hw_protocol=0x86dd hook=1 mark=0 indev=2 prefix="Hello World" payload_len=52
> ^C
 "Hi there Tiger"       - locally generated UDP6 for interface lo
 "What's new Pussycat?" - locally generated UDP6 for interface eth1
 "Hello World"          - remotely generated UDP6 on interface eth1

Duncan Roe (2):
  utils: nfulnl_test: Agree with man pages
  utils: nfulnl_test: Add rather extensive test of nflog_get_packet_hw()

 utils/nfulnl_test.c | 39 ++++++++++++++++++++++++++++++++-------
 1 file changed, 32 insertions(+), 7 deletions(-)

-- 
2.17.5

