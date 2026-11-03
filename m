Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793732194;
	b=0zN2tEcRyEBG9+v5OanPQrMpH0Lq/vJT7qahooIN7Y3oAtebcCh2OeBjavYiq55zBA0s
	 LjWuVlDKpAJGaJz4xn8DmKUv56WQ8zBifJfX8p2+LJL/BTES+Sty1UzHAB+poQRf/5eiJ
	 otv5aXPWyiOhYgny41yx3azn71MrNMpes9yBCsGYemXagVgKMheJCsYjmrLAHO2AIvGcc
	 jQnFxda+skHBcaRiTAUfcPCO/3Few4ykS2NxNQqkGXE1aCF891NbA/CJazSYYAefSB81v
	 TF5TGSyMFvY/Jfs5ajhbov6Nb7wEMXrBU9lL7JeLFEQZgOA90B0jHAlvHv8GDDMTgQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793732194;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=PLO2xwfCocrBevVIKEHkd2tUmUVJORQjvzNZ7fJWYoM=;
	b=dP0W5zuu4Oz7NaGatwKHNSCdZd20DwssxvBodpLq42/F9kpZas/N+YhiUnuIahBNDvUp
	 dL62JD98U3RYt5wHGvjBoi/dM/prljkKHBwJKr+kfXC4e+l7kc3AYMqQ3rbOAyxJnL1g7
	 tbs2f76HC7miBw7M0koR0gW/6BVYFVsxAcsN6pXt82Uw2AawwH8s3qqNgPb8n2THmJhOv
	 yGaTS7w3x/truMtfndmO0XJ+rkevCqQRtlNSMqQmcHex9W5x8o76ifecOJnQA2IH+Jh3a
	 95sb1N600jnoAgke1potwfNrw4CAjNXJnvqNjGzXgZncPU5DQE960r+UeVq0Zu51GwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=n28IUoCz;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60014606A333
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Nov 2026 18:56:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 60014606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=n28IUoCz
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a214c5c4c0so41176755e9.3
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Nov 2026 10:56:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793732193; x=1794336993; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PLO2xwfCocrBevVIKEHkd2tUmUVJORQjvzNZ7fJWYoM=;
        b=n28IUoCztPkOlL+/CXAG4SBObTW9aBGn/U7mFufsMhv/WPJsvUzl/Y6EqWzrh/yGMW
         dYc1WEPIQTohl016wkl+7KVSesl3V4AGRbXYsfN0tYCwm8bz5o6U/URwCHKOX+FIX4T/
         GWlhtg0Q/00gYJvxUKYUM6E4FtU3NVKe9eu7j0f/NURbl1DXRbxXy9ztlVNXEoCbXUx9
         fOZSJJ8pFblx/PPGxTa2J8wGhNZ9s3lyNWlCo+odAyFRAie9E73Xw2s7OvCrHueVWmkO
         8XSVuuU2/Yef8nXN5srjPUpuxNQJnwF4UKGmSVNBoTiiSk5X8Y5fWD19N1i+grIMF9hm
         rRdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793732193; x=1794336993;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PLO2xwfCocrBevVIKEHkd2tUmUVJORQjvzNZ7fJWYoM=;
        b=nnilW+mwWC4MKr4lWlnBrWXQXAv3pw5aCgYG13wIbBaD4mK2STjXD+vNjZGiG2ywnC
         MBieZX8uQf33698hjs7NOiFoJ5BOmTOLwrK1Gc5mE9n/p2UtgmntHs8hEGZqz2j/cuqB
         B4y0snSI0cGO6OJEEKtBw2uUKkNCoqnC0cmHmJJ0GdkTFh+MxjXu6PdUAsXXyqh1RsCM
         uObxHY89heBjE492L1nfny38nKRJckuWGJrXNgxEih22eQN1lghn0+j9b8nP0Fk+u6DZ
         zRERaBjw9eHBc1CTplIZ9opvtEPPBrEo/sVamzFlNJgxyE5S1qRb89FGO5k2nl6iq7P2
         4LxA==
X-Forwarded-Encrypted: i=1; AKwUvBx1YQ3fRgoeESO7wovbOeJ+FjJcw+Dd/AaD0imlqJ2hbvAo3fRcgOg7RoPpnYpSeJQccxYdQ8I/JAw6eHgZVHA=@vger.kernel.org
X-Gm-Message-State: APuU4Z+3frIVaBjttzRAVDKe5KEBU6RkdtHdzF0yWORUx9jlB6VlpvPN
	bZWJm57wZvMkkNxgGXGe5aI3r2XGGM6a7V9XA5XAw0J5Au+kCjlbDz+n
