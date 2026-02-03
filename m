Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73AEF32F753
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Feb 2026 13:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770123954; cv=pass; b=iItBZW8gkx0P3QTgxs/XK78i3MbYvTkOKE79iYs4qi+r4B/aiXgiJqTA1pBOkMVErU9bbLDDrjlk12uFvQBb5gOk3LNEwyhPB62svtymyPvj5o8quTYi/h89pwgbW5/++NRSqtAHO6Ki4+ssNyGydieYJODd6tckNKHns5D3mnA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770123954; c=relaxed/simple;
	bh=voLKekegcCZk0vr/4QPCTc1uZsgmhHcmtHb1yEzgJ0Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Xhr/62T5P2a/HBxBx6wdeNjMS+w8UYl/APaElcTu6zT52uvIx7aZzwbN3s35a2DSBs0Yjk2EwyuWPryVQAgubbwpgT5xld7V0htmH2Wr2RydwKmvSugbc/PewD4wTRW9WugC67DkJPQMBO8rJc0l077+Q6x/jEIxNI6Wga28tU8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ah77SLl7; arc=pass smtp.client-ip=74.125.224.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ah77SLl7"
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-649278a69c5so6081477d50.3
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Feb 2026 05:05:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770123952; cv=none;
        d=google.com; s=arc-20240605;
        b=CFqx9UhojQWCdgvVk9TFE1WtZdFcaikPWJ20Asf0ltGMprqc33Gsn0DKr+uqeHYuUn
         Jm5nya/O32CJVbr7efRg7xnxbdCk9mL16VQj5Bbk6ZjM2inA41qt/AqDLAyPNgJ61NoF
         v9bXjpOoyFpp/G50FVCi9W7BIIAWMsjr8pZ+sB5URSKEn1Ymd5tlalN3ldVMAiBPGlxw
         j3PJVHnP4XVwApXG/QjT8uq/hatRrKgphjRE9TmZWvj77vL1M5biD7Zb8InaIq7hiHmJ
         6MCDs+q8rIT/jp7PA/eszIuXNhq5jphpr0t19gtOtT0+CFRZX6MCuRJUsnl0x0Ylbhxb
         TW2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EzvCKkHvTDyl5Hbu0UI0p5YJ3tj4x14liy6theec5Kc=;
        fh=QWIC77Szo7YS0CoIp4QdgfVTuMVuIjIW+36DEnqIICk=;
        b=No1EFyS61ap/X5hqMSuijsot1Xfj41h0I5n68NNNd31bquJTQllBoc5kuvmC/zyYkp
         1xoKVI/zjJGJWnDnEgz8Za4SMbTQpVHv1jpWV1X6XEHn0WPvwwkzRuRVCX+fB77of5/M
         a0xcSXYHRXhPt4ivEa68h7v0I88ViGKQdgNWSOLRLDDiovLRAUrDiqk8MqzLiur/k6Et
         nsUftjbNmVKh62EP78hyArFI9aDdJOy/KBprGCog2ybb9XutzqM4Dh/oUrbSn2fyavDZ
         vcPUGitg5PynRoVEfPSSt1XyHH/veTZsFgTwcwkiDZcGbQ7SScaw/6zchO9HmitmHVjo
         18ow==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770123952; x=1770728752; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EzvCKkHvTDyl5Hbu0UI0p5YJ3tj4x14liy6theec5Kc=;
        b=ah77SLl78ZadDZvqsWf1HyUYFDANZituTkTeypLMev5DVch048NFyVh0XDtIixFzPO
         Iu+vIFQwEYUnxdLiQu1Dp4ttKBm4EVoHhLHFKNskSPlcklv7SMY0n3yMShQxWfRhF9jj
         Lxok7x7U6E7NrdmYBont85Nwm2RZW4e5wK4im9jzepXMMR8kCQQ0r04enfNfhVdwE43m
         k+Hg4E2+uR3K4qiFuorx8CIZCQ7A4H1sODkC6fxe3ft6SkWVq2GgFOmQZxIX25C3bVhh
         engzIq0hT4bkHYLQH8xG+z06Ut+fwxuxtS4PwE8A7j5tmeG/KL+1V3tzqgxgFbWw0Fa7
         0ZDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770123952; x=1770728752;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EzvCKkHvTDyl5Hbu0UI0p5YJ3tj4x14liy6theec5Kc=;
        b=C3wNFJ0OkfF2Zuar8OFbeW94YyygP47A9Jw+xR8lHjaINNc1EvizJ8j0mDiiqU03Oy
         8e4cMMChYmMYofXfxMkKaCtKSmESLxCSSqz4Qrv02KYkkqKlRvjwWGSkpYmYQn4Va17i
         noCmhUKIDI1nmqBE6i7pQOcN297OKhFaIwdaIzw+9wuIiD2gSV4AWyOhYT3KvF68FdLs
         Ogk3j1ZR6yRgLuWD5QM7OfhtSx7zzeFoExnhdHroAUfGXAR8zDbz59Kf8lYIbQpLRpdW
         RfII5jbK29HFMQzANIxh4P20C3ayOrNG/XveZlSFceE1z65kb3FvTI+Utt59gDl/4tF3
         Btvg==
