Return-Path: <SRS0=RCn+=2A=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3793C43603
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Dec 2019 12:59:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7778207FF
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Dec 2019 12:59:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727310AbfLJM7C (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Dec 2019 07:59:02 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:39164 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727296AbfLJM7B (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Dec 2019 07:59:01 -0500
Received: by mail-io1-f69.google.com with SMTP id u13so13188021iol.6
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Dec 2019 04:59:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=K7gPl1FphJWhh8zq+KZGN6d9O0Mc9hz+Z8xkj8vZdlQ=;
        b=FpqZSMUx/sRElj8CVtmwBAWfMBY3/VYNkZRmLEGe1rnIO2n/a8T/+2bUoQC4asJRcT
         BP9xQB4VUSUprNV/sCew51WOjL4Wli4M8ruDrA+mJIX9jcUmrqUunbggvSmYbrgPkrob
         Otsqsh6tDSF7UydoigJtKg9vfV817Z+xmQ2DPx+6rp6I/wGpO4yEwcAfWLE9X+PUzbFj
         6Tu3jehPdI/xKrlw7rb1x3s90wPEm/VSFwHQizo6zoPwauevAWPuxhZUNmqimmFl3ka3
         j83+74GAl110kaqnZom2KmGNlElH95sa1+5Zyd1rtdeuJwhZGpmfmz9gUSnrf8JR0nhg
         jQNw==
X-Gm-Message-State: APjAAAUY9+xQS2DbND7yA/BO11w6jh+zB6iMcYUd9GgJryt0Z05pueey
        AZCv81RyaHO4+oFnY9X09uUs1l62HdQTfvYeE/z9eTTHbMQ2
X-Google-Smtp-Source: APXvYqwDCe80r9YbW2QQnA0KjjLSvil/nEblKeil0eEsHFedCe59r/gm8ekpcNZa3NtXqCgGqqZ6wrMr2kggORAQDm9RLlN60DpJ
MIME-Version: 1.0
X-Received: by 2002:a92:5e4b:: with SMTP id s72mr32788228ilb.211.1575982741163;
 Tue, 10 Dec 2019 04:59:01 -0800 (PST)
Date:   Tue, 10 Dec 2019 04:59:01 -0800
In-Reply-To: <0000000000007f075c0598f7aa38@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007598ae0599591335@google.com>
Subject: Re: KASAN: slab-out-of-bounds Read in bit_putcs
From:   syzbot <syzbot+998dec6452146bd7a90c@syzkaller.appspotmail.com>
To:     b.zolnierkie@samsung.com, coreteam@netfilter.org,
        davem@davemloft.net, dri-devel@lists.freedesktop.org,
        gwshan@linux.vnet.ibm.com, kaber@trash.net,
        kadlec@blackhole.kfki.hu, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mpe@ellerman.id.au,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, ruscur@russell.cc, stewart@linux.vnet.ibm.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot has bisected this bug to:

commit 2de50e9674fc4ca3c6174b04477f69eb26b4ee31
Author: Russell Currey <ruscur@russell.cc>
Date:   Mon Feb 8 04:08:20 2016 +0000

     powerpc/powernv: Remove support for p5ioc2

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16af042ae00000
start commit:   9455d25f Merge tag 'ntb-5.5' of git://github.com/jonmason/..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=15af042ae00000
console output: https://syzkaller.appspot.com/x/log.txt?x=11af042ae00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7a3b8f5088d4043a
dashboard link: https://syzkaller.appspot.com/bug?extid=998dec6452146bd7a90c
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12fa5c2ee00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12e327f2e00000

Reported-by: syzbot+998dec6452146bd7a90c@syzkaller.appspotmail.com
Fixes: 2de50e9674fc ("powerpc/powernv: Remove support for p5ioc2")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
