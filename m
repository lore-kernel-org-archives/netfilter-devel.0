Return-Path: <SRS0=MXnI=C7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4456AC4363D
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Sep 2020 04:20:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 179D623A34
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Sep 2020 04:20:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbgIVEUI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Sep 2020 00:20:08 -0400
Received: from mail-il1-f205.google.com ([209.85.166.205]:34571 "EHLO
        mail-il1-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726982AbgIVEUI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Sep 2020 00:20:08 -0400
Received: by mail-il1-f205.google.com with SMTP id i18so4354958ils.1
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Sep 2020 21:20:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=0rHm8bXbukk50V2tgkQM0HsC/iM/PUt9OO0NuPfACHA=;
        b=cXl8Xk2q4dkFm5kyoDk1+UzAvq7rUoP/JKGHj0I736rFZ0JRPUVYzyAq78wndSmitV
         k/FbbrxqFmzHC1F9a/4nsDA5eJ8LBaMgIIyPKQPHmiZ8nNAqpbfNLVDDXUBMqEF9HHcx
         CsKqO4R5kRpEFVEt1Gf2klyJ9Wq2CSXnyTwpRP12iDli9lCGuR39/jwyN+AM+iMRaAs5
         iaKPYNc8YnddLeFEIVma5pg7DeC+S/kIr2zzQzrikG9XxBbPQkEE4tnMgMZNaGjWF33Z
         plMTafK44RCqeTORlW6PQIJYCWRwPchWZqIY/jjhDK2ZwEpHd2eGRrJi7uKtuaFJofyR
         8MhA==
X-Gm-Message-State: AOAM533HDWKkfmj3SvKUfqx5yMVQbNjwnX3hq1khHUrEAznhvrEK6RJx
        tASeswfAd8l6SffQERuf/7ewVcRkXwF7zHgUTbK9xPj+jN5S
X-Google-Smtp-Source: ABdhPJy53+Vstd8n28VPXTz7cOxvgyh0jXV9alO5jFC2ZI34K8SZzeOB6BRWrJQPKXyc1OsRfUJmrB7ijvnuooyvcrjNcJ7mVpx4
MIME-Version: 1.0
X-Received: by 2002:a92:6e0f:: with SMTP id j15mr2749896ilc.299.1600748407016;
 Mon, 21 Sep 2020 21:20:07 -0700 (PDT)
Date:   Mon, 21 Sep 2020 21:20:07 -0700
In-Reply-To: <00000000000082559e05afc6b97a@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002cd54805afdf483f@google.com>
Subject: Re: UBSAN: array-index-out-of-bounds in arch_uprobe_analyze_insn
From:   syzbot <syzbot+9b64b619f10f19d19a7c@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, bp@alien8.de, coreteam@netfilter.org,
        davem@davemloft.net, gustavoars@kernel.org, hpa@zytor.com,
        john.stultz@linaro.org, kaber@trash.net, kadlec@blackhole.kfki.hu,
        keescook@chromium.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, wang.yi59@zte.com.cn, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot has bisected this issue to:

commit 4b2bd5fec007a4fd3fc82474b9199af25013de4c
Author: John Stultz <john.stultz@linaro.org>
Date:   Sat Oct 8 00:02:33 2016 +0000

    proc: fix timerslack_ns CAP_SYS_NICE check when adjusting self

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1697348d900000
start commit:   325d0eab Merge branch 'akpm' (patches from Andrew)
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1597348d900000
console output: https://syzkaller.appspot.com/x/log.txt?x=1197348d900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b12e84189082991c
dashboard link: https://syzkaller.appspot.com/bug?extid=9b64b619f10f19d19a7c
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1573a8ad900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=164ee6c5900000

Reported-by: syzbot+9b64b619f10f19d19a7c@syzkaller.appspotmail.com
Fixes: 4b2bd5fec007 ("proc: fix timerslack_ns CAP_SYS_NICE check when adjusting self")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
