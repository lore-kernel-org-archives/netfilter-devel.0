Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91CEEC4743F
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Jun 2021 20:17:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67B0C61008
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Jun 2021 20:17:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234953AbhFHUTB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Jun 2021 16:19:01 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:37558 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234815AbhFHUS6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Jun 2021 16:18:58 -0400
Received: by mail-il1-f198.google.com with SMTP id g12-20020a056e021a2cb02901dfc46878d8so15991425ile.4
        for <netfilter-devel@vger.kernel.org>; Tue, 08 Jun 2021 13:17:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=ezcyOkSc0C4ne5wy7XpBhvdu2J9JnoNW6BAbB6EkXRc=;
        b=EMh+s4Vp/LlWGVJAg2lWIj4ABq3fC+Bo48XL+VorocLeaPVI3IozUbPDYEwgVv0pb5
         1KkJVi2JegId4xOBCF04SO5R67W8vLNwImi+ocUEjIFPU8jDqRejUYhb3Ps8qyP7qKHd
         FeamOUxi1oxrmaMdgxwREmV673K+EQ8WvOe6b+JC7clZd9jfQMDBFbIcoC0oi55jGKP8
         N1cqUE1AYfjGEzQD7u9zl0A6vw/7D2VjVt04AQ1B+ZLxPa9lG/HxSCzO1RDt7V0ca3IP
         wIDcq+w7G3lmPtKuLQptSKQOfqgtji+RFAHZVppeKmvt3vMe5aksIyO2RS288hltJeXd
         06JA==
X-Gm-Message-State: AOAM532GEZ93EOxVB9CMI6ijupK/AAkpljMjGzX8HAc3db687GNFymsR
        9uKx1rK6AWKT/MbygunySMUgAvQ+55gGiqOVJHsLUFTUkfL+
X-Google-Smtp-Source: ABdhPJxlFMepmJqj21LizbIi4meiP0zBRDHteG4KDW9m2NIZ7zZsorrU0kycxV5pId0oKOs6apRSk7sZWFPXjDKQYU6iZDZS5LBV
MIME-Version: 1.0
X-Received: by 2002:a92:d1c3:: with SMTP id u3mr22045702ilg.190.1623183425148;
 Tue, 08 Jun 2021 13:17:05 -0700 (PDT)
Date:   Tue, 08 Jun 2021 13:17:05 -0700
In-Reply-To: <000000000000f6d80505abb42b60@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000761c0e05c446d750@google.com>
Subject: Re: [syzbot] WARNING in cancel_delayed_work
From:   syzbot <syzbot+35e70efb794757d7e175@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, dsahern@kernel.org,
        fw@strlen.de, johan.hedberg@gmail.com, johannes.berg@intel.com,
        johannes@sipsolutions.net, kadlec@netfilter.org, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, luciano.coelho@intel.com,
        marcel@holtmann.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 43016d02cf6e46edfc4696452251d34bba0c0435
Author: Florian Westphal <fw@strlen.de>
Date:   Mon May 3 11:51:15 2021 +0000

    netfilter: arptables: use pernet ops struct during unregister

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=140478ffd00000
start commit:   c3d8f220 Merge tag 'kbuild-fixes-v5.9' of git://git.kernel..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=bb68b9e8a8cc842f
dashboard link: https://syzkaller.appspot.com/bug?extid=35e70efb794757d7e175
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14f6602e900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1203cc61900000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: netfilter: arptables: use pernet ops struct during unregister

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
