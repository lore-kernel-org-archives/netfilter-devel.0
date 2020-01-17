Return-Path: <SRS0=kPFe=3G=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58052C33CB6
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Jan 2020 18:57:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33E952082F
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Jan 2020 18:57:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729578AbgAQS5j (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Jan 2020 13:57:39 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:33957 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729543AbgAQS5j (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Jan 2020 13:57:39 -0500
Received: by mail-il1-f197.google.com with SMTP id l13so19462055ils.1
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Jan 2020 10:57:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=0XaH1mXR999mQNU6K6YWrbLPoIkTydrY/Z5TzvdEIoo=;
        b=fO/QY/vYU3CmCy/acvddIR/nw3pTfpgaxEbzHqLIZZ2GuhE94nYhUtJ7Kp2byi+3ga
         amgkA52kgkLyMYXCwuWna396FNoh5lXizzj0q/y2Bdp+bXkZM6DXr8zo8pZbw96oOlNd
         gZI9YzHAUI/1f/ajCdsYUBg8utPPm878BjWHWpM1ab5gPwmD0nr4EVIspu+DiXUm6z5n
         DP8Mbd5qqa2Y2Gko67niqALZdUUB+IiESv943Vvwt0Y7KZ3PEafsB0vPVFv2jJcyDe6i
         8IWZk3hbMRlz/rnS+WVBtDelT1FN4D34KXAgcZIKJGfO971/fCI82EuItXsAW4s7hsIm
         Cpvw==
X-Gm-Message-State: APjAAAUsYpgTO1PPZKSOANETVL8hQmu50rdSAmM1IkDj6BRS87wrjtyf
        /I4avLh2r8ZrTAkqVPMFVszEMyO4IFi+i+XMN2y4n6bwJCor
X-Google-Smtp-Source: APXvYqwdJblA4HS+sQAcyDnaZpEyamvRHPNZVLzTjCRJ1fUtjR6kwtPkrmKO+XSfDHOH8bobb3s8OKTAC0ffD9Ym4OsrWFyRFSsI
MIME-Version: 1.0
X-Received: by 2002:a92:2907:: with SMTP id l7mr4151886ilg.140.1579287458817;
 Fri, 17 Jan 2020 10:57:38 -0800 (PST)
Date:   Fri, 17 Jan 2020 10:57:38 -0800
In-Reply-To: <00000000000074ed27059c33dedc@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fb2c4f059c5a8309@google.com>
Subject: Re: general protection fault in nft_chain_parse_hook
From:   syzbot <syzbot+156a04714799b1d480bc@syzkaller.appspotmail.com>
To:     bridge@lists.linux-foundation.org, coreteam@netfilter.org,
        davem@davemloft.net, fw@strlen.de, kadlec@blackhole.kfki.hu,
        kadlec@netfilter.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        stephen@networkplumber.org, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot has bisected this bug to:

commit 98319cb9089844d76e65a6cce5bfbd165e698735
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Tue Jan 9 01:48:47 2018 +0000

     netfilter: nf_tables: get rid of struct nft_af_info abstraction

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13d38159e00000
start commit:   f5ae2ea6 Fix built-in early-load Intel microcode alignment
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=10338159e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=17d38159e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d9290aeb7e6cf1c4
dashboard link: https://syzkaller.appspot.com/bug?extid=156a04714799b1d480bc
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15a7e669e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11102356e00000

Reported-by: syzbot+156a04714799b1d480bc@syzkaller.appspotmail.com
Fixes: 98319cb90898 ("netfilter: nf_tables: get rid of struct nft_af_info  
abstraction")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
