From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/5] netfilter: ipv6: move POSTROUTING invocation before
 fragmentation
Date: Thu, 1 Apr 2010 13:50:16 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1004011340120.17429@obet.zrqbmnf.qr>
References: <1270031487-15094-1-git-send-email-jengelh@medozas.de> <1270031487-15094-2-git-send-email-jengelh@medozas.de> <4BB47A5E.6090205@linux-ipv6.org> <4BB480C6.9080604@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55033 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755662Ab0DALuS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Apr 2010 07:50:18 -0400
In-Reply-To: <4BB480C6.9080604@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2010-04-01 13:17, Patrick McHardy wrote:
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

I am not quite following where this extra refragmentation is
happening. Assuming [nf-packet-flow.png] as a base, there are two
spots in which conntrack/defrag happens: PREROUTING and OUTPUT.

This translates to:

>its a lot easier to construct your ruleset when you don't have to
>take care of fragments.

We never see fragments in the ruleset

 a) for netif_rx received packets, defrag will be run early
    (yes, there's raw, but that's special anyway)

 b) locally-generated packets are fragmented only after all of
    Netfilter is done.
