Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535F6368D4C
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Oct 2026 08:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791361066; cv=none; b=NilagIubj7UrLo+ibT+9VOhvoAItlJRukjYWLjcZVbgxdD+hRTYFy4ZSzydW/bkfFo5hHegfzg+r284S24ypm1/JbriqJ3KWWcNBce8q7an7PICKh/IW6y40updnxBonV/fbvTCfGURisWW2BNuXsQ4BmgSDClJqFYY/VfiHLt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791361066; c=relaxed/simple;
	bh=ypNxC703y/0we+RH+g6IzISIwrzibmYZwIRv0HDrxV0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=csMx/adgg5OE3xeNEX9RzrmYQHROg8qFmzyMZKgB6SKk3EQ14C9pTE9Y8CE0vObdTWN3Wd56VGPyqGNW1FLvZ2pbYszeNthGs9zfvR9W+NAHcZ5ZDUElbs3O8qQqi7o7ioBXfcVCAddMQYG9Kubh59zkSpAvYDAXPyEE3j/ebFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZPrSq6y4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZPrSq6y4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E99FA1F0089B;
	Wed,  7 Oct 2026 08:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791361062;
	bh=flapb3rIHWlz5txRaY/A3A+HxK88UBiNKc27LvYa5RI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZPrSq6y4f+NzA+1GvPT14NtGEI3XN2w+17nZBVZ6C/kaSDFLcW6z2q5RL2VYgK7kX
	 2h50a/MjlH1jh6YwiqSL0pv+yTvvvfh83iTbKNDyZWftzjfoYDJRG+0A/2LpKlT5oh
	 5oaLkb06Br7LpyQVZA7Mxzhyv0dMpQlzi3dlMpNcCSxzXISE13L6DO44C6IJXzZaZl
	 mcw20WOO/iNq+ejQ5znMNZLDgxMFjXC6vnG9cy5I8rtDPj1/6F3MG6uRUzXoiA2x3f
	 XgE62RSz4xFoDiVX587JKC3S5LWcFEldHsbyaJD5pss7MqeikG3+IBSozTxu+67da8
	 2r8ycSH+nHEuw==
Message-ID: <230c857e-9560-40d5-8e9e-99d875e3a3c1@kernel.org>
Date: Wed, 7 Oct 2026 10:17:39 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: Netfilter: match "tcp option" with the same type present multiple
 times
Content-Language: fr
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>,
 Netfilter Coreteam <coreteam@netfilter.org>,
 Fernando Fernandez Mancera <fmancera@suse.de>
References: <a391d81c-0bce-41e6-886e-a558765c6891@kernel.org>
 <arrhlKkKSSKFp4Sq@chamomile>
 <a1e6f81d-d902-4bae-8244-ad936ef70e19@kernel.org>
 <aruMPHNdZq7U9eV9@chamomile>
 <4da35a94-af13-47de-adef-35b5671100b7@kernel.org>
 <arupFwGHewREJJ74@chamomile>
 <6365150c-09d0-4a2c-84e3-ffe6e292e317@kernel.org>
 <asWEWpVJLk0so8zM@chamomile>
From: Matthieu Baerts <matttbe@kernel.org>
Autocrypt: addr=matttbe@kernel.org; keydata=
 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
 lzVbFe7fduHbABmYz9cefQpO7wDE/Q==
Organization: NGI0 Core
In-Reply-To: <asWEWpVJLk0so8zM@chamomile>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Pablo,

Thank you for your reply!

On 07/10/2026 01:29, Pablo Neira Ayuso wrote:
> On Wed, Sep 30, 2026 at 08:33:36PM +0200, Matthieu Baerts wrote:
>> On 29/09/2026 14:03, Pablo Neira Ayuso wrote:
>>> On Tue, Sep 29, 2026 at 12:40:47PM +0200, Matthieu Baerts wrote:
>>>> On 29/09/2026 12:00, Pablo Neira Ayuso wrote:
>>>>> On Tue, Sep 29, 2026 at 11:21:15AM +0200, Matthieu Baerts wrote:

(...)

>> If someone gives ...
>>
>>   tcp option mptcp subtype { mp-capable, mp-join, remove-addr } drop
>>
>> ... a bitmap could be used, but then that's specific to MPTCP I suppose.
> 
> I think this makes sense from user perspective.
> 
> The nft_exthdr expression needs iterate over the whole list of tcp
> options, then if type is 30, make a set lookup to check if the subtype
> value is in the set.
> 
> Something like:
> 
>  - loop
>  |  r1 <- exthdr     [ if no more tcp options, break loop ]
>  |  r2 <- lookup(r1) [ if found, break loop ]
> 
> but exthdr need to be taugh to resume from the last visited tcp
> option. A new loop expression would wrap these two exthdr and lookup
> expression (similar to nft_inner) and store the iteration context (ie.
> last visited tcp option to continue from there).
> 
> exthdr tcp option support needs advertise a new NFT_EXPR_LOOP flag, so
> it can be used with within this new nft_loop expression.

Yes, this or Fernando's idea (BTW, thank you for looking at that!). Both
will need to expose a new capability to the userspace from what I
understand, so any of them are fine for me.

> Another question: Would you still like to validate that DSS comes
> before REMOVE_ADDR?

I don't think that's needed: the RFC doesn't impose an order nor a
specific combination. When multiple MPTCP options are used, they are
notifying two different things.

If people are interested in validating that option A comes before option
B, that's certainly because they are trying to find a specific pattern
-- e.g. to identify a specific stack or kernel version -- not to
identify packets of a certain protocol. For them, they can use other
techniques, but I don't think we need to increase the complexity to
support that case. (At least for MPTCP.)

Cheers,
Matt
-- 
Sponsored by the NGI0 Core fund.

