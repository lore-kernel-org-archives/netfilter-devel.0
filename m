Return-Path: <SRS0=AyPt=3K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C81EC2D0CE
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Jan 2020 21:50:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50B8D24125
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Jan 2020 21:50:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729099AbgAUVuC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Jan 2020 16:50:02 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:56184 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728799AbgAUVuC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Jan 2020 16:50:02 -0500
Received: by mail-io1-f69.google.com with SMTP id z21so2635630iob.22
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Jan 2020 13:50:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=1nu34KWVojNJ0iYFVQZsR/2nmBumiBAt3h2LvuI970Y=;
        b=edL02p4qnWYiOBXcjKeaNLA8dKmixFQJt77HrsvRrPiv+B9BcVHEgZF39EY949EXEW
         iJXIbZj4GcSzYP0POTpI6T2NYD6YPbNmYvh8/Cw0c6zhc96yCMWMVtrhGUwmMt+CVFV3
         z0sZb4j3oZSmrvTUyxSnl2xyxo/0xCFp6p1uJZ3d/4X0/uIAgsrLPGKcxG3RiX4VNJjN
         XsEByT90AUK8xIh4hVV+dM7Z/c9JqgBft3Fv2PB5lqKTByqV9sTnmK9EimlyOZqtzKZP
         aS3jG7U76WZ4+ZHq/O186pxYYCjuiFHy0yze3XjU+q8pgQBVbPQ+2pMfOjaCtjNUKsYw
         Bmfg==
X-Gm-Message-State: APjAAAXXxkuOJKff481/dZhKbL0+vEOy/vul0i2DWvSE9M9alshuXQXi
        xoHR232gcS051pFUx4Yy/OztFcIW/msEZIyl8vh1a7Gp8gwe
X-Google-Smtp-Source: APXvYqxQ4rOLGRXLTbwmviB3A/+GgBIvEUj4X8+0mXpwIfIkcZe7psrzASaNmKDPlT3fRnC4f73MzzR9V1/NkWOy3R3G2dY3dwD9
MIME-Version: 1.0
X-Received: by 2002:a6b:5503:: with SMTP id j3mr4657404iob.142.1579643401878;
 Tue, 21 Jan 2020 13:50:01 -0800 (PST)
Date:   Tue, 21 Jan 2020 13:50:01 -0800
In-Reply-To: <000000000000367175059c90b6bf@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d747bf059cad63b0@google.com>
Subject: Re: KASAN: use-after-free Read in __nf_tables_abort
From:   syzbot <syzbot+29125d208b3dae9a7019@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, dan.carpenter@oracle.com,
        davem@davemloft.net, fw@strlen.de, kadlec@netfilter.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot has bisected this bug to:

commit ec7470b834fe7b5d7eff11b6677f5d7fdf5e9a91
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Mon Jan 13 17:09:58 2020 +0000

    netfilter: nf_tables: store transaction list locally while requesting module

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14890721e00000
start commit:   d96d875e Merge tag 'fixes_for_v5.5-rc8' of git://git.kerne..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=16890721e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=12890721e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=83c00afca9cf5153
dashboard link: https://syzkaller.appspot.com/bug?extid=29125d208b3dae9a7019
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1203f521e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10a706a5e00000

Reported-by: syzbot+29125d208b3dae9a7019@syzkaller.appspotmail.com
Fixes: ec7470b834fe ("netfilter: nf_tables: store transaction list locally while requesting module")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
