Return-Path: <SRS0=4QBM=ZU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99624C43215
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Nov 2019 10:30:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71A4021774
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Nov 2019 10:30:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbfK1KaB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Nov 2019 05:30:01 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:47102 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbfK1KaB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Nov 2019 05:30:01 -0500
Received: by mail-il1-f199.google.com with SMTP id i74so21829747ild.13
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Nov 2019 02:30:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=1y+8h0adrUwE7n/UFRdlXn6lrWhJARMArZmc7WSZSbo=;
        b=aTKhGumgWORAP+jNE48IfTwxgxzhynSuyuxxZafEvKHUphMh1tctW5c8qP0ghBVE0J
         yKWM0SPKUQ65uGYYor0W5g3Ysh9dPXZqiYgFGotdwXg2VkUohkQ8zm9KKQ8VP6EGxgCQ
         9YO1fFrNR/HXm3xKW/J1bO26kl0gzXg3UiribLtQTBQVx2Mq7VbSNTbKgnZ3J6bq2yv0
         G58CU80cYEqibH+0VtehscG77DNfBA8od3h8KAu/Iudx4hwtc14B/o/W2SbBCnBUh9gd
         6Xeg1vRA1ZNeHVvQqbU9G+O7Uj2qgN7do6LoZyAQ8x5522IS/1OTYOMNFJisB8JUs/eS
         rM8A==
X-Gm-Message-State: APjAAAVxSpqFHBLufprbzLI3gbf2uENvKtRxuWlYPbjR+tga4JJcyTTp
        VEARS1J99usDQCV3Be0/MRy7ufiOx0dqmltKhoFjEd439glu
X-Google-Smtp-Source: APXvYqw2P2kVfRCOmAlhCFdPp4pODsE7Gp3HDeRuvO52RgpRAmsfSGU8ZjG8MAIR7k8Tm/JF3bkAGnvJEgGs1eN+T2lG1oJs2xsz
MIME-Version: 1.0
X-Received: by 2002:a02:cd31:: with SMTP id h17mr407619jaq.94.1574937000680;
 Thu, 28 Nov 2019 02:30:00 -0800 (PST)
Date:   Thu, 28 Nov 2019 02:30:00 -0800
In-Reply-To: <0000000000003872fd0568da185f@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007825cd05986598e6@google.com>
Subject: Re: KASAN: use-after-free Read in ccid2_hc_tx_packet_recv
From:   syzbot <syzbot+554ccde221001ab5479a@syzkaller.appspotmail.com>
To:     alexey.kodanev@oracle.com, coreteam@netfilter.org,
        davem@davemloft.net, dccp@vger.kernel.org, dsahern@gmail.com,
        edumazet@google.com, fw@strlen.de, gerrit@erg.abdn.ac.uk,
        kadlec@blackhole.kfki.hu, keescook@chromium.org,
        kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, soheil@google.com,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot has bisected this bug to:

commit 3fa6f616a7a4d0bdf4d877d530456d8a5c3b109b
Author: David Ahern <dsahern@gmail.com>
Date:   Mon Aug 7 15:44:17 2017 +0000

     net: ipv4: add second dif to inet socket lookups

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=141e882ae00000
start commit:   b5069438 Merge branch 'stable/for-linus-4.17' of git://git..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=161e882ae00000
console output: https://syzkaller.appspot.com/x/log.txt?x=121e882ae00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=982e2df1b9e60b02
dashboard link: https://syzkaller.appspot.com/bug?extid=554ccde221001ab5479a
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1363ccb7800000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1272e2b7800000

Reported-by: syzbot+554ccde221001ab5479a@syzkaller.appspotmail.com
Fixes: 3fa6f616a7a4 ("net: ipv4: add second dif to inet socket lookups")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
