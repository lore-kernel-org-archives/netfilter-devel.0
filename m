From: Patrick McHardy <kaber@trash.net>
Subject: Re: Possible conntrack/kernel bug - not catching certain ICMP packets
Date: Thu, 21 Jul 2011 11:14:36 +0200
Message-ID: <4E27EDFC.6020007@trash.net>
References: <4E202844.30602@wildgooses.com> <4E241AB0.5060603@wildgooses.com> <alpine.LNX.2.01.1107181415500.13166@frira.zrqbmnf.qr> <4E274C77.8080605@wildgooses.com> <4E27C458.5030605@trash.net> <4E27E6B1.4030606@wildgooses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Ed W <lists@wildgooses.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33362 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab1GUJOj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Jul 2011 05:14:39 -0400
In-Reply-To: <4E27E6B1.4030606@wildgooses.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 21.07.2011 10:43, Ed W wrote:
> On 21/07/2011 07:16, Patrick McHardy wrote:
>> It's expected behaviour since ICMP packets related to an existing
>> connection don't refresh the connection and are not accounted.
>> I don't have an opinion on whether they should be accounted, I
>> guess you could argue both ways.
> 
> Thanks for the feedback.
> 
> I guess I was hoping that conntrack could be used for accurate bandwidth
> accounting, however, it seems to ignore this type of packet, so it's
> count is going to deviate from a simple interface byte counter?

Yes, but it's going to do that anyways since there are also packets
which can't be tracked, invalid packets, etc. Also conntrack doesn't
account for link layer headers and only for IPv4/v6 packets.

> I don't see the argument for *not* counting the bytes from the ICMP
> packet though? Surely the goal of conntrack is that everything is
> scooped into some connection? It seems like in this case conntrack
> labels this packet as belonging to the connection, BUT doesn't update
> the packet or byte counts - this seems like a half and half situation?

Well, you could just as well argue that someone is only interested
in the amount of bytes/packets which were actually transfered within
a connection. Since you mentioned interface counters, we also don't
account for ARP requests triggered by a connection.

I agree that it would be good to account for these packet *somewhere*.

> Thanks for replying - interested to hear the arguments against
> refreshing byte counts given that conntrack has already marked it as
> related?

Well, basically the related ICMP packets bypass protocol related
tracking, which is of course correct since they obviously shouldn't
be handled by f.i. TCP tracking, but this is where the accounting
happens.
