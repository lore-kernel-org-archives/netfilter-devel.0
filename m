From: Patrick McHardy <kaber@trash.net>
Subject: Re: The glorious NFCT "none" helper
Date: Tue, 07 Jun 2011 12:23:50 +0200
Message-ID: <4DEDFC36.6070301@trash.net>
References: <1305757266-8730-1-git-send-email-jengelh@medozas.de> <4DDA6F53.9060809@trash.net> <4DDA8184.3060407@netfilter.org> <alpine.LNX.2.01.1105231755550.18360@frira.zrqbmnf.qr> <4DDA8793.7010203@netfilter.org> <4DDB5901.2090607@trash.net> <4DDC00FF.6040405@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49849 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab1FGKYA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jun 2011 06:24:00 -0400
In-Reply-To: <4DDC00FF.6040405@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 24.05.2011 21:03, Pablo Neira Ayuso wrote:
> On 24/05/11 09:06, Patrick McHardy wrote:
>> On 23.05.2011 18:13, Pablo Neira Ayuso wrote:
>>> On 23/05/11 17:59, Jan Engelhardt wrote:
>>>> On Monday 2011-05-23 17:47, Pablo Neira Ayuso wrote:
>>>>> On 23/05/11 16:29, Patrick McHardy wrote:
>>>>>> Wouldn't a flag to the CT target to skip the helper lookup work as well?
>>>>>
>>>>> Indeed.
>>>>
>>>> Yes, but how would xt_CT.ko convey to NFCT then that no helper is 
>>>> supposed to be used? Calling nf_ct_helper_ext_add, but then leave help 
>>>> at NULL?
>>>
>>> You can attach a template conntrack in the raw table with the CT target.
>>> That template should have some status flag set to skip helper
>>> allocation/assignation.
>>
>> Problem might be the second lookup done after NAT. We don't have the
>> template available at that time.
> 
> We'll have some IPS_NO_HELPER flag set for the conntrack at that time to
> skip the helper assignation.
> 
>> I don't like the dummy helper idea very much though, what I would
>> prefer is an option to use only explicit helper assignment. That
>> would be a more flexible option, additionally allowing to track
>> protocols on any port without specifying each of them when loading
>> the helper.
> 
> I don't want to assign a dummy helper, but use a flag to skip helper
> assignation, would you be OK with that idea?

Sure, that sounds like something that would fit into the CT target.
My idea other idea is to have a global option to disable helper
lookups and *only* use explicit assignment, so you can specificy
specifically for which addresses and ports to use helpers.

> BTW, not related with this patch but I'd like to fix the current issue
> with the userspace expectation support problem, still don't like my
> patches to add a template and set one flag to explicitly tell conntrack
> to allocate the helper CT extension?

This is too much exposure of implementation in my opinion, userspace
shouldn't have to care about extension areas. I'll have another look
at your patches to see if I can come up with an alternative.
