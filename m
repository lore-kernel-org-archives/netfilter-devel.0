From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Needs to fix in userspace
Date: Sun, 21 Jun 2009 02:26:01 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0906210224360.8096@fbirervta.pbzchgretzou.qr>
References: <alpine.DEB.2.00.0906210018560.11764@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:41542 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbZFUA0A (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Jun 2009 20:26:00 -0400
In-Reply-To: <alpine.DEB.2.00.0906210018560.11764@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2009-06-21 00:20, Jozsef Kadlecsik wrote:

>Hi,
>
>While working on netfilter/iptables in parallel, I discovered a couple of 
>elements which are missing from userspace, compared to the recent kernel:
>
>- libxt_LED and libxt_osf are missing: the kernel supports the LED
>  target and the osf match, but the userspace doesn't
>- libxt_NFQUEUE and libxt_socket: the kernel parts support revision 0
>  and 1 while the userspace support only revision 0
>- libxt_realm is missing: the kernel supports both IPv4/IPv6, in
>  userspace we have got libipt_realm only

I am not even sure the ipv6 networking stack uses realms in the first place.
