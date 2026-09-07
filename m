Received: from mail-ej2-f9.google.com (mail-ej2-f9.google.com [74.125.228.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB91B3C5DD4
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Sep 2026 09:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788775057; cv=none; b=ljRz20bCG19PWz7NWMV3OmEboJRa+mKK6jNlBx30tF3v8YwP557BKSbVGmwXeXiJTxuXLdwMNFYU0Ei/WWeFCyEFfr3E6I+VEws4ercFxdU/Y9TotyOr63G8MJ6g7BbOqVLdc/URkg/9HE6CJlfPfAn2B5VC96Pw8FK/bd9ZDzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788775057; c=relaxed/simple;
	bh=vhWYZT5rtHpp1RsdL2F+vrHvIG+pLXc1kq9fh1aD3h8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N2uTBo9ayz0yCkJBya3+yKhPFU8RyF9W9ROqZcwXgI6UihNvQ3idFgZSinBG7c4+K/8bdsERB7aCZ7vAFbULf7rjJnE0lsaqgwD68QL6Q26VazD5Djw/7v26UnCuHkfoosOoxLjdD/vZDn1q80Yghv+wyOTPMG+WWKPtpoYdb7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ovn.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.228.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ovn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej2-f9.google.com with SMTP id a640c23a62f3a-c2630e38cffso104713466b.0
        for <netfilter-devel@vger.kernel.org>; Mon, 07 Sep 2026 02:57:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788775054; x=1789379854;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jUXGZANL0993PysSl5gghhV/fwlEARMhYop7oGVffdM=;
        b=iDsDlLn39AkQyoN/pQcRMMl5wuIeZGVy17xTK9GuiJrxpfsqZBuo0Sal93Lo06gzPf
         AQLLAH6nxV2O3BWGZMvRDZzPl0eosGhvGoYfCfEuCw26rYhBdsQ47m6SVndsh0O9v7ya
         881uYWdMaMkPeDzZ6WcM6IDsrj+XjS1MeRHfR5r8+RZmdv6AS6trrGHB49+xx0hIVRnq
         2pF2CjG5D9kfXt+y5TdJRAYkBHLWU1lTcZsY6NeJqNMk700OurzS5mBKx8+7mn5SMcyY
         3YybH7iL1ekgFdNqygC8MjxzWmniKAniuZ6J7VZ7OkhWUSQyHPhPDGOqtKEqA7OENtp0
         TFXw==
X-Forwarded-Encrypted: i=1; AKwUvBzFX2CRbI5hHrWIrTISd+ZaeF+gRynCsl3nnG+3GjZ73Z7klmjGQ+p12IU1Vq0FPbua4EpHWo1TtEMo0hWZC1Y=@vger.kernel.org
X-Gm-Message-State: AFuF++mWIl2Kbo/kWE6oUY5OVZLLUINQpID2i3e8ldSIXcbTeB2FPYG4
	kVeXEJIhCigD17gpzuwU1Ojx/mCN/Irmdi7MZZNzj0BeIT68touNnOyr
X-Gm-Gg: AYBFou24rGjcURmCUbeDZvUVju+rO3OOd6dNfjL4loESqZ/6XDsKZApfq1jhT7S1dqo
	E9SKxBlYxSD+MoGqHndtYuT96ArDuaSo/Wn3hdF3qSXOw2hVkuBrCbXRcCRoztAfogolbPyktSx
	NFzlf2FEnH4kC9T5hUZHAJhYvoODebNolhsVioYyofFCGLFNYHx8b9aW7EM4ujtSRerV3Bjur0Z
	cPjhtR1nuzKUeEFZ2AlLreX4g7FX3BsIR0D1zYWijZxfP3y1A2JC/D4FtXzl+r2H0hAtHNmWlz8
	gkHEmcfB2YUbjavjGfYS53tuV1JpQXCBS9ZhKTMbqHFSpNiTyx2LLUCBwwGQd48IA813pYD7z0b
	mcDY4V5qhhSmKqjDQEj1J6ixw8J3z6qnQhGOCxRVa/+UtnfrRyBCK6/xyKBMQoO1lhtdaqAqbrP
	aT+MypYYyPxB+A9MIESezgZO9j4aJnJtWaXVNc3e3ycEkxi/uQ5jUSuYU/lNVkdWGp0Q6UIgtBQ
	miAxsvG2L7pYCk=
X-Received: by 2002:a17:907:9405:b0:bec:64d4:3872 with SMTP id a640c23a62f3a-c260ca351e8mr820271566b.24.1788775053950;
        Mon, 07 Sep 2026 02:57:33 -0700 (PDT)
Received: from [192.168.88.241] (37-48-53-4.nat.epc.tmcz.cz. [37.48.53.4])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c260d4a98efsm452196766b.14.2026.09.07.02.57.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2026 02:57:33 -0700 (PDT)
Message-ID: <0956bec0-163f-480d-ad31-5e547fbe0bab@ovn.org>
Date: Mon, 7 Sep 2026 11:57:31 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf-next] netfilter: conntrack: make filtering by zone
 discoverable
To: Ilya Maximets <i.maximets@ovn.org>, netfilter-devel@vger.kernel.org
Cc: netdev@vger.kernel.org, Donald Hunter <donald.hunter@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Pablo Neira Ayuso <pablo@netfilter.org>,
 Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
 Shuah Khan <shuah@kernel.org>, =?UTF-8?Q?Asbj=C3=B8rn_Sloth_T=C3=B8nnesen?=
 <ast@fiberby.net>, "Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
 "Remy D. Farley" <one-d-wide@protonmail.com>, linux-kernel@vger.kernel.org,
 coreteam@netfilter.org, linux-kselftest@vger.kernel.org
References: <20260904174452.1913072-1-i.maximets@ovn.org>
Content-Language: en-US
From: Ilya Maximets <i.maximets@ovn.org>
Autocrypt: addr=i.maximets@ovn.org; keydata=
 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
In-Reply-To: <20260904174452.1913072-1-i.maximets@ovn.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/4/26 7:44 PM, Ilya Maximets wrote:
> Conntrack flush supports filtering by zone using CTA_ZONE, but this
> attribute is really hard to use from user space applications.  The
> reason is that it is not possible to tell if it's supported or not.
> 
> Older kernels silently ignore CTA_ZONE.  And in that case they just
> happily flush all the entries from all zones breaking all the existing
> connections.  So, applications have to infer support from the kernel
> version.  While it works in most cases, it's not a particularly
> reliable or desired way to check kernel capabilities from applications
> that aim to be portable.  There should be a better way to probe or
> discover features in the kernel.
> 
> The CTA_FILTER interface on the other hand is simple enough to probe.
> We can check for NLM_F_DUMP_FILTERED in the dump to see if filtering
> is supported.  And unknown sub-attributes in CTA_FILTER are rejected
> explicitly since strict validation is in use there.
> 
> Let's add new CTA_FILTER_ZONE that signals that CTA_ZONE should be
> filtered on.  It is a flag, since everything in the CTA_FILTER is a
> bit mask, i.e., a form of a flag.  If set, it means that CTA_ZONE must
> be present and be used for filtering.  If the flag is not set however,
> the filtering on CTA_ZONE will still take place to ensure backwards
> compatibility.  So, the flag doesn't really change the filtering
> behavior, but it allows user space applications to properly discover
> support for CTA_ZONE filtering without need to rely on kernel version
> parsing or risk accidental flushes of the entire conntrack table,
> and also without modifying the kernel state.
> 
> A new test variant is added to test with and without the new flag.
> Since the setup code is moved into a shared function, expectations
> replaced with assertions to bail early if the base setup fails to
> avoid the cascade of secondary failures that can be misleading.
> Error return is only for the SKIP cases.
> 
> Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
> ---
> 
> One other alternative is to make CTA_FILTER_ZONE a U16 sub-attribute
> instead of a FLAG and prioritize it over the CTA_ZONE.  But it feels
> like a FLAG is better suited for the CTA_FILTER, even if it takes a
> bit of extra space in the request.  Though I'm OK with reworking this
> into U16 or some other mechanism that would make the feature
> discoverable, if there are better ideas.
> 
>  Documentation/netlink/specs/conntrack.yaml    |   5 +
>  .../linux/netfilter/nfnetlink_conntrack.h     |   1 +
>  net/netfilter/nf_conntrack_netlink.c          |  11 ++
>  .../net/netfilter/conntrack_dump_flush.c      | 143 ++++++++++++------
>  4 files changed, 115 insertions(+), 45 deletions(-)

[...]

> -FIXTURE_SETUP(conntrack_dump_flush)
> +static int conntrack_zone_setup(struct __test_metadata *_metadata,
> +				struct mnl_socket **sock)
>  {
>  	struct in6_addr src, dst;
>  	int ret;
>  
> -	self->sock = mnl_socket_open(NETLINK_NETFILTER);
> -	if (!self->sock) {
> +	*sock = mnl_socket_open(NETLINK_NETFILTER);
> +	if (!*sock) {
>  		perror("mnl_socket_open");
> -		SKIP(return, "cannot open netlink_netfilter socket");
> +		SKIP(return -1, "cannot open netlink_netfilter socket");
>  	}
>  
> -	ret = mnl_socket_bind(self->sock, 0, MNL_SOCKET_AUTOPID);
> +	ret = mnl_socket_bind(*sock, 0, MNL_SOCKET_AUTOPID);
>  	EXPECT_EQ(ret, 0);

Sashiko-gemini (sashiko-nipa didn't run, probably because the patch was
moved to changes-requested due to the CI issue) pointed out that I missed
converting this expectation into an assert.  I can do that in v2 once
the CI is working again.

Best regards, Ilya Maximets.
