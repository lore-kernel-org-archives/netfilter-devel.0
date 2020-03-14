Return-Path: <SRS0=uBOy=5A=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=DATE_IN_PAST_12_24,
	FROM_LOCAL_HEX,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EDFBC0044D
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Mar 2020 03:03:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6048520575
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Mar 2020 03:03:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727433AbgCODD4 convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 14 Mar 2020 23:03:56 -0400
Received: from mail-pl1-f200.google.com ([209.85.214.200]:47161 "EHLO
        mail-pl1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727174AbgCODD4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 14 Mar 2020 23:03:56 -0400
Received: by mail-pl1-f200.google.com with SMTP id t2so8150926ply.14
        for <netfilter-devel@vger.kernel.org>; Sat, 14 Mar 2020 20:03:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to:content-transfer-encoding;
        bh=j2SmXJOFlNVNX3IBInWb2HEJ3kFsGIlnIYBHVv47Fmg=;
        b=GEzlBNQ79CFSsH8SW1TYgbHC6/1xRmdBtSlYyd3hLhRdDaoa2cQx97QQ4zHLKMT5dc
         2phAYnLQEMwDk0aENIlk3X74NEK8WFQap1i1lq3J457IcZpj6mrHhCHgQeris91iw2sx
         xD0ksam47tiEUBE+Z+XpEazTyy9Bc+pJAMHmaG1vnb+Tsvp/Qkhzb/PPAmFD32/SzRgR
         XM072CvZlWrmkJr5WJO6WJHx2SEVf0QO1gs+uF3EYWrG85OIGIqG5XxRzy3e1gZVG8TC
         Q9xudhTHiaSul8nL5eXP6zX3pXfA1zdMSyjHQLd04y4pDANZHtONg3k+w8aNUB0xn+Ya
         iYFw==
X-Gm-Message-State: ANhLgQ3YRkHbOvn9m4yl2v3zMH0qfMUpyzvzOETuYGEgqzFFoQ88dHul
        RS4of7JloOAz+FZ4AKxUIujCCj5JDGP5SJhq0c8phyr/7XB7
X-Google-Smtp-Source: ADFU+vuJBPZ1PMOOzQo98cA9c5gJcvaAaQ6f/LSVIdRh9X4dB9T+eheUju1sRb7NyyPU97BKERRNFdBNpuxA4sPOAFveN366df7X
MIME-Version: 1.0
X-Received: by 2002:a92:d842:: with SMTP id h2mr17075595ilq.34.1584191402876;
 Sat, 14 Mar 2020 06:10:02 -0700 (PDT)
Date:   Sat, 14 Mar 2020 06:10:02 -0700
In-Reply-To: <000000000000204b4d059cd6d766@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d3278d05a0d04d97@google.com>
Subject: Re: KASAN: slab-out-of-bounds Read in bitmap_port_destroy
From:   syzbot <syzbot+b96275fd6ad891076ced@syzkaller.appspotmail.com>
To:     arvid.brodin@alten.se, coreteam@netfilter.org,
        dan.carpenter@oracle.com, davem@davemloft.net,
        florent.fourcot@wifirst.fr, fw@strlen.de, hdanton@sina.com,
        jeremy@azazel.net, johannes.berg@intel.com,
        kadlec@blackhole.kfki.hu, kadlec@netfilter.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
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

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=106f42a9e00000
start commit:   131701c6 Merge tag 'leds-5.5-rc8' of git://git.kernel.org/..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=83c00afca9cf5153
dashboard link: https://syzkaller.appspot.com/bug?extid=b96275fd6ad891076ced
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15fba721e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1339726ee00000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: netfilter: ipset: use bitmap infrastructure completely

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
