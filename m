Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=209.85.128.177
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792576336;
	b=KwX2P7i/JLjAObSwNDrMYgfT589bXHoK6OLkgbXh/aZkmt6wrTLsuxo2MXHGl6iT534K
	 RRapq0Ph9kZav/tS4Hr1mDpkx24TqUbQE4hG3ZZFPYm75YugBd40HU6JDBRdsi4Z8qQiY
	 DpPaMD3MdvoPO6DrkdTro/+ZYGOS+v92HVUADNDi6mcY9mf6j7mE9k8SYDObz3QVsMaEf
	 EGbeI00XUBzYImKBBN6foX/HST3WQpSvCghWbYmQq5o7hmFS64PCJlmRJpVGqp+NNmDGU
	 HOT7d2dAzpu3KbjU4q0khy5fJ53DsJOX+H+7l3kIxhHiWnkuQGsZUId9FkNa8M5HhRg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792576336;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=Jvum9vHoM5in6HyLcCxwho4XKzNHKiwHpUd+vconds8=;
	b=Se4rYQNGjXs8fVolv4jZUodr4vQg36rjQaNop03vhING7KwwGBX+aFV/2zV4xqZWhfqd
	 7HAXTw8/B2tCf+Sn6CKC91NRdN2st70ZyE+OLiQvHIsBgakQPV0S5ybREKlpG8JExWXfY
	 z/tSIsPhY4rn7ghVusP8rb0GHhnylBJemGDJHgVWenAz+LrOAvXBJqXSXclehyKnYcxC5
	 p2HDMM0jRHDcGGw50RP+tyDBhYJymAKJzS1Q0bpzTeyVqvZf1yu0gh3myevS2HTFK8KcI
	 ZhtmxhxR3z8R3Fd3EDnZJ1zwzPZK76qBP5hqWNFEg/JfSZnGlagHgZH76sjyEUdvs+A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bairaktaris.de;
	spf=pass smtp.mailfrom=bairaktaris.de;
	dkim=pass header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=bFdHvy08;
	arc=fail smtp.remote-ip=209.85.128.177
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B34606A31B
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 09:52:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 72B34606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=bFdHvy08
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-8b13c7bb0deso1106067b3.1
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 02:52:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792576335; cv=none;
        d=google.com; s=arc-20260327;
        b=VwRZcB37j3EMkttdMhbWpZWiiErOblBZpXEtEIU9YefYB3Xg0h3m8pMvmFJ7N3SCUl
         5uiGdre5zeRaNsp8LgjC7fIOBsQwbk/K4oYTPIE0bPxfYpnpbLuWMaow0TlWgtqcHQ2h
         nLs75+fut90GKSzEhLT8jysVKveFdiDejMgBx848gUp2WlAvwkp2FBQov9pmA0qlTOD9
         nCE2tR63JlyQW2WYWlf/ZSjKpvFN39A893mBmwgLn8vXTYL3TvFkzSOfnFyzA5tMX917
         3x5cs5mE3yWr7LUsAu26O6WXVeZDcIMilNxX0Io1nEpQdTkcODyg9yDEvzcdVHH0nYTA
         n3Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Jvum9vHoM5in6HyLcCxwho4XKzNHKiwHpUd+vconds8=;
        fh=QVbg9hqyF0+D2FzYIlfAv5RnZetygDwSW49TlHccU8I=;
        b=ZOBWODspOqW4OQK9sQxD/R4joQGSj/EssjunRAvxDs8ZAw0Tx7kxq2Up1TgyiGGbfa
         NwYrgsDtBHuu5PhAZg2e67Ejb0WogEs97Vo7X0gTviONXyHN6p2OX0aXQoilZofQQHRa
         yzfSnWWN1R+G9vwrskAbOdda9ipfCVL2/wPHKitvnHSz7l3OpckGkeilll3rOC06zfLL
         LFsSPs6U9b1jmBz3Q6WDb/DHnF2OHz/UtSfVJC86Iv20cMIcSBaskQDdeKq/nZKkskez
         JFbyNaHbMyOFeNRl3T/wSO+t66Wbo0pNv3hSbQC93GnrEpvmGCDkcb45MKmOAC0J5SIJ
         6k8Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1792576335; x=1793181135; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Jvum9vHoM5in6HyLcCxwho4XKzNHKiwHpUd+vconds8=;
        b=bFdHvy08P5qTB+4vC3oEIRt/xKMa3RZ5dVG7cKzf2O6NwQgBTnKsoJAKPu00bMNLqX
         eDayHVV406lPN30nVfCqvhQsSPAMYRUsDDx/Yfu8By1+D71d6Xs2cYpYqDcNkhyuHWUr
         QTWvxkxavzRGSjvR+pobQhyGFRotU54L/noqHEgJG1EYXju2pcCE8w8XGdtXZI2ELx9v
         SVqkS0saCjWz8uxENbAQB1dqqIeVrCEl2mUE6lr9c9g0G/CctkGjy2YUYbz4fdva9jH/
         pl//1WVpvsuc7nb8TCyOSdjeFtNpUQvQTmZDg0TltV5F/bFhVAWImJnglr0HUmpi+9PZ
         a7Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792576335; x=1793181135;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Jvum9vHoM5in6HyLcCxwho4XKzNHKiwHpUd+vconds8=;
        b=KmTbWxLbL86uvuf5bjoK/9TqRJv9cGZHoxdbeclj3uBzqkXh/o899+t3HRjOY37bwK
         KCNXXtV/jq4uv5MgdfoELWexjBaZTd9bCXPbbQm9ypnXxheKoGqE0HRuUkj19odRdaA1
         +kW4tIjzBGI9zLEtOh52VEsHHrjvhiOY5jDgUGujwgBuGUD/BH8TBWQP6dAvMGSQy9rA
         IHYSrLgPFJdtmraJIOzVyTgqDDp6l9pLY9GikYpRHvsVV4zdZm69qBFjth90GXEwJ0w3
         xoUFQQLeT9D9fw8VFjSYyfxyVClATKCqaxFUMltl/k/P1yirde0cNSOWqxb59N/ymQHb
         izvQ==
