From: Peter Marczis <peter.marczis@greenwavesystems.com>
Subject: Re: conntrack (possibly) hangs on our ARM CPU in case we delete 5k+
 connections as fast as possible
Date: Thu, 16 Mar 2017 11:58:18 +0100
Message-ID: <CAMm+moO_0fOrq-gfTAW7rTJtvrwjFoZkw3Z5KjOnjnfcNJM3CA@mail.gmail.com>
References: <CAMm+moMPBxBmrnNuwK6tK_Bu2oKaxOMj=BK=DtpYT_YStO9P7A@mail.gmail.com>
 <20170314103300.GA8738@breakpoint.cc> <CAMm+moPG18qx-2xQ6dXK0p=vTjGNfH6Xo_hk2ADWbf8ocmLTkw@mail.gmail.com>
 <20170314112051.GA23549@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:37346 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751478AbdCPK6U (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Mar 2017 06:58:20 -0400
Received: by mail-it0-f49.google.com with SMTP id g138so37961409itb.0
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Mar 2017 03:58:20 -0700 (PDT)
In-Reply-To: <20170314112051.GA23549@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Florian !
Thanks a lot again for the help. We decided to not backport the
commit, as we far behind. We will upgrade the kernel instead in the
future...
Again, thanks a lot for your help.
Br,
 Peter.
Peter G. Marczis
SW. Developer
Bregneroedvej 96, 3460 Birkeroed, Denmark
Cell: +45 28 12 92 10 Skype: 28199210


*This e-mail may contain confidential and privileged material for the
sole use of the intended recipient. Any review, use, distribution or
disclosure by others is strictly prohibited. If you are not the
intended recipient (or authorized to receive for the recipient),
please contact the sender by reply e-mail and delete all copies of
this message.



On Tue, Mar 14, 2017 at 12:20 PM, Florian Westphal <fw@strlen.de> wrote:
> Peter Marczis <peter.marczis@greenwavesystems.com> wrote:
>> I mean we destroy the sockets, we used two very basic python script to
>> open and close TCP sockets between the WAN and LAN interface.
>
> Then my guess wrt. nf_ct_iterate_cleanup is certainly wrong.
>
