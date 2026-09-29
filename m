Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256F14CE683
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Sep 2026 09:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790674459; cv=none; b=b0gyxVlcLbZDHN5gcMxpxuT/8Y3Snf1YrFZkwD6wAhbqyFVGy5kA5qGmOPqlb6IUK7py7V3mglIioUsm7fWAHsKwxFzxVi6Q/LZZibk4gSN1D/OwQLyF1U9TpufjEyXmbx5HmO1b4/XLy9QSNSY/u1SePstScNHs/P7ReypIhn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790674459; c=relaxed/simple;
	bh=Jz533e4zw9ygXoMc10I8j6l1QwX5B8qv0+NXCpTq4Cs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LLTyGMDXiBZ5uurEppfuTVOAkegx0l8zOzIfNkSBzllqB+Vdn1I5xpSq17PfomomvnMxjQtAGU2RLesocLXO6IGhPzF1GP4MtkV9EDOEjXMqxeuaYEk/Ag0/THeMQJWZQohPX5eW8g4RY1VbYDxZT7evjfjXCnKBRNOoGRuMS28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CNJoekom; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CNJoekom"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0933C1F000FF;
	Tue, 29 Sep 2026 09:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790674457;
	bh=A2GIzru1jSoIBMTUSdCSMIC8KScXbXWXR52BHh2Vq0Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CNJoekomBhLqNfzHYrPtXdikE0NSgzRXRcxYIv1qYOb9niNjuS0t/Zm8tpYxAJH4K
	 OrFJHiDLHXAP5v221kuYQu72EmqBe9nmvKyRKXkZjDz5o+sTShTAF8Ds7NGvd5lUD/
	 UHKn9Gt82nQKrK3xEYV3jZFkHEqHOXsDVxv4EqRww2HC0Ew9avNW2dLcG+dZUXreEZ
	 oG3T/xwEOxw4NMuDLBPaaCusV2gOIDZftdr1MiUoKWdBMe6JO+4UTDKAQ0oJpRLRk/
	 +KjC12TjP1XKPimRGPRnFr3DEy2NmwHJL0rZIlc7g2S+7qB3qVQRFlM/1Ok+0Ni+RT
	 Bll9q/I4saC5g==
Message-ID: <6260a189-aa8b-42c5-bc85-bc2367656fd5@kernel.org>
Date: Tue, 29 Sep 2026 11:34:14 +0200
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
To: Jan Engelhardt <ej@inai.de>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>,
 Netfilter Coreteam <coreteam@netfilter.org>
References: <a391d81c-0bce-41e6-886e-a558765c6891@kernel.org>
 <ro0285nn-9p34-n561-q86n-1s668021npor@vanv.qr>
From: Matthieu Baerts <matttbe@kernel.org>
Autocrypt: addr=matttbe@kernel.org; keydata=
 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
 lzVbFe7fduHbABmYz9cefQpO7wDE/Q==
Organization: NGI0 Core
In-Reply-To: <ro0285nn-9p34-n561-q86n-1s668021npor@vanv.qr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Jan,

On 28/09/2026 23:54, Jan Engelhardt wrote:
> On Monday 2026-09-28 14:13, Matthieu Baerts wrote:
> 
>> The MPTCP selftests are switching from IPTables to NFTables, and
>> Clashiko reported that this part of a rule wouldn't match anything:
>>
>>  tcp option mptcp subtype remove-addr drop
>>
>> When an MPTCP REMOVE_ADDR suboption (type 0x30, len >=4, subtype 0x4) is
>> added to the TCP options, it is added after an MPTCP DSS option (type
>> 0x30, len >= 8, subtype 0x2). In other words, there will be two MPTCP
>> (type 30) options in the TCP options. It looks like Netfilter doesn't
>> handle that, because it stops processing other TCP options when the
>> expected type is found:
>>
>> net/netfilter/nft_exthdr.c:nft_exthdr_tcp_eval() {
>>    ...
>> 	for (i = sizeof(*tcph); i < tcphdr_len - 1; i += optl) {
>> 		optl = optlen(opt, i);
>>
>> 		if (		priv->type != opt[i])
>> 			continue;
>> 		...
>> 		return;  // <== it will look at the first MPTCP option
>> 	}
> 
> Hm, neither RFC 793 nor 9293 seem to define a general processing rule
> or error-handling behavior for duplicate or repeated options within
> the header of a TCP segment.

From what I understood at the IETF, new TCP extensions can only be
assigned one "type". If multiple message types should be passed, the
subtype should be either extracted from the size, or by using another
TLV inside. (MPTCP is using the two techniques.)

(Old extensions like SACK and echo are exceptions, because they are old
ones.)

> MPTCP RFC 8684 seems to acknowledge that, with:
> 
> "it may not be possible to combine all desired options .. on a single
> packet"

The MPTCP RFC specifies this mainly because of the TCP options space
restriction (40 bytes). For example, the ADD_ADDR option can take up to
30 bytes (+2 for the alignment). If you add TCP Timestamp (10 + 2 for
the alignment) or SACK, you are over the limit.

Cheers,
Matt
-- 
Sponsored by the NGI0 Core fund.

