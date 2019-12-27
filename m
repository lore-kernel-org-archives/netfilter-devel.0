Return-Path: <SRS0=2e0L=2R=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8D97C2D0DB
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Dec 2019 02:47:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98BE720409
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Dec 2019 02:47:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbfL0CrD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Dec 2019 21:47:03 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:47571 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfL0CrC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Dec 2019 21:47:02 -0500
Received: by mail-il1-f197.google.com with SMTP id x69so22130581ill.14
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Dec 2019 18:47:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=9wUyWhkVCaEXCNwORLXmBdo7IR6pgdqnHT8ZPHyEEOI=;
        b=cNPkF51Qc0f8L5BpCmI0We/VUIYq6YQpJm97B/qD9B/HRhbauNQxLqIXzQ4U87Va5w
         WRv3MWEwZx00ootIKRhd++XDr/KxNjrJ4NVZJ2m15hkZigD2CpHEYYDTzGJ1xvsDlp6H
         cBMXotX3K7fQi3wGxx7ZVIyfTwkPlMGVHr9RmZ2f4iVAeeARcmcgMQcWylKEeaV14TSW
         eHZr3ul0SWNiCeTt+f3xgV4kZ81bHhcWuaZooeO7m8VEosMQ8xQHnGSdxDFBkC7g0Awt
         56po3P6egEKcRSm23QjpZZW5QY3LK3zCuODQVRpCsqFJzZls5JaAPIVvM4Nxr3mOAb0l
         ckpg==
X-Gm-Message-State: APjAAAUTheTWyAOVysjCtSwY6eSgPTdytRwxw/Zq6gTvGaNdueYXd80V
        5tiBb2PeDQE2q0fEHN5QYJN6u5c2ya3yFo/xLa+srNHekAX6
X-Google-Smtp-Source: APXvYqy/glUbW4fyY45ilDNcSBPrbmY8p44WAOpcXDXHF91TBRPIzoRZYjV4mJKH8foQH5c56NeEd3d20Al3XaiB4s0DhImJVTjq
MIME-Version: 1.0
X-Received: by 2002:a92:d809:: with SMTP id y9mr44099353ilm.261.1577414821279;
 Thu, 26 Dec 2019 18:47:01 -0800 (PST)
Date:   Thu, 26 Dec 2019 18:47:01 -0800
In-Reply-To: <00000000000057fd27059aa1dfca@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000015fd8f059aa682d3@google.com>
Subject: Re: general protection fault in xt_rateest_tg_checkentry
From:   syzbot <syzbot+d7358a458d8a81aee898@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com,
        fw@strlen.de, kadlec@blackhole.kfki.hu, kadlec@netfilter.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot has bisected this bug to:

commit 3427b2ab63faccafe774ea997fc2da7faf690c5a
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri Mar 2 02:58:38 2018 +0000

     netfilter: make xt_rateest hash table per net

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=151a26c1e00000
start commit:   46cf053e Linux 5.5-rc3
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=171a26c1e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=131a26c1e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ed9d672709340e35
dashboard link: https://syzkaller.appspot.com/bug?extid=d7358a458d8a81aee898
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13713ec1e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1272ba49e00000

Reported-by: syzbot+d7358a458d8a81aee898@syzkaller.appspotmail.com
Fixes: 3427b2ab63fa ("netfilter: make xt_rateest hash table per net")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
