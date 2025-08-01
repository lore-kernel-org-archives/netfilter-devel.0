Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7FC18D
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Aug 2025 16:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754065862; cv=none; b=kHy+cVgtuaUe4qOTFrYiroga/1892lD71l1BziTawZMfXapGGYxuQXHIHEX9TCs5ZGYgg3ix2AO6UGWCIP/4PfFxRuotqMWyVFRcdvFB3NT/ZxTwZj239b4M51cYyY1/QLULFwKoGeywJTdbxa7dUHRNXno7QUAIrhqD6Thok8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754065862; c=relaxed/simple;
	bh=T4bYieFv5LfO/IRqc2qPhkIXqxlkNfCdNHoPR1nTXhg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ivTa3MALGwnsOEt8KH5EuYd0NqGybhRJ3XOO/AzZR+xfYDFNSMPglhUeaalL8rPj04yXra6o+rmwtRD0w+EuhoNQ/c95JTeOXfwq7s8gQPycH4aJnAlnidqZ/7SoRex4KVHHk0rKXACBo8MYPM0cTj8AD6Xa5/9YmcA7vNQ7k6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dKQcL7n6; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dKQcL7n6"
Message-ID: <91bb735f-088e-4346-9b2c-874caf0bc1ce@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754065858;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8XgNhwo+yL6OA0es4MKVJbLgKNyAaHpC3XsdhEhMZkc=;
	b=dKQcL7n6sN/Z+GRvJkR4hsxneyuCTSKWVV6wokYbOwUpGLoKSB1c37iXpdJLfKpyTEG5Kr
	4bSSR+FaO2hWkdmR3GSVfCehZnFc2UXGtA8pTtpgLBe3MyUW40c8MM2k/dCcsU3jBxRELM
	Xt9++LmqSdkwpRyZks+bHjdjMTVjoSs=
Date: Fri, 1 Aug 2025 09:30:53 -0700
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH bpf 3/4] bpf: Improve ctx access verifier error message
Content-Language: en-GB
To: Paul Chaignon <paul.chaignon@gmail.com>, bpf@vger.kernel.org
Cc: Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Eduard Zingerman <eddyz87@gmail.com>, Martin KaFai Lau
 <martin.lau@linux.dev>, netfilter-devel@vger.kernel.org,
 Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>, Petar Penkov <ppenkov@google.com>,
 Florian Westphal <fw@strlen.de>
References: <cc1b036be484c99be45eddf48bd78cc6f72839b1.1754039605.git.paul.chaignon@gmail.com>
 <cc94316c30dd76fae4a75a664b61a2dbfe68e205.1754039605.git.paul.chaignon@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yonghong Song <yonghong.song@linux.dev>
In-Reply-To: <cc94316c30dd76fae4a75a664b61a2dbfe68e205.1754039605.git.paul.chaignon@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 8/1/25 2:49 AM, Paul Chaignon wrote:
> We've already had two "error during ctx access conversion" warnings
> triggered by syzkaller. Let's improve the error message by dumping the
> cnt variable so that we can more easily differentiate between the
> different error cases.
>
> Signed-off-by: Paul Chaignon <paul.chaignon@gmail.com>
> ---
>   kernel/bpf/verifier.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 399f03e62508..0806295945e4 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -21445,7 +21445,7 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
>   					 &target_size);
>   		if (cnt == 0 || cnt >= INSN_BUF_SIZE ||
>   		    (ctx_field_size && !target_size)) {
> -			verifier_bug(env, "error during ctx access conversion");
> +			verifier_bug(env, "error during ctx access conversion (%d)", cnt);

For the above, users still will not know what '(%d)' mean. So if we want to
provide better verification measure, we should do
	if (cnt == 0 || cnt >= INSN_BUF_SIZE) {
		verifier_bug(env, "error during ctx access conversion (insn cnt %d)", cnt);
		return -EFAULT;
	} else if (ctx_field_size && !target_size) {
		verifier_bug(env, "error during ctx access conversion (ctx_field_size %d, target_size 0)", ctx_field_size);
		return -EFAULT;
	}

Another thing. The current log message is:
	verifier bug: error during ctx access conversion (0)(1)

The '(0)' corresponds to insn cnt. The same one is due to the following:

#define verifier_bug_if(cond, env, fmt, args...)                                                \
         ({                                                                                      \
                 bool __cond = (cond);                                                           \
                 if (unlikely(__cond)) {                                                         \
                         BPF_WARN_ONCE(1, "verifier bug: " fmt "(" #cond ")\n", ##args);         \
                         bpf_log(&env->log, "verifier bug: " fmt "(" #cond ")\n", ##args);       \
                 }                                                                               \
                 (__cond);                                                                       \
         })
#define verifier_bug(env, fmt, args...) verifier_bug_if(1, env, fmt, ##args)

Based on the above, the error message '(1)' is always there, esp. for verifier_bug(...) case?
Does this make sense?

>   			return -EFAULT;
>   		}
>   

