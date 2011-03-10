From: "Fabien C." <7o5fzvj4duxjxzp@jetable.org>
Subject: Re: libnetfilter_queue: Some accepted packets get lost
Date: Thu, 10 Mar 2011 22:21:18 +0100
Message-ID: <4D7940CE.8080602@jetable.org>
References: <4D716FFE.8050503@jetable.org> <4D778432.10802@netfilter.org> <4D780CD3.2000006@jetable.org> <20110310062922.GY8821@Chamillionaire.breakpoint.cc> <4D78D77E.6040703@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:56636 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077Ab1CJVV1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Mar 2011 16:21:27 -0500
In-Reply-To: <4D78D77E.6040703@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>> perhaps you're hitting this problem?:
>> http://marc.info/?l=netfilter-devel&m=129016166319433&w=2
>> It triggers when your receive a 2nd UDP packet with the same
>> address/port pair while the 1st packet is still queued.
> 
> Fabien, to confirm that this is the problem, please use the following rule:
> iptables -A OUTPUT -t raw -p udp --dport 53 -j NFQUEUE --queue-num 666
> and retest. Let us know if that fixed it.

Yes, that fixed it, thank you for the information!

It's just a bit sad not being able to use conntracking, it avoided some packets
going through userland once one had already been accepted on the same source
ip/port.

Do you think it's not technically possible to fix that race condition in a
proper way?

Fabien
