From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [NETFILTER]: Move extensions' arguments into compound structure
 (1/2)
Date: Sun, 5 Oct 2008 10:40:48 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810051036170.21891@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0810031851430.13861@fbirervta.pbzchgretzou.qr> <48E8CF70.9090309@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52666 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645AbYJEOkt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Oct 2008 10:40:49 -0400
In-Reply-To: <48E8CF70.9090309@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2008-10-05 10:30, Patrick McHardy wrote:
>> @@ -223,9 +223,18 @@ do_match(struct ip6t_entry_match *m,
>>         unsigned int protoff,
>>         bool *hotdrop)
>> {
>> +	struct xt_match_param par = {
>> +		.in        = in,
>> +		.out       = out,
>> +		.match     = m->u.kernel.match,
>> +		.matchinfo = m->data,
>> +		.fragoff   = offset,
>> +		.thoff     = protoff,
>> +		.hotdrop   = hotdrop,
>> +	};
>
> Some of these members are constant during evaluation, so it would save
> some overhead to initialize the structure on a higher level and only
> fill in the match specific bits in do_match(). Alternatively you could
> use two structures, one for the fixes bits related to the packet, one
> for the match specific bits.

Yes I/we can still do that, but I wanted to get the big API change out
at least, hoping that it fits into the upcoming window.

> BTW, networking is using the same patch headline scheme as most of
> the other subsystems nowadays, so please use "netfilter: " instead
> of [NETFILTER]: in future patches. I also usually add the netfilter
> internal subsystem, so this one would probably be
> "netfilter: x_tables: move extensions' arguments ...".

Yup. When space is tight (and we only have like 74 chars to make it
fit onto a screen, accounting for the git-log indent and one extra
byte), it will have to do without the subsystem.
