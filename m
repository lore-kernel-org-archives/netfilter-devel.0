From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: possible deadlock in xt_find_target
Date: Thu, 1 Feb 2018 19:17:27 +0100
Message-ID: <CACT4Y+Y4kTjZH2L=8wGg6K_uYH9WgnHcjWUx1PTJcKMKxYqm=w@mail.gmail.com>
References: <001a113f890435f93f0563c78742@google.com> <20180201180656.GB11048@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: syzbot <syzbot+5208e0989d3d8116837d@syzkaller.appspotmail.com>,
        netfilter-devel@vger.kernel.org, syzkaller-bugs@googlegroups.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f52.google.com ([74.125.83.52]:47024 "EHLO
        mail-pg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752839AbeBASRs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Feb 2018 13:17:48 -0500
Received: by mail-pg0-f52.google.com with SMTP id s9so12772246pgq.13
        for <netfilter-devel@vger.kernel.org>; Thu, 01 Feb 2018 10:17:48 -0800 (PST)
In-Reply-To: <20180201180656.GB11048@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 1, 2018 at 7:06 PM, Florian Westphal <fw@strlen.de> wrote:
> #syz fix: netfilter: on sockopt() acquire sock lock only in the required scope

Note that if you add the Reported-by tag to the commit with hash that
points to this report, you don't need to do "#syz fix". If you want to
fix several bugs at once, you can add several Reported-by tags.
But doing both things should work too, just wanted to reduce burden on
you in future.

Thanks
