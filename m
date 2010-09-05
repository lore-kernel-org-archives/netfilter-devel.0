From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: fragmented packet
Date: Mon, 6 Sep 2010 00:18:48 +0800
Message-ID: <AANLkTik03N1ZRKeF=0YGWSvXOhccrVKMwHEQHB_TVjR6@mail.gmail.com>
References: <AANLkTikniSd5X_ryuhWbAyDLPa7oDSDULe1iYfG02vuP@mail.gmail.com>
 <alpine.LNX.2.01.1009050017350.15290@obet.zrqbmnf.qr> <AANLkTimmN8T4fw=kW+CB0Oh285wrVb4BD4_bx9k_kVxs@mail.gmail.com>
 <AANLkTinNdSq-PMnsYQ7Qb6E0tkhuUF71F2+9ux5OFM3h@mail.gmail.com>
 <AANLkTi=Gv7J5K7kip0JzvDtybsF-hJV_oBm6pQpezhWb@mail.gmail.com> <alpine.LNX.2.01.1009051754280.9116@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Nicola Padovano <nicola.padovano@gmail.com>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52411 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193Ab0IEQTJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Sep 2010 12:19:09 -0400
Received: by wwj40 with SMTP id 40so5356774wwj.1
        for <netfilter-devel@vger.kernel.org>; Sun, 05 Sep 2010 09:19:08 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1009051754280.9116@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Sep 5, 2010 at 11:54 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
> On Sunday 2010-09-05 17:24, Changli Gao wrote:
>
>>On Sun, Sep 5, 2010 at 5:45 PM, Nicola Padovano
>><nicola.padovano@gmail.com> wrote:
>>> i'm so sorry...i've said ethernet mtu=16bytes...........
>>
>>the minimal size of an ethernet frame is 60 bytes.
>
> But loopback is not an ethernet device.
>

But I don't think IP protocol can work with a MTU <= 20(sizeof(struct
iphdr)) can work. How can IP fragment/defragment works without a full
IP header.

-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
