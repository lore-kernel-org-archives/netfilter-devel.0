Return-Path: <SRS0=suW2=DF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66718C4741F
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Sep 2020 17:40:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25C132083B
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Sep 2020 17:40:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgI1RkM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Sep 2020 13:40:12 -0400
Received: from mail-il1-f206.google.com ([209.85.166.206]:38365 "EHLO
        mail-il1-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726460AbgI1RkI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Sep 2020 13:40:08 -0400
Received: by mail-il1-f206.google.com with SMTP id f75so1422694ilh.5
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Sep 2020 10:40:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=YJj+NKirC78aDBHmX2WKsxxPVFYimQaCt4KWlG1d+NM=;
        b=ZArF5WI/4XOz2iLdMqrrUNFYX4y8CAyMQ2pugMtq3OFRIRDhUXbp4jDtNsKyU7P6IH
         V1ypgBhKKtnFtYmmY6yJlb33rV8sqEmSauSEqnoA1KAjn13hlIFwijJFvYm2fjQaX6DH
         OBcVY+DJCLCdQMPkgcJ2oKfWQfpNLCNnmVWNs09EiiRZ/7Zu3oYXUZFRKvjLCLzNlXRK
         UPP4qL3rxsiR+ZQ6NOtbpxxr2AUNavKenVJbGYwo1ZL+DRkC7xhu9GQQEhTqDOeRi7eP
         SWTcsCdvo06/udhXRAXv3oBlLV8geabD1NwrWeta4JzeL4xkwm49IOYf5b2Ck7KFOa2z
         9EGQ==
X-Gm-Message-State: AOAM533pT/SZzW+d+Bt4wWKZ3Fwfwx7E7qXCceEGruMPg7EaE4xkTzmi
        ONCL5gWUJoz2lDOt8lZE52chx6G2MZnb0YaCZ9AnEYgPV2+I
X-Google-Smtp-Source: ABdhPJyACsKcOzagLGt6tchEW46xgXXf0ncWeiIXVtEwQtLLeOF/H8MmdTl5xCixGz8iVvFR/G5TTrpiwBozN+CFGBXJmyS2hR2v
MIME-Version: 1.0
X-Received: by 2002:a92:d105:: with SMTP id a5mr2164301ilb.206.1601314805962;
 Mon, 28 Sep 2020 10:40:05 -0700 (PDT)
Date:   Mon, 28 Sep 2020 10:40:05 -0700
In-Reply-To: <000000000000650d4005b00bcb0c@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002edd5605b0632812@google.com>
Subject: Re: general protection fault in strncasecmp
From:   syzbot <syzbot+459a5dce0b4cb70fd076@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, coreteam@netfilter.org,
        davem@davemloft.net, dhowells@redhat.com, hch@lst.de,
        hdanton@sina.com, kaber@trash.net, kadlec@blackhole.kfki.hu,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        mhiramat@kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, torvalds@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot has bisected this issue to:

commit bfd45be0b83e8f711f3abc892850d6047972d127
Author: Christoph Hellwig <hch@lst.de>
Date:   Tue Oct 11 20:52:22 2016 +0000

    kprobes: include <asm/sections.h> instead of <asm-generic/sections.h>

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1613329d900000
start commit:   98477740 Merge branch 'rcu/urgent' of git://git.kernel.org..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1513329d900000
console output: https://syzkaller.appspot.com/x/log.txt?x=1113329d900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5f4c828c9e3cef97
dashboard link: https://syzkaller.appspot.com/bug?extid=459a5dce0b4cb70fd076
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=125d46c5900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16c58f8b900000

Reported-by: syzbot+459a5dce0b4cb70fd076@syzkaller.appspotmail.com
Fixes: bfd45be0b83e ("kprobes: include <asm/sections.h> instead of <asm-generic/sections.h>")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
