Return-Path: <SRS0=AyPt=3K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D091C33CAA
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Jan 2020 04:41:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61DF7217F4
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Jan 2020 04:41:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728596AbgAUElC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Jan 2020 23:41:02 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:53070 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727829AbgAUElB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Jan 2020 23:41:01 -0500
Received: by mail-io1-f71.google.com with SMTP id d10so957042iod.19
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Jan 2020 20:41:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=NCHvuKVSBxRHeizGAyp94YLEyZNHqgNg1esxuxlJg/o=;
        b=KzkJTD2muHcfhugYVbzPgAtKvz2xOrgiimbQ+4wDPlQ751sFPoD+qrkw86aASb7qLS
         yK/A9S7a6uFYQon4HJNPSgG+vFtvZLNHxwOlkixzvjPXmAVWuvTHXv8NgZMvP7j1IAqi
         EkRlaou3TlhYJ4YwAdtWoWEBqOwFvqOUU1L86OGjgiZ0oYNCTn2CaAyIXIm2UmowuMV7
         H1gCTiTqk3UJVvQEPk0od098UOxmEtzyQAIOa/TwwfhK3sIlBdBFHJ3n9rRR9J5xJsPe
         ymmj91bIfIYrju5+1qbxGuJFpDipPV2E+3cspbsvS9keG8NhbiPDcMJLtwJkNQwAL1Wk
         opHw==
X-Gm-Message-State: APjAAAXErhqtPrkgCquPBSIlmwuQglKMqj4W77Ae3Pge1nQZryW4c/QJ
        /kBVZ51lXWqOqQKD5OU6Q4siZRFMKm+iyZ8QL9GeSs3n7rH4
X-Google-Smtp-Source: APXvYqzJrudOM5ZqIhdp6/vUqAJPKgAZHJimMJnIa4tHcx71IDDXqV6DGIP5tIwdhQNRHsKr47nmu6rr4NtsU6zWdZOvYEY4ROX2
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:4d2:: with SMTP id f18mr2062010ils.54.1579581661230;
 Mon, 20 Jan 2020 20:41:01 -0800 (PST)
Date:   Mon, 20 Jan 2020 20:41:01 -0800
In-Reply-To: <000000000000bb0378059c865fdf@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cfbeb5059c9f036d@google.com>
Subject: Re: KASAN: use-after-free Read in bitmap_ip_destroy
From:   syzbot <syzbot+8b5f151de2f35100bbc5@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        coreteam@netfilter.org, davem@davemloft.net,
        florent.fourcot@wifirst.fr, fw@strlen.de, jeremy@azazel.net,
        johannes.berg@intel.com, kadlec@netfilter.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com,
        mareklindner@neomailbox.ch, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        sw@simonwunderlich.de, syzkaller-bugs@googlegroups.com,
        tanhuazhong@huawei.com
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot has bisected this bug to:

commit 354d0fab649d47045517cf7cae03d653a4dcb3b8
Author: Peng Li <lipeng321@huawei.com>
Date:   Thu Jul 4 14:04:26 2019 +0000

    net: hns3: add default value for tc_size and tc_offset

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15cc0685e00000
start commit:   8f8972a3 Merge tag 'mtd/fixes-for-5.5-rc7' of git://git.ke..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=17cc0685e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=13cc0685e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cfbb8fa33f49f9f3
dashboard link: https://syzkaller.appspot.com/bug?extid=8b5f151de2f35100bbc5
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12e22559e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16056faee00000

Reported-by: syzbot+8b5f151de2f35100bbc5@syzkaller.appspotmail.com
Fixes: 354d0fab649d ("net: hns3: add default value for tc_size and tc_offset")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
