From: d i <navilein@hotmail.com>
Subject: RE: loopback forwarding not working (aka implicit source local NAT)
Date: Wed, 17 Sep 2008 22:43:30 +0000
Message-ID: <BLU144-W62E5044D0CD5A32D3132FD14C0@phx.gbl>
References: <BLU144-W44C48F9DBE68BEE223EE6FD14C0@phx.gbl>
 <alpine.LNX.1.10.0809171309130.14575@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from blu0-omc1-s7.blu0.hotmail.com ([65.55.116.18]:13755 "EHLO
	blu0-omc1-s7.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753030AbYIQWnb convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Sep 2008 18:43:31 -0400
In-Reply-To: <alpine.LNX.1.10.0809171309130.14575@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> iptables -t raw -A OUTPUT 

with what target ? raw table i think only accepts TRACE and NOTRACK targets, and none of them works with --to ${LANIP}:port 

i actually tried with the DNAT target as well for this, but ends up in error. 

can you please write the whole rule ? is this together with the
iptables -t nat -A OUTPUT -p tcp -DNAT --dport 222 --to ${LANIP}:22
or just by itself ?
 
> Can't you just use a VPN solution like ipsec/openvpn for this?

any commercial application is likely to create extra unnecessary overhead and complications. a kernel based solution is much cleaner and lighter. 
yes, i have the ssh on top of it, but i can live with that. i'm using the tunnel for other things as well. 

thanks! 
_________________________________________________________________
Discover the new Windows Vista
http://search.msn.com/results.aspx?q=windows+vista&mkt=en-US&form=QBRE