From: Anton Danilov <littlesmilingcloud@gmail.com>
Subject: Re: xtables-addons: Kernel 4.4.0 OOPS with xt_CHAOS
Date: Wed, 11 May 2016 14:31:19 +0300
Message-ID: <CAEzD07J6PnoSeW3LiCGddzz326G8ExNXzgJ_u6ASx0Lt+SXDdw@mail.gmail.com>
References: <CAOxNAe+PUyGO3GkZDP1BMxnXpSjv4KZq7ArB0+aU-N8AK0KTvA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Feliksas <computershik@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:34403 "EHLO
	mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbcEKLbU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 May 2016 07:31:20 -0400
Received: by mail-yw0-f196.google.com with SMTP id i22so3850399ywc.1
        for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2016 04:31:20 -0700 (PDT)
In-Reply-To: <CAOxNAe+PUyGO3GkZDP1BMxnXpSjv4KZq7ArB0+aU-N8AK0KTvA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello.

Seems like this is xt_TARPIT target issue, not the xt_CHAOS.

Have you rebuild the xtables-addons?

2016-05-10 18:15 GMT+03:00 Feliksas <computershik@gmail.com>:
> Greetings,
>
> Opened a bug on Launchpad, since it happened on Ubuntu, probably was
> the wrong place to do that, so reposting here.
>
> After upgrading from Wily to Xenial, my server started being frequently
> rebooted by an HP iLO watchdog. I turned it off, and installed kdump
> tools, and managed to capture a kernel crashdump. Turned out to be a
> network-related OOPS, looks like a bug with xtables modules and kernel
> 4.4.0 (the issue doesn't seem to occur with 4.2.0).
>
> crash tool outputs for two crashes (occured in series with 5-minute
> pause for server coldboot):
> http://pastebin.com/BSyEmUyJ
>
> corresponding kernel backtraces:
> http://pastebin.com/BMmqzrVP
> http://pastebin.com/xQRA2kGP
>
> The offending iptables rule, now removed:
>
> iptables -A INPUT -j CHAOS --tarpit
>
> xtables-addons-dkms and xtables-addons-common version:
>
>  Installed: 2.10-1build1
>   Candidate: 2.10-1build1
>   Version table:
>  *** 2.10-1build1 500
>         500 http://mirror.yandex.ru/ubuntu xenial/universe amd64 Packages
>         100 /var/lib/dpkg/status
>
> Kernel version 4.4.0-22-generic #39-Ubuntu SMP Thu May 5 16:53:32 UTC
> 2016 x86_64 x86_64 x86_64 GNU/Linux
>
> I still have the dumps and can provide any additional information
> necessary.
>
> Bug on Launchpad:
> https://bugs.launchpad.net/ubuntu/+source/xtables-addons/+bug/1579385
>
> ---
> Andrew
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Anton.
