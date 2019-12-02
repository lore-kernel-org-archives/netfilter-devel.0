Return-Path: <SRS0=20nZ=ZY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12D34C432C3
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 06:47:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D342520715
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 06:47:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WoudGpAX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbfLBGrZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Dec 2019 01:47:25 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:37924 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbfLBGrZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Dec 2019 01:47:25 -0500
Received: by mail-qt1-f196.google.com with SMTP id 14so40327182qtf.5
        for <netfilter-devel@vger.kernel.org>; Sun, 01 Dec 2019 22:47:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=w5F3Y8zqEkCwkUMXUn9FFeKvhwvA4xUSSc7Xy06U26E=;
        b=WoudGpAXy+WLLgqCY/1HXkL7kxkpmMmaAywYNCPy+DV5kFlauvDt+MVGIj3voqs8EB
         a4dMaDFhyaHUPnV2HnAODhoa4UJ4Hdpg9plGJqhykWqQX2UZb5wL6ktmuwP2PnILoY/V
         t4IcagIqscxpDzHd6Ornm0PNMMibtXhiwkbSmQ+uvsXI2QS12RqDEiWpzThWlZcZvgqc
         ajMSS3bm7BLDbzEAAYh/GMjIL+m6EjZC1VQqHEBHs0lRsKNwebEnA5yF00moDshiqY1v
         V2+wqSLocate/712Js6yG63IJS0XSPZ2VPeptYYCyzhhFrV6eXdBTGoc5CFKJKHt8yt3
         2ACQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=w5F3Y8zqEkCwkUMXUn9FFeKvhwvA4xUSSc7Xy06U26E=;
        b=Yp2I5OEK5a+PPO5evvmMb8EMuLPYjXdrJz5jBDD3C1EP2mxhROADpGTE/w+9Er0sQQ
         /6RNBaT9AaGF0wokGcMJRd1RGIfBtMONOnJH8KZqBflIjxalHYBa2foOWw4qIktP30pJ
         JnEduLmRI7BZ8iywmA/+Q7yV2L7qAdY8aUXbjAXhKnRKH2RH3ADJArBOB4Qx0yMyVRcY
         XdgFRyH4XHKOjSK37ImOcsDAXtdiVEERA53geH2h3WTyAPwWx3VPxm5v6VIoPJX+qOop
         yuToDJG5x4tS5oaHK/AupnoHofPoiWX5P7z/JrPtqhuICBI4jX1uvVntFNInNPo3AVFn
         z4Gg==
X-Gm-Message-State: APjAAAV8MYqBn9RnUpu4dc1TsPVd0xClTQ+DpfkXfBRFXf0huFFkJmxa
        jqL0Jt32PNKoIQLtp7HbSNsyDJCA7rD9dkn03ApIWw==
X-Google-Smtp-Source: APXvYqyKDu9/tqAvMtHO6VvbWtZqcaxmYBnv+++IWHqBoEDkHy5Y/Zgs72zDEMHhogHxbnZKh2USvOUFIKpcipPq2AA=
X-Received: by 2002:ac8:ccf:: with SMTP id o15mr65633251qti.380.1575269243204;
 Sun, 01 Dec 2019 22:47:23 -0800 (PST)
MIME-Version: 1.0
References: <000000000000e59aab056e8873ae@google.com> <0000000000000beff305981c5ac6@google.com>
 <20191124193035.GA4203@ZenIV.linux.org.uk> <20191130110645.GA4405@dimstar.local.net>
 <CACT4Y+bg7bZOSg0P9VXq8yG2odAJMg6b6N2fXxbamOmKiz3ohw@mail.gmail.com> <20191201000439.GA15496@dimstar.local.net>
In-Reply-To: <20191201000439.GA15496@dimstar.local.net>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 2 Dec 2019 07:47:11 +0100
Message-ID: <CACT4Y+YhYaEC2of_6bZ6aZxX_kc3+4Li=MZU-MB1RcNr6Z7iww@mail.gmail.com>
Subject: Re: KASAN: use-after-free Read in blkdev_get
To:     Dmitry Vyukov <dvyukov@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Chris Metcalf <cmetcalf@ezchip.com>, coreteam@netfilter.org,
        David Miller <davem@davemloft.net>,
        Chen Gang <gang.chen.5i5j@gmail.com>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Dec 1, 2019 at 1:04 AM Duncan Roe <duncan_roe@optusnet.com.au> wrote:
