From: Andrew Beverley <andy@andybev.com>
Subject: Re: Accessing packet marking functions
Date: Sat, 19 Jun 2010 21:50:00 +0100
Message-ID: <1276980600.1476.82.camel@andybev>
References: <1276965739.1476.35.camel@andybev>
	 <alpine.LSU.2.01.1006192200300.21809@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from earth.simplelists.com ([89.16.184.171]:50318 "EHLO
	earth.simplelists.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab0FSUuM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 Jun 2010 16:50:12 -0400
In-Reply-To: <alpine.LSU.2.01.1006192200300.21809@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> >Can somebody point me in the right direction for the correct way of
> >setting and accessing the mark value of a packet? The TOS feature in
> >Squid uses setsockopt(). Is there an equivalent for mark? Should I be
> >using libnetfilter_queue?
> 
> setsockopt(fd, SOL_SOCKET, SO_MARK, ...)

Thanks Jan. I was honestly googling that for ages :-)

Not really for discussion here, but the whole concept of having a proxy
server in combination with traffic shaping rules makes things
challenging. All my traffic shaping rules are based on source and
destination interfaces, ports, and client addresses, so once a proxy is
thrown in, that sort of information is unavailable, as all the traffic
is no longer forwarded, but instead goes to and from the local host...

Andy


