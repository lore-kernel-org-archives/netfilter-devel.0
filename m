Received: from mail1.fiberby.net (mail1.fiberby.net [193.104.135.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D641847CC8E;
	Wed, 26 Aug 2026 19:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.104.135.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787773332; cv=none; b=tQQXSFjz/e1BPN2xn3Ll8npDXCUzi7mK8xobqeGHoXoIbo9rtQy+VpiK5UVqIHBDbhSFXMHihdJYzTROmWiTDCQkhLRWVFURB8W1r2t42Nscu3JTafZjg3SpMsRtY6dloVut8nWn9F0g9+sKVwdjrUPYspg/IHhXI2plO/cqZGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787773332; c=relaxed/simple;
	bh=n5+zW/sLXcx1YtKY8np6uGvCc7Muo5pDQvEIJAesLos=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RvMA4Nj7C7RUVmpXOYkYMdyH29Gtpas6EdDiYKjZceGgBGH9FrcQq+gTVoc3Lh6QpHuB71b0/7ABVHKyZHv2IA45dVv4d0hNuNBq6IcQ1Vc09hmvJ1vUSjGXXTkUpJUkdLTukOy28/PPj24n3GAw5NtT8FTvcoCye0RtDCiDFV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fiberby.net; spf=pass smtp.mailfrom=fiberby.net; dkim=pass (2048-bit key) header.d=fiberby.net header.i=@fiberby.net header.b=ET8CBYu+; arc=none smtp.client-ip=193.104.135.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fiberby.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fiberby.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fiberby.net header.i=@fiberby.net header.b="ET8CBYu+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fiberby.net;
	s=202008; t=1787773316;
	bh=n5+zW/sLXcx1YtKY8np6uGvCc7Muo5pDQvEIJAesLos=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ET8CBYu+Q7E+A8tRwIXw4hZxzpB2sJWVTf+2MNuxXBaQqArP+IhNrnuUyluPP2LWB
	 AwfTiWPjzemIeRrxpIfocAKolIq15Ou5SG198lf6FmiagknC80bNkhOICQylpykH9D
	 RrA586cpC4LRyARW/6JWCvgxgtHJtKlmWaExWH+71uQe7QkGuPuEwM2qTu/cLujix2
	 E8xOWGyMvB1jd3iE5/QKkZ26Zwh1YXD2blO1R12zNGD13/Rta/BeZAnJJk45eEz17q
	 lMj1+MNS5A/X66cknx2NQNQGME2qFPfJCiruJoWOF7z+bIR7wE1Tg0M0By8PppuO33
	 tbHHfpIuB13Gg==
Received: from x201s (193-104-135-243.ip4.fiberby.net [193.104.135.243])
	by mail1.fiberby.net (Postfix) with ESMTPSA id CBB6D60075;
	Wed, 26 Aug 2026 19:41:55 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by x201s (Postfix) with ESMTP id 6C1EB20079C;
	Wed, 26 Aug 2026 19:40:35 +0000 (UTC)
Message-ID: <2e89120d-c18d-4d0b-9e7c-149611475271@fiberby.net>
Date: Wed, 26 Aug 2026 19:40:35 +0000
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] netlink: specs: fix the conntrack filter type
To: Ilya Maximets <i.maximets@ovn.org>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Donald Hunter <donald.hunter@gmail.com>,
 "Remy D. Farley" <one-d-wide@protonmail.com>,
 "Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
 Florian Westphal <fw@strlen.de>, linux-kernel@vger.kernel.org,
 netfilter-devel@vger.kernel.org, stable@vger.kernel.org,
 netdev@vger.kernel.org
References: <20260825155832.3685714-1-i.maximets@ovn.org>
 <94842eea-a296-4ab9-a026-2475757a82b8@fiberby.net>
 <7b1f615f-d435-4b83-a180-67cf9a4223a0@ovn.org>
Content-Language: en-US
From: =?UTF-8?Q?Asbj=C3=B8rn_Sloth_T=C3=B8nnesen?= <ast@fiberby.net>
In-Reply-To: <7b1f615f-d435-4b83-a180-67cf9a4223a0@ovn.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/26/26 6:38 PM, Ilya Maximets wrote:
> On 8/26/26 7:20 PM, Asbjørn Sloth Tønnesen wrote:
>> On 8/25/26 3:58 PM, Ilya Maximets wrote:
>>> The CTA_FILTER doesn't contain nested tuple attributes, instead it
>>> contains bit masks that specify which tuple attributes to filter on.
>>> The values for filtering are taken from the top-level CTA_TUPLE_ORIG
>>> and CTA_TUPLE_REPLY.
>>
>> As identified by Sashiko-NIPA[1], then CTA_TUPLE_ORIG and CTA_TUPLE_REPLY
>> are both absent from the GET DUMP request attribute list.
>>
>> However this doesn't prevent ynl CLI from sending the attributes:
>>
>> $ sudo ./tools/net/ynl/pyynl/cli.py --family conntrack --dump get --json \
>>     '{"nfgen-family": 2, "filter": {"orig-flags": 1}}'
>> Netlink error: Invalid argument
>>
>> $ sudo ./tools/net/ynl/pyynl/cli.py --family conntrack --dump get --json \
>> '{"nfgen-family": 2, "filter": {"orig-flags": 1}, "tuple-orig": {"tuple-ip": {"ip-v4-src": "192.255.0.255", "ip-v4-dst":
>> "192.255.255.0"}}}'
>> []
>>
>> Otherwise, LGTM.
>>
>> [1] https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260825155832.3685714-1-i.maximets%40ovn.org
> 
> The reported issue is preexisting and a little orthogonal to the goal of
> this patch.  I.e. missing dump attributes vs wrong type of attributes that
> are specified.
> 
> I can add all the missing attributes: tuple-orig, tuple-reply, mark-mask
> and status-mask.  Either as a separate patch, or fold the change into this
> one, but rename it into something like:
>    "netlink: specs: fix conntrack filtering attributes and types"
> 
> WDYT?

I agree that it is a little orthogonal, but OTOH the patch doesn't really fix
anything meaningful when the YNL spec doesn't allow actually making the request.
The commit message directly refers to attributes not allowed in the YNL spec,
without declaring it as intentionally deferred (like the filter bitmasks).

I see mark-mask and status-mask as a fully orthogonal issue, as they don't
clash with the commit message.

I would just fold tuple-orig and tuple-reply into this patch, and leave
mark-mask and status-mask for another patch.  Alternatively make it a series.
