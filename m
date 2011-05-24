From: Pierre Rondou <prondou@gmail.com>
Subject: IPv6 reassembly in the FORWARD HOOK in Netfilter
Date: Tue, 24 May 2011 14:52:27 +0200
Message-ID: <4DDBAA0B.6070406@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: evyncke@cisco.com, guy.leduc@ulg.ac.be,
	Cyril Soldani <cyril.soldani@ulg.ac.be>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:3067 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755236Ab1EXMw1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 08:52:27 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I'm a student at the University of Liege currently developing a NAT64 
(see RFC 6146) module for Netfilter.

In order to make it compliant to the RFC specifications, the module 
needs to perform some sort of reassembly (in fact, accept out-of-order 
fragments arrival).
RFC says that the IPv6-IPv4 gateway can forward fragments as they 
arrive, but in the case the first fragment of a packet does not arrive 
first at the gateway, there will be a problem because it won't know how 
to translate the packet (don't know which IPv4 address to use).

So, the gateway needs to handle out of order fragments and maintain 
state for the following fragments.

Rather than creating many structures for that goal, I would have loved 
to use the kernel reassembly module, but it is limited to the INPUT hook.

Where this limitations may be understandable for router purpose (even 
though router admin could just kill it if they don't want it), it is a 
problem for the NAT64 module as the gateway has the reassemble 
fragmented paquet which are not destinated to it.

Is there a way to remove that specific limitation?

Regards,

Pierre Rondou
