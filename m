From: Kfir Lavi <lavi.kfir@gmail.com>
Subject: Re: Moving modified packets between processes
Date: Sun, 24 Oct 2010 14:34:08 +0200
Message-ID: <AANLkTi=ngV_Kr0_W6+Q=LQg-x2S58zFYAwKyUZmjV8da@mail.gmail.com>
References: <AANLkTincYmY4rALnsTTy=K32e7s1crw1nc=gBDHyjj58@mail.gmail.com>
	<alpine.LNX.2.01.1010241325410.23809@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50997 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932574Ab0JXMeJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Oct 2010 08:34:09 -0400
Received: by iwn34 with SMTP id 34so3129326iwn.19
        for <netfilter-devel@vger.kernel.org>; Sun, 24 Oct 2010 05:34:08 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1010241325410.23809@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Oct 24, 2010 at 1:31 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
> On Sunday 2010-10-24 10:54, Kfir Lavi wrote:
>
>>I will need to move Ethernet, ARP and IP packets.
>>What are my options regarding moving the packet modified with new
>>custom header from one process to another process?
>
> http://en.wikipedia.org/wiki/Inter-process_communication lists ways of
> transferring data between programs.
>

Thanks,
There is no mention in this page about Netlink.
As I'm getting packets from the kernel via netlink, I would think it's
a good choice to continue using netlink.
I'm trying now to create a small example code using libnl.
What is your take on using netlink?

Regards,
Kfir
