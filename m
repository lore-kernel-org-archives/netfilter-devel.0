Return-Path: <SRS0=kPFe=3G=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5B1BC33CB6
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Jan 2020 04:45:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADB522072E
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Jan 2020 04:45:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730258AbgAQEpC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Jan 2020 23:45:02 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:53003 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbgAQEpC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Jan 2020 23:45:02 -0500
Received: by mail-io1-f71.google.com with SMTP id d10so14372875iod.19
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jan 2020 20:45:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=1cUAzzk2sNct6oR4gK6sFNSkqIAeXDAPVDj7dr4pJaI=;
        b=jClfA2plfS6RnpCNm0WIhJz3TyTnHBy1XUFCv2Fqn3wYuHsuQ18Rif/VOr+0KE0xkO
         LbrgpjeDEyAXyAqs9KvYbiIaSlGB4hZqQ/K/10brHOTSLNE9AbY/u8ZgyItfW1D8Tqeo
         ZJS49Ut/F33xFyHkL5xyDs8OTNqarSd+zw38NFx36TFYckek6Cpyi0sCoSucSj8dcwmB
         3qsDNyBp0MO80l3AlSurWdhyxnhi0PG9zsezqNSPE3jZk9YRBLaz3FkFzsxihL0zUYfm
         LCbrXrhi7TFVNEY/EMQFHWDR7sEfyOpk2u3KuR00m/ciY2khYY5QCieobSQm4T1LHR3/
         wdYw==
X-Gm-Message-State: APjAAAXEnmwgP2NqgF+gSYRMWak9V5sfsQMqTjjSkEPEfhpxdnS+gSzI
        PHUiatzJbXFsEzQjFYN2NY12WIa3ZJZVEM1EBn9eaIzWElJ/
X-Google-Smtp-Source: APXvYqyjD+Biivg/aa5/AT9J3HOCrQyY1dnQuDliyrdfNZIwqOAQb+x2KCj1JtDJEr9CqmN0upuDE/qMamViB/tBFaUwrT2rQYUY
MIME-Version: 1.0
X-Received: by 2002:a5d:9694:: with SMTP id m20mr30787857ion.48.1579236301410;
 Thu, 16 Jan 2020 20:45:01 -0800 (PST)
Date:   Thu, 16 Jan 2020 20:45:01 -0800
In-Reply-To: <000000000000b3599c059c36db0d@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c31c6d059c4e9a6c@google.com>
Subject: Re: BUG: corrupted list in nf_tables_commit
From:   syzbot <syzbot+37a6804945a3a13b1572@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@blackhole.kfki.hu, kadlec@netfilter.org,
        kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot has bisected this bug to:

commit 7c23b629a8085b11daccd68c62b5116ff498f84a
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Sun Jan 7 00:04:22 2018 +0000

     netfilter: flow table support for the mixed IPv4/IPv6 family

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=146472d1e00000
start commit:   51d69817 Merge tag 'platform-drivers-x86-v5.5-3' of git://..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=166472d1e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=126472d1e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d9290aeb7e6cf1c4
dashboard link: https://syzkaller.appspot.com/bug?extid=37a6804945a3a13b1572
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17241c76e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13118315e00000

Reported-by: syzbot+37a6804945a3a13b1572@syzkaller.appspotmail.com
Fixes: 7c23b629a808 ("netfilter: flow table support for the mixed IPv4/IPv6  
family")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
