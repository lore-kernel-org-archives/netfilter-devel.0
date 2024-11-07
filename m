Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB5720F5B9
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Nov 2024 12:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730983382; cv=none; b=r5db8VIiG0rnRO1XNEUjKoSSQmgn9W0SWIxTLHNWaoczKEMWOWc+4LJcMxP95xxt32HiDMV2o2KB19DZjlWAc65u1DtXL0BaZAHbQGANcFeeJFKN5mqjmLI837B/D7VHtmts0Ie7FqVSoXGCLBj+RBdUp41gCWZWlSOxuc0j9QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730983382; c=relaxed/simple;
	bh=/v6itHHmwpj55a9Ueu87me8eVNwUqqHOLNHMFGOvbe0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kw+uv1AOOgFhjsPkJmtp9RzapgY5K1ijeLM4EZGqVMzDdnJTkKfX0N8GTwWrva14biGJyJGi2x9pHuZ7HawUV1TNyYnlHmfkvwl37GdxnGohKaaWlrBF9YI2TVdJxGjgysKySb7HMn/YwpxzFJRPmnvT04aCR3YGOWOkY+WRRoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iHJZMKDi; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iHJZMKDi"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5c9404c0d50so1116033a12.3
        for <netfilter-devel@vger.kernel.org>; Thu, 07 Nov 2024 04:43:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730983379; x=1731588179; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/v6itHHmwpj55a9Ueu87me8eVNwUqqHOLNHMFGOvbe0=;
        b=iHJZMKDiKhXYjkYmb/AW7LrwPGJrHgzh0cBP4P1/Y9Juh4ORT4ZJKEjFzVtUYFlgKa
         Z5O6nca0tCY+NUdjLrnGwRFPB9XaXPUWox2n7fUt9IO2DXjPiD+Q4MOyXy2OUqzo2g7K
         y7N04z6bvnuqdtUDoVWyUxosJV1UEc72k1wmANExOhQJi53or261OUeskrrgZ6t9hYcm
         qa+MXwe/uqY+xfVhqBkpYF2ZLRNuFiLZEcRqrqdUdLpqd5LoRf3eqQPtBibPn5Z0IY9d
         BMIeG/Y5+6tc6mN12dS912a9q8+LKsLqu0J3fSd/eDlFMQ1Yxd9mV4wSpPIxFXBcRHLv
         ClvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730983379; x=1731588179;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/v6itHHmwpj55a9Ueu87me8eVNwUqqHOLNHMFGOvbe0=;
        b=jEgipMszEjT/CTemgX4rUQEPeUB+j2ADRiBozJu9z/qZ8cUr3SSqp8qXkzZVvWJnrL
         5SN7yQTluXTVIPUYyZWhL53V9Tqz6KU+SFY9DrSLWClAwfT3TEcLW3Pngs6d58iXfKhX
         pZPI2KePSFQJLojLl0uTTFiNQITW7M57W0tIyhzOCAmr3HCKfgBcCI37xss5cIarc8Sw
         ZsAupcQED3YFEyc24uKQabXdRms7FoIoWpVEoeJChRCI5StC9X2AEyM7b0c/oBNmiYtS
         JRvDD5Wxlz9w1Uxu3xB/vwuANgkRE7lwswUzbYSMDfWYoXGRYR7k0fSrEL23x5f0t1Jj
         TBpA==
X-Forwarded-Encrypted: i=1; AJvYcCVsL4N5wMeDooPJSt70jEGF62MMcMzLpmvj0T2BY71v0bmo7oYDVZ5Q+hZI7sR4d7ZcROzFTpEJCnYqaSpItT8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3tsDBGXezwlfbK0oQa0lmtGw/ZIfwZs4hdPzO2JfKOnE5tbvv
	9WYqaBXsXfgAzSJvsOmpbLc8j41mq4ffbfF7VVHiQRbIkrGPFi2sQatan09Bp5rt/SCmBkjh0rD
	HxJc3P03CX68EWNxWyfY0J68J5tKW2XpwQS+q
X-Google-Smtp-Source: AGHT+IFKf6zZ//WCw5XMeJTuoFw4Owv0wF+FRy01fL8DSe79ySBpTLQb9HFtlA/iK5UJCkaX8LOlbT1jyjeJKZv2HS4=
X-Received: by 2002:a05:6402:3491:b0:5ce:c925:1756 with SMTP id
 4fb4d7f45d1cf-5cec9251eeamr12190654a12.6.1730983378900; Thu, 07 Nov 2024
 04:42:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241105100647.117346-1-chia-yu.chang@nokia-bell-labs.com> <20241105100647.117346-11-chia-yu.chang@nokia-bell-labs.com>
In-Reply-To: <20241105100647.117346-11-chia-yu.chang@nokia-bell-labs.com>
From: Eric Dumazet <edumazet@google.com>
Date: Thu, 7 Nov 2024 13:42:47 +0100
Message-ID: <CANn89i+t0cJ8Ah5rYMh0B_Js-ynrsHbWpKsT3WXS=OcYqsYN3g@mail.gmail.com>
Subject: Re: [PATCH v5 net-next 10/13] tcp: AccECN support to tcp_add_backlog
To: chia-yu.chang@nokia-bell-labs.com
Cc: netdev@vger.kernel.org, dsahern@gmail.com, davem@davemloft.net, 
	dsahern@kernel.org, pabeni@redhat.com, joel.granados@kernel.org, 
	kuba@kernel.org, andrew+netdev@lunn.ch, horms@kernel.org, pablo@netfilter.org, 
	kadlec@netfilter.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	ij@kernel.org, ncardwell@google.com, koen.de_schepper@nokia-bell-labs.com, 
	g.white@cablelabs.com, ingemar.s.johansson@ericsson.com, 
	mirja.kuehlewind@ericsson.com, cheshire@apple.com, rs.ietf@gmx.at, 
	Jason_Livingood@comcast.com, vidhi_goel@apple.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 5, 2024 at 11:07=E2=80=AFAM <chia-yu.chang@nokia-bell-labs.com>=
 wrote:
>
> From: Ilpo J=C3=A4rvinen <ij@kernel.org>
>
> AE flag needs to be preserved for AccECN.
>
> Signed-off-by: Ilpo J=C3=A4rvinen <ij@kernel.org>
> Signed-off-by: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>

Reviewed-by: Eric Dumazet <edumazet@google.com>
