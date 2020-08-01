Return-Path: <SRS0=dQO5=BL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CA8FC433E3
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Aug 2020 22:56:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72321206F6
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Aug 2020 22:56:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbgHAW4L (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 1 Aug 2020 18:56:11 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:34051 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726807AbgHAW4K (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 1 Aug 2020 18:56:10 -0400
Received: by mail-io1-f69.google.com with SMTP id 127so23880206iou.1
        for <netfilter-devel@vger.kernel.org>; Sat, 01 Aug 2020 15:56:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=dOzePy5yJodn3MAztJ8MjMszFxBpzjO8+9+k54Plw7U=;
        b=K0HMUF8Z4k85kFrnsDKOEh2Mb0YKJ/bw/mivJRLJsTFJAjfEQCqbwtJ3ZzNrl5p7Hd
         0qrrciVlFkxLRjz+UQ3Ru/mj1dKlFaGew2bV/gcL7nJD1MQSEGWPCgc0OjFPAt1pgfe8
         ZGVFUDl2HIMS9m80VNVY9ijhvCh/aF9RhAbXiSrReeYpTrgzgknokg+I0vyzA8x50Mik
         plqaDFbaSWx/rxDFdkXYFhI5r7fSwQWCTYX8eP9VZPyducMenCqQwRl0FgxF8SKhG93e
         5NtQTxQIjs8kpVS/0M9UGlHyItKP/7uFxUdBquTh3RWdCtx5bC4g4jx7FktLJOFbpa5H
         o7sw==
X-Gm-Message-State: AOAM531jgCYdluxNRCOLYKI6GAa9Qn1wyTjAp8sYr5u0ixYAEvA9Vk8S
        r6GeGSqR3cojdrC/pPcwNfbLLVzqmsxlRYy+nnBxmtLyExY6
X-Google-Smtp-Source: ABdhPJzoFyfIZQhNRPiFzD4/WN4vVmjC3jcEN/n2QVLjineSWA8YL2dCDfS0uwVot1kHmJxuiejHJRIs+6Vlg9DaPmCCBtbeQtI1
MIME-Version: 1.0
X-Received: by 2002:a92:79c4:: with SMTP id u187mr10446904ilc.194.1596322569603;
 Sat, 01 Aug 2020 15:56:09 -0700 (PDT)
Date:   Sat, 01 Aug 2020 15:56:09 -0700
In-Reply-To: <0000000000007450a405abd572a8@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b54f9f05abd8cfbb@google.com>
Subject: Re: WARNING in hci_conn_timeout
From:   syzbot <syzbot+2446dd3cb07277388db6@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net,
        devel@driverdev.osuosl.org, forest@alittletooquiet.net,
        gregkh@linuxfoundation.org, johan.hedberg@gmail.com,
        kaber@trash.net, kadlec@blackhole.kfki.hu, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        rvarsha016@gmail.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot has bisected this issue to:

commit 3d30311c0e4d834c94e6a27d6242a942d6a76b85
Author: Varsha Rao <rvarsha016@gmail.com>
Date:   Sun Oct 9 11:13:56 2016 +0000

    staging: vt6655: Removes unnecessary blank lines.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17023a14900000
start commit:   7dc6fd0f Merge branch 'i2c/for-current' of git://git.kerne..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=14823a14900000
console output: https://syzkaller.appspot.com/x/log.txt?x=10823a14900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e59ee776d5aa8d55
dashboard link: https://syzkaller.appspot.com/bug?extid=2446dd3cb07277388db6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13f781d4900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=116a0c14900000

Reported-by: syzbot+2446dd3cb07277388db6@syzkaller.appspotmail.com
Fixes: 3d30311c0e4d ("staging: vt6655: Removes unnecessary blank lines.")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
