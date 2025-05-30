Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5097319004A
	for <netfilter-devel@vger.kernel.org>; Fri, 30 May 2025 03:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748574652; cv=none; b=gmBzbNDngaRJY2tU8izmBlYN9Y6vJnkEh/lJSXlZo8JZWqf2ZPc7jn65mrcz8rJ52jfB1oNpUfiMi1lOBTa9ccV6tES73Tg6ATnkcJz0snkWPYdtaT7HJtP1qFMl7iMPLUzyyFQ4P1S5M2WlneUijGC8BNW96/kO8rcHrcFyXmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748574652; c=relaxed/simple;
	bh=Dn+CyC0JvyO5R/AcuungXdEiOqDoOFYO7/62igZNlXY=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=GilolIQxIAowCXaVIwokDDjpkNDLPCNd81n8BZck5lYAeOsS6EvVYq26SLgTTQX4pK8hfvtGK1d7vMXKJn1itv1rZLdJUGr49p98IrrVmq6CMeuIuGJVFiry+EBoeQ9rYOizS+dQnlh+khFz0JEtXMqfMYjY/ns4tvXHdZq76VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Pj+uQK4i; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Pj+uQK4i"
Message-ID: <4b7b81f0-c818-40f6-ba5f-64dbf8528893@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748574638;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qxmWCoqgZoSvwWE8g+gRmrqeGh5Erk+0rx4TFhB+dko=;
	b=Pj+uQK4ijpyR4dVCGYn0pCQDAfQ2tFyLOjmrchMVMak4V3mLRyqpUKqy1DR/llKLS+YwB9
	m+Nw8OZtn+5Y/PoJzMnQsmZP2RAXfwyo/cXNHNbhXtQFb3gauIzS9+skGhAiIchNOHs8un
	dffm9jzfIwWTYt9bQ5mycwDTOK/xkvI=
Date: Fri, 30 May 2025 11:10:30 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/1] netfilter: load nf_log_syslog on enabling
 nf_conntrack_log_invalid
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
To: Florian Westphal <fw@strlen.de>
Cc: pablo@netfilter.org, coreteam@netfilter.org, davem@davemloft.net,
 Lance Yang <ioworker0@gmail.com>, edumazet@google.com, horms@kernel.org,
 kadlec@netfilter.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
 netfilter-devel@vger.kernel.org, pabeni@redhat.com, zi.li@linux.dev,
 stable@vger.kernel.org
References: <20250526085902.36467-1-lance.yang@linux.dev>
 <aDbt9Iw8G6A-tV9R@strlen.de> <a2f5fb23-e57a-4a83-bb95-b5756df0e2d7@linux.dev>
Content-Language: en-US
In-Reply-To: <a2f5fb23-e57a-4a83-bb95-b5756df0e2d7@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Cc: stable

On 2025/5/28 19:42, Lance Yang wrote:
> 
> Thanks for taking the time to review!
> 
> On 2025/5/28 19:05, Florian Westphal wrote:
>> Lance Yang <ioworker0@gmail.com> wrote:
>>> From: Lance Yang <lance.yang@linux.dev>
>>>
>>> When no logger is registered, nf_conntrack_log_invalid fails to log 
>>> invalid
>>> packets, leaving users unaware of actual invalid traffic. Improve 
>>> this by
>>> loading nf_log_syslog, similar to how 'iptables -I FORWARD 1 -m 
>>> conntrack
>>> --ctstate INVALID -j LOG' triggers it.
>>
>> Acked-by: Florian Westphal <fw@strlen.de>
> 
> Hmm... should this patch be backported to stable kernels? Without it,
> nf_conntrack_log_invalid won't log invalid packets when no logger is
> registered, causing unnecessary debugging effort ;)
> 
> Back then, I actually thought my machine wasn't seeing any invalid
> packets... turns out they just weren't logged in dmesg :(
> 
> Thanks,
> Lance

