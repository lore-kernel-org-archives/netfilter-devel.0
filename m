Return-Path: <SRS0=Vl9M=3M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A266C2D0DB
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jan 2020 12:30:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E18724655
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jan 2020 12:30:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgAWMaB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Jan 2020 07:30:01 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:52300 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726170AbgAWMaB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Jan 2020 07:30:01 -0500
Received: by mail-io1-f69.google.com with SMTP id d10so1879560iod.19
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jan 2020 04:30:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=4SmMbABkY6ThQPONYy6cypBPBR0TLA6ap0ik5lnKxP8=;
        b=Ms9WVhvpQNFrdy0opWjO+CSe38HqJxXAvFhNsZ5wcOtnkBLvj9WmBO7bTVhC9s815b
         9/NqgMz5nVhgQxk1UvnuIcn/uLUqX3YOzi/B+DtT5p4aKL6HFUu+hlCZAWSXmPBcBHGN
         /xU+S8Yr+nQfLL1v2N6BNbwpl5kLpMvd+p3fv9BFDLx8ke7/jGhiA+SxNngHfX7y7gLB
         3sqZXzi9AP1wEls9pALdd0PbuMM1CwxE/lZdDuGN6YgIowgsfD/8HqEMl07o/Xf9IIMk
         T6w5v8jRsK55OHFu59LnyR329L1bfjnaIAef2x+2b4ci9xDki41Kn+1RZlXNMELWZ8sm
         hTmw==
X-Gm-Message-State: APjAAAXypOZEPi1BRt4RlE39A26sTMwbiF+nQrqTBcWmb34/3XdirVLd
        +Z1mX4sha6zd8ZY8Rpa6F8ArSjDrUhFXyHRcXM/Ue8KpArh3
X-Google-Smtp-Source: APXvYqxSAwAGR1DUOhT8OmC+2lHPf8M7QnvokXyKxJl/MwEFN5SFQHJSUSrgtfrCq2Tq9CKYo7cWSjIffVV6IYpiJW39NHXvxpk0
MIME-Version: 1.0
X-Received: by 2002:a5e:aa12:: with SMTP id s18mr10205269ioe.182.1579782600551;
 Thu, 23 Jan 2020 04:30:00 -0800 (PST)
Date:   Thu, 23 Jan 2020 04:30:00 -0800
In-Reply-To: <00000000000014b040059c654481@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ba7772059ccdcc7b@google.com>
Subject: Re: WARNING in nf_tables_table_destroy
From:   syzbot <syzbot+2a3b1b28cad90c608e20@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot has bisected this bug to:

commit ec7470b834fe7b5d7eff11b6677f5d7fdf5e9a91
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Mon Jan 13 17:09:58 2020 +0000

    netfilter: nf_tables: store transaction list locally while requesting module

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12c2ef59e00000
start commit:   5a9ef194 net: systemport: Fixed queue mapping in internal ..
git tree:       net
final crash:    https://syzkaller.appspot.com/x/report.txt?x=11c2ef59e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=16c2ef59e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7e89bd00623fe71e
dashboard link: https://syzkaller.appspot.com/bug?extid=2a3b1b28cad90c608e20
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15338966e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1667d8d6e00000

Reported-by: syzbot+2a3b1b28cad90c608e20@syzkaller.appspotmail.com
Fixes: ec7470b834fe ("netfilter: nf_tables: store transaction list locally while requesting module")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
