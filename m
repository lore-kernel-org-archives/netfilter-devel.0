Return-Path: <SRS0=tm+y=5H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E364C4332B
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Mar 2020 18:02:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D2342072E
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Mar 2020 18:02:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbgCVSCJ convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 22 Mar 2020 14:02:09 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:50627 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726752AbgCVSCE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 22 Mar 2020 14:02:04 -0400
Received: by mail-io1-f71.google.com with SMTP id s2so9516850iot.17
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Mar 2020 11:02:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to:content-transfer-encoding;
        bh=gKaSt4ZxxQs34ChfXVL8Hym0FPD2YC0tVneuWnb771k=;
        b=Nql9zQZNGqDYesznxvyPn8Fo8RXIfjgMryrf5f+vVXLbrjOB+GBLtN0nBBCpLeTUhx
         02nq473zE4etv3og/csffqno/DX00rwZ24A1P42YfB+pQItYj/fqZFEapN5LvYp5dUMZ
         2BfREqlV26u9HQU+h/TIIaQSbd2dZ7hHFo3qeNJo52jNLJiklcofycU7h71/nVh6/MYf
         xbN1sBK/iZEmV9ycycm+NCGFGgaKEdsjnQsudLiB9oyNyvXTAfF9s9oV51bqOcQqWIL2
         xUuJfUuuRK32Sg8b5PeIveSwb7cw4AwjMyEcQBR7E/+KbGcs/D5dPxj+N0NHy78dXFfS
         mmqQ==
X-Gm-Message-State: ANhLgQ1f5cBq3AdaiTZWcco/r2WfksitbbiIV1Xv3/KS61TIjFaU6DJ5
        WC2QAp95sz9qWiTeiM0Ie647m5n6GNjrlWyrBH+sINcc7LMj
X-Google-Smtp-Source: ADFU+vsE6MYXnGyJNqw2vLGTU0rbWrO9cnQWa5eMVntpxhMHOkrc8SQ0+ppZ6IOnLHjd2xBOscF9K+YA+EakNro3nJqvZIEq+m22
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:4c6:: with SMTP id f6mr17550477ils.272.1584900123891;
 Sun, 22 Mar 2020 11:02:03 -0700 (PDT)
Date:   Sun, 22 Mar 2020 11:02:03 -0700
In-Reply-To: <000000000000dd68d0059c74a1db@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e39e1b05a1755045@google.com>
Subject: Re: KASAN: slab-out-of-bounds Read in bitmap_ip_add
From:   syzbot <syzbot+f3e96783d74ee8ea9aa3@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, allison@lohutok.net,
        aryabinin@virtuozzo.com, coreteam@netfilter.org,
        davem@davemloft.net, elver@google.com, fw@strlen.de,
        gregkh@linuxfoundation.org, info@metux.net, jeremy@azazel.net,
        kadlec@blackhole.kfki.hu, kadlec@netfilter.org,
        kstewart@linuxfoundation.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        torvalds@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit 32c72165dbd0e246e69d16a3ad348a4851afd415
Author: Kadlecsik József <kadlec@blackhole.kfki.hu>
Date:   Sun Jan 19 21:06:49 2020 +0000

    netfilter: ipset: use bitmap infrastructure completely

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13c6cb73e00000
start commit:   244dc268 Merge tag 'drm-fixes-2020-01-19' of git://anongit..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=d9290aeb7e6cf1c4
dashboard link: https://syzkaller.appspot.com/bug?extid=f3e96783d74ee8ea9aa3
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1104c495e00000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: netfilter: ipset: use bitmap infrastructure completely

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
