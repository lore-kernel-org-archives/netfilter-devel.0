From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: write a new simple target for netfilter
Date: Mon, 30 Aug 2010 21:07:20 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1008302107030.2418@obet.zrqbmnf.qr>
References: <AANLkTikwLOzN8ycsVxtXy6f57=Y0MG=dMp04v4r8O3cp@mail.gmail.com> <AANLkTinLYRcgf3rxWYMMFZ5BmVdQgTojKExtpNbY-Jo7@mail.gmail.com> <4C7BB8DF.7040208@kaleco.net> <AANLkTimwoCiP=XYaiNp4MMb4krHsF8QebJULfe5fv8Em@mail.gmail.com>
 <alpine.LNX.2.01.1008301658580.24381@obet.zrqbmnf.qr> <AANLkTi=tFWwOrjBKPf2NfT3CCE3zfjpDHnuZnFo4ugy=@mail.gmail.com> <alpine.LNX.2.01.1008302045310.1164@obet.zrqbmnf.qr> <AANLkTinD1+AmaB=n3zofaxSv4Q5h44zxzFrK8441-qUq@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: justin@kaleco.net,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Nicola Padovano <nicola.padovano@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:51024 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496Ab0H3THW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Aug 2010 15:07:22 -0400
In-Reply-To: <AANLkTinD1+AmaB=n3zofaxSv4Q5h44zxzFrK8441-qUq@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2010-08-30 21:00, Nicola Padovano wrote:

>oh sorry, i forget the dmesg output
>
>[ 4871.255884] x_tables: ip_tables: TAR target: only valid for protocol 6

So, you made your module enforce .proto = IPPROTO_TCP, now you also must 
specify -p tcp on iptables.
