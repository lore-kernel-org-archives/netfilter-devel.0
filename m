Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3853340E8D1
	for <netfilter-devel@vger.kernel.org>; Tue, 30 Jun 2026 12:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782823589; cv=pass; b=OSNU+453/nHzO2bimcLXYdSCadCPS+/bBnzpe7+LTddIVNqDDNJsF+fggsOmzojK89rYeB++Odv924Xp0aEmINQeHT9ldhQl4IyzJu3Irob1ajMX9RORLwiV0GrcF+93HduLQWAn9nuVw6UNK04w/8srwzuTBrHoR6041nbTGLA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782823589; c=relaxed/simple;
	bh=wh+IO83KQv+PW9qYrhitQ6PvmR93iwz2rI91a2YZLhM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Zt0ZAULxCYd3ueMKweIwFcjkbzcHMO9Nn+GD0OeZWSb1H1VWyYlYOpI9TzW0E5vUFbNjrE6AcEnvSBu7f3Wz8KLsM2+AjQSBhEvraS1H3Qp/NG4eZEpQSNq5oAGDivoOSUfdSzVMqX0SOI+sDP/po4yvgnVWEhOsIpwK9Fn/H+8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=boYSunRG; arc=pass smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="boYSunRG"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c126f9c9567so209750166b.1
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Jun 2026 05:46:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782823587; cv=none;
        d=google.com; s=arc-20260327;
        b=ojw2u3C5EYRGZ7NNMMA8j2fenNwqRiYNhi61LHC/lU7RK16/R7IvXirTRJnJj5qoOI
         qFcWJp31gDi3TG+giSbKlYnIbIBqqkatZwIyhebSX7yyHJ7M04IiKS/wzzEmsPmu8NRY
         mLnaa7oT5RaHctLij7+SBME2gUaSJyAvicgzPy7TMcwulQYLpenOyZD/lK7TGbebF4Nx
         qQQ6d7KgGz+ao4ZfWe2k1L/SDxDGZemkPbPNmETVJN/WElbFjiXcGzak5q7dCWtWVLIT
         /V0mH+HDO7ue4rHF5Or4ekpiw9uHCuYQQ2Gxq6ughdrCDipKOCRiPTE3MuGCF4JFeHxh
         FrOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=wh+IO83KQv+PW9qYrhitQ6PvmR93iwz2rI91a2YZLhM=;
        fh=g2cM0MBrdczUQrQWE7/jMLqgvrgoqusKFo/e+xDK2W0=;
        b=OIQJF92U0SRyR4KXhAotCtsc9P9lqY9qCw2SKoJIznPi/dT0i+9pLt8o7FFVZOow8H
         xqTuixieX1HFCQW7FXv2Vv2mRrr9RaX9M1nNiW+segjxt8+/L2mfzfMDxfyAqOO+qbdW
         o2mjfxEuu7glpuElkAtakJwNpSyFL61xRgKtd/7vO9nHn6WwjKV9iliIbTkbjhQus7xs
         gDyvM0rsWtoHy6AEbgCT6Yf/PTrUhSng+pBElRDw8XudET804PlS6cBPfshpUzKIOjfO
         OcqdowqVx6hY/74wzRIt6dwsIyMQ9F9cfcV3+Jn256OFvTzMXz5xLTmw1xAwbFJz/N3P
         T9vA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782823587; x=1783428387; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wh+IO83KQv+PW9qYrhitQ6PvmR93iwz2rI91a2YZLhM=;
        b=boYSunRGPo7CwEeA2Z0NIVk4hP7utv7eg7TTpbAWlcUohi5w9BmqqUu/SrlhkhvcZ4
         teEUNreOIrtzjWGBZDkprmMcqthY3KtSBkx9925gKSVzQxaJym7sQLIM7/Ik36VnsEmg
         kNPJAlq+1AAFsX0Qz+TZ82ggvaWNOfvwnYj5jz2c/gZEub5BvVXyilpi+xYMufvcAdza
         iKH08j02gBfa7anrTpxvZH5dwY6CFO66qOXDMyUUO8wx7tYcaaQR6XTfX1k/hcWdvBRR
         kwMDH2rEcylTdYsmixsJPw9sbBjdejghJ5riO9zADRSCJxOmTGdneFju1V4vzhEyaKR4
         Mo9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782823587; x=1783428387;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wh+IO83KQv+PW9qYrhitQ6PvmR93iwz2rI91a2YZLhM=;
        b=LTx7QgAXqjPuqzWS7beK3gch7KXHgus9p3XnbG35i4w8bYGlR+FLv9aP+YX5ii8fFC
         RKD6BQlTA8BR3jqsUtDhtK5ZT4/e3zDOmoQi+E3qfPAFvP2zL6FLj5TQhX/+efMe/G78
         MkTxsi0JrlVwXuOIb4WdmeqGNCrnMYYSkUd/NbYUEFHGxBAOhYgIUDdmuJjPbcAJFp+J
         cc9r/zH8fabHvJRAAn5sC2Fpb/yTE1d1yyF8QCGyZPSkE1cQ5g2sewG2463LMLcwOi13
         I5wt1RqetB/lqWuDc1eYzQRHxhvwrsyDZM0xZMef8D4zkqNnjPD4d+r41c49pFS4HMpp
         siIQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro69Iytfit4+o3PwVcbmMfiGXUHIntMLZAkNnsNZrvzy0B5WTKfgKQ83JSUGyFrLQlsbGrIKFSoEmD2edqu+q0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPvYgFJAYe2foV39ATtNow4JmOQLPuS1KF3aAzM6AsdKLA7k/5
	Lgl7s48yzxPeMaUFD20yxwN2dYEVRbb66mMre/GqHL46sfB75Hg0obSZZlADMqaSNCWlxM1+9XO
	qmuiG/LBrdJG3VkkSL0BW0io3p17+5sU=
