Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D47038645B
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Apr 2026 21:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776202566; cv=none; b=HGFW4gA2btl41X3yO1i1CA2f4FRnKOKjFO98XxrXUEhkUzK+6gti91ykaxHjbmJuVvr3/90iqDgMDiQwJYifHLAh2EvBLf9scVZvQ6mMAbwe7AsTiMr+CnMPJSAeU16UreMCUZ0eUqf64hwqexxKvizlyMTqzjQIkdm6Y7GlkGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776202566; c=relaxed/simple;
	bh=0TMK6TPj2I/wDCZC3TKkkZR0vWPLJmtivYg0Oosnwbw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fhDuFPrgJWIcnNk935cJKJ1D3jL5Tl3QgsrGJZMGSnKEaq5+g2AsqthqNWKN37+hNX7blOtDecX5RC20k25bh6It3tF5tyoSxf56NsV1w+GJL7jTCMlBtKrL2XKWEFYT/ZfOIPzG6g4c60uzYE/BvQam3FEyBtkH0weOhBOz81c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CKD8hswe; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CKD8hswe"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b932fe2e1a7so839516766b.1
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Apr 2026 14:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776202563; x=1776807363; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:sender:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FVfeBwiYFSjucW7g9phomZssZLdfk3en30hBBiRPj+E=;
        b=CKD8hswejFyJ6d0NueXf5SrY2Yru5vKmq1YraCdrqWMGZ5QF9ZBSbEc279u+bQiLnc
         kGxpfO9QKdOMSHYcToyrJPtArAGDMKUl4Jo7tsW0PnZMofNm+l6YFrsdugfd6zYx8ssK
         wb7/b2h6z1kV4DZ/x/TIlQvF1xTsZ0lwXm2blP9MZN4vKJPt2f2aNFylSI0bmuocRudm
         i1+LXDCBFrMENaozlHJ8G4mSNIwyLscbHRPsUkPzG1xqeY7k9UoKq/KkpdrWF4ZelLMd
         x+pDvgFcyMF2ACMHFQsVRH8/BU2Ke4C475Fm+7hv97Z6Nxj26rseVMTqCedYMWKGLXjN
         S4Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776202563; x=1776807363;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:sender
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FVfeBwiYFSjucW7g9phomZssZLdfk3en30hBBiRPj+E=;
        b=Tdowba3YgCK0NYSyuSWt7oyD2HFyYTVnhC81Lw5pftgtA9SgH8Feoeq3nHcupDRSdM
         4k3tmVityTvBmQHkF6PH6OZfFTYJOjRvxg/JJS/5emoc+zM0+03/Al3rLaJM+zajy1QN
         o+p0N/aEHYQE70cYO3UpM7ZoOcdcrazCa/xRxutWTayMWOzbUlRWSM2KUPpu2slsNFNq
         9G84j/kuT/jEQobNCtZOKcvNmakQ2LMyGpjCA/S331/cuA8rB8/BcKULAhUNTiwWq0++
         QV7S6jh6pMoMnTvQOAgL1AW7dk2Xkl07yCW3i+8adZpcSHDECfj+9L6WtI+G7HlPd42Z
         wZ4w==
X-Forwarded-Encrypted: i=1; AFNElJ8jRluqBTpJGoeH9olPwJIUkhLcVGMUmCZAlxxsz1iaWzujrb67PuA4OXWgUGt/H91hTK3czQannR4fvGvPxaY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8aFNa8c8kAWzRLlasFX8vEMWyuLjmWIwc96nJnqnpjyzmd8vE
	YA5jmS3S/WxTtygaBT33/fUI+LE1BuAcFu3Gng0nXSQHy3VasQXSZswU
X-Gm-Gg: AeBDievffptfMhKCjs9hbuz9t7moAc0nkHCjKjsw2ROB9+A0BEvoo3Zc1utjNbCPYOM
	UQvNrevsKcUbDIpHwptj21OMwlDvPBdB13TpEgZYo3Y7C0fNIiHSNSAeLEViFiprxdXpIUbhByk
	fi572A8ZNApEnl0MaHq/0dv1s7mlYV5Qp8svIHt/ZMTi8FQEsccPzrHVifPb+OOVnH6M/DPSkJv
	omLl+mwB7Nhlmvf+bJZMbaA38wZ7B8xiULu8FcQcxYV/XCm1zb5nbzp+nV0gRkxOg5RQFMQ8JST
	0diz7D9pKSoDocyJj6ZIdDF/qiqsBExry82wPvK1JUabMnD3CCLf1XvsvPuPj3qIkczScQ2uBWL
	AsAFULEx1uCGyq92y/bAHXYkc5sjLKluH7iiZvP2UFdQ4pCvNJyWJveP+j94AUOrHHed7G76+Bq
	HJYCyLlW++KxETGi32W+OFRhTtu9OfETp3bBrmMsDLlZo=
