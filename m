Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90618C433E0
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Jan 2021 17:35:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5446E23433
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Jan 2021 17:35:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729067AbhAVRcm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 22 Jan 2021 12:32:42 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:46683 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728662AbhAVRVr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Jan 2021 12:21:47 -0500
Received: by mail-io1-f70.google.com with SMTP id m14so9850306ioc.13
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Jan 2021 09:21:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Pk7Ng//oZp6bx3wVbtVGOjayazYiW5CoL8C/yLltJEI=;
        b=Omowdj9HaHUJeg6NMbrUKFVbTfwKYEUkSE2n6K17w1kSP+rxsrcwzN/fBI933p+CTj
         EneE5BaJVN8LEPuaOST2hKoV/lWGGMTFs/qpr6yudAEn2jJpAhHcNWWj4BafvGVmw3w7
         0kU8IxYSn/CQj2dkG9WCReD3QV0KTejlz735OjSg+NvBJVDL2wSA0sxqFmHb7kqfULnc
         fMeZsK1Jt9ZS/6Sv5eHg45mkwKCaJEYZ7UKhEa8YTX7GAC3suZmzeOf5sXhekPZsvsTh
         1TC1Tgn9Nc0lxXQPeakYSyH3n47/xuksHRSv3QUcFjdBguLKj5Xc8x08rtNLiTxCy5Ct
         Wwqw==
X-Gm-Message-State: AOAM5334z0MbwuRvohyv2bB6g1PbBor/kU91Iy1vXFob7Sn21Rbi0ddQ
        5y+UKKsRFSZoGiGENG+836Q1IuD3369KjwVbztXUG0I5gfTx
X-Google-Smtp-Source: ABdhPJwuxS5IKE8JH++C9E5iRtlObmCnWu4CK74jGYoTCgwtMlPdCoSd+1qaXik20vfyPhex6LbwlMtwbLleEB929XQ3egRqvMN8
MIME-Version: 1.0
X-Received: by 2002:a6b:4003:: with SMTP id k3mr4151669ioa.105.1611336066630;
 Fri, 22 Jan 2021 09:21:06 -0800 (PST)
Date:   Fri, 22 Jan 2021 09:21:06 -0800
In-Reply-To: <000000000000a358f905ae6b5dc6@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000dd897e05b9806982@google.com>
Subject: Re: KASAN: use-after-free Read in dump_schedule
From:   syzbot <syzbot+621fd33c0b53d15ee8de@syzkaller.appspotmail.com>
To:     anant.thazhemadam@gmail.com, anmol.karan123@gmail.com,
        coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        jhs@mojatatu.com, jiri@resnulli.us, kadlec@netfilter.org,
        kuba@kernel.org, leandro.maciel.dorileo@intel.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        subashab@codeaurora.org, syzkaller-bugs@googlegroups.com,
        vedang.patel@intel.com, xiyou.wangcong@gmail.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit cc00bcaa589914096edef7fb87ca5cee4a166b5c
Author: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Date:   Wed Nov 25 18:27:22 2020 +0000

    netfilter: x_tables: Switch synchronization to RCU

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10879d68d00000
start commit:   59126901 Merge tag 'perf-tools-fixes-for-v5.9-2020-09-03' ..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=3c5f6ce8d5b68299
dashboard link: https://syzkaller.appspot.com/bug?extid=621fd33c0b53d15ee8de
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=152c3af9900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12213b71900000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: netfilter: x_tables: Switch synchronization to RCU

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
