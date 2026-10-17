Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8BEC3EC826
	for <netfilter-devel@vger.kernel.org>; Sat, 17 Oct 2026 10:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792233491; cv=pass; b=JDhBSLZmGXOOqGGQg2qerZ+loYtS5kAEFKCcEUbz4KAMDsk7xGZ1Vf1unlM2T4cb6LtmaPaYSBe0vPsv4rc3hE4ziizdfVJPTbCmseUn0qOptI+1ubt9rVrhClfqE3NVLNxPBrtfkNfltolVfrwhBiHzkNuRO+qC6fopX5DvoVU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792233491; c=relaxed/simple;
	bh=OWILE6TJnc+6T9SUFGhHKJWv32QNTH0FJDtYxgA/Iek=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TXxUdlEuiMaIG0p5nG+oZWCZh46fomfntZ4Mli17JwFqRaWqYTtgOnyv5gMevH4fZgW1AeS/OixyEXEFYtqn7zYRftJ6Wxs2RxX0mVRuFHADvNursJhbAveFPf0JyRSWvI4MTj7hpTvs5ePTHy6UQsij4R8HnStj3JB98l19hs8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=twkK6hQE; arc=pass smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="twkK6hQE"
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-8726acc5eadso5435317b3.0
        for <netfilter-devel@vger.kernel.org>; Sat, 17 Oct 2026 03:38:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792233488; cv=none;
        d=google.com; s=arc-20260327;
        b=h8h3Z+ILRmDsfXbs+VqFVk590K8IJVmldMU9x1QN+JoHPGncAASrloP5jrIt7Uvxb1
         2eRYy447sCQnx+R/NKcfXuboJ8j8622uw9OrhC10eS/02FccZEmrflTmTJdJiW1ExKAL
         OLS1YO3wndt0UbsBSdeIbz9QbvLsZS33P1DqOJHzzA1/a2k3dcUILtOxfk4YS1T7YSEn
         SxLaJio34RFbo6xGMAH1B+pt8tzkU3HOZEEZfB4MlP924444N2pYMcaUMC+Ho5kIdf8p
         iN5KGbLoHrJKv+TUM8PI7cFXQxowfeEVmFSAdXB4AFZ/EE8Ju1bQ360cYrJJsFjZuM/z
         tlBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=OWILE6TJnc+6T9SUFGhHKJWv32QNTH0FJDtYxgA/Iek=;
        fh=ojNdzq9rDGxIstMHfvb8jFDbW03v3DoIl/AcAPuIe6U=;
        b=qbIQUg2AKFvSyG2kCAdHV6JltKgsrbuVvnpXIU7q0cryXQUsjRLvdDWXWKqARr2U3y
         g12pR8nlfYcfWEZCkVuEdumtQYSQ5WcxwhDAt2XbWwjyCUINlzomFhYiX0JyWcHiBBXy
         kDl4u7iFIShKpwOKS5+RaVvAdV42Pv0qvx77B8b9sL8D7Az3JD+KHW0aetUx6iefm/fB
         0iTb6ERoIA9Rd/o0+JPND8/MIkDjfia5/ibBx+aikrzgc1c34CMXeH9V2xw4g41xmW2J
         jClyimjNbc3ydAZmIb/1k+/2s71Es1P7CoNqTlXr22gupuAV56m2rpjD50U6GMYc+8tN
         A+Lg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1792233488; x=1792838288; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OWILE6TJnc+6T9SUFGhHKJWv32QNTH0FJDtYxgA/Iek=;
        b=twkK6hQEU1af83Elo0s5cJGQFtomg9cUDJ89V7VVJcW2pC3yDBLo/HEeD0pQu/24Sp
         Ll8C0fJuWRU8odd/H9YH4aUV08VZLJehLdTQZsIGyUtOgy3ZQw7Wsh4MMMUlPrFUvDEW
         Nt0rssAD3uaVAfNuAQy7m4dMWFwgjFHWUAlY0RhdSgzxwTWvZzW+RuhkWxE2TH+3QFNH
         0REL+c/TPybjClq0UjkME+S+nA0lsrccX8DT9dRCntb+y4DGPaJDFYdfJSBmRLWvalt9
         7ocfHR8nQhOQysVVbumw/tQVgucRQWMuCwPlABD8zOqRxNdNPBvI/P0khbLEJpLo8cH2
         QRKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792233488; x=1792838288;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=OWILE6TJnc+6T9SUFGhHKJWv32QNTH0FJDtYxgA/Iek=;
        b=xy+oxf/8y4IQdft3yvqhMooRr1koHc3bHUheO7XhiOJn1k6euyECrN9U4sXwbs7zfD
         6VoRGb9+ClV6iBOTBcQfDINDbRpWt5nwbto3dJPuXYP+6ZiuQ1Hn0+GcVTMvxxKNLYCj
         4pDy1dgFhZ4EsDFA9MuL3qEvxCJWryhKUUZX59w6wiFh4Xd5cI0L3wG/pZ3zbltnR/3P
         lYMJhMFb5686KM0AlAYvAYlJWLCMM8NfxSx3M4bnSiVFakfMuxE7/BXCpEWu4XxKvLm/
         ZS8WG+HtcEmvA7X9vHD2Jz8rt6up2CEVw01PgQIM9pOH5QbPVAjmy5uc2ech9Y3itdFz
         zCxQ==
