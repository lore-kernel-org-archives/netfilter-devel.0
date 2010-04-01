From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/5] netfilter: ipv6: move POSTROUTING invocation before
 fragmentation
Date: Thu, 1 Apr 2010 12:57:53 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1004011255210.17429@obet.zrqbmnf.qr>
References: <1270031487-15094-1-git-send-email-jengelh@medozas.de> <1270031487-15094-2-git-send-email-jengelh@medozas.de> <4BB47A5E.6090205@linux-ipv6.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:45349 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754477Ab0DAK5y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Apr 2010 06:57:54 -0400
In-Reply-To: <4BB47A5E.6090205@linux-ipv6.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2010-04-01 12:50, YOSHIFUJI Hideaki wrote:
>(2010/03/31 19:31), Jan Engelhardt wrote:
>> Patrick McHardy notes: "We used to invoke IPv4 POST_ROUTING after
>> fragmentation as well just to defragment the packets in conntrack
>> immediately afterwards, but that got changed during the
>> netfilter-ipsec integration. Ideally IPv6 would behave like IPv4."
>> 
>> This patch makes it so. Sending an oversized frame (e.g. `ping6
>> -s64000 -c1 ::1`) will now show up in POSTROUTING as a single skb
>> rather than multiple ones.
>
>I am not in favor doing this
>because we theoretically make fragments __before__ routing
>in output path (as we reassemble __after__ routing in input path).
>
>IMHO, FORWARDING and POSTROUTING share similar semantics
>from routing POV.
>As we see "fragments" in FORWARDING, we should see
>fragments in POST_ROUTING, at least in IPv6.

I don't have much of a problem with it, in fact, I also have a patch ready that
would turn things around in the IPv4 section instead to match the IPv6
behavior. Or it could be ignored altogether since it is not crucial for
IPSKB_REROUTED.
Patrick?
