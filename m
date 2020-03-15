Return-Path: <SRS0=uBOy=5A=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6DDFC2BB1D
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Mar 2020 05:49:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF89420724
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Mar 2020 05:49:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbgCOFtE convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 15 Mar 2020 01:49:04 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:48012 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbgCOFtD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 15 Mar 2020 01:49:03 -0400
Received: by mail-il1-f199.google.com with SMTP id a4so10794391ili.14
        for <netfilter-devel@vger.kernel.org>; Sat, 14 Mar 2020 22:49:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to:content-transfer-encoding;
        bh=FJOATGVgF+RB8AvqptT57xQBCVKN+MlPkIh/jxrUb5Y=;
        b=AyMCS+Fhsvlyefrn1lqLYuFW9RYalb0TpjA/NhskB5RlvVu6dTrH+eppBSEtS15Kup
         pkvfNxeAACBZi2JW0LVFoW35a0FGeg6qeGVHM5JCXuVojdfbFGmpF9szRLamJErgqKM+
         FSQdfgFPtmZYMQZ3z9rAYuy8ncGcgCj6S9KSH3LceIeyQ7z+TeTeV51Zo52uIdKANp3x
         ZBws78Bu4q7DQpFKSahC4UdJ00NTbnjSg5q5yco6NjBuQwiDeSt/y08Qbx81Ozq4fsPX
         6n1cX1fTmohPzr25gSjWI7WcAsHd41byEcBZe9SMDpGxF0YFdrOz84HvEstlN/bvMYUr
         KVFg==
X-Gm-Message-State: ANhLgQ0lHxgkujd1kaWaNpFoGm+2Im2hjv1HfdV0FtjuOvANyX2QCfE5
        EFXcP8nC3BewGcyPz3Uomdnzap1Rb5ChW1jC/ypfaNjfe3EF
X-Google-Smtp-Source: ADFU+vtjWrHuYWHmtJ+7R/F21gT5LEveKjWUsRf8UObsGMOlzh5S+x+bzsUNrMqUqBppbPPWer/sA+tMDrmnP8e3gzLvu8ysJS2P
MIME-Version: 1.0
X-Received: by 2002:a92:5e14:: with SMTP id s20mr101812ilb.101.1584251342473;
 Sat, 14 Mar 2020 22:49:02 -0700 (PDT)
Date:   Sat, 14 Mar 2020 22:49:02 -0700
In-Reply-To: <000000000000e0ab4c059c79f014@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000080d06405a0de4277@google.com>
Subject: Re: KASAN: slab-out-of-bounds Read in bitmap_port_ext_cleanup
From:   syzbot <syzbot+7b6206fb525c1f5ec3f8@syzkaller.appspotmail.com>
To:     a@unstable.cc, andrew@lunn.ch, b.a.t.m.a.n@lists.open-mesh.org,
        coreteam@netfilter.org, davem@davemloft.net,
        florent.fourcot@wifirst.fr, fw@strlen.de, grygorii.strashko@ti.com,
        j-keerthy@ti.com, jeremy@azazel.net, johannes.berg@intel.com,
        kadlec@blackhole.kfki.hu, kadlec@netfilter.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        mareklindner@neomailbox.ch, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        sw@simonwunderlich.de, syzkaller-bugs@googlegroups.com
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

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=122e7c1de00000
start commit:   d5d359b0 Merge branch 'for-linus' of git://git.kernel.org/..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=cf8e288883e40aba
dashboard link: https://syzkaller.appspot.com/bug?extid=7b6206fb525c1f5ec3f8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15909f21e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=141a1611e00000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: netfilter: ipset: use bitmap infrastructure completely

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
