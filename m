From: Patrick McHardy <kaber@trash.net>
Subject: Re: scrubbing support in Netfilter
Date: Wed, 28 May 2008 06:38:47 +0200
Message-ID: <483CE1D7.30408@trash.net>
References: <87hccjdbm4.fsf@chdir.org> <alpine.LNX.1.10.0805271729350.12937@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Nicolas Bareil <nico@chdir.org>, netfilter-devel@vger.kernel.org,
	Nicolas Bareil <nicolas.bareil@eads.net>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39062 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbYE1Eiv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 May 2008 00:38:51 -0400
In-Reply-To: <alpine.LNX.1.10.0805271729350.12937@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Tuesday 2008-05-27 17:12, Nicolas Bareil wrote:
>>
>> I developped a Netfilter module which performs packet normalization, the
>> "scrubbing" feature of OpenBSD[1]. Normalized trafic offers the
>> following possibilities :
>
> I seem to remember that Linux's TCP or nf_conntrack already does
> some scrubbing.

No, unless you're refering to the unwanted side-effects from
defragmentation and refragmentation for IPv4. I also don't
want to include something like this in netfilter, NAT is
already bad enough and the threats it *might* protect against
seem a bit vague. Better throw your broken IDS out if can
be fooled by changing TTLs.

I don't want to sound too discouraging though, I have no problem
adding it to the pom-ng sources.list.

>> The current patch achieves the following transformations :
>>
>> * IPv4
>>  - Random IP ID
>>  - Zeroify ToS
> 
> Zeroify? Clearing the TOS is probably not a good idea because
> it defeats packet scheduling (if it uses TOS).

Well .. ToS is only useful within your own administrative
boundaries anyways, I've seen quite a few ISPs overwriting
it during transit.

>>  - TTL normalization
>>
>> * TCP
>> - Random TCP Sequence
> 
> I wonder if Linux already has this.

For forwarded traffic? No.

> 
>> - TCP Options
>>   - Random Timestamp
> 
> Is this even RFC compatible?

I assume its a random offset per connection, but still, no.
You can also still distinguish different hosts by their clock
rates.
