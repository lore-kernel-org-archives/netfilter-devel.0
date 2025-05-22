Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214B52B9B7
	for <netfilter-devel@vger.kernel.org>; Thu, 22 May 2025 02:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747879592; cv=none; b=IG+PCrdVCL7g1mP3ezqgnMXEPnt4J09+/kI3CIFLBGBt2aqj3HAFqe7Mn3UgTvH/a4pn5vO/eptGCcbeh8wau/NV7Z26XnVPP3WoR+iKOnTRLCvwWPVsOsVwLbf/fRAx+I9sbjLsGzHC/BrgOZ3N0jIxrdrr9BhLv9I+ViHIaVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747879592; c=relaxed/simple;
	bh=O28jIlXIf5gfesN/XPxs7fVyntVRfvLjhoqGkUxFXsE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L2cUxjNxV5ildOSIxIZyPSmVzMb8AJO4Ptwh9xyfvkAqETM4+h3NSUsMJK1avlDOA9ho5Qf/tYUExPgasQnnz8gTrmYzZYiE9tlunjYcQbAaPiQdGh3yoJQCdA5+lp3jQIaVxcxHtEnjOiHlD5Pu1RA9DpU4Jcdw2S63D1W8TP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wtMJ0nhy; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wtMJ0nhy"
Message-ID: <1c21a452-e1f4-42e0-93c0-0c49e4612dcd@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1747879587;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Goe+x3x0xtqgGb8hs7fXbNwjAvjiSoD8kMH2h6/QAzE=;
	b=wtMJ0nhyegawJYaSZcDstkO45B/lnH37UWpkJtOhEfuTJr9/cRTxx9PeDoyBV4I8BsKpt6
	vxWAjnLN0agbD15Ad+tZA666Ht3xxWoX4PjPMz9D1fj0Xkil5u3EGr7L2XBwz34ttGVdGy
	IKEYn6MgS+XNzH402nLYlDo9hCedmV4=
Date: Thu, 22 May 2025 10:05:54 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [RESEND PATCH 1/1] netfilter: load nf_log_syslog on enabling
 nf_conntrack_log_invalid
Content-Language: en-US
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Lance Yang
 <ioworker0@gmail.com>, kadlec@netfilter.org, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 coreteam@netfilter.org, linux-kernel@vger.kernel.org,
 netfilter-devel@vger.kernel.org, Zi Li <zi.li@linux.dev>
References: <20250514053751.2271-1-lance.yang@linux.dev>
 <aC2lyYN72raND8S0@calendula> <aC23TW08pieLxpsf@strlen.de>
 <6f35a7af-bae7-472d-8db6-7d33fb3e5a96@linux.dev> <aC4aNCpZMoYJ7R02@strlen.de>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <aC4aNCpZMoYJ7R02@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 2025/5/22 02:23, Florian Westphal wrote:
> Lance Yang <lance.yang@linux.dev> wrote:
>>> There is no need for 'syslog' to be active for 'log_invalid' to be
>>> useful as long as the system in question has e.g. ulogd running
>>> and listening to nflog messages.
>>>
>>> If anything, the modprobe should be done only when no logger
>>> is registered.
>>
>> Yes, could we load the module only when no logger exists? Something
>> like:
>>
>> + if (nf_logger_find_get(NFPROTO_IPV4, NF_LOG_TYPE_LOG) != 0)
>> + 	request_module("%s", "nf_log_syslog");
> 
> This function bumps the module refcount, so if the logger exists you
> would need to call nf_logger_put() too.

Ah, understood ;)

> 
> I'd add a new, simpler helper, that only returns if any logger
> is active.
> 
> bool nf_log_is_registered(int pf);
> 
> or something like that.

Nice, thanks for jumping in! I'll hold until the helper lands, then
rebase and send the v2.

Thanks,
Lance
