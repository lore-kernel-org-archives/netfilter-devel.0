From: Patrick McHardy <kaber@trash.net>
Subject: Re: macvlan device blocks traffic for 30 secs
Date: Thu, 25 Feb 2010 17:54:14 +0100
Message-ID: <4B86AB36.6090402@trash.net>
References: <alpine.LSU.2.01.1002251743590.30827@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37504 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932939Ab0BYQyQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Feb 2010 11:54:16 -0500
In-Reply-To: <alpine.LSU.2.01.1002251743590.30827@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> it's a while since I have last toyed with macvlan, but for some 
> experimenting, it came up as something usable again. What I noticed 
> while testing:
> 
> guest# ip link add link eth0 name mqv0 type macvlan
> guest# ip link set dev mqv0 up
> 
> At this point, any connections drop for a specific amount of time.
> 
> host$ ping 192.168.100.101
> PING 192.168.100.101 (192.168.100.101) 56(84) bytes of data.
> 64 bytes from 192.168.100.101: icmp_seq=1 ttl=64 time=4.87 ms
> 64 bytes from 192.168.100.101: icmp_seq=2 ttl=64 time=0.353 ms
> 64 bytes from 192.168.100.101: icmp_seq=3 ttl=64 time=0.341 ms
> 64 bytes from 192.168.100.101: icmp_seq=4 ttl=64 time=0.335 ms
> 64 bytes from 192.168.100.101: icmp_seq=5 ttl=64 time=0.345 ms
> 64 bytes from 192.168.100.101: icmp_seq=6 ttl=64 time=0.378 ms
> 64 bytes from 192.168.100.101: icmp_seq=7 ttl=64 time=0.283 ms
> 64 bytes from 192.168.100.101: icmp_seq=8 ttl=64 time=0.372 ms
> 64 bytes from 192.168.100.101: icmp_seq=37 ttl=64 time=5.04 ms
> 64 bytes from 192.168.100.101: icmp_seq=38 ttl=64 time=0.291 ms
> 
> and I am not quite sure why that is. The ARP entries don't change.
> Can you reproduce this?

No, this works fine here. It might be related to filter reprogramming
of the NIC. Which driver are you using?
