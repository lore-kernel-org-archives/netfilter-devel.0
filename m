From: Andrew Beverley <andy@andybev.com>
Subject: Re: Accessing packet marking functions
Date: Tue, 29 Jun 2010 22:22:47 +0100
Message-ID: <1277846567.1561.21.camel@andybev>
References: <1276965739.1476.35.camel@andybev>
	 <alpine.LSU.2.01.1006192200300.21809@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from earth.simplelists.com ([89.16.184.171]:45894 "EHLO
	earth.simplelists.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab0F2VXK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jun 2010 17:23:10 -0400
In-Reply-To: <alpine.LSU.2.01.1006192200300.21809@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> >I am considering patching Squid proxy so that it retains a packet's mark
> >value if it could not be fetched from the cache. Squid already has
> >similar functionality for the TOS field, but I would like to extend this
> >to netfilter's mark feature.
> >
> >Can somebody point me in the right direction for the correct way of
> >setting and accessing the mark value of a packet? The TOS feature in
> >Squid uses setsockopt(). Is there an equivalent for mark? Should I be
> >using libnetfilter_queue?
> 
> setsockopt(fd, SOL_SOCKET, SO_MARK, ...)

Thanks for the help so far. To retrieve the mark should I just be using:

getsockopt(fd, SOL_SOCKET, SO_MARK, ...) ?

I keep getting a mark of 0 despite setting a mark in PREROUTING. My code
is as follows:

int mark = 0;
int marklen = sizeof(mark);
getsockopt(newsocket, SOL_SOCKET, SO_MARK, &mark, &marklen);



Thanks,

Andy


