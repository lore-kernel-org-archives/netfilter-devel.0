Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4B73B19D4
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Jun 2026 08:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780908853; cv=pass; b=uYMYYup6cQ1oQCmA7KssT0TiuAdC43yODF/jBcis1yEtJOYZIOMC+V8FyzaT+Q/zpTTqyATj0gyTKv2tjeNkXdF3655JI+2Ogfbo+PXwPpvoPCeQtHHsP9SEv57UjpmL0mrxVYM+YcFZEBp9DAl6nFtlGyJtM/D4OveiTAX/2UY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780908853; c=relaxed/simple;
	bh=8QVx45y6QyTBCVh+SAc+yQjvfe4xgdcmAH4VAii4y3Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=egyQ6eMrkzJQxtMKIkL2lf1mmi5t3Yftau60CrOqZtmGPCGRGr5/HJ9+mnZG+j8IO1+6Tm3w8S8BOT/dV2K9BWDXqKLZHLoyM1VMCZUepCPt+zgtH/rk5aS+nOqp17c//iNVUcirJpnIMGoGXoK5nVx1gShEsVD4O/Ih+bD75kA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P4qHLfO1; arc=pass smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P4qHLfO1"
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-48633190849so1512269b6e.3
        for <netfilter-devel@vger.kernel.org>; Mon, 08 Jun 2026 01:54:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780908851; cv=none;
        d=google.com; s=arc-20240605;
        b=cRExSL4SXJt+5bc87rxSulbMTQwSFB+q04v8rfX8FnumWBTokxOkV5QzsRYnVhqTR4
         aZ+0k7Wj9M65Z3EwwmOGKL96RAD1hBkw1Y+FYQo8VmF2+hfjK7zuDv9mUs+JpOal7jrD
         Jg/x8V/L+c4++XHeiXVrCTbI+mjysTGARw5u2aWY7O2+nYAhtfwb1gfIppPKqPkhvujM
         y1/q37TKHtmRK8ZJcDY1xf0qaVoCGAE10KaDp3Y6GBwa0M5cSTxvMIQh4GSK8RSwJ9Rf
         0tPcC/V9ja3jJQlU3KpeFruFMUX/V+as6BEllW6MkROFut8+mCubKm9XkccWZ5diD6cJ
         wuXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=8QVx45y6QyTBCVh+SAc+yQjvfe4xgdcmAH4VAii4y3Y=;
        fh=/C/30jTGvyM4tPtfZfF1kkMQmuv1HFSpFHhKTZmy7gs=;
        b=JwUCg2d5z6QtBRI5CGdZdNRnI2A+s/3iiDj7RNuE/+QxfjhM0ieZ8adlVoq+rflK/4
         t3fJmjjSEygDRFQ6IGoxO5Adpzf6obWJI5lBPhh4US3UetY+PgmuMmiIIl+rJbudvRJn
         mcUAojq90fHzNfN4/T1QDTMBUGkdvm5Y2q2iJCbA9Wqtdx0KQrwfGL9AZPTiKeqzTCbR
         4Yh/W8zFe9shhsfUuGtiwZdAT8c27CcFZqPDzQcRgj6INVIWgSmfrvjfeRtF7L2v3gpZ
         iaGKlpPmfF7WJLbHkSoyrzQr7s1mD5o33LPoGb/yfaSps670fFQHRmcZoU5AI2omyWQG
         NmcQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780908851; x=1781513651; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8QVx45y6QyTBCVh+SAc+yQjvfe4xgdcmAH4VAii4y3Y=;
        b=P4qHLfO1HlEEsX7Ms501MxKfRPgys3qGOUtyBBzsbPsXu5pf86+Eoyed+i4tl8ZXEK
         C2R1mqz8FSjKM4ZHILanVO+OOyeToo1d2V4QgJWhc0t+XkudN0cpa/rVTINTeuHD5a3p
         FTiVMcCMMLI6zUuO2wLoYE4FtmSWO5+ceQNHUfyolqtTnusrQXAKxPajK5hekItxmNHE
         fbrNDE1ybzc0NxmjTKF0E0Ac4SMPhUa26wAzH8Fj8avwjkM80zTyQYVU5eKZPrBFyG/X
         CK011MHZGZievnLgNaW93geAN9GhvcRQAnbIoLSTFwVb++/+R8oSnvbpLY7CFP/76cEi
         QvpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780908851; x=1781513651;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8QVx45y6QyTBCVh+SAc+yQjvfe4xgdcmAH4VAii4y3Y=;
        b=paTJ32NkINsyrY6fj+B6wtpd07uYES99PRSEXpGPTs925OY3PSNQLkKuBiCXTxoaMi
         7GFD6BstkOinRH1jJ+D+MZ6ZNWVQqtnhzRni/NgtRCtpSC+gadsqnKBfSwlunJQRBGdB
         93RPPNXkZGQFKW9k8oRMwUxzCyy9MIiCZxttLhdXF8UUmMQwURCzYKZ5sfPNfkT51EER
         VXAhykd36wdqFkMMhQkO1xW9lO3Joe21SquCfWpQ2aCVCWvQmBzTw4e+5bMRHt8YyCwo
         YFzXQ/8ekJFNTBF5gqobhSyicB5xG9AeyPqec2oEAVPAcaDH6wrvYklWmC5gPlC6293k
         ErRQ==
