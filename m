Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85BA3ED5D6;
	Tue,  6 Oct 2026 13:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791292630; cv=none; b=V3TMdpqv0yxYgHb/YieKYlo1x49zO2cRf8OI8AMldoZuN5uJojxX5kH7rxIfGR3DCpjtnDwYeXkmzXffi5Em9RomRXJ5R6a4guqhLjcwi+skWzB13xFJXefwodyRAB8madJpm8RZJKJbidX1GnqNye6D/8vgjRXerQIea9mGHAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791292630; c=relaxed/simple;
	bh=nMLIv5b8FgYxUAJL70j13ODD8h60rrpKuPu4YZIEV6A=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=TB/FECdcSQklBQlrNlEm7qiD5g+p4GMzPGwxYAjHFZX+7N+Ohs6nBEGjMwlb8oON40RSbmRcPdRLYSEMol4poGgV8qyf0lZTKNhjTFq5RgPp/0Zn5FMGnyRRXqWAL09ZgxpmGJc1KaP+bc+DUITDJBRMcpO0gUxfQTrqP0Zi9jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr; spf=pass smtp.mailfrom=oss.cyber.gouv.fr; dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b=LJwznXkd; arc=none smtp.client-ip=51.159.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b="LJwznXkd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	Message-ID:References:In-Reply-To:Subject:Cc:To:From:Date:MIME-Version:
	Reply-To:Sender:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
	bh=k5vD5U2vDHop2y93h5RObps/SJVwtXt/ikqi9pmsRyw=; b=LJwznXkd9feDS7KEE+0TKpJfvK
	UbX3SvWbrB/3yge0aTnVhNkc8Pgg13hP6lEQvfmsv9/rtioKOjB+4TgrxNg0w+/V8FfDsOidGdGJR
	/GVl5d2cgoIjIkmbi4OxjgIAU7b7fsY0+Arj82FoR8ibWTRjniUU1NNDylM1AE8Eti20fQf9F4n9t
	UkH7M0vFA5EzNEkE8elskAnt4qb8RGJTA0UIA9sspK5R+BA8sYGsJvFvZSoBC7viylvemfJmYzxPz
	8nSLnCXDdB1+iRvtNjz3R5Lw+CV4kABmLoxM2YY6i1I76Z/RVUFZdsF1S2PWLyFeXSQeu+P6PoJSs
	TByaNAiw==;
Received: from [::1] (port=50768 helo=pf-012.whm.fr-par.scw.cloud)
	by pf-012.whm.fr-par.scw.cloud with esmtpa (Exim 4.100.1)
	(envelope-from <jeremy.jean@oss.cyber.gouv.fr>)
	id 1xE52Z-0000000Fv2X-486s;
	Tue, 06 Oct 2026 15:17:06 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 06 Oct 2026 15:17:06 +0200
From: =?UTF-8?Q?J=C3=A9r=C3=A9my_Jean?= <jeremy.jean@oss.cyber.gouv.fr>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_set_rbtree: reject expired interval
 ends
In-Reply-To: <asQtPfgYhK1uxMpR@chamomile>
References: <20261005200404.3544062-2-Jeremy.Jean@oss.cyber.gouv.fr>
 <asQtPfgYhK1uxMpR@chamomile>
User-Agent: Roundcube Webmail/1.6.19
Message-ID: <9a9f2587b7bd37c8d03d0105cf968b25@oss.cyber.gouv.fr>
X-Sender: jeremy.jean@oss.cyber.gouv.fr
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - pf-012.whm.fr-par.scw.cloud
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - oss.cyber.gouv.fr
X-Get-Message-Sender-Via: pf-012.whm.fr-par.scw.cloud: authenticated_id: jeremy.jean@oss.cyber.gouv.fr
X-Authenticated-Sender: pf-012.whm.fr-par.scw.cloud: jeremy.jean@oss.cyber.gouv.fr
X-Source: 
X-Source-Args: 
X-Source-Dir: 

On 2026-10-06 01:05, Pablo Neira Ayuso wrote:
> Hi,
> 
> On Mon, Oct 05, 2026 at 08:04:05PM +0000, Jérémy Jean wrote:
>> Consider two ranges in a netfilter verdict map:
>> * keys 10-19 accept packets, and
>> * keys 30-39 jump to chain 'victim'.
>> Now, delete the end marker at 20. The lookup array now uses element 30
>> as the first range's end, so an INTERVAL_END query for key 15 returns
>> element 30, including its jump verdict and chain pointer. This can 
>> make
>> KASAN reports a UAF after the GC releases reference chain for 30 that
>> has expired:
>> 
>>   BUG: KASAN: slab-use-after-free in nft_verdict_dump+0xdd/0x110
>>   Read of size 8 at addr ff110000009dfb58 by task repro/50
>>   ...
>>   Call Trace:
>>   ...
>>    nft_verdict_dump+0xdd/0x110
>>    nft_data_dump+0x4d/0x80
>>    nf_tables_fill_setelem+0x30b/0x8a0
>>    ? __asan_memcpy+0x3c/0x60
>>    nf_tables_fill_setelem_info+0x1b0/0x200
>>    nft_get_set_elem+0x3fd/0x4b0
>>   ...
>>   Freed by task 24:
>>   ...
>>    kfree+0x1a5/0x280
>>    nf_tables_trans_destroy_work+0x2cb/0x520
>> 
>> Reject expired endpoints in nft_rbtree_get() before returning them.
>> 
>> Fixes: 2aa34191f06f ("netfilter: nft_set_rbtree: use binary search 
>> array in get command")
>> Cc: stable@vger.kernel.org
>> Assisted-by: LLM
>> Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
>> ---
>>  net/netfilter/nft_set_rbtree.c | 2 ++
>>  1 file changed, 2 insertions(+)
>> 
>> diff --git a/net/netfilter/nft_set_rbtree.c 
>> b/net/netfilter/nft_set_rbtree.c
>> index 9894832..1fd9cbe 100644
>> --- a/net/netfilter/nft_set_rbtree.c
>> +++ b/net/netfilter/nft_set_rbtree.c
>> @@ -187,6 +187,8 @@ nft_rbtree_get(const struct net *net, const struct 
>> nft_set *set,
>>  	if (flags & NFT_SET_ELEM_INTERVAL_END) {
>>  		if (!interval->to)
>>  			return NULL;
>> +		if (nft_set_elem_expired(interval->to))
>> +			return ERR_PTR(-ENOENT);
>> 
>>  		rbe = container_of(interval->to, struct nft_rbtree_elem, ext);
>>  	} else {
>> --
>> 2.47.3
> 
> 
> Can you test this fix instead? Thanks

Hello Pablo,

Thanks for this improved fix. I replayed the reproducer I had that 
triggers the
bug on the kernel that includes your patch, and I confirm that it fixes 
the UAF.

Let me know if I could be of further assistance.

Regards,
Jérémy
