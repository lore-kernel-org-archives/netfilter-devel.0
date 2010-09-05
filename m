From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: fragmented packet
Date: Mon, 6 Sep 2010 07:47:19 +0800
Message-ID: <AANLkTi=G5LY--8_-o7yEsLZYvwdXxUpLAF6v2iRpqTEh@mail.gmail.com>
References: <AANLkTikniSd5X_ryuhWbAyDLPa7oDSDULe1iYfG02vuP@mail.gmail.com>
 <alpine.LNX.2.01.1009050017350.15290@obet.zrqbmnf.qr> <AANLkTimmN8T4fw=kW+CB0Oh285wrVb4BD4_bx9k_kVxs@mail.gmail.com>
 <AANLkTinNdSq-PMnsYQ7Qb6E0tkhuUF71F2+9ux5OFM3h@mail.gmail.com>
 <AANLkTi=Gv7J5K7kip0JzvDtybsF-hJV_oBm6pQpezhWb@mail.gmail.com>
 <alpine.LNX.2.01.1009051754280.9116@obet.zrqbmnf.qr> <AANLkTik03N1ZRKeF=0YGWSvXOhccrVKMwHEQHB_TVjR6@mail.gmail.com>
 <AANLkTi=LVLd2YxkDDeh3uGpW2R3n_QC-F=SHM115bY6b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Nicola Padovano <nicola.padovano@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34587 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829Ab0IEXyQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Sep 2010 19:54:16 -0400
Received: by wyf22 with SMTP id 22so2333468wyf.19
        for <netfilter-devel@vger.kernel.org>; Sun, 05 Sep 2010 16:54:14 -0700 (PDT)
In-Reply-To: <AANLkTi=LVLd2YxkDDeh3uGpW2R3n_QC-F=SHM115bY6b@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 6, 2010 at 7:19 AM, Nicola Padovano
<nicola.padovano@gmail.com> wrote:
> the default value for mtu (in hping) is 16 bytes!!! what does it mean?
> maybe hping (against the rfc) use the fragmentation on the IP
> __payload__ and not on the whole IP packet...what do you think? you
> can check this with wireshark!
> in fact i typed this hping line:
>
> hping -m 160 -d 140 -c 1 localhost

Since you use hping, I think it has noting to do with the kernel.
Hping fragments packets in user space other than kernel space.

>
> so we have a IP DATAGRAM size = 140data+20ipheader+20tcpheader > MTU=160
>
> but there isn't fragmentation (check it with wireshark) but ip
> datagram size is greater than mtu!
>
> So why there isn't fragmentation? because (i suppose) the
> fragmentation work only on the IP payload:
> IP paylaod = 140data + 20tcpheader = 160 = MTU => no fragmentation!

Fragmentation is in IP layer. sizeof(ip packet) <= MTU. In your case,
140data + 20ipheader = 160 = MTU => no fragmentation.

>
> what do you think? i'm pretty sure of what i say....
>



-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
