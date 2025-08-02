Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3454689
	for <netfilter-devel@vger.kernel.org>; Sat,  2 Aug 2025 00:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754092868; cv=none; b=ep8kICBSxMAnGOe1xkt90m1cakjayRqYLfVHmfxCqtPtwvdsM3LqLUuu1mYWphmLFsaaa8/cmE6zXx9xRPzEaUFQGU5yM6M98Dy8kaDFyhTcq0tQsZDspqhe8AoOe+/g6SGzWgM0hTvcB2+DNsqKXkAJDuHraCFEFVecFEYR1YE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754092868; c=relaxed/simple;
	bh=rjzkCq6DmLcQXmc1JxR9f7/G0bzlzmscB1DovrQ81+M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TsonhNANgah3m1IaE9VaJi9EaSnePXwPVFKGQFPo6iOYewDJSmd0G760vDLQKFYNfZGSiI85a2HDpVC+fQwuQjvd/ojuQDzYRO1eD+edGxGL5Ba2mzpUQw69XYeNDWIlmTUrRU1Di/7oJOqjsgL2Tf8O2MmyNXOHi2tcUSmfDMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NlFscboR; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NlFscboR"
Message-ID: <7804bd72-90f5-4bab-a0b9-a0aa282f2610@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754092860;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SWvfk6Pyus5TO52Q9RiPG2DHPnI2HVx/dJWgpFUYw5A=;
	b=NlFscboR4O9KcwQNIsd9/O0GN93A3sJDfI+uvW1K7HLaiLee+cHFoy3o0TYIcxU37F5o/e
	ZGIi+PZRHs0juHL1LhkKN0/ZCof7IoRpyd7MkefaR9kk/kUMIk78dGe4388r/3NkxGyasI
	3g1IA1YIVyETH8dhOrjLoZo2pjZ16Wo=
Date: Fri, 1 Aug 2025 17:00:53 -0700
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH bpf 3/4] bpf: Improve ctx access verifier error message
Content-Language: en-GB
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Paul Chaignon <paul.chaignon@gmail.com>, bpf <bpf@vger.kernel.org>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>,
 Martin KaFai Lau <martin.lau@linux.dev>,
 netfilter-devel <netfilter-devel@vger.kernel.org>,
 Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>, Petar Penkov <ppenkov@google.com>,
 Florian Westphal <fw@strlen.de>
References: <cc1b036be484c99be45eddf48bd78cc6f72839b1.1754039605.git.paul.chaignon@gmail.com>
 <cc94316c30dd76fae4a75a664b61a2dbfe68e205.1754039605.git.paul.chaignon@gmail.com>
 <91bb735f-088e-4346-9b2c-874caf0bc1ce@linux.dev>
 <CAADnVQL-YTbqG1xrdbFBEqsoJWcCKGFnx0sCNSkKJKb9shnXEA@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yonghong Song <yonghong.song@linux.dev>
In-Reply-To: <CAADnVQL-YTbqG1xrdbFBEqsoJWcCKGFnx0sCNSkKJKb9shnXEA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT



On 8/1/25 2:47 PM, Alexei Starovoitov wrote:
> On Fri, Aug 1, 2025 at 9:31 AM Yonghong Song <yonghong.song@linux.dev> wrote:
>>
>>
>> On 8/1/25 2:49 AM, Paul Chaignon wrote:
>>> We've already had two "error during ctx access conversion" warnings
>>> triggered by syzkaller. Let's improve the error message by dumping the
>>> cnt variable so that we can more easily differentiate between the
>>> different error cases.
>>>
>>> Signed-off-by: Paul Chaignon <paul.chaignon@gmail.com>
>>> ---
>>>    kernel/bpf/verifier.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>>> index 399f03e62508..0806295945e4 100644
>>> --- a/kernel/bpf/verifier.c
>>> +++ b/kernel/bpf/verifier.c
>>> @@ -21445,7 +21445,7 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
>>>                                         &target_size);
>>>                if (cnt == 0 || cnt >= INSN_BUF_SIZE ||
>>>                    (ctx_field_size && !target_size)) {
>>> -                     verifier_bug(env, "error during ctx access conversion");
>>> +                     verifier_bug(env, "error during ctx access conversion (%d)", cnt);
>> For the above, users still will not know what '(%d)' mean. So if we want to
> Right, but such verifier_bug reports are mainly for developers,
> and we will know what it's about especially after redundant (1) is fixed.
>
>> provide better verification measure, we should do
>>          if (cnt == 0 || cnt >= INSN_BUF_SIZE) {
>>                  verifier_bug(env, "error during ctx access conversion (insn cnt %d)", cnt);
>>                  return -EFAULT;
>>          } else if (ctx_field_size && !target_size) {
>>                  verifier_bug(env, "error during ctx access conversion (ctx_field_size %d, target_size 0)", ctx_field_size);
>>                  return -EFAULT;
>>          }
> It's nicer, but overkill. As Paul explained if cnt > 0 && < INSN_BUF_SIZE
> it must be ctx_field_size/tager_size issue that
> needs debugging anyway with a proper reproducer.
> So making this particular debug output prettier won't help
> analysis much.

Sure. I am ok with this. Thanks!

[...]
