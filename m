From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/5] netfilter: ipv6: move POSTROUTING invocation before
 fragmentation
Date: Thu, 01 Apr 2010 13:17:26 +0200
Message-ID: <4BB480C6.9080604@trash.net>
References: <1270031487-15094-1-git-send-email-jengelh@medozas.de> <1270031487-15094-2-git-send-email-jengelh@medozas.de> <4BB47A5E.6090205@linux-ipv6.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50189 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122Ab0DALR2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Apr 2010 07:17:28 -0400
In-Reply-To: <4BB47A5E.6090205@linux-ipv6.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

YOSHIFUJI Hideaki wrote:
> Hello.
> 
> (2010/03/31 19:31), Jan Engelhardt wrote:
>> Patrick McHardy notes: "We used to invoke IPv4 POST_ROUTING after
>> fragmentation as well just to defragment the packets in conntrack
>> immediately afterwards, but that got changed during the
>> netfilter-ipsec integration. Ideally IPv6 would behave like IPv4."
>>
>> This patch makes it so. Sending an oversized frame (e.g. `ping6
>> -s64000 -c1 ::1`) will now show up in POSTROUTING as a single skb
>> rather than multiple ones.
> 
> I am not in favor doing this
> because we theoretically make fragments __before__ routing
> in output path (as we reassemble __after__ routing in input path).

That's true, but is symetry for fragment handling really something
worth keeping? Besides avoiding one refragmentation pass in conntrack,
its a lot easier to construct your ruleset when you don't have to
take care of fragments.

Granted, in IPv4 the main motivation for this change was to reduce
stack usage by not using the "okfn" anymore, which isn't too important
on the output path, and we don't fragment forwarded packets in IPv6.

> IMHO, FORWARDING and POSTROUTING share similar semantics
> from routing POV.
> As we see "fragments" in FORWARDING, we should see
> fragments in POST_ROUTING, at least in IPv6.

We'd still see them for forwarded packets.
