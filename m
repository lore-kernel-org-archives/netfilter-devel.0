Return-Path: <SRS0=0JUI=4J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D081C35660
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Feb 2020 19:05:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1346B24650
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Feb 2020 19:05:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729642AbgBUTFF convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 Feb 2020 14:05:05 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:43275 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729430AbgBUTFF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Feb 2020 14:05:05 -0500
Received: by mail-io1-f72.google.com with SMTP id v15so2964214iol.10
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Feb 2020 11:05:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to:content-transfer-encoding;
        bh=6HPd5BpaEdwQYZOa0Jq69qrFdmHHelt8oh9R02313yI=;
        b=dDFKwgbnBrSVGI8qj/xsYOxdIn/le/rqNvbPNrVcrcpbZmuMi6SpIdl6TkL0QPuM2V
         jmkgj/3bI2t23vD0X9aYPLcDmQlVCidr3xb7xaMXQHvfMUA0a9VHDNvfrpaP7EgILS9j
         gJjAZMz+4t+hx2SzPcqFjiB8yAAguMc4bg2bJcGyXxj1ZYhhhf8DFUjV9sNQznGp5K0w
         dB4H+Tr78o4rEuspIi2fsOFqvIy816OyDOjjjOGZ11T+WkIx69jfBzRewtljFHUT+jz3
         PHyhKdUjclT/f3kxunU3wLh6/wglEgIEh13twKlP7rsNZqRTw/rM+pLtLaRS/i69zyJU
         J0Xw==
X-Gm-Message-State: APjAAAUjsOFbF1rCSW+FLIfZ/bVXiDQW+On6yHfI/vCyx/mdctTvtwFn
        03i2nH4yAWebs8ts9ldooMelPN4C8bOONau2ypZMV8tM+rKz
X-Google-Smtp-Source: APXvYqwLW2r3BmTlbIIeJFfAs7Uv80Ut/LNDiARQZ70MK0QKfO5+10fP12va8gN8C1TWjny8qjdR5O6xuKt+aWLqAsKZ/K16uMae
MIME-Version: 1.0
X-Received: by 2002:a5e:8e4d:: with SMTP id r13mr30243768ioo.60.1582311902722;
 Fri, 21 Feb 2020 11:05:02 -0800 (PST)
Date:   Fri, 21 Feb 2020 11:05:02 -0800
In-Reply-To: <000000000000f649ad059c8ca893@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e2c2c9059f1ab2bb@google.com>
Subject: Re: KASAN: slab-out-of-bounds Write in bitmap_ip_del
From:   syzbot <syzbot+24d0577de55b8b8f6975@syzkaller.appspotmail.com>
To:     allison@lohutok.net, arvid.brodin@alten.se, coreteam@netfilter.org,
        davem@davemloft.net, dirk.vandermerwe@netronome.com, fw@strlen.de,
        gregkh@linuxfoundation.org, info@metux.net,
        jakub.kicinski@netronome.com, jeremy@azazel.net,
        kadlec@blackhole.kfki.hu, kadlec@netfilter.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
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

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1226da7ee00000
start commit:   d96d875e Merge tag 'fixes_for_v5.5-rc8' of git://git.kerne..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=cf8e288883e40aba
dashboard link: https://syzkaller.appspot.com/bug?extid=24d0577de55b8b8f6975
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14cddd76e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10f459c9e00000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: netfilter: ipset: use bitmap infrastructure completely

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
