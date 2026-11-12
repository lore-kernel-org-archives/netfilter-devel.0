Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.178
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794480579;
	b=ow5V0zVDoM+GgFKohYGCBwXQYsxuRD4rNNP17M1udGUV22XBiYIOcjNUSJNxwfxsPmLM
	 xtJvyaqJLy7sQpmycRBWwNvq8biufx1F5nrC8ydzdtSQ5ZLBsin2EgqsqOidhXlP1y3dD
	 CXPLH7v/WVzzzRFp+2NSje9iclBGI3feR7Okepgg3N6N1Zr4g/uP/HdeQK//Y82zi8piV
	 GJYBfx0SWx2z2pLKVzOgfRwCcHkBkO1aY2f/EO0WlsfZBcwEIast7inUTQgJHA/UzOJli
	 VPHNPVvfLBNbFiAiH6CYFsGSqCK/rhFzf8zIpofwgnux/m/Kf1Oidmf8e+EpaFaDIww==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794480579;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=FEtDWOCZqPhjvsvxprvXZxQh6BiXZmmXMKDopOlOztk=;
	b=aevpsO62HJgztYpm4UmP/+9g5gFEYcfuaP1jvk2K6ois+7VNbfIGkREFwJTqDbmO9kd7
	 5Ay+LXSwNyCt3La/WFaWD/SPHmrCZZCQBArrMvUr+X8tRkWxQmUegWy9lUGUuAPcOCOBt
	 HLmbjkuRjVbfnKM4iqBi/E2AD60b/6b6Pn63HtRfrbLnBf97iI1uwXu2X12veGTIpx9xn
	 AtFtr/XIFb+dyqRxgJn6TR/UYqv1QTSlEerjBDoDvdsdFwBQdxrBJwOoLMzwqJoRNq0Fe
	 FejfUj1TLofIUkdj8a8XoMC2rlG+08Kofdy89ehLcx/0rT2Cz3KAC5DbiofhzmSktTA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=mojatatu.com;
	spf=none smtp.mailfrom=mojatatu.com;
	dkim=pass header.d=mojatatu.com header.i=@mojatatu.com header.a=rsa-sha256 header.s=google header.b=Tqj5nvAp;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.178
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C0E606A31C
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Nov 2026 10:49:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 44C0E606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mojatatu.com header.i=@mojatatu.com header.a=rsa-sha256 header.s=google header.b=Tqj5nvAp
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-8a60f90a924so1711053b3a.3
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Nov 2026 02:49:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794480578; cv=none;
        d=google.com; s=arc-20260327;
        b=D9LqXtO6T6XvEWDg10cjHFql5syBZHRB1Nv59FJxLsiXOljo/4x/JlJsZp04RyNHvt
         fDRexkYlXYDbRpdRursY/PEldZnkA92YGArxHDgIvb0CuJrRosmKr+k3HUjUifo6OP5l
         eLHfTYxdeP+aex2+q+6y/WLkmeOSiXV8N1AJEvrQAvIUEM+1d5PKUYd8AcP2oAcL5HVs
         vfv88IGjc8mDpU4FBKJMlm15/El/8Tg5qk5QwFu+bBwHcgkz7Yzh2oDT3efJ27VaDUod
         iPawOzwbRUpZvsHNjyVmRvz+msFx4tEUV42mCOR7sL0YIg6/qEvJxcEUGTAU2/OnHsQq
         EhDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FEtDWOCZqPhjvsvxprvXZxQh6BiXZmmXMKDopOlOztk=;
        fh=C/UZzN04XM6FdsZ1AJjxbmH7ca+Oi1XbmUml/TcMOA8=;
        b=BhqcXn/puyCWPXRHKeOJlu0wSPwt6HEQ/VafMcVu3bA1FchFBzrMKRs8wOsjHtDlXq
         iBgVCQN9qT1Z+QR10kt+jh7wnQkNihbfwscLR2He0Xtq3KGf3sCx6KwB8kXjdMEm0p3k
         abIB2xypA0meEI6uuopN0nnTp+3gPCVUkbLvWPgSxZku8A9+6LzVGkiNYJaMRYGeJ9CX
         +lLYlAGPZ9kvSrxJHTap84NAJh5IYbKHQI81Wqz1iEWf3gXkvId2DFV7/wqXLD2vVKcZ
         N8ds+x/21HzckHh1D50mDtdaQtLL8EJilVUKo68h4T0okidLy38uDVcCP1PbAvXAI05J
         n2Lg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu.com; s=google; t=1794480578; x=1795085378; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FEtDWOCZqPhjvsvxprvXZxQh6BiXZmmXMKDopOlOztk=;
        b=Tqj5nvApRnLaXKJqnt1MtDcVgtOxG9b6FS3RhbrQh5OZklRpQEZx6UBwMAO9PmjJvf
         ArxcVMnUGE12W/1CQHNBzLA8ggTDyzZy+qk6SjvayMiejqah/j/hEhrJJDpdh8BtWUGI
         J9kO4ui3tsJ78QlVZXP12CxS4RXKWeUwe8wh8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794480578; x=1795085378;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FEtDWOCZqPhjvsvxprvXZxQh6BiXZmmXMKDopOlOztk=;
        b=OWSUNssxmi6p1sygxdMy8ZtshxApO8OmwzVZzXnpPjFjQ/Mw8HVcYhgk1e34tKo5Yd
         0p4cVpUPW/k5p+gZBGBZXLqeS9xCvRXo1v3FQR0mFzUF19HRF9m1i+iginKv02AOwJZM
         9uXPzSAsJVrL23E+FogSBrHBlB/I4HBTRRUgupkjx/nA6zCfHY4g4FQW0/flQzc/hpV1
         Kc6rJolTtk3pMfwDazO2EgLp5qVPW9zGdaGqznGC/eHD4Yv01P6iAt7OuZTriXh6VoYb
         67BS3IkVJkhK6+iKILSBr/xRVwUpFaDuq6LPDaj24XeZq/zWhSFgIx5edXNrjoWTv5dx
         hOXw==