X-Forwarded-Encrypted: i=1; AJvYcCVmXAejNd1uwHjkjdU8F+H5Binnsbxyql/wiR/WEC8cV14zxJ4D/s8D/g65liyQObA5yxwKsFn5B9WYtDSd8V0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRP/z/BjePKtdIM6wTXCgG5DgK6TfiB3yG7R6noCDLPtWHNAmK
	ksEjC/GfzgvCPPKg3irQyYzLH2E8z0Kvi/HHRd4BTcYB8kuf7RMj3yj4KqKw/dVczCCy/cUPrTb
	hmu+Kq0Xtpni4jRiHm7cEmhJYfGcukuA=
X-Gm-Gg: AZuq6aKpB7o3zUfbk8xLO/QVDPljcc7mrNzOF+kBkTGVbeVNsbASFDv62TaTDCyy0Vr
	cC0NBEacNTbLCfjWUCl7otdf4wnTZOXMoGl5lmRH4LbbJPwb3plYjtCYuqUZnrNKvW4M/V0aTV2
	I7jYqEtQ8JOlnEJdE29ZrKLXnPvDVrBdMSmF1Km4CCBbRcR7FGP4sI/I6AF3igZAvfeJJRwSISe
	IUiAfVc4WTE0Ctc/MKakjJT5Ds4RTzEAGwlr2p1wYvvafM1xZjrEF/V8WGr2wgnazvfU+L2iXjN
	WSj0Mw==
X-Received: by 2002:a05:690e:1382:b0:649:cd05:c518 with SMTP id
 956f58d0204a3-649cd05c775mr4229871d50.44.1770123952334; Tue, 03 Feb 2026
 05:05:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260203084323.2685140-1-sun.jian.kdev@gmail.com> <aYHwd2mMaVp-qFlp@strlen.de>
In-Reply-To: <aYHwd2mMaVp-qFlp@strlen.de>
From: sun jian <sun.jian.kdev@gmail.com>
Date: Tue, 3 Feb 2026 21:05:41 +0800
X-Gm-Features: AZwV_Qh7OL-8yA3ZCQSQKBbrNjJ5KI5yV8gSWZdHYOrH-TO3MU-ndKsFoQt5iyM
Message-ID: <CABFUUZHwLvfAfxdmaJHvCPQ=YHXMnkqEiJxjqTN=29VyiSBhnQ@mail.gmail.com>
Subject: Re: [PATCH] netfilter: bpf: add missing declaration for bpf_ct_set_nat_info
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>, Simon Horman <horms@kernel.org>, 
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 3, 2026 at 8:56=E2=80=AFPM Florian Westphal <fw@strlen.de> wrot=
e:
>
> Sun Jian <sun.jian.kdev@gmail.com> wrote:
> > When building with Sparse (C=3D2), the following warning is reported:
> >
> > net/netfilter/nf_nat_bpf.c:31:17: warning: symbol 'bpf_ct_set_nat_info'
> >  was not declared. Should it be static?
> >
> > This function is a BPF kfunc and must remain non-static to be visible
> > to the BPF verifier via BTF. However, it lacks a proper declaration
> > in the header file, which triggers the sparse warning.
> >
> > Fix this by adding the missing declaration in
> > include/net/netfilter/nf_conntrack_bpf.h inside the CONFIG_NF_NAT
> > conditional block.
>
> Didn't Alexei tell you to not send more fixes like this?
>
> https://lore.kernel.org/netfilter-devel/CAADnVQ+j8Q5+2KSsaddj3nmU1EkuRAt8=
XwM=3DzcSrfQfY+A1PsA@mail.gmail.com/
>
> "No. Ignore the warning. Sparse is incorrect.
> We have hundreds of such bogus warnings. Do NOT attempt to send
> more patches to "fix" them."
>
> I'm not applying patches when a subsystem maintainer already
> said no.
Sorry, I'll drop this patch.
