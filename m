Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AD2FC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Dec 2021 11:42:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbhLHLpj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Dec 2021 06:45:39 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:53859 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbhLHLpi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Dec 2021 06:45:38 -0500
Received: by mail-il1-f197.google.com with SMTP id i8-20020a056e021d0800b0029e81787af1so2563417ila.20
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Dec 2021 03:42:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Cq6WGSsbkGm+8nb0ThhxOfOvaLP7AJDIkLOefXvz+uY=;
        b=4q9ZSM1miFsQuK/E78b7aouGup+6y649qVj6e7qT4d5dymOFrso/KEx/ibHtKmMhEP
         hlQVrzYpqPgz8fYeEbucW5iB3RtNQ4GYSscOo9RU5wMpu31V0xqmtnFCqstX2PpJ6jPA
         BQBHevSgqO/3KsVpqL7vi21papoY+yHqg+Qc4FVyuEqM3Iu/wHg2tRLReDCVnnkQYz32
         jApDPUo1BtwLK2l9mhYbcvQITtJfm6ko5XP7dHSlyFgHEG486gxbHRMh2s8HY1OGI7YH
         e199/1vnbFyXQ9Sk7q2sQEE6qO2fVqZZ+XA4EEkwUl2ZIUF9dY99YR41RL1DrnBYaSyZ
         jTOg==
X-Gm-Message-State: AOAM531ootduHDKDUTNcRowlBIS75ctqWJmrUbq6LY8lgVUS2Ac2N1bn
        mXljqLNEKsGCXRF7p8mcruukvQwcZ5/LWiwx0iRERAD+U8DI
X-Google-Smtp-Source: ABdhPJwVt0d41ihAPgHJSWd2jTx09ZIGqhhiiwLHhb7EM/SNMaXiiIcGIJu7NzZd8ctmftWz5j+uDKa8fHXt14xKFWf6ThkIW5+i
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1ca6:: with SMTP id x6mr6098073ill.214.1638963726877;
 Wed, 08 Dec 2021 03:42:06 -0800 (PST)
Date:   Wed, 08 Dec 2021 03:42:06 -0800
In-Reply-To: <0000000000007f2f5405d1bfe618@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bd8a5505d2a0faee@google.com>
Subject: Re: [syzbot] possible deadlock in blkdev_put (2)
From:   syzbot <syzbot+643e4ce4b6ad1347d372@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, coreteam@netfilter.org, davem@davemloft.net,
        dsahern@kernel.org, fw@strlen.de, kadlec@netfilter.org,
        kuba@kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        penguin-kernel@I-love.SAKURA.ne.jp,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot has bisected this issue to:

commit f9006acc8dfe59e25aa75729728ac57a8d84fc32
Author: Florian Westphal <fw@strlen.de>
Date:   Wed Apr 21 07:51:08 2021 +0000

    netfilter: arp_tables: pass table pointer via nf_hook_ops

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12500ae5b00000
start commit:   04fe99a8d936 Add linux-next specific files for 20211207
git tree:       linux-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11500ae5b00000
console output: https://syzkaller.appspot.com/x/log.txt?x=16500ae5b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4589399873466942
dashboard link: https://syzkaller.appspot.com/bug?extid=643e4ce4b6ad1347d372
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11bb96ceb00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15ad1badb00000

Reported-by: syzbot+643e4ce4b6ad1347d372@syzkaller.appspotmail.com
Fixes: f9006acc8dfe ("netfilter: arp_tables: pass table pointer via nf_hook_ops")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