X-Forwarded-Encrypted: i=1; AL+hErF424mb7yYH8E8K6LagfkZsAV4VmYJR3QlkLuReTZFEbmPrGWXPDjBlzc8zeMDmlgGTDi0hJ3/rWgoKZiiFgK8=@vger.kernel.org
X-Gm-Message-State: APuU4Z8U13OOhHfI6WZaBg8zVvoOcqMiO5BpYCDYsEbH/LIWf4Yq71y5
	kTXMywgbxRGGo1rDoBiBlTkv8iFRFKXLoOkHj19jaKIt+WHIi6kBIlP9Y1KcAFHP+AovsnJSvgh
	5i79HjHKxNXrpy+69MFSJyGvymzImul6Bo+xFekhU
X-Gm-Gg: AYBFou0V1fjGQC30iihE+3vYjQNyalOVqmWnMsvT4DUJRXa2E/TdF4L9/mgGuGCKRhg
	KRe0eMp/pGTLJ9cNitmsJdiaJSWY1EMbYwgckhWm9OzM8c+wUFPyyquBi1BY404SLirBIGdmIqr
	NnvX4G6hCNQrpXLJJXdxATWY3hP2i5wE/eGXx4mulPvJMAmuo7obx/F/ENenEKK56Ti7M3HuhCQ
	qINdS21SlFEakjDr8PYAP6Ern0TJMCgOcgVwWAF8FfcQmhlZwl1nR6Qq7hQuyQ7wPm1SZhIwnS9
	JbjyuB3BlQ3fjHy+HrefsPKkFOs9ws6kAnFhjQIXKkptip2U3cKqusozrp9vJO4IhUB7wo5VuA/
	qeAaxibQgIq9yi5DuL60PlBRSJQcXX5WGgYJFGr7jpCSzULPViYzoNr214AC+j8SglQ46BTOO3u
	l6aOJuHn0HBDz8N79L3wyHTCVJR+xvbn0/GwH0
X-Received: by 2002:a05:6a00:1c9d:b0:881:e266:c3c5 with SMTP id
 d2e1a72fcca58-8bc19dcf4d4mr4999096b3a.2.1794480578075; Thu, 12 Nov 2026
 02:49:38 -0800 (PST)
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CORE-9NOG.v1.r0.20261111073528@mojatatu.com> <CORE-9NOG.v1.r0.20261111073528-1@mojatatu.com>
 <avTfQjFQYR2NNdRg@chamomile>
