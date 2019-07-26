Return-Path: <SRS0=19L1=VX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B79D6C76190
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Jul 2019 02:34:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A3B9218B8
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Jul 2019 02:34:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbfGZCeC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 22:34:02 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:47492 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbfGZCeB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 22:34:01 -0400
Received: by mail-io1-f72.google.com with SMTP id r27so57075145iob.14
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jul 2019 19:34:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=7CpkHsdwXfZwBwrO6vlf0OIv7joJOo5Z6wYVwguiJ04=;
        b=Ug+m/xeS7IcQGmJOgRa4jGXieCxrKFZKv5QLKQwHDQXnyjF+6H8kdDP8NiYG8oWvNd
         LgYmi8tCsuUA/e37+BeXX/9xY7bWUW1cLX08aJB4cH2eesIaQGCl1NKlFGnePbdcnfET
         fwbpiSTghaKcNMzcYR6IM+3cWvR28xPEU1pNmdXagfwux27TL5ONSV3JRt/BuPv/D2w3
         dO6QVjcbIAxbuGLTAlbt4M6kF6i5l/ROSwkOcyD3rBBwFo8qnvylCIMIYGmIOeYDa0E/
         GXNnc2wBsjpcqE/na1cBanEpwBm00NVSVfOVvSIyHWe0xbT+2hCJ4Kg1GT7QBxwu4pnM
         Sm+Q==
X-Gm-Message-State: APjAAAUayHaXUhFQGjRi4xcAPYBO8eaFzEXlOKk1o6narDF5txHeYq7K
        wDZ5jFW9i9rNhHwiqT9o05rm/d4NwZ6IJMkYBiEYdNPrE6fj
X-Google-Smtp-Source: APXvYqwFoHU762iKdsVHVX6yTlu7QfEbGsNdjn/z0ANksU56Shk8WreV3mmUqSXqtLdMgVlprsuuj4lm54a3cf1C9DCqoj4pnlX3
MIME-Version: 1.0
X-Received: by 2002:a02:b90e:: with SMTP id v14mr56641596jan.122.1564108441113;
 Thu, 25 Jul 2019 19:34:01 -0700 (PDT)
Date:   Thu, 25 Jul 2019 19:34:01 -0700
In-Reply-To: <000000000000b68e04058e6a3421@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000005dbbc058e8c608d@google.com>
Subject: Re: memory leak in dma_buf_ioctl
From:   syzbot <syzbot+b2098bc44728a4efb3e9@syzkaller.appspotmail.com>
To:     bsingharora@gmail.com, coreteam@netfilter.org, davem@davemloft.net,
        dri-devel@lists.freedesktop.org, duwe@suse.de, dvyukov@google.com,
        kaber@trash.net, kadlec@blackhole.kfki.hu,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, mingo@redhat.com, mpe@ellerman.id.au,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, rostedt@goodmis.org, sumit.semwal@linaro.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot has bisected this bug to:

commit 04cf31a759ef575f750a63777cee95500e410994
Author: Michael Ellerman <mpe@ellerman.id.au>
Date:   Thu Mar 24 11:04:01 2016 +0000

     ftrace: Make ftrace_location_range() global

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=154293f4600000
start commit:   abdfd52a Merge tag 'armsoc-defconfig' of git://git.kernel...
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=174293f4600000
console output: https://syzkaller.appspot.com/x/log.txt?x=134293f4600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d31de3d88059b7fa
dashboard link: https://syzkaller.appspot.com/bug?extid=b2098bc44728a4efb3e9
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12526e58600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=161784f0600000

Reported-by: syzbot+b2098bc44728a4efb3e9@syzkaller.appspotmail.com
Fixes: 04cf31a759ef ("ftrace: Make ftrace_location_range() global")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
