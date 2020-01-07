Return-Path: <SRS0=BUQT=24=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5CDFC32771
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Jan 2020 01:28:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FF8120715
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Jan 2020 01:28:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbgAGB2C (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Jan 2020 20:28:02 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:53365 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727295AbgAGB2B (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Jan 2020 20:28:01 -0500
Received: by mail-io1-f71.google.com with SMTP id m5so25434887iol.20
        for <netfilter-devel@vger.kernel.org>; Mon, 06 Jan 2020 17:28:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=75DRJK5klYoLUbzgyGRVpTRFYRrPHK+zNd4vNtL85ZQ=;
        b=ktHX2aMZlBUdFi6URUnxymtPY/KDwk8zcx4WbyutU8RbHzGRo0+oKs1p0p5ndA70kg
         2ZROUth2K0WHEHV8w5gZ038plFyuAd4rP+Lpj/bKgDaQO8DcSq7HsvRdMDkTVIXbnnNM
         x5vQj6QIGJzswIGsGwQ6EVoHvzWTYkIGQls/N0KQLQ+i7lNxG/P7hpz6I1L3SuAZzuU5
         JuFnwzM6iJrPqQxYE+maZPjXTejwuVdvFKtqLojFM8PYluP76hn6P4TkI5nTRMAq2qOe
         q9QDwCz+dA+Uh7lwh4R8+4gdRqqiRyvMtPv/fgsWeE1i9KrPhY3aohuRLP/eZVWceybL
         UpCg==
X-Gm-Message-State: APjAAAVmjc+Y/2/G+zjMdStskokTRGkYgtEVR3ULapzsVPJE/Ou1wVub
        NCMFtN0y69faRVQC4cSiqPwN128eZEBCxaXlAmBvko89BlbZ
X-Google-Smtp-Source: APXvYqze6nKMW0nX6ASAFlo5hVUFSK6rrj7ZAUCJAj0dZPg3taWf89Wj800pPzrot4VgciXRshJGrcRY8N62dRXGw0WFccatqMpz
MIME-Version: 1.0
X-Received: by 2002:a92:d151:: with SMTP id t17mr73212526ilg.175.1578360481266;
 Mon, 06 Jan 2020 17:28:01 -0800 (PST)
Date:   Mon, 06 Jan 2020 17:28:01 -0800
In-Reply-To: <0000000000009cd5e0059b7eb836@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d04359059b82afd9@google.com>
Subject: Re: general protection fault in dccp_timeout_nlattr_to_obj
From:   syzbot <syzbot+46a4ad33f345d1dd346e@syzkaller.appspotmail.com>
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

commit dd2934a95701576203b2f61e8ded4e4a2f9183ea
Author: Florian Westphal <fw@strlen.de>
Date:   Mon Sep 17 10:02:54 2018 +0000

     netfilter: conntrack: remove l3->l4 mapping information

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10957485e00000
start commit:   d89091a4 macb: Don't unregister clks unconditionally
git tree:       net
final crash:    https://syzkaller.appspot.com/x/report.txt?x=12957485e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=14957485e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f2f3ef188b7e16cf
dashboard link: https://syzkaller.appspot.com/bug?extid=46a4ad33f345d1dd346e
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12ff2869e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16693751e00000

Reported-by: syzbot+46a4ad33f345d1dd346e@syzkaller.appspotmail.com
Fixes: dd2934a95701 ("netfilter: conntrack: remove l3->l4 mapping  
information")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
