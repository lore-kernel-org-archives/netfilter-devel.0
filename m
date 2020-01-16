Return-Path: <SRS0=22nV=3F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F800C33CB1
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jan 2020 06:03:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1077020748
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jan 2020 06:03:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbgAPGDB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Jan 2020 01:03:01 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:55147 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbgAPGDB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Jan 2020 01:03:01 -0500
Received: by mail-io1-f70.google.com with SMTP id u6so12023344iog.21
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Jan 2020 22:03:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=l8bygRXo9H61q/xTgsjVCR2mIDWLRv2gXicQnyi0I1Y=;
        b=JrE9nLK7CSvUBje6MVJXUQpGr46R563VhQCjOYR90ptWhAlYhIgZY4DpIcyH6J9WiZ
         5dqULoHbc068Uxu1sru5nHSxt5PaST4kwSk89t2jqCzC5mxu830BBKrPwFLUZdwSNFRF
         aSBL9gRQ2L5Nb5tJKM173uI4HxwnwZ340kNM+gxM6VttYo8x/ju1U/CS9I3Cy+nGJPF+
         ifUWMuDMDc66rSdbaFgilo2G1nyL/HbTl1rVRENUkn2HSI0QrhuzRC5ObVgOMaScUs/p
         vXwdcolsIFF6eiOuoBWibt4R4svPDS/lQ30DomZZskP/xMiNaDdoTCYwmdY5wstZONiH
         DXyg==
X-Gm-Message-State: APjAAAWaUDvNydExh0LaFnpi0ufy20Ha2QLMJplosWkdhKy5lpA8NnrH
        HKfxJhUkB0tRn7SCCA0UwxKSfe/u4mIvysq6pBaBkLMZLB2k
X-Google-Smtp-Source: APXvYqyE5UypONJc+dmBaDsn10ba1W1VIkt9suVws575jhjE72sLjeZaHsFFX7HXfIFYuVXUR87AMCJI8zBfRLZmt8GGKLBO81wQ
MIME-Version: 1.0
X-Received: by 2002:a92:d8d0:: with SMTP id l16mr2094256ilo.43.1579154580939;
 Wed, 15 Jan 2020 22:03:00 -0800 (PST)
Date:   Wed, 15 Jan 2020 22:03:00 -0800
In-Reply-To: <000000000000bc757e059c36db18@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d7aad9059c3b93b7@google.com>
Subject: Re: BUG: corrupted list in nft_obj_del
From:   syzbot <syzbot+6ca99af7e70e298bd09d@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@blackhole.kfki.hu, kadlec@netfilter.org,
        kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot has bisected this bug to:

commit 20651cefd25ffa77a15cab5853b175a6dc975ec2
Author: Florian Westphal <fw@strlen.de>
Date:   Tue Jan 9 13:30:48 2018 +0000

     netfilter: x_tables: unbreak module auto loading

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1073a33ee00000
start commit:   8b792f84 Merge branch 'mlxsw-Various-fixes'
git tree:       net
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1273a33ee00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1473a33ee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7e89bd00623fe71e
dashboard link: https://syzkaller.appspot.com/bug?extid=6ca99af7e70e298bd09d
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=168b95e1e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10f29b3ee00000

Reported-by: syzbot+6ca99af7e70e298bd09d@syzkaller.appspotmail.com
Fixes: 20651cefd25f ("netfilter: x_tables: unbreak module auto loading")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
