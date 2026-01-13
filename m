Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CDF23019DA
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Jan 2026 06:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768285230; cv=none; b=Z4A65RnKZIRoPzgCCRn7BP9280xBcEfJAxBtFwWo7kugZCZsUfUmwIY/NVwj3n3idufPnjvdiagJbvrzOXb9LoeF8QyZEq+J7HwG5u8BLxshhsyGdNlvyin8O2uUd2kcKgcOb9QSjNiUWHnzmgpJfM/SoqJ0lcDhIyZIsgXV5E4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768285230; c=relaxed/simple;
	bh=wCB7Qgvlxm8kjbQcp7dMePk88omGQti/GWMRHOWyOsQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s4vAUcEL01OMEuRiIrqeHtxFyPixZwcEG1vxPXZRClTH3EXfcCgAJVM/pEUlMl55Ahf3B2weVSj3nVChXprAw/9Lm/Vd182dC1wCR2KpU2pt+H61/raDoxq8cu2VhuQa9icBfaNDcDV9kOHYbTYoRaB1BMnCCO5nZddSNEd0SdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=networkplumber.org; spf=pass smtp.mailfrom=networkplumber.org; dkim=pass (2048-bit key) header.d=networkplumber-org.20230601.gappssmtp.com header.i=@networkplumber-org.20230601.gappssmtp.com header.b=l5xoPLo9; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=networkplumber.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=networkplumber.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=networkplumber-org.20230601.gappssmtp.com header.i=@networkplumber-org.20230601.gappssmtp.com header.b="l5xoPLo9"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-47bdbc90dcaso50566965e9.1
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Jan 2026 22:20:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20230601.gappssmtp.com; s=20230601; t=1768285226; x=1768890026; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+5c6uNihQYtmaNA7ilYqerYKnx3q5lMZZF3n4+EDPoc=;
        b=l5xoPLo9LrgtnMLu8vGTAQBhGockQbUu6+RlvBwgsg90XBWSH7p7W7ZW5z2MqaBNeW
         7X8fx8VNGDD33jVluQINpKTkwkKI86AdqhlVLex2J1r0dy5Awyb87sWRv4jq2wamRSNB
         UeTYPLxX0RZAvikFuBAHVHhme5cTMkV2TI2to4haxrYMW7s3ZpRViwYgTYJgyLJ5OB7s
         k+idq0L2NJ6tbCOwV4gyVjpat5aZBL/1hiYEuefLFrZR/D3K6Fz/K8XwTZxTCyL4+2Ox
         yMoUPBdUKtEKN+qSHonomAp3oBmrhE1oCt1LH+nwqOicZ5jLu+z6DGOvH+VsdwrjZj5n
         2BhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768285226; x=1768890026;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+5c6uNihQYtmaNA7ilYqerYKnx3q5lMZZF3n4+EDPoc=;
        b=wYEGrjt+Gm+rFqFN+jsdZmE1di9BCag/LHr8yTLatye2SS8GUuT5oRKf9nVmFoiKTc
         T+hEvQYHWSfa22WmmWlzoprDaQau6fRXFB6g0yigQANqBTJQDa0m6qz4uyS6dpRprofY
         E0BFgChFwPpDd1haS0xY+2kl5oJOJZ06ksLKqgW/6/o9ZlcSMGS4F/rVtwyABoS7Jebe
         tW8sX125wuxe/21MisOdZBxVi6UuvSMFuZzNT+PyF1rQchnvKsxS/vaKCdQBWWd9nk7e
         PCRHfTTZBoacPXuXByp/6PD7LxU2uAI91t4hRWVD+LxJEjbMRI2qeQp27rLX93h/rCnF
         +RNw==
X-Forwarded-Encrypted: i=1; AJvYcCXf2xbHlIiOCoJ/Rt9l+HktAElACRi8lQuRSZtzCBB85bqZ+dhKmswiOaBzY6a7ZzlCUtuYFeEymhhQa2vBoU8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyM0XkuMyyOKqno/BqwNP9vIpMWgQr3NKKDmJ/w3DCWKoTYbjsn
	v7/F4uwi3TouH6s/Fr6rqXW9V26RFu0fS2vfOBEHp6y1LnRkUTJY8+sjft5/TFspsII=
X-Gm-Gg: AY/fxX7gioip16nC9a4+tBRWJGpH8xlsm/vR7SfdHHTqYbzKInX11gqc9JnkyjvWpC7
	rNCLfhw9oTaaMEYnT6nmEhnJC8Gukx5Z9snV2xe25R21mAtya7Ji+nnEp+xaHwT58R/Iqof+aUF
	m72fUE3HcDm18W1KbA2AXnio0xJS2fAp4W8eTTaEjIv+X1wpVwkZdSwCIh5W3zoEzfVi+trAb+u
	GFbZ+2cZJmaveWkWiV9qKOSDzjyhMjdkRqFblMOMdAXfbeDNh0T7HvpW7ULiX9Dp1DPe8o5V83O
	4p5VdgEVcJRB49SEIABkR6Clu+7eU0NwXct/7OgSjigNjdfKphtnv6pfYJxR8f++BEutJuBXG0e
	czg5goRt9R5/uDQmj2jS9adqoNPKIMJhokQCPjthsA5TFIpU3bOvqULr3arIDWz0RqttIts/evT
	UHmT+SaWY0rNkA4NUj4107+K+k0dWqctCAFO87gpdR69dK1X10ZhQWWSHcGox9/is=
