Return-Path: <SRS0=uBOy=5A=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49F73C0044D
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Mar 2020 02:13:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28FF32076A
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Mar 2020 02:13:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727222AbgCOCNo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 14 Mar 2020 22:13:44 -0400
Received: from mail-qt1-f199.google.com ([209.85.160.199]:57336 "EHLO
        mail-qt1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727740AbgCOCNn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 14 Mar 2020 22:13:43 -0400
Received: by mail-qt1-f199.google.com with SMTP id c13so12833080qtq.23
        for <netfilter-devel@vger.kernel.org>; Sat, 14 Mar 2020 19:13:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=lcIB99Oc70nccWilUatyGo7bA1aJbKIH0bAnGGmG+HI=;
        b=X8rsuJlYJ8eazM1O3Ca7r/XWddDBmaqY4PClwYShC2l2BMm5xSK34LEnHLZ5qaZveX
         sd4kP5MLMSzJcQ+LPRizP7mDnuVAd3iHfzHMqLBq7r7G9evY+QYorJqM/ohe3t2zJIRr
         dJWFVIXAauMYTwFqD7I+4NBcNfLqQkBHxeEeroSHfTpItlMG+316rPCbFP5QbxsdgzAu
         MrSL98n1TkYkyAGmFltFI2iL/HYgReG4IYMY4Er3CWO/rJGXcFbOAa11rJJsVF11vCmh
         iPZHN/jBFIYBsYdWSKdiCtpNyKax9xgqk9bG/B6DbBgeaG9Lp+B/H+eStTZRfvfzWd18
         uOPQ==
X-Gm-Message-State: ANhLgQ3Rxm8QYQEreQiUPKzNhobtx5gVsZIhz3XN/AUro8D38+5zCiym
        VEY0k6vjlERxh9skXgZZhncQtOWPo643xXeXyL3wGBp4JKjF
X-Google-Smtp-Source: ADFU+vtPYT6ImrSmn+n/oX5k44+StXAe5BTdqdlYQ14Q6+IFjM7O2EKZuGalsm3dcqRYn0+Y71MHqpN4yJlLeeGrUHswwpKYHgR0
MIME-Version: 1.0
X-Received: by 2002:a02:cacc:: with SMTP id f12mr13752376jap.99.1584228542130;
 Sat, 14 Mar 2020 16:29:02 -0700 (PDT)
Date:   Sat, 14 Mar 2020 16:29:02 -0700
In-Reply-To: <0000000000001ba488059c65d352@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007f2c5b05a0d8f312@google.com>
Subject: Re: BUG: corrupted list in __nf_tables_abort
From:   syzbot <syzbot+437bf61d165c87bd40fb@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        johan.hedberg@gmail.com, kadlec@netfilter.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, max.chou@realtek.com, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit 34682110abc50ffea7e002b0c2fd7ea9e0000ccc
Author: Max Chou <max.chou@realtek.com>
Date:   Wed Nov 27 03:01:07 2019 +0000

    Bluetooth: btusb: Edit the logical value for Realtek Bluetooth reset

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=113e9919e00000
start commit:   d5d359b0 Merge branch 'for-linus' of git://git.kernel.org/..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=83c00afca9cf5153
dashboard link: https://syzkaller.appspot.com/bug?extid=437bf61d165c87bd40fb
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=168a1611e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=162f0376e00000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: Bluetooth: btusb: Edit the logical value for Realtek Bluetooth reset

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
