Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A264C2BBCD
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Dec 2020 07:16:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21A8023130
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Dec 2020 07:16:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbgLPHPo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Dec 2020 02:15:44 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:54152 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbgLPHPo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Dec 2020 02:15:44 -0500
Received: by mail-il1-f197.google.com with SMTP id q2so18665891ilt.20
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Dec 2020 23:15:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=36zW/PbpiTCKuG8Esvh3+4Beyh5+p/0KAx49415NdvY=;
        b=k8/EVOzxd3w5LznqXlYvev4/AzRy61+eLnzZvPuuke89FJUC8y/8pKHCF50/zgWVlX
         mqt4vrNrqiw5JoJQPFxmIQ3VEPIqzt87UUgn4fxwKQWaekHXfcgDVaPj9glOpTAAcQ25
         dKn88VLx29q4CzCfoDVi/77C5nzkmDi9X+WrTF3vvUL3MMNVZgqCtAVYukXuiQfe1Zd0
         ybn1Oe4F58uPOCYaKxMoU5uk2N0KLUMrZ33KkNOCP5H43Wxu7dabJ0VzfTe+qn/uibLs
         iwJgsGqbw301tZ+ROtaF7jbqONY7vvgiE+MZ10JsX/3p9FjPLSL+mSO46unKs+3PMK3U
         3NGA==
X-Gm-Message-State: AOAM5314W0Mx6aMNXDGGRMXsrHcm3VwpOci0c8F6UFXgURgoNSDATl7k
        /PKvz9tEURbhed10i8t9ImHzosCquIkCUbDoCGeJOBSuEJzE
X-Google-Smtp-Source: ABdhPJyE+w4DQGI1MtjxdqzF3IywhKSts84lZVnS0w5MQcPUmCQp7IMO10IRfWgV2p9/kkfUbcykf9u+Dd+WT8lfjHM/CdRp4VIy
MIME-Version: 1.0
X-Received: by 2002:a6b:c9cb:: with SMTP id z194mr40484133iof.110.1608102903193;
 Tue, 15 Dec 2020 23:15:03 -0800 (PST)
Date:   Tue, 15 Dec 2020 23:15:03 -0800
In-Reply-To: <000000000000ab11c505abeb19f5@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004ea4fe05b68fa299@google.com>
Subject: Re: KASAN: use-after-free Write in __sco_sock_close
From:   syzbot <syzbot+077eca30d3cb7c02b273@syzkaller.appspotmail.com>
To:     anmol.karan123@gmail.com, coreteam@netfilter.org,
        davem@davemloft.net, devel@driverdev.osuosl.org,
        foxhlchen@gmail.com, gregkh@linuxfoundation.org,
        johan.hedberg@gmail.com, kaber@trash.net, kadlec@blackhole.kfki.hu,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        marcel@holtmann.org, mchehab@kernel.org, mchehab@s-opensource.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 6dfccd13db2ff2b709ef60a50163925d477549aa
Author: Anmol Karn <anmol.karan123@gmail.com>
Date:   Wed Sep 30 14:18:13 2020 +0000

    Bluetooth: Fix null pointer dereference in hci_event_packet()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14cb845b500000
start commit:   47ec5303 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=e0c783f658542f35
dashboard link: https://syzkaller.appspot.com/bug?extid=077eca30d3cb7c02b273
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=165a89dc900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=130a8c62900000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: Bluetooth: Fix null pointer dereference in hci_event_packet()

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
