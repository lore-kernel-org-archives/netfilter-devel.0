Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A331A9FB7
	for <netfilter-devel@vger.kernel.org>; Sat,  5 Sep 2026 04:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788581449; cv=pass; b=PYnHrilXJYJsGtB1tBG4Y7ZflGIWFsh0bVYDO8xG9TMGliKsn8/X+saTLCzNY6R9AC/8p0jZqBiu4yJth5uUiMm2qyYV47V3qEjF88YFhGvLrF7Fs4Vim/TR+iREAvU5hyqn7cEagPPICCqgNpa6vSGff01ksqwLgDk2qrhY+1M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788581449; c=relaxed/simple;
	bh=NPVqSyYahOrG9i7WDx5wohhO3rO/dLgDWLTg/Id8pKk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L9rdfzju9klO7d1pK8E+i6r2DCnAxV5Ke47wq+zuX6kBOxrXwy7owWtrusttJZeFd3ihuh7a9qsNSy59YuP//8P/RzudHZK/Z64xrWCD31gVpakh3EepVPL4isDKVPpd2XA386fFUNVUMIQBIbfzkdRuc/WOYcxyJ4047LgZ9Gs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bPRg8Zni; arc=pass smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bPRg8Zni"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-84830c774a0so1505488b3a.1
        for <netfilter-devel@vger.kernel.org>; Fri, 04 Sep 2026 21:10:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788581447; cv=none;
        d=google.com; s=arc-20260327;
        b=fARbHZB7VhlTUHt8E8g8EzVNG2gRh4Pu0YXohfTyboWBPu9xLLWX/0BMfbe8Nku7cf
         /+o2gmu9ZuNm8v1Xkc0Zow08OmbRcDj+xlzNxTELSe/MY/9nxMMbBU4vB2V/8Cbk5+Eu
         QSWQo3HQ2wkEain7roD7zyGdyfkds7rjNrvpCMWSxH1jCNmPbZstXWp4khb2rhNkliPn
         gnbjkt2zgN3Ed9ADOZIZ3eFMcUz8V588d5aeZzdd/ETzAeK5ia4R3daeFXAChbjGTfuF
         hWJXBon7YxB6jlZAhdvRDVEltdcSXrafUaGCX7dSj17OMiw+uM88NNUR3M11FUnNKK53
         oXXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NPVqSyYahOrG9i7WDx5wohhO3rO/dLgDWLTg/Id8pKk=;
        fh=bUGXRsbdrkZrbHsYrpL4FcjfWRHeWHcq+abs5ewIlcc=;
        b=aE1RMo4iDGbHo0LU/K1fjh/qldto/xM7VxwRq6MPUJ2nC7AGqFCuZzpTq9mO9bQ6N6
         AD0EhDPSjk0rff5bVa0df9+UcNKZuMOV+n9y4321SMWlzPtXx5JRx5MK+C0aCF4KhWlr
         M6OI3peTf1WorBFzy4Lh9brOHW+hg8AaUaarEWa92NV3CAbDeQR4XbitRoMXPkmcs5Hc
         U3SnJ32xuUdXRNKunsNOj6qIubrSGP2fMXuWrgV0bSbTDr1AzfPMO0+MOmNrV8+49ixJ
         i1nSPPEZpvALFn8WnJGYjzozoPA03QsDassc+yEQKoEyVmyI1eAUQSyH6ZBUwlgDde0K
         jVDg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788581447; x=1789186247; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NPVqSyYahOrG9i7WDx5wohhO3rO/dLgDWLTg/Id8pKk=;
        b=bPRg8ZniKQqQdMsGO0SVIDQ1Cq1ueNE8rZ2vOqU9a73MHsd/tY5R7UH0hxlBLqG0FJ
         iLGt4lxGGNtqyzURDJ0jSApMeyov06lk0GkH10TZ03OtmFfPFihv+NtMW/ag1wlRjjCa
         TYxBSVfLLmpE9o89w4le/Bjh7ZO+eMssy8aYYGpSpV73xH1WXsp0huZ/BvLebTnx8LPo
         utHrOBLnGENV/aOUwzVLaag/3BXfBFrd0CJFJxOVPobNGQDHRrz3EpsDhZyQ3FBgT+gb
         VFuk8bNgr5eilqlTpviooCm70v8NcCZkqcOCXZoh2ljNCC9ROT1ny74ef/cA+8t992Iz
         Ppsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788581447; x=1789186247;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NPVqSyYahOrG9i7WDx5wohhO3rO/dLgDWLTg/Id8pKk=;
        b=HkB+ee99H1ZdbNSQgvjKZWQpYfHZAPdn+NToeVQRmeLxBLscazZ3aO4r/kvigUAdN3
         VZVNfHoOUyiLD0sOG4K8Lrt24WZHiWqZ5X0n9iZasleVpUwL6yajeM+K5WA/mvVBRHH4
         fFiuOHSzJSmmhIG698RKz25wZnSZ0pwQG19P+RRpQYpR5K/0IaiaFPWE/QC0iyeI4sf7
         tXMjMHUtE5Up/U0/eij7nekOzHXJQg89Qj8j5eTDIdiVa414gpGXHkePQ/cU85dDVzW6
         JBuJtDnoKJcagWF+0DIjKKqb588YAYkhfF9t+5rIDD+qWqvAoTNLoBtcOQjMa4VdJzai
         m1wQ==
