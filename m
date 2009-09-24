From: Jan Rafaj <jr+netfilter-devel@cedric.unob.cz>
Subject: Re: xt_stealth as separate patch against xtables-addons-1.17
Date: Thu, 24 Sep 2009 17:47:42 +0200 (MEST)
Message-ID: <alpine.LNX.2.00.0909241737210.8925@cedric.unob.cz>
References: <alpine.LNX.2.00.0909011937060.7713@cedric.unob.cz> <alpine.LSU.2.00.0909240211160.31517@obet.zrqbmnf.qr> <alpine.LNX.2.00.0909241450270.8925@cedric.unob.cz> <alpine.LSU.2.00.0909241503360.29849@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, spender@grsecurity.net,
	Balazs Scheidler <bazsi@balabit.hu>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cedric.unob.cz ([160.216.40.10]:41561 "EHLO cedric.unob.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752366AbZIXPrp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Sep 2009 11:47:45 -0400
In-Reply-To: <alpine.LSU.2.00.0909241503360.29849@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


>> Btw, the manpage for 'socket' match should clearly specify that
>> an 'open socket' means socket in either listening or established state.
>> I was first puzzled by what 'open socket' really means...
>
> Now that you mention it, I guess it's "any socket" :-/
> On the upside, more feature flags for xt_socket! :)

Indeed. To simulate xt_stealth, we first need xt_socket to allow for 
clearly distinguishing tcp sockets in 'listening' state only, and udp 
sockets in 'existing' state I guess (see xt_stealth.c). Separate, 
per-"state" match should be possible, though.

I suggest adding support to xt_socket for something like

   --sockstate listening
   --sockstate established
   --sockstate exists

Then, I could write:

   iptables -N socktest
   iptables -A socktest -p tcp --syn -m socket --sockstate listening -j RETURN
   iptables -A socktest -p udp       -m socket --sockstate exists    -j RETURN
   iptables -A socktest                                              -j DROP

   iptables -A INPUT                                                 -j socktest

Jan
