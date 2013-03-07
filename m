From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 1/6] build: also use libtool for install stage
Date: Thu, 7 Mar 2013 21:39:30 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1303072138210.22653@nerf07.vanv.qr>
References: <1359381586-11940-1-git-send-email-jengelh@inai.de> <1359381586-11940-2-git-send-email-jengelh@inai.de> <20130205033007.GA20407@localhost> <20130306110836.GA4017@altlinux.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: "Dmitry V. Levin" <ldv@altlinux.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:39268 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932747Ab3CGUjb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Mar 2013 15:39:31 -0500
In-Reply-To: <20130306110836.GA4017@altlinux.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2013-03-06 12:08, Dmitry V. Levin wrote:
>> > 
>> > There will be extra "warnings" emitted by libtool during `make install`,
>> > like:
>> > 
>> > 	libtool: install: warning: relinking "libxt_AUDIT.la"
>> > 
>> > This is normal (and unfixable)
>> 
>> I prefer that distros live with that warning. Users will be annoyed by
>> that warning for sure.
>
>[...]
>With regards to libtool's warnings about relinking, it happens to all
>hundreds of packages that manipulate RPATH entries during build, so
>the amount of annoyance among libtool users would hardly increase.

That said, the --no-warn option is only available in libtool >= 2.4.2
or so; it is not present in 2.4(.0).
I nevertheless have a patch (unpushed) ontop of my latest set (pushed).
