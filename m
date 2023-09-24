Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E42FCE7A88
	for <netfilter-devel@archiver.kernel.org>; Sun, 24 Sep 2023 10:59:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbjIXK7Z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 24 Sep 2023 06:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjIXK7Y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 24 Sep 2023 06:59:24 -0400
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com [209.85.160.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 503D7100
        for <netfilter-devel@vger.kernel.org>; Sun, 24 Sep 2023 03:59:18 -0700 (PDT)
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-1bf2e81ce63so9892871fac.1
        for <netfilter-devel@vger.kernel.org>; Sun, 24 Sep 2023 03:59:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695553157; x=1696157957;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jlk+O3J+o0kkp1OKytTuo5mn2nF+ogupL5uOl8zcGuA=;
        b=vZSCiJNTkRGrBxNXkKce6sPK6byjhCNcM5MkFyLlh15gPaBAF+MJjquMGdSVPo26ys
         +jUktvGd10DDj208XO5gVs/fpKYhZxpV7A8bPR0ZC8shmWESU7lp80WwMsExEB5SSf4S
         PjYWOzX4Wjm5q52lLfhXTle4D0MPERAvQa05ic/42xFgZQ6PzAytfXVMVAuI0NxFObrY
         5pMxmKnmpKtjBRyRTi88LfwKiVsd1RyN7Jz/5t0ojZIy5D8xenX3PZR8SLg8v6EEz03x
         ghxrPH48Yc4rwB7MSVxpJXo55s/ozbVwZB+c4R96pzuBiWmXduUXJvseVdj2hhqOVyag
         5bgg==
X-Gm-Message-State: AOJu0YylzNeWqzfqi6+Gg62cCKDkjy3dFIHAiCP7B2p1GMNamm4jmZYx
        3G2QdSzmeFz8i38R3YmoHcVmmNOyVC1hKsw4t9Y8fVfxIU35
X-Google-Smtp-Source: AGHT+IGp8vx1D9jMEB/i7wblpIR1qbSKkkYzRnZBs6mxLXQ6LjSZuwUrXWRzpxMUsQ4CTqUu0G4qMtnatkOXoDUjowcVzPeX9afh
MIME-Version: 1.0
X-Received: by 2002:a05:6870:9a93:b0:1d6:a9da:847 with SMTP id
 hp19-20020a0568709a9300b001d6a9da0847mr2947177oab.0.1695553157625; Sun, 24
 Sep 2023 03:59:17 -0700 (PDT)
Date:   Sun, 24 Sep 2023 03:59:17 -0700
In-Reply-To: <0000000000000c439a05daa527cb@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a87e66060618bb7e@google.com>
Subject: Re: [syzbot] [netfilter?] INFO: rcu detected stall in gc_worker (3)
From:   syzbot <syzbot+eec403943a2a2455adaa@syzkaller.appspotmail.com>
To:     bpf@vger.kernel.org, coreteam@netfilter.org, davem@davemloft.net,
        dvyukov@google.com, edumazet@google.com, fw@strlen.de,
        gautamramk@gmail.com, hdanton@sina.com, jhs@mojatatu.com,
        jiri@resnulli.us, kadlec@netfilter.org, kuba@kernel.org,
        lesliemonis@gmail.com, linux-kernel@vger.kernel.org,
        mohitbhasi1998@gmail.com, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pabeni@redhat.com,
        pablo@netfilter.org, paulmck@kernel.org, sdp.sachin@gmail.com,
        syzkaller-bugs@googlegroups.com, tahiliani@nitk.edu.in,
        tglx@linutronix.de, vsaicharan1998@gmail.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot has bisected this issue to:

commit ec97ecf1ebe485a17cd8395a5f35e6b80b57665a
Author: Mohit P. Tahiliani <tahiliani@nitk.edu.in>
Date:   Wed Jan 22 18:22:33 2020 +0000

    net: sched: add Flow Queue PIE packet scheduler

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15c5748e680000
start commit:   d4a7ce642100 igc: Fix Kernel Panic during ndo_tx_timeout c..
git tree:       net
final oops:     https://syzkaller.appspot.com/x/report.txt?x=17c5748e680000
console output: https://syzkaller.appspot.com/x/log.txt?x=13c5748e680000
kernel config:  https://syzkaller.appspot.com/x/.config?x=77b9a3cf8f44c6da
dashboard link: https://syzkaller.appspot.com/bug?extid=eec403943a2a2455adaa
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1504b511a80000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=137bf931a80000

Reported-by: syzbot+eec403943a2a2455adaa@syzkaller.appspotmail.com
Fixes: ec97ecf1ebe4 ("net: sched: add Flow Queue PIE packet scheduler")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
