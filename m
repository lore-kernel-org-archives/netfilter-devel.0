From: Andrew Beverley <andy@andybev.com>
Subject: Re: Accessing packet marking functions
Date: Sun, 20 Jun 2010 12:16:53 +0100
Message-ID: <1277032613.1476.93.camel@andybev>
References: <1276965739.1476.35.camel@andybev>
	 <alpine.LSU.2.01.1006192200300.21809@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from earth.simplelists.com ([89.16.184.171]:57032 "EHLO
	earth.simplelists.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab0FTLRH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jun 2010 07:17:07 -0400
In-Reply-To: <alpine.LSU.2.01.1006192200300.21809@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> >Can somebody point me in the right direction for the correct way of
> >setting and accessing the mark value of a packet? The TOS feature in
> >Squid uses setsockopt(). Is there an equivalent for mark? Should I be
> >using libnetfilter_queue?
> 
> setsockopt(fd, SOL_SOCKET, SO_MARK, ...)

I am getting the error "Operation not permitted" when trying to do this.
Is this because the packet is not in a state where it can be marked, or
am I doing something stupid? My code is:

int nfmark = 255;
setsockopt(fd, SOL_SOCKET, SO_MARK, (int *) &nfmark, sizeof(int));


The following lines of code in the same place work okay to set the TOS:

int nfmark = 255;
setsockopt(fd, IPPROTO_IP, IP_TOS, (int *) &nfmark, sizeof(int));


Thanks,

Andy


