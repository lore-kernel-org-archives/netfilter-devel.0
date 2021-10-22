Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4007C433FE
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Oct 2021 17:46:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A325161251
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Oct 2021 17:46:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233617AbhJVRs3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 22 Oct 2021 13:48:29 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:41773 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233524AbhJVRs3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Oct 2021 13:48:29 -0400
Received: by mail-io1-f70.google.com with SMTP id f13-20020a5ec60d000000b005ddbc52304dso3694580iok.8
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Oct 2021 10:46:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=RrHw7TXIiKdbLCANwDy+z6xoVa/oNS++wThBTPoL/HI=;
        b=nC21KYBhV+J/FVqY0f6cBNFF9fMeSjL2wzYQtmv5Z9Y7ga3hYNN9bfrZYA1uIsRzag
         9CDUVlqZ7wfWIW7xfdq2uthqEV5W0qcrdyDzgrbRgrXYbfO1+JNI6dcK0X1ETEUA3L8t
         CRJxroL43kFCq2AUbxn5TH8c8HGxBxXqtFbmePKJATkU10uBI6TT6bk8fD8Kdu25RLN3
         mN7q9fvoiHYpifDbiASFKtO/BKm7JMaCO2kfCkKg/VhDFzhrMl/BZ6z+qjUX1Cem0WF1
         Xx/0ZoV+dbnuIASmiEhaExu+LjDGGE90ipqVm0xsh9IXeojM+bNy1HIrN/GirYl89G89
         vzcQ==
X-Gm-Message-State: AOAM533A6FzeBtRy+rG7hA+W/6EFUF+n8qnIM2QkztPgj0Ib/XXZWkIG
        TYJ2MoiAzUmLQeVeX0OG5IRNRsIMdIRsSwoiL2DlYMjkaAD+
X-Google-Smtp-Source: ABdhPJw6yIyVEJmLjE1guEYATik6TF0vOCw3Equ1/PA4QM9pbSE29jYpfR05Jxmp4ZyNReAsLF56PiiTgLjL0LdBc1iIHrhEq66t
MIME-Version: 1.0
X-Received: by 2002:a02:a60a:: with SMTP id c10mr796118jam.139.1634924771381;
 Fri, 22 Oct 2021 10:46:11 -0700 (PDT)
Date:   Fri, 22 Oct 2021 10:46:11 -0700
In-Reply-To: <000000000000bab70f05b563a6cc@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003b942305cef496a2@google.com>
Subject: Re: [syzbot] WARNING in port100_send_frame_async/usb_submit_urb
From:   syzbot <syzbot+dbec6695a6565a9c6bc0@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com,
        eli.billauer@gmail.com, fw@strlen.de, gregkh@linuxfoundation.org,
        gustavoars@kernel.org, hdanton@sina.com, ingrassia@epigenesys.com,
        k.kozlowski.k@gmail.com, kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, stern@rowland.harvard.edu,
        syzkaller-bugs@googlegroups.com, thierry.escande@collabora.com,
        tiwai@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit e9edc188fc76499b0b9bd60364084037f6d03773
Author: Eric Dumazet <edumazet@google.com>
Date:   Fri Sep 17 22:15:56 2021 +0000

    netfilter: conntrack: serialize hash resizes and cleanups

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1633b4b0b00000
start commit:   c84e1efae022 Merge tag 'asm-generic-fixes-5.10-2' of git:/..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=7be70951fca93701
dashboard link: https://syzkaller.appspot.com/bug?extid=dbec6695a6565a9c6bc0
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17c607f1500000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: netfilter: conntrack: serialize hash resizes and cleanups

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
