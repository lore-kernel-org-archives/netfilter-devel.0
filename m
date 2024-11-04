Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA6321B3959
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Nov 2024 11:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730718593; cv=none; b=XETCaZXnzEvajyZZ1GCfHbJCakJPrjvSXgjoGjhRvHNoWXMzpqatjXDyNWKHYvI6YpniPQ1iQz79DWHMFRz0H/NM2STPLdG5FDOGC/Ay8gQS/mStPc9oKs1u9Vy8a7qrURy90KKH0SWjOx+GLR0adNM/ZSS80BePyaWU1ejHHl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730718593; c=relaxed/simple;
	bh=lUuUGUzmWxiiE+AdbDx4NddMn/Sm1GUTVEG9UTHvf2w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i8pGQRnHFLlTFm4ns9KuuywQAjLlItxJr8XSMlDSJpoloyW/xKuUNPRzZAstVuxWBp+U9it2nrjkUHVGzhMmvLFLXs42onYr4l1+2lv+zVPsRj9w8z/rdvbpI0hhbPpgv3pmvpLunVydVpxjkyouDyw3xapZQ7wl006M4oo08UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L2I5cuo4; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L2I5cuo4"
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3a6bf539cabso5544295ab.3
        for <netfilter-devel@vger.kernel.org>; Mon, 04 Nov 2024 03:09:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730718591; x=1731323391; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lUuUGUzmWxiiE+AdbDx4NddMn/Sm1GUTVEG9UTHvf2w=;
        b=L2I5cuo4GudW4HVji8wPei8IWqM5WHMT93zA409Icw2CeilZ5dtgGrBpvcX9HcdkMO
         BJVjRiAFauw82+OiEs23MWmRw3ItEJZMQzNDC4z01IrrTg86FaEeTM/pI5z0Qylf0dLW
         P1OHvLXdp4OOtnCXDRuuiCxADTIPn2w35WywFycCUeu0SzkITOtzcz+iGxBvuXbYt5N7
         danMPfoLr/6bV4d8Z9lwafPvVShE3LsAodNSzxwneCJi2uFUMtOkYKQ4sMFY+qFH44V5
         VdHW9iI0+hlmNKsVMQD+feqeOJoFDvDF2IUkxh1Da2u9x/SLkrC27BHx2RXnPlvFfnft
         eePg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730718591; x=1731323391;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lUuUGUzmWxiiE+AdbDx4NddMn/Sm1GUTVEG9UTHvf2w=;
        b=hDN1D2JdQJ+cDHYNeyJLq2tFCWWGtvhOTXFOHAR/t08LWrTz+EurkgFIuB+Gfx5dPK
         DMA7eQkKoBSqdxmFbVwlBCynVM+WWyTB6Bi9Md73daZ/atEwGq/C5pJz32iJRb4ofZFJ
         QsrU5PXS6rcXAaCNRhznQro3tbFGtgiL+mb96eh2xBE8yki6IFbiBXeU03sL3sx4vAQ9
         7FuFY4/3mVor4u3kTiid1CHanqy4Jt5vyjr6L/rBmZkkgHghwTCQzgv8ZObu8qlX0uoB
         1W/jrztnSBoUB99VLzlRRYGBMg6uthypFfB5ktjiePA7evk3L7Cw7wk07F2pWRhWvdtv
         wXtg==
X-Forwarded-Encrypted: i=1; AJvYcCW2WVRV/m1mAVdLeeHPTxvh7poIgShpWa3xOQsSQN6YOfngJS560h8bAkRr1bvHN/wAkZjIVhBYu+C72kF8x/M=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQtIIn+tDePGrF4SiHF7o45Djtm+zqPTZIudXo9fkIxAlqyBs9
	lPPoQTlbZcV5c2ii2A7d4fvkTroSjVlUHg0eFTK1NudXukvo6UEKEdhyg3CfogCnUGgvDFm2oJm
	WsGl+ycnr52nnvDzA7Dm4VTvOULAl+rOELA0=
X-Google-Smtp-Source: AGHT+IGCQttrdPUer+9fLzj/hr3pSEig9nmdo18AObdISJ00ur/N7upjDDYNfC8NDsrep8J+Q3LT8Wl42FZnbzXBB2s=
X-Received: by 2002:a05:6e02:1a6b:b0:3a6:ac4e:264a with SMTP id
 e9e14a558f8ab-3a6ac4e2800mr136615425ab.10.1730718590616; Mon, 04 Nov 2024
 03:09:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241030131232.15524-1-fw@strlen.de> <CAOiXEcfv9Gi9Xehws0TOM_VrtH4yKQ4G1Xg9_Q+G8bT_pk-2_A@mail.gmail.com>
 <ZyiPTuWKtSQyF05M@calendula> <20241104093933.GA13495@breakpoint.cc> <CAOiXEcfNUrATSXafH8WOgEzMBZcGk+O5Or1PaVYL4nPWMJvV+Q@mail.gmail.com>
In-Reply-To: <CAOiXEcfNUrATSXafH8WOgEzMBZcGk+O5Or1PaVYL4nPWMJvV+Q@mail.gmail.com>
From: Antonio Ojea <antonio.ojea.garcia@gmail.com>
Date: Mon, 4 Nov 2024 11:09:14 +0000
Message-ID: <CABhP=tYhre7KMAC+MZxK4U=betBLD6u2G_uP3+icCyN7VeOtyw@mail.gmail.com>
Subject: Re: [PATCH nf-next v2] netfilter: conntrack: collect start time as
 early as possible
To: Nadia Pinaeva <n.m.pinaeva@gmail.com>
Cc: Florian Westphal <fw@strlen.de>, Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 4 Nov 2024 at 10:19, Nadia Pinaeva <n.m.pinaeva@gmail.com> wrote:
>
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > I'd suggest to add timestamping support to the trace infrastructure
> > for this purpose so you can collect more accurate numbers of chain
> > traversal, this can be hidden under static_key.
>
> Another problem with that idea is that I am building an observability tool,
> so I can't modify/insert any rules, because someone else manages them.
> When using conntrack events, the only change I need is enabling
> nf_conntrack_timestamp.
>
> On Mon, 4 Nov 2024 at 10:39, Florian Westphal <fw@strlen.de> wrote:
> >
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > I'd suggest to add timestamping support to the trace infrastructure
> > > for this purpose so you can collect more accurate numbers of chain
> > > traversal, this can be hidden under static_key.
> >
> > This might work for nft and iptables-nft, but not for iptables-legacy
> > (not sure its a requirement) or OVS.
>

(Disclaimer, I'm working with Nadia on this) one goal for the tool is
to be completely passive and avoid modifying the system at runtime, so
it can be used with different implementations of the Kubernetes
dataplane.
The use of conntracks is because we are interested in "connections"
metrics, that are the ones that are more visible to users. The
conntrack subsystem already has the information needed, so the more
accurate the metrics the better ...
