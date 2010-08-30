From: Nicola Padovano <nicola.padovano@gmail.com>
Subject: Re: write a new simple target for netfilter
Date: Mon, 30 Aug 2010 23:47:36 +0200
Message-ID: <AANLkTikqMSHJDDe7VsOVUc_yqCERNnHXsb7pVNXmZnGP@mail.gmail.com>
References: <AANLkTikwLOzN8ycsVxtXy6f57=Y0MG=dMp04v4r8O3cp@mail.gmail.com>
	<AANLkTinLYRcgf3rxWYMMFZ5BmVdQgTojKExtpNbY-Jo7@mail.gmail.com>
	<4C7BB8DF.7040208@kaleco.net>
	<AANLkTimwoCiP=XYaiNp4MMb4krHsF8QebJULfe5fv8Em@mail.gmail.com>
	<alpine.LNX.2.01.1008301658580.24381@obet.zrqbmnf.qr>
	<AANLkTi=tFWwOrjBKPf2NfT3CCE3zfjpDHnuZnFo4ugy=@mail.gmail.com>
	<alpine.LNX.2.01.1008302045310.1164@obet.zrqbmnf.qr>
	<AANLkTinD1+AmaB=n3zofaxSv4Q5h44zxzFrK8441-qUq@mail.gmail.com>
	<alpine.LNX.2.01.1008302107030.2418@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:59412 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528Ab0H3Vrh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Aug 2010 17:47:37 -0400
Received: by wwi14 with SMTP id 14so329342wwi.1
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Aug 2010 14:47:36 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1008302107030.2418@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

i'm sorry...but i've restarted my computer and then i tried to insmod
the module and now i have:
insmod: error inserting './xt_TAR.ko': -1 Unknown symbol in module
with this dmesg result:
[  413.359837] xt_TAR: Unknown symbol xt_register_target (err 0)
[  413.360019] xt_TAR: Unknown symbol xt_unregister_target (err 0)

wtf now? help me, please. i need to sleep. :P

On Mon, Aug 30, 2010 at 9:07 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
> On Monday 2010-08-30 21:00, Nicola Padovano wrote:
>
>>oh sorry, i forget the dmesg output
>>
>>[ 4871.255884] x_tables: ip_tables: TAR target: only valid for protocol 6
>
> So, you made your module enforce .proto = IPPROTO_TCP, now you also must
> specify -p tcp on iptables.
>



-- 
Nicola Padovano
e-mail: nicola.padovano@gmail.com
web: http://npadov.blogspot.com/
