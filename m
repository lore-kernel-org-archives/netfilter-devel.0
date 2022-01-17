Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA909C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jan 2022 16:12:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240887AbiAQQMO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Jan 2022 11:12:14 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:51780 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240884AbiAQQMM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jan 2022 11:12:12 -0500
Received: by mail-il1-f198.google.com with SMTP id d8-20020a056e02214800b002b766d01bf5so11914446ilv.18
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jan 2022 08:12:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=xuzTZ41K566REjxDbPumQ9eQ7qYKtqQReAxXQBUHG4E=;
        b=wNQiRDv3imG/qAE7opjbehbqW0VUqv3RkAlDkN7QLxklXuQRssVRXQw9vPoY4dzW1x
         GPiXntY6tuhBeDImfaBn+0Nr5+4goXtoNjoYSbvcB1KYPVVQ0u2znr44zINRbz/gjC7v
         cFFpl1rzJYMAHHSK1r3Zp7bAvV8mJdYb44cEsymHdyM2bHI2ks+rwSlbrDour/6/ppHz
         rIwfMZgjN70naE4G+sYpI8xDRsQYdeaZupBipWt4/tqtoZ0MuCVHmc6nJW8ghhBdj6Fr
         pRcgTsC0ZWKc3OyiqEk7pYZqjf2rvBZCIx6OJnkOijtS+yz6fKraQREdVBcz8/iBRJji
         PP/g==
X-Gm-Message-State: AOAM531QILWZRsfn8atJc/7+gW59K+2Mvx4I9BauK02zckceczHj9sqV
        sh2iaue+H7Q7nR3GKHFlKJ/3EyKNwWkvPKxfKSlstnC+uOiU
X-Google-Smtp-Source: ABdhPJz1jyyIXxHrExZi60mnLbKlhQ4qpcFnzsZJTX4wBUQTPJaJ+7xBoy1CZ1oYysLObagTp2nEyg6NE4o1+kQgvoMIAINQnGVz
MIME-Version: 1.0
X-Received: by 2002:a02:94a3:: with SMTP id x32mr10046790jah.185.1642435931560;
 Mon, 17 Jan 2022 08:12:11 -0800 (PST)
Date:   Mon, 17 Jan 2022 08:12:11 -0800
In-Reply-To: <000000000000c0069f05d38f279d@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000044c19b05d5c96a09@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in nf_hook_entries_grow
From:   syzbot <syzbot+e918523f77e62790d6d9@syzkaller.appspotmail.com>
To:     antony.antony@secunet.com, coreteam@netfilter.org,
        davem@davemloft.net, eyal.birger@gmail.com, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 8dce43919566f06e865f7e8949f5c10d8c2493f5
Author: Antony Antony <antony.antony@secunet.com>
Date:   Sun Dec 12 10:34:30 2021 +0000

    xfrm: interface with if_id 0 should return error

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10eb9bb0700000
start commit:   9eaa88c7036e Merge tag 'libata-5.16-rc6' of git://git.kern..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=10f3f669b8093e95
dashboard link: https://syzkaller.appspot.com/bug?extid=e918523f77e62790d6d9
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1781a643b00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15130199b00000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: xfrm: interface with if_id 0 should return error

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
