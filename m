Received: from mail-ed1-f67.google.com (mail-ed1-f67.google.com [209.85.208.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1D24218BD
	for <netfilter-devel@vger.kernel.org>; Tue,  5 May 2026 11:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777978888; cv=none; b=f3hS2f2ZHIufyO/lEgkXHs85aKtZqZsZaboUlEZmZOnRQDIYExMs3I/TLgxk/3wl3gb6ULpYa3S+ybXrA+y7B54lpzKRaV8QNtzu+P4dJJ89Gm78bS2I4vc4t2Dl39kxVpsvDeCKQVV5mLB4CAK5LTbhmjHuLKkPUGh67dr1D6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777978888; c=relaxed/simple;
	bh=4N1YT3iSFCxvJQ1DuuuZveWCkqLKVXrBB4j6/ijkuFw=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Hm0R6QrWbX42aKxLtWcfXGKyzltAc2VVn1YRXcKBSij7Qnjvhn3iVlMe8EFulVL/4QWWEGuHW58T8Gqjmykd0wykNThq2FnE0C+zR5q6OAxXbL7SArCpp+wTEmuShX9v+U6UQHIM1oDkGwwzYn7N2oDQozskbHbJwxtdrUeNlw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ovn.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ovn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f67.google.com with SMTP id 4fb4d7f45d1cf-67b8d9c26bbso6898501a12.2
        for <netfilter-devel@vger.kernel.org>; Tue, 05 May 2026 04:01:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777978885; x=1778583685;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:cc:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W/+4JVLEopn+EOqTkHHwu2qSAR1YvdVY7AK9mw+2P7k=;
        b=l1gnSl3GiprOpklkcU+v1J9IUCuMwrq8DrWZEhYN5Q17402bhAhhY0pVB+RF1Gc/RU
         BzVWX200RIRO4JZ+ljJc8wsBn0w1XAWWVNO2JZjRYTEchrNBhLpWkNpAmspc3s/BwHg4
         MCMHVVPp8cFONvyBdez/TeVHU+L7loOrvK3YROpc/2xI+IMURuIBjipeMc/bFK9cyeIT
         oI7TXA4FWvyJxH9QOTAmHm44JUluVzWz0UYcc+CRRjLMObfBtuAKXjSP+BFzekxcQ2oE
         Q64nWLkMGjuqKT7x1kNV08yocZ2c/ho8JNviNcSxxGlWx5Cn/eY/ufbmDk2M68jHxi2z
         KAmw==
X-Forwarded-Encrypted: i=1; AFNElJ+gcxsXCkdDYO22+huWYbIzyf7zXtzChyP8tX/jbQYb9hZm0LWfEuC8niAI/CjaMVh2v+Wae55dCAHtX0mZXbs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7BWHmKyr3ZNku6M79KFxxpU0O/nbhdkKV0vrFKg+I+hNZMyFb
	ffhJ1JGsCDe/7T1UKZLe+CSr5//ip9TabRRmEKslMU84ewRa0v1atD18
X-Gm-Gg: AeBDiesMi/aDCThCt1eW0DmI30fO34FQmHPFs6XcXiutsAzD7ZQXcHX8fqRcGzNK005
	stnZVw4kpoBkbnEU2fPArFjYlHL+btTS3+X47FC2jegW07DCZDdfjOLRSAEIcz6XHzAxmnfBCt9
	sks2XoY9X6zZo4brsezS/RIR7P4NqCntPBJDeHHgt15Z1s3zosr40nG5rk4qwcGaPgwrBJvEi67
	6rJvU08oRdHdg0CDicC7huWP0/NdWMDMHT+uQD9xnDzHtomQASn/yzBsWNtglQ7dQFI1P3UfPUF
	ugCa06njQ+Q4PNjqcGQXEGAJgL0CRexeDPo1Ra9y/bTLcSf5+shx1/PratCPhDgUB0EbX6rUzzM
	AXJkBpfoTzTcmPZyVggxeWr2AVSfQVBr4v29tSpDKYdDSwcYBCPfonVPM6BH930N0If5GTvbYsU
	35WsQ/LUy9ZoKtsVhYTaXTMlY6MDYXAr6GWc4+6iwvTrG5/8XDGIr46+k51MQvCTehdAkZNijKM
	CZj
X-Received: by 2002:a17:907:a01:b0:ba7:670b:f074 with SMTP id a640c23a62f3a-bbffa02ca02mr768977366b.2.1777978885143;
        Tue, 05 May 2026 04:01:25 -0700 (PDT)
Received: from [192.168.88.241] (37-48-40-237.nat.epc.tmcz.cz. [37.48.40.237])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bbe6d66c90dsm483751466b.43.2026.05.05.04.01.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2026 04:01:23 -0700 (PDT)
Message-ID: <f0557cdd-738b-4d19-969d-94310b553d0b@ovn.org>
Date: Tue, 5 May 2026 13:01:22 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: i.maximets@ovn.org, netfilter-devel@vger.kernel.org, fw@strlen.de,
 davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
 pabeni@redhat.com, edumazet@google.com, horms@kernel.org,
 Eelco Chaudron <echaudro@redhat.com>, Aaron Conole <aconole@redhat.com>
Subject: Re: [PATCH net 06/12] netfilter: nf_conntrack_expect: honor
 expectation helper field
To: Pablo Neira Ayuso <pablo@netfilter.org>
References: <20260326125153.685915-1-pablo@netfilter.org>
 <20260326125153.685915-7-pablo@netfilter.org>
 <8fd5d3a3-d1d7-4542-a0db-1678989940d4@ovn.org> <afSCXEg-X-ieL9cY@chamomile>
 <ef01005e-d867-4936-b138-b98f37e5f394@ovn.org> <afkosr2fDEPA_jX9@chamomile>
 <afkuhbWieFXRTirN@chamomile>
Content-Language: en-US
From: Ilya Maximets <i.maximets@ovn.org>
Autocrypt: addr=i.maximets@ovn.org; keydata=
 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
In-Reply-To: <afkuhbWieFXRTirN@chamomile>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/5/26 1:40 AM, Pablo Neira Ayuso wrote:
> On Tue, May 05, 2026 at 01:16:05AM +0200, Pablo Neira Ayuso wrote:
>> Thanks for the detailed report. It seems I changed the semantics of
>> exp->helper, this used to be use to set a new helper for an expected
>> connection, which is the case for sip and h323.
>>
>> Would this patch help address the issue you are observing?
> 
> Actually, this needs to set to NULL the new exp->assign_helper field,
> see new patch, untested.

I ran this through OVS system tests and all passed.  So, this restores
the old behavior, at least for FTP (we do not support sip/h323).  For
that part:

Tested-by: Ilya Maximets <i.maximets@ovn.org>
