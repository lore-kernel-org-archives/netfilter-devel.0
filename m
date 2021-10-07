Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68696C433FE
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Oct 2021 13:20:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D37F61248
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Oct 2021 13:20:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233197AbhJGNWA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 Oct 2021 09:22:00 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:39457 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232893AbhJGNWA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Oct 2021 09:22:00 -0400
Received: by mail-il1-f200.google.com with SMTP id g1-20020a056e02130100b00258dfe95241so3911350ilr.6
        for <netfilter-devel@vger.kernel.org>; Thu, 07 Oct 2021 06:20:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=ta8TFCyBY1gpWCj21ajzUB9frfUQOUQio86Er8sxqeo=;
        b=iGwPxnHCA2HxYmX5d7jkkpyq2K6CwaDddwsDQ9e6uFU2JbuniXCB9MmAv2gqvAeDI6
         Kjqy4Ii5GcWAjsnzrw8DCtVqSP32TKz0M7L+Ab9CWcfJZa452GF6FocwdV/TAkZBWy+C
         mIjHxr3ZVi6GliROawFWHB08/bQxVXGNegq3nmNcvrRArEWMwAbtDm+irAgO28Vc+Tg5
         Z6GI1a881KkPj6fdw1sQ3oxcxmUM9JuwYE1pccUS1EE5ulREjc9Vb3HJZ561Pc4Vwyv1
         Pmibc3GNBpPDYBCdXalojU/1Xxqd2psdzhD9NCXxPzLIf+ZXYZ759YgErpGPjPCq3Wsm
         8mGg==
X-Gm-Message-State: AOAM531iOo6nvOWSaVMeUWWaOfTZZZKYqtZyQLLRm6qF6U6LFXSG2o6s
        k1SptT3RWagjWwJsT8+ZwOwlyv8pDNudPnDM/kAgnLU9b/vi
X-Google-Smtp-Source: ABdhPJxX+LmOXMIhLmy2MtMP/zvk5EDCKJa7XQPxqftj0hiiK6+wuzEnrRmw2/+EERMeZYDiNCg0lWg48DkTd7v/EVqDJLrP+z0T
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:c2e:: with SMTP id q14mr3187493ilg.109.1633612806720;
 Thu, 07 Oct 2021 06:20:06 -0700 (PDT)
Date:   Thu, 07 Oct 2021 06:20:06 -0700
In-Reply-To: <0000000000000845ce05c9222d57@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000b920e05cdc31f01@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in nf_tables_dump_sets
From:   syzbot <syzbot+8cc940a9689599e10587@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit a499b03bf36b0c2e3b958a381d828678ab0ffc5e
Author: Florian Westphal <fw@strlen.de>
Date:   Mon Sep 13 12:42:33 2021 +0000

    netfilter: nf_tables: unlink table before deleting it

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13018e98b00000
start commit:   f9be84db09d2 net: bonding: bond_alb: Remove the dependency..
git tree:       net-next
kernel config:  https://syzkaller.appspot.com/x/.config?x=8075b2614f3db143
dashboard link: https://syzkaller.appspot.com/bug?extid=8cc940a9689599e10587
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15fbb98e300000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: netfilter: nf_tables: unlink table before deleting it

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
