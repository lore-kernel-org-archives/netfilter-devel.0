Return-Path: <SRS0=Z7Wb=5B=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D085EC10DCE
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Mar 2020 02:40:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2292206E9
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Mar 2020 02:40:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730482AbgCPCkE convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 15 Mar 2020 22:40:04 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:54240 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729986AbgCPCkE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 15 Mar 2020 22:40:04 -0400
Received: by mail-io1-f70.google.com with SMTP id q24so10787721iot.20
        for <netfilter-devel@vger.kernel.org>; Sun, 15 Mar 2020 19:40:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to:content-transfer-encoding;
        bh=G7pIHMXafOLm3F/2/i2LvBMFMIvTzROgcOUTWFn2X6I=;
        b=LqsYgLpUrT488LcFoQLySwQkHXEHPsg5oKOozyySp4sq5NG7waUWo4LW0lc4wpOdwH
         PMg0pENxjBsQn63Ci5FwoFDYaX/rEGv2JiKVJpQQp20qHYfFnQVTHtuAhRJKza/Km7by
         WsJn5yg0ogErQGRvvBi9fbnvHNcq0GGZC+lmfIEv+0BYc22jM+bsrmKJ7re72x2RqeWb
         Hgp6eDzpQSf/FEBRtA6E6VFnPxDXy6wcZ+U6XxvksPDQjCd5W5Dz39K1bDUXhE7qjzk6
         GZmdsS753vtYuNUf9F3vhZLeBh8dIqik8N5AThqOOzgLz76K8iobOff3+jxoLpEIWuHi
         S7vA==
X-Gm-Message-State: ANhLgQ04WOsVpmho/Mrmza1384kVoFRiftnvSC+avrsGY0yZ8pP8zwdy
        Cue0mJRf6THIOVk/4SsQYrqLnvgiE+wb/9U+K3Qcgjfpva6S
X-Google-Smtp-Source: ADFU+vsoZxccOxRhbL4Y/MIwgxSx220g7zIbktYsAfwneEMRwc/N8lW0/7POXMyHaJ8GuPRqszlVeuTTjg5as1yqhzbhVmbrzHSZ
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3dd:: with SMTP id r29mr2463944jaq.94.1584326403449;
 Sun, 15 Mar 2020 19:40:03 -0700 (PDT)
Date:   Sun, 15 Mar 2020 19:40:03 -0700
In-Reply-To: <000000000000bdb5b2059c865f5c@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007c695f05a0efbc52@google.com>
Subject: Re: KASAN: slab-out-of-bounds Read in bitmap_ip_ext_cleanup
From:   syzbot <syzbot+6491ea8f6dddbf04930e@syzkaller.appspotmail.com>
To:     a@unstable.cc, akpm@linux-foundation.org, allison@lohutok.net,
        arnd@arndb.de, axboe@kernel.dk, b.a.t.m.a.n@lists.open-mesh.org,
        bp@alien8.de, catalin.marinas@arm.com, chris@zankel.net,
        christian.brauner@ubuntu.com, christian@brauner.io,
        coreteam@netfilter.org, dan.carpenter@oracle.com,
        davem@davemloft.net, elena.reshetova@intel.com,
        florent.fourcot@wifirst.fr, fw@strlen.de, geert@linux-m68k.org,
        hare@suse.com, heiko.carstens@de.ibm.com, hpa@zytor.com,
        info@drgreenstore.com, info@metux.net, jcmvbkbc@gmail.com,
        jeremy@azazel.net, johannes.berg@intel.com,
        kadlec@blackhole.kfki.hu, kadlec@netfilter.org,
        linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org,
        linux@armlinux.org.uk, mareklindner@neomailbox.ch,
        mingo@redhat.com, netdev@vger.kernel.org,
        netfilter-core-owner@lists.netfilter.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        peterz@infradead.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        viro@zeniv.linux.org.uk, will@kernel.org, x86@kernel.org
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

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16b8e545e00000
start commit:   d96d875e Merge tag 'fixes_for_v5.5-rc8' of git://git.kerne..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=cf8e288883e40aba
dashboard link: https://syzkaller.appspot.com/bug?extid=6491ea8f6dddbf04930e
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=126748d6e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1385f959e00000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: netfilter: ipset: use bitmap infrastructure completely

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
