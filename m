Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98905C47083
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Jun 2021 11:19:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8700461159
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Jun 2021 11:19:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232057AbhFBLU7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Jun 2021 07:20:59 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:44734 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232093AbhFBLU6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Jun 2021 07:20:58 -0400
Received: by mail-il1-f199.google.com with SMTP id h6-20020a92c0860000b02901e0cde08c7fso1287454ile.11
        for <netfilter-devel@vger.kernel.org>; Wed, 02 Jun 2021 04:19:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to:cc;
        bh=Ik+ck8Lh3RRt0JEN5CCsrhUxXANYahmCllH+5HG5l88=;
        b=EfukfSVjLffnHLnEZvxU56QQKFwTA+wvRCjS0aG+FcZWrx6A8706Qc+R5sT31SF3em
         /evSwRvQmpGd0qkM27ubBksEwzTdnIp8TvDn901eJpiVjzlqC+NUeGAB9ybFsi7PiWnq
         M8BzoE5dMwXsUcrQpCBuMmg/6+jF+aEQkDAuicRWe37n6mC0CECs9Kut2xAW9mNNcat1
         x7guLCSSymUp7178W7UboSveEDS6idTpDKPEbNcap7z8apl+EecWF8Y83x6n9CN8p5t9
         79n/lWfkxdjXJdwpkDXhzl6NCpL+tNAZDy9prq8OKLElOqg/br62Go7Zf4oNFAexBJ9M
         KcmQ==
X-Gm-Message-State: AOAM5327twd/wTC2bXSW1yFotMyPdr8bJ7IG03YQeKOlam7Lh02ecfw/
        17Bb7n10MGvmXRbak1DazZEpHq1sUMwwPa0pVhoVNGS2zVAS
X-Google-Smtp-Source: ABdhPJzJqVr2YzcOaqu2A0rRUEiRWN4jO2zCOcyJJKUMnlEYYcW6KSke3zHcDGUZQpzoXUdx3YpvAjjRKi+XPGZ3ZP0DqITYqcT4
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:13a9:: with SMTP id h9mr8555710ilo.96.1622632755758;
 Wed, 02 Jun 2021 04:19:15 -0700 (PDT)
Date:   Wed, 02 Jun 2021 04:19:15 -0700
In-Reply-To: <YLdo77SkmGLgPUBi@casper.infradead.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000020d4a05c3c6a1bd@google.com>
Subject: Re: [syzbot] WARNING in idr_get_next
From:   syzbot <syzbot+f7204dcf3df4bb4ce42c@syzkaller.appspotmail.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     anmol.karan123@gmail.com, bjorn.andersson@linaro.org,
        coreteam@netfilter.org, davem@davemloft.net, dsahern@kernel.org,
        ebiggers@google.com, ebiggers@kernel.org, eric.dumazet@gmail.com,
        fw@strlen.de, kadlec@netfilter.org, kuba@kernel.org,
        linux-fsdevel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, manivannan.sadhasivam@linaro.org,
        necip@google.com, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, willy@infradead.org,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

> #syz fixed qrtr: Convert qrtr_ports from IDR to XArray

unknown command "fixed"

>
> On Wed, Jun 02, 2021 at 03:30:06AM -0700, syzbot wrote:
>> syzbot suspects this issue was fixed by commit:
>> 
>> commit 43016d02cf6e46edfc4696452251d34bba0c0435
>> Author: Florian Westphal <fw@strlen.de>
>> Date:   Mon May 3 11:51:15 2021 +0000
>
> Your bisect went astray.
>
> -- 
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/YLdo77SkmGLgPUBi%40casper.infradead.org.
