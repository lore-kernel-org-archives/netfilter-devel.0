Return-Path: <SRS0=vOmJ=3I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD37CC33CB6
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 Jan 2020 04:41:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94A1A2072B
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 Jan 2020 04:41:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgASElC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 18 Jan 2020 23:41:02 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:48267 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbgASElC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 18 Jan 2020 23:41:02 -0500
Received: by mail-il1-f200.google.com with SMTP id u14so22422262ilq.15
        for <netfilter-devel@vger.kernel.org>; Sat, 18 Jan 2020 20:41:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=EHfWBR0huIHFcTJaoFUtGUR7IDOZ8MVrcyGekqx8mAE=;
        b=ueH/kL4txyzGjS3eqpK+nmi7Tz4AAW9920t7g2A3qE02qh2PnVyZWDUJmIee/IiBXq
         w0xe0PgcgHuNyyw8SzTIY2NtkMvBYEVADEnv8MB+jhgRO/PA4YsX39zWZnkyYjLQpKpZ
         An27m1MBG9KU3jLCHml5C0sv0mTGYWvhSmmZcmayyc1tcRzq2MVyNeV7zwaNPQbmO+Fn
         sVAJxufI4leB4K/LN5OzqLhjWwFMalZFWPfPnlZh1pYYdF6uFpfy0SyLzYx4pV5hP1DW
         e9ZsLb6jJ6170gR9wbmRvXjxCHSbxX5LBec9VwG5LO0EZpmmw3CHPe1h1CxGS+46uhPQ
         XuDg==
X-Gm-Message-State: APjAAAXYynQX/w/f29FTKJSRY2vYgRSPC6ID2vI3KjGsA/A+Uvazaesl
        p09GxtKyxnrcHo31sHVyH6nmk7dl6fkHfnMcVXvyMTalH01H
X-Google-Smtp-Source: APXvYqxTvS9QIRjVWv+5NS7HReJdEStlb/ujZ5/QAI12PGUg0ITxDVVyZ+dB04yYCxhUmlbpujJjRydgNvYEngV+/fm8FPnQG0fR
MIME-Version: 1.0
X-Received: by 2002:a92:b712:: with SMTP id k18mr5669699ili.259.1579408861675;
 Sat, 18 Jan 2020 20:41:01 -0800 (PST)
Date:   Sat, 18 Jan 2020 20:41:01 -0800
In-Reply-To: <000000000000717523059c6cabc9@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000027c814059c76c818@google.com>
Subject: Re: KASAN: slab-out-of-bounds Read in bitmap_ip_gc
From:   syzbot <syzbot+df0d0f5895ef1f41a65b@syzkaller.appspotmail.com>
To:     allison@lohutok.net, arvid.brodin@alten.se, coreteam@netfilter.org,
        davem@davemloft.net, fw@strlen.de, info@metux.net,
        jeremy@azazel.net, kadlec@netfilter.org,
        kstewart@linuxfoundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot has bisected this bug to:

commit b9a1e627405d68d475a3c1f35e685ccfb5bbe668
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu Jul 4 00:21:13 2019 +0000

    hsr: implement dellink to clean up resources

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13ddfa85e00000
start commit:   25e73aad Merge tag 'io_uring-5.5-2020-01-16' of git://git...
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=103dfa85e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=17ddfa85e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cfbb8fa33f49f9f3
dashboard link: https://syzkaller.appspot.com/bug?extid=df0d0f5895ef1f41a65b
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=124774c9e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15aa48d6e00000

Reported-by: syzbot+df0d0f5895ef1f41a65b@syzkaller.appspotmail.com
Fixes: b9a1e627405d ("hsr: implement dellink to clean up resources")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
