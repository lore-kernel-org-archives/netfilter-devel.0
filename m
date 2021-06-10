Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 496E1C47094
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Jun 2021 08:04:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3193F613CA
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Jun 2021 08:04:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbhFJIGT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Jun 2021 04:06:19 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:40578 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbhFJIGP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Jun 2021 04:06:15 -0400
Received: by mail-il1-f200.google.com with SMTP id b4-20020a920b040000b02901dc81bf7e72so808048ilf.7
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Jun 2021 01:04:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=EXuC5hR+DxXmhBYFDXYIPj2wRbgENSDGNStCsBqTJu0=;
        b=F4aJ77HFWGN6l37Oncx6WA68wciJim+3JnorOWVMaLFVQ+KqgN7TCapKXJvJC41opB
         loUNssivEtgVSqJJ1c972hd9adCz3ckgft1e19+cssBgYAmV0bILHPPBcesFMXxJCwOb
         1fjFt7wMcMB+GDGjF8bZyle9Z2FKwpk9a9mc/TlVdZepKEjrlJvJ8E1yhreEb0MGRGWu
         iIBJKpEFsyDPkDoHcXhMNHeKBS+CnNljv015UYKZvvFs2VurqHQj+m+/nEj7OlPrIVO2
         iAI326GXoUAtfDCkyKsBgQLQ4mg6OZ5fc11L2NwIwJM/duQcE/SDF6956NKq61h18yQp
         pZhw==
X-Gm-Message-State: AOAM533nWzkYrepypyU4bU/Gth9RubI/7yPddY+ig3enxFnpN+Kl5WOy
        rTd0XPlQULxDciE0ti/0m6rAEN3MSkB7TgEN0INZk90xmfBE
X-Google-Smtp-Source: ABdhPJxRRi/1I5TNhoQba1+i+apRY6ysQAyvYPwt9CP8LLzEVHGx0ECuewSq/IOcrMT0gR4jj+XFBdzrofOIP0eVpO+iJSk1UUPl
MIME-Version: 1.0
X-Received: by 2002:a92:640d:: with SMTP id y13mr3083856ilb.158.1623312247492;
 Thu, 10 Jun 2021 01:04:07 -0700 (PDT)
Date:   Thu, 10 Jun 2021 01:04:07 -0700
In-Reply-To: <0000000000003842c805c44e7951@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000df175a05c464d5b7@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in blk_mq_exit_sched
From:   syzbot <syzbot+77ba3d171a25c56756ea@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, coreteam@netfilter.org, davem@davemloft.net,
        dsahern@kernel.org, fw@strlen.de, hch@lst.de,
        john.garry@huawei.com, kadlec@netfilter.org, kuba@kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        ming.lei@redhat.com, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot has bisected this issue to:

commit f9006acc8dfe59e25aa75729728ac57a8d84fc32
Author: Florian Westphal <fw@strlen.de>
Date:   Wed Apr 21 07:51:08 2021 +0000

    netfilter: arp_tables: pass table pointer via nf_hook_ops

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14e76d88300000
start commit:   a1f92694 Add linux-next specific files for 20210518
git tree:       linux-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=16e76d88300000
console output: https://syzkaller.appspot.com/x/log.txt?x=12e76d88300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d612e75ffd53a6d3
dashboard link: https://syzkaller.appspot.com/bug?extid=77ba3d171a25c56756ea
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13c901ebd00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1406b797d00000

Reported-by: syzbot+77ba3d171a25c56756ea@syzkaller.appspotmail.com
Fixes: f9006acc8dfe ("netfilter: arp_tables: pass table pointer via nf_hook_ops")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
