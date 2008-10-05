From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Connection Protocol in the state?
Date: Sun, 5 Oct 2008 16:52:38 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810051648560.32566@fbirervta.pbzchgretzou.qr>
References: <200810012206.52512.christoph.paasch@gmail.com> <alpine.LNX.1.10.0810031004350.3893@fbirervta.pbzchgretzou.qr> <200810051051.19999.christoph.paasch@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Christoph Paasch <christoph.paasch@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:35879 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159AbYJEUwj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Oct 2008 16:52:39 -0400
In-Reply-To: <200810051051.19999.christoph.paasch@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2008-10-05 04:51, Christoph Paasch wrote:
>Hello,
>
>>
>> Read the really-really-really-nice manpage (which has gotten so much care
>> from me). I mean, hey, it's directly below --ctstate! :-)
>>
>>        [!] --ctproto l4proto
>>               Layer-4 protocol to match (by number or name)
>
>Hmm... so, you mean that the established connection doesn't makes
>the difference between the different protocols, as long as those
>aren't specified with "--ctproto".

Correct, -m conntrack is naturally protocol-independent.
You can use either -p tcp or --ctproto tcp to check for
protocol-specific parts. Note that -p and --ctproto have different
meaning, but I have yet to see a connection tracker that puts, say,
non-tcp packets into a tcp connection.

>So, if I got an established TCP-connection, I can do run any other protocol 
>(UDP, ... and in particular shim6 ;-) in any direction. And also on any port 
>number? 

You will never see the SHIM layer if you are doing filtering at
layer-3 (which is what ip6tables does).

>Sorry, but I think, that it's not clear, what is stored in the state, of a 
>connection, if the iptables rule doesn't specifies the protocol, portnumber, 

connection = (srcip, dstip, l4stuff)
l4stuff#tcp= (srcport, dstport)
