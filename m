Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 998A03C583B
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Jul 2026 08:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785400278; cv=pass; b=tw4J6a0084IH895z5zkJrXYOJHYcftj5zFg2DRWuV4amSsdDAUB92PGlpD8dOlh9AAw3auLgGoEbyp3OSdukENg+J7rE1/3gi0qHgmxgl2FD2Y2Ktc8JyinjMOAL1Yw+F3CeJkAUL8NN+Ck0AP6/5arydAiw2+rl32kQ6DeftVc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785400278; c=relaxed/simple;
	bh=UyGpFZHBuLi7sb7D2H3adTyPghwkWlzs4kttoVoTpWA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cSHhXTGGS2rB8xnIzXNndfhkP/ebahYVN7G185Pznfqrmh2iXu1DCAaS4phMRuBsRcEO0z/thPNJJ6Oq82qGy5usL+E4peAPdE1T1WoHxBADxsvVjXqqC7ImebziCzS4ZsWJFPVEXDLqwd8LCxFqcVRRM22oN3ajRSeH6N6gtJA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FQgWoJ0B; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FQgWoJ0B"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-69848c9462aso244870a12.2
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Jul 2026 01:31:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785400266; cv=none;
        d=google.com; s=arc-20260327;
        b=XctdwDXpuO/JPw/iUrEy1iRcXZkCag118/AWf5a7t3d42m4cFa1rxiI1skZGMvi2tS
         4zjknUSOwXiPb09Cftz/xKC/2jdodEPsX0YWBNylhq3MfdcMVOIcky8xBW2rh16NJRSI
         t0XtjeqFN5dI29YINmcvSf7AMEd7rNoG3ePnto4PEkec0gQpMeVXbTOcc/Nz/K+35D0D
         ElqTilxpKvGzvdfOrCDtRc7rALF9pBjrFXd4dV2rb0AbuHwqff4No3msXepDU2lhXhyw
         SATxyVj3zxwydccL3NHqUgc4CrL6B3dKMix55VXTzpkjXUK/O5WgfUTXch1vvGV8la2P
         1VuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UyGpFZHBuLi7sb7D2H3adTyPghwkWlzs4kttoVoTpWA=;
        fh=vFSnLIh80EtqI7HEPpG5BYO1VmcZ4T750U66klKuCL0=;
        b=FCFCniNuC2ZnYJ6R6tFk3BVpzcfL8YjnaAEpG2Y/sQ/QJrj15kS+tPduP9MUSEA2uO
         b6zcG+uw2GAdm3MqaMUFWgglXCs1Eb6MvtYIa2OfED1hMBpcMxLUJl4nSLYF9yA6K3Bv
         Nvb3kAbhekTuxXGetjLO2YcOwZ8AzVcH/RCArg083TzrQkhsJBOlo827bBc/b1ev0bMn
         yIDbS+shFTzDMJzs+OORX9rsOK9ResL64NyXpT3AHqvhzHSp0t2Zyq8ANitvGWbDHrx5
         AiWWG5W442aegWGggFeg4G1FdWcokNJiULxaPchqLQv8A9rU5qHnry0cEnjjGdDzEJGB
         /MFA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785400266; x=1786005066; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UyGpFZHBuLi7sb7D2H3adTyPghwkWlzs4kttoVoTpWA=;
        b=FQgWoJ0Ban7tkpBIKsbVb1GhdVRoDo24YlMgFlki9j0l/FrFMU0x90zTbpVnvDiDYz
         a48u9VKaiivILVKwNQzBUdLJU2aMhJaaK+rk45p1OC/D/CCTBIlNUVkC9lFaIdWIwWkn
         G9VFtal4QUBUje+zolTUwBtxivKmgWV+9ImN7csnM6AYp68ZOD16BaFlw9A0AD0MablN
         mjCSr797LW5khJOUgofZt1MFtI0J34cO//1I2B7VKKVpjcOqIDijSfYVyMWn2SUWQ7HW
         by7YM+2W2FgkJHHd6414dS4i2TWsVYGD+NcFFlu6Oy+3B77GHCnKLWoGbarBEMHkhm38
         4/Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785400266; x=1786005066;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UyGpFZHBuLi7sb7D2H3adTyPghwkWlzs4kttoVoTpWA=;
        b=oLFU3XUDt5OK7FYCi6IOynHYkhh0vQb0LawXTNw3M6sKTNC9l8Jzd/VCdDJnMzHru/
         1WGDIauY8NOAD0yYkf+ZX6Eoi5XOQTPlQzuKI5BbgUU0tjYy5h2aN4KdfIfMky25SpP1
         u3m2PjdP8Xswj/yVRMTUHZf7ugYjNpyYFk77iM8cWhZZ9vK+Em0auRparJUNbVHDaEh/
         SjW7MsiH0N2UN+K1rs2CrzkrrANw/XkomVc1+zVPod3LQwBG4kvSFgjuGLpex80hn8Jf
         8zLVcJyKTMUBtrtt/uQDj+LTzkUn1/AO7A/bxCtlQqWTuAsTv3mRzfzP/9Tu0gHSvN55
         sBQQ==
