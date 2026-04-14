Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C4E318EF4
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Apr 2026 18:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776191135; cv=none; b=FfZD9UlOaegmD61M4lYEc1qfoToAt/vG4KDJTlxt//nHWFucXxORqBMMukOt2tseBQoxGWHWW1k6LO5uYAeG3hTFZB0UYTht8QZwr/y6y8i2XV704XckbSUb2q3IOlX1YcXgcb2nh8wxzhgHB+U/EAJx0dfIqZjV03YlTSXMjfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776191135; c=relaxed/simple;
	bh=G3w0DZ0WFidkPB/uPrbI9py6h5O7bcwpN2Dv7lkGGTQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jEDBD7VpebPNBc0MAZ82A3+oESqAikzsoqHopxJDQMCccu5LKLpMiXRbWsFSRTKdB78xCZ2eBkw7I3XsbAeGGyYtFpLotp3n5XT036iSl8nLOPbqvFgC2TryUc3F0f8uzVqoqxxmlZbjDJRPaQGGrUMIcNG9UaRah6SpemhBYsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ytag37WK; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ytag37WK"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b9b1ffbb9f5so829772766b.2
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Apr 2026 11:25:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776191131; x=1776795931; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:sender:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KPeEClNJ70HwQFmMmwRFDNn5+7Dvy+a0H3+D1LydCmU=;
        b=Ytag37WKLdbqkETC1go8+hSa41sqknKPK00yveQS2qYT1LiCo/j/KwYrjg2H6iatuU
         pkDk5rPhf10HFL7dtHqlw48wEu/4U0b6AIYYO1QChHcU7XK9yb9/QxbgJzA2AE3ELtlY
         KGYvLXE9EQe7/ybeL4Jh+zuPB6NpeQXoi7Gru2woEZDd7z4SPw2SJjEHMsT2W7oMQK13
         v/o/f5vDunRfIM/PMrFcuRtg05cZOFXRRGIGULmn/sougVse/toHSYm+puqRiPlTNO/C
         e2MhPpCHeN8e+sbzGpDxvcZfdNM3Bv7T2dNvJOB3oIeaG4a17W7hPKgboELXceXspSH2
         /0ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776191131; x=1776795931;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:sender
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KPeEClNJ70HwQFmMmwRFDNn5+7Dvy+a0H3+D1LydCmU=;
        b=Ej/8TwlwxdPbrgi8EGTbmmWy0kOI1mxRrHQPsI97ryzeEWf1bNtznqSzMYVeB2L8wm
         gbNlijETjhECU0X1mJOUKOypik7kvpxJNZ6RB9XOBaYivQqvWnEP+ivHIoaSJDfxnSnJ
         RSro3uhgfQEyPUzxn27ecqEiVsyJEV/FRjPitVsj0IgNGktSWtIZHwdealHG0q+BzX4b
         baYLAfGo3vpByIOo3NL9CdGCOi9+g9f29eXPnPWiJQfmtk63wzlyct5Kw770u0/0zE6J
         viT24gJ2kfCdBVGl6STfyCIx7i9FsE7hhKGpgfRzdMdNMF1cdT1uE2akouv+Lopmxbl8
         yjvw==
X-Forwarded-Encrypted: i=1; AFNElJ+nNfUBR7n7YzrHVM8MjWV5iNpvWqAIrefa7rcQ+7+XQSgmgbjMRsliBlsStvDbQBtjsorqmpPezEuZ/glSRG0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEM5ChvzIW2HxAuRFGUODqQ9spUfv9nf7hbJ+JPVvH/zI2MqWg
	BT0Y0mp+7sM8W8hR5yhQsBQb5Pgovmckjk1JM7hC3PuYFD8msJT3b1kC
X-Gm-Gg: AeBDiesMXOSp70uOugNBl4F9KzFYc+Cmu4/6eSB9WntRqW0Qt219k0kXcMi6BgCaHUc
	Vun/t3hhUit0P6rhCKcl27D66bMx5NrfaaEQt6Vos2a6qUkvN3D4ezpR/ZO7KygzYFJQC5Py41H
	cxBr/awkiorJgCHde+hUclVE6FaH4NYEExFixoiQoPFAQLD9CYbKFYvncpnQel6bKS3qhEKEaxw
	tPUMEgyNZdQgcSHlZr/eMNsPDrNC6LIuz1N0bHND+EmuLSnN3khCjelxAnGSpQSIhBYD+daknJE
	3XFyTMf0Mh6UW+uhW3/JymuShgGM38X7YwQJu+YU9NKTHlhP3uTd8B36EoysDz9tHbGkiVAzryr
	GciFmiRdARGNsOgdCQiKS8N+Ma2FNmx/mGJBk77TnAkzdgb9ufMGDCcE+RSlVfDHIEME+xEylvj
	XCq7nadYVIFH0cSMkeLjwvcOWXmgFasZniaf0OpokkdH12K2NMVYQl+w==
X-Received: by 2002:a17:907:3e0b:b0:b96:e593:fd1e with SMTP id a640c23a62f3a-b9d71fe2c9cmr952390666b.0.1776191131309;
        Tue, 14 Apr 2026 11:25:31 -0700 (PDT)
Received: from 127.0.0.1 ([94.41.86.134])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b9d6db92792sm413467066b.0.2026.04.14.11.25.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2026 11:25:30 -0700 (PDT)
Sender: <irecca.kun@gmail.com>
Message-ID: <a3ac856c-914c-4b39-949f-634bed501e7c@gmail.com>
Date: Tue, 14 Apr 2026 18:25:28 +0000
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: The "clockevents: Prevent timer interrupt starvation" patch
 causes lockups
To: Frederic Weisbecker <frederic@kernel.org>
Cc: Eric Naim <dnaim@cachyos.org>, Thomas Gleixner <tglx@kernel.org>,
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
Content-Language: en-US
From: Hanabishi <i.r.e.c.c.a.k.u.n+kernel.org@gmail.com>
In-Reply-To: <ad6BtKRj1GyreNCS@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 14/04/2026 18:04, Frederic Weisbecker wrote:
> Can you try the following?
> 
> diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
> index b4d730604972..5c6dfd6bed28 100644
> --- a/kernel/time/clockevents.c
> +++ b/kernel/time/clockevents.c
> @@ -100,6 +100,7 @@ static int __clockevents_switch_state(struct clock_event_device *dev,
>   		/* The clockevent device is getting replaced. Shut it down. */
>   
>   	case CLOCK_EVT_STATE_SHUTDOWN:
> +		dev->next_event_forced = 0;
>   		if (dev->set_state_shutdown)
>   			return dev->set_state_shutdown(dev);
>   		return 0;
> @@ -127,10 +128,12 @@ static int __clockevents_switch_state(struct clock_event_device *dev,
>   			      clockevent_get_state(dev)))
>   			return -EINVAL;
>   
> -		if (dev->set_state_oneshot_stopped)
> +		if (dev->set_state_oneshot_stopped) {
> +			dev->next_event_forced = 0;
>   			return dev->set_state_oneshot_stopped(dev);
> -		else
> +		} else {
>   			return -ENOSYS;
> +		}
>   
>   	default:
>   		return -ENOSYS;
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

This patch doesn't help me unfortunately. Thanks.

