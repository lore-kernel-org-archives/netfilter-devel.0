Return-Path: <SRS0=uIll=BN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EC3BC433E1
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Aug 2020 17:08:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BE66207DF
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Aug 2020 17:08:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbgHCRIH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 Aug 2020 13:08:07 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:40084 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726889AbgHCRIH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Aug 2020 13:08:07 -0400
Received: by mail-il1-f200.google.com with SMTP id z16so28018028ill.7
        for <netfilter-devel@vger.kernel.org>; Mon, 03 Aug 2020 10:08:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Uagz7c3ZVrQ4AmBTqTiRjiEhG5PZlj6ITpIEOjqwLlk=;
        b=pnKdBzp/BeJP6ur1sFCquJCZB+WwoL0MY3fJfel5JsMGgcli/Uhtl37h9vb2+yFNPw
         sSXd45A2l0wiaZcBC29K8kOpC4+c6vDnYbD5LspPk6w7givwh3kHpDkqxQS52GXwOiGL
         bbYFI2IcFjC7xQG1/70yxGIzXmh3aQwDsjwnBJYEgVboCjq2+iVKTB64sakRvwuZP5qy
         HJqUWT9uST4PuTEA7VHZe2VuSop+eptyrfE6y31kl/01KVnf/DnvjpXbYLUCVkuvLAIW
         cyn9auZLAR7VJCf0sMmcHwMattUgsQ9ahNYw/f/GWdrCRbQt9H12ejkgAS277GAStA9W
         fXlw==
X-Gm-Message-State: AOAM531i9rwyWZdvjQXUHAvTtXevQUfUXBkYdRPhD/A6jpmDjZZ0JLd9
        cCQDtM7+QnZVFZ0zGsxj5cMiqZDD9859BlVqlVnEt53yaJJ+
X-Google-Smtp-Source: ABdhPJwUoO2AGC6UR45bmv6qFFKyJ8ndp7XrS1e6QhsHYtzpbvYwfQUycvap8dTkeAspF89iKUlUGDNf8nhiIGlpOp1dgS5vlqxA
MIME-Version: 1.0
X-Received: by 2002:a6b:bb43:: with SMTP id l64mr795486iof.191.1596474486108;
 Mon, 03 Aug 2020 10:08:06 -0700 (PDT)
Date:   Mon, 03 Aug 2020 10:08:06 -0700
In-Reply-To: <000000000000adea7f05abeb19cf@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a335a405abfc2e1e@google.com>
Subject: Re: KASAN: use-after-free Read in hci_chan_del
From:   syzbot <syzbot+305a91e025a73e4fd6ce@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net,
        devel@driverdev.osuosl.org, eric@anholt.net,
        gregkh@linuxfoundation.org, johan.hedberg@gmail.com,
        kaber@trash.net, kadlec@blackhole.kfki.hu, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot has bisected this issue to:

commit 166beccd47e11e4d27477e8ca1d7eda47cf3b2da
Author: Eric Anholt <eric@anholt.net>
Date:   Mon Oct 3 18:52:06 2016 +0000

    staging/vchi: Convert to current get_user_pages() arguments.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=178321a4900000
start commit:   5a30a789 Merge tag 'x86-urgent-2020-08-02' of git://git.ke..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=144321a4900000
console output: https://syzkaller.appspot.com/x/log.txt?x=104321a4900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e59ee776d5aa8d55
dashboard link: https://syzkaller.appspot.com/bug?extid=305a91e025a73e4fd6ce
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=127dd914900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=122a94ec900000

Reported-by: syzbot+305a91e025a73e4fd6ce@syzkaller.appspotmail.com
Fixes: 166beccd47e1 ("staging/vchi: Convert to current get_user_pages() arguments.")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
