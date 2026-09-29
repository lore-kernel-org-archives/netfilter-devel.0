Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4480C3BB102
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Sep 2026 09:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790673690; cv=none; b=mRcioDiJNWY3bEIjOMeEjaSqP3LGx0hePDq04+igCyb0nnefw3d3/HI43wFGj88WpJQB8xW0DoeijBJDZQBhjTFpvKAN/1jpMX4ojSqOytL3+3HP9ePpuvM9oGqUP/D8o8uAEYrf0iUPWDtHWPDO/cd8O+TxzINSh0RJAYZX7XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790673690; c=relaxed/simple;
	bh=xKCC4Kc3p6zB5GCooBoneLYDAhrQSEtNrHzXiXUJz3o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i4HyKMyKl+mVCD2zoKF1Xo8bclzaVDqS6XNOvqy1DchP36/pvE/aWsVJs31m2Mebnu4un17HaKaDjzi9HWYx7S08lRTp8AcWnfsEQKwjN4fzp1HthKB/O8A5RKcC2D5gIY2WZd1/PWM4paSuyDW81p33/HdQ8bu9hslWpJ1gaAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W/inYw8v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W/inYw8v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D51231F000FF;
	Tue, 29 Sep 2026 09:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790673678;
	bh=gV4aCqAnPgJnyxH2nfN7Qm6binA2WW4nBypoUepdygI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=W/inYw8vfaRv8hepkie5oSYjHBfMe5yrUWsvKviaBPBNFUbeQWKDwnLGCikiC/d4V
	 DknjzkpK74Xz9T+3e+gmtOrrQJ9VZSSxcSLaTwkC7T4IUSQkSaoN38VgY78RRpthWo
	 a+i7dFhI0XDt41Jr9++d4s02FA5ohrhLNHmdEAbOhCjUuCjJGpy9lIi8M26UGWKoE4
	 NnyC/I56g9RQRX0ZHv9dWhhovZZlsZlIRLSqkRgDCMM2S3VZKwZcQrrK/MBsz0aFnY
	 1/N2K2u7YvuL9V7qxPKyKlz/pwcv4F0ICR3BlMVqiEhI3QYOULtw7U/8Q7qgmncBM4
	 ZABcRzwOmYQDw==
Message-ID: <a1e6f81d-d902-4bae-8244-ad936ef70e19@kernel.org>
Date: Tue, 29 Sep 2026 11:21:15 +0200
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
 Netfilter Coreteam <coreteam@netfilter.org>
References: <a391d81c-0bce-41e6-886e-a558765c6891@kernel.org>
 <arrhlKkKSSKFp4Sq@chamomile>
From: Matthieu Baerts <matttbe@kernel.org>
Autocrypt: addr=matttbe@kernel.org; keydata=
 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
 lzVbFe7fduHbABmYz9cefQpO7wDE/Q==
Organization: NGI0 Core
In-Reply-To: <arrhlKkKSSKFp4Sq@chamomile>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Pablo,

Thank you for your reply!

On 28/09/2026 23:52, Pablo Neira Ayuso wrote:
> Hi Mattieu,
> 
> On Mon, Sep 28, 2026 at 02:13:16PM +0200, Matthieu Baerts wrote:
>> Hello Netfilter devs,
>>
>> First, thank you for maintaining Netfilter in the kernel and the
>> userspace tools.
>>
>> The MPTCP selftests are switching from IPTables to NFTables, and
>> Clashiko reported that this part of a rule wouldn't match anything:
>>
>>   tcp option mptcp subtype remove-addr drop
>>
>> When an MPTCP REMOVE_ADDR suboption (type 0x30, len >=4, subtype 0x4) is
>> added to the TCP options, it is added after an MPTCP DSS option (type
>> 0x30, len >= 8, subtype 0x2). In other words, there will be two MPTCP
>> (type 30) options in the TCP options. It looks like Netfilter doesn't
>> handle that, because it stops processing other TCP options when the
>> expected type is found:
>>
>> net/netfilter/nft_exthdr.c:nft_exthdr_tcp_eval() {
>>     ...
>> 	for (i = sizeof(*tcph); i < tcphdr_len - 1; i += optl) {
>> 		optl = optlen(opt, i);
>>
>> 		if (priv->type != opt[i])
>> 			continue;
>> 		...
>> 		return;  // <== it will look at the first MPTCP option
>> 	}
>>     ...
>> }
>>
>> It looks like it shouldn't stop if the wrong subtype is found, but the
>> subtype is not compared there if I'm not mistaken. Should there be a fix
>> to support this case?
> 
> Would it work for you if you can specify what TCP option you want to
> match? ie.
>  
>     tcp option[2] mptcp subtype remove-addr drop
>                ^
>                |
>                |
>        allow to specify a match at a given tcp option

In my specific use-case, yes it would work. Some MPTCP sub-options will
always be after another one... when the Linux stack is used.

> Or would this be too strict for your use-case and you would prefer
> that you can match it anywhere?

I think it would make more sense to match it anywhere. For example, an
MP_RESET can be used alone, or after an MP_FASTCLOSE. Plus some stacks
could reorder the options as there is no imposed order.

Cheers,
Matt
-- 
Sponsored by the NGI0 Core fund.

