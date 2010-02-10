From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 3/4] netfilter: xtables: use xt_table for hook
 instantiation
Date: Wed, 10 Feb 2010 23:10:52 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1002102310470.26190@obet.zrqbmnf.qr>
References: <1265813954-13854-1-git-send-email-jengelh@medozas.de> <1265813954-13854-4-git-send-email-jengelh@medozas.de> <4B72D069.2040106@trash.net> <alpine.LSU.2.01.1002101705260.12673@obet.zrqbmnf.qr> <4B72DA65.4040308@trash.net>
 <alpine.DEB.2.00.1002102013450.13645@blackhole.kfki.hu> <alpine.LSU.2.01.1002102042190.28163@obet.zrqbmnf.qr> <alpine.DEB.2.00.1002102210040.13883@blackhole.kfki.hu> <alpine.LSU.2.01.1002102307110.26190@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:38751 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756060Ab0BJWKx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Feb 2010 17:10:53 -0500
In-Reply-To: <alpine.LSU.2.01.1002102307110.26190@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2010-02-10 23:07, Jan Engelhardt wrote:

>
>On Wednesday 2010-02-10 22:32, Jozsef Kadlecsik wrote:
>>> 
>>> How so? If I untrack something in the raw table, I would have
>>> assumed it skips all conntracking - including defrag.
>>
>>Let's assume that you don't want to track the UDP DNS lookups to your busy 
>>DNS server but want to track all other connections:
>>
>>iptables -t raw -A PREROUTING -d dns.server -p udp --dport 53 -j NOTRACK
>>iptables -t raw -A PREROUTING -s dns.server -p udp --sport 53 -j NOTRACK
>>
>>If the fragments were visible in the raw table, what rule would you 
>>use to handle them?
>
>Hm, -t raw -A PREROUTING -f -d dns.server -p udp --d/sport 53 -j NOTRACK?

Ha. I see...
