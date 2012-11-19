From: Ricardo Klein <klein.rfk@gmail.com>
Subject: Re: [ANNOUNCE] ipset 6.15 released
Date: Mon, 19 Nov 2012 15:53:50 -0200
Message-ID: <CADuigkXWY2mkzWRTDvi9wv5VTXt4phEHH69GArut9HY20iouOg@mail.gmail.com>
References: <alpine.DEB.2.00.1211191356240.21756@blackhole.kfki.hu>
	<CADuigkX_Mr_7ur=mta0DKhB7vmdXeAytBaDvP_zKHug5sO8zbg@mail.gmail.com>
	<alpine.DEB.2.00.1211191847190.23128@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:64762 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab2KSRxu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Nov 2012 12:53:50 -0500
In-Reply-To: <alpine.DEB.2.00.1211191847190.23128@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef,

I have deleted "configure" and run autogen again... I think the
problem was created by my first test, because I tried to run autogen
without having autogen, pkg-tool etc.. on this box...
Now it has built succefull....
--
Att...

Ricardo Felipe Klein
klein.rfk@gmail.com


On Mon, Nov 19, 2012 at 3:50 PM, Jozsef Kadlecsik
<kadlec@blackhole.kfki.hu> wrote:
> On Mon, 19 Nov 2012, Ricardo Klein wrote:
>
>> It fails on ./configure on CentOS 6.3 x84_64 with the message:./configure: line
>> 14702: syntax error near unexpected token `libmnl,'
>> ./configure: line 14702: `PKG_CHECK_MODULES(libmnl, libmnl >= 1)'
>
> It's funny, because that part was not touched at all. Can you successfully
> run "./configure" in ipset 6.14??
>
> Best regards,
> Jozsef
> -
> E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
> PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
> Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
>           H-1525 Budapest 114, POB. 49, Hungary
