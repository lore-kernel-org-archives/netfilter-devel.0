Return-Path: <SRS0=gL2e=VZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15947C433FF
	for <netfilter-devel@archiver.kernel.org>; Sun, 28 Jul 2019 14:20:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E96EF214C6
	for <netfilter-devel@archiver.kernel.org>; Sun, 28 Jul 2019 14:20:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbfG1OUC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 28 Jul 2019 10:20:02 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:54600 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbfG1OUB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 28 Jul 2019 10:20:01 -0400
Received: by mail-io1-f71.google.com with SMTP id n8so64590811ioo.21
        for <netfilter-devel@vger.kernel.org>; Sun, 28 Jul 2019 07:20:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=hnSE0IkAtQQd9LTTGkd+F6q8mkeCAgFd7SlsTWCyTMI=;
        b=qLsL0eemTNfk4PnUhYhCHRH8uPs+LqMzdE6KwfybtZckY90eM/B4HQN2OQLbBTXIN+
         DGJGhy3a/buMggJF6Nlji0voq+8DTPHselmTgRDaE5zGCH0K4h74hN5wkl8aFfcG1yvo
         xj8pAn0uGKItZUowbGv1v35+D2pibU9ZDihLSv1s7ZFjeYeSvQofEsu1TGuo+e2s+KY5
         8o6Cc3BLuWFngFNv5GZtlSCPsjMqrwXduuQeKK/E3vsR8j77NPnhPgfKWcmwnY2VIgFh
         Sxt/glhqQgSgD+p1cmc0dZsf3Tg4ff1fGpEVogjfchEDy3tFAENHSLTo1YlOBAfB6m/1
         IODA==
X-Gm-Message-State: APjAAAWM9/2cDx5dj2rTnUYMqNB/22XRocoows4oA0nhBDWMuXT6R6UC
        RtWFntcn+AWX8v9+lK0FJs6TgqtFBZNSayP54EGTyycjbrT5
X-Google-Smtp-Source: APXvYqzqsQPOZw9eJjrE3cvYQcF0WB7rEVn52ueiw3GFmGkorKwxWzihfkn52GZd9Jx4mk8mOoeNflmypz7lP+W90dHc9moAjCoN
MIME-Version: 1.0
X-Received: by 2002:a5d:924e:: with SMTP id e14mr88096039iol.215.1564323600914;
 Sun, 28 Jul 2019 07:20:00 -0700 (PDT)
Date:   Sun, 28 Jul 2019 07:20:00 -0700
In-Reply-To: <0000000000005e6124058c0cbdbe@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008be1b2058ebe7805@google.com>
Subject: Re: memory leak in fdb_create
From:   syzbot <syzbot+88533dc8b582309bf3ee@syzkaller.appspotmail.com>
To:     bridge@lists.linux-foundation.org, bsingharora@gmail.com,
        coreteam@netfilter.org, davem@davemloft.net, duwe@suse.de,
        kaber@trash.net, kadlec@blackhole.kfki.hu,
        linux-kernel@vger.kernel.org, mingo@redhat.com, mpe@ellerman.id.au,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        nikolay@cumulusnetworks.com, pablo@netfilter.org,
        roopa@cumulusnetworks.com, rostedt@goodmis.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot has bisected this bug to:

commit 04cf31a759ef575f750a63777cee95500e410994
Author: Michael Ellerman <mpe@ellerman.id.au>
Date:   Thu Mar 24 11:04:01 2016 +0000

     ftrace: Make ftrace_location_range() global

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1538c778600000
start commit:   abf02e29 Merge tag 'pm-5.2-rc6' of git://git.kernel.org/pu..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1738c778600000
console output: https://syzkaller.appspot.com/x/log.txt?x=1338c778600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=56f1da14935c3cce
dashboard link: https://syzkaller.appspot.com/bug?extid=88533dc8b582309bf3ee
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16de5c06a00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10546026a00000

Reported-by: syzbot+88533dc8b582309bf3ee@syzkaller.appspotmail.com
Fixes: 04cf31a759ef ("ftrace: Make ftrace_location_range() global")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