X-Google-Smtp-Source: AGHT+IEiWbsU2G7On+GlJQdRLa1I0QYbmcddBFpX+1V/SFXuq+KJVQQTG97s3EQDxxOc8KC7Hn8irw==
X-Received: by 2002:a05:600c:4447:b0:477:3e0b:c0e3 with SMTP id 5b1f17b1804b1-47d84b3b8b9mr216297115e9.32.1768285225735;
        Mon, 12 Jan 2026 22:20:25 -0800 (PST)
Received: from phoenix.local (204-195-96-226.wavecable.com. [204.195.96.226])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7f6953fasm378393495e9.5.2026.01.12.22.20.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 22:20:25 -0800 (PST)
Date: Mon, 12 Jan 2026 22:20:17 -0800
From: Stephen Hemminger <stephen@networkplumber.org>
To: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org, andrew+netdev@lunn.ch,
 netdev@vger.kernel.org, xiyou.wangcong@gmail.com, jiri@resnulli.us,
 victor@mojatatu.com, dcaratti@redhat.com, lariel@nvidia.com,
 daniel@iogearbox.net, pablo@netfilter.org, kadlec@netfilter.org,
 fw@strlen.de, phil@nwl.cc, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, zyc199902@zohomail.cn, lrGerlinde@mailfence.com,
 jschung2@proton.me
Subject: Re: [PATCH net 0/6] net/sched: Fix packet loops in mirred and netem
Message-ID: <20260112222017.3d1da4c9@phoenix.local>
In-Reply-To: <20260111163947.811248-1-jhs@mojatatu.com>
References: <20260111163947.811248-1-jhs@mojatatu.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 11 Jan 2026 11:39:41 -0500
Jamal Hadi Salim <jhs@mojatatu.com> wrote:

> We introduce a 2-bit global skb->ttl counter.Patch #1 describes how we pu=
ti
> together those bits. Patches #2 and patch #5 use these bits.
> I added Fixes tags to patch #1 in case it is useful for backporting.
> Patch #3 and #4 revert William's earlier netem commits. Patch #6 introduc=
es
> tdc test cases.
>=20
> Jamal Hadi Salim (5):
>   net: Introduce skb ttl field to track packet loops
>   net/sched: Fix ethx:ingress -> ethy:egress -> ethx:ingress mirred loop
>   Revert "net/sched: Restrict conditions for adding duplicating netems
>     to qdisc tree"
>   Revert "selftests/tc-testing: Add tests for restrictions on netem
>     duplication"
>   net/sched: fix packet loop on netem when duplicate is on
>=20
> Victor Nogueira (1):
>   selftests/tc-testing: Add netem/mirred test cases exercising loops
>=20
>  drivers/net/ifb.c                             |   2 +-
>  include/linux/skbuff.h                        |  24 +-
>  include/net/sch_generic.h                     |  22 +
>  net/netfilter/nft_fwd_netdev.c                |   1 +
>  net/sched/act_mirred.c                        |  45 +-
>  net/sched/sch_netem.c                         |  47 +-
>  .../tc-testing/tc-tests/actions/mirred.json   | 616 +++++++++++++++++-
>  .../tc-testing/tc-tests/infra/qdiscs.json     |   5 +-
>  .../tc-testing/tc-tests/qdiscs/netem.json     |  96 +--
>  9 files changed, 698 insertions(+), 160 deletions(-)
>

Reviewed-by: Stephen Hemminger <stephen@networkplumber.org>

This is a complex patch series so I decided to get a second opinion using A=
I.
It is worth reading (but not completely trusting). Review prompt is Chris M=
ason's
Claude review prompts.


Summary: Patch Series Analysis
Patches Reviewed
6-patch series from Jamal Hadi Salim fixing loop detection in mirred and ne=
tem:

Patch 1/6: Introduces skb->ttl (2-bit field) for cross-deferral loop tracki=
ng, moves from_ingress to qdisc_skb_cb
Patch 2/6: Fixes mirred ingress=E2=86=92egress=E2=86=92ingress loop detecti=
on using ttl
Patch 3/6: Reverts netem duplication restrictions (preparation for proper f=
ix)
Patch 4/6: Reverts associated selftests
Patch 5/6: Fixes netem duplicate infinite loop using ttl
Patch 6/6: (Email thread discussion, not code)

Key Findings
No regressions identified. The analysis covered:
AreaResultSKB structure change (ttl field)=E2=9C=93 Safe - properly initial=
ized via zeroingfrom_ingress relocation=E2=9C=93 Safe - written immediately=
 before readLoop detection logic=E2=9C=93 Correct - ttl tracks across async=
 boundariesNetem duplicate fix=E2=9C=93 Improvement over old q->duplicate h=
ackLocking=E2=9C=93 Correct softirq/per-cpu patternsResource management=E2=
=9C=93 No leaks identified
Design Assessment
The approach is sound:

Egress paths: Continue using per-cpu sched_mirred_dev[] array for immediate=
 loop detection
Ingress paths: Use skb->ttl to track loops across netif_rx() deferral bound=
aries
Netem: ttl-based dup prevention works across entire qdisc tree (better than=
 old local-only fix)

Recommendation
Yes, the patch is OK to merge.
The series correctly fixes real bugs (CVE-worthy loop conditions) with a mi=
nimal, well-designed solution. The 2-bit ttl field is sufficient for the us=
e case (limit of 3 ingress redirects), and the changes maintain backward co=
mpatibility for existing configurations while closing the loop detection ga=
ps.
