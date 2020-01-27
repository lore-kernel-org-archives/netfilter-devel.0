Return-Path: <SRS0=xF+Z=3Q=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF23EC32771
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Jan 2020 04:01:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF3822067C
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Jan 2020 04:01:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgA0EBE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 26 Jan 2020 23:01:04 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:51427 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726871AbgA0EBD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 26 Jan 2020 23:01:03 -0500
Received: by mail-il1-f198.google.com with SMTP id c12so6357934ilr.18
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Jan 2020 20:01:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=VgaYY37/arJ//cWZJnlZvZwtZBPazlQXq/CIao1WfmQ=;
        b=mNlymUoYjv9enezevcjyCCWL8E31yMojjbyCazerBJYNM4ZbXVNIdc42ztwf6icTcA
         7ubrqA0A6i7sJbXoS0FE/nZsf2FK3XR6h08a/0biRwmVPfc/iqCmyidEZAyj5nHnseON
         f7A0hoNi6UYc/9exmnZqJX2s/Gnd2mThFMi/oh9vX5JiedfG1tu3iRvreJu1/4tz/15q
         T1IOWoFDaxglY8DpBIBs8c7IMZ9C6dLbhOBx6N2+DNMIXuOAO9eKMXhf1qoz+AcBfxiR
         cjhyC1PKTbreUqu2DdM7EhKhnHW5Mxrw8mzU3BE+2/7mtio5C/pST9najGEHsdZGnG4Y
         agPQ==
X-Gm-Message-State: APjAAAUMfITn+FeNxyYoKj/y4D/M8kwLxtqM07VXLgToOjT7V28kpm8F
        YjYUUljbNk4o6mxTp7cAe/AB0uHAzQj4KlPmBvDgXtvZJtR5
X-Google-Smtp-Source: APXvYqysxyvWoFV1hsXw8Jkg2vzZtt8Wscf4J2wj8nn/VWMlh9MEbn8dzfvU/rqOy4eKy13jsOByr26t5WOoeFH66a7eL6jBTpI/
MIME-Version: 1.0
X-Received: by 2002:a02:864b:: with SMTP id e69mr11540998jai.83.1580097663218;
 Sun, 26 Jan 2020 20:01:03 -0800 (PST)
Date:   Sun, 26 Jan 2020 20:01:03 -0800
In-Reply-To: <000000000000dd68d0059c74a1db@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ed3a48059d17277e@google.com>
Subject: Re: KASAN: slab-out-of-bounds Read in bitmap_ip_add
From:   syzbot <syzbot+f3e96783d74ee8ea9aa3@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, allison@lohutok.net,
        aryabinin@virtuozzo.com, coreteam@netfilter.org,
        davem@davemloft.net, elver@google.com, fw@strlen.de,
        gregkh@linuxfoundation.org, info@metux.net, jeremy@azazel.net,
        kadlec@netfilter.org, kstewart@linuxfoundation.org,
        linux-kernel@vger.kernel.org, mark.rutland@arm.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, torvalds@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot has bisected this bug to:

commit 751ad98d5f881df91ba47e013b82422912381e8e
Author: Marco Elver <elver@google.com>
Date:   Fri Jul 12 03:54:00 2019 +0000

    asm-generic, x86: add bitops instrumentation for KASAN

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1287db66e00000
start commit:   244dc268 Merge tag 'drm-fixes-2020-01-19' of git://anongit..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1187db66e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1687db66e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d9290aeb7e6cf1c4
dashboard link: https://syzkaller.appspot.com/bug?extid=f3e96783d74ee8ea9aa3
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1104c495e00000

Reported-by: syzbot+f3e96783d74ee8ea9aa3@syzkaller.appspotmail.com
Fixes: 751ad98d5f88 ("asm-generic, x86: add bitops instrumentation for KASAN")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
