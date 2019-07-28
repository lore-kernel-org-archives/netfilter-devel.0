Return-Path: <SRS0=gL2e=VZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74101C7618B
	for <netfilter-devel@archiver.kernel.org>; Sun, 28 Jul 2019 16:51:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BC1621738
	for <netfilter-devel@archiver.kernel.org>; Sun, 28 Jul 2019 16:51:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cumulusnetworks.com header.i=@cumulusnetworks.com header.b="OfC8vdkx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbfG1QvJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 28 Jul 2019 12:51:09 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36312 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbfG1QvI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 28 Jul 2019 12:51:08 -0400
Received: by mail-wr1-f68.google.com with SMTP id n4so59342145wrs.3
        for <netfilter-devel@vger.kernel.org>; Sun, 28 Jul 2019 09:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=5K+SuxpGvXfQ///N9XK1+tF5GqeC/HVgCK0aC6WVZtU=;
        b=OfC8vdkx64xyhbGpo8KCxYo+Lm9vikgIF+jEkc9Nv6Yxn4gP0DjP/kIQg51vfl7xGC
         jV8WoJ2HAmWTP3kg4XrVF4jk+AGlMOm8gSNklsPETgCIJkZwo7ReZmIX238PnP9Qyin9
         yd0vAmYMJBw9QIB5VddDz14pj4cZtz7R9nCvg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5K+SuxpGvXfQ///N9XK1+tF5GqeC/HVgCK0aC6WVZtU=;
        b=rXoHH2MPS3i8eUfjzVZDijgYUSsplzOL58INaO5KUqJyRHmqznKbaXZrkj6l3sFv3z
         4JrEqiERQ720a/sMr++uNYq7jmIEQlk0XtYRNn5umm9fZEEbsAvIR0yyBCeWP8MB8Ahi
         vLoY1cvMtpp2hrfPm9kQfNAsogOSDMCmF12WSJ/hRQylNquzVH6IvyBCVfDEvUY7wAtr
         WtvZbu8r5r57hJdES2WRm9FEgnR887aXKPHHJyBot/7XSdWMU3UTxbO/hqXSJyuJdCPZ
         Pwr7rMqS+9am1bULFi5FL0xglAB/paoSR3H10sWjPgZ33rSccwBjJJ682F4+90Vl7oqp
         m8/Q==
X-Gm-Message-State: APjAAAWQs3ASdVl+QDyVINOHB66Z8fx4P38zaSqGWgNA0ZPOY0PwylRV
        BWqsZNdK8dYKWPysErYf/BfW3w==
X-Google-Smtp-Source: APXvYqw83tJg77hrak37KuOXdaRIdcSuKl5v2EFRFUxMzT6hdmsmAZ/ogHbPEp7hpFDY2TYo5CjGUQ==
X-Received: by 2002:adf:ea87:: with SMTP id s7mr116716538wrm.24.1564332666403;
        Sun, 28 Jul 2019 09:51:06 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id i12sm69356215wrx.61.2019.07.28.09.51.04
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Jul 2019 09:51:05 -0700 (PDT)
Subject: Re: memory leak in fdb_create
To:     syzbot <syzbot+88533dc8b582309bf3ee@syzkaller.appspotmail.com>,
        bridge@lists.linux-foundation.org, bsingharora@gmail.com,
        coreteam@netfilter.org, davem@davemloft.net, duwe@suse.de,
        kaber@trash.net, kadlec@blackhole.kfki.hu,
        linux-kernel@vger.kernel.org, mingo@redhat.com, mpe@ellerman.id.au,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, roopa@cumulusnetworks.com,
        rostedt@goodmis.org, syzkaller-bugs@googlegroups.com
References: <0000000000008be1b2058ebe7805@google.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <d16a3297-d651-0a32-e803-774a9c8c61bf@cumulusnetworks.com>
Date:   Sun, 28 Jul 2019 19:51:03 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <0000000000008be1b2058ebe7805@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 28/07/2019 17:20, syzbot wrote:
> syzbot has bisected this bug to:
> 
> commit 04cf31a759ef575f750a63777cee95500e410994
> Author: Michael Ellerman <mpe@ellerman.id.au>
> Date:   Thu Mar 24 11:04:01 2016 +0000
> 
>     ftrace: Make ftrace_location_range() global
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1538c778600000
> start commit:   abf02e29 Merge tag 'pm-5.2-rc6' of git://git.kernel.org/pu..
> git tree:       upstream
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=1738c778600000
> console output: https://syzkaller.appspot.com/x/log.txt?x=1338c778600000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=56f1da14935c3cce
> dashboard link: https://syzkaller.appspot.com/bug?extid=88533dc8b582309bf3ee
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16de5c06a00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10546026a00000
> 
> Reported-by: syzbot+88533dc8b582309bf3ee@syzkaller.appspotmail.com
> Fixes: 04cf31a759ef ("ftrace: Make ftrace_location_range() global")
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

I see the problem, it'd happen if the multicast stats memory allocation fails on bridge
init then the fdb added due to the default vlan would remain and the bridge kmem cache
would be destroyed while not empty (you can even trigger a BUG because of that).
I'll post a patch shortly after running a few tests.

Thanks,
 Nik

