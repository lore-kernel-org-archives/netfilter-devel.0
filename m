Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E45BC47082
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Jun 2021 16:47:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 073F361001
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Jun 2021 16:47:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbhFGQs7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 7 Jun 2021 12:48:59 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:36795 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230453AbhFGQs7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Jun 2021 12:48:59 -0400
Received: by mail-io1-f69.google.com with SMTP id i15-20020a6bee0f0000b029043af67da217so12551958ioh.3
        for <netfilter-devel@vger.kernel.org>; Mon, 07 Jun 2021 09:47:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=5sWTD7ZtJJvFb5Hd+ZcQxV3BC6zm39TRieMzIj8ghAE=;
        b=MwNxSJ4PSTtZhbxSgU92ei4c7e4TuFEBfIKFTzGm1jzVwWy6QPBVDNwk7ReI6scQoW
         VXQSUrqV0F0p/vkq+153jr8ae9/IV4y8A545PFW8C99PRf44OzyjFXPkIoStgX9ztvzb
         twlamI/GoJUB0cwVguqS9I0y2x2UnK4dTOf8dVBXgA0VNMfXZPsqMyXetlQNHjCT4PNy
         TaQqyMJInEW5bzguuPjzph89lsTDnNki3dJrDthOiiaN+iioqsvfii+uy0JWI4HH+o9e
         +MROoS6ZCYOgSLZf7Ts22EctOCXy3+Qeuq7IrZz1oj0KKJBkIaV4KWAuqPpfnZBZb8yV
         eh4w==
X-Gm-Message-State: AOAM530ENUHOc0hvi9kV5MV17CKBupC7sQi8TJshjxau47r7MmFlST86
        7aC5qhLaJjsTDVqvrHiOZv1pgp0yyjn80KcABv5b+vpp7K2U
X-Google-Smtp-Source: ABdhPJyDXPNYTwfbSAd6P+4H7FvAg0x1fEf6Q0O5hD6MvbI9qvTgusV4qviPUlvsH2Fzk78BjCH5i0R7y+J5mBz6CGfrRiefw9Wq
MIME-Version: 1.0
X-Received: by 2002:a92:c7b0:: with SMTP id f16mr14813184ilk.169.1623084427231;
 Mon, 07 Jun 2021 09:47:07 -0700 (PDT)
Date:   Mon, 07 Jun 2021 09:47:07 -0700
In-Reply-To: <000000000000a363b205a74ca6a2@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b9c68205c42fcacb@google.com>
Subject: Re: [syzbot] BUG: using smp_processor_id() in preemptible code in radix_tree_node_alloc
From:   syzbot <syzbot+3eec59e770685e3dc879@syzkaller.appspotmail.com>
To:     bjorn.andersson@linaro.org, brookebasile@gmail.com,
        coreteam@netfilter.org, davem@davemloft.net, dsahern@kernel.org,
        ducheng2@gmail.com, ebiggers@kernel.org, fw@strlen.de,
        gregkh@linuxfoundation.org, kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, manivannan.sadhasivam@linaro.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, skhan@linuxfoundation.org,
        syzkaller-bugs@googlegroups.com, willy@infradead.org,
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

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12dfdf47d00000
start commit:   acf25aa6 Merge tag 'Smack-for-5.8' of git://github.com/csc..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=5263d9b5bce03c67
dashboard link: https://syzkaller.appspot.com/bug?extid=3eec59e770685e3dc879
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15bd4c1e100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1520c9de100000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: netfilter: arptables: use pernet ops struct during unregister

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
