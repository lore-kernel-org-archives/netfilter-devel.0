Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 467CBC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Sep 2021 10:32:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 298346115B
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Sep 2021 10:32:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233716AbhIIKdU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Sep 2021 06:33:20 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:44895 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233901AbhIIKdU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Sep 2021 06:33:20 -0400
Received: by mail-il1-f198.google.com with SMTP id d4-20020a923604000000b0022a2b065b0aso1576775ila.11
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Sep 2021 03:32:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=wYGQ6jwHlyJRKwQ0wASVxdo20+iSeZwpNWcEYrVI0Mg=;
        b=JH/2f0clBfQda0MVU6obFmVM9TxhqSac1SmA3+dkO0m33wLMq318IpxZ5YZq6aTOTS
         TVzSPkbi8hf01HEx/htnvjQbfr4P0LE0GoZSeEXtJ+H8pwENR4ZbswMbBg081Mv9cVgh
         9EtK+is7/C2ev95QHj58nBMRhQsL5x/wk6aSFSLGqD31XsUAavCgnAUF43uv2jRYYeno
         rb9nQbxmik09LIwiaPu+GGoIXDlJiThW/jYzWYrMpqZAsmhjJH4B5QfVSLJtZSgt4YVh
         lNeWRn4CqspLEIxH6Tts63dCclkQp1qUXgjK7g5NlytFJQzsuRh9FL5D0aeu2HgOd2ZZ
         GujQ==
X-Gm-Message-State: AOAM533/kuEoeCTQd1538J21p5bluEIWvd8zaRfnE735aiWbjKsei0zJ
        zr6LPI2HIzArXu83FxICrArepXu5edrVpyxQg5z2dK38pfxY
X-Google-Smtp-Source: ABdhPJyLqRh/TbRtIHt72BPFNapbFg9OeSZoFGu+kZ/Sb6A9wM8KjD+jiurXOZXjz8P6xfgVBECN1lEOE5FmMsE/lX8rlWQ2Uj5i
MIME-Version: 1.0
X-Received: by 2002:a02:ba1a:: with SMTP id z26mr2259499jan.98.1631183531325;
 Thu, 09 Sep 2021 03:32:11 -0700 (PDT)
Date:   Thu, 09 Sep 2021 03:32:11 -0700
In-Reply-To: <0000000000006173bf05cb892427@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f2bcea05cb8d8266@google.com>
Subject: Re: [syzbot] WARNING: kmalloc bug in hash_ipport_create
From:   syzbot <syzbot+a568bbab323b96631e61@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, coreteam@netfilter.org,
        davem@davemloft.net, fw@strlen.de, kadlec@netfilter.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        torvalds@linux-foundation.org, w@1wt.eu
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot has bisected this issue to:

commit 7661809d493b426e979f39ab512e3adf41fbcc69
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Jul 14 16:45:49 2021 +0000

    mm: don't allow oversized kvmalloc() calls

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15bb0a93300000
start commit:   626bf91a292e Merge tag 'net-5.15-rc1' of git://git.kernel...
git tree:       net-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=17bb0a93300000
console output: https://syzkaller.appspot.com/x/log.txt?x=13bb0a93300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=16e23f04679ec35e
dashboard link: https://syzkaller.appspot.com/bug?extid=a568bbab323b96631e61
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=178b5d0d300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16fad1dd300000

Reported-by: syzbot+a568bbab323b96631e61@syzkaller.appspotmail.com
Fixes: 7661809d493b ("mm: don't allow oversized kvmalloc() calls")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
