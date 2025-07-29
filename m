Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5511A10957
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Jul 2025 01:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753753981; cv=none; b=bQNh/x/0PNXiTb7kwr9ZlL12F3JC1LQ2U77uT7GD19zLfJ2Fhhcjyk60Ge7UzC00n0oWi6xl5KfJrHkgeJhg1MjjF+/U7h1zl6sXqRAKit9XR9bwVX8j9dKi89oSYNUfJXpkqDIGXtT8rTi80h61iPO5vO7VkYeUJdfl0mi+Qxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753753981; c=relaxed/simple;
	bh=gBlWQyMozJdcDonu8Q2VqwcimonFYnAnUm5rS4IIcJs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LfZMKSG2KDt/J1ZxZNPKznLj/Pv5Xm1BptbcFoGvrP/torpC3kO0kxY02RMOjg0hU+82XLt/YIKVZ7wW3eRL9l9TIklOWv3DGbRunayE4GG3lynTD+ewzNLBUXa2pvw1sfzC2y1qAdoD3JAtUFLlbUamC/mJsTdZHYZEyfEbvsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ewUOLvNf; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ewUOLvNf"
Message-ID: <73710fd4-de44-459f-8db0-02e493566691@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753753967;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9U/sk+xmyR8x6V2nJlKMZERDGiuyCLMcm3nhKX+FSMU=;
	b=ewUOLvNfpdRHyRZ8kL1GW/3klu8JM0B+rA5vOh5v/WkGw+1H/gmPvOSOFaqeRbyce6goxQ
	sAISI6mYgs2IoqRTQ4HWEwAcFqihYXB5OKZ6H4Gi/b5qNaIfzqr8axPiMhTfst6Uc4i7WX
	6NdXoom4VzE9p0JGm1vU+bdrPoni1Ic=
Date: Tue, 29 Jul 2025 09:52:32 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3 1/1] netfilter: load nf_log_syslog on enabling
 nf_conntrack_log_invalid
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: fw@strlen.de, coreteam@netfilter.org, davem@davemloft.net,
 edumazet@google.com, horms@kernel.org, kadlec@netfilter.org,
 kuba@kernel.org, linux-kernel@vger.kernel.org,
 netfilter-devel@vger.kernel.org, pabeni@redhat.com, zi.li@linux.dev
References: <20250728102514.6558-1-lance.yang@linux.dev>
 <aIgb64Riu6FBcC28@calendula>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <aIgb64Riu6FBcC28@calendula>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 2025/7/29 08:55, Pablo Neira Ayuso wrote:
> On Mon, Jul 28, 2025 at 06:25:14PM +0800, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> When no logger is registered, nf_conntrack_log_invalid fails to log invalid
>> packets, leaving users unaware of actual invalid traffic. Improve this by
>> loading nf_log_syslog, similar to how 'iptables -I FORWARD 1 -m conntrack
>> --ctstate INVALID -j LOG' triggers it.
> 
> JFYI: I ended up taking v2 into nf-next, let me know if there is any
> issue with your previous version, thanks.

Thanks for picking up v2 and merging it into nf-next!

No issues at all from my side. v3 only contains minor cleanups with
no functional changes, so v2 is fine and good to go ;)

Thanks,
Lance

