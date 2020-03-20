Return-Path: <SRS0=s0US=5F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFE04C4332B
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Mar 2020 04:42:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4E5520772
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Mar 2020 04:42:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbgCTEmG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Mar 2020 00:42:06 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:41915 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgCTEmF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Mar 2020 00:42:05 -0400
Received: by mail-il1-f197.google.com with SMTP id f19so3993352ill.8
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Mar 2020 21:42:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=+YoOMjO6luwEwwnQleJR7GJujX9qkW3ROR7gWbzVHTc=;
        b=YeK70z+buKvv9pF+5/P+DR7pGVrhsbvwcUjKPNvlR8YOlZ3OqwtUvIPE/g1sM6hGQ9
         YYhnkw7ITQaXD+KFzUO+kBFlNthSfn5apZkrC2+DxKrNCsE+37wO9QuqY10o4oZvf8tc
         SF46KtfJl7OwUl1gYpKPxu4ClbyvuqxL8bxgDkekOIdofipAGeLUeZwBV+sXRljnvlyL
         G7NcpQRSF8Sol9paIwS0SudPX6NeTUY/Ju130EKHcRJAVqwZDtwGF3fP2bSECCyo8zwl
         ZUbKpMCDkgjYx8OA7vIqspVoGeSkgynkZLAQFVI5o+bWtP3EPMnSRBuM/ruslUKQeQGM
         JyWQ==
X-Gm-Message-State: ANhLgQ1jcjhY0clGgdliARhSVGS7DsItz9SePBNetCHZcRLtq/IZ+0f3
        VttQTb5b5mGActQA6xaQGz/3IEyYR3PmfGHRv/dc1ji7ha9E
X-Google-Smtp-Source: ADFU+vvvu8NLalP1cGxkvhKVN7qZ92RRR3QEjUcPEZNcU+YjcZP8wQ2QavDecLU7agqtV2mMBHcxyCFp2UUC8Pz/K3pBe5ExZNzs
MIME-Version: 1.0
X-Received: by 2002:a92:25d6:: with SMTP id l205mr5908567ill.35.1584679324596;
 Thu, 19 Mar 2020 21:42:04 -0700 (PDT)
Date:   Thu, 19 Mar 2020 21:42:04 -0700
In-Reply-To: <0000000000005eaea0059aa1dff6@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000039c12305a141e817@google.com>
Subject: Re: INFO: task hung in htable_put
From:   syzbot <syzbot+84936245a918e2cddb32@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, coreteam@netfilter.org,
        davem@davemloft.net, fw@strlen.de, hannes@cmpxchg.org,
        kadlec@blackhole.kfki.hu, kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, mhocko@suse.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit 99b79c3900d4627672c85d9f344b5b0f06bc2a4d
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu Feb 13 06:53:52 2020 +0000

    netfilter: xt_hashlimit: unregister proc file before releasing mutex

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17446eb1e00000
start commit:   f2850dd5 Merge tag 'kbuild-fixes-v5.6' of git://git.kernel..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=735296e4dd620b10
dashboard link: https://syzkaller.appspot.com/bug?extid=84936245a918e2cddb32
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17a96c29e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12fcc65ee00000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: netfilter: xt_hashlimit: unregister proc file before releasing mutex

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
