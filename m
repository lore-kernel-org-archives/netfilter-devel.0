From: =?ISO-8859-2?Q?=A3ukasz_Czy=BF?= <lukasz.czyzz@gmail.com>
Subject: Re: NAT IPv6/IPv4 translator - request for review, plus two questions
 regarding code
Date: Fri, 16 Mar 2012 20:52:56 +0100
Message-ID: <CALJVcJHUD=M-PnNAUYo0x8kMmBrt06kEBFXEGM2_5ZnA2ePaBA@mail.gmail.com>
References: <CALJVcJFZ_qk_qdNFnfveQx+GJF3iXLmMBe=ezgphUiY2uiFpng@mail.gmail.com>
	<CAHo-Ooy2Rmu=gwgoAcKfVoYbHfABkJkjK2_MSDu1j7Eq0Sac_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: =?ISO-8859-2?Q?Maciej_=AFenczykowski?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52307 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307Ab2CPTw5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Mar 2012 15:52:57 -0400
Received: by vcqp1 with SMTP id p1so4618879vcq.19
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Mar 2012 12:52:56 -0700 (PDT)
In-Reply-To: <CAHo-Ooy2Rmu=gwgoAcKfVoYbHfABkJkjK2_MSDu1j7Eq0Sac_g@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>
> I would probably suggest implementing this not as netfilter hooks,
> but rather as a virtual device (tun/tap/veth/dummy like).
>

This exactly how I implemented it in early version of my module. I
changed to netfilter-hook solution, because it seemed to me that
translation process gets faster by doing so. At the other hand
netfilter way generates some additional processing (really small) for
every received packet, even if it is not dedicated to translation - so
it is some kind of trade off.

>
> From the web page it doesn't sound like there's any actual netfilter
> interaction...
>

Yes , as I wrote in my previous message - my module only registers its
functions in netfilter hooks, it doesn't use any other netfilter
functionality.

> Furthermore, I would hazard a guess that requiring an IPv4 address for
> every IPv6 host desiring to connect to an IPv4 address makes
> this a little uninteresting.... to quote:
>

Yes, I agree that it is big constraint, despite that such
configuration can be useful in some environment, when one needs to
have IPv6 host which should be able to reach IPv4 network from static
IPv4 address, reserved to this host only, without port forwarding. It
is similar to one of Cisco NAT translation schemes, called Static NAT.

I am aware that I would have to implement port forwarding option to
make translator more functional. But it is big topic and I do not have
time to code it at this moment. I am just looking for review of my
kernel module.



Lukasz
