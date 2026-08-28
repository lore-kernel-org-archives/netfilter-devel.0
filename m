Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F0B540F734
	for <netfilter-devel@vger.kernel.org>; Fri, 28 Aug 2026 10:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787912371; cv=none; b=lg5ngLQW9+Q/VwwBlNhDQhKpfG2ZxfKMJbbuX1ZFHm6YB2AFcUOMktbsE6uO0i8uuvcEJILmmfyvjKp1x43vCdtmQ8zwivNISCTkFUsS9iw7umpFcwOXzl4BEcLCo/rBJI7vZFOiJPCwPIZtA5CCIXea4+8k89OCZ3qfpuM6XUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787912371; c=relaxed/simple;
	bh=poaEQLXngwkj4ZVH0XYTEle5qKOKOqr8YA6nXQc3/c0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=tviXF3DQMY3bgXfxKkGQQ5s3+u/rSg4mZlD9VuBYNZrtsdM/QDsEjlTOisl63WaewqIjU6Fm49dt7iFWn/+Gj5ytO/NrtYpCEj42b6TEPWVI9ICmOsKPcOBe4+8LELXoRlCCVyxXVgH53RfwFUszTVD8dUJ65wfosZZdwG8NCDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=blackwall.org; spf=none smtp.mailfrom=blackwall.org; dkim=pass (2048-bit key) header.d=blackwall.org header.i=@blackwall.org header.b=klfgmmBt; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=blackwall.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=blackwall.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=blackwall.org header.i=@blackwall.org header.b="klfgmmBt"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-499ac87c92bso6924225e9.1
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Aug 2026 03:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall.org; s=google; t=1787912368; x=1788517168; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=oEWt45vodLvRlM58BDpgvWT4gNSU+vy10S0wY3Bn1lw=;
        b=klfgmmBt1PG966x7WeLE1tNaz7xebH7VhuOk0OyasHd6vcEAFgOIOyEmzeulstwu8A
         B+2D92+baSnRzBAntKj3p9VCHZ4uTzyjhXr7f9E4PIbtw/qpjmO+axJkppMnpgXuLLR/
         rvYgRhlblK1U1BsLL3gvZmG+Hklzp4bfPutGRr6zcvrixevJ+O8KKKY/HwcCazZKJeYx
         CvF/Mf0BKqI78MGQaRzZmAPciPNVCF69lOydu2B+ZwcbCyrX4YN27ic6UZk7NgMxOqLg
         IpsgME2WQP1BR0uT48EXbjbjJjC/xEFsYqsfLVduzcW+IoOph9E8m0cFDAnvHjV2yjwD
         KEIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787912368; x=1788517168;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=oEWt45vodLvRlM58BDpgvWT4gNSU+vy10S0wY3Bn1lw=;
        b=e69kKfP6ahOgOn6Ay3U0TfLmmFAUhJHfk0iEYIhAX2ORjyp/tkvB467hP/DxlOgYTa
         tDhpCTLqTHVxXsSTwjgEIBTetdSHzdOtyJEsVGvv7VjrEJNOdsWrSe0Puo4CJvCvj/Qq
         AJRjFBaKpI9hwcNdF3VpLjseUmzmaMLd4pagqF4q4GHvYolsA6SeYW0ccNQBuQ7wJ4HA
         Ub2KOz9Xw2Z2BKuPVtkThNs91Eyy6N+5QU6MqHFuOqVhVd+vei4G8hFrt2uSNYYHDtsa
         B7NSMoEejcEaedzsVnrfYlF8mBwCvEyiEwb9g7+V+gDqxUNiOlG8WbGjUBhwV4SGbFjc
         kbIg==
X-Forwarded-Encrypted: i=1; AHgh+Rr7l6W4u3JCHGUIVTY7wRY9HywsEWeTkUF4t7fHtoWaBSmKr4c1TnEq5E6QWFm41UctJuaNdJszc3CEXkWznjU=@vger.kernel.org
X-Gm-Message-State: AFuF++k5B11Z/seGLFcckWlwugRFgndkrIWmxTmBEaWTlKASbak585nG
	/skkA2UJsAtpVQU3t1IjAnYiW5O048KeYrrNES0UdPO0lSPj+s1YnthD0Io8jaCtg5ygQ2bV2Zk
	OzVuN7do=
