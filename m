From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/5] netfilter: ipv6: move POSTROUTING invocation before
 fragmentation
Date: Wed, 7 Apr 2010 15:24:59 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1004071524510.10827@obet.zrqbmnf.qr>
References: <1270031487-15094-1-git-send-email-jengelh@medozas.de> <1270031487-15094-2-git-send-email-jengelh@medozas.de> <4BB47A5E.6090205@linux-ipv6.org> <4BB480C6.9080604@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55733 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753355Ab0DGNZB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Apr 2010 09:25:01 -0400
In-Reply-To: <4BB480C6.9080604@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2010-04-01 13:17, Patrick McHardy wrote:

>YOSHIFUJI Hideaki wrote:
>> Hello.
>> 
>> (2010/03/31 19:31), Jan Engelhardt wrote:
>>> Patrick McHardy notes: "We used to invoke IPv4 POST_ROUTING after
>>> fragmentation as well just to defragment the packets in conntrack
>>> immediately afterwards, but that got changed during the
>>> netfilter-ipsec integration. Ideally IPv6 would behave like IPv4."
>>>
>>> This patch makes it so. Sending an oversized frame (e.g. `ping6
>>> -s64000 -c1 ::1`) will now show up in POSTROUTING as a single skb
>>> rather than multiple ones.
>> 
>> I am not in favor doing this
>> because we theoretically make fragments __before__ routing
>> in output path (as we reassemble __after__ routing in input path).
>
>That's true, but is symetry for fragment handling really something
>worth keeping? Besides avoiding one refragmentation pass in conntrack,
>its a lot easier to construct your ruleset when you don't have to
>take care of fragments.
[...]

So, drop the patch or not?
