Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68890309F00
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Oct 2025 11:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761651798; cv=none; b=Z3MSEFOTZyw3k2d+O2KRNd68mw3BnV1dlCS/WUGjxZOXeb5TVGnBm+oJClM7UEx0qbFyOe6nGISQRjzNaoL2dkDjBcjvS73fdk+pwuUDI0yCdym04dVbPpzip/ntuVoQIXn2+ArnS4Up4xgeiAKKvqbWMHB2Gi0KECUVPZ1SlQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761651798; c=relaxed/simple;
	bh=yGVq8gF2tUQexob86KGNBoc3W0yZw6td9K+Fy7ylHo4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dGARqr86USPU8dSFVzJ7FjH4e7JhiewPa9hepNIOlSWqj5UP/hyRYU7Oen1oI7aUHn5Abg2RLeeaOpQ3JYwe2TvnO3Pj3F8OiuoaC3wfOea5H1Slt5mFwh7H8RgOl1d4tjNITIRafilWaDp0soTuoA+CdtPhZbKSLKIHI0ap/RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hN/IF4hv; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hN/IF4hv"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b6d3340dc2aso97062466b.0
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Oct 2025 04:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761651794; x=1762256594; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bnZs2RMUETbMZcfBovNxnautSVDoIsvh/Vcc2VRjKM0=;
        b=hN/IF4hvDxuuXsbRaa9PL/Is/CtrzJUsQwfHUVvAcvaTamtVUoVAn6+gCdFiTJcJT7
         K79egEEQGnKbah9N0sOciTo3v+ZkEAXWYL4dnJDum7CL/+bEnrUA6ijFhDIK6tJpw0nB
         XaqanuqgFCRTd6B/baa5cERb0pH5k862iGpiVAilJGxyI9dFG6yf2P75Q3MYY2yVUXTa
         njtuxGUiAWcezijrgnB/4T5Wnh+IU89XtLdP5p/cuxCrOnhFRK55mhZ1elVpzLCDhk9c
         8vOWvI+O4lEU8TupawjpK+eVNUuuPnnN18mNE9RhTYVl1yxQR9IPXvwz0mALPQWQpWrU
         iqWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761651794; x=1762256594;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bnZs2RMUETbMZcfBovNxnautSVDoIsvh/Vcc2VRjKM0=;
        b=Kcv+0/v8eut3y3FDp1HWgVu30UurNCTb7Otf1AwnLiJEgfkMNkMbe5SY/3cxXqvNzW
         iOl+CwlmyLYDYHEj1zdAEyWRstVtagj5hBw6BWVSKT/g7uuO6keRfhY0dJ4Tu848rOE5
         p5nW21suGKFMiVrzlMnJVXDKUHTdtBy6KTLk3XaxQr2tRPoXYSesgXIEI6oI7bi/4NI9
         rtCu/gZxsJHIDkW68JX6YW4VbLvcMbfgdXI/ywuiVta/OBuWzygluZbETy/Q4fW7CgaZ
         9cwtg/KMRXm/hYOOEIiTmpB8UWXpvH8m0OEooiGUWR9UDfCbnUOhr33zjCW1vW0ZuEvI
         5rUA==
X-Forwarded-Encrypted: i=1; AJvYcCWhyidB1k4uqK3R/EUBcQZcYNX3L0EvAKJc+X+Rpz+ouU+8EDOVfCKshzjtYPyNXFHFWVPeSc4fGWttmXgJrNs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhvIF9662isfxnc+d5j5W94l/4z4fjdfhEPqzlsw6S+sARi39I
	/Hcx4KS9DPN96y23ZBLeMp2qq9j91/VDkZhI6zQj19ev2ATcZl5zSkcs
