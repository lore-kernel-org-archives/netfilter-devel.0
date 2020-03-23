Return-Path: <SRS0=yGNv=5I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45AA0C4332B
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Mar 2020 10:39:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 268ED2074D
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Mar 2020 10:39:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbgCWKjF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 23 Mar 2020 06:39:05 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:48495 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727937AbgCWKjF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Mar 2020 06:39:05 -0400
Received: by mail-io1-f70.google.com with SMTP id b136so11297428iof.15
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Mar 2020 03:39:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=E3FbehYY8mAkOJJQcLvCMQ904m/hZIJiIkOCeXRTCwQ=;
        b=Eg7WgziHfMNWkBcSfY8AQ8vUUW/dqR6M8sgvT44C+3iG5rj038AiY1q2DcBul9wLRY
         aCsLTpiWJpm65GJusTgs8bgg8+JDeUZH+4+Dt9I8Xc18tbJLN5fyKt03PojoCWlsqIkD
         LKzbvbZqtBXd/t2wfmGuUDVOMZef3XBFOMAq2N1PJElUk4XPeiAyJNA/J4BF+xRUYBoj
         3nFSQ6CKq98p+WXNDh48Yuss1E/9MM2V/mtBnh3ka67mzk8tTDiSrUJf3C4O1z9qpkyl
         ZhRehug4GPGRbsjxU1kpByjLUOJmW12i/3afM+Loxf3bLn3Kjx7BhgQnb7TD5GslJZ3+
         ER9g==
X-Gm-Message-State: ANhLgQ2ORPDx+8EMXqBcQxdXvgHp2GY8mzQS7VGoVK/aNTh+gviwTRT/
        kEpE92RVtn3khHDbp9uK2qSkl17+pVj5yTp9VSNJU3+LfPDC
X-Google-Smtp-Source: ADFU+vuCV647OHMwnKb02Ze7RBGdSa3A1fMxiZF+p+y1+XffxMam6T5V6B/LWpW4eBuh5XQ284LGQv6ZKqYyY6/0QzvRHGijREZz
MIME-Version: 1.0
X-Received: by 2002:a02:c85a:: with SMTP id r26mr20323367jao.74.1584959942803;
 Mon, 23 Mar 2020 03:39:02 -0700 (PDT)
Date:   Mon, 23 Mar 2020 03:39:02 -0700
In-Reply-To: <000000000000b6da7b059c8110c4@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005fc4c505a1833ed3@google.com>
Subject: Re: general protection fault in nf_flow_table_offload_setup
From:   syzbot <syzbot+e93c1d9ae19a0236289c@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit a7da92c2c8a1faf253a3b3e292fda6910deba540
Author: Florian Westphal <fw@strlen.de>
Date:   Mon Feb 3 12:06:18 2020 +0000

    netfilter: flowtable: skip offload setup if disabled

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1522646be00000
start commit:   0a44cac8 Merge tag 'dma-mapping-5.6' of git://git.infradea..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=31018567b8f0fc70
dashboard link: https://syzkaller.appspot.com/bug?extid=e93c1d9ae19a0236289c
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=126c7e09e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1208fdd9e00000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: netfilter: flowtable: skip offload setup if disabled

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
