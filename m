Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81F616F0E4;
	Fri, 16 Aug 2024 10:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723802837; cv=none; b=fjzE/NbRLI3fVzdlSHjHWddPNcdQiSw6xMJWEsoTL4icXV6fzN3hcXvF/0u+vy4KzQkmUPeckOg5PP7x3ElV/+5fpF4IykNDLap5YBWUDiNDH5EBMnahaW14MLeotI7ohGMM9wyZLknRkXO7i4ED5AyVUpD1Z8PhZHBtdbUaJ74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723802837; c=relaxed/simple;
	bh=biAqo7T8SdroVxvylbCUb+F7vc3PGQWYePnn434KC1M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WBgO/sVQYbeaxaPZ2ipVGdl3TBpiyA9+7cgNXc7DNLRVVrIx8dyo95yGc3YyWIKgwxicVsqh57RbW8w+4fq0Pt98LjCjC8qnqnZUFrcUG7aDR88r6OcEeGAbVOWITz585gSxP1stEFg/HsZH4kHEi4MvQcxi4dXqNkUKI8i+lLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-58ef19aa69dso1836777a12.3;
        Fri, 16 Aug 2024 03:07:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723802834; x=1724407634;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4OiQaVPKwoKnMv1TswES28+nB1exXJnUDKgD7tdfBJE=;
        b=FEwwpfaq5znak7Ao0zKTV8wwveIykX/U+m0lhd7on0vOe5VYHIfbhFahhg6sxXZqLD
         aPqAZ6Psujt4YuF2rQvYNgkayul1dii3kV6Vfc6x4yLQ8ATkXID155de4V8eijNTsTHH
         +jpgvPg5uAtf3pS6CQ6ZuePhqR8g0SAn9BaBqQrYg/mXJsqJi+HnVuhALpDQwprpG0DD
         6JwXbNqpdVamFJKUVQ4zTGsyUw21xtKg2S3CEwLDWTu7Wg/npOpeAS4khR5PA0L/f6xO
         utxtgikerXoXFg6jQDq4+RKVzDCyztFH/lDuVbk6PeVHfSk8+BNBp6TaCFNLbKEAHLlI
         EIzQ==
X-Forwarded-Encrypted: i=1; AJvYcCVJKR4Vw7/+A1jgPDpG2dQyrC8mFgXpOFKRXRB2qd68mww4hIGKVNEcFotFZb7eOUuTtWHqyouq+1iMARUBAa+ExnV3pBs3/zkeyd3OjfR0loZIqkx5wwhRTKlZ8Mcg7WcH24ig4iU9
X-Gm-Message-State: AOJu0YzK+a2SWAO3C12MtlEeLz/KP/nsTx9vFVDEP1zRjH5YNxiwqMOe
	6mOd1Qipsg+o8dRoyP/ALXziKVqDH8YjrMrtDMNHMw7P2YLTDvTO
X-Google-Smtp-Source: AGHT+IElti/lbIIocIGoW4NbTzqv/XNAqMxdGvv86M3Gk10TMou0Ylx0EYLycMPe04ltquIip70Jsw==
X-Received: by 2002:a05:6402:321a:b0:58d:81ac:ea90 with SMTP id 4fb4d7f45d1cf-5beca8b29b4mr1452458a12.38.1723802833843;
        Fri, 16 Aug 2024 03:07:13 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::aaaa:69? ([2a0b:e7c0:0:107::aaaa:69])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5bebbdfa6a7sm2047696a12.40.2024.08.16.03.07.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Aug 2024 03:07:13 -0700 (PDT)
Message-ID: <bea26372-5c9d-46f9-ba67-b8ec9b9085d2@kernel.org>
Date: Fri, 16 Aug 2024 12:07:11 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v4 4/4] netfilter: nfnetlink: Handle ACK flags
 for batch messages
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Donald Hunter <donald.hunter@gmail.com>, netdev@vger.kernel.org,
 Jakub Kicinski <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
 Jiri Pirko <jiri@resnulli.us>, Jacob Keller <jacob.e.keller@intel.com>,
 Jozsef Kadlecsik <kadlec@netfilter.org>, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, donald.hunter@redhat.com, mkoutny@suse.cz,
 Michal Kubecek <mkubecek@suse.cz>
References: <20240418104737.77914-1-donald.hunter@gmail.com>
 <20240418104737.77914-5-donald.hunter@gmail.com>
 <3f714aad-43b8-443d-a168-db02cb9453af@kernel.org>
 <Zr8i2cwJtTe76h7F@calendula>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <Zr8i2cwJtTe76h7F@calendula>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 16. 08. 24, 11:58, Pablo Neira Ayuso wrote:
>> See:
>> https://github.com/systemd/systemd/actions/runs/10282472628/job/28454253577?pr=33958#step:12:30
> 
> Fix:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=d1a7b382a9d3f0f3e5a80e0be2991c075fa4f618

Ah, I checked my local -next clone, but had not updated, so I didn't see 
this.

Taking into openSUSE. Hopefully, this gets into stable soon? 6.10.6-rc1 
does not have it yet.

thanks,
-- 
js
suse labs

