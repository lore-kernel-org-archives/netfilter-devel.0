From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf] netfilter: xt_NFLOG: fix unexpected truncated packet
Date: Sun, 30 Oct 2016 11:04:41 +0800
Message-ID: <CAML_gOcF=1cC5e57Q1SKt5tnZj3E==pMYmpc1yD98fFrCrp4ug@mail.gmail.com>
References: <1476191025-16296-1-git-send-email-zlpnobody@163.com> <Pine.LNX.4.64.1610291902380.20350@nacho.alt.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Liping Zhang <zlpnobody@163.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>,
        Justin Piszcz <jpiszcz@lucidpixels.com>,
        Vishwanath Pai <vpai@akamai.com>,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Chris Caputo <ccaputo@alt.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f193.google.com ([209.85.217.193]:36585 "EHLO
        mail-ua0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753853AbcJ3DEn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 Oct 2016 23:04:43 -0400
Received: by mail-ua0-f193.google.com with SMTP id 12so4104908uas.3
        for <netfilter-devel@vger.kernel.org>; Sat, 29 Oct 2016 20:04:42 -0700 (PDT)
In-Reply-To: <Pine.LNX.4.64.1610291902380.20350@nacho.alt.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2016-10-30 3:04 GMT+08:00 Chris Caputo <ccaputo@alt.net>:
> Pablo,
>
> Can we get this patch approved?  It is definitely needed for the 4.8.x
> tree and 4.9-rcX and mainline.
>
> Thanks,
> Chris
>

Hi,

This patch was already applied, and was upstream to net.git:
https://git.kernel.org/cgit/linux/kernel/git/davem/net.git/commit/?id=6d19375b58763fefc2f215fb45117d3353ced888

I think you will see this patch in mainline soon.
