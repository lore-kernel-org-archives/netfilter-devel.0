From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: clone packet with new destination address
Date: Mon, 1 Nov 2010 20:37:52 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1011012036030.655@obet.zrqbmnf.qr>
References: <4CC1843F.8050903@earthlink.net> <AANLkTi=Y6zdmj4hngEaJPjZjNTTWaWMERfKR=dGSkY9b@mail.gmail.com> <AANLkTi=T3QwJp-yVT3GNk46mjmudQ5CrE71YnMqWfsOh@mail.gmail.com> <4CCEB69B.5080905@earthlink.net> <alpine.LNX.2.01.1011011405480.4499@obet.zrqbmnf.qr>
 <4CCECEDD.2030107@earthlink.net> <AANLkTiny3XRc7-OPrUzvzp_=0wd4KJ+GAhPQEkQrSwjR@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: sclark46@earthlink.net, netfilter-devel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:33220 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436Ab0KAThy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Nov 2010 15:37:54 -0400
In-Reply-To: <AANLkTiny3XRc7-OPrUzvzp_=0wd4KJ+GAhPQEkQrSwjR@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2010-11-01 16:00, Changli Gao wrote:

>On Mon, Nov 1, 2010 at 10:29 PM, Stephen Clark <sclark46@earthlink.net> wrote:
>>
>> I am not sure on how to go about doing that, looking at the code for TEE it
>> looks
>> like the cloned packet bypasses any of the remaining iptables chains.
>
>It isn't true. The cloned packet only bypasses the iptables rule where
>it is generated.

That isn't true either. The cloned packet starts its travel in OUTPUT, 
not where it left off.

>I think you can use the RAWSNAT xtables-addon to change the
>destination address. Since the new skb is attached to untracked ct,
>you can use match conntrack --ctstate UNTRACKED to filter it out.

That may still give false positives if there is other NOTRACK traffic.
