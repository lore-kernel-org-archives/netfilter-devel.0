From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH]  Accounting rework: ct_extend + 64bit counters
Date: Tue, 03 Jun 2008 19:14:08 +0200
Message-ID: <48457BE0.6000604@trash.net>
References: <48442cd8.dD0hLVFRFjNruv6o%ole@ans.pl> <4845477B.8050400@trash.net> <Pine.LNX.4.64.0806031715240.3438@bizon.gios.gov.pl> <4845712F.7080003@trash.net> <Pine.LNX.4.64.0806031830250.3438@bizon.gios.gov.pl> <48457414.4050509@trash.net> <Pine.LNX.4.64.0806031841410.3438@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46248 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbYFCROL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Jun 2008 13:14:11 -0400
In-Reply-To: <Pine.LNX.4.64.0806031841410.3438@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Krzysztof Oledzki wrote:
>> Mhh good point :) I was thinking of calling it from the raw table,
>> but of course we don't have a conntrack at that point. So the
>> information would have to be propagated from the raw table somehow.
>> Maybe something like the untracked conntrack? IIRC someone posted
>> a patch for something similar (propagation of parameters to helpers)
>> some time ago.
> 
> OK, I'll look at this. Can we push the current version (plus discussed 
> changes) now and tag if for 2.6.27 and try to solve above problem later 
> (2.6.28)?

I would prefer to see a final solution before pushing
it upstream. Having it only implemented half-way forces
an additional allocation on everyone (even those not
even compiling the feature in now) for now gain.

>>> Do you mean an iptables target (-j ...)? IMHO a kernel/module option 
>>> plus a sysctl/sysfs interface should be enough.
>>
>> Having it controlled through an iptables target would be preferrable
>> because you can then do selective accounting.
> 
> OK, but this will make everything slower and may be often unnecessary, 
> so I still think that setting a default mode should be possible. It is 
> something like "iptables -P", BTW.

I'm guessing the allocation is where the real cost is,
but I'm not opposed to a default (that will get changed
to off after some period).
