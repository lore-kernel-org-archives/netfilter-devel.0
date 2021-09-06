Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A8B3C433FE
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Sep 2021 05:27:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BD5A61050
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Sep 2021 05:27:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238706AbhIFF0O (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Sep 2021 01:26:14 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:53074 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238267AbhIFF0O (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Sep 2021 01:26:14 -0400
Received: by mail-io1-f71.google.com with SMTP id e18-20020a6b7312000000b005be766a70dbso4383441ioh.19
        for <netfilter-devel@vger.kernel.org>; Sun, 05 Sep 2021 22:25:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=ZvVDoBv3IAH8y1S0lXBguVVm08g+13BDGKyt9/bor9Y=;
        b=jBOd2GmvijOHRNdrdClEpQkKDQZlPsoGoGDqmAMG9tGFBaYyIWlSdm8il2iL60UTci
         eZfDXez1GuuNySAKKJwSLdnpWHdGotCdbjbIq1iBCcr5WIMS+tWb7OulD9ys7WGuTpHw
         CxNS2CaXGfcWXTDHYN/MF0SzgOERCDMFLufQHuhzZKLds4Iqs4S8Aa1V/ygj9bL/fE6Q
         iFNovBljIGeHyNHOUCZBPkqRhrxI3mFwND3ZJe546CM65tYIRvDTzJYrcmLZEz31VUgc
         7OxLLFOoGyvPmVWi7Yv0rnJq/RhbQ+y2jeQ0KDBcons2Wuvblbrf2av4KkQJtYJ7PsIp
         y7rA==
X-Gm-Message-State: AOAM532wATO8sAU7tCH/b49xDgY0bsVoHzgQ6mzD2T/Cvo8tOmbtq4vK
        eTKQUe4JYGaDnFl2o/Lkz1hCDdQzjfccPh6opc3KTSZ5Nn1x
X-Google-Smtp-Source: ABdhPJzd449QRHh060sSTuNCXAhTIrwXmTA69htRCTu+gj5HcaUCJCrRFnuZykGCC4UYH518hB/hhMO85JbepGiR6Qh7k2AHNNjo
MIME-Version: 1.0
X-Received: by 2002:a02:294b:: with SMTP id p72mr9242294jap.0.1630905907569;
 Sun, 05 Sep 2021 22:25:07 -0700 (PDT)
Date:   Sun, 05 Sep 2021 22:25:07 -0700
In-Reply-To: <000000000000ed8c0a05cb1ff6d8@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000486b8b05cb4cdf5c@google.com>
Subject: Re: [syzbot] WARNING: kmalloc bug in nf_tables_newset
From:   syzbot <syzbot+cd43695a64bcd21b8596@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, coreteam@netfilter.org,
        davem@davemloft.net, eric.dumazet@gmail.com, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        torvalds@linux-foundation.org, w@1wt.eu
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot has bisected this issue to:

commit 7661809d493b426e979f39ab512e3adf41fbcc69
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Jul 14 16:45:49 2021 +0000

    mm: don't allow oversized kvmalloc() calls

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15f767b1300000
start commit:   a9c9a6f741cd Merge tag 'scsi-misc' of git://git.kernel.org..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=17f767b1300000
console output: https://syzkaller.appspot.com/x/log.txt?x=13f767b1300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7860a0536ececf0c
dashboard link: https://syzkaller.appspot.com/bug?extid=cd43695a64bcd21b8596
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13281b33300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1077b4b9300000

Reported-by: syzbot+cd43695a64bcd21b8596@syzkaller.appspotmail.com
Fixes: 7661809d493b ("mm: don't allow oversized kvmalloc() calls")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
