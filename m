Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AF53C43217
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Sep 2021 09:23:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2689F610A3
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Sep 2021 09:23:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238671AbhIMJYT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 05:24:19 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:45998 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238506AbhIMJXk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 05:23:40 -0400
Received: by mail-il1-f198.google.com with SMTP id o12-20020a92dacc000000b00224baf7b16fso15144632ilq.12
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Sep 2021 02:22:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=HFFQPLAJXYx4bvBZVVBupuysAIuBOZazsLsw7gSGXPM=;
        b=Zceunzss+ICfnD82aC7cXXZ4pPEAsVKDAjlEMIZZONbLiqJdLVtGPUOyoBze7fUvwv
         ezWLf93VNAtMPOqxtYuHZxi7nMjYZAA6ml6BMHg2O82sJnJf73w4CDnAJUEx8SmE1qbx
         Nl7RBOybI397CQerqYXyfy9IH9mqD7pNwpUw654XP8DoMuyLnvEK7QogGrpRKjtuS9rQ
         XjoEYpMikwtDKvM9Ep4beANvIuGGWpo7NMtoFJGryPUn90jVEJ6rhoguX7oB85zDNjAR
         FUeNU9hvq1aUinFDv5jTXWVHIlirRmOv1IIf+kq+qrHF0+ajk7nZAxyu4zz9FJKpj2gP
         rnmA==
X-Gm-Message-State: AOAM532CEHnIDt1yh2AYtECBv/0ezv9oojpThm+a8/AhOGeaDgX9lNgZ
        C6AkFkUyPxT5SgaUjG1Ls18xTKou2QdUjI4CtVgvDAE9e39g
X-Google-Smtp-Source: ABdhPJz7iVHqBJwGMWVtkrGExpiG1/xH+YHaKqOpWGtfsh6vf6jjB1BWXgH366JewGOkGwNFwNOdUNMP/62JNgA5QSGR5CPvzAXQ
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1564:: with SMTP id k4mr7564234ilu.146.1631524938755;
 Mon, 13 Sep 2021 02:22:18 -0700 (PDT)
Date:   Mon, 13 Sep 2021 02:22:18 -0700
In-Reply-To: <0000000000006e9e0705bd91f762@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006ab57905cbdd002c@google.com>
Subject: Re: [syzbot] WARNING in __percpu_ref_exit (2)
From:   syzbot <syzbot+d6218cb2fae0b2411e9d@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, coreteam@netfilter.org,
        davem@davemloft.net, dsahern@kernel.org, fw@strlen.de,
        hdanton@sina.com, io-uring@vger.kernel.org, kadlec@netfilter.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org, ming.lei@redhat.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 43016d02cf6e46edfc4696452251d34bba0c0435
Author: Florian Westphal <fw@strlen.de>
Date:   Mon May 3 11:51:15 2021 +0000

    netfilter: arptables: use pernet ops struct during unregister

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10acd273300000
start commit:   c98ff1d013d2 Merge tag 'scsi-fixes' of git://git.kernel.or..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=1c70e618af4c2e92
dashboard link: https://syzkaller.appspot.com/bug?extid=d6218cb2fae0b2411e9d
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=145cb2b6d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=157b72b1d00000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: netfilter: arptables: use pernet ops struct during unregister

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
