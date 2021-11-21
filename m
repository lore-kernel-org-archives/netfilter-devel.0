Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73B1FC433F5
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Nov 2021 02:24:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236989AbhKUC1L (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 20 Nov 2021 21:27:11 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:42961 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236940AbhKUC1K (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 20 Nov 2021 21:27:10 -0500
Received: by mail-io1-f72.google.com with SMTP id n25-20020a056602341900b005e7a312f86dso8653120ioz.9
        for <netfilter-devel@vger.kernel.org>; Sat, 20 Nov 2021 18:24:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=LtUl4z87GOaDU5n0H8iK+P9twUYQ08LpbtGLszWSXRc=;
        b=FAfhBmgsANhmT0v2hb6pEujmtlzggji3l8gLuqMW8I6HOcdFVsRL+hy8pUmStErhyx
         1AGNXAiebc/aTE3eB6znKBhfELJ3hD/3R8fhZBAUap4SxPQolpPX+Kh77Lnvx2QiosEp
         f5j1yLUkOXm/zZ06zIfXjj5j7MMHzSuYbGTRWLH27KPXmDmb6IQOvsipVDs13748rer5
         pVgzSfcQdLE2dseNSvRmB5/yqnmLu10KNtdwB7QzCcR+0oCsLpvkOh9iQ1F24tVeUniv
         mv5oD59lALivn65xcAGRTGp4S1QF1ypYD53jq3Fk577520SVULbu4JpBo+4AScABIlwy
         VZ+w==
X-Gm-Message-State: AOAM5321U3mb0lBtL/s0mxzbrKUJ1Q8iz1bgc188ql8A4bK3pqHxt4/n
        aKq6pVD/jdG+5QXQVpOVkdylgSQKnTlCRsT+6XJvs5dLGskx
X-Google-Smtp-Source: ABdhPJyLC4dN9+5VCm/mej8aJrMaFCsJiYnTKo9BvfORLV/ZGN5kSEAKCIIBTbE9HCZ+ugiVq5QX+g5u7/0gwFXWS1buNYxVh4Ym
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:18c5:: with SMTP id s5mr13033774ilu.193.1637461446245;
 Sat, 20 Nov 2021 18:24:06 -0800 (PST)
Date:   Sat, 20 Nov 2021 18:24:06 -0800
In-Reply-To: <000000000000e79ab005a56292f5@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d6442705d143337a@google.com>
Subject: Re: [syzbot] WARNING in cgroup_finalize_control
From:   syzbot <syzbot+9c08aaa363ca5784c9e9@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        cgroups@vger.kernel.org, christian@brauner.io,
        coreteam@netfilter.org, daniel@iogearbox.net, davem@davemloft.net,
        hannes@cmpxchg.org, john.fastabend@gmail.com, kaber@trash.net,
        kadlec@blackhole.kfki.hu, kafai@fb.com, kpsingh@chromium.org,
        linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org,
        lizefan.x@bytedance.com, lizefan@huawei.com, longman@redhat.com,
        marcelo.leitner@gmail.com, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, nhorman@tuxdriver.com,
        pablo@netfilter.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, tj@kernel.org,
        vyasevich@gmail.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 7ee285395b211cad474b2b989db52666e0430daf
Author: Waiman Long <longman@redhat.com>
Date:   Sat Sep 18 22:53:08 2021 +0000

    cgroup: Make rebind_subsystems() disable v2 controllers all at once

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12232c06b00000
start commit:   442489c21923 Merge tag 'timers-core-2020-08-04' of git://g..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=b3f0df8558780a7d
dashboard link: https://syzkaller.appspot.com/bug?extid=9c08aaa363ca5784c9e9
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14148c62900000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: cgroup: Make rebind_subsystems() disable v2 controllers all at once

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
