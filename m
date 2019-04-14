Return-Path: <SRS0=kfn4=SQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97868C10F14
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Apr 2019 19:20:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D96920870
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Apr 2019 19:20:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbfDNTUC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 14 Apr 2019 15:20:02 -0400
Received: from mail-it1-f198.google.com ([209.85.166.198]:55373 "EHLO
        mail-it1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbfDNTUB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Apr 2019 15:20:01 -0400
Received: by mail-it1-f198.google.com with SMTP id g184so14567193ita.5
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Apr 2019 12:20:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=6YV5NQ1EAO6qSwshw1ufdLQZxEQ9/TbaOVyv9EaQcrA=;
        b=TA0RPt5NI+sO1EB09WUnEa8nEBM9z+BR0FIEMP8TKq/rFVbdXKZb+yFvC9hJAzuO9b
         ufPP0EH0gNdbEfbN6bKRp9OJUbH72YtRyUDE8mpNdPlICA/1D+rXoF8aS9kuPCsEdEqQ
         L6sQmERhGYixxGiF8oN2DmMR5k08u8wf0rsfIieoVfVofooLub/V9ttIrda6ZFgrRc00
         VgWu4VTMMEOre66Xnqd31Mi7a0oVXsMZSlTf2HTCaEiOsKecvzmnk9J7nmqSSejcCKeZ
         4g0W858+0AQtUMP6wIUKaNd7WVRmSDbpNncuEdMgMuQVAKk/HnNcwT2mZepZo1i7b8t/
         MV/A==
X-Gm-Message-State: APjAAAVPzerek59iJRg0sBFUcvZ4t7nvH9nLi74V+auXkShkv90hp1B4
        0oQTs9msaxsg5Ix+wF7u2VhyEf9bpeNL7Iuxdp3GyaIC6n5r
X-Google-Smtp-Source: APXvYqzc0Bp4QML6DjAm7HeeSioJJRmpMRU2UOBxDhwVwkqzHdpUUn575KiXMoTFT6UEjLwDW1BrGbemuPHtM4KWVGn1qhTaRHA3
MIME-Version: 1.0
X-Received: by 2002:a24:97cf:: with SMTP id k198mr5844597ite.26.1555269601059;
 Sun, 14 Apr 2019 12:20:01 -0700 (PDT)
Date:   Sun, 14 Apr 2019 12:20:01 -0700
In-Reply-To: <001a113dea0ef7d2620566c15bac@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000019eb000586826c2a@google.com>
Subject: Re: WARNING in compat_copy_entries (2)
From:   syzbot <syzbot+659574e7bcc7f7eb4df7@syzkaller.appspotmail.com>
To:     alexl@redhat.com, bridge@lists.linux-foundation.org,
        coreteam@netfilter.org, cosimo@endlessm.com, davem@davemloft.net,
        dvyukov@google.com, fw@strlen.de, kadlec@blackhole.kfki.hu,
        libc-alpha@sourceware.org, linux-kernel@vger.kernel.org,
        luto@amacapital.net, luto@kernel.org, mingo@kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        nicholson@endlessm.com, pablo@netfilter.org, peterz@infradead.org,
        raji@linux.vnet.ibm.com, stephen@networkplumber.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, tuliom@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot has bisected this bug to:

commit 9dea5dc921b5f4045a18c63eb92e84dc274d17eb
Author: Andy Lutomirski <luto@kernel.org>
Date:   Tue Jul 14 22:24:24 2015 +0000

     x86/entry/syscalls: Wire up 32-bit direct socket calls

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1736919f200000
start commit:   ce380619 Merge tag 'please-pull-ia64_misc' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10b6919f200000
kernel config:  https://syzkaller.appspot.com/x/.config?x=36fbc8c97ef985d3
dashboard link: https://syzkaller.appspot.com/bug?extid=659574e7bcc7f7eb4df7
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=179b4d8b800000

Reported-by: syzbot+659574e7bcc7f7eb4df7@syzkaller.appspotmail.com
Fixes: 9dea5dc921b5 ("x86/entry/syscalls: Wire up 32-bit direct socket  
calls")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
