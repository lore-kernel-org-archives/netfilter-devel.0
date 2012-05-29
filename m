From: "Steve \(Telsat Broadband\)" <steve@telsatbb.vu>
Subject: RE: Redirect target for IPv6 inclusion
Date: Tue, 29 May 2012 22:27:45 +1100
Message-ID: <008101cd3d8e$150d5ca0$3f2815e0$@telsatbb.vu>
References: <008001cd3d8c$8f4238d0$adc6aa70$@telsatbb.vu> <alpine.LNX.2.01.1205291320040.27038@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>
To: "'Jan Engelhardt'" <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.telsatbb.vu ([180.222.210.5]:65344 "EHLO mail.telsatbb.vu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180Ab2E2L3a (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 May 2012 07:29:30 -0400
In-Reply-To: <alpine.LNX.2.01.1205291320040.27038@frira.zrqbmnf.qr>
Content-Language: en-au
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

Thanks for the super fast response!

I've been reading through your previous posts where you've suggested to use
the TPROXY method, but after hours of attempting to get it operating it
still will not 'proxy' the packets through to the end service.

We're using the 'REDIRECT' target only as an end catch-all method for
unauthenticated users on our network access server; if the user has access
they are forwarded; if not they are redirected to a service listening on any
IP on the same server; however each time I've tested with the TPROXY
options, the listening service never sees any packets.

TPROXY its self seems a little more complicated than I need for this
situation and when I researched the redirect target for v6 I came across
this post which seemed to reference a patch for adding in the redirect
target to ip6tables:
http://marc.info/?l=netfilter-devel&m=132185516524115&w=2

If this patch isn't to be included; could you perhaps point me in the
direction of some detailed reference of how to get TPROXY established in the
same fashion as redirect?

Many thanks
Steve.




-----Original Message-----
From: jengelh@seven.medozas.de [mailto:jengelh@seven.medozas.de] On Behalf
Of Jan Engelhardt
Sent: Tuesday, 29 May 2012 10:21 PM
To: Steve (Telsat Broadband)
Cc: netfilter-devel@vger.kernel.org
Subject: Re: Redirect target for IPv6 inclusion

On Tuesday 2012-05-29 13:16, Steve (Telsat Broadband) wrote:

>Hi All,
>
>I've seen a reference that a REDIRECT target for IPv6 is being worked 
>on and I would like to know if/when it might be included into 
>ip6tables?  This redirect target forms a very large part of our network 
>access server and is critical for our IPv4 operations and will also be 
>critical for us to start operating with IPv6.

There is already redirect-to-local with -j TPROXY.


