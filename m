From: Ed W <lists@wildgooses.com>
Subject: Re: Possible conntrack/kernel bug - not catching certain ICMP packets
Date: Thu, 21 Jul 2011 09:43:29 +0100
Message-ID: <4E27E6B1.4030606@wildgooses.com>
References: <4E202844.30602@wildgooses.com> <4E241AB0.5060603@wildgooses.com> <alpine.LNX.2.01.1107181415500.13166@frira.zrqbmnf.qr> <4E274C77.8080605@wildgooses.com> <4E27C458.5030605@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail1.nippynetworks.com ([91.220.24.129]:58307 "EHLO
	mail1.nippynetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab1GUInc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Jul 2011 04:43:32 -0400
In-Reply-To: <4E27C458.5030605@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 21/07/2011 07:16, Patrick McHardy wrote:
> It's expected behaviour since ICMP packets related to an existing
> connection don't refresh the connection and are not accounted.
> I don't have an opinion on whether they should be accounted, I
> guess you could argue both ways.

Thanks for the feedback.

I guess I was hoping that conntrack could be used for accurate bandwidth
accounting, however, it seems to ignore this type of packet, so it's
count is going to deviate from a simple interface byte counter?

I don't see the argument for *not* counting the bytes from the ICMP
packet though? Surely the goal of conntrack is that everything is
scooped into some connection? It seems like in this case conntrack
labels this packet as belonging to the connection, BUT doesn't update
the packet or byte counts - this seems like a half and half situation?

Thanks for replying - interested to hear the arguments against
refreshing byte counts given that conntrack has already marked it as
related?

Cheers

Ed W