X-Gm-Gg: ASbGncsc0wf/o/UhZKqit8o2Z7IsrRVBnyeICrwHaC8RPd1D/aKJvz1qhy+mVF9ipw+
	ysQz3IFzm9NCWA8u8qmg1wYY6SMD//XuLGNfRf90f+AAshHZdrpG6meHIS8WNY0/qTkJi5RrKnq
	ur5O/DHPdJbG2DkbsSpUGIpP1SUjeAkhAaqAxHyVpuBiE05yMBsqLJDUFjE5Gz23BayUm+rzhOL
	R9gQQrDTT4B5yF5bzePy292Ee9sDls8kKCcoxQ+bjT2Nitl6fVjJZUR39s6ai4mKrPfSN6KH+JL
	nAo9mImuCRANqU+Pn+Rm4RxHnGIUp4/A1BPIGRfuDA85CqWVLQWTJoJjlc9tosWXFC5nicUAcfo
	eeO15ZvWgy3fz/YN/juvN55HPrdIYj47TlRi1D084yBYnnBDxddOBCC0YWEVlIR3dH7I07vtr+s
	ZaCSRFRRlWRk1PDydYD6wr/zUHT9Go8c6TD2sSZlIT1aKkZ7SiOKlYPMiBz5QmCIOaNJBEgVPEX
	TLfM/CjXnbZiV0ffj6aE52hAWt7N4Yvye5jMxk/jFE4Lz1JM8/sSA==
X-Google-Smtp-Source: AGHT+IF3bVuUSQU+alNARg7/R6qmJGQ06NbQbI0VrYE7H37TwU5eAm2jU1tQRdun4pLRt3QQNki5aQ==
X-Received: by 2002:a17:907:958f:b0:b6d:f416:2f3 with SMTP id a640c23a62f3a-b6df416071fmr70842766b.19.1761651794317;
        Tue, 28 Oct 2025 04:43:14 -0700 (PDT)
Received: from ?IPV6:2001:1c00:20d:1300:1b1c:4449:176a:89ea? (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b6d8548ed8fsm1084055466b.73.2025.10.28.04.43.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Oct 2025 04:43:13 -0700 (PDT)
Message-ID: <a4a3dce4-0f2c-4153-abbe-81e5d2715bbe@gmail.com>
Date: Tue, 28 Oct 2025 12:43:12 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 nf-next 3/3] netfilter: nft_chain_filter: Add bridge
 double vlan and pppoe
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Nikolay Aleksandrov <razor@blackwall.org>,
 Ido Schimmel <idosch@nvidia.com>, netfilter-devel@vger.kernel.org,
 netdev@vger.kernel.org, bridge@lists.linux.dev
References: <20250925183043.114660-1-ericwouds@gmail.com>
 <20250925183043.114660-4-ericwouds@gmail.com> <aN425i3sBuYiC5D5@strlen.de>
From: Eric Woudstra <ericwouds@gmail.com>
Content-Language: en-US
In-Reply-To: <aN425i3sBuYiC5D5@strlen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/2/25 10:25 AM, Florian Westphal wrote:
> Eric Woudstra <ericwouds@gmail.com> wrote:
>> This adds the capability to evaluate 802.1ad, QinQ, PPPoE and PPPoE-in-Q
>> packets in the bridge filter chain.
> 
> Same comment as previous patch, this needs to explain the why, not the what.
> 
> nft_do_chain_bridge() passes all packets to the interpreter, so the
> above statement is not correct either, you can already filter on all of
> these packet types.  This exposes NFT_PKTINFO_L4PROTO etc, which is
> different than what this commit message says.

So I have corrected the commit messages now, but:

> I also vaguely remember I commented that this changes (breaks?) existing
> behaviour for a rule like "tcp dport 22 accept" which may now match e.g.
> a PPPoE packet.
> 
> Pablo, whats your take on this?  Do we need a new NFPROTO_BRIDGE
> expression that can munge (populate) nft_pktinfo with the l4 data?
> 
> That would move this off to user policy (config) land.
> 
> (or extend nft_meta_bridge, doesn't absolutely require a brand new expression).
> 
Did you get any answer on this somewhere? I think that answer may affect
this commit, so I'll wait before sending the next version for now.