>
> On Sat, Nov 30, 2019 at 04:53:12PM +0100, Dmitry Vyukov wrote:
> > On Sat, Nov 30, 2019 at 12:06 PM Duncan Roe <duncan_roe@optusnet.com.au> wrote:
> > > > > syzbot has bisected this bug to:
> > > > >
> > > > > commit 77ef8f5177599efd0cedeb52c1950c1bd73fa5e3
> > > > > Author: Chris Metcalf <cmetcalf@ezchip.com>
> > > > > Date:   Mon Jan 25 20:05:34 2016 +0000
> > > > >
> > > > >     tile kgdb: fix bug in copy to gdb regs, and optimize memset
> > > > >
> > > > > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1131bc0ee00000
> > > > > start commit:   f5b7769e Revert "debugfs: inode: debugfs_create_dir uses m..
> > > > > git tree:       upstream
> > > > > final crash:    https://syzkaller.appspot.com/x/report.txt?x=1331bc0ee00000
> > > > > console output: https://syzkaller.appspot.com/x/log.txt?x=1531bc0ee00000
> > > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=709f8187af941e84
> > > > > dashboard link: https://syzkaller.appspot.com/bug?extid=eaeb616d85c9a0afec7d
> > > > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=177f898f800000
> > > > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=147eb85f800000
> > > > >
> > > > > Reported-by: syzbot+eaeb616d85c9a0afec7d@syzkaller.appspotmail.com
> > > > > Fixes: 77ef8f517759 ("tile kgdb: fix bug in copy to gdb regs, and optimize
> > > > > memset")
> > > > >
> > > > > For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> > > >
> > > > Seriously?  How can the commit in question (limited to arch/tile/kernel/kgdb.c)
> > > > possibly affect a bug that manages to produce a crash report with
> > > > RSP: 0018:ffffffff82e03eb8  EFLAGS: 00000282
> > > > RAX: 0000000000000000 RBX: ffffffff82e00000 RCX: 0000000000000000
> > > > RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff81088779
> > > > RBP: ffffffff82e03eb8 R08: 0000000000000000 R09: 0000000000000001
> > > > R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> > > > R13: 0000000000000000 R14: 0000000000000000 R15: ffffffff82e00000
> > > > FS:  0000000000000000(0000) GS:ffff88021fc00000(0000) knlGS:0000000000000000
> > > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > CR2: 000000c420447ff8 CR3: 0000000213184000 CR4: 00000000001406f0
> > > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > > > in it?  Unless something very odd has happened to tile, this crash has
> > > > been observed on 64bit x86; the names of registers alone are enough
> > > > to be certain of that.
> > > >
> > > > And the binaries produced by an x86 build should not be affected by any
> > > > changes in arch/tile; not unless something is very wrong with the build
> > > > system.  It's not even that this commit has fixed an earlier bug that
> > > > used to mask the one manifested here - it really should have had zero
> > > > impact on x86 builds, period.
> > > >
> > > > So I'm sorry, but I'm calling bullshit.  Something's quite wrong with
> > > > the bot - either its build system or the bisection process.
> > >
> > > The acid test would be: does reverting that commit make the problem go away?
> > >
> > > See, for example, https://bugzilla.kernel.org/show_bug.cgi?id=203935
> > >
> > > Cheers ... Duncan.
> >
> > This is done as part of any bisection by definition, right? The test
> > was done on the previous commit (effectively this one reverted) and no
> > crash was observed. Otherwise bisection would have been pointed to a
> > different commit.
> >
> Agree that's what bisecting does. What I had in mind was to make a patch to
> remove the identified commit, and apply that to the most recent revision
> possible. Then see if that makes the problem go away.

I wonder in what percent of cases:
1. It gives signal different from reverting the commit in place.
2. The revert can be cleanly applied to head.
3. The revert does not introduce other bugs.

For this to be worth doing, all these 3 should be reasonably high. I
can imagine 3 may be high (?), but I am not sure about 1 and 2.