X-Forwarded-Encrypted: i=1; AKwUvBxccbZI1oN+pro3NbCWfq9mKXLsI4IUzqw0V3UtsLW8+gevZ/kC5QM56BrcehfW32x/s0TM+BthD6sSGsX/2XY=@vger.kernel.org
X-Gm-Message-State: AFuF++l50kMU7KX3OnY0kpfKtil//2tPydU/zXhlIy8QQhUtbT8PYF94
	Ubpm+6GeJaVC8wvwAynNy6UEKbhalxVhHO3FK3kMd/BiEW7lzGYB7IaKkzY1T+OvkhTLMEt1fN+
	a6ZkcRw2rccbWMU13+R+wE0Sm4bACuNc=
X-Gm-Gg: AYBFou3p/+CLOITGPnqoM3xQNjHbjZjx1uCXQ5J7jT5pFcpc5uLj4jPkfqangQnGuWk
	CfvSpLhw1SxnHzsG3S2x2k+1igsEKp4mWf7KBs0ID9jxzkH357AldvtOxLQE3nmQnGSjje/5Bjr
	p3zwh648wF3aoSXtu4bpGTg05bEuV3P3SMPM5qoD7P8X0pNH/DschkQ7XnF5RpQeMJe7+fjK2Gc
	84gMO7abx4vtoBqZvMTPU+GqnEbS5W+TTJ4eeR2oMsUbrhZwhoiqWP5omzZ1dhebfFebWq2pFUp
	E7BNhBzSAdzshG28gtTl1TGN5JR3krXMWAYWjhn0pqeR
X-Received: by 2002:a05:6a21:1b85:b0:3d3:adbf:7779 with SMTP id
 adf61e73a8af0-3da3a0af14amr15170847637.21.1788581447401; Fri, 04 Sep 2026
 21:10:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1786933680.git.rakukuip@gmail.com> <b139065e9f62868ac5ed0900faf1dcd13c7e68f8.1786933680.git.rakukuip@gmail.com>
 <aoQwbtJ9vHfFb8Fx@strlen.de>
In-Reply-To: <aoQwbtJ9vHfFb8Fx@strlen.de>
From: Lain Anc <rakukuip@gmail.com>
Date: Sat, 5 Sep 2026 12:10:34 +0800
X-Gm-Features: AcwNN1X7d1up9bq9om48o_mNYyzBBdP6SaKt-ULK7UteGbOYltIdpns-GM0dIao
Message-ID: <CANZytUzcDW1XpptiTKEzMuDTw2WAsDCYVMSrugmDWndf9CgWvw@mail.gmail.com>
Subject: Re: [PATCH nf 1/1] netfilter: xt_IDLETIMER: validate label before
 debug logging in checkentry
To: Florian Westphal <fw@strlen.de>
Cc: Ren Wei <weir@nebusec.ai>, netfilter-devel@vger.kernel.org, pablo@netfilter.org, 
	phil@nwl.cc, davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
	pabeni@redhat.com, horms@kernel.org, luciano.coelho@nokia.com, 
	kaber@trash.net, quic_manojbm@quicinc.com, quic_subashab@quicinc.com, 
	vega@nebusec.ai
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Florian Westphal <fw@strlen.de> =E4=BA=8E2026=E5=B9=B48=E6=9C=8818=E6=97=A5=
=E5=91=A8=E4=BA=8C 18:14=E5=86=99=E9=81=93=EF=BC=9A
>
> Ren Wei <weir@nebusec.ai> wrote:
> > Fix this by moving the pr_debug() calls after idletimer_tg_helper() has
> > successfully validated the label string.
>
> I think it would be better to just zap this pr_debug, I don't think it
> provides any benefit to have it.

Thanks for the feedback. I see that Pablo has already addressed this
in commit f43358489db4 ("netfilter: x_tables: remove pr_debug").
Therefore, no further v2 is needed from our side. Thanks for the quick hand=
ling.
