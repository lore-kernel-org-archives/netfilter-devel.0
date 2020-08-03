Return-Path: <SRS0=uIll=BN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6441CC433E0
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Aug 2020 00:49:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40F49206E9
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Aug 2020 00:49:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbgHCAtG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 2 Aug 2020 20:49:06 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:42436 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726989AbgHCAtF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 2 Aug 2020 20:49:05 -0400
Received: by mail-il1-f200.google.com with SMTP id c12so12965862iln.9
        for <netfilter-devel@vger.kernel.org>; Sun, 02 Aug 2020 17:49:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=zjMjCpZHpZC9oX4mSp6lGsDleX+rgZUM4Hc+zQq53tE=;
        b=Bj5o6T6CcZgLbN41MomZ6KWImlQUIL9YFrKtBeM9ySLw5lUk70t13wmJAIXayjeDQx
         YE9XsAsRlhfGJxFKLOtBzkxEJtckX0/Og2pX5NQEB5FDsubeZo3Myt4kp3Zybp4AAheQ
         iBmQz81PLbXEthRAxzvi7mKdtuOo9GApx0AxVoywMGR6N4uEHsa+BU9+F3r8b9oOoXyd
         jZbeWJ0xyzaEVqtCX72dALxGofuWFzfM1oJ4lRFcvmefAgDZPdVGI1FmfckdufPpjxdI
         MzZU/uJLRZc0geWXP+02OhbZGGci3+63NZdEmX04aTXn/9PjqP8pkoedLkvC7rx6TFCH
         GadQ==
X-Gm-Message-State: AOAM531oZiVu881R8k0/7+E7idot5I1QL/f7Gd38n6o5kOKTGooSBt40
        j5cfxXaVqRCu3OBfIjrXRHdDGv1jaW0FMxd2cXLOUzdQP8b/
X-Google-Smtp-Source: ABdhPJx51fMhfJaafxHzZAN2jjWSIrSl/b5CFIul4+GGQOi4s1mKok/hTo4u9c3s4cBgSHZ/wcwXjrq3H3VFwrd210mpw03EVfqe
MIME-Version: 1.0
X-Received: by 2002:a05:6602:15d0:: with SMTP id f16mr168098iow.45.1596415744953;
 Sun, 02 Aug 2020 17:49:04 -0700 (PDT)
Date:   Sun, 02 Aug 2020 17:49:04 -0700
In-Reply-To: <000000000000ab11c505abeb19f5@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000064571305abee81ea@google.com>
Subject: Re: KASAN: use-after-free Write in __sco_sock_close
From:   syzbot <syzbot+077eca30d3cb7c02b273@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net,
        devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        johan.hedberg@gmail.com, kaber@trash.net, kadlec@blackhole.kfki.hu,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        marcel@holtmann.org, mchehab@kernel.org, mchehab@s-opensource.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot has bisected this issue to:

commit 43ea43b9d8b27b7acd443ec59319faa3cdb8a616
Author: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Date:   Wed Oct 12 11:21:43 2016 +0000

    [media] radio-bcm2048: don't ignore errors

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1036e6a4900000
start commit:   ac3a0c84 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1236e6a4900000
console output: https://syzkaller.appspot.com/x/log.txt?x=1436e6a4900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e59ee776d5aa8d55
dashboard link: https://syzkaller.appspot.com/bug?extid=077eca30d3cb7c02b273
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12cf1904900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10d52e14900000

Reported-by: syzbot+077eca30d3cb7c02b273@syzkaller.appspotmail.com
Fixes: 43ea43b9d8b2 ("[media] radio-bcm2048: don't ignore errors")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