X-Gm-Message-State: AFq9FYK6L4YAHSDoqRsNiK7El9AiDxhz39bTKsdoiMH+/mc9bgggNEda
	wuMRQVx2k6B4La+Jo3PLye0HLU0gaKxaBUj7DwklXzqrGt6HtP7rG6Zob3HZdeLHtttS+Mog9TH
	0aP5THI+qcOMUuYfKLQWAG1WjA/6CkIDA6uJuG+ZP1FkM3XQZYFeBHNEH
X-Gm-Gg: AYBFou3ViICnwSCuubNnE4cEgasbMmEraH6lx+xb6wa0DgmlBV601S2RoO5Cqp4dr6e
	L23F9lzqNZXL2/Hg0qA6h2kgVCRXVoxSg0prZuZaV4IKooiWsSsJEEqomxRb8Rh4bUn/lHcTjRP
	I9ob+yu6TYdbVQCx2tY99CNvQL6IPCR18yc5Mfcqy6XhzDkHGYOEOHQURi7eb4ATSE0toFvVIu0
	5f43OeNl/+B1IiAxoCdYUB90TPobhVWf3puwzadxjjPevDWtMIQ1UZM3zQFKJe09TRG2cGpN6YS
	t9RPLwu/4QVU9qdjh66O6ahyP0iD5unAFvHvMESnwkKXziAZKptcBTLNi688RfbjV720nP+yjmi
	pB2MqnquzX0PAQnu2plbfjgMT461gCjZXRZf51FrkUYXtmhWp9l6TlASZJQnC5mKTfP3yM7vWH+
	8y7a12DV9ymDix7vb3K89kDB3N44qsSNgB3YkyE7C5nN4iasQRxQCej7E1TMf5H1RvRF+Akuv+x
	+rD5Wien7L0veJ6IYprcbIjgL+pnJYYHGUJNOtslD0Qa52/PEcMU1i8/KBJSQTDY/ygRvWJMM+9
	G/GOKO2I2ixNrg==
X-Received: by 2002:a05:690c:f02:b0:8b0:e9a4:65b3 with SMTP id
 00721157ae682-8b0f219a7a5mr9764157b3.13.1792233487679; Sat, 17 Oct 2026
 03:38:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260913104251.648421-1-julius@bairaktaris.de> <20261004172439.3548490-1-julius@bairaktaris.de>
In-Reply-To: <20261004172439.3548490-1-julius@bairaktaris.de>
From: Julius Bairaktaris <julius@bairaktaris.de>
Date: Sat, 17 Oct 2026 10:37:30 +0000
X-Gm-Features: AclHuK9uOXJa5LQ_fwTpXh6eC6CCQIR7bqWDTaaZHFaPK-RFMqJ9NrsaTLBldJc
Message-ID: <CAC1t37J79N69Q_GWbU9ehf6sTKSB82xT7-7EuOsXvxtEsq7KLg@mail.gmail.com>
Subject: Re: [PATCH nf v2 0/2] netfilter: flowtable: correct and advertise the
 vlan match
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, coreteam@netfilter.org, 
	netdev@vger.kernel.org, saeedm@nvidia.com, tariqt@nvidia.com, 
	mbloch@nvidia.com
Content-Type: text/plain; charset="UTF-8"

Hi Pablo, Florian,

another gentle ping on this nf series. If a rebase and resend would
help, I'm happy to do that.

Thanks,
Julius


Am So., 4. Okt. 2026 um 17:24 Uhr schrieb Julius Bairaktaris
<julius@bairaktaris.de>:
>
> Hi Pablo,
>
> friendly ping on this series.
