Return-Path: <SRS0=8lzl=2S=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C37A6C2D0C6
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Dec 2019 09:06:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A078720748
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Dec 2019 09:06:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfL1JGC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 28 Dec 2019 04:06:02 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:53697 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbfL1JGC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 28 Dec 2019 04:06:02 -0500
Received: by mail-io1-f72.google.com with SMTP id m5so13184006iol.20
        for <netfilter-devel@vger.kernel.org>; Sat, 28 Dec 2019 01:06:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=WfGb9lGFdGhSi8hZEfWk/M3G0IsGwYCNAdgm6CjQ7QI=;
        b=rRbETUTwcGZYwsnMw4uhZ0WxUrx+rkrSTpR5FDqawR/ioVt74fxbd0HbK2B6fzP7G9
         NAn8yEG09SY1BPhD50qBParcWdgvMQ535+QSAKEaiLMTWV462gSXjEitgqhwbOBU5HlO
         Ip1LNG+DwnmZ4EuXhetLStp4zWFJW1QvRPVptpyM8zNfAUu2d73Qxs/xKhz3Pu8a2yPN
         7zjTiYyMPY1XpoV6ykEunXR699vX2tf7c9SwnSD2Zn23uRtqv9u0gZKSDOAMt44YOQqf
         cpYfBb1H92dJJufHB4drwLlvb3EDoM3traOTqBmoQWlRoY4NuOJiOgZKj5pb7xsBhu+u
         NYYA==
X-Gm-Message-State: APjAAAX+WE7bkVzinW2Dcj5YpaE0AhEbIliXCCa4lh+WXCJBuT8MPi7b
        pEbzLB8flx1QDnJZ7owIKg838VVlpBQ1AnI7mX7rqwkGy6Xp
X-Google-Smtp-Source: APXvYqyJDTFrNl+ZpW3oGkoUn5Ny0lVdEe36WgM5iN4TzGysRfB97r5Zok5DVtIDafRKxTRvqHwhuE0e1QpHyIt/5WWgjBGqL612
MIME-Version: 1.0
X-Received: by 2002:a6b:f404:: with SMTP id i4mr37323657iog.252.1577523961683;
 Sat, 28 Dec 2019 01:06:01 -0800 (PST)
Date:   Sat, 28 Dec 2019 01:06:01 -0800
In-Reply-To: <0000000000004718ff059abd88ef@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005c669c059abfebe7@google.com>
Subject: Re: general protection fault in nf_ct_netns_do_get
From:   syzbot <syzbot+19616eedf6fd8e241e50@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        hpa@zytor.com, kadlec@netfilter.org, linux-kernel@vger.kernel.org,
        linux@roeck-us.net, mareklindner@neomailbox.ch, mingo@redhat.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot has bisected this bug to:

commit 0a957467c5fd46142bc9c52758ffc552d4c5e2f7
Author: Guenter Roeck <linux@roeck-us.net>
Date:   Wed Aug 15 20:22:27 2018 +0000

     x86: i8259: Add missing include file

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1579e751e00000
start commit:   46cf053e Linux 5.5-rc3
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1779e751e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1379e751e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ed9d672709340e35
dashboard link: https://syzkaller.appspot.com/bug?extid=19616eedf6fd8e241e50
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14a47ab9e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=170f2485e00000

Reported-by: syzbot+19616eedf6fd8e241e50@syzkaller.appspotmail.com
Fixes: 0a957467c5fd ("x86: i8259: Add missing include file")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
