Return-Path: <SRS0=O/k4=YS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72691CA9EBD
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Oct 2019 04:20:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49BDB21D71
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Oct 2019 04:20:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733263AbfJYEUE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Oct 2019 00:20:04 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:33994 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727103AbfJYEUD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Oct 2019 00:20:03 -0400
Received: by mail-il1-f199.google.com with SMTP id s17so1147879ili.1
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Oct 2019 21:20:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=NF2elsax11pXsnm+smX3VLKpwTuafbnzKYyInM/Zfhg=;
        b=TjSvtl5iWgODIDExcnpmUpgYqSSms3NLjetCgMqktN33IO/CYroJ0FNvBMNt0/2rJo
         eiwlnjXnD7NHLwOvYuOWJA09ElKTX3TVgLpctPPVXAhl/tjqJkFHcDoVHjawWM0eO6cF
         j+Ng5ZXIqGTD0xVOSAnLwtYGdkmob8atfjBX+PdPYVNAu9It12R/TukiWgMtJX7Ppnb3
         Bw5wEGog7TeccGvknI7uqEwJaV/94dcXQehnxgIOrMCVf3bS0THupbH7x6Ymt+4iaoWn
         UxdVmZgZXQhVYW67LM0kZziOM+0Km7qRa7q3R9G1VuLErS27Ml62Wv7o9zvn8PrEqKx1
         ylXw==
X-Gm-Message-State: APjAAAWPhcVHs7mk2CeJt2t7SfTMtT3fWczYcRDWOHbVCrRINzVAIi/M
        2ol/2kC1XedzHwNVAGzHbBkp6aK2Rds2Kwu9k5LNLRzciqYD
X-Google-Smtp-Source: APXvYqxBLtXLb+ZNhposnuPP5R6TbEk6pDsIDIYFbKqUpk/R085DA7b4q4kzLVLphPbJ9kNcvFRhZFz7kEFExK0XH5h0eLU1wAlT
MIME-Version: 1.0
X-Received: by 2002:a92:ccd0:: with SMTP id u16mr1924578ilq.296.1571977201370;
 Thu, 24 Oct 2019 21:20:01 -0700 (PDT)
Date:   Thu, 24 Oct 2019 21:20:01 -0700
In-Reply-To: <00000000000074bc3105958042ef@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000aecf020595b4762f@google.com>
Subject: Re: KASAN: use-after-free Read in nf_ct_deliver_cached_events
From:   syzbot <syzbot+c7aabc9fe93e7f3637ba@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, dhowells@redhat.com,
        fw@strlen.de, kadlec@netfilter.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot has bisected this bug to:

commit 2341e0775747864b684abe8627f3d45b167f2940
Author: David Howells <dhowells@redhat.com>
Date:   Thu Jun 9 22:02:51 2016 +0000

     rxrpc: Simplify connect() implementation and simplify sendmsg() op

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12f869df600000
start commit:   12d61c69 Add linux-next specific files for 20191024
git tree:       linux-next
final crash:    https://syzkaller.appspot.com/x/report.txt?x=11f869df600000
console output: https://syzkaller.appspot.com/x/log.txt?x=16f869df600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=afb75fd8c9fd5ed8
dashboard link: https://syzkaller.appspot.com/bug?extid=c7aabc9fe93e7f3637ba
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10938e18e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=147caa97600000

Reported-by: syzbot+c7aabc9fe93e7f3637ba@syzkaller.appspotmail.com
Fixes: 2341e0775747 ("rxrpc: Simplify connect() implementation and simplify  
sendmsg() op")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
