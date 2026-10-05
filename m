Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C503AA1BA
	for <netfilter-devel@vger.kernel.org>; Mon,  5 Oct 2026 21:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791235245; cv=none; b=XIi77fSLXY1q0jxIR2xK+e28hcVVJ33osbsZ2RBatRl338fI0g6UpR2ypEvj14roY+c1lxNuSqtUIVGHWieVtZ3ZuXOcShYGpcQXXpFIrRAZHsrXz946jSCta7axarheNvmpqQApSiz5ov0KCCDV6lUU3CuV8IdqmVzYI4p7HLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791235245; c=relaxed/simple;
	bh=eKEhRWg8r8lcVQlTsVVu0qrr3lXjUZhkr92zgqGRhF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nSm+I66BEwKNkkNJtV5GMiReHMt8nmPOF6FC9Df1VFkVTd8uO3Ev+znSlNmJ+LeQSN5CZ8zCqUwksraPNVZxmsp3vy5YhKUAm24LrO+kUA785xgRYbOo9NWHPffppQonVURN42er2BQWF5sR0bjPXhfCUH3vT9WqTyl9HptLCsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=0GW03P+/; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="0GW03P+/"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-48afe75f055so1869212f8f.2
        for <netfilter-devel@vger.kernel.org>; Mon, 05 Oct 2026 14:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1791235241; x=1791840041; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Iq44C5dsPAhwLXRlUUC1A0u7pKaUDbi940VQRcT8enY=;
        b=0GW03P+/V2U/QA+KGvBbndvWZKaUIWR6Phs5dV4YvSuU6ihg0FOqP0ZE0fi/uKAWjn
         fwwqAuilqXLIzbk8Xaf7eC7CuJAf+WXOkERp+4mjc/AetaXznzzyivUvp2jvBGG+4Pfr
         Ph8kuAhlN5Vv4IkpzP6j6BQDepKu0xvoy6XNR8tNTart9H5e/Dmpm0/WnZYAqHm+NsQd
         KJHhWMFU99Ge/YJLCs12oeqJRY5rzB8n1Pn+YxGIyGJGF1twld/hTP1FJdDBAu8w+gcP
         UbU4F0MynG7fxh00taUBUFPo1hfQNAk6cwe9Qu6Q5vDh0lEpc8Pj35OsGGvqmyp0hlZl
         c1dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791235241; x=1791840041;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Iq44C5dsPAhwLXRlUUC1A0u7pKaUDbi940VQRcT8enY=;
        b=X78dM5dMAMjT9lYvEmxC2D7XQGXUVI4mtyQpXPyKIYV3EfWTzBSL2miU97cOWrZ1yk
         rzMIoDgVTF9fHZ4dwvPcKRFSw7ZMhIGs872M/odpBRK0jWs/bMpWeF8O/7W3S9gs1I9M
         3SKgIZ/Gjzgfq2ulOck/4Zrd+UuXh15VN6qSrkNS/O4xlCxWIurH8hp3hkuZbN/x7AZL
         jzgczSOokxaW1Ai4bOG8RFrSapYFBePPJF6UT+v6TGk5MWwW/XiB/C76iwtPjzXohJ7E
         yG5Pt0q9dtDvQ0oojZeIvWeRV/qUs7lx0/Req1vYb3+Wjp+PN7jW5/FRZeIL++XKjzyD
         VxEQ==
X-Gm-Message-State: AFuF++ndvgfouGE3YzTipq8H3hEN74v4wqGUNgT+NCQ19zZOeglZzcSM
	EsCeJqrn4IoAetPvxbhs5iL9ORJlan1N2Epn8aqK8rv665FhyQjtitEvJH078Yf7HhlK9GtkHlj
	Vpa+fEg==
X-Gm-Gg: AYBFou2Yz9UQBFOEfmYlANBphej/P2S37fOpBH0kvVF69AtQBB96ybk8KayMf8QVGbW
	LokjncuxlUAEEcJygrLiEAOPvTjCy8RRy0SyQObRPcrSuaiEp6EfKcCHUEtGCicFaMglsPiNsZ0
	YeHLBfThDbwvFK5K/YJ4KUMQTl7LX03kW+B5qKdiZMAvun+0oqNaroqTzJZhWsSvd6Ai2cTr/XF
	HV6XRJw6OuVkHcJ5uavdiVD14bzt/SXVfP5DtWRC4g7Y8kkzQzH05YImA2+3XTDmR9BdMa6AB3I
	3sAsxV+G1CANjsHFLBdW1v8mlvFkxqWCvKRQy5rhp5N6IXi/PMYkcVefSAuWxSkbfF5pnOQd2sp
	3mgmfsrietiXUrZve/3c7TiawDtgZDeo8lgfUmhePQzRtftb1rWbFs6S97O6YkkGxSpp70WsrhX
	FNT70pz33Qpgkyjlb6NO9eBg/T84j5J5I7jycQ0qpKxhkg/5Gm8NFbCHXAi6x5ZVt5bIuArcmuU
	BF95KjPD80MwhWSA0JiLseBG6hnUyG+t0tojPsefpGunGiUbqY3nAcZAIazYvEWV+z5uccwcxue
	W1JjFUuN1pCX8Y4YKtv9hYz5SZ0CAXEfNp3iXt39u19rGhbqXjfIwyR+gtzNJGs3sSgAhNtpiVt
	9upYMo11PYzMHnqgy4KXXxw5wyY8qf/YsHu+kJRyqCqikOOQkzILAwh4g9gI/NAZoPQY=
X-Received: by 2002:a05:600c:3e0a:b0:4a1:6843:eabb with SMTP id 5b1f17b1804b1-4a16843efe6mr133495455e9.1.1791235240914;
        Mon, 05 Oct 2026 14:20:40 -0700 (PDT)
Received: from Desktop ([187.40.54.22])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a178ca8127sm18607725e9.2.2026.10.05.14.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 14:20:40 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: sashiko-reviews@lists.linux.dev
Cc: netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	pablo@netfilter.org,
	fw@strlen.de,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH nf-next v3 3/3] selftests: netfilter: nft_flowtable.sh: check the priority a flow carries
Date: Mon,  5 Oct 2026 23:20:17 +0200
Message-ID: <20261005212017.2997-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261005171647.3D12A1F000FF@smtp.kernel.org>
References: <20261005171647.3D12A1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Could this introduce test flakiness due to a race condition?

I don't think so. test_tcp_forwarding_ip() waits for both socat
processes and compares both output files before check_priority() reads
the counters, so the connection is closed by then.

check_dscp() reads and resets its counters the same way, and its
"dscp_ingress" check also expects zero after the "dscp_none" run
counted packets:

    check_dscp "dscp_none" "0"
    ...
    check_dscp "dscp_ingress" "$pmtu"

The test passed three times out of three with the series. No change
planned for this one.
