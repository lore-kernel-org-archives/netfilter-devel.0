Return-Path: <SRS0=22nV=3F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBE2EC33CB1
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jan 2020 10:49:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A20DC2077B
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jan 2020 10:49:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbgAPKtC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Jan 2020 05:49:02 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:39926 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbgAPKtC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Jan 2020 05:49:02 -0500
Received: by mail-il1-f197.google.com with SMTP id n6so15814798ile.6
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jan 2020 02:49:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=vXf7A0NOmOYnzFvw+i/lGTeJq016329/QakV55aUcG0=;
        b=DFysd84fpoOwRkcZtOBuvyBqEnZ6GXjACWmNLmvh9t0njO2UUneWc26TfycXrqqvir
         FAGb79D2BuDQQ6EcAIULJ/ROE2dFzFl2GJq6SZ2SFYRghwUJwMe9akz5wXPuhOTRQfFP
         MOcrukyD2y7ohoryj3pZyMEWTXRbNW1a6FPN32YZ6C9MDrdN7PkPwuk4aQgQCCMaePND
         m8BPr62mUaCjSoPLf07I3K/kT2Bdw4I83KWRn5GrqA9hIqJPIPFzT5qZ94PvGklfwFTI
         8ArA/d/1UPoMQEKuTTmkBax9jtQgg+baKcj+G2B9HxvhiNBGDC6Zfqb6CnZUqO+rZAwA
         FUkA==
X-Gm-Message-State: APjAAAUPI7esAemWGkirGky7XyVm9fnFiTy1KQnVnb0F5RlzEis7mGE0
        16rUTcz7c36z553sICxRg4hscWCg6gBpARSRJSXkIDHVNeRi
X-Google-Smtp-Source: APXvYqxopJ/jpk1yIg/I62PmVhs8FXVnSYmF1TfUZ9VNvmnmuoElsGzQesNp8GprKQ9VNUmhiQEqsoJLXz2GyBosz3vGAuYabDoY
MIME-Version: 1.0
X-Received: by 2002:a92:3cd4:: with SMTP id j81mr3015923ilf.77.1579171741688;
 Thu, 16 Jan 2020 02:49:01 -0800 (PST)
Date:   Thu, 16 Jan 2020 02:49:01 -0800
In-Reply-To: <000000000000b9fc96059c36db9e@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b3ea0f059c3f9203@google.com>
Subject: Re: WARNING in nft_request_module
From:   syzbot <syzbot+0e63ae76d117ae1c3a01@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@blackhole.kfki.hu, kadlec@netfilter.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot has bisected this bug to:

commit 452238e8d5ffd8b77f92387519513839d4ca7379
Author: Florian Westphal <fw@strlen.de>
Date:   Wed Jul 11 11:45:10 2018 +0000

     netfilter: nf_tables: add and use helper for module autoload

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17bb83e1e00000
start commit:   51d69817 Merge tag 'platform-drivers-x86-v5.5-3' of git://..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=147b83e1e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=107b83e1e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d9290aeb7e6cf1c4
dashboard link: https://syzkaller.appspot.com/bug?extid=0e63ae76d117ae1c3a01
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16b14421e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=138473fee00000

Reported-by: syzbot+0e63ae76d117ae1c3a01@syzkaller.appspotmail.com
Fixes: 452238e8d5ff ("netfilter: nf_tables: add and use helper for module  
autoload")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
