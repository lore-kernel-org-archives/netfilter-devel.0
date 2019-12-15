Return-Path: <SRS0=q6zd=2F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 397BFC43603
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Dec 2019 06:31:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12BCD206CB
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Dec 2019 06:31:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbfLOGbF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 15 Dec 2019 01:31:05 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:55862 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbfLOGbD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 15 Dec 2019 01:31:03 -0500
Received: by mail-io1-f72.google.com with SMTP id z21so3232086iob.22
        for <netfilter-devel@vger.kernel.org>; Sat, 14 Dec 2019 22:31:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=uPjooTBgtNtcDU16+HUh9j8DUTREFvIUsjeh8i5zb8c=;
        b=c5vsbdxRSYttjI0Hl8o6zkhwGM6j1e57tKv1p1MbZ6hExg8ThOaqMyafJjmig/L/jU
         YCi6bWRg7Fqjd2gsWkHBTi5aNroKJJoALB9btNSZk7sSJ/BqmHxTbOJVEjnI33ucNQ7j
         /jZB6+AUPQP7wCrn95PAS8pEz1+jrcxYabn4o5ieb6HcPYf2z+Lq2W9TPMhJyRER0Vv/
         749w0WkdwEovRtg1BYwHZvrnnYbaZc8dRnufmJOfXdbD+BttCNb7frzcZcSnZx5CxSCN
         zP9xxPnxeb+vg9r1v0GljgnMif39Nhm88LpAPqIlyDuJPUze/rlqXKsZsJM9qu4lF3Mx
         N+rw==
X-Gm-Message-State: APjAAAW8rX3/cZi5fKb36XCJju/vBihqzrbExfrr2M1i8LV2oE3UL2PL
        LR6xzIZUVu6VwMB8Gqdz7V477E4Ru8dvyVAqCsGHFZTMqZJ5
X-Google-Smtp-Source: APXvYqww0KZklP/HZPASxOh1ECBAek11I/mQkvDmtxWf0F+hizPdRYifxpJhSeQt7ZuoAXuoj1TH6U4YiqD2qQs428uaZ4+Q3wAV
MIME-Version: 1.0
X-Received: by 2002:a6b:16c5:: with SMTP id 188mr13807757iow.195.1576391461017;
 Sat, 14 Dec 2019 22:31:01 -0800 (PST)
Date:   Sat, 14 Dec 2019 22:31:01 -0800
In-Reply-To: <000000000000cd9e600599b051e5@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000f9d220599b83d18@google.com>
Subject: Re: KASAN: vmalloc-out-of-bounds Read in compat_copy_entries
From:   syzbot <syzbot+f68108fed972453a0ad4@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, aryabinin@virtuozzo.com,
        bridge@lists.linux-foundation.org, coreteam@netfilter.org,
        davem@davemloft.net, dja@axtens.net, dvyukov@google.com,
        fw@strlen.de, kadlec@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        nikolay@cumulusnetworks.com, pablo@netfilter.org,
        roopa@cumulusnetworks.com, syzkaller-bugs@googlegroups.com,
        torvalds@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot has bisected this bug to:

commit 0609ae011deb41c9629b7f5fd626dfa1ac9d16b0
Author: Daniel Axtens <dja@axtens.net>
Date:   Sun Dec 1 01:55:00 2019 +0000

     x86/kasan: support KASAN_VMALLOC

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=166d43dee00000
start commit:   e31736d9 Merge tag 'nios2-v5.5-rc2' of git://git.kernel.or..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=156d43dee00000
console output: https://syzkaller.appspot.com/x/log.txt?x=116d43dee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=79f79de2a27d3e3d
dashboard link: https://syzkaller.appspot.com/bug?extid=f68108fed972453a0ad4
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16bc5946e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17302361e00000

Reported-by: syzbot+f68108fed972453a0ad4@syzkaller.appspotmail.com
Fixes: 0609ae011deb ("x86/kasan: support KASAN_VMALLOC")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
