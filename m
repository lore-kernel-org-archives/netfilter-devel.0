From: Patrick McHardy <kaber@trash.net>
Subject: Re: Transfer stalls with NAT under 2.6.24.3
Date: Wed, 26 Mar 2008 10:24:35 +0100
Message-ID: <47EA1653.3080300@trash.net>
References: <47EA0DAB.7080205@securenet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Sven Riedel <sr@securenet.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56960 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275AbYCZJ0j (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Mar 2008 05:26:39 -0400
In-Reply-To: <47EA0DAB.7080205@securenet.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Sven Riedel wrote:
> Hi,
> I've run into a strange problem where large file transfers start 
> stalling over a NATed connection. Packet traces reveal that ACK 
> packets are sometimes not being passed through to the inside (NATed) 
> host, which results in a transfer stall until a tcp timeout occurrs 
> and the other side retransmits the ACK.
>
> This only seems to happen if the conntrack table on the firewall 
> already contains an entry for the same source and destination in 
> TIME_WAIT state. If no conntrack entries exist for the same source and 
> destination, the packets flow fine.
>
> The problem seems to be alevated by setting ip_conntrac_tcp_be_liberal 
> to 1, but this seems to be only a workaround not a real solution.
>
> Scatter gather and tcp segment offloading have been disabled in the 
> relevant NICs on the firewall during debugging, to make sure this 
> isn't a hardware issue.
>
> Is this issue known/is there a patch available or would further 
> information be needed to help debug the problem?

2.6.24.3 includes a patches that was supposed to fix problems
with connections in TIME_WAIT state. Does 2.6.24.2 work better
for you?

Please enable conntrack logging for TCP by executing:

echo 6 >/proc/sys/net/netfilter/nf_conntrack_log_invalid

and check whether you get any messages in the ring buffer.
