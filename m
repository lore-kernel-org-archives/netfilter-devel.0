From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER]: Move extensions' arguments into compound structure
 (1/2)
Date: Sun, 05 Oct 2008 16:52:03 +0200
Message-ID: <48E8D493.5@trash.net>
References: <alpine.LNX.1.10.0810031851430.13861@fbirervta.pbzchgretzou.qr> <48E8CF70.9090309@trash.net> <alpine.LNX.1.10.0810051036170.21891@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46472 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136AbYJEOwJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Oct 2008 10:52:09 -0400
In-Reply-To: <alpine.LNX.1.10.0810051036170.21891@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Sunday 2008-10-05 10:30, Patrick McHardy wrote:
>>> @@ -223,9 +223,18 @@ do_match(struct ip6t_entry_match *m,
>>>         unsigned int protoff,
>>>         bool *hotdrop)
>>> {
>>> +	struct xt_match_param par = {
>>> +		.in        = in,
>>> +		.out       = out,
>>> +		.match     = m->u.kernel.match,
>>> +		.matchinfo = m->data,
>>> +		.fragoff   = offset,
>>> +		.thoff     = protoff,
>>> +		.hotdrop   = hotdrop,
>>> +	};
>> Some of these members are constant during evaluation, so it would save
>> some overhead to initialize the structure on a higher level and only
>> fill in the match specific bits in do_match(). Alternatively you could
>> use two structures, one for the fixes bits related to the packet, one
>> for the match specific bits.
> 
> Yes I/we can still do that, but I wanted to get the big API change out
> at least, hoping that it fits into the upcoming window.

Reducing the overhead before merging will make me a lot more
comfortable accepting this patch without seeing any numbers
since its adding overhead to one of the hottest spots of ruleset
evaluation.

>> BTW, networking is using the same patch headline scheme as most of
>> the other subsystems nowadays, so please use "netfilter: " instead
>> of [NETFILTER]: in future patches. I also usually add the netfilter
>> internal subsystem, so this one would probably be
>> "netfilter: x_tables: move extensions' arguments ...".
> 
> Yup. When space is tight (and we only have like 74 chars to make it
> fit onto a screen, accounting for the git-log indent and one extra
> byte), it will have to do without the subsystem.

No, I'm adding it anyways and exceeding the limit is fine for
changelogs if it aids in readability. So please just add it so
I don't have to edit the descriptions every time.

