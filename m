From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: IP traffic rerouting
Date: Fri, 14 Aug 2009 01:37:27 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0908140126250.28623@fbirervta.pbzchgretzou.qr>
References: <4A849733.4020404@tootai.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Daniel Huhardeaux <daniel.huhardeaux@tootai.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38729 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbZHMXh2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Aug 2009 19:37:28 -0400
In-Reply-To: <4A849733.4020404@tootai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2009-08-14 00:44, Daniel Huhardeaux wrote:
>
> is there a solution to reroute all traffic (icmp, udp, tcp, ...) from
> one IP address to another one?


Routing tables are controlled with iproute2. Replace the variables by 
something appropriate. The freely choosable $number usually wants to be  
>= 1 to avoid surprises.

ip rule add from $srcaddr table $number prio $prio
ip route add default via $toaddr table $number

(The main routing table has number 254, and is usually at the lowest 
prio of 32767. The "prio $prio" part is thus usually optional in 
practice.)