X-Gm-Message-State: AOJu0Ywp/H9y1PO4YyEz2DDD2aDIdcqBDj5t7rtORZRR4Y99nd809BoH
	r8cLMX2Rs33e2cTMnFDXcC5VHz721mDNObgae3Vghf1r9Xfg4zitPofIHI9kzxonY7wTTmt6MZ0
	2F0e/z+RbsyiV781clDiQQtnZY9I7cvs=
X-Gm-Gg: Acq92OGeHQTbFdIhf9lQXiW3fkgjKvi4jmoj5l8fhKKWS90XlDMs3zVuckrEVwR2R50
	SxJ+CO1+bPJ/An3dyeWFmMh09dcnotTblPFUBV9Y4teqhHuT0V/hFslrX8XK2vQ5yl2qzuK78nn
	pEqGoJjJhF64TQJg4eoPFuvVbeaksCvUnGSsI4+oum5AhXvN2uqeiMEUKYun62AF79RaOqE2Nvl
	yrqkpvETgrjZw1P2pxM6fE7xe+XvBNyy3eSmqCTNLOjQ2w101PTvxI9KSY/HFIMKwcRIMriqpHG
	Prgo/bRL1cbx2VUnIg==
X-Received: by 2002:a05:6808:10cc:b0:46e:c1cd:866a with SMTP id
 5614622812f47-4868deb1172mr8209073b6e.27.1780908851103; Mon, 08 Jun 2026
 01:54:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260528204020.7ae744ab@pumpkin> <20260528223412.27311-1-kacper.kokot.44@gmail.com>
 <ahjHRB0Ohn7fpd-o@chamomile>
In-Reply-To: <ahjHRB0Ohn7fpd-o@chamomile>
From: Kacper Kokot <kacper.kokot.44@gmail.com>
Date: Mon, 8 Jun 2026 09:53:59 +0100
X-Gm-Features: AVVi8Cep8npgLg1pwln0GCs-DeX3qq7kqMO_6D31-1M9IkFc4dDZxjHiY93gBbQ
Message-ID: <CAG-Fur4ro0ktPiG7mD1YBkvuDmtCubAhPwHfKN7LrQBaJq5vKg@mail.gmail.com>
Subject: Re: [PATCH v2] netfilter: TCPMSS: fix dropped packets when MSS option
 is unaligned
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, kadlec@netfilter.org, fmancera@suse.de, 
	fw@strlen.de, david.laight.linux@gmail.com, Phil Sutter <phil@nwl.cc>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	coreteam@netfilter.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> > Padding TCP options with NOPs is optional, so it is legal to send an
> > MSS option that is not aligned to a word boundary [...]
>
> Yes, but how many stacks do this?

None that I'm aware of. Mainstream stacks pad everything to a word
boundary and put MSS as the first option. The motivation is RFC 9293
(MUST-64) spec conformance rather than a bug seen in the wild.

> > This has not been observed in any real environment.
>
> ... then why is this a fix?
> [...]
> To me, this qualifies as an enhancement, if anything.

I'll drop the "fix" and reframe this as an enhancement including your
suggested subject line.

> This is questionably a "clean packet".

Fair point, I shouldn't have framed it as legitimate/clean traffic
being dropped.

> And "the kernel is not silently dropping anything, it is policy that
> would drop it" [...]

I'll reword the commit message to say the mangled packet ends up with
an invalid checksum and could then be dropped by policy, rather than
implying the kernel itself drops it.

Thanks for the review.
