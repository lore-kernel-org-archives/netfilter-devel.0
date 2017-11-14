From: Jay Elliott <jelliott@arista.com>
Subject: Re: [PATCH v2] netfilter: conntrack: clamp timeouts to INT_MAX
Date: Mon, 13 Nov 2017 18:25:35 -0800
Message-ID: <CA+c2rSiciLQiJqzfdwo9p4_POQSZW1mmaQCfsMwPvm4td2wLAw@mail.gmail.com>
References: <1510394920-25302-1-git-send-email-jelliott@arista.com> <20171111182751.GI5512@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qt0-f174.google.com ([209.85.216.174]:54543 "EHLO
        mail-qt0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751184AbdKNCZ5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2017 21:25:57 -0500
Received: by mail-qt0-f174.google.com with SMTP id h42so413084qtk.11
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2017 18:25:57 -0800 (PST)
In-Reply-To: <20171111182751.GI5512@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Nov 11, 2017 at 10:27 AM, Florian Westphal <fw@strlen.de> wrote:
> It also looks wrong.
> let ct->timeout be 1000.
> let nfct_time_stamp be 0x80000000
>
> Then ct->timout is capped to 0x7fffffff.
> Next check considers the timeout to be expired, as 0x7fff... - 0x800 < 0.

Thanks for pointing that out; it does look like something that could
cause troubles.

Is it alright if I submit a fix to this as a separate patch?  I
*think* I have a solution (pending some testing), but I also think
it's outside of the scope of this commit since it's a pre-existing
problem so I'd like to fix it separately.


> So I guess best bet is to actually do a 64bit multiplication, as you
> did, then truncate.
>
> Please use u64 for this (the u_intXX_t types are prehistoric leftovers).

So to clarify, are changing the u_int64_t variables to u64 and fixing
the case where nfct_time_stamp >= 0x8000... the only changes that need
to be made based on the v2 patch I sent out?

Thank you,
Jay Elliott
