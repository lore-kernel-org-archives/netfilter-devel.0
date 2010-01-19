From: Patrick McHardy <kaber@trash.net>
Subject: Re: RFC: netfilter: xtables: add CT target
Date: Tue, 19 Jan 2010 11:19:42 +0100
Message-ID: <4B55873E.3030308@trash.net>
References: <4B5575CB.5050207@trash.net> <alpine.LSU.2.01.1001191047480.13020@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42741 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755786Ab0ASKTp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Jan 2010 05:19:45 -0500
In-Reply-To: <alpine.LSU.2.01.1001191047480.13020@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Tuesday 2010-01-19 10:05, Patrick McHardy wrote:
> 
>> The attached two patches add a 'CT' target to specify parameters
>> used during conntrack creation. This can be used to manually attach
>> a helper to a connection. A couple of patches I'm still working
>> on will additionally use this for the "conntrack zones" classification.
>>
>> I'm wondering if anyone has further ideas of parameters that might
>> make sense to support.
> 
> Phil Oester/Pablo had proposed an earlier conntrack target to do just 
> that.
> 
> [3] 
> http://thread.gmane.org/gmane.comp.security.firewalls.netfilter.devel/21499
> (Can't find Pablo's update to that)

We could use the CT target to specify a fixed timeout, but since
it is only used for creating the conntrack entry, the timeouts
wouldn't be refreshed for received packets. This doesn't sound
very useful. Of course the target could also modify existing
connections, but that doesn't fit into the concept very well.
