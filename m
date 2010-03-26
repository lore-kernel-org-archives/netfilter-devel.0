From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 8/9] netfilter: xtables: inclusion of xt_TEE
Date: Fri, 26 Mar 2010 03:39:50 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003260332500.15526@obet.zrqbmnf.qr>
References: <1268831945-6041-1-git-send-email-jengelh@medozas.de> <1268831945-6041-9-git-send-email-jengelh@medozas.de> <4BA0DAB3.3000700@trash.net> <alpine.LSU.2.01.1003171437440.6297@obet.zrqbmnf.qr> <4BA0DF4D.5000504@trash.net>
 <alpine.LSU.2.01.1003230241580.12017@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:57856 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300Ab0CZCjw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Mar 2010 22:39:52 -0400
In-Reply-To: <alpine.LSU.2.01.1003230241580.12017@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Patrick McHardy wrote:
>
>> - iptables POSTROUTING is invoked before outgoing fragmentation
>>   (verified using ping -s 65000 localhost, and watching with both
>>   ipt_LOG and tcpdump.)
>>
>> - ip6tables POSTROUTING is invoked after outgoing fragmentation
>
>That's correct. We used to invoke IPv4 POST_ROUTING after fragmentation
>as well just to defragment the packets in conntrack immediately
>afterwards, but that got changed during the netfilter-ipsec integration.
>
>Ideally IPv6 would behave like IPv4.

Can you elaborate? conntrack runs well before POSTROUTING,
so the choice of doing POSTROUTING before or after fragmentation
seems to have no effect (other than perhaps xfrm).
