From: Jan Engelhardt <jengelh@medozas.de>
Subject: RE: loopback forwarding not working (aka implicit source local
 NAT)
Date: Wed, 17 Sep 2008 19:34:34 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0809171934190.1817@fbirervta.pbzchgretzou.qr>
References: <BLU144-W44C48F9DBE68BEE223EE6FD14C0@phx.gbl> <alpine.LNX.1.10.0809171309130.14575@fbirervta.pbzchgretzou.qr> <BLU144-W62E5044D0CD5A32D3132FD14C0@phx.gbl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: d i <navilein@hotmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:33374 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbYIQXeh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Sep 2008 19:34:37 -0400
In-Reply-To: <BLU144-W62E5044D0CD5A32D3132FD14C0@phx.gbl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-09-17 18:43, d i wrote:
> 
>> Can't you just use a VPN solution like ipsec/openvpn for this?
>
>any commercial application is likely to create extra unnecessary
>overhead and complications. a kernel based solution is much cleaner
>and lighter.  yes, i have the ssh on top of it, but i can live with
>that. i'm using the tunnel for other things as well.

Then openswan is probably your best bet.
