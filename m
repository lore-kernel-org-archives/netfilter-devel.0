From: Dave Taht <dave.taht@gmail.com>
Subject: Re: xtables2 a8, netlink interface
Date: Fri, 20 Jan 2012 10:23:54 +0100
Message-ID: <CAA93jw40yyZHiK7wbCxOp-CkRvXNT6s0gnmi3gh8MgE62Xu9zg@mail.gmail.com>
References: <1326990381-14534-1-git-send-email-jengelh@medozas.de>
	<20120119165629.2f7c8112@nehalam.linuxnetplumber.net>
	<alpine.LNX.2.01.1201200931340.29049@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Stephen Hemminger <shemminger@vyatta.com>,
	netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:40642 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752715Ab2ATJXz convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Jan 2012 04:23:55 -0500
Received: by obcva7 with SMTP id va7so459508obc.19
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Jan 2012 01:23:54 -0800 (PST)
In-Reply-To: <alpine.LNX.2.01.1201200931340.29049@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 20, 2012 at 9:33 AM, Jan Engelhardt <jengelh@medozas.de> wr=
ote:
> On Friday 2012-01-20 01:56, Stephen Hemminger wrote:
>>>
>>> So here is the first set of patches implementing part of the xt2 co=
re
>>> and nfnl interface. Please review, I am sure you will have somethin=
g
>>> to say :)
>>>
>>> The userspace part is at git://dev.medozas.de/libnetfilter_xtables,
>>> the xtnl-test program compiled as part of the default make target
>>> gives access to the kernel functions implemented by the patches.
>>
>>Does it allow for watching for iptables changes (notifications),
>>similar to what is done for link, address, and qdisc changes?
>
> It certainly does not look like a big deal to write it, so yes, I
> had that on my list of things to add. (Even though I could not come u=
p
> with a usecase for that feature myself yet.)

My use case would be for a routing daemon to detect when nat was presen=
t on
an interface, so as to not advertise invalid routes.

> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
Dave T=E4ht
SKYPE: davetaht
US Tel: 1-239-829-5608
=46R Tel: 0638645374
http://www.bufferbloat.net
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
