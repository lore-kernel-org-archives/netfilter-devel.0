From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: arptables bug.
Date: Mon, 07 Jan 2013 21:20:40 +0100
Message-ID: <50EB2E18.5070708@pandora.be>
References: <201301052056.18524.steven@springl.ukfsn.org> <20130107032415.GA18563@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Steven Jan Springl <steven@springl.ukfsn.org>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:59308 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab3AGUUo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Jan 2013 15:20:44 -0500
In-Reply-To: <20130107032415.GA18563@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

I've applied (a slightly different version of) your patch, thanks. I'll 
make a new release somewhere this week.

cheers,
Bart

Op 7/01/2013 4:24, Pablo Neira Ayuso schreef:
> On Sat, Jan 05, 2013 at 08:56:18PM +0000, Steven Jan Springl wrote:
>> Hello
>>
>> I am using arptables v0.0.3.4 in Debian Squeeze.
>>
>> Issuing command:
>>
>> aptables -A INPUT -i eth0 --opcode ! 1 -j DROP
>>
>> Then issuing command arptables-save produces the following:
>>
>> -A INPUT -j DROP -i eth0  --opcode 1
>>
>> The "!" is missing from the opcode.
> Patch attached to fix it.
>
> Bart, could you please apply this to your git repo? Thanks.

