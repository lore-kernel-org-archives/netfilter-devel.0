From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH][BRIDGE-NETFILTER] fix REJECT for bridged traffic
Date: Fri, 06 Nov 2009 17:03:20 +0100
Message-ID: <4AF448C8.80701@trash.net>
References: <4AF1D08C.2030907@pandora.be> <4AF2E21B.4050801@trash.net> <4AF32544.2060709@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:65271 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759379AbZKFQDQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Nov 2009 11:03:16 -0500
In-Reply-To: <4AF32544.2060709@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bart De Schuymer wrote:
> Patrick McHardy schreef:
>> Also proper ETH_* values please. But I'm wondering, we already save
>> the entire header in br_nf_post_routing(). Can't that be done earlier
>> so the upper layers don't have to care about this stuff and can simply
>> attach the original nf_bridge reference?
>>
>>   
> If you don't save the correct MAC address for the newly created skbuff
> in ipt_REJECT, there is no way to get it back later. Furthermore, if you
> save the header too early, MAC SNAT and DNAT might have changed the
> header and you have to resave the header anyway.

Yes, we need to save it at some point. My idea was that we might be able
to save it in PREROUTING instead of POSTROUTING and only do

nskb->nf_bridge = nf_bridge_get(oskb->nf_bridge)

in ipt_REJECT and probably also the ICMP code. MAC NAT could be handled
by updating the bridge info simultaneously.

>> I'm also wondering - how are ICMP rejects handled?
>>
>>   
> Good question :-)
> ICMP packets currently get sent with a source IP and MAC address of the
> bridge. If the bridge doesn't have an IP address but does have a
> suitable route, the source address is 0.0.0.0. I'll look into fixing this.

