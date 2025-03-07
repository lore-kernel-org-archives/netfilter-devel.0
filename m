Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA5419DF66
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Mar 2025 20:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.118.73.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741378071; cv=none; b=KDQ114tcyqUxYvTUJiORSJYETrjUEKRCedaP3eFB6nPCkuAUyFDY2PWp1lyJfMeZ00LSLjPeuuQEL0kkDsKVlvicSk5I8F//YpRBUU0jTU5N7YOFyGblUvPrXYbUX5YtzCyvZcvcue0/5K8gZ2nt6ufumwIbepf6mRgRWVWfB04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741378071; c=relaxed/simple;
	bh=U4dFl14AFahHJOpPJD4ik6YQYymaRN04CNhAkHBzPn0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BLvpqeY5SiM7OWgv5BTXrnw/7JzokTrE3UaJAryB88g8pV0qxDUieo1ql7KCEdD0t+DhGGWp7uUAKCym5TQjYvy2lTJw2qw3a1H3OaLI5FGw09k/H2tPF0UAkCbXEVG/D9ePJKdNzADtvhiOkkt6PsoHXntEAq/GVpuebdnIxdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thelounge.net; spf=pass smtp.mailfrom=thelounge.net; arc=none smtp.client-ip=91.118.73.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thelounge.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thelounge.net
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: h.reindl@thelounge.net)
	by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4Z8clh6pzfzXKl;
	Fri,  7 Mar 2025 21:07:44 +0100 (CET)
Message-ID: <6290cf9a-faff-4e1a-aac4-f12d4744d8b9@thelounge.net>
Date: Fri, 7 Mar 2025 21:07:44 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH iptables]: xtables: tolerate DNS lookup failures
Content-Language: en-US
To: Guido Trentalancia <guido@trentalancia.com>, Jan Engelhardt <ej@inai.de>
Cc: netfilter-devel@vger.kernel.org
References: <1741354928.22595.4.camel@trentalancia.com>
 <qn655027-4830-ps48-87po-r61npps888s5@vanv.qr>
 <d8ad3f9f-715f-436d-a73b-4b701ae96cc7@thelounge.net>
 <1741361507.5380.11.camel@trentalancia.com>
 <cc4ecd68-6db9-42e6-b0f0-dd3af26712ec@thelounge.net>
 <76043D4F-8298-4D5C-9E98-4A6A002A9F67@trentalancia.com>
From: Reindl Harald <h.reindl@thelounge.net>
Autocrypt: addr=h.reindl@thelounge.net; keydata=
 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
 K4rYsjPimkSIVdrNM//wVKdCTbO+
Organization: the lounge interactive design
In-Reply-To: <76043D4F-8298-4D5C-9E98-4A6A002A9F67@trentalancia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



Am 07.03.25 um 20:32 schrieb Guido Trentalancia:
> That's the way it is, I am personally against the practice of resolving FQDNs dynamically, but many commercial services do so and the only way of setting up iptables rules in that case is using FQDNs...

there is nothing qualified in a reverse-lookup
franklyi can place any reverse-name that i want for any IP i control
don't care really but using hostnames in a packet filter is dumb

> Iptables has always supported FQDNs, we are not talking here about removing that support or whether it should be used or not, the point is makjng that feature more robust and fault-tolerant.
> 
> I believe the patch improves the current situation for those that wish or simply must use FQDN-based rules.
> 
> Regards,
> 
> Guido
> 
> On the 7th march 2025 20:15:39 CET, Reindl Harald <h.reindl@thelounge.net> wrote:
>>
>>
>> Am 07.03.25 um 16:31 schrieb Guido Trentalancia:
>>> Nowadays FQDN hostnames are very often unavoidable, because in many
>>> cases their IP addresses are allocated dynamically by the DNS...
>>
>> which makes rules with hostnames even more dumb
>>
>> frankly you can't write useful rules for dynamic IPs at all
>>
>>> The patch is very useful for a desktop computer which, for example,
>>> connects to a wireless network only occasionally and not necessarily
>> at
>>> system bootup and which needs rules for IPs dynamically allocated to
>>> FQDNs.
>>>
>>> Guido
>>>
>>> On Fri, 07/03/2025 at 15.48 +0100, Reindl Harald wrote:
>>>>
>>>> Am 07.03.25 um 15:07 schrieb Jan Engelhardt:
>>>>>
>>>>> On Friday 2025-03-07 14:42, Guido Trentalancia wrote:
>>>>>
>>>>>> libxtables: tolerate DNS lookup failures
>>>>>>
>>>>>> Do not abort on DNS lookup failure, just skip the
>>>>>> rule and keep processing the rest of the rules.
>>>>>>
>>>>>> This is particularly useful, for example, when
>>>>>> iptables-restore is called at system bootup
>>>>>> before the network is up and the DNS can be
>>>>>> reached.
>>>>>
>>>>> Not a good idea. Given
>>>>>
>>>>> 	-F INPUT
>>>>> 	-P INPUT ACCEPT
>>>>> 	-A INPUT -s evil.hacker.com -j REJECT
>>>>> 	-A INPUT -j ACCEPT
>>>>>
>>>>> if you skip the rule, you now have a questionable hole in your
>>>>> security.
>>>>
>>>> just don't use hostnames in stuff which is required to be upo
>>>> *before*
>>>> the network to work properly at all
