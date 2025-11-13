Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBCE02F6587
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Nov 2025 15:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763047942; cv=none; b=N0l6SpjAMMGfTerSCWSPRTJGRm/GDqXBf/Vj6oHnUocKLXQ2wF5Eo9YfEl99NF5DMbAIXuiz0Yv1BcqdJtvvMpftrsILhilcM07o8JEHI6Bjpafj2xd2OEcuQJSf+mPGfQhkW65EUBOTPx2RvsVSCLkaRwNgLLj8eK322mdYOpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763047942; c=relaxed/simple;
	bh=HK/XTH1vs5ogHtDfEDHsy2lCYQYNnOlTeFggXsOVopA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lIk1viBtShs7pOQpOneoiGCGhWKXz0J4ZJMFV73PuhypMAn/MHZQ9Jfy+d0kmy1JID0PIwO0u21YVs/AFph/TnH4pNrWA76e26/lMfgAq4v7/TbXLBd4aAXqZ+SrzwonLuy+mFATP4MMra//iCLaj/eG1U4lx/4qF7fwOchWZXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VoGY2WRp; arc=none smtp.client-ip=209.85.221.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VoGY2WRp"
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-54aa789f9b5so537891e0c.1
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Nov 2025 07:32:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763047940; x=1763652740; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HK/XTH1vs5ogHtDfEDHsy2lCYQYNnOlTeFggXsOVopA=;
        b=VoGY2WRp5yRxVTVQ32riyXohtSVfxELDM6I+HgSmAshWIggHOjoVQgFogt1jNiU6W+
         yXjIB0XGBlWXqWLQraK7842v/4Nolpx9bMqH+SEb2xObtfG8lOvoilvotJ2b9Jabnp5D
         g/uTmF5UuqlZj8lWdhah+1HBYoxqU4dnS3vkvOOxyfqRIjHvW2ynIZc5CjQnHJdXkOds
         o1MbKETrnKKNgYwik+Az9nfB0DdG2+ysCBJ2uW6wz6EgOgsFPlQiOd6gFbtArQQ9YriH
         UbUX2tk9WKAG09P3q4G7yOpG9Bv3cUDSwLxDg+w4oyWhFeQaA8mwfR2urejJy+0FWETY
         qeHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763047940; x=1763652740;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HK/XTH1vs5ogHtDfEDHsy2lCYQYNnOlTeFggXsOVopA=;
        b=ccvC864Gq4bqJLiOaQhMe3HWZNgYuVOhHrcWTCaJGWkDRinV2Tl1BKdVN6uL6aVVLv
         G5uv+XyLJiLFSCCce3G9wFIvLqok8R2F6RlKgO0RB5G3DxMgp202rgUimaeSo7gHryhK
         +aIOSwPqeCq+FCAT3xpq/5aL2fAjcZBLAHVLdN/AJjIZshu+EJBWiTR0OfcP/ChZdXhc
         TZiFAFWmRhLChth2bLWfPlPIMesR+bCtuGsE9zeQc9vTvWX4QTgw1mM5ezhr14XXGtb9
         cPweVH6UQVP6qMO7ajqmMfCyfeBZuavMECRTSoJSWW3p9ItB7YGLGcxX1K632DMQvY1v
         keNQ==
X-Forwarded-Encrypted: i=1; AJvYcCViYJYOLpjQ1r8nX0SsMgTPi+M/9qGPh56LXwZyb/ToBHsDso74Lzhjse1RjEGlC4odgWvHNiRbt5yvrdN1BIs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9vm7JNPODa85mJtMU7Y/AxXBHMUorTatxG/5DTi3dBNET8em9
	nOBL7FYOe4k+lCiuasWJKkKCu8pxv2ZyYtEztnn3d/Q71a+6vGymJqKQG37PPmlug2+C0dcprQa
	1X9LF8+TR0VvV2PqfSka2o99MBUkxyf0=
X-Gm-Gg: ASbGncsOe+pocWLukVRwEHUicnC4VjB1EneajdJV/3xAkHMnCMJtp8JSrfcFC/xmJhn
	QiiTO4HDMO5NCZu5fwokd9voJSbkN7yh3tUjUkv3FxsiIedh75bZShV8ySFXnVbRxW9DcoCKDKK
	meUpCFznT9r4mv12KF9PjXbmJvpyfhucFM6vhiQuIi8nZY0fEGOcXK7IwmJaE8qkXLtjfJ6cfE5
	wDKV0xwgRSz/aQ1QiOIMPMeiDjpwzxIbtNypxK1OzyPhNBCCeJ06jnrWQeQ5qE=
X-Google-Smtp-Source: AGHT+IHjkzaJR98ABGf7JPdxTaIgrD7ydPjrcLBtkfxsqqWMEkSquvfD6fsm6+pA4EMyJmcW5nPIV7Bo8G1boiTHdOs=
X-Received: by 2002:a05:6102:cc8:b0:5db:ce49:5c71 with SMTP id
 ada2fe7eead31-5dfc55b0bbfmr17704137.18.1763047939722; Thu, 13 Nov 2025
 07:32:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113092606.91406-1-scott_mitchell@apple.com> <aRXM079gVzkawQ-y@strlen.de>
In-Reply-To: <aRXM079gVzkawQ-y@strlen.de>
From: Scott Mitchell <scott.k.mitch1@gmail.com>
Date: Thu, 13 Nov 2025 07:32:08 -0800
X-Gm-Features: AWmQ_bk4Cs4HA_t-WxTixgm-463gTBOmlX39m7CT2eAG1Up1wBQtX5vxCBOeAL0
Message-ID: <CAFn2buDiAqpdzo=50=QA6zS1TZyFVNHqKdqvoixCuWcGLF=uAw@mail.gmail.com>
Subject: Re: [PATCH v2] netfilter: nfnetlink_queue: optimize verdict lookup
 with hash table
To: Florian Westphal <fw@strlen.de>
Cc: pablo@netfilter.org, kadlec@netfilter.org, phil@nwl.cc, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	horms@kernel.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Scott Mitchell <scott_mitchell@apple.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2025 at 4:19=E2=80=AFAM Florian Westphal <fw@strlen.de> wro=
te:
>
> Scott Mitchell <scott.k.mitch1@gmail.com> wrote:
> > Signed-off-by: Scott Mitchell <scott_mitchell@apple.com>
>
> Didn't notice this before, these two should match:
>
> scripts/checkpatch.pl netfilter-nfnetlink_queue-optimize-verdict-lookup-w=
i.patch
> WARNING: From:/Signed-off-by: email address mismatch: 'From: Scott Mitche=
ll <scott.k.mitch1@gmail.com>' !=3D 'Signed-off-by: Scott Mitchell <scott_m=
itchell@apple.com>'

Good catch, will fix in v3 (coming shortly).
