From: Nicola Padovano <nicola.padovano@gmail.com>
Subject: Re: write a new simple target for netfilter
Date: Mon, 30 Aug 2010 21:00:11 +0200
Message-ID: <AANLkTinD1+AmaB=n3zofaxSv4Q5h44zxzFrK8441-qUq@mail.gmail.com>
References: <AANLkTikwLOzN8ycsVxtXy6f57=Y0MG=dMp04v4r8O3cp@mail.gmail.com>
	<AANLkTinLYRcgf3rxWYMMFZ5BmVdQgTojKExtpNbY-Jo7@mail.gmail.com>
	<4C7BB8DF.7040208@kaleco.net>
	<AANLkTimwoCiP=XYaiNp4MMb4krHsF8QebJULfe5fv8Em@mail.gmail.com>
	<alpine.LNX.2.01.1008301658580.24381@obet.zrqbmnf.qr>
	<AANLkTi=tFWwOrjBKPf2NfT3CCE3zfjpDHnuZnFo4ugy=@mail.gmail.com>
	<alpine.LNX.2.01.1008302045310.1164@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: justin@kaleco.net,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61478 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653Ab0H3TAN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Aug 2010 15:00:13 -0400
Received: by ewy23 with SMTP id 23so3403878ewy.19
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Aug 2010 12:00:11 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1008302045310.1164@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

oh sorry, i forget the dmesg output

[ 4871.255884] x_tables: ip_tables: TAR target: only valid for protocol 6

On Mon, Aug 30, 2010 at 8:45 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
> On Monday 2010-08-30 20:35, Nicola Padovano wrote:
>
>>what's the problem now!?!?
>>now i have:
>>- a new target module
>>- a makefile (like xt_ipaddr example makefile)
>>- a library .so in /lib/xtables
>>
>>then i do 'make' and then 'insmod'
>>but when i digit:
>>iptables -A INPUT -s 127.0.0.1 -p icmp -j TAR
>>the result is
>>iptables: Invalid argument
>>:(
>
> Run dmesg and see.
>
>



-- 
Nicola Padovano
e-mail: nicola.padovano@gmail.com
web: http://npadov.blogspot.com/
