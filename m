Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE090165FAA
	for <netfilter-devel@vger.kernel.org>; Wed,  1 May 2024 22:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714601482; cv=none; b=isNsKxGEApZdk9JjUuHkFCA7dUXez/SXzlCv6lR5uLPe9AK1RbATe9ReQzTuBas5QaSrhRpliXMMyymUlmw846PBo7ywOaB57M1QK7o4w8SDSJtGpRYxozucMdP2Ce7D0gIGLtXGPSl9GGWrZ/JqIG8wqQ/wEGrJ0vJGBzqchGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714601482; c=relaxed/simple;
	bh=mIJlBSZdyKIvENC8XczJFKTy5wuRWt3B+ZgNrKdjlJE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MUUnubJYbRwWOcJeMe1B/EuLsSF3npL9hx+SEpSCSrMU/hI4kLNQAvd6QOEPR2vMftZrGv4ctLIozUSgqnLNdaQoNTy3iamfDX2vYXs1Z1yHZ02OKtoHkoofA5weNUn542J92clLo6UzgeOBKV0XxPc0sbgYbfReHg3IzILKW+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BN+LYUb5; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BN+LYUb5"
Message-ID: <f3721e87-10dc-46d7-86b1-432d8afa4b21@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714601478;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rGW3yDHopUvbdT8k5H063AAugiRm6wOVHCvilw2wUW0=;
	b=BN+LYUb5O8VnwZrZyQbvc12jesTJVCflel+oYDFTQ4vHJVvS9X4XzZT0u6XEGUY65Txu8W
	I8IjAkDuOkjycm/eK/e16I6cLyzRfKOtsE1vjTIkDChPJJFYUEqdpXfEkPAWJJomW5zgod
	a6TVep454qqHA94hmzQTgBtwY3QFbe0=
Date: Wed, 1 May 2024 15:11:09 -0700
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v2 1/2] net: netfilter: Make ct zone opts
 configurable for bpf ct helpers
To: Brad Cowie <brad@faucet.nz>
Cc: andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
 coreteam@netfilter.org, daniel@iogearbox.net, davem@davemloft.net,
 john.fastabend@gmail.com, jolsa@kernel.org, kuba@kernel.org,
 lorenzo@kernel.org, memxor@gmail.com, netdev@vger.kernel.org,
 netfilter-devel@vger.kernel.org, pabeni@redhat.com, pablo@netfilter.org,
 sdf@google.com, song@kernel.org
References: <463c8ea7-08cf-412e-bb31-6fbb15b4df8b@linux.dev>
 <20240501045931.157041-1-brad@faucet.nz>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20240501045931.157041-1-brad@faucet.nz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 4/30/24 9:59 PM, Brad Cowie wrote:
> On Fri, 26 Apr 2024 at 11:27, Martin KaFai Lau <martin.lau@linux.dev> wrote:
>> On 4/23/24 8:00 PM, Brad Cowie wrote:
>>>    };
>>>
>>>    static int bpf_nf_ct_tuple_parse(struct bpf_sock_tuple *bpf_tuple,
>>> @@ -104,11 +107,13 @@ __bpf_nf_ct_alloc_entry(struct net *net, struct bpf_sock_tuple *bpf_tuple,
>>>    			u32 timeout)
>>>    {
>>>    	struct nf_conntrack_tuple otuple, rtuple;
>>> +	struct nf_conntrack_zone ct_zone;
>>>    	struct nf_conn *ct;
>>>    	int err;
>>>
>>> -	if (!opts || !bpf_tuple || opts->reserved[0] || opts->reserved[1] ||
>>> -	    opts_len != NF_BPF_CT_OPTS_SZ)
>>> +	if (!opts || !bpf_tuple)
>>> +		return ERR_PTR(-EINVAL);
>>> +	if (!(opts_len == NF_BPF_CT_OPTS_SZ || opts_len == NF_BPF_CT_OPTS_OLD_SZ))
>>>    		return ERR_PTR(-EINVAL);
>>>
>>>    	if (unlikely(opts->netns_id < BPF_F_CURRENT_NETNS))
>>> @@ -130,7 +135,16 @@ __bpf_nf_ct_alloc_entry(struct net *net, struct bpf_sock_tuple *bpf_tuple,
>>>    			return ERR_PTR(-ENONET);
>>>    	}
>>>
>>> -	ct = nf_conntrack_alloc(net, &nf_ct_zone_dflt, &otuple, &rtuple,
>>> +	if (opts_len == NF_BPF_CT_OPTS_SZ) {
>>> +		if (opts->ct_zone_dir == 0)
>>
>> I don't know the details about the dir in ct_zone, so a question: a 0
>> ct_zone_dir is invalid and can be reused to mean NF_CT_DEFAULT_ZONE_DIR?
> 
> ct_zone_dir is a bitmask that can have two different bits set,
> NF_CT_ZONE_DIR_ORIG (1) and NF_CT_ZONE_DIR_REPL (2).
> 
> The comparison function nf_ct_zone_matches_dir() in nf_conntrack_zones.h
> checks if ct_zone_dir & (1 << ip_conntrack_dir dir). ip_conntrack_dir
> has two possible values IP_CT_DIR_ORIGINAL (0) and IP_CT_DIR_REPLY (1).
> 
> If ct_zone_dir has a value of 0, this makes nf_ct_zone_matches_dir()
> always return false which makes nf_ct_zone_id() always return
> NF_CT_DEFAULT_ZONE_ID instead of the specified ct zone id.
> 
> I chose to override ct_zone_dir here and set NF_CT_DEFAULT_ZONE_DIR (3),
> to make the behaviour more obvious when a user calls the bpf ct helper
> kfuncs while only setting ct_zone_id but not ct_zone_dir.

Ok. make sense.

> 
>>> +			opts->ct_zone_dir = NF_CT_DEFAULT_ZONE_DIR;
>>> +		nf_ct_zone_init(&ct_zone,
>>> +				opts->ct_zone_id, opts->ct_zone_dir, opts->ct_zone_flags);
>>> +	} else {
>>
>> Better enforce "ct_zone_id == 0" also instead of ignoring it.
> 
> Could I ask for clarification here, do you mean changing this
> else statement to:
> 
> +	} else if (opts->ct_zone_id == 0) {
> 
> Or should I be setting opts->ct_zone_id = 0 inside the else block?

Testing non zero inside the else and return error instead of silently ignoring 
it and then use nf_ct_zone_dflt:

	} else {
		if (opts->ct_zone_id)
			/* don't ignore the opts->ct_zone_id */
			return ERR_PTR(-EINVAL);
		
		ct_zone = nf_ct_zone_dflt;
	}


