From: "Steve \(Telsat Broadband\)" <steve@telsatbb.vu>
Subject: RE: Redirect target for IPv6 inclusion
Date: Thu, 28 Jun 2012 13:07:33 +1100
Message-ID: <073001cd54d2$ce779060$6b66b120$@telsatbb.vu>
References: <008001cd3d8c$8f4238d0$adc6aa70$@telsatbb.vu> <alpine.LNX.2.01.1205291320040.27038@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>
To: "'Jan Engelhardt'" <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.telsatbb.vu ([180.222.210.5]:51585 "EHLO mail.telsatbb.vu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754231Ab2F1CIq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Jun 2012 22:08:46 -0400
In-Reply-To: <alpine.LNX.2.01.1205291320040.27038@frira.zrqbmnf.qr>
Content-Language: en-au
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

Do you have any documentation reference for using 'redirect-to-local' when
applying it in a rule in the mangle table is reports 'unknown option'

ip6tables v1.4.12.1: unknown option "--redirect-to-local"
Try `ip6tables -h' or 'ip6tables --help' for more information.

Thanks
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


