Return-Path: <SRS0=M2Uw=SZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0410BC10F03
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Apr 2019 21:51:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2608218D2
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Apr 2019 21:51:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho-ws.20150623.gappssmtp.com header.i=@tycho-ws.20150623.gappssmtp.com header.b="YOyhuu/J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbfDWVvc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Apr 2019 17:51:32 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44185 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbfDWVvc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Apr 2019 17:51:32 -0400
Received: by mail-pl1-f196.google.com with SMTP id y12so5591863plk.11
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Apr 2019 14:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tycho-ws.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=uw7KXLe/Skb6dFikTX1+7qQzn166qiox9tzl7QxENaE=;
        b=YOyhuu/J3GGz5B+OWj/b+k+xW6ze3w5qrrBdDyavLRdjvHGX+6B7xeJKBkHVD3cAU4
         ox/ZUbjaSGKGoAlgaOB+DKqWL1SXpWsrK5VfdeL6KhigcmZ70uIOBNjBP+rZ0fn8Uj3b
         Pene2Rs7fs4wQMrLxMzrSSKw5tfY/H/R84RxwXKhFb9n9wWQKJ1exxztNgLL5AbeVmXR
         goU8ZXjThXlPrnd5pdvmF2TA3POiDszYcY8UoJDy5sxI7P9rHAnVKA0RBnJJUSqW88bH
         2LfAeM5CTN5ZP3GI7xjJH0xedI9/5TsqpcmFaXaY1V45TufHUwrV9A/GOSveZ0VQx61U
         U6vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=uw7KXLe/Skb6dFikTX1+7qQzn166qiox9tzl7QxENaE=;
        b=fILqD2VOGbdzOkdiJ7MV8RZ2ien/zHvxNiwlsvZZAYdWai69RDBD1yAslaWH1jWryt
         cHVY3YkogJpWkJlZbj37cFdFfg4+UoIlYCteXMqHi1sWnc+oly2bEPEOgzez6VUGuR2S
         tBnUWO3IzwaRUsMhktJnw78oY5MIBiKuHABbWgVXUEGqn+O+aKVymkz5Ah+PExZGPM8i
         IcuYg5sWSM7vEG8xZjE9yBOaa6Zvl55QEhX4B4ey4HTjmtfYLUQ4HJlTUiJ5UGnIoGDI
         bNXoIXzmERs+lXU9tItAOY2DUG/Yo/3ZLK3H60PVBK590R1ebdGa3aPzv78Alvlz7m8G
         9hTA==
X-Gm-Message-State: APjAAAU7LQ1XGpw76XjusHc6xIxrW+GKtpId0pUeOINJIUeeiQt2CqpW
        sZnUnDF9vyhpe7iZhnAZrrAXcA==
X-Google-Smtp-Source: APXvYqzPHlA/MEnAiPv1YCDxZkODyf/FwJRypNfYv1quMLACShzbkjhWsph+0VulOjETvlYS9I55DA==
X-Received: by 2002:a17:902:4481:: with SMTP id l1mr9387078pld.75.1556056290960;
        Tue, 23 Apr 2019 14:51:30 -0700 (PDT)
Received: from cisco ([2601:282:901:dd7b:7136:cebf:c0d3:8091])
        by smtp.gmail.com with ESMTPSA id m131sm41779679pga.3.2019.04.23.14.51.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 23 Apr 2019 14:51:30 -0700 (PDT)
Date:   Tue, 23 Apr 2019 15:51:27 -0600
From:   Tycho Andersen <tycho@tycho.ws>
To:     Kees Cook <keescook@chromium.org>
Cc:     Alexei Starovoitov <ast@kernel.org>, bpf@vger.kernel.org,
        coreteam@netfilter.org, Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Martin KaFai Lau <kafai@fb.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Network Development <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Will Drewry <wad@chromium.org>, wenxu@ucloud.cn,
        Yonghong Song <yhs@fb.com>,
        syzbot <syzbot+b562969adb2e04af3442@syzkaller.appspotmail.com>
Subject: Re: KASAN: use-after-free Read in seccomp_notify_release (2)
Message-ID: <20190423215127.GJ3758@cisco>
References: <000000000000c8f45a0584e69ea9@google.com>
 <CAGXu5jLBd-u=ywxiEjmrLMj9TMRVnLOHHKfWKQ_fEosDFjPoog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jLBd-u=ywxiEjmrLMj9TMRVnLOHHKfWKQ_fEosDFjPoog@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Apr 23, 2019 at 02:39:52PM -0700, Kees Cook wrote:
> On Mon, Mar 25, 2019 at 1:02 AM syzbot
> <syzbot+b562969adb2e04af3442@syzkaller.appspotmail.com> wrote:
> >
> > Hello,
> >
> > syzbot found the following crash on:
> >
> > HEAD commit:    1bdd3dbf Merge tag 'io_uring-20190323' of git://git.kernel..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=12ae5b93200000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=9a31fb246de2a622
> > dashboard link: https://syzkaller.appspot.com/bug?extid=b562969adb2e04af3442
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=162ca25d200000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1733b53b200000
> >
> > The bug was bisected to:
> >
> > commit a799aea0988ea0d1b1f263e996fdad2f6133c680
> > Author: wenxu <wenxu@ucloud.cn>
> > Date:   Wed Jan 9 02:40:11 2019 +0000
> >
> >      netfilter: nft_flow_offload: Fix reverse route lookup
> 
> This bisection looks bogus?
> 
> However, I _can_ trigger the problem on this kernel version with this
> config. (And not with Linus's latest tree.)
> 
> The PoC is identical to the prior report[1] that we thought was fixed.
> Perhaps the fix didn't actually fix it? (I mean
> a811dc61559e0c8003f1086c2a4dc8e4d5ae4cb8) But it's been silent for 29
> days now, so I'm not sure what's going on.
> 
> Tycho are you able to reproduce this on the older tree?

It looks like this case is using TSYNC and NEW_LISTENER together:

syscall(__NR_seccomp, 1, 0xb, 0x20000140);

and I did fix a uaf with TSYNC and NEW_LISTENER in this series:

https://lore.kernel.org/lkml/20190306201413.14153-2-tycho@tycho.ws/T/#u

which seems like it's probably related. I don't think the above ever
got applied though?

Tycho
