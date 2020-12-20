Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CAA2C3526C
	for <netfilter-devel@archiver.kernel.org>; Sun, 20 Dec 2020 09:38:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37C842312A
	for <netfilter-devel@archiver.kernel.org>; Sun, 20 Dec 2020 09:38:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbgLTJhp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 20 Dec 2020 04:37:45 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:50477 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727283AbgLTJho (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 20 Dec 2020 04:37:44 -0500
Received: by mail-il1-f197.google.com with SMTP id t8so6670852ils.17
        for <netfilter-devel@vger.kernel.org>; Sun, 20 Dec 2020 01:37:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=0fT5mqBE94g71/WluOC6bf1J/UQhmIMm/DUDfbpZB9U=;
        b=sR8aqGsSQ/m8SDpRCdaMhBjhAYO4fa5kPomfNVbaMAPsIqBTzGiKotlYC91xFVbccF
         QeLLO9rC5N5sOeOnrV5UkOA6DKZG3ZVpOCUXq3/Ziwyv8fMBBwFmAEw1OHAoPo9ru+Os
         MUUVkICGjEuPbsveZd685NUSsTcsmh24BwneLF/gmKY1u9s2i2EZzXXXKCK3UdExszEi
         Igb2dfnvqjn46+iQeze+CU60eJA2NU6jqxy4tBXX6o9NqAe2Rst3GeC9UzNFOf3yQF7s
         BQ2NR3NqJIrrvPWUv6/VWDHzEKfo1g2i4i7eoKUpzWzRLeTz2bUVkDqHA9l721RTAJSf
         t0Vw==
X-Gm-Message-State: AOAM532o7Wa2BLoVYVPQJVL94ceLcRRYM5+c8M8wPmNtbWUuhwJneFO9
        vdfTddVwVJjOF/gn0z0cBba6dhF27/bAeXejUmnScBxXQOoG
X-Google-Smtp-Source: ABdhPJy/2OvStEVOk368NFkl05TcHnoLfL9VubxJP+qHGmxR1gjcoH5bassxkyk/ywRnffzn1GiHR9p3jFp67h07+mij430mJ0zN
MIME-Version: 1.0
X-Received: by 2002:a5d:8704:: with SMTP id u4mr10573638iom.3.1608457023536;
 Sun, 20 Dec 2020 01:37:03 -0800 (PST)
Date:   Sun, 20 Dec 2020 01:37:03 -0800
In-Reply-To: <000000000000264c6305a9c74d9b@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008647f705b6e215de@google.com>
Subject: Re: INFO: rcu detected stall in tipc_release
From:   syzbot <syzbot+3654c027d861c6df4b06@syzkaller.appspotmail.com>
To:     Markus.Elfring@web.de, bp@alien8.de, coreteam@netfilter.org,
        davem@davemloft.net, fw@strlen.de, fweisbec@gmail.com,
        hdanton@sina.com, hpa@zytor.com, jmaloy@redhat.com,
        jmattson@google.com, joro@8bytes.org, kadlec@netfilter.org,
        kuba@kernel.org, kuznet@ms2.inr.ac.ru, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, subashab@codeaurora.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        tuong.t.lien@dektech.com.au, vkuznets@redhat.com,
        wanpengli@tencent.com, x86@kernel.org, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit cc00bcaa589914096edef7fb87ca5cee4a166b5c
Author: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Date:   Wed Nov 25 18:27:22 2020 +0000

    netfilter: x_tables: Switch synchronization to RCU

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1445cb37500000
start commit:   7cc2a8ea Merge tag 'block-5.8-2020-07-01' of git://git.ker..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=7be693511b29b338
dashboard link: https://syzkaller.appspot.com/bug?extid=3654c027d861c6df4b06
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12948233100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11344c05100000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: netfilter: x_tables: Switch synchronization to RCU

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
