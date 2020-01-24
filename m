Return-Path: <SRS0=/v6G=3N=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8A3CC2D0CE
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Jan 2020 04:55:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A434C2070A
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Jan 2020 04:55:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730321AbgAXEzC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Jan 2020 23:55:02 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:47101 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729316AbgAXEzB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Jan 2020 23:55:01 -0500
Received: by mail-il1-f197.google.com with SMTP id a2so652041ill.13
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jan 2020 20:55:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=wqIW1GSh96dKBLUXIwcBCdzQGnE7BxtkVO3LYYJlVQE=;
        b=SlyiRdkET9EWZtfFYm0yZ7W0YRhVQJ9uSKRxyR1h0jfTnJdGBl6YfzknBlPyrAvxP+
         r/xhKfIQ9i0M62lW/hPXvgwvMZg4pDwkOQrlm15nN/YKl91NDSwyLOr9+TbTkaUW3DY/
         bvt+DgR2xe1gC114OQ2/KDoGu7e84IRtyexLECl3lr6J59ulq0IivWjTyfTWmkOdRRrz
         +DJDDoPCPIiK8KkUoPRjRl9CN+qvBP35cbA24xhTTeFDAQdRQT4LubqzHZhODzxehOfu
         nz6tzW4068JmlzOUTGX4Hh3Bgcudbjp5ushE2wbEoRT89IfdyHKWRNFwTlQ5tb6vPC4e
         8+wQ==
X-Gm-Message-State: APjAAAWcohR0Skk2wmB4V1HD2SZ/0t1lAxjcP9k38jkv+k0XbNGWXHSy
        XaC5mbVeU5oitNPafg93jQ9TWeYhSSXwgOfCcI16EeH+4aTF
X-Google-Smtp-Source: APXvYqxrBcPP1lod4jQ5x9Z+3r0zQv4PBuVpX/irM3rH1cFEkIinSrYxZh5p5QiT0thS8XZ7XZ8TETunB7YSrXzC5GGeknq9swin
MIME-Version: 1.0
X-Received: by 2002:a92:7903:: with SMTP id u3mr1546730ilc.254.1579841700988;
 Thu, 23 Jan 2020 20:55:00 -0800 (PST)
Date:   Thu, 23 Jan 2020 20:55:00 -0800
In-Reply-To: <000000000000204b4d059cd6d766@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000638fae059cdb8fe8@google.com>
Subject: Re: KASAN: slab-out-of-bounds Read in bitmap_port_destroy
From:   syzbot <syzbot+b96275fd6ad891076ced@syzkaller.appspotmail.com>
To:     arvid.brodin@alten.se, coreteam@netfilter.org, davem@davemloft.net,
        florent.fourcot@wifirst.fr, fw@strlen.de, jeremy@azazel.net,
        johannes.berg@intel.com, kadlec@netfilter.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot has bisected this bug to:

commit b9a1e627405d68d475a3c1f35e685ccfb5bbe668
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu Jul 4 00:21:13 2019 +0000

    hsr: implement dellink to clean up resources

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17d0c611e00000
start commit:   131701c6 Merge tag 'leds-5.5-rc8' of git://git.kernel.org/..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1430c611e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1030c611e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=83c00afca9cf5153
dashboard link: https://syzkaller.appspot.com/bug?extid=b96275fd6ad891076ced
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15fba721e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1339726ee00000

Reported-by: syzbot+b96275fd6ad891076ced@syzkaller.appspotmail.com
Fixes: b9a1e627405d ("hsr: implement dellink to clean up resources")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
