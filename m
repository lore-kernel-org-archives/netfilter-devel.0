Return-Path: <SRS0=amc/=R2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1509C43381
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 Mar 2019 23:07:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BEA82183E
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 Mar 2019 23:07:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbfCWXHC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 23 Mar 2019 19:07:02 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:45310 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727625AbfCWXHB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 23 Mar 2019 19:07:01 -0400
Received: by mail-io1-f69.google.com with SMTP id r21so4885261iod.12
        for <netfilter-devel@vger.kernel.org>; Sat, 23 Mar 2019 16:07:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=DM0i7JvsW5kDkBW3eMu9lvcFxNEHMWs+yjuUoQZrNnc=;
        b=evhIIa3Dq7o5lYyg74K4ptbqrFdBeBrf9/UmeKKH/I4bmKHI7dOCeeI0ykLsvo+Weu
         6ACXw1l+wkCtXmc666siQul/GICzhxRnZKmdSxRrM1zcKVTJ0QFqsgrk96Th1fv9ZEdm
         5AoMHjNOBfXZq/byKhhm17+r5dGEDs7YLu/oc7Ch4LdZ+M1n7SrgfqLaAyHzxL9i67hw
         7QagXv0OJE/oyP7lj3skxzXmaZ2DU+QU5sLQy1/MDodJaricIyKDQSGnYqcQuJCCcxJD
         9/Y4QPwTAeHGNqWLiioKqT+8qM4TJv3+9hgVPCCffm0b5cmzOTfgnj/cG+y5nfVx0WoG
         UVSg==
X-Gm-Message-State: APjAAAUjVlEOGEsFRM80raiCxHbwarjIXT9JHIQXoZ8/jDbxiCiJDZO4
        MnpuazMMdb2T3I1RindUxWfQSjOQV4h2iM3K5QcSQPp/e/wW
X-Google-Smtp-Source: APXvYqyi+PHG1GG7s9bvqlbmuCCJlQLLEEIuzZodR7N3GDIinasT2drcO0UAOvtkcfBCgxvI6naISitUKLGOzp++gfsBBtV7MSHG
MIME-Version: 1.0
X-Received: by 2002:a5e:9604:: with SMTP id a4mr11667728ioq.1.1553382420988;
 Sat, 23 Mar 2019 16:07:00 -0700 (PDT)
Date:   Sat, 23 Mar 2019 16:07:00 -0700
In-Reply-To: <00000000000081994205827ea9a0@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000674a950584cb07a0@google.com>
Subject: Re: WARNING in xt_compat_add_offset
From:   syzbot <syzbot+276ddebab3382bbf72db@syzkaller.appspotmail.com>
To:     bridge@lists.linux-foundation.org, coreteam@netfilter.org,
        davem@davemloft.net, fw@strlen.de, kadlec@blackhole.kfki.hu,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, nikolay@cumulusnetworks.com,
        pablo@netfilter.org, roopa@cumulusnetworks.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot has bisected this bug to:

commit 2035f3ff8eaa29cfb5c8e2160b0f6e85eeb21a95
Author: Florian Westphal <fw@strlen.de>
Date:   Mon Jan 21 20:54:36 2019 +0000

     netfilter: ebtables: compat: un-break 32bit setsockopt when no rules  
are present

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1462834d200000
start commit:   8a61716f Merge tag 'ceph-for-5.0-rc8' of git://github.com/..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1662834d200000
console output: https://syzkaller.appspot.com/x/log.txt?x=1262834d200000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7132344728e7ec3f
dashboard link: https://syzkaller.appspot.com/bug?extid=276ddebab3382bbf72db
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=140c0914c00000

Reported-by: syzbot+276ddebab3382bbf72db@syzkaller.appspotmail.com
Fixes: 2035f3ff8eaa ("netfilter: ebtables: compat: un-break 32bit  
setsockopt when no rules are present")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
