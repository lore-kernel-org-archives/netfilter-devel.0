Return-Path: <SRS0=yhqN=4H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A73EC3404C
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Feb 2020 02:08:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38ECF207FD
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Feb 2020 02:08:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbgBSCIC convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Feb 2020 21:08:02 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:37412 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727893AbgBSCIC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Feb 2020 21:08:02 -0500
Received: by mail-io1-f71.google.com with SMTP id p4so15273940ioo.4
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Feb 2020 18:08:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to:content-transfer-encoding;
        bh=4diWwWLXm7lY/GHl3gvscC/1M0a1R7YH2cSj9Fw5eHQ=;
        b=YUfCDRUtKtmOzaMxueoLBr7Hxl58XzxxuA7uGofY/sKym87VJZmOj9ydSiIjkFIYqe
         KIEitkKodgPcjyNYLbY+NIxXg420dZFBpbgcOsX4Y5gKNPUU3MOTI4hjiFygvu7w6WSY
         +Ryl2zzi36E02lKG0qGOmDqmO2CeDEi4pK901owqhX2pGDA7cRJwJ+LXKriMLhI/x7vU
         J/8H825Zyysu6/Lvf3HFaKwbmqwGeos1+PyrPzCPo2CfbjPex7iZeHCR7An6BvfQQUyV
         aguH05V/nSw9j3F8urv7LetOLiEpY3hUAglchqA64vF07rDeIFJrJ11Gp5m4/oDUW9MF
         Yb3A==
X-Gm-Message-State: APjAAAV7+qpxwhrHpEjwSPHQYsa95Uox0+BFAZmMOhAHYsGOsTzPr7gz
        vB0CCjYOamwYj3UVV55j/LoYH17ke+clRQQRkJJ1M2VQimv1
X-Google-Smtp-Source: APXvYqzdxPP1bcYe7a4xOJJ2PZvwgFfZkFkliW3rcWAp+NO+QUzOk5XyZt5pyzhMqqramXLk6gwjJUtyolpYMy0PBvZtFLrsOuX6
MIME-Version: 1.0
X-Received: by 2002:a92:15c2:: with SMTP id 63mr22276770ilv.111.1582078081462;
 Tue, 18 Feb 2020 18:08:01 -0800 (PST)
Date:   Tue, 18 Feb 2020 18:08:01 -0800
In-Reply-To: <000000000000bb0378059c865fdf@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000d774c059ee442e6@google.com>
Subject: Re: KASAN: use-after-free Read in bitmap_ip_destroy
From:   syzbot <syzbot+8b5f151de2f35100bbc5@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        coreteam@netfilter.org, davem@davemloft.net,
        florent.fourcot@wifirst.fr, fw@strlen.de, jeremy@azazel.net,
        johannes.berg@intel.com, kadlec@blackhole.kfki.hu,
        kadlec@netfilter.org, linux-kernel@vger.kernel.org,
        lipeng321@huawei.com, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com, tanhuazhong@huawei.com
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

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17fc79b5e00000
start commit:   8f8972a3 Merge tag 'mtd/fixes-for-5.5-rc7' of git://git.ke..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=cfbb8fa33f49f9f3
dashboard link: https://syzkaller.appspot.com/bug?extid=8b5f151de2f35100bbc5
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12e22559e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16056faee00000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: netfilter: ipset: use bitmap infrastructure completely

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
