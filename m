From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: write a new simple target for netfilter
Date: Mon, 30 Aug 2010 20:45:37 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1008302045310.1164@obet.zrqbmnf.qr>
References: <AANLkTikwLOzN8ycsVxtXy6f57=Y0MG=dMp04v4r8O3cp@mail.gmail.com> <AANLkTinLYRcgf3rxWYMMFZ5BmVdQgTojKExtpNbY-Jo7@mail.gmail.com> <4C7BB8DF.7040208@kaleco.net> <AANLkTimwoCiP=XYaiNp4MMb4krHsF8QebJULfe5fv8Em@mail.gmail.com>
 <alpine.LNX.2.01.1008301658580.24381@obet.zrqbmnf.qr> <AANLkTi=tFWwOrjBKPf2NfT3CCE3zfjpDHnuZnFo4ugy=@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: justin@kaleco.net,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Nicola Padovano <nicola.padovano@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:59160 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754911Ab0H3Spi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Aug 2010 14:45:38 -0400
In-Reply-To: <AANLkTi=tFWwOrjBKPf2NfT3CCE3zfjpDHnuZnFo4ugy=@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2010-08-30 20:35, Nicola Padovano wrote:

>what's the problem now!?!?
>now i have:
>- a new target module
>- a makefile (like xt_ipaddr example makefile)
>- a library .so in /lib/xtables
>
>then i do 'make' and then 'insmod'
>but when i digit:
>iptables -A INPUT -s 127.0.0.1 -p icmp -j TAR
>the result is
>iptables: Invalid argument
>:(

Run dmesg and see.

