Return-Path: <SRS0=yhqN=4H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 900DEC34053
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Feb 2020 15:46:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66B182464E
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Feb 2020 15:46:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgBSPqD convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Feb 2020 10:46:03 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:48313 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbgBSPqD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Feb 2020 10:46:03 -0500
Received: by mail-il1-f197.google.com with SMTP id u14so513493ilq.15
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Feb 2020 07:46:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to:content-transfer-encoding;
        bh=meEL6Fy6aleZ9jtvpgGrvnGSbq9MuEYemHMybXseYg4=;
        b=o0spg6qFhrpsWHkC89OE44I8Ye0ZPpkIdJI1bZRTDkaHOgJrlBVvm/OxQiHiKz/UFZ
         vFIeaAlyX+wzGyIQTSDePYAQkU7whyr2GQfwf0ZzF6NFdPmzGDeEguNLZhi/szw2pI7S
         10Jh/HTyeSq8UC8F/hs9TzNRem4JBPFlIyc1G/l0oXc3X/ExRwAKIuPI/zWleegmPafH
         5CwyCm87QIpLI0IfDWfHhtFNgnMzVEwUsezeapnlH3NtrGJjl+3ADopHKM5+rfbbCGyl
         swAPV8coBo/RpbxCj5npi5FWc/UndzZvcfC+GI11YbGfpszFVR30RhuHdguD0jeXh3/3
         YK1w==
X-Gm-Message-State: APjAAAULPgY6nNEvhV8fVWt5L/McxpLPgbNZmkk7Y4aTT8wBsl/spavw
        WaiF6ikDs3qkEFn6YofRz/ta5PIaBUDXYvbHJagM03pgqjOM
X-Google-Smtp-Source: APXvYqwJfaY34Duul7QI4nsW4eP5gWo56eh9X0PBjI8pEz/ZDnQ4R7/IwdlEugDK5rSMkM2M9L+WROKda4/pXhpDOVDjiChOjTov
MIME-Version: 1.0
X-Received: by 2002:a92:91d8:: with SMTP id e85mr25001159ill.146.1582127163011;
 Wed, 19 Feb 2020 07:46:03 -0800 (PST)
Date:   Wed, 19 Feb 2020 07:46:02 -0800
In-Reply-To: <000000000000c7999e059c86eebe@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008a7b14059eefafff@google.com>
Subject: Re: KASAN: use-after-free Read in bitmap_ipmac_ext_cleanup
From:   syzbot <syzbot+33fc3ad6fa11675e1a7e@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        coreteam@netfilter.org, davem@davemloft.net,
        florent.fourcot@wifirst.fr, fw@strlen.de, jeremy@azazel.net,
        johannes.berg@intel.com, kadlec@blackhole.kfki.hu,
        kadlec@netfilter.org, linux-kernel@vger.kernel.org,
        mareklindner@neomailbox.ch, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        po-hsu.lin@canonical.com, skhan@linuxfoundation.org,
        sw@simonwunderlich.de, syzkaller-bugs@googlegroups.com
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

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13435a7ee00000
start commit:   8f8972a3 Merge tag 'mtd/fixes-for-5.5-rc7' of git://git.ke..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=d9290aeb7e6cf1c4
dashboard link: https://syzkaller.appspot.com/bug?extid=33fc3ad6fa11675e1a7e
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15982cc9e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11be38d6e00000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: netfilter: ipset: use bitmap infrastructure completely

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
