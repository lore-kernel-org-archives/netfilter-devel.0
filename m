Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DE96C4338F
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Aug 2021 20:50:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18D7561042
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Aug 2021 20:50:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhHGUu1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 7 Aug 2021 16:50:27 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:36710 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbhHGUu0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 7 Aug 2021 16:50:26 -0400
Received: by mail-io1-f69.google.com with SMTP id x13-20020a5eda0d0000b02905976d643e4cso1022383ioj.3
        for <netfilter-devel@vger.kernel.org>; Sat, 07 Aug 2021 13:50:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=kB3Z+oJmbPVyqEenpzuOJ3r/Iu75zORAOLzcjtFRKcU=;
        b=mMUAleSacIUIShvcz8cBi2nqmHtBoVnlKFmiUi8gCm9ICGWfvu+AkNCw4JOE4BhkdT
         IAY2I8Fs5VIFgHJuUrUB+25MxPbuyzM8LDQ5g3ovj24+z0pJfJQHmMbz0a00VHAAzQvN
         897OCgATIERMkHxEmnae2qxKTMgNarnAYWrns3/tGd2KFzuB3gTdro+ku0ZsuEJ5bKKj
         3mkEOLmnC8xxo1OfKyZEJvs0X6zLmbS0rkV0fLaT3UWHjetOilg7MyGfgjlpo2lqPmsl
         Xg8O7bn/FWINxtfy20LjXHTrYT3yHYMo6BiOY6hBCNqKxFTZqJ6El0oxiN6Q2yN8l6Kd
         99Gw==
X-Gm-Message-State: AOAM532I7AGU392/B580QSf3hbOfOFFCqI4D7bvaN9WR+ZsUspOlRuEZ
        4wYhi38pNr3qC2KHEvHNNCCtLkgmvmoxqitRutX270PxC1i9
X-Google-Smtp-Source: ABdhPJwjExny7u/hKTYAZ8j2/3MBwJ7OmePQ9gJZ+yu6LVU/yD0FZToysK+YsZWX2eREUDBAfRwOH4NNmSdjgH2lP5/tagQ/uNEH
MIME-Version: 1.0
X-Received: by 2002:a92:c52e:: with SMTP id m14mr19009ili.257.1628369408835;
 Sat, 07 Aug 2021 13:50:08 -0700 (PDT)
Date:   Sat, 07 Aug 2021 13:50:08 -0700
In-Reply-To: <000000000000b720b705c8f8599f@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002d477205c8fe4ccd@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Write in nft_ct_tmpl_put_pcpu
From:   syzbot <syzbot+649e339fa6658ee623d3@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot has bisected this issue to:

commit 65038428b2c6c5be79d3f78a6b79c0cdc3a58a41
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Tue Mar 17 13:13:46 2020 +0000

    netfilter: nf_tables: allow to specify stateful expression in set definition

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1145a881300000
start commit:   894d6f401b21 Merge tag 'spi-fix-v5.14-rc4' of git://git.ke..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1345a881300000
console output: https://syzkaller.appspot.com/x/log.txt?x=1545a881300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=343fd21f6f4da2d6
dashboard link: https://syzkaller.appspot.com/bug?extid=649e339fa6658ee623d3
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=110319aa300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1142fac9d00000

Reported-by: syzbot+649e339fa6658ee623d3@syzkaller.appspotmail.com
Fixes: 65038428b2c6 ("netfilter: nf_tables: allow to specify stateful expression in set definition")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