X-Received: by 2002:a17:906:6a03:b0:b98:48b1:b129 with SMTP id a640c23a62f3a-b9d727969e8mr1203629666b.47.1776202563125;
        Tue, 14 Apr 2026 14:36:03 -0700 (PDT)
Received: from 127.0.0.1 ([94.41.86.134])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b9d6de8d709sm449315266b.8.2026.04.14.14.36.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2026 14:36:01 -0700 (PDT)
Sender: <irecca.kun@gmail.com>
Message-ID: <e6d3dc64-1714-4105-8a38-3942c62d159a@gmail.com>
Date: Tue, 14 Apr 2026 21:35:59 +0000
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: The "clockevents: Prevent timer interrupt starvation" patch
 causes lockups
To: Thomas Gleixner <tglx@kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>, Eric Naim <dnaim@cachyos.org>,
 LKML <linux-kernel@vger.kernel.org>, Calvin Owens <calvin@wbinvd.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>, Ingo Molnar
 <mingo@kernel.org>, John Stultz <jstultz@google.com>,
 Stephen Boyd <sboyd@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, Sebastian Reichel <sre@kernel.org>,
 linux-pm@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
 Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org
References: <20260407083219.478203185@kernel.org>
 <20260407083247.562657657@kernel.org>
 <68d1e9ac-2780-4be3-8ee3-0788062dd3a4@gmail.com>
 <aeb848aa-404a-40fb-bd41-329644623b1d@cachyos.org>
 <ad6BtKRj1GyreNCS@localhost.localdomain>
 <a3ac856c-914c-4b39-949f-634bed501e7c@gmail.com> <87340xfeje.ffs@tglx>
Content-Language: en-US
From: Hanabishi <i.r.e.c.c.a.k.u.n+kernel.org@gmail.com>
In-Reply-To: <87340xfeje.ffs@tglx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 14/04/2026 20:55, Thomas Gleixner wrote:
> The one below should cover all possible holes.
> 
> Thanks,
> 
>          tglx
> ---
> diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
> index b4d730604972..5e22697b098d 100644
> --- a/kernel/time/clockevents.c
> +++ b/kernel/time/clockevents.c
> @@ -94,6 +94,9 @@ static int __clockevents_switch_state(struct clock_event_device *dev,
>   	if (dev->features & CLOCK_EVT_FEAT_DUMMY)
>   		return 0;
>   
> +	/* On state transitions clear the forced flag unconditionally */
> +	dev->next_event_forced = 0;
> +
>   	/* Transition with new state-specific callbacks */
>   	switch (state) {
>   	case CLOCK_EVT_STATE_DETACHED:
> @@ -366,8 +369,10 @@ int clockevents_program_event(struct clock_event_device *dev, ktime_t expires, b
>   	if (delta > (int64_t)dev->min_delta_ns) {
>   		delta = min(delta, (int64_t) dev->max_delta_ns);
>   		cycles = ((u64)delta * dev->mult) >> dev->shift;
> -		if (!dev->set_next_event((unsigned long) cycles, dev))
> +		if (!dev->set_next_event((unsigned long) cycles, dev)) {
> +			dev->next_event_forced = 0;
>   			return 0;
> +		}
>   	}
>   
>   	if (dev->next_event_forced)
> diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
> index 7e57fa31ee26..115e0bf01276 100644
> --- a/kernel/time/tick-broadcast.c
> +++ b/kernel/time/tick-broadcast.c
> @@ -108,6 +108,7 @@ static struct clock_event_device *tick_get_oneshot_wakeup_device(int cpu)
>   
>   static void tick_oneshot_wakeup_handler(struct clock_event_device *wd)
>   {
> +	wd->next_event_forced = 0;
>   	/*
>   	 * If we woke up early and the tick was reprogrammed in the
>   	 * meantime then this may be spurious but harmless.

Ok, it does fix the problem! Thank you.
The patch itself does not apply cleanly for 7.0 though and I had to adapt it a bit.

