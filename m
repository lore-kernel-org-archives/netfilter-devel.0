From: Neal Cardwell <ncardwell@google.com>
Subject: Re: [PATCH RFC 0/5] netfilter: implement netfilter SYN proxy
Date: Fri, 9 Aug 2013 09:55:28 -0400
Message-ID: <CADVnQy=WAiEAcVkB6c3NPATVnd+uAjE87QEWnomWUr4+Dy-fdg@mail.gmail.com>
References: <1375898766.4004.37.camel@edumazet-glaptop>
	<20130807205959.GC21463@macbook.localnet>
	<20130807210540.GE32257@order.stressinduktion.org>
	<20130807.164056.2110811182336568861.davem@davemloft.net>
	<20130808000412.GF32257@order.stressinduktion.org>
	<20130808001344.GA24450@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: David Miller <davem@davemloft.net>,
	Eric Dumazet <eric.dumazet@gmail.com>, pablo@netfilter.org,
	netfilter-devel@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
	mph@one.com, jesper.brouer@gmail.com, as@one.com
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:62921 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967825Ab3HINz3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Aug 2013 09:55:29 -0400
Received: by mail-ea0-f170.google.com with SMTP id h14so2048158eak.15
        for <netfilter-devel@vger.kernel.org>; Fri, 09 Aug 2013 06:55:28 -0700 (PDT)
In-Reply-To: <20130808001344.GA24450@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> It seems, Windows stopped using tcp timestamps at least in windows 8 by
> default.

I agree we should not let the Windows TCP stack behavior dictate the
approach, but just wanted to point out that it's not just Windows 8
that lacks timestamps. It's more that Windows 7 is about the only
sizable Windows deployment that does use timestamps. Windows NT,
Windows 2000, Windows XP, Windows Vista, and Windows 8 all do not use
timestamps by default, and that adds up to about 30-40% of Internet
clients, depending on who's measuring. Something to keep in mind.

neal
