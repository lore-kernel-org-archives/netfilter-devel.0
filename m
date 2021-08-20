Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 187AFC4338F
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Aug 2021 21:29:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9F5C6108B
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Aug 2021 21:29:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240598AbhHTV3z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Aug 2021 17:29:55 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:39656 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238398AbhHTV3x (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Aug 2021 17:29:53 -0400
Received: by mail-il1-f198.google.com with SMTP id y8-20020a92c748000000b00224811cb945so6128113ilp.6
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Aug 2021 14:29:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=irP4+a4MqOno9gjzxCYV4LkdM8U6+CH4E7PsJC0/pm4=;
        b=Bwo6sXa+7h1ZMlRgxrWmBwnSZPqQU3hsfXQg4HUUEeAntR3llHeZcTW+wdqH9ZWVqZ
         2MxgwKIQ34KsoeFg1X5oY8n8TZP1vFpZoxcbseNiXl+GxhSRl8/ZzzUJoK63PN8vGzPF
         17StNe+lOGXDzDPhTp3nhmst5V+81f1Q0ZlZVh2oEdLXUYWASQNaRg7d7uvue7nPLDk7
         /4yp0X6e+8BSyMe2qDEy/VUdvHGEVKJypqjO2UEEnbvg/C8e5E1m9GyXL9QJKiadr7Hr
         XKThy203YigmyKKpRq/xBtAfQzDmjKPRGXxzHcSJlMbMqyEuphOCi/nMrYMM/7mk1ble
         /t/Q==
X-Gm-Message-State: AOAM532PRhkFaRVgdNLPAfFV0uOaOiRqQbzO9ErzTudvJx50ST7BB6CG
        IUXiHRO3ftdt0sQwGQi5BI9kKw9O7abpj7HjjCdZ0LfB7Pxv
X-Google-Smtp-Source: ABdhPJzwQnqnBvNJw3VYBFYSQJOZJNIfjhdUk4XZi5YP/GetgfyT4o7ZYLOJzWzalZHwhX6L41qpYmxt/NbXjWGg30XqrAwCrd24
MIME-Version: 1.0
X-Received: by 2002:a92:7108:: with SMTP id m8mr10061663ilc.238.1629494954973;
 Fri, 20 Aug 2021 14:29:14 -0700 (PDT)
Date:   Fri, 20 Aug 2021 14:29:14 -0700
In-Reply-To: <0000000000000845ce05c9222d57@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f460a305ca045b3e@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in nf_tables_dump_sets
From:   syzbot <syzbot+8cc940a9689599e10587@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot has bisected this issue to:

commit 6001a930ce0378b62210d4f83583fc88a903d89d
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Mon Feb 15 11:28:07 2021 +0000

    netfilter: nftables: introduce table ownership

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12d34475300000
start commit:   f9be84db09d2 net: bonding: bond_alb: Remove the dependency..
git tree:       net-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11d34475300000
console output: https://syzkaller.appspot.com/x/log.txt?x=16d34475300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8075b2614f3db143
dashboard link: https://syzkaller.appspot.com/bug?extid=8cc940a9689599e10587
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15fbb98e300000

Reported-by: syzbot+8cc940a9689599e10587@syzkaller.appspotmail.com
Fixes: 6001a930ce03 ("netfilter: nftables: introduce table ownership")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
