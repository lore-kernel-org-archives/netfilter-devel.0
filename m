From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: xt_hashlimit: restore per-rule effectiveness
Date: Wed, 06 Oct 2010 17:07:49 +0200
Message-ID: <4CAC90C5.9050206@trash.net>
References: <1286346523-9476-1-git-send-email-jengelh@medozas.de> <1286346523-9476-2-git-send-email-jengelh@medozas.de> <4CAC7F8A.5080703@trash.net> <alpine.LNX.2.01.1010061625270.27021@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43305 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759096Ab0JFPHw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Oct 2010 11:07:52 -0400
In-Reply-To: <alpine.LNX.2.01.1010061625270.27021@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 06.10.2010 17:00, Jan Engelhardt wrote:
> On Wednesday 2010-10-06 15:54, Patrick McHardy wrote:
> 
>> Am 06.10.2010 08:28, schrieb Jan Engelhardt:
>>> When adding a second hashlimit rule with the same name, its parameters
>>> had no effect, because it had used a copy of the first one's inner
>>> state.
>>
>> I'm not sure we can change this behaviour at this point. There's at
>> least one change in your patch that changes the default behaviour,
>> you can currently create a second rule for a table witout specifying
>> the mode
> 
> I don't think that works. iptables does not know how many hashlimit 
> rules there are, thus it always enforces the presence of 
> --hashlimit-name, --hashlimit-mode and so on.

No, revision 1 only checks for limit and name.

>>> @@ -452,34 +456,34 @@ hashlimit_init_dst(const struct xt_hashlimit_htable *hinfo,
>>>  
>>>  	memset(dst, 0, sizeof(*dst));
>>>  
>>> -	switch (hinfo->family) {
>>> +	switch (family) {
>>
>> This also looks problematic, the entries don't include the family
>> themselves, so you're allowing tables to contain entries of multiple
>> families, which might cause mismatches.
> 
> AFAICS, one can already mix v4 and v6 into the same hashlimit bucket
> at this time (including side effects).

No, currently the tables include the family as key. Actually your
patch doesn't allow that either, but it doesn't make sense to change
hashlimit_init_dst to use par->family instead of hinfo->family.
