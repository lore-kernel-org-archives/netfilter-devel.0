Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C02FD3BED31
	for <netfilter-devel@vger.kernel.org>; Wed, 20 May 2026 09:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779270025; cv=none; b=hs5VUvrEfCg90klvb9UfUicriEGmmK0B/icCI2pPPjM4fUOFts3O0i+IiZt+Aa5nkEDKFzmZiCCR8zNwDRB0R8L3VrPtbzfSEgfc13FVNVTnievhlYBbCE7DqNtnOC3aAhVIui7tGK09b6A0Xw4yEVg74YbPQNuzrL8oXoKZjc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779270025; c=relaxed/simple;
	bh=TZHnJzR7iW5HjIT/++IlzBeIvtY+z5VqbOjLwDmqCjY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pS+0LrSjJm+5QSnNQJGcuMGtEun2nf2miAelkluHJg5MLIdbZasBu2BSxdeZza9OjAfkrcYGWebjdZR+ScgvMHb1JC2jZn4JNLMnpgRkxXisRKn8CYsvaMqBEd8/SD6Ebl6jiseQjiK2xgx8yKyjhnvjqvdiUTNOoXgR479UMIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bF72g6m9; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bF72g6m9"
Message-ID: <ccfd7143-0f0a-4578-a195-65b84ec00cfb@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779270015;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JAPvx+mEyaz1lWZlLkw1vI+4plMOIax7ceS884DfaSY=;
	b=bF72g6m98CmcgqqPIv3OibXPRVjTPeVr3czwNEp5I8jMv3jUtGf3NI3EEVyVo6ePYSIJK1
	FF9Yg0Vt3e4tFk5PaMlmjtaVJXvodcoNBnpx+DIO/kwTa+6ZE+ADvuDLnbnlvjP0L2lsQt
	m/f7hFAjN+f7qKkwTqrFf3is902hUg4=
Date: Wed, 20 May 2026 17:39:48 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH nf v2 0/3] netfilter: nft_fib_ipv6: handle routes via
 external nexthop
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, fw@strlen.de,
 coreteam@netfilter.org
References: <20260520023411.391233-1-jiayuan.chen@linux.dev>
 <ag1-KRkLjQXHa6aJ@orbyte.nwl.cc>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Jiayuan Chen <jiayuan.chen@linux.dev>
In-Reply-To: <ag1-KRkLjQXHa6aJ@orbyte.nwl.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT


On 5/20/26 5:26 PM, Phil Sutter wrote:
> Hi,
>
> On Wed, May 20, 2026 at 10:34:08AM +0800, Jiayuan Chen wrote:
>> Patch 1 switches the fib6_siblings walk in nft_fib6_info_nh_uses_dev()
>> to list_for_each_entry_rcu().
>>
>> Patch 2 fixes the slab-out-of-bounds when the matched route uses an
>> external nexthop object.
>>
>> Patch 3 adds a selftest covering single nh, nh group and old-style
>> multipath.
>>
>> v1: https://lore.kernel.org/netfilter-devel/20260519041431.396218-1-jiayuan.chen@linux.dev/
>>
>> Changes since v1:
>>    - new patch 1: list_for_each_entry_rcu() conversion split out
>>      (Suggested-by: Phil Sutter)
>>    - patch 2:
>>      * drop redundant ternary in nft_fib6_nh_match_dev_cb (Phil)
>>      * drop redundant "!= 0" on nexthop_for_each_fib6_nh return (Phil)
>>      * use READ_ONCE() for rt->fib6_nsiblings (Phil)
> Will you send a v3 addressing Florian's concerns regarding the test case
> in patch 3?


In the current version, the selftest has already incorporated Florian's 
suggestion,that is,

to verify functionality rather than just serving as a bug reproducer 
(using nf_ok/nf_bad counter).


Sorry for not making this clear in the changelog : ).


> Patches 1 and 2 look good to me, thanks for the respin!
Thank for your review.
> Cheers, Phil
