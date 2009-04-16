From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: NAT and IPSEC
Date: Thu, 16 Apr 2009 15:30:11 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0904161529420.27884@fbirervta.pbzchgretzou.qr>
References: <49E72BE9.6020007@earthlink.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Stephen Clark <sclark46@earthlink.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50993 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782AbZDPNaO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Apr 2009 09:30:14 -0400
In-Reply-To: <49E72BE9.6020007@earthlink.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2009-04-16 15:00, Stephen Clark wrote:

> Hello,
>
> I have to separate ipsec tunnels going to two different private networks. How
> do I keep iptables from natting the traffic destined for these 2 networks. I
> tried:
>
> iptables -t nat -A POSTROUTING -o eth1 -d ! 192.168.1.0/24  -d ! 172.16.0.0/16
> -j MASQUERADE
>
> but it says only one -d is allowed. So I tried

Create a new chain from which you prematurely exit if the daddr is 
192.168.1.0/24 or 172.16.0.0/16, and the third rule would masq.

> iptables -t nat -A POSTROUTING -o eth1 -d ! ( 192.168.1.0/24 || 172.16.0.0/16 )
> -j MASQUERADE
>
> and it says "(" error. So how do I specify multiple destination
> networks/addresses to be excluded from being natted.
