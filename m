From: Patrick McHardy <kaber@trash.net>
Subject: Re: nf_conntrack.acct has no effect
Date: Tue, 17 Mar 2009 14:32:26 +0100
Message-ID: <49BFA66A.4090700@trash.net>
References: <alpine.LSU.2.00.0903161749530.16494@fbirervta.pbzchgretzou.qr> <49BE84D4.7050804@trash.net> <20090317082425.GA25491@mail.eitzenberger.org> <49BF9F7E.3090208@trash.net> <alpine.LNX.1.10.0903171411560.17354@bizon.gios.gov.pl> <49BFA633.4010306@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>, pablo@netfilter.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47422 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717AbZCQNc3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Mar 2009 09:32:29 -0400
In-Reply-To: <49BFA633.4010306@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Krzysztof Oledzki wrote:
>>
>>
>> On Tue, 17 Mar 2009, Patrick McHardy wrote:
>>
>>> Holger Eitzenberger wrote:
>>>> On Mon, Mar 16, 2009 at 05:56:52PM +0100, Patrick McHardy wrote:
>>>>
>>>>> Currently the default is set based on the old config option.
>>>>> When unset, no acct-extend is allocated for *new* conntracks.
>>>>> The old ones that do have an acct-extend are still displayed.
>>>>
>>>> I think the current implementation is unfortunate, because the
>>>> connbytes match auto-selects CONFIG_NF_CT_ACCT, and you end up having
>>>> the message always and can't get rid of it other than patching
>>>> it out.
>>>
>>> Its only a compat option, it will get removed soon. 2.6.30 or 2.6.31
>>> I'd say.
>>
>> I have the patch ready. Do you think it is a good moment to push it 
>> now, so it will be included in 2.6.30, or should I rather wait for 
>> 2.6.31?
> 
> I'd say it has been long enough, but Jan raised a valid point.
> We can't use the Kconfig selection anymore once we remove that
> option, so we need a replacement to automatically enable counters.

Just to clarify: I'm talking about connbytes of course :)