X-Forwarded-Encrypted: i=1; AKwUvBz/OrCCYhtj3ZgwauDBEvmeYWryNFP9NeE3XSkb0ioFZw7fG6y4VR7Vy0xv1G0YhoNOsZY1GgIf1A9y205IbSw=@vger.kernel.org
X-Gm-Message-State: AFq9FYIz3ZrOGT91ASU2jBLqow8gBL6uN5I1CG8TbTO8kYKuzawZd3Iw
	iTYYDc4eeN/Kk0E1v43ufqwD2sKoVEf1FDPsGqbCV7GTMwO2Sq5KnL51JOd07MpjuDWI6KOxWlF
	Yn3JNKHdn1nUyk+DldcMxzFBehu5mRN/xCGUXUy2B
X-Gm-Gg: AYBFou2cjdw7u3/0fvxM4sJCLXhEtsKM5+NRc+uLIRGWf3S0UVV3fzroJJ5hEIiI82r
	QHul6sWxjI+q1qoALX2P3+mUg5NgaJiTt1mXDoSUrgCwUofSCPg7wegSxIGlkkzHVFSrPzpvzb4
	Se8TmOOFrKGuaj/xAaSkx5DazYKXTXyq0+r+BswVD7qaGV6R+d6moG/bEc5SPIXDSg+5/7tRK9d
	H8iarFvFNxBTG/xvChpndk6cL3UCDZSaymUKbfYknZqkAixRuE/cvFqO4+ngN5Oq/JxsFxXBQXN
	ptJruVSCK6aKQgfciGz39beSIOJ+icYpTJGUaSMTxRmuEgxCx52NUfDOAUq0i+T5NyDpjDjoDsB
	mmii8o5cmZaXXOJrp/ToNJ5b+vRKywUriGBIRVqNJ0LcGKr5uD2V6p7HTeWdoY9xpTywI0OM72C
	LaMx+2bZ4xYMog6wara0DQgkJN1GcTRD7OI8P5598s0gBK8Ebv5vkVwd5uJqaH2jn9zuj3FiPFY
	taUktbfHjH+yKH5TmkDUE1NuFEoggWwsqI6XAqYXXTVgdEQIc8n2cc+0Ud8t5DidDxtjpsSaj+d
	dwJPLdoMO9wEJvWBg7TvVA/b5Iw1IwEN2+cn68126jqW6AMs5/QlwcJmeQRTv0GVsgOQHw4=
X-Received: by 2002:a05:690c:e653:b0:8a9:da0d:1d94 with SMTP id
 00721157ae682-8b133fbd819mr5144797b3.68.1792576335378; Wed, 21 Oct 2026
 02:52:15 -0700 (PDT)
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <atQmpPlfT_DSd9dq@chamomile> <20261018025319.1445197-1-julius@bairaktaris.de>
 <athy9HUHBPfCBKu6@strlen.de>
In-Reply-To: <athy9HUHBPfCBKu6@strlen.de>
From: Julius Bairaktaris <julius@bairaktaris.de>
Date: Wed, 21 Oct 2026 09:51:40 +0000
X-Gm-Features: AclHuK-pk6kFTufeu4wo_iVpKWwHjnmfy3Rd4sMx-D_9eg3gvY73gs9VtcFkc1Y
Message-ID: <CAC1t37KrcwpXz5BDrPMpKBdpwJMon=WQWs8sbxDh-FrGFkAaMQ@mail.gmail.com>
Subject: Re: [PATCH nf-next 2/3] netfilter: flowtable: update upper device
 stats in the fast path
To: Florian Westphal <fw@strlen.de>
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org, phil@nwl.cc, 
	coreteam@netfilter.org, netdev@vger.kernel.org, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	andrew+netdev@lunn.ch, shuah@kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nbd@nbd.name
Content-Type: text/plain; charset="UTF-8"

Am Mi., 21. Okt. 2026 um 08:08 Uhr schrieb Florian Westphal <fw@strlen.de>:
> Conceptually, with flowtable, offloaded packets bypass that device entirely
> and therefore should not touch stats of the virtual device.  At least
> thats how I'd expect it to behave.

Fair point. Users could just as well report that as a bug.

Pablo, I have a v2 ready if you still want it. Otherwise I'm fine with
dropping the series until the expected behaviour is clear.

And thanks for giving your thoughts, Pablo and Florian!

Julius
