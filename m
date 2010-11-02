From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: clone packet with new destination address
Date: Wed, 3 Nov 2010 06:35:08 +0800
Message-ID: <AANLkTimqE3RjrTDgkk2UwaRQmvpJ-m2Ad-CncoTe5Yjk@mail.gmail.com>
References: <4CC1843F.8050903@earthlink.net> <AANLkTi=Y6zdmj4hngEaJPjZjNTTWaWMERfKR=dGSkY9b@mail.gmail.com>
 <AANLkTi=T3QwJp-yVT3GNk46mjmudQ5CrE71YnMqWfsOh@mail.gmail.com>
 <4CCEB69B.5080905@earthlink.net> <alpine.LNX.2.01.1011011405480.4499@obet.zrqbmnf.qr>
 <4CCECEDD.2030107@earthlink.net> <alpine.LNX.2.01.1011012015340.655@obet.zrqbmnf.qr>
 <4CD015BD.2000408@earthlink.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: sclark46@earthlink.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59559 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab0KBWfa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Nov 2010 18:35:30 -0400
Received: by fxm16 with SMTP id 16so6292136fxm.19
        for <netfilter-devel@vger.kernel.org>; Tue, 02 Nov 2010 15:35:29 -0700 (PDT)
In-Reply-To: <4CD015BD.2000408@earthlink.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 2, 2010 at 9:44 PM, Stephen Clark <sclark46@earthlink.net> wrote:
>
> Hmm...,
>
> Sounds like maybe an easier way to do this is to use libipq and the QUEUE
> target to
> select the packets of interest - then make a copy of the packet in userspace
> and
> use a raw socket to send the copy with the new destination address on its
> way.
>
> Does this sound reasonable?

Oh, I think NFLOG will be better, or libpcap & libnet, if you want to
implement this function in user space, because it doesn't delay the
original packets as NFQUEUE does.

-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
