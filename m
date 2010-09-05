From: Nicola Padovano <nicola.padovano@gmail.com>
Subject: Re: fragmented packet
Date: Mon, 6 Sep 2010 01:19:35 +0200
Message-ID: <AANLkTi=LVLd2YxkDDeh3uGpW2R3n_QC-F=SHM115bY6b@mail.gmail.com>
References: <AANLkTikniSd5X_ryuhWbAyDLPa7oDSDULe1iYfG02vuP@mail.gmail.com>
 <alpine.LNX.2.01.1009050017350.15290@obet.zrqbmnf.qr> <AANLkTimmN8T4fw=kW+CB0Oh285wrVb4BD4_bx9k_kVxs@mail.gmail.com>
 <AANLkTinNdSq-PMnsYQ7Qb6E0tkhuUF71F2+9ux5OFM3h@mail.gmail.com>
 <AANLkTi=Gv7J5K7kip0JzvDtybsF-hJV_oBm6pQpezhWb@mail.gmail.com>
 <alpine.LNX.2.01.1009051754280.9116@obet.zrqbmnf.qr> <AANLkTik03N1ZRKeF=0YGWSvXOhccrVKMwHEQHB_TVjR6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:54245 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099Ab0IEXT4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Sep 2010 19:19:56 -0400
Received: by wwj40 with SMTP id 40so1630409wwj.1
        for <netfilter-devel@vger.kernel.org>; Sun, 05 Sep 2010 16:19:55 -0700 (PDT)
In-Reply-To: <AANLkTik03N1ZRKeF=0YGWSvXOhccrVKMwHEQHB_TVjR6@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

the default value for mtu (in hping) is 16 bytes!!! what does it mean?
maybe hping (against the rfc) use the fragmentation on the IP
__payload__ and not on the whole IP packet...what do you think? you
can check this with wireshark!
in fact i typed this hping line:

hping -m 160 -d 140 -c 1 localhost

so we have a IP DATAGRAM size = 140data+20ipheader+20tcpheader > MTU=160

but there isn't fragmentation (check it with wireshark) but ip
datagram size is greater than mtu!

So why there isn't fragmentation? because (i suppose) the
fragmentation work only on the IP payload:
IP paylaod = 140data + 20tcpheader = 160 = MTU => no fragmentation!

what do you think? i'm pretty sure of what i say....
