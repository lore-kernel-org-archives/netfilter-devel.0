From: Florian Westphal <fw@strlen.de>
Subject: Re: conntrack (possibly) hangs on our ARM CPU in case we delete 5k+
 connections as fast as possible
Date: Tue, 14 Mar 2017 11:33:00 +0100
Message-ID: <20170314103300.GA8738@breakpoint.cc>
References: <CAMm+moMPBxBmrnNuwK6tK_Bu2oKaxOMj=BK=DtpYT_YStO9P7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Peter Marczis <peter.marczis@greenwavesystems.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:38402 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750771AbdCNKdT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Mar 2017 06:33:19 -0400
Content-Disposition: inline
In-Reply-To: <CAMm+moMPBxBmrnNuwK6tK_Bu2oKaxOMj=BK=DtpYT_YStO9P7A@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Peter Marczis <peter.marczis@greenwavesystems.com> wrote:
> Hello developers,
> I'm seeking some help to debug and solve one of my issues.
> 
> We observed that if we create 30k connections, everything works as
> expected, but when we start to disconnect them,
> conntrack (well not confirmed yet fully) makes the kernel side busy,
> and looks like no scheduling happens.

What do you mean by 'disconnect'?  conntrack -F ?

My wild guss is you need to backport

commit d93c6258ee4255749c10012c50a31c08f4e9fb16
netfilter: conntrack: resched in nf_ct_iterate_cleanup

> The whole thing works as expected, the only problem it makes our
> processes and well everything on user side hanging for a couple of
> seconds 10-30s,
> which of course triggers our HW Watchdog, and we end up in a reboot.

You could try

CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y