X-Forwarded-Encrypted: i=1; AHgh+RqfdCNRGshL7dsp73DiaNAsiubq4I9hoHeKRXZPiRrMxwM2+s2qvXgfOrlbj9EdfN/6xCC+baBEy9LfZcev8hw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxkJTJ1oUb3OG1SAJF8Yv0beoI5RW5MFpuMhQH7XZB9PByD3sWB
	iHRaL6y2Kv04xMgZbsO1T6brX1SNoiA1jUWKwvFVfc4cQB7n6eLLytaPyVlsvilHYuBPmBpVuce
	L4XzS2Va10hyZN+G5buAxcEnZyPoWhsQ=
X-Gm-Gg: AR+sD10BhRLklhWkZzuBMqwh8mZ0IT5wp9YoJ6P0HSG5v93UGGRSPrf67rjkUkK/hsK
	mwwLSxlPtoXpjO0FR7TRc6EHJtbWyEymDE1L6NfOIRyFrXQ9JiXCyWr9a4+7HPJUnjJWlBsz+9L
	jsw4qxgqOHzPQXpr5Nwh6wT93yqM09kodPDb515NhHlbqCPctv9wHWFA1ROtU0lJzX7rGC2KSrp
	OTBx/Tn7//Pe5LD/mt5JTXutiIOERQfJAtR12ZKgYxFMX8vqVxpURuvawry3VUDoIlAEbq9R/5E
	nmxLgAkoWzNdA/TImNtLOnVUBllPJyV3YohXDPPyT8RmXFUFqZ6eNdj0Ljxof5UJ1FVMP5P9MQ=
	=
X-Received: by 2002:a05:6402:2792:b0:6a0:eb:ae4b with SMTP id
 4fb4d7f45d1cf-6a07b53987dmr789961a12.0.1785400265443; Thu, 30 Jul 2026
 01:31:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260729163141.213611-1-nicoyip.dev@gmail.com> <DKBP6A3V5I02.3GNQ1SEZST1F0@etsalapatis.com>
In-Reply-To: <DKBP6A3V5I02.3GNQ1SEZST1F0@etsalapatis.com>
From: Chengfeng Ye <nicoyip.dev@gmail.com>
Date: Thu, 30 Jul 2026 16:30:53 +0800
X-Gm-Features: AUfX_mzP2_dgrdwIJfpJtiwvx7D1iQ4FEUItWv_JG1MEc41mX0jP5E3An5U4l64
Message-ID: <CAAo+4rWZAdy=6HAHiysb86E5eFmXsWNZACtf_eBzFNqg=9EJhw@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: Fix netns reference imbalance in conntrack kfuncs
To: Emil Tsalapatis <emil@etsalapatis.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, 
	Stanislav Fomichev <sdf@fomichev.me>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Lorenzo Bianconi <lorenzo@kernel.org>, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 30, 2026 at 2:38=E2=80=AFPM Emil Tsalapatis <emil@etsalapatis.c=
om> wrote:
> Sashiko is right on this regarding all other fields of opts having the
> same issue. While they can't lead to a crash, let's still snapshot them
> at the beginning of the function so they don't change from under us.
> This is still far from ideal - we may read an inconsistent snapshot of
> the struct - but it's backed by BPF program-controlled memory so AFAICT
> this is the best we can do.
>
> pw-bot: cr

No problem, v2 was just sent.