X-Gm-Gg: AfdE7cl3YM8H7+mtvKqReVSHXfXaHEmv+aAAcCZTGSQ8MNVfNBH3D/TEb3kTTIAdzBi
	GDEZJrUuBrM8mUd8wpNr+V5k9WEuhyqFYQWxBIZGANCl9WVTRQB5IHk22V5753jYdLDYPI/mzlO
	UgGKe6uoEKhYZdyjz3bjAgQEYDwZA++PuXjtni5vqk38HbDmc0AX3txc5h+m/7jm4P2B2UZD5+7
	gg0wnfslYBfzq9rbHGzHDeTWYOpGjhwB9a057sYCoulGscFo0sIl/eoGjltsKGH4iSkEdXyOg==
X-Received: by 2002:a17:906:fe43:b0:c12:34ed:da11 with SMTP id
 a640c23a62f3a-c12873872afmr146790966b.61.1782823586478; Tue, 30 Jun 2026
 05:46:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260618125848.93550-1-running910@gmail.com> <akNRQFx9fmi2DK0w@strlen.de>
In-Reply-To: <akNRQFx9fmi2DK0w@strlen.de>
From: Zhixing Chen <running910@gmail.com>
Date: Tue, 30 Jun 2026 20:46:14 +0800
X-Gm-Features: AVVi8Cc6zr8eey41iEMKq_9uJ6bV9rfcrW_UKBAjGWWLZP7XvRwERlL2YGq_QB8
Message-ID: <CAMyuFdW+LR8YczR70gaoz-R0hAkxm8w0pvn_vf9S_9yM7B+8BQ@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: ip6t_ah: validate AH header length
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> We should not return false in matches for malformed packets without
> also setting ->hotdrop = true.

Thanks a lot for taking a careful look, I really appreciate it.

I agree. Returning false makes the packet a rule mismatch, while this
condition means the packet is malformed. I will send a v2 that sets
->hotdrop before returning false in ah, and applies the same
malformed-header handling to hbh and rt as well.
