Return-Path: <SRS0=BgG3=ZQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3CDBC33C9C
	for <netfilter-devel@archiver.kernel.org>; Sun, 24 Nov 2019 19:07:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DA782075E
	for <netfilter-devel@archiver.kernel.org>; Sun, 24 Nov 2019 19:07:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbfKXTHC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 24 Nov 2019 14:07:02 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:38419 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726855AbfKXTHB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 24 Nov 2019 14:07:01 -0500
Received: by mail-il1-f198.google.com with SMTP id o18so7490577ilb.5
        for <netfilter-devel@vger.kernel.org>; Sun, 24 Nov 2019 11:07:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=0iPpdRzq0L7+RSFavqTsQfmCi/uTeccXAim0E/TGr2Q=;
        b=nPlreA4hBWlKwAy85jVmnJnGmnRW18/URsO7oAyICm712EE447D0a9O87zBFVgk8uY
         2CkQoT7B8hbvbQXLKm95QcOn5Zr0pWi3M1H00L9wMXnDwidyr+dHAHfJNLsSeGOl+hl5
         sETjQIYlanXCef+hPuZ5E3Op1M7Vo+puaKT0KJlUeZDRnEju4QatOMS2uuYL52fdqgy0
         Wt/e1eSyFa/GD7K0F9q+mu9VUmjjd7wnMX2q/oG3XedM6isSMuQMpQz/yekGLNVVNoLa
         FWtN8eyAgaLfOVMrO1U3Sy19BF0vaL6FUn9HuMQGrwdMxLrjHm5HIirwwaptr/lmWz09
         hyLw==
X-Gm-Message-State: APjAAAWWYvddc/BMQFxCVrd9KVSzFvkwiP0d/00R2C4hgLW31fgSQ+G9
        ML0Pm63i6M8fbxSRNsnfGm+alxchZnxN5Jq/PXb1ckfyXWo3
X-Google-Smtp-Source: APXvYqxzdQLTUAzZHkNrn+IW7dBHAAZnrSGKEzdtkJeRCBqjt/+dvnBg9GSfzUg/aUk4k+sN4UpRfbhAt4p8PcJXTniYzbgEeEFN
MIME-Version: 1.0
X-Received: by 2002:a5d:9153:: with SMTP id y19mr23281646ioq.26.1574622420789;
 Sun, 24 Nov 2019 11:07:00 -0800 (PST)
Date:   Sun, 24 Nov 2019 11:07:00 -0800
In-Reply-To: <000000000000e59aab056e8873ae@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000beff305981c5ac6@google.com>
Subject: Re: KASAN: use-after-free Read in blkdev_get
From:   syzbot <syzbot+eaeb616d85c9a0afec7d@syzkaller.appspotmail.com>
To:     cmetcalf@ezchip.com, coreteam@netfilter.org, davem@davemloft.net,
        dvyukov@google.com, gang.chen.5i5j@gmail.com, kaber@trash.net,
        kadlec@blackhole.kfki.hu, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot has bisected this bug to:

commit 77ef8f5177599efd0cedeb52c1950c1bd73fa5e3
Author: Chris Metcalf <cmetcalf@ezchip.com>
Date:   Mon Jan 25 20:05:34 2016 +0000

     tile kgdb: fix bug in copy to gdb regs, and optimize memset

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1131bc0ee00000
start commit:   f5b7769e Revert "debugfs: inode: debugfs_create_dir uses m..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1331bc0ee00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1531bc0ee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=709f8187af941e84
dashboard link: https://syzkaller.appspot.com/bug?extid=eaeb616d85c9a0afec7d
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=177f898f800000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=147eb85f800000

Reported-by: syzbot+eaeb616d85c9a0afec7d@syzkaller.appspotmail.com
Fixes: 77ef8f517759 ("tile kgdb: fix bug in copy to gdb regs, and optimize  
memset")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
