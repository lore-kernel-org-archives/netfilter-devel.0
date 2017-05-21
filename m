From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf-next 2/3] netfilter: nf_ct_helper: use
 nf_ct_iterate_cleanup to unlink helper objs
Date: Sun, 21 May 2017 18:17:30 +0800
Message-ID: <CAML_gOc1OHEc_evYoXj2f0O1CMGLVc0MMNYgVE0xNtzXPXNJtQ@mail.gmail.com>
References: <1495345149-57674-1-git-send-email-zlpnobody@163.com>
 <1495345149-57674-3-git-send-email-zlpnobody@163.com> <20170521081521.GD1004@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Liping Zhang <zlpnobody@163.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f171.google.com ([209.85.217.171]:32860 "EHLO
        mail-ua0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750824AbdEUKRb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 May 2017 06:17:31 -0400
Received: by mail-ua0-f171.google.com with SMTP id e28so45490058uah.0
        for <netfilter-devel@vger.kernel.org>; Sun, 21 May 2017 03:17:31 -0700 (PDT)
In-Reply-To: <20170521081521.GD1004@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

2017-05-21 16:15 GMT+08:00 Florian Westphal <fw@strlen.de>:
[...]
> this is broken for unconfirmed conntracks, as
> other cpu can reallocate the extension area.

Right, I missed this point, thanks for your reminder.

> For the module removal case, we have no choice but to toss the
> unconfirmed conntracks.
>
> Same for patch #3.
>
> I plan to submit my patches soon, perhaps its best if I only
> submit the first couple of patches so you can rebase on top of that?

I read your nfct_iterate_cleanup_15 patch series just now.
Your patch set did more jobs, also including all the jobs which
my patch set did. :)

I think it's better to do these things together, so I'm fine if you
can mark my patch set as Superseded. :)

> Alternatively, I'm fine if your patches go in first, I can also
> just rebase on top.
