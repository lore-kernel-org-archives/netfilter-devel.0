Return-Path: <SRS0=Z7Wb=5B=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B793C0044D
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Mar 2020 12:49:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D08A205ED
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Mar 2020 12:49:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731063AbgCPMtF convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Mar 2020 08:49:05 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:35678 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731060AbgCPMtE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Mar 2020 08:49:04 -0400
Received: by mail-io1-f69.google.com with SMTP id w16so11547756iot.2
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Mar 2020 05:49:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to:content-transfer-encoding;
        bh=bbgjCSG0GMx48AI+Nh/K6rSe5vletqIPxakfsmtyduw=;
        b=pgN+p+a5cxOjzzyaTqtqnotWBxI8USScDvuhKSBoBX//jAENw8C1Ny2iO6S/jnuHEP
         JFO//6DQ22xr8W1nEt6LGp3wJV2c5Brq5tn1NBVx1K+XPXYXJkuUKvtiZX58xjxJpV51
         P08kk+ENbKhx5r21wujRO68Gg6wiaD2ZiGuQC9Xs44xH0vw3qZAuGSappHB3XwoYD0rh
         soJdvcnrAIuKvbfUKRrH4cqFY6iKZE1csMhwS8ihSoOerSFxQSPU9fgj7x2Fog/LhW8M
         5ptaJkL+AYRiZMDsDjWWP4fTzXlYXNmOI6YvLtUcuVgogUhzCXCAzM0txSPxlG5QRB+Q
         8eNA==
X-Gm-Message-State: ANhLgQ1mZIh7m7Dvi0a326yKw296WAj2stAqCeU4PpCh9SMPIUIvmTH5
        lYGgOCScnaJEOa1031suNHeAEpSn1CbkTxX3+ZManlwziYg2
X-Google-Smtp-Source: ADFU+vue7B9fHGoWNVwlgwrWGWkXeorIo9SBr4w0t4qGXj0x5F7298EMNFAO00Xn0od3oIodZxvMr/pdtB+0Ajok3FT03wHErLf5
MIME-Version: 1.0
X-Received: by 2002:a92:d789:: with SMTP id d9mr455830iln.301.1584362942791;
 Mon, 16 Mar 2020 05:49:02 -0700 (PDT)
Date:   Mon, 16 Mar 2020 05:49:02 -0700
In-Reply-To: <00000000000043aa29059c91459e@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000066871f05a0f83e9d@google.com>
Subject: Re: KASAN: slab-out-of-bounds Read in bitmap_ipmac_gc
From:   syzbot <syzbot+c1a1fb435465986efe35@syzkaller.appspotmail.com>
To:     a@unstable.cc, allison@lohutok.net,
        b.a.t.m.a.n@lists.open-mesh.org, coreteam@netfilter.org,
        davem@davemloft.net, fw@strlen.de, gregkh@linuxfoundation.org,
        info@metux.net, jeremy@azazel.net, kadlec@blackhole.kfki.hu,
        kadlec@netfilter.org, kstewart@linuxfoundation.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com,
        liuyonglong@huawei.com, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, salil.mehta@huawei.com, sbrivio@redhat.com,
        shuliubin@huawei.com, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        yisen.zhuang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit 32c72165dbd0e246e69d16a3ad348a4851afd415
Author: Kadlecsik József <kadlec@blackhole.kfki.hu>
Date:   Sun Jan 19 21:06:49 2020 +0000

    netfilter: ipset: use bitmap infrastructure completely

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1074c2a9e00000
start commit:   d96d875e Merge tag 'fixes_for_v5.5-rc8' of git://git.kerne..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=cf8e288883e40aba
dashboard link: https://syzkaller.appspot.com/bug?extid=c1a1fb435465986efe35
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14e36185e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=104a7a11e00000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: netfilter: ipset: use bitmap infrastructure completely

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