X-Gm-Gg: AR+sD134NuiXHtN6k1vPVtiKXhi/US6mqVPVUMtwe39Pz1WD6Sbl2rRfuXxY9wDb/gf
	D3JPoNFPiRLxeKY2NnoSTcp33gnzL5NGO/7tVmNwXKXgy4PVXPJsn6cXUcb6V8OBVmxNI4NxutS
	aTFNyhl4UrzTH+nTIbb9zP5NGb1mS1AuH0JIYt7sGfAF+P7mts9RDZunQ0UslDph+5Jeei1ab8W
	2c0B71QxmFao4Wtm97FCvXNCqeU3eAr2LWqSqk9AaPmW6JsOgvNtHclvAja/HvGSqLJFKr6J4F5
	ya1rLfZR+FDkFMm60VwEH5lVaJaOsanjwp3zrQwWUwN8v+zpmp40OeKWFi8xG29ojb0kAtNuCd9
	PaWGfN4HMXI97BmDTO2CBxtWpNJ1Zdy1V1HY3jwmzudrK89lJBrq+DF1mcc+R3xRd0r3zQ3TSZg
	RBQbQwmWV0wINIWgjmNhESAMH0433C3f7NAUymulbUTp1lvt3R8hazBNwCEeefS6Buc7ZfPaYNW
	wqrwfhqwx4SQ891w6Y=
X-Received: by 2002:a05:600c:3103:b0:499:be2d:c290 with SMTP id 5b1f17b1804b1-49b91c4fa9amr80720665e9.9.1787912367884;
        Fri, 28 Aug 2026 03:19:27 -0700 (PDT)
Received: from [192.168.0.161] (78-154-15-182.ip.btc-net.bg. [78.154.15.182])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b94dcaf61sm38823535e9.4.2026.08.28.03.19.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Aug 2026 03:19:27 -0700 (PDT)
Message-ID: <347de812-4502-4f40-9d8e-028ec8ea35c1@blackwall.org>
Date: Fri, 28 Aug 2026 13:19:26 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 nf] netfilter: disable br_netfilter in user namespaces
Content-Language: en-US, bg
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20260827181431.21720-1-fw@strlen.de>
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20260827181431.21720-1-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 27/08/2026 21:14, Florian Westphal wrote:
> br_netfilter has way too many bugs, schedule for removal and disable
> the feature in user namespaces.
> 
> In particular, we get more and more gadgets to have bridge ports escape
> rcu_read_lock() protection, then underlying device gets reconfigured
> (macvlan or something else), then reinject into network stack causes
> crash because net_device is assumed to still have bridge rx data
> associated with it.
> 
> br_netfilter is an ancient kludge that emulates ip stack from within the
> bridge and then calls into ipv4/ipv6 netfilter hooks to have bridged
> frames processed via iptables/ip6tables by setting the 'call-iptables'
> sysctls to 1. It is NOT related to ebtables or nftables 'bridge' family
> at all.
> 
> Note that in addition to call-iptables, sysctls, the bridge itself exposes
> call-iptables per port via netlink and sysfs ('BROPT_NF_CALL_IPTABLES')
> toggles.
> 
> Those are still available, the brnet structure is scoped to br_netfilter;
> exposing it bridge-wide is a big no-no.
> 
> This relies on brnf_device_event() no longer registering the base
> br_netfilter hooks, so while BROPT_NF_CALL_IPTABLES can be set, it
> has no effect because the hooks that evaluate this feature bit
> are never registered.
> 
> brnf_init_net can no longer depend on CONFIG_SYSCTL, else such builds
> never disable support in user namespaces.
> 
> v2: avoid silly UaF, compilers are too forgiving...
> 
> Cc: Nikolay Aleksandrov<razor@blackwall.org>
> Signed-off-by: Florian Westphal<fw@strlen.de>
> ---
>   net/bridge/br_netfilter_hooks.c | 33 +++++++++++++++++++++++----------
>   1 file changed, 23 insertions(+), 10 deletions(-)
> 

The patch looks good, thanks!
2 minor nits:
BROPT_NF_CALL_IPTABLES is per bridge, not per port. Also please update the
Netfilter section of Documentation/networking/bridge.rst that it won't work
in non-init ns and is scheduled for removal.

Cheers,
  Nik