X-Gm-Gg: AYBFou2zCX7Z9dXXEQe1ZtrBBRGNudZ8VTHpIt16u1eDbZ3nOT9N9FOKmPaJDRXObvx
	kt+1fKc6sEbLZCNySDYc/Tt2RIlX8O37knmOSqdjElVh/N5+ejARt8aD6bHeBiQhUhGa8klrTON
	McAfOaFs9MN2GElCJFJHqSvJfzAk1xDeALQ1gv2kNOGemtKgKMZMfJ5h1dDe9jzH6d0Q0LFfKqF
	RxNCS1tTkMebmVahk2B6ZyVfsSxMlshS5bxM4hYtFMCmzT727ScJOr4IlJN/XELuBA3tXs7dyA4
	jzqi5FVT1nPLpYf3AO3JCo9u9mWB5LnKHgxe2fxpD1ezvMbe5D1bj9LuzFG4FruloSbDRxpj5Fl
	Xqit7ZNLzHPdrKvYniGsEstnXxoSW3RCPjr5N0zduHw+3BzxyT2aOE2Q7ogXAa0c7sSN8ynG1un
	Mdanp1Z88iVaPCo1FLw4nlDhQ6zozogkK8FvWqeIwn2n6r/oyPUhR/uWPdYkdj/w65KqTo7o5a1
	ZUJfAOwo1rYJLi35i+Dt3PkslbHtHCfLmYboQz4fvBh3kSjF5S0nqUXnAOHLNzkZpTts3mw6uG7
	p02B+GX4RV7068CQRICd1f66IYI3xrKTG8chkSZnLD7h5OwApzLpxIbO3SZLB8TuXQmAz94MjvN
	XV3aPzpzCeKJn0UczkwLLHUNQ
X-Received: by 2002:a05:600c:628d:b0:4a1:e01e:1927 with SMTP id 5b1f17b1804b1-4ac17d16a1bmr319846245e9.5.1793732192587;
        Tue, 03 Nov 2026 10:56:32 -0800 (PST)
Received: from ?IPV6:2a12:26c0:4402:6300:8cdc:cc88:9490:1614? ([2a12:26c0:4402:6300:8cdc:cc88:9490:1614])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b2a9bd5d9fsm76736105e9.15.2026.11.03.10.56.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 10:56:31 -0800 (PST)
Message-ID: <f909ccfb-0bad-4ad2-a5d7-d836f4bbc958@gmail.com>
Date: Tue, 3 Nov 2026 18:56:30 +0000
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf] netfilter: flowtable: do not clear the offload bit
 twice
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Sven Auhagen <sven.auhagen@voleatech.de>,
 Oz Shlomo <ozsh@nvidia.com>, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261103-flowtable-offload-bit-v1-1-20f5952c00a1@gmail.com>
 <aunoySCHzqwI1QIz@chamomile>
Content-Language: en-US, pt-PT
From: =?UTF-8?Q?Jo=C3=A3o_Silva?= <jgc3silva@gmail.com>
In-Reply-To: <aunoySCHzqwI1QIz@chamomile>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

The fix was LLM generated but I wouldn't say it's just "for correctness".
For some context, this issue was hit while developing hardware-offloaded 
flows for the RTL930x target in openwrt. There was a point in 
development where this was causing flows to pile up and eventually 
exhaust the TCAM of the PIE engine on the switch.

Thanks for considering.

João Silva


On 03/11/26 13:59, Pablo Neira Ayuso wrote:
> On Tue, Nov 03, 2026 at 09:52:56AM +0000, João Silva via B4 Relay wrote:
>> From: João Silva <jgc3silva@gmail.com>
>>
>> An expired hardware flow remains in the flowtable until its asynchronous
>> hardware deletion completes. Teardown clears IPS_OFFLOAD_BIT, so a packet
>> can create a replacement flow referencing the same conntrack entry while
>> the old flow is still waiting for deletion.
>>
>> The next GC pass calls flow_offload_teardown() on the expired old flow
>> again, clearing the replacement's offload bit. More packets can then
>> create additional flows for the same conntrack entry. A pending hardware
>> work item can also delay deletion and expose the same repeated teardown.
>>
>> Commit d2d31ea8cd80 ("netfilter: conntrack: fix erronous removal of
>> offload bit") closed this window for software flows by unlinking them in
>> the same GC pass and made the conntrack state fixup one-shot, but
>> hardware flows stay linked until NF_FLOW_HW_DEAD is set.
>>
>> Make clearing IPS_OFFLOAD_BIT part of the existing one-time teardown
>> transition, alongside the conntrack state fixup. Subsequent teardown calls
>> must not alter the offload state now owned by a replacement flow.
> Let's better target nf-next for this, this looks like LLM triggered
> for correctness.
>
> Thanks.
>
>> Fixes: e5eaac2beb54 ("netfilter: flowtable: fix TCP flow teardown")
>> Signed-off-by: João Silva <jgc3silva@gmail.com>
>> ---
>>   net/netfilter/nf_flow_table_core.c | 6 ++++--
>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
>> index 0d72dc8ae47a..709b55b74cc7 100644
>> --- a/net/netfilter/nf_flow_table_core.c
>> +++ b/net/netfilter/nf_flow_table_core.c
>> @@ -398,9 +398,11 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
>>   
>>   void flow_offload_teardown(struct flow_offload *flow)
>>   {
>> +	if (test_and_set_bit(NF_FLOW_TEARDOWN, &flow->flags))
>> +		return;
>> +
>>   	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
>> -	if (!test_and_set_bit(NF_FLOW_TEARDOWN, &flow->flags))
>> -		flow_offload_fixup_ct(flow);
>> +	flow_offload_fixup_ct(flow);
>>   }
>>   EXPORT_SYMBOL_GPL(flow_offload_teardown);
>>   
>>
>> ---
>> base-commit: 734bef548a96e8774d6eef5dfa2026c6edc4e80b
>> change-id: 20261103-flowtable-offload-bit-f15bfd1d38ed
>>
>> Best regards,
>> -- 
>> João Silva <jgc3silva@gmail.com>
>>
>>

