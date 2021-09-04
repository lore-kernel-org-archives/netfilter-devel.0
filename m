Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80E9DC433F5
	for <netfilter-devel@archiver.kernel.org>; Sat,  4 Sep 2021 08:23:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DAFE61051
	for <netfilter-devel@archiver.kernel.org>; Sat,  4 Sep 2021 08:23:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233962AbhIDIYN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 4 Sep 2021 04:24:13 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:54903 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233278AbhIDIYM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 4 Sep 2021 04:24:12 -0400
Received: by mail-io1-f70.google.com with SMTP id e2-20020a056602044200b005c23c701e26so1056384iov.21
        for <netfilter-devel@vger.kernel.org>; Sat, 04 Sep 2021 01:23:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=M3toUYP73wjtZjjuGZaluiFGnzByzbicamvbzl2GU/w=;
        b=GKknV+FJ/lML0/o1yMYRhDZO0IgvjFHx9p474+SUyKa4zCBEE39uUYHcupNxHj0Tme
         mQQyxPWZmT4YXCqpAxg61d2CpZ888Lh4ynawW48t/efzPOM+7K3rhnX4KBWw9R2ujf3W
         OkTUtBx2zRGxoj43ZwwhzEmiy67KbvDtT29xLCKIuHbggr6C2OQ8a1ELGGigssUcyH7s
         QNx3XdIgjn8B9Nk7YXasrcTbLvbCbxkyNm6TNP/KUpUh+F1En3O1ekglil6uf1O++HlA
         L625RB6Gjf1RsbaNLs8x+OYXb13VQ2wNYaaxKb8lE7cbarvhJ17oGpaSG6s8zH1z0XRg
         GuFw==
X-Gm-Message-State: AOAM532rRMSyC6vFP0kPB/LDxpKXcSYODgn2GWkMPqUH/+fmh/WvBZSw
        8et3rvJu3LLBPPpj3SQN/0oBkdfzGZezvuxjyCwRsnvamLyP
X-Google-Smtp-Source: ABdhPJz3nU0+9fHDM9jpojjeZT6ijTGdbtoJlUBtgSHEtb4+BB6TZlWcNDnkyxKIOI/Pw8b3cTxJ3iM9/EBYgvrmkdZYQKhrS7Y4
MIME-Version: 1.0
X-Received: by 2002:a92:d282:: with SMTP id p2mr1977515ilp.259.1630743791386;
 Sat, 04 Sep 2021 01:23:11 -0700 (PDT)
Date:   Sat, 04 Sep 2021 01:23:11 -0700
In-Reply-To: <0000000000003166f105cb201ea6@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000067c79605cb2720bb@google.com>
Subject: Re: [syzbot] WARNING: kmalloc bug in hash_netport_create
From:   syzbot <syzbot+3f5904753c2388727c6c@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, coreteam@netfilter.org,
        davem@davemloft.net, eric.dumazet@gmail.com, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        torvalds@linux-foundation.org, w@1wt.eu
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot has bisected this issue to:

commit 7661809d493b426e979f39ab512e3adf41fbcc69
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Jul 14 16:45:49 2021 +0000

    mm: don't allow oversized kvmalloc() calls

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=113125f5300000
start commit:   a9c9a6f741cd Merge tag 'scsi-misc' of git://git.kernel.org..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=133125f5300000
console output: https://syzkaller.appspot.com/x/log.txt?x=153125f5300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1ac29107aeb2a552
dashboard link: https://syzkaller.appspot.com/bug?extid=3f5904753c2388727c6c
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14581b33300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13579a69300000

Reported-by: syzbot+3f5904753c2388727c6c@syzkaller.appspotmail.com
Fixes: 7661809d493b ("mm: don't allow oversized kvmalloc() calls")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
