Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E939C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Sep 2021 14:01:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B4AB61244
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Sep 2021 14:01:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237755AbhIPOCe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Sep 2021 10:02:34 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:48965 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238117AbhIPOCc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Sep 2021 10:02:32 -0400
Received: by mail-il1-f200.google.com with SMTP id n4-20020a056e021ba400b0022481cdc803so12475219ili.15
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Sep 2021 07:01:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Rg5swG7vfZFIYVXMyonVSaWtcmV6xu8pi1vuSVxxgRg=;
        b=OwEHWm59YXfHIedJ9+IqDEtp1wB5K6Zq2bH2p8OFHclEoSnZbAKqD93osq/sGW8IgR
         Cz4k1ENr6IH4CIv9PR9Lr0yhUezvtuNQH/AZoo1+jIR9DWZKOiBVeclnLZbAk2iIlWXr
         4oCfHAxaQx6TGUDEuKQ6uWjs2f4aP95pjl9uFnNBLUsTH1NYHTImKq1dZ3LnFbLP9ZQh
         ILWAOp4BRmCCvke5x5i3hL9f2ZwXfFgKPcIHpjRtk3MqPbzzyYKsv13AoshFFwEOCgHE
         hG3O8l9ezs2WF9UxSZXaRs7rc8MAPsEKnlNWJZQdD5hsHvUqqh9kSBffcQ/NMaDdHCRI
         eucw==
X-Gm-Message-State: AOAM530kBVmVq9XKiPv+bcARL9+GQwNVpz77lc+r0tFCR0ii1/vcpRQa
        wvK8YXEMZS/x7ELfM+/pPkKVegJCCsXUJdg5OWczNo7Iwx+G
X-Google-Smtp-Source: ABdhPJx1AQvYzhvk1chHxJ+OOacYbh2ToZzXsMDGRXSfvADJvc2UVKTiq8ZYqzGqE/bXmABIleNk1xHuK0ut39hBC0JzqvljvTE9
MIME-Version: 1.0
X-Received: by 2002:a92:cb87:: with SMTP id z7mr4244017ilo.315.1631800872036;
 Thu, 16 Sep 2021 07:01:12 -0700 (PDT)
Date:   Thu, 16 Sep 2021 07:01:12 -0700
In-Reply-To: <0ddad8d7-03c2-4432-64a4-b717bbc90fb4@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000526fb105cc1d3f5b@google.com>
Subject: Re: [syzbot] WARNING in __percpu_ref_exit (2)
From:   syzbot <syzbot+d6218cb2fae0b2411e9d@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, coreteam@netfilter.org,
        davem@davemloft.net, dsahern@kernel.org, dvyukov@google.com,
        fw@strlen.de, hdanton@sina.com, io-uring@vger.kernel.org,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, ming.lei@redhat.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+d6218cb2fae0b2411e9d@syzkaller.appspotmail.com

Tested on:

commit:         5318e5b9 io_uring: quiesce files reg
git tree:       https://github.com/isilence/linux.git syz_test_quiesce_files
kernel config:  https://syzkaller.appspot.com/x/.config?x=f7d9f99709463d21
dashboard link: https://syzkaller.appspot.com/bug?extid=d6218cb2fae0b2411e9d
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: testing is done by a robot and is best-effort only.
