Return-Path: <SRS0=x4bV=3O=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32695C35241
	for <netfilter-devel@archiver.kernel.org>; Sat, 25 Jan 2020 05:17:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EF8D20838
	for <netfilter-devel@archiver.kernel.org>; Sat, 25 Jan 2020 05:17:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbgAYFRD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 25 Jan 2020 00:17:03 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:54638 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgAYFRD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 25 Jan 2020 00:17:03 -0500
Received: by mail-io1-f70.google.com with SMTP id k25so2719634ios.21
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Jan 2020 21:17:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Hm1zljW9y0AexWcJitkyOHbzqNCGgR9k713xPpYIVAY=;
        b=d93OfF8B6YWqryRxw/HVvQDZsR5GjujZ8307j54J+nMwnyKniJuGayGyFlnKinL0eX
         4KdgmRDRiPc3iuNoADGkHqY4jIMZnifdWyvwZH3Xe8jotgblIhEyQ/aDKzEbxHk5UFbD
         blIWhfg1r24pUKxpLm+wOvHb1AwGN7KKaSZDjI6wF5Za3htSLr/Hn5YXRDDcxh1gnV1C
         HApzQ6grCNMisqU+HRgvzPVJsiE3JKApw1LVzQSNqqwzlWfcJ8WGlVmgpHRl5KIBT0NJ
         gAXVhUatvOUnQC0L435cE7TOZfuphqn8HH3Mc8l+jaYGIZUDXT9Bgbsk9JUGUIcW0m5q
         xRPw==
X-Gm-Message-State: APjAAAVYx6A2ZtRswIlYc5U50IoDQonifnFS2BnCiEpPy38qpxXpKjRT
        UA/Tw0w9U4Gy54lgm21XvdJTo/Lslfcim41A4+BBg9Daitr5
X-Google-Smtp-Source: APXvYqzktrXlzRHbfMlINQ4SHuMoXb8GIG7MQZ6dYPldTUgzSyB7rjjYXEMSwB2k5zI32/xnqeOrTvFvtLKPcvFAYhveGhIqcFFK
MIME-Version: 1.0
X-Received: by 2002:a5d:9514:: with SMTP id d20mr5091562iom.198.1579929422654;
 Fri, 24 Jan 2020 21:17:02 -0800 (PST)
Date:   Fri, 24 Jan 2020 21:17:02 -0800
In-Reply-To: <000000000000c8a983059ce8298c@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000001f420059ceffc95@google.com>
Subject: Re: INFO: rcu detected stall in ip_set_udel
From:   syzbot <syzbot+c27b8d5010f45c666ed1@syzkaller.appspotmail.com>
To:     bp@alien8.de, coreteam@netfilter.org, davem@davemloft.net,
        fw@strlen.de, hpa@zytor.com, info@metux.net, jeremy@azazel.net,
        kadlec@blackhole.kfki.hu, kadlec@netfilter.org,
        kstewart@linuxfoundation.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot has bisected this bug to:

commit 23c42a403a9cfdbad6004a556c927be7dd61a8ee
Author: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Date:   Sat Oct 27 13:07:40 2018 +0000

    netfilter: ipset: Introduction of new commands and protocol version 7

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1352c611e00000
start commit:   4703d911 Merge tag 'xarray-5.5' of git://git.infradead.org..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=10d2c611e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1752c611e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=83c00afca9cf5153
dashboard link: https://syzkaller.appspot.com/bug?extid=c27b8d5010f45c666ed1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1568f9c9e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17db3611e00000

Reported-by: syzbot+c27b8d5010f45c666ed1@syzkaller.appspotmail.com
Fixes: 23c42a403a9c ("netfilter: ipset: Introduction of new commands and protocol version 7")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
