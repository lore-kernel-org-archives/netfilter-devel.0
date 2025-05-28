Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9739283C90
	for <netfilter-devel@vger.kernel.org>; Wed, 28 May 2025 11:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748432595; cv=none; b=d7BaFVBzEUKvIFt1izOHHsu9IJFuK9P6h3JBlDB+mrvrUEW0opuoRaI3XCGiEMlFbcLl725AqicQyUqNODYdyIluGd41f5CyP2Xlt5mc8TsVEangmxHSqqTKmllHMY7Mg1NTKKD+iEWQrjeZMohZLEfbVAx7XrLud5HrMg73W/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748432595; c=relaxed/simple;
	bh=F14WpKvt+umuWe3/Isc5tPu1qABYABZZp0MgaG9pYeg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xu9OhtOibNFf1ovJzpuwx3YsBQlsNvZP58sBtAbfDHJt/7Bf+/uA/USeSKHPVZb+bRzuKlF7PaVHHEha5QPLmwcr2fSCPdn2aBDUYPbZYLx5FFC7q2Agqp2oF2G3tTG3foncjBD4cotkQhfXa6n6jnhMX4VhWFWEf9ZcfYZHbm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CXZSk8QF; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CXZSk8QF"
Message-ID: <a2f5fb23-e57a-4a83-bb95-b5756df0e2d7@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748432581;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YE1ELheB7GeGGiQgSxZMg6BAxL+LxZtmsKzHFj/F6a8=;
	b=CXZSk8QFLRjGA8Q5yqW8MqFoxFum+XvmH2ioKhW1iETEpG+zoRpfLbuSwSb9z7N+86kRRv
	zxadLT2tUi/LSAM/KI4V0xxJiFlZeMQixL1Q6wZbsrpjAJQDag2II306jZKcvpotlsVFPu
	WAM3B/n7U8rcZi+q1Hg4E8UhUGynKcI=
Date: Wed, 28 May 2025 19:42:50 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/1] netfilter: load nf_log_syslog on enabling
 nf_conntrack_log_invalid
To: Florian Westphal <fw@strlen.de>
Cc: pablo@netfilter.org, coreteam@netfilter.org, davem@davemloft.net,
 Lance Yang <ioworker0@gmail.com>, edumazet@google.com, horms@kernel.org,
 kadlec@netfilter.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
 netfilter-devel@vger.kernel.org, pabeni@redhat.com, zi.li@linux.dev
References: <20250526085902.36467-1-lance.yang@linux.dev>
 <aDbt9Iw8G6A-tV9R@strlen.de>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <aDbt9Iw8G6A-tV9R@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT


Thanks for taking the time to review!

On 2025/5/28 19:05, Florian Westphal wrote:
> Lance Yang <ioworker0@gmail.com> wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> When no logger is registered, nf_conntrack_log_invalid fails to log invalid
>> packets, leaving users unaware of actual invalid traffic. Improve this by
>> loading nf_log_syslog, similar to how 'iptables -I FORWARD 1 -m conntrack
>> --ctstate INVALID -j LOG' triggers it.
> 
> Acked-by: Florian Westphal <fw@strlen.de>

Hmm... should this patch be backported to stable kernels? Without it,
nf_conntrack_log_invalid won't log invalid packets when no logger is
registered, causing unnecessary debugging effort ;)

Back then, I actually thought my machine wasn't seeing any invalid
packets... turns out they just weren't logged in dmesg :(

Thanks,
Lance
