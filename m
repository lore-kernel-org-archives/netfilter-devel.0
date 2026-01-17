Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396E9279DB1
	for <netfilter-devel@vger.kernel.org>; Sat, 17 Jan 2026 17:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768671238; cv=none; b=LdoaBZwd0XWvXQmnqqCv14roeSFDwV0tYDkRj0nfVePw2ONnKHwf+gCha0S5KHr64Y2ECc7u/2HBLEMZBoM4uzXAdKOdDHKzwn62hmEHu8vHrFeU6A7qXuLQ39hlr0dIUWNNJFx0c/CZtS8TbSLJJOtFjgIBADebmoW/wu+0RdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768671238; c=relaxed/simple;
	bh=tlBjuA5xfR5tuefAO46JbRQJcsmLlI8yfq+b7MeWLEE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Pfrfp2OMHE+mpdgG7P4uGPVgCG9jkgqmv40vZ3SsaEJdzPhHM10dnXS33mRjh0MSRE/NVfVlETTLAjOjKdsOJsqNR3qJorSig0HNdMFykPGUpGT35bXQ8g/3wVjXpHahufjTVeyVlakt3Fg44eRf6X5+Rmv5kAjslehQi2lfdX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Azsokahx; arc=none smtp.client-ip=209.85.217.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Azsokahx"
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-5ecb1d9ac1dso2124038137.0
        for <netfilter-devel@vger.kernel.org>; Sat, 17 Jan 2026 09:33:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768671236; x=1769276036; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DeAqZXahHzqa6kJPzha4YSPb4VXznhEtP56Z4rFZLGA=;
        b=Azsokahx3e7LrP3J7DybNydoQq+JBLyRRjk7aAOqUj5/72KB4ZtGHjYZ8BTG8lJ4aL
         sAu/GR4bdktvfo30+m9D6SlefDJ4th6C3Qb4N/5P8L3ILvOMjEcIBdDgkaZNs52am2fN
         3cOAH409It0HydWTU4EcX4Hx6lJIPWMarn0UzqO+3AyjeWy+zw3edcTD2zldCxFH9rug
         qEbj2j3SU+yP7HXu+P0zBM6m1tLJPPUEvZB0DeLVurQVvHtJYJ8fYtjASqch14s/Uaea
         i21JYbMNc3a8iBjhHZWVY5BfGOj26TSho1Wu4iscp7qHpFT3c1DF4Pwygu5pTnwssUf7
         q74g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768671236; x=1769276036;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DeAqZXahHzqa6kJPzha4YSPb4VXznhEtP56Z4rFZLGA=;
        b=tbKpk3MqJkqfBSzhDoY6sasJbKdgVSvRL+w5nxBu92fcDwSA5ymcgfeSp+53IocQfH
         kKLLVLEp1mjjvUZqixycCqG2xHIqFX+VzgA/vRJrJr2MRgfj7AgRtB//g4ie5Fu6UKz3
         yv/kmcuQTGpaUwS6SGRLaSslyLTD6/DkmVB60dCDMxBJ7yysF0b0YVIKEhEP+NTrcxYE
         5YA79+cWLbB3hqt6ULh4YP0gKTw3WkQXF1ylZJiXm7RmjKq3SMYRut5NwNRNLK4VLXPN
         HMgLMRAZDsle5a829dbh5TwGvTT8LR8aMPu1/FptjDPvV4tel6P3LW2WT/QSo1sM1p89
         UJsA==
X-Forwarded-Encrypted: i=1; AJvYcCUhdm/d/HoD3/Giv8TIJuKZ5gjiB6223XsmFWnMtiAEff//rc70N7/vXE1eztHDP1rxdqv2XwGjzWlpbUnZMGs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyMkrNAVrXB2U9ceeu2A3IRwfrzrYLPkjS8LJnBnKygbuPAyXAN
	gU2b7/kEZ/dmHb1W+Vd8CsiKRR3uYB/g8huvCCdn5A2EbksKwRcOr6ljS1GBIDO2m8hmWtTnnHj
	xvGh1vxeZThahwL3w6TBBKEglS/CbKC0=
X-Gm-Gg: AY/fxX6acB9udaWCQeAk9rGNReI7dVevRKPpn/zywhCxNlTmxQ3j7UUMLEklRgn2gDG
	bxOfi1P8KbzUvjiNYJiwwyDB0KspY9FE3SXvflX5n10po1O1vAT/oLXc14R1OY4BbJWSaZMG7r+
	HeYOVz3m53jXf5CcrxRPGprBCLc+dGsl0+aLJtfl95/8Uqi4WbQ7/9LLcyUiPnuCW3lIzlXZLrN
	cXlam9O2NArdAT2/XLv+PcMAH7FfrCZ2f1XsnlKjyl3xdDK34XYDmmKOSB1Bjk+k1MrIYQ=
X-Received: by 2002:a05:6102:1611:b0:5e5:7055:66f5 with SMTP id
 ada2fe7eead31-5f1a5512e54mr2482685137.27.1768671235999; Sat, 17 Jan 2026
 09:33:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251122003720.16724-1-scott_mitchell@apple.com>
 <aWWQ-ooAmTIEhdHO@chamomile> <CAFn2buDeCxJp3OHDifc5yX0pQndmLCKc=PShT+6Jq3-uy8C-OA@mail.gmail.com>
 <aWketzn78tzo5anB@strlen.de>
In-Reply-To: <aWketzn78tzo5anB@strlen.de>
From: Scott Mitchell <scott.k.mitch1@gmail.com>
Date: Sat, 17 Jan 2026 09:33:45 -0800
X-Gm-Features: AZwV_Qg7qTIftU8j3tbHTZvqgIuaPVcLE_E-_VQsq9p3KEg55n-yTqR0tUYuZYc
Message-ID: <CAFn2buB-Pnn_kXFov+GEPST=XCbHwyW5HhidLMotqJxYoaW-+A@mail.gmail.com>
Subject: Re: [PATCH v5] netfilter: nfnetlink_queue: optimize verdict lookup
 with hash table
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, kadlec@netfilter.org, phil@nwl.cc, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	horms@kernel.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"

Thanks for the clarification on the options. I'd like to propose going
with a refined version of the v5 approach (per-instance hlist_head
with auto-resize). Approach is to submit a v6 series with 2 commits:
1. Refactor instance_create() locking to enable GFP_KERNEL_ACCOUNT
instead of GFP_ATOMIC
2. Add per-instance hash table with auto-resize (no uapi changes)

Rationale for per-instance approach over shared rhashtable:
1. Resize algorithm matched to nfqueue behavior: outstanding packet
count depends on verdict/traffic rate. rhashtable resizes based on
element count, which for nfqueue means resize-up during bursts
followed by resize-down as verdicts drain the queue to zero. This
burst-drain pattern would cause repeated resize operations. The resize
approach can be tailored to nfqueue use case to reduce resize
thrashing.
2. Per-queue memory attribution/limits:  With GFP_KERNEL_ACCOUNT, hash
table allocations are charged to the cgroup that triggered the resize,
so memory consumption is bounded by cgroup limits rather than
requiring an additional kernel-internal limit.
3. Simpler key structure: Avoids composite keys (net, queue_num,
packet_id) needed for a shared hash table

I'm open to reconsidering the shared rhashtable approach if you feel
the benefits outweigh these tradeoffs.
