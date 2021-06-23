Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36702C48BE5
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Jun 2021 09:15:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 232BC6044F
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Jun 2021 09:15:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbhFWJRm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Jun 2021 05:17:42 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:38852 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbhFWJRl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Jun 2021 05:17:41 -0400
Received: by mail-il1-f198.google.com with SMTP id w2-20020a056e021a62b02901ee3a728339so1333910ilv.5
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Jun 2021 02:15:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=tu+XTnTLmC9DibbRT9Ja/k7FUiyom6JkIMBLX50ARKo=;
        b=i/pUoVUBiFaW18iOKzhCuQWkGlYvOL7vZx54bk15zcKSkElsVQkE56m9JGQ6k/FWG8
         JAV+0fIsZPblNrXdorBprJOz4Ij1bo40uwB7YoTBMjS5haPlZLm+pPvgEw4EyoiU6XI8
         pqJN+r8mNmg6CFJRvFc7upRjNV+in0KG3VCpqPYAXZw2F8rZ8SUz8yAfbSjISplModX1
         HOZEWQGxnaqyCfmV54zgUZmN3h/QyprRDaBtD+h5N2Xxa4OkzioMzI+yC5IAhL9pcMXQ
         C5xMJMeKtwAn4W7rx9JfZrS7nXJcSXBFZKxQTb1XspdJAsbZmxyJksbvFyNYA75kwabt
         S9tA==
X-Gm-Message-State: AOAM531Zx7K3eeVm0qRQErA7/X+Y4LO4SopukxAtN8vubRsb44kKUR1S
        vMRiIb5j4ZgnUsZvnraxb7IFXi21+SgGo6Ft9ECfmkLWING6
X-Google-Smtp-Source: ABdhPJx+TvC18vUgDtM/8/PQwHM8IDggKp4p/DvJ5T0Ya/ItnxEhnGJ1rQGrB461kRji28Bs/ivSB/XZunBwKS4d2V0bDZecfUqE
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a66:: with SMTP id w6mr2222624ilv.99.1624439723269;
 Wed, 23 Jun 2021 02:15:23 -0700 (PDT)
Date:   Wed, 23 Jun 2021 02:15:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000aa23a205c56b587d@google.com>
Subject: [syzbot] WARNING: zero-size vmalloc in corrupted
From:   syzbot <syzbot+c2f6f09fe907a838effb@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, coreteam@netfilter.org,
        davem@davemloft.net, dsahern@kernel.org, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    13311e74 Linux 5.13-rc7
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15d01e58300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=42ecca11b759d96c
dashboard link: https://syzkaller.appspot.com/bug?extid=c2f6f09fe907a838effb
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14bb89e8300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17cc51b8300000

The issue was bisected to:

commit f9006acc8dfe59e25aa75729728ac57a8d84fc32
Author: Florian Westphal <fw@strlen.de>
Date:   Wed Apr 21 07:51:08 2021 +0000

    netfilter: arp_tables: pass table pointer via nf_hook_ops

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13b88400300000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=10788400300000
console output: https://syzkaller.appspot.com/x/log.txt?x=17b88400300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c2f6f09fe907a838effb@syzkaller.appspotmail.com
Fixes: f9006acc8dfe ("netfilter: arp_tables: pass table pointer via nf_hook_ops")

usb 1-1: media controller created
dvbdev: dvb_create_media_entity: media entity 'dvb-demux' registered.
cxusb: set interface failed
dvb-usb: bulk message failed: -22 (1/0)
DVB: Unable to find symbol mt352_attach()
dvb-usb: no frontend was attached by 'DViCO FusionHDTV DVB-T USB (LGZ201)'
dvbdev: DVB: registering new adapter (DViCO FusionHDTV DVB-T USB (LGZ201))
usb 1-1: media controller created
------------[ cut here ]------------
WARNING: CPU: 1 PID: 2950 at mm/vmalloc.c:2873 __vmalloc_node_range+0x769/0x970 mm/vmalloc.c:2873
Modules linked in:
CPU: 1 PID: 2950 Comm: kworker/1:2 Not tainted 5.13.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: usb_hub_wq hub_event
RIP: 0010:__vmalloc_node_range+0x769/0x970 mm/vmalloc.c:2873
Code: c7 04 24 00 00 00 00 eb 93 e8 b3 44 c5 ff 44 89 fa 44 89 f6 4c 89 ef e8 05 f7 09 00 48 89 04 24 e9 be fb ff ff e8 97 44 c5 ff <0f> 0b 48


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
