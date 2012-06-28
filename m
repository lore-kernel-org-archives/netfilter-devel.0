From: Jan Engelhardt <jengelh@inai.de>
Subject: RE: Redirect target for IPv6 inclusion
Date: Thu, 28 Jun 2012 12:08:35 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1206281203010.18948@frira.zrqbmnf.qr>
References: <008001cd3d8c$8f4238d0$adc6aa70$@telsatbb.vu> <alpine.LNX.2.01.1205291320040.27038@frira.zrqbmnf.qr> <073001cd54d2$ce779060$6b66b120$@telsatbb.vu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: "Steve (Telsat Broadband)" <steve@telsatbb.vu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:35560 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932780Ab2F1KIk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Jun 2012 06:08:40 -0400
In-Reply-To: <073001cd54d2$ce779060$6b66b120$@telsatbb.vu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2012-06-28 04:07, Steve (Telsat Broadband) wrote:

>>>I've seen a reference that a REDIRECT target for IPv6 is being worked 
>>>on and I would like to know if/when it might be included into 
>>>ip6tables?  This redirect target forms a very large part of our network 
>>>access server and is critical for our IPv4 operations and will also be 
>>>critical for us to start operating with IPv6.
>>
>>There is already redirect-to-local with -j TPROXY.
>
>Do you have any documentation reference for using 'redirect-to-local' when
>applying it in a rule in the mangle table is reports 'unknown option'
>
>ip6tables v1.4.12.1: unknown option "--redirect-to-local"

I did not say it was a target option. It is in fact a term for a
decision of the routing engine. As per ip(8), there is

       TYPE := [ unicast | local | broadcast | multicast | throw |
                 unreachable
               | prohibit | blackhole | ...

some implemented, some not.
