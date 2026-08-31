Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B731C46E01D
	for <netfilter-devel@vger.kernel.org>; Mon, 31 Aug 2026 15:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788190017; cv=none; b=aHoF8stSYDm+9LD62zZ7iACjUeX46ZkagNK4CDgDpJAWltMprY/9rqkchjofm8D6swjwN7bDMdQTJdk2qB64DpuRoJa7x8LLAQgAI+lnxZ/1GoWhBeSur36qoV2ir36uG5Dp89X1IjiKWl7m0Ga2HwW6IUquIgCINgL4oXpYEqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788190017; c=relaxed/simple;
	bh=PlduqlHylvX2cFED4bmB+oZzZxljdLxbXB2+0aV0xfk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=uchhGjPtCtaIxzAYMRm1RIQ0Syx3aWjFQxPHSJ4SgH29+3u3j08AEBHKy0pc53/duzLKol+WnzmYHYeilwl1EtzTC4u9xtRTCseJchfA3gkxYOLZK4JWZ+rsJUH4k+2MOvqsoAW8zWZtgB3Qi0FVDffZRQWjd4ZBD950jX3uGBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=blackwall.org; spf=none smtp.mailfrom=blackwall.org; dkim=pass (2048-bit key) header.d=blackwall.org header.i=@blackwall.org header.b=FYSqkp0G; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=blackwall.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=blackwall.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=blackwall.org header.i=@blackwall.org header.b="FYSqkp0G"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-482e5733a5aso2155595f8f.0
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Aug 2026 08:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall.org; s=google; t=1788190014; x=1788794814; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=HdFM3tsPKHZYenvGmNrHLo5fG882GDMeQBbjIIV3meQ=;
        b=FYSqkp0GT0uJyukkEsDq0V1F5jCbHnG/4Kd48SHxfk19ZSwY6kUy5IxYeqZKzmfwqM
         lNDnZnVaOrfKaFRIaHiNslsBKxF0R7CBuj7idHfjCANSspyNGsXYQspejcgZotO42FX0
         ZCuS1F5aZpn8+vhcDA/qIL0IQcRsV/0ltPPPjyMMWfD9ImKgH3cNgj2vcs3KDfT/5ERv
         oXg+7OtKVO++rcdpSipMC1Oi+F7WhSu0K4lTaETq3vNd4KZaZKR0Wg9atFL2BfOSV+Au
         /E1x+vbP18izYGnYviV31HKNxXJvRxmuGuWOcajMnXvfcOyLxrj8x0qdIAFJMNXlGqew
         5Axw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788190014; x=1788794814;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=HdFM3tsPKHZYenvGmNrHLo5fG882GDMeQBbjIIV3meQ=;
        b=PbUhtSyLhxM39nw9FnPSyBFHq1zZmFjzSKyOuCZDVacn3yFMY5AIk4P/kvNN/yHnJp
         zVwnDRP238zekTuEvRFAh1ZfNEG/2XOppWemXT+MLafjyOsstKpBX5siXWIoN2rj3bDq
         GSiQIMw/BnUzGWiqwSg4elyjy+u5hk3hkXUjElcncw/a2iU5ZSsX8et74vWrux1tkft6
         LYHJgevB5+th5SBqlX9hmUkeoOqGREndGux90NotaJ+ZgcGLoXqbM2xvYFbNUBnJqtTr
         sZgI+fJKbiLaODRn6eAc5BvbW2VV52btbD4lBrOeLmf2XZl2csxUZxNS5d+Di+n8dZNy
         M5Gg==
X-Forwarded-Encrypted: i=1; AKwUvBzAuGkzi66/oYXgAmhqXtMYce8U8M4oq8qxbmE6eaaXNRZEVvTIkb60Ir8zIwyyxp4GFGZnzgpBOxuubPK304A=@vger.kernel.org
X-Gm-Message-State: AFuF++ksWPbjystAdXuWFdLPO1m6A7qzGbYQshVLAqtx2mWOWD1D/Q5L
	v4+lOCv7CT7+po9+wSjpyWzAqg4tHWFfvaM4vAeLCcFXXEACtBKvVOW6VwnaYt2rqW8=
X-Gm-Gg: AYBFou3b0ZudPgBZY5Jbb55ZasBWMdbUEdUVAg36Ej+EA1vQ5KmSJu+FUq8/+oWTuAu
	zHr69zUHjmU67Oc8s1T5WOwEvbnYmUDeD7RJ0fbV0JBjZFuAzQi65IqgU1vInIuM9TgkZ+JmozR
	pQihoiQUUjp574PB4BOSXXUaBOvijXFY4LTCQjLGVTfrzqam6DopgCyMCb2ZMZesXpFt3Z9DmaM
	JJETxsfBX3SNJpICT/ib35+XsrFG+8biCwJz6GD9d8/gf2eH7Xj3tBTQPujEZ89Ih5p5x4ZKWr4
	YYvdVKIV4RGDn/UsX2quvTw88h6/SpHLLR9qLukyGqm3d76qMXnb71Et9RIVViIMNcoAsauLj54
	LEGi6n9CrfXyhdsdnrph5H0AWzWhkU12VdkK3zNNSUKDf5Jd8Ya1c4GsRFYf0bIjpAKwe4aJKvT
	JNaxdtbvJU9KB2nf84zAJIDRJmlFATQqX4gCgdJDmvxWw4XwDHPsuZWe8NWupWqnQb8nfSuWqcQ
	zrDZ3TbU8JUB/Ky2ew=
X-Received: by 2002:a5d:4985:0:b0:484:372b:9524 with SMTP id ffacd0b85a97d-48440ffe6a0mr2556791f8f.18.1788190013598;
        Mon, 31 Aug 2026 08:26:53 -0700 (PDT)
Received: from [192.168.0.161] (78-154-15-182.ip.btc-net.bg. [78.154.15.182])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482fbab3fcesm22123228f8f.5.2026.08.31.08.26.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2026 08:26:52 -0700 (PDT)
Message-ID: <befc734c-1c66-4286-8b3d-954b77b44189@blackwall.org>
Date: Mon, 31 Aug 2026 18:26:52 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf v3] netfilter: disable br_netfilter in user namespaces
Content-Language: en-US, bg
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20260831151107.25269-1-fw@strlen.de>
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20260831151107.25269-1-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 31/08/2026 18:11, Florian Westphal wrote:
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
> Note that in addition to call-iptables, sysctls, the bridge also exposes
> call-iptables per bridge device via netlink and sysfs
> ('BROPT_NF_CALL_IPTABLES') toggles.
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
> Cc: Nikolay Aleksandrov <razor@blackwall.org>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>   v3: also update Documentation, correct changelog: toggle is
>   per bridge device, not per bridge port (Nik)
> 
>   Documentation/networking/bridge.rst |  5 +++--
>   net/bridge/br_netfilter_hooks.c     | 33 ++++++++++++++++++++---------
>   2 files changed, 26 insertions(+), 12 deletions(-)
> 

LGTM, thanks!
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>


