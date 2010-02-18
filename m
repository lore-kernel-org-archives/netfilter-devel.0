From: Patrick McHardy <kaber@trash.net>
Subject: Re: nf_conntrack_count versus '/proc/net/nf_conntrack | wc -l' count
Date: Thu, 18 Feb 2010 19:22:31 +0100
Message-ID: <4B7D8567.2060301@trash.net>
References: <48ceaa831002150927q166b5955gfa0e1e465903d29d@mail.gmail.com>	 <1266264287.2859.0.camel@edumazet-laptop>	 <alpine.LSU.2.01.1002152132250.21055@obet.zrqbmnf.qr>	 <48ceaa831002151308y5bb2606n2058599f3ec4b82@mail.gmail.com>	 <1266270757.2859.27.camel@edumazet-laptop>	 <48ceaa831002151400q4178d121h28887cfdf6625499@mail.gmail.com>	 <1266271377.2859.28.camel@edumazet-laptop>	 <48ceaa831002151410j1dbdfce3tcbdb5ceaa86b0e2b@mail.gmail.com>	 <48ceaa831002180940y65af65b4p5d887f2f1a50b4b@mail.gmail.com>	 <1266515463.2877.10.camel@edumazet-laptop> <5415ae081002181012x4f7c95a4ncec563f69ae3562e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	Afi Gjermund <afigjermund@gmail.com>,
	Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Douglas Diniz <dgdiniz@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38213 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab0BRSWd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Feb 2010 13:22:33 -0500
In-Reply-To: <5415ae081002181012x4f7c95a4ncec563f69ae3562e@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Douglas Diniz wrote:
> I'm facing the same problem. I'm working in a embedded system with
> kernel 2.6.20-6. When I send a ping (or any other protocol) through
> eth0 to eth1 (or vice versa) the conntrack count isn't decremented. If
> I send the ping through any other interface (eth0 to wifi, eth1 to
> wifi, wifi to eth0 and wifi to eth1) I have no problem.
> The problem seems to be only between the ethernet interfaces.
> I debug the netfilter and I saw that when the problem occurs the "use"
> variable inside conntract structure in > 1, so this variable is only
> decremented by 1, not reaching in 0, and then the destroy_conntrack
> function is not called.
> 
> So I think that the problem is more low level, and some events aren't
> reaching netfilter, and the "use"variable isn't decremented properly.
> 
> This could be a problem with the ethernet driver?

Yes, although you'd likely notice other effects like running
out of memory if it was leaking the packets.
