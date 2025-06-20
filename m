Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA99A25F98E
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Jun 2025 16:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750436414; cv=none; b=ANSjBK0iMUDVQODgsRHiNTRsPmBySY/OkwxY4y4AsJ8rH2/i56vg4M5GdBZFOLiuaYhqnNSscxHcVQ0dzVaDISytxfS8xidFDaLtEkHVmtPvS2vAefPS24ifhpdJzOiA0tH4JWEdMk1BK9N2bVt/H5pTF0kYbkOtZO1s9jvwNMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750436414; c=relaxed/simple;
	bh=HYTOWjDukRZ7ZHMgKqBNidaHm/7rDrH6ltFndm5/Ihw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qv5RrnlSoDS0ye01HMjIJWC7XCA1WyDi5FocnV4zpZ1NdhLGSd1mhm5HyvDwINuZ4ca7+DuosGWl5L8mhddd00ek/AoQ9th7mhr8vGvv/z2Y031osPcF9y9O5/AZd9LlsrcImoIUvX7D9rhwFU2hZ8fxuJlJdiHd+yMn2K3oL8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=6wind.com; spf=pass smtp.mailfrom=6wind.com; dkim=pass (2048-bit key) header.d=6wind.com header.i=@6wind.com header.b=U/oWL/C8; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=6wind.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=6wind.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=6wind.com header.i=@6wind.com header.b="U/oWL/C8"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3a4eed70f24so321495f8f.0
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Jun 2025 09:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google; t=1750436410; x=1751041210; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :from:references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=NXttrKxk2yS2jYMSNejp1cO8JOMwcunJDEmJOmX01c0=;
        b=U/oWL/C8bFbaZLtCilyhwAR7bWSQUhENpYQF3XRmkDDRRUuw0lJ0gHkAXx9FSTJUU3
         GtjBTiq4wxqQY7iCEhKkHh9sMHPcZ0JrufWCH4PiJXhJ0EZ3UirFj1HjZq3VkbB4yvuh
         Li8ZHgbIEi/I26ZdL7779ftTJsLOORTfe5Hbz4xbFVxWPsYEjv8/+VoiHnAH3HwF72Hg
         g9Fu3J1LdaPBUuKkMzbl1ck8GrB7c96T53CqxB1HTjaYeUbTzCCxU5rpRyIzrkLzNIi0
         cXU3PtNmgQepYldUgf5v0L6RO16ijWESdawAxJcBRR9W2Csq0P4ty+DwHuo8HCGgGWY9
         rHqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750436410; x=1751041210;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :from:references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NXttrKxk2yS2jYMSNejp1cO8JOMwcunJDEmJOmX01c0=;
        b=EKx11KlaOV+ZMe/VFBiwfXfuQ4pAPAmiaa1U4uY9mxmiarRPjv9vVNzQVrwkmBOLM9
         jM/5vLKHGR/aRdYS8CIAqxPLKnuz66BR2f4pmrG/CinLcueI8nnrF4m1F9BMzadl22Qz
         bgaQ1jzXnQcKtC+XQfdFH4u2MkT+Lm06pWkD6ZERWuKrXP4QW51lVc69eQbBFDIWbRZp
         HSd/Hz0/B5rq0Nd12dwR0D8XqUgWcGcWMHTnV63wf6lS6ow2aT2wSrvwJjZfCUTa7tLN
         0OV4A0XYhWK1XiJrOLXIxZi3K6mTfE03p+hVYqH3j+xRyU0jOpp5y6Ooy3HN31Vcz7eg
         PXcg==
X-Gm-Message-State: AOJu0Yx3AyN256bStiXLCObGqB0mY58BbGUEecu6tbfSf/PgORYcLKXz
	V/2wFcOaXskL3vFYVIzeeqI8DqR+EyC2rFJUC4g2koLAjWg4feRvQreliW1shicfl2c=
X-Gm-Gg: ASbGnctTZfdX+45og5mVuXKnkqOMPQH18+wM/q0F0HIgoXszs7W5QaXHMd9j3T1UKe/
	iLoXNhl7fcXK0TObVR5/66EyIcqGEnl1PRuS60w9FzB5Yw3Zr9inW/hedKh1zWrq8fyfALptIny
	SbgZRWe0tYEQgKKdysjISqPfH8nrertJbX4LoQsKHoqHOFKvVqaM+2k4G3NsiJqk7n4kl/BQQea
	DqgTL8k+n6UOA4Ee8OPYkMxVeCfcFqEBIK0fwJdHdNYLTshhwblsfXCiarq48Ln1SkSXu9zXAQ7
	byyEYkVLe4VrZucFSvlA1TExYRvjtwuLpMCV5LzqEn7LVJPpw+Qv3/1qiKeXm+XcW7kqNklJZIH
	s9CQYCPh/8/IFnw9QPCmLSTcHaf1+QMymq/7I
X-Google-Smtp-Source: AGHT+IGkowJ8P5bwuL7sCxZqqQhRiSiWE7pYlaRQ/m3YEL+PQGhAmp5M2JGhffVe+AMarzUPpEXkKQ==
X-Received: by 2002:a05:600c:3143:b0:439:9c0e:36e6 with SMTP id 5b1f17b1804b1-453658bac2cmr14871855e9.3.1750436410004;
        Fri, 20 Jun 2025 09:20:10 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:607e:36cd:ae85:b10? ([2a01:e0a:b41:c160:607e:36cd:ae85:b10])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-453646cb672sm30442825e9.6.2025.06.20.09.20.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Jun 2025 09:20:09 -0700 (PDT)
Message-ID: <ed8f88e7-103a-403b-83ed-c40153e9bef0@6wind.com>
Date: Fri, 20 Jun 2025 18:20:08 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: When routed to VRF, NF _output_ hook is run unexpectedly
To: Eugene Crosser <crosser@average.org>, netdev@vger.kernel.org
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
 David Ahern <dsahern@kernel.org>, Florian Westphal <fw@strlen.de>,
 Pablo Neira Ayuso <pablo@netfilter.org>
References: <f55f7161-7ddc-46d1-844e-0f6e92b06dda@average.org>
 <2211ec87-b794-4d74-9d3d-0c54f166efde@6wind.com>
 <7a4c2457-0eb5-43bc-9fb0-400a7ce045f2@average.org>
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Content-Language: en-US
Organization: 6WIND
In-Reply-To: <7a4c2457-0eb5-43bc-9fb0-400a7ce045f2@average.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Le 20/06/2025 à 18:04, Eugene Crosser a écrit :
> Thanks Nicolas,
> 
> On 20/06/2025 16:56, Nicolas Dichtel wrote:
> 
>>> It is possible, and very useful, to implement "two-stage routing" by
>>> installing a route that points to a VRF device:
>>>
>>>     ip link add vrfNNN type vrf table NNN
>>>     ...
>>>     ip route add xxxxx/yy dev vrfNNN
>>>
>>> however this causes surprising behaviour with relation to netfilter
>>> hooks. Namely, packets taking such path traverse _output_ nftables
>>> chain, with conntracking information reset. So, for example, even
>>> when "notrack" has been set in the prerouting chain, conntrack entries
>>> will still be created. Script attached below demonstrates this behaviour.
>> You can have a look to this commit to better understand this:
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8c9c296adfae9
> 
> I've seen this commit.
> My point is that the packets are _not locally generated_ in this case,
> so it seems wrong to pass them to the _output_ hook, doesn't it?
They are, from the POV of the vrf. The first route sends packets to the vrf
device, which acts like a loopback.


Regards,
Nicolas
