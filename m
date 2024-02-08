Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0976967C45;
	Thu,  8 Feb 2024 05:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.237.130.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707371315; cv=none; b=r6Zbsw/Ckg/JkPMQWWdmLM02LITrzM8LWnxAQ80UDcyv8xzBNeafqTyZrBiCoEr4qjCw6hwsWNYKU0N2RjxWec0HtfQhTgtKcmTU/l3Yl7Y629Tm3RYWCwO+qkUp5V0/43H6HUp7+eyhNcQJRRRBdG9BppZleUoW/lSlM7qscSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707371315; c=relaxed/simple;
	bh=bVuiZaFG8LtkLH6SCRvw1CAui7KJcVPOCwYBYV+zuHA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EbNL7j4tetnhDxMIyPkKJ8HBomCPBUzPyzq9fLtE0lPBrDYEm2uim6L9CRgtBWV0/OwFJubJAu4eqe9y/ZwFqpGakA4rR62XS6ETuYDLeKjyYQ/j2nS9MrmqGPHo/Pwf/qmrZgsHLonSLJmsjh6FZ3AKVy3i17sHReuelmLQ4d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; arc=none smtp.client-ip=80.237.130.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	id 1rXxGu-000812-OY; Thu, 08 Feb 2024 06:48:28 +0100
Message-ID: <9fb4e908-832c-44ae-8049-f6e9092f9b10@leemhuis.info>
Date: Thu, 8 Feb 2024 06:48:27 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 05/13] netfilter: ipset: Missing gc cancellations
 fixed
Content-Language: en-US, de-DE
To: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
 pabeni@redhat.com, edumazet@google.com, fw@strlen.de
References: <20240207233726.331592-1-pablo@netfilter.org>
 <20240207233726.331592-6-pablo@netfilter.org>
From: Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <20240207233726.331592-6-pablo@netfilter.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1707371313;03bf8b85;
X-HE-SMSGID: 1rXxGu-000812-OY

On 08.02.24 00:37, Pablo Neira Ayuso wrote:
> From: Jozsef Kadlecsik <kadlec@netfilter.org>
> 
> The patch fdb8e12cc2cc ("netfilter: ipset: fix performance regression
> in swap operation") missed to add the calls to gc cancellations
> at the error path of create operations and at module unload. Also,
> because the half of the destroy operations now executed by a
> function registered by call_rcu(), neither NFNL_SUBSYS_IPSET mutex
> or rcu read lock is held and therefore the checking of them results
> false warnings.
> 
> Reported-by: syzbot+52bbc0ad036f6f0d4a25@syzkaller.appspotmail.com
> Reported-by: Brad Spengler <spender@grsecurity.net>
> Reported-by: Стас Ничипорович <stasn77@gmail.com>
> Fixes: fdb8e12cc2cc ("netfilter: ipset: fix performance regression in swap operation")

FWIW, in case anyone cares: that afaics should be

 Fixes: 97f7cf1cd80e ("netfilter: ipset: fix performance regression in swap operation")

instead, as noted yesterday elsewhere[1].

Ciao, Thorsten

[1] https://lore.kernel.org/all/07cf1cf8-825e-47b9-9837-f91ae958dd6b@leemhuis.info/
