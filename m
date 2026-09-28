Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1BD4D597C
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Sep 2026 20:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790627202; cv=none; b=jj4v/NoKBn6on2tMqmTDNgMogEXYavGb+6VDRQ9Nf0+pa/KOUBzTg+rlK+bdsBBJiVQZORg/hDOAlHMJpWMs3beLjymrAXWR/exJhjZIC4LJe7P+mDsNC62iiNezwChhV+KBXpFpXOcbZd6SvEekdOQW4zZdmT7dEd2myKriiEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790627202; c=relaxed/simple;
	bh=bQBIPk/RiSXlZQywiMTYskTnRMQnXaF3+U43YIPWmvQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t0JzBO/9ExKhfnAsSiyBpgGPSxz2KVp4X3CnQaa1SZAPrZgVU1AytKPmxrvoLv7gSP8cwl0uIFB4SoUCS4vbAgKpt9X1aYiYiJaCQoCG85Gwt0htSfGXZ1jMhr64X0YLzSNGl0RxU1FewfSBzLfdGPnz3Xh81Tr9zAUSxyUWXQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ehPFQ8CK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ehPFQ8CK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 471001F000FF;
	Mon, 28 Sep 2026 20:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790627201;
	bh=6drJPILI7g/pSQbVyLAOTvuJCz16MkW+IIKcnrQMk9A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ehPFQ8CKu8lCxqSD9fUZoCmPWongoI4kdz8Z7JhvjU5pjpAfw2ncVD7tx4nkhaI2a
	 OcalCyf4/yXI4hLdSh56kU/lPzIaxZmKd1ZhKcQHF489wuExJ7hBPQKauOuuLSY/IL
	 BdMWsPKF1RZrKppEH2/WZMWKkZucb5f66m3kG4PaHRr7LWsRiphyvCPDF76DivqFkZ
	 ufTB6hlsXse7fkaPeMz57EXQy4SPnSBBP0OLO153nwkZ/HRlUwl97rL3HA/xjG8pAm
	 KkRl5lNpTUVHAh4n7ld2cy57DmcPzhr0mA/XuvYqE2+Fs8PdGNbt/ZeALOKenVuxD8
	 HQG3avVyjxE8g==
Message-ID: <cc29ad91-bb10-4b82-813b-2acea5dab3a7@kernel.org>
Date: Mon, 28 Sep 2026 22:26:37 +0200
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
To: Florian Westphal <fw@strlen.de>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>,
 Netfilter Coreteam <coreteam@netfilter.org>
References: <a391d81c-0bce-41e6-886e-a558765c6891@kernel.org>
 <arpn7_v8156iSc85@strlen.de>
From: Matthieu Baerts <matttbe@kernel.org>
Autocrypt: addr=matttbe@kernel.org; keydata=
 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
 lzVbFe7fduHbABmYz9cefQpO7wDE/Q==
Organization: NGI0 Core
In-Reply-To: <arpn7_v8156iSc85@strlen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Florian,

Thank you for your reply!

On 28/09/2026 15:13, Florian Westphal wrote:
> Matthieu Baerts <matttbe@kernel.org> wrote:
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
> 
> Yes, this won't work. 'tcp option X' extracts the
> option X.
> 
> I don't see how this could be fixed within the limitations of the
> architecture.

That's what I was thinking too :-/

> Just use bpf.

Yes, or with a raw payload expression with NFTables.

>> It looks like it shouldn't stop if the wrong subtype is found, but the
>> subtype is not compared there if I'm not mistaken. Should there be a fix
>> to support this case?
> 
> I don't know how, unless one would extend the kernel to make it aware of
> mptcp, which also requires userspace to pass the suboption type to look
> for in addition to 'mptcp option'.

Should there be a note somewhere in the doc about this limitation?
Because it looks like it will never be possible to match such subtype.

There are other MPTCP suboptions that can be used with DSS, e.g. MP_PRIO
and MP_FAIL. But also MP_RST that can be used with FAST_CLOSE.

>> BTW, I'm probably missing something, but adding the following doesn't
>> seem to have any effect on my side:
>>
>>   nft add table ip filter
>>   nft add chain ip filter OUTPUT \
>>     { type filter hook output priority filter; policy accept; }
>>   nft insert rule ip filter OUTPUT tcp option mptcp exists counter drop
>>
>> Same with "mptcp subtype mp-capable", other subtypes or other types like
>> "timestamp". But if I use ...
>>
>>   nft insert rule ip filter OUTPUT meta l4proto tcp counter drop
>>
>> ... then the drop is effective. Any idea what I'm missing here? :)
> 
> No idea.
> cd git/netfilter.org/nftables/tests/shell; ./run-tests.sh -k testcases/packetpath/tcp_options
> 
> passes here.
> Even tried adding 'tcp option timestamp exists...' to the test, also
> passes.

Arf, my bad, I still had debugging code, sorry... :/

Cheers,
Matt
-- 
Sponsored by the NGI0 Core fund.

