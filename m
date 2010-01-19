From: Patrick McHardy <kaber@trash.net>
Subject: Re: RFC: netfilter: xtables: add CT target
Date: Tue, 19 Jan 2010 11:40:17 +0100
Message-ID: <4B558C11.9020607@trash.net>
References: <4B5575CB.5050207@trash.net> <alpine.DEB.2.00.1001191115160.3138@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43083 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104Ab0ASKkV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Jan 2010 05:40:21 -0500
In-Reply-To: <alpine.DEB.2.00.1001191115160.3138@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik wrote:
> On Tue, 19 Jan 2010, Patrick McHardy wrote:
> 
>> The attached two patches add a 'CT' target to specify parameters
>> used during conntrack creation. This can be used to manually attach
>> a helper to a connection. A couple of patches I'm still working
>> on will additionally use this for the "conntrack zones" classification.
>>
>> I'm wondering if anyone has further ideas of parameters that might
>> make sense to support. We could for example move parameters like
>> sip_direct_signalling and sip_direct_media into the helper structure
>> and allow to set them dynamically for each connection. Or perhaps
>> selectively enable netlink events.
> 
> Selectively enabling netlink events (not only per connection but per event 
> type) would be cool! Last year I used the CONNMARK target for that purpose 
> - maybe it fits better to the CT target.

I think it would be a good fit since you probably would want to specify
the events to be delivered before the conntrack is created.

Adding an event mask to the ecache extension also looks unproblematic.
You could then use a rule like this:

iptables -t raw .. -j CT --ctevents new,related,protoinfo,helper

or something like that. Are the existing event types fine grained
enough for this? Also, should the CT target override the global
sysctl setting?
