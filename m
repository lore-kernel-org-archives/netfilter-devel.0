From: Peter Marczis <peter.marczis@greenwavesystems.com>
Subject: Re: conntrack (possibly) hangs on our ARM CPU in case we delete 5k+
 connections as fast as possible
Date: Tue, 14 Mar 2017 12:11:21 +0100
Message-ID: <CAMm+moPG18qx-2xQ6dXK0p=vTjGNfH6Xo_hk2ADWbf8ocmLTkw@mail.gmail.com>
References: <CAMm+moMPBxBmrnNuwK6tK_Bu2oKaxOMj=BK=DtpYT_YStO9P7A@mail.gmail.com>
 <20170314103300.GA8738@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:34155 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750771AbdCNLLX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Mar 2017 07:11:23 -0400
Received: by mail-io0-f175.google.com with SMTP id b140so7925276iof.1
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Mar 2017 04:11:22 -0700 (PDT)
In-Reply-To: <20170314103300.GA8738@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
I mean we destroy the sockets, we used two very basic python script to
open and close TCP sockets between the WAN and LAN interface.

Thanks for the hint, I will try those !

Br,
 Peter

On Tue, Mar 14, 2017 at 11:33 AM, Florian Westphal <fw@strlen.de> wrote:
> Peter Marczis <peter.marczis@greenwavesystems.com> wrote:
>> Hello developers,
>> I'm seeking some help to debug and solve one of my issues.
>>
>> We observed that if we create 30k connections, everything works as
>> expected, but when we start to disconnect them,
>> conntrack (well not confirmed yet fully) makes the kernel side busy,
>> and looks like no scheduling happens.
>
> What do you mean by 'disconnect'?  conntrack -F ?
>
> My wild guss is you need to backport
>
> commit d93c6258ee4255749c10012c50a31c08f4e9fb16
> netfilter: conntrack: resched in nf_ct_iterate_cleanup
>
>> The whole thing works as expected, the only problem it makes our
>> processes and well everything on user side hanging for a couple of
>> seconds 10-30s,
>> which of course triggers our HW Watchdog, and we end up in a reboot.
>
> You could try
>
> CONFIG_LOCKUP_DETECTOR=y
> CONFIG_HARDLOCKUP_DETECTOR=y
>



-- 
Br,
 Peter G. Marczis
  SW. Developer
 +45 28 12 92 10
