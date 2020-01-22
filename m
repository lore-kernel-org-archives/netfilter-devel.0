Return-Path: <SRS0=e21D=3L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E10CC2D0DB
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Jan 2020 16:24:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75323217F4
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Jan 2020 16:24:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728925AbgAVQYC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Jan 2020 11:24:02 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:51315 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726061AbgAVQYC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Jan 2020 11:24:02 -0500
Received: by mail-io1-f70.google.com with SMTP id t18so6678iob.18
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Jan 2020 08:24:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=zJCuXAAGGfmdn3xKT3mw1EQTFOCTjnZ0M4GP0MOAhHQ=;
        b=ty2cQIHjx0gAx9FR5eVUdOTtf7/486og0AZRkMovKcCzAf9uAZwoEX8TO4oBYoEl5o
         jJ7nx9hsi+Zgob+KlgDyMzj4XDysEwZ2NwNpVcaNSun6mvkTZJhljNravDBuFUjG08MR
         N8Wi8xX/zav1mUMIkgDx4Zoqspm3nsXZ2vSJN6vFf3gXzLtwGL5wgUWCHso/KbbEDGls
         L+pqL4H8AgvTBqjPI+DKE5KOlSRcg7DEFlRZF5NMC74+i/4omKdDUv7ThX0vgqKUkqb2
         hxFBuU634H3V0+ydXk5rLwxg90OhrU73vTOGe3x0BUlnqMo1q10ABjztDGZZRmiY5eoI
         c2PQ==
X-Gm-Message-State: APjAAAWmRBPC8HpElfApktEjkcbCdKdLWZ/UiGBp2i7xoc7JV4NbvfFz
        /s3F595Cy2b1GX4Jds2h7GRoVHgLdnpnf2bLpqElMJUTIBxi
X-Google-Smtp-Source: APXvYqyJNUTQllpzChKWI3nNnvCCMcKFDK8FOmsX5mlgK8LQmSBOogF54plRyAyGRd+Lr8Pp2HjGvCwNo5+7ENt5YVZMH92fGi8/
MIME-Version: 1.0
X-Received: by 2002:a6b:8e47:: with SMTP id q68mr7385399iod.274.1579710241804;
 Wed, 22 Jan 2020 08:24:01 -0800 (PST)
Date:   Wed, 22 Jan 2020 08:24:01 -0800
In-Reply-To: <000000000000b6da7b059c8110c4@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cf992f059cbcf362@google.com>
Subject: Re: general protection fault in nf_flow_table_offload_setup
From:   syzbot <syzbot+e93c1d9ae19a0236289c@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot has bisected this bug to:

commit a7965d58ddab0253ddfae58bd5c7d2de46ef0f76
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Mon Jan 13 18:02:22 2020 +0000

    netfilter: flowtable: add nf_flow_table_offload_cmd()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17ea59c9e00000
start commit:   4f2c17e0 Merge branch 'master' of git://git.kernel.org/pub..
git tree:       net-next
final crash:    https://syzkaller.appspot.com/x/report.txt?x=141a59c9e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=101a59c9e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7f93900a7904130d
dashboard link: https://syzkaller.appspot.com/bug?extid=e93c1d9ae19a0236289c
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=166fea6ee00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=108d6185e00000

Reported-by: syzbot+e93c1d9ae19a0236289c@syzkaller.appspotmail.com
Fixes: a7965d58ddab ("netfilter: flowtable: add nf_flow_table_offload_cmd()")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
