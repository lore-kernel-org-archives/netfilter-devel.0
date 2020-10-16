Return-Path: <SRS0=ZKiM=DX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37F72C433DF
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:04:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C16692084C
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:04:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BWppSsQw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406393AbgJPKEQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 16 Oct 2020 06:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394309AbgJPKEQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Oct 2020 06:04:16 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1018AC061755
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Oct 2020 03:04:16 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id k9so1477031qki.6
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Oct 2020 03:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wKROEBD/IeUL91SII+WzarWqrsdhLa/c9UmVE6mp63s=;
        b=BWppSsQwo+mAVW9LyR71BnZ83v8uSOPQ4J6TNvWzVDCjb40W/yOrRu6nqTnWPdMHTO
         O+KlWt2l/nfu3Fuu2UcO7XCuld8J4bW/q+7VGcax8ar29p5QrOZ6STUe1J4G39dqPonM
         cvuVO1X/W59l40O7dE1EiQGrJRpgGNGAdwfe9kAQL+X5mcXKOtHFOv/rJL24x6pfZZQK
         5uxUzF+E7ShV7UIRTkvw2j7/elYFrBtODEx7yx+LXbzKMBV5mSrqNXCoxoxLctqbNMRl
         QEkQCSrgQjCyZIV7yGhPbxglRyXw556xEa1iFoiqlRL8WyioG4AhxY928yZisv7ROneM
         u8ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wKROEBD/IeUL91SII+WzarWqrsdhLa/c9UmVE6mp63s=;
        b=YZaiOIEBYC1XBYBjhlsPmaMfe3rRYkq9v+5uBIFC3cI27mJPz2ex7ahlRlEDg5IL1e
         zU7ZxqtJXm0k2iCFbRbh2L2LPfAgzXtaIf1hLKoJ0CiGqAQ4MFgvZ1R8D0CB8qU/rpe4
         z7Ow1jC2hiuVH4xbeYtF800uV8ilmY5gNsEktfG++17h8bRBwWvozI0eN4HusVSCFP4t
         Q/5LsjX97+kVn2iEd74SYm9ETvo5y9r26ogcEon00b3x/kXv7qmXc5Izk9VGyED7HmB5
         KmRIBbqATVADBWsUr/VBOqPO4PBcIwadM2mGprDgNHu6qazdcHnQvxfNYMu3/pmBQe8v
         ezOQ==
X-Gm-Message-State: AOAM532yEpY7WPBhzfoIWng/LffVro7cFY9XQelNNAJribEoour0/HL4
        pdgQJGz81zDDce1sb42gkGxcdBeQESfWSUKJo4n6h7fwQdLmkA==
X-Google-Smtp-Source: ABdhPJwtcNBk9xTR6ZhXF5xBV+Zg7y49lWRl6s7Yrzhh2V8MBaSP+IiZFZLxjAMUaEISQjS8h3H/DyS3axByd0BMDkw=
X-Received: by 2002:a05:620a:1657:: with SMTP id c23mr3171746qko.231.1602842654929;
 Fri, 16 Oct 2020 03:04:14 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000376ecf05b1b92848@google.com> <CACT4Y+aTPCPRtJ2wJ5P58DijtG2pxXtZm6w=C838YKLKCEdSfw@mail.gmail.com>
 <20201015110203.7cffc1d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <20201015110409.66a8a054@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201015110409.66a8a054@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Fri, 16 Oct 2020 12:04:03 +0200
Message-ID: <CACT4Y+bO-rxU4xVAzopBod5QvJBtNBHzxxvMWnhGArjcGPokgA@mail.gmail.com>
Subject: Re: bpf-next test error: BUG: program execution failed: executor 0:
 exit status 67
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     syzbot <syzbot+5609d37b3a926aad75b7@syzkaller.appspotmail.com>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        syzkaller <syzkaller@googlegroups.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 15, 2020 at 8:04 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > <syzbot+5609d37b3a926aad75b7@syzkaller.appspotmail.com> wrote:
> > > >
> > > > Hello,
> > > >
> > > > syzbot found the following issue on:
> > > >
> > > > HEAD commit:    e688c3db bpf: Fix register equivalence tracking.
> > > > git tree:       bpf-next
> > > > console output: https://syzkaller.appspot.com/x/log.txt?x=13d3c678500000
> > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=ea7dc57e899da16d
> > > > dashboard link: https://syzkaller.appspot.com/bug?extid=5609d37b3a926aad75b7
> > > > compiler:       gcc (GCC) 10.1.0-syz 20200507
> > > >
> > > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > > Reported-by: syzbot+5609d37b3a926aad75b7@syzkaller.appspotmail.com
> > > >
> > > > executing program
> > > > 2020/10/15 14:32:51 BUG: program execution failed: executor 0: exit status 67
> > > > iptable checkpoint filter/2: getsockopt(IPT_SO_GET_INFO) (errno 22)
> > > > loop exited with status 67
> > > >
> > > > iptable checkpoint filter/2: getsockopt(IPT_SO_GET_INFO) (errno 22)
> > > > loop exited with status 67
> > >
> > > +netfilter maintainers
> > >
> > > It seems one of these recent commits broke netfiler.
> > > Since syzkaller uses netfiler for sandboxing, syzbot is currently down
> > > on bpf-next and linux-next. Other trees will follow once they merge
> > > the breakage.
> >
> > Do you have this?
> >
> > d25e2e9388ed ("netfilter: restore NF_INET_NUMHOOKS")
>
> Ah, you're saying it's just linux-next and bpf-next that's down.
> I think the quoted fix will hit bpf-next in a few hours.
>
> Thanks!

Yes, stopped happening. Phew!

#syz fix: netfilter: restore NF_INET_NUMHOOKS
