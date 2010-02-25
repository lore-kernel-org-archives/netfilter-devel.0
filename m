From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: macvlan device blocks traffic for 30 secs
Date: Thu, 25 Feb 2010 18:17:45 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1002251817040.13151@obet.zrqbmnf.qr>
References: <alpine.LSU.2.01.1002251743590.30827@obet.zrqbmnf.qr> <4B86AB36.6090402@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55426 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932815Ab0BYRRq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Feb 2010 12:17:46 -0500
In-Reply-To: <4B86AB36.6090402@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2010-02-25 17:54, Patrick McHardy wrote:
>Jan Engelhardt wrote:
>> it's a while since I have last toyed with macvlan, but for some 
>> experimenting, it came up as something usable again. What I noticed 
>> while testing:
>> 
>> guest# ip link add link eth0 name mqv0 type macvlan
>> guest# ip link set dev mqv0 up
>> 
>> At this point, any connections drop for a specific amount of time.
>> 
>> host$ ping 192.168.100.101
>> PING 192.168.100.101 (192.168.100.101) 56(84) bytes of data.
>> 64 bytes from 192.168.100.101: icmp_seq=1 ttl=64 time=4.87 ms
>> 64 bytes from 192.168.100.101: icmp_seq=2 ttl=64 time=0.353 ms
>> 64 bytes from 192.168.100.101: icmp_seq=3 ttl=64 time=0.341 ms
>> 64 bytes from 192.168.100.101: icmp_seq=4 ttl=64 time=0.335 ms
>> 64 bytes from 192.168.100.101: icmp_seq=5 ttl=64 time=0.345 ms
>> 64 bytes from 192.168.100.101: icmp_seq=6 ttl=64 time=0.378 ms
>> 64 bytes from 192.168.100.101: icmp_seq=7 ttl=64 time=0.283 ms
>> 64 bytes from 192.168.100.101: icmp_seq=8 ttl=64 time=0.372 ms
>> 64 bytes from 192.168.100.101: icmp_seq=37 ttl=64 time=5.04 ms
>> 64 bytes from 192.168.100.101: icmp_seq=38 ttl=64 time=0.291 ms
>> 
>> and I am not quite sure why that is. The ARP entries don't change.
>> Can you reproduce this?
>
>No, this works fine here. It might be related to filter reprogramming
>of the NIC. Which driver are you using?

tap0 on one the host, e1000 inside the virtualbox.
