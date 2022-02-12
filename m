Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3585C4332F
	for <netfilter-devel@archiver.kernel.org>; Sat, 12 Feb 2022 22:43:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232199AbiBLWnU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 12 Feb 2022 17:43:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232186AbiBLWnU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 12 Feb 2022 17:43:20 -0500
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1236A23BD6
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Feb 2022 14:43:16 -0800 (PST)
Received: by mail-il1-f199.google.com with SMTP id g15-20020a92520f000000b002bec6a02012so3073722ilb.18
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Feb 2022 14:43:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Qndx5/xlMDuMFsAiyXYtZiMwVkwJVHOfIbITY7SRWJQ=;
        b=ivBIpFV02cRWXUWnDUXkaN38jIFkA94sTF40I7in2DBr8slxdMfEhTLunwd9jbhIGg
         Mpfh2Fwmr1TI7SEEiJG+VoLVEPS5KUYPsyWPkJSGUVxm9nwRkgDRdyM89Hw0I9HyX/EL
         uFF8/AYk7lb8ZfnjRLHUzksX9Umhu+Ftr8OkGM+JPMfyEznQWGwMFEobMayiRrRKf2F4
         toT2yOZPGqNnQaqhpm40CJg4XhEILTKahDKsPGkmTGmJojw34seGHIoSQ21ZSA55GfxK
         8tkFYDfz0imtAT4oZ7jZbCr51WSNnPhSCqvwVSzsRqLhacxj1gC8QltXfWJV43oSDTOM
         xQiA==
X-Gm-Message-State: AOAM5303etekOmRkOc2lyDs+MULDWEuzBrW7aiH2+UqA/phPx9JzjUTy
        reYvudepywllnfr/FLwn18GAHzT07FXQpRynImt2u/+QCI82
X-Google-Smtp-Source: ABdhPJyYJiru2zx+c/KVjgt1xGFubXKCnNkIk4JRjg/rcylmahzVP9hbqgP6bfAIgw0MItzt6bpF6kOvtY69glToznfqQq+iuQ/5
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1806:: with SMTP id a6mr3393462ilv.272.1644705795363;
 Sat, 12 Feb 2022 14:43:15 -0800 (PST)
Date:   Sat, 12 Feb 2022 14:43:15 -0800
In-Reply-To: <0000000000004c57c005b0fc4114@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b15b3505d7d9e8ca@google.com>
Subject: Re: [syzbot] INFO: task hung in usb_get_descriptor
From:   syzbot <syzbot+31ae6d17d115e980fd14@syzkaller.appspotmail.com>
To:     brouer@redhat.com, coreteam@netfilter.org, davem@davemloft.net,
        edumazet@google.com, eman.mohamed@rofaidarealestate.com,
        gregkh@linuxfoundation.org, gustavoars@kernel.org,
        hdanton@sina.com, ingrassia@epigenesys.com, johan@kernel.org,
        kaber@trash.net, kadlec@blackhole.kfki.hu,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        mathias.nyman@linux.intel.com, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        skhan@linuxfoundation.org, stern@rowland.harvard.edu,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 363eaa3a450abb4e63bd6e3ad79d1f7a0f717814
Author: Shuah Khan <skhan@linuxfoundation.org>
Date:   Tue Mar 30 01:36:51 2021 +0000

    usbip: synchronize event handler with sysfs code paths

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1616e872700000
start commit:   4fa56ad0d12e Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=144ecdb0be3abc07
dashboard link: https://syzkaller.appspot.com/bug?extid=31ae6d17d115e980fd14
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12548d11d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13ec77e9d00000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: usbip: synchronize event handler with sysfs code paths

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
