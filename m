From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [ANNOUNCE] ipset 6.13 released
Date: Sun, 01 Jul 2012 11:46:43 +0100
Message-ID: <4FF02A93.8080603@googlemail.com>
References: <alpine.DEB.2.00.1206292201340.29738@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:65305 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042Ab2GAKqx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Jul 2012 06:46:53 -0400
In-Reply-To: <alpine.DEB.2.00.1206292201340.29738@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> I have just released ipset 6.13 with a few bugfixes and some new features.
>
> Userspace changes:
>  - Explain in more detail src/dst for hash:net,iface
>   
Assuming this is what you've had in mind (taken from "man ipset"):

The second direction parameter of the set match and
SET target modules corresponds to the incoming/outgoing interface:
src to the incoming one (similar to the -i flag of iptables), while
dst to the outgoing one (similar to the -o flag of iptables). When
the interface is flagged with physdev:, the interface is interpreted
as the incoming/outgoing bridge port.

I think that is plain wrong!

You refer to the incoming interface (interface on which packets arrive) 
as the "source". That cannot be right. To me, it should be a 
"destination", not  "source" as the very definition of a "destination" 
is where something ends, this is where a packet arrives and where the 
journey of the packet "stops" (or where the packet is "destined" to 
arrive anyway). It should definitely not be a "source" as the packet 
does not originate there, nor does it start its journey there.

Similarly for the outgoing interface - this isn't a "destination" 
interface as the packet doesn't arrive there - it is where it starts its 
journey from!

So, I think you should reverse both definitions and match "src" with the 
outgoing interface and "dst" with the incoming interface - exactly the 
opposite of what you have now. Documenting something which was done 
wrong in the first place doesn't make it right.
