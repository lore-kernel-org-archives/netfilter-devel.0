From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Accessing packet marking functions
Date: Sun, 20 Jun 2010 13:52:18 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1006201351490.23203@obet.zrqbmnf.qr>
References: <1276965739.1476.35.camel@andybev>  <alpine.LSU.2.01.1006192200300.21809@obet.zrqbmnf.qr> <1277032613.1476.93.camel@andybev>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Andrew Beverley <andy@andybev.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:58972 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752372Ab0FTLwU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jun 2010 07:52:20 -0400
In-Reply-To: <1277032613.1476.93.camel@andybev>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 2010-06-20 13:16, Andrew Beverley wrote:

>> >Can somebody point me in the right direction for the correct way of
>> >setting and accessing the mark value of a packet? The TOS feature in
>> >Squid uses setsockopt(). Is there an equivalent for mark? Should I be
>> >using libnetfilter_queue?
>> 
>> setsockopt(fd, SOL_SOCKET, SO_MARK, ...)
>
>I am getting the error "Operation not permitted" when trying to do this.
>Is this because the packet is not in a state where it can be marked, or
>am I doing something stupid? My code is:
>
>int nfmark = 255;
>setsockopt(fd, SOL_SOCKET, SO_MARK, (int *) &nfmark, sizeof(int));
>
>
>The following lines of code in the same place work okay to set the TOS:
>
>int nfmark = 255;
>setsockopt(fd, IPPROTO_IP, IP_TOS, (int *) &nfmark, sizeof(int));

1. Do away with the pointless casts.
2. Needs root privileges.
