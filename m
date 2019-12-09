Return-Path: <SRS0=ntVu=Z7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EF0FC43603
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Dec 2019 15:58:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08EE72077B
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Dec 2019 15:58:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbfLIP6C (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Dec 2019 10:58:02 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:55822 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726602AbfLIP6C (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Dec 2019 10:58:02 -0500
Received: by mail-io1-f69.google.com with SMTP id z21so10951740iob.22
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Dec 2019 07:58:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=haSirlvjghAy8O+UGZZ1CIdjmlMMpGQNnbPGRDREiuo=;
        b=W/5XOLurlAx2RrvCJFY0UylQxVusLFfE4FWAd68W1uO6/rNSnPH+/1WDrdSc+PiPGD
         S97ACpHRoDTg/qQF/LG8u7siG4ENSz5JdObxLAmhgoawnaaiB1Pisogi5uejcU+lr3rU
         UZrz4zLopP8+Qlzvcr1sfV1etDoB4xn5fCMbMOqvIPsKoTyumvioEq5Z5spIVKDXY4c+
         UoWyUqiInWLRsDD2IZhpXTXPfTKLngexKoZj7zbwsAt90eldfjdIFra1ZF8BN7hrcXU5
         q/PDfG49D8Pbehj0ZMtfpC/5NhjHx+yGARdtQGIivifxwUsBgDb2drghb9oosGwBKDdU
         jpiA==
X-Gm-Message-State: APjAAAXoNzwVNKavu+fWVaip898R+TsgP7g31xg49pkOQkKYEEyv8Fhm
        BCX9E6oYxuJ6ugxpTzzE61MMqNy3sRgLpu7yGZ7tg+nTtA+g
X-Google-Smtp-Source: APXvYqy7SHoywomGmpRRGQOfRHAlD50ocSW6nQ6ugt5VWZKCvCo8SfnyYovVgE3ZOkflrPwPuNULbNVTBJdi5Engji2jZ7ttDdZV
MIME-Version: 1.0
X-Received: by 2002:a92:45d2:: with SMTP id z79mr28552816ilj.76.1575907081960;
 Mon, 09 Dec 2019 07:58:01 -0800 (PST)
Date:   Mon, 09 Dec 2019 07:58:01 -0800
In-Reply-To: <00000000000000ffab05992442a7@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d1c7150599477511@google.com>
Subject: Re: KASAN: global-out-of-bounds Read in fb_pad_aligned_buffer
From:   syzbot <syzbot+0568d05e486eee0a1ba2@syzkaller.appspotmail.com>
To:     b.zolnierkie@samsung.com, coreteam@netfilter.org,
        daniel.vetter@ffwll.ch, davem@davemloft.net,
        dri-devel@lists.freedesktop.org, gwshan@linux.vnet.ibm.com,
        kaber@trash.net, kadlec@blackhole.kfki.hu, kraxel@redhat.com,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        maarten.lankhorst@linux.intel.com, mpe@ellerman.id.au,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, peda@axentia.se, ruscur@russell.cc,
        sam@ravnborg.org, stewart@linux.vnet.ibm.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot has bisected this bug to:

commit 2de50e9674fc4ca3c6174b04477f69eb26b4ee31
Author: Russell Currey <ruscur@russell.cc>
Date:   Mon Feb 8 04:08:20 2016 +0000

     powerpc/powernv: Remove support for p5ioc2

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13ea0aeae00000
start commit:   9455d25f Merge tag 'ntb-5.5' of git://github.com/jonmason/..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=101a0aeae00000
console output: https://syzkaller.appspot.com/x/log.txt?x=17ea0aeae00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7a3b8f5088d4043a
dashboard link: https://syzkaller.appspot.com/bug?extid=0568d05e486eee0a1ba2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15ddeca6e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16df9e41e00000

Reported-by: syzbot+0568d05e486eee0a1ba2@syzkaller.appspotmail.com
Fixes: 2de50e9674fc ("powerpc/powernv: Remove support for p5ioc2")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