In-Reply-To: <avTfQjFQYR2NNdRg@chamomile>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Thu, 12 Nov 2026 05:49:26 -0500
X-Gm-Features: AclHuK9omPXMn0HkBh9zI32g8JDs_xDABa01ADFsm-x2ufsLQpfFXolnA1YvCdk
Message-ID: <CAM0EoMm3hK1P_-gTz9R3oo528t_rqfX4BWfJN9odCdm27iTtww@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] netfilter: nft_fwd_netdev: drop the stale
 dst when steering to a device
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netdev@vger.kernel.org, Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	Victor Nogueira <victor@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>, sashiko-bot@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 11, 2026 at 4:33=E2=80=AFPM Pablo Neira Ayuso <pablo@netfilter.=
org> wrote:
>
> On Wed, Nov 11, 2026 at 09:16:37AM -0500, Jamal Hadi Salim wrote:
> > This is a followup of the review of the teql arp-queue fix as reported
> > by Sashiko.
> >
> > The issue: the neighbour variant of fwd rewrites skb->dev to the
> > configured output device and calls neigh_xmit(), but leaves the skb's
> > dst untouched. If that device's neighbour for the configured nexthop is
> > incomplete, the packet is parked on the neighbour's arp_queue while the
> > stale dst still describes the device the packet was routed through.
> > Draining the queue re-looks the neighbour up from that dst, so the fram=
e
> > is built with the routed device's link-layer header and then transmitte=
d
> > on the configured device. The packet leaves with another device's
> > addresses.
> >
> > The Fix: drop the dst before the device switch. Both lookup inputs the
> > neighbour transmission needs, the device and the nexthop, are supplied
> > by the rule, so the route dst is never consulted. Without it the queue
> > drain keeps the parking neighbour and the frame carries the configured
> > device's addresses.
> >
> > Conditions to recreate the bug: two network namespaces, A (10.10.0.1/24=
)
> > and B (10.1.0.1/24) in one, their veth peers in the other with only A's
> > peer addressed (10.10.0.2/24) so B's nexthop cannot be resolved by ARP.
> > Resolve A's neighbour for 10.10.0.2 as permanent, then load this rulese=
t
> > on A:
> >
> >     table netdev t {
> >             chain c {
> >                     type filter hook egress device va priority 0
> >                     policy accept
> >                     fwd ip to 10.1.0.2 device vb
> >             }
> >     }
> >
> > Send one packet to 10.10.0.2. It is parked on B's incomplete neighbour
> > for 10.1.0.2; once that neighbour becomes valid the frame leaves B
> > carrying A's source address and A's neighbour as the destination.
> >
> > Reported-by: Sashiko (nipa) <sashiko-bot@kernel.org>
> > Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/QDISC-6HS9.=
v3.r0.20261103062649-2@mojatatu.com
> > Link: https://lore.kernel.org/netdev/QDISC-6HS9.v3.r0.20261103062649-2@=
mojatatu.com/
> > Reviewed-by: Victor Nogueira <victor@mojatatu.com>
> > Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
> > ---
> >  net/netfilter/nft_fwd_netdev.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_net=
dev.c
> > index a48c2f765bba..ad4d61d64cdd 100644
> > --- a/net/netfilter/nft_fwd_netdev.c
> > +++ b/net/netfilter/nft_fwd_netdev.c
> > @@ -175,6 +175,7 @@ static void nft_fwd_neigh_eval(const struct nft_exp=
r *expr,
> >               }
> >       }
> >
>
> Does this need a check for skb_dst_valid()? I think it is valid to
> attach a template dst here for tunneling?
>

You are correct (I think you mean skb_valid_dst()). Same guard needed
with the second (ebpf) patch.

pw-bot: cr

cheers,
jamal
> > +     skb_dst_drop(skb);
> >       skb->dev =3D dev;
> >       skb_clear_tstamp(skb);
> >
> > --
> > 2.43.0
> >
