From: Patrick McHardy <kaber@trash.net>
Subject: Re: NFQUEUE verdicts - adding non-termination
Date: Fri, 12 Nov 2010 12:11:00 +0100
Message-ID: <4CDD20C4.9030507@trash.net>
References: <631109.9100.qm@web111016.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Andrew Watts <akwatts@ymail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61442 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757413Ab0KLLLH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Nov 2010 06:11:07 -0500
In-Reply-To: <631109.9100.qm@web111016.mail.gq1.yahoo.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 12.11.2010 12:01, schrieb Andrew Watts:
> --- On Thu, 11/11/10, Patrick McHardy <kaber@trash.net> wrote:
> 
>> On 11.11.2010 10:01, Andrew Watts wrote:
>>> Hi.
>>>
>>> The NF_CONTINUE verdict that Darryl Miles brings up in his 11/4
>>> post is very interesting. NF_CONTINUE would provide the NFQUEUE
>>> target the added flexibility of, say, partial handling in
>>> userspace. A queue-handler could have a set of criteria that,
>>> when satisfied, would result in an immediate drop or accept. One
>>> could then leave the rest of the packets to find their fate in the
>>> chains/rules left to traverse. I would be interested in helping
>>> to add this verdict if someone will take the lead (assuming a patch
>>> hasn't already been written - has it?).
> 
>> There's no difference between returning NF_ACCEPT or a new NF_CONTINUE.
>> Queueing happens outside of the ruleset context, so in either case the
>> packet would continue through the network stack directly, not after
>> the NFQUEUE rule.
> 
> I see. Is there a way to achieve this result under the current
> infrastructure?

Having the packet continue after the NFQUEUE rule? No, once the packet
is reinjected, that rule might not even be there anymore.
