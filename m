Return-Path: <SRS0=uBOy=5A=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C0D0C18E5B
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Mar 2020 21:26:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35BB020663
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Mar 2020 21:26:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729212AbgCOV0G convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 15 Mar 2020 17:26:06 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:46293 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729166AbgCOV0G (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 15 Mar 2020 17:26:06 -0400
Received: by mail-il1-f199.google.com with SMTP id a2so12112304ill.13
        for <netfilter-devel@vger.kernel.org>; Sun, 15 Mar 2020 14:26:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to:content-transfer-encoding;
        bh=ObBVExDwk8OBYjYRj5UK3XQ8zrdTqTo9rbmRyh92cU0=;
        b=KMgJLQS29dOC8cj+f0Va/xYzMEWuQCHYgyyeopN/q3JoDPlqUOuIwDXXCs2+h3TAKc
         YLTuIpqlHr8qDMhSnN+Zjb68l879d3TY7eKcaXOT7tbHZDwa9KmabUOYL/k3Yl+YlM5E
         +mkURzMkwFrfwimLE8ueM8cpDrGjur8H9kphEWkK6ZPCn1o3HpMYHYaCSPbCIAYvAuFn
         fcv7NLUHeWi0F36RWUWzlKzEvyGZiTtpRWA3r8oPSJQjqfOcZF1uaGeL9DEa2BUhZBA8
         zxVv5v759B5IqODYHmRBX8aFAe7mjevK83Svjbo2iXAngC8ziPMt9KII0NO5Aev2134+
         zDzw==
X-Gm-Message-State: ANhLgQ0XvBD+st+ye+DRebYuqiFGPuNBEXxU60keAJN7S0KuW+l8ifXB
        XNjVOhYtPpQBmbrlYwdpCXaW2EO30jxgp2gWaxl//L+uBSy3
X-Google-Smtp-Source: ADFU+vt4qJpj1JeI/CaGL1tH5qCsGjqSAlUF9zulnGe3k9qHg++O02+OAtSyUOSf2fVU7oTjSCFWtWERadBsDt0XUmGXBPeoxU6S
MIME-Version: 1.0
X-Received: by 2002:a92:d112:: with SMTP id a18mr12650691ilb.259.1584307564141;
 Sun, 15 Mar 2020 14:26:04 -0700 (PDT)
Date:   Sun, 15 Mar 2020 14:26:04 -0700
In-Reply-To: <000000000000f96400059c8ca8cd@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009363ac05a0eb5940@google.com>
Subject: Re: KASAN: slab-out-of-bounds Read in bitmap_ipmac_ext_cleanup
From:   syzbot <syzbot+c400f7b04cadb5df6ea7@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net,
        florent.fourcot@wifirst.fr, fw@strlen.de, jeremy@azazel.net,
        johannes.berg@intel.com, kadlec@blackhole.kfki.hu,
        kadlec@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
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

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1163e0d3e00000
start commit:   4703d911 Merge tag 'xarray-5.5' of git://git.infradead.org..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=cf8e288883e40aba
dashboard link: https://syzkaller.appspot.com/bug?extid=c400f7b04cadb5df6ea7
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=155af721e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13cfb79ee00000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: netfilter: ipset: use bitmap infrastructure completely

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
