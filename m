Return-Path: <SRS0=S009=3H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F655C32771
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 Jan 2020 22:30:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DEC9246A8
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 Jan 2020 22:30:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbgARWaB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 18 Jan 2020 17:30:01 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:55965 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726997AbgARWaB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 18 Jan 2020 17:30:01 -0500
Received: by mail-io1-f72.google.com with SMTP id z21so17480805iob.22
        for <netfilter-devel@vger.kernel.org>; Sat, 18 Jan 2020 14:30:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=yYySPTzXjesI6rMbrrYCnEOoWQeyP6zwNDoBKllcD6s=;
        b=f9yWFqnMjhaKvVOCLt9OtubYxQgvAAgES4/5EcgSN4x0WQvPh6LCVk1Tmw0nTUfQw0
         xn9D2IltoaQCeClwLeBTzb4LIAc7pecXRazF7HZdVCDb/KcYd18t3pJ+hyiAJlIgJGWU
         p5IpGSdD8admrRZJeM9rRgcImdR7d2s2doAiwMGaOdyr2Lj8S9VGIoRg0f23ktP1+YDH
         zaaSgAeb36eKoteITJy0TjXJ1IWYsTHzF6yS0w2odlIvnfVRRvHLU4URw6oS1uytuWtw
         lLUcFMuJoeEIMtQvvNyMKhb2HQcxPui2TQzQW8GcdT7qO4r19fe6SsWNSx3YO59X2IAD
         asOA==
X-Gm-Message-State: APjAAAWz6UzV4l0qSxoFVL1sJIGWXU30urW/B+6e4hYhzX0mwev3eBvv
        2ZhgkI9TGsPEKM60hr98uTE4Yq3Ze+qg9KrNGMlGYBDZnfuM
X-Google-Smtp-Source: APXvYqx1pd31epsuW/G1/6eX4XtJtvHwMaQ8qI1MCUim2ZtcFsWE4ZOYVf2vl7dBgVGnmVgzwNIdSp63LSgF0NEjWlUwyEVcpUX/
MIME-Version: 1.0
X-Received: by 2002:a6b:d214:: with SMTP id q20mr29420477iob.298.1579386600669;
 Sat, 18 Jan 2020 14:30:00 -0800 (PST)
Date:   Sat, 18 Jan 2020 14:30:00 -0800
In-Reply-To: <0000000000006de432059c6cabb1@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004bc94b059c71994f@google.com>
Subject: Re: KASAN: slab-out-of-bounds Read in bitmap_port_gc
From:   syzbot <syzbot+53cdd0ec0bbabd53370a@syzkaller.appspotmail.com>
To:     arvid.brodin@alten.se, coreteam@netfilter.org, davem@davemloft.net,
        fw@strlen.de, gregkh@linuxfoundation.org, jeremy@azazel.net,
        kadlec@netfilter.org, kstewart@linuxfoundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot has bisected this bug to:

commit b9a1e627405d68d475a3c1f35e685ccfb5bbe668
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu Jul 4 00:21:13 2019 +0000

    hsr: implement dellink to clean up resources

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=170438d6e00000
start commit:   25e73aad Merge tag 'io_uring-5.5-2020-01-16' of git://git...
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=148438d6e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=108438d6e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d9290aeb7e6cf1c4
dashboard link: https://syzkaller.appspot.com/bug?extid=53cdd0ec0bbabd53370a
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17eb74c9e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14db11d1e00000

Reported-by: syzbot+53cdd0ec0bbabd53370a@syzkaller.appspotmail.com
Fixes: b9a1e627405d ("hsr: implement dellink to clean up resources")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
