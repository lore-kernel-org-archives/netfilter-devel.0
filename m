Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639504E3ECF
	for <netfilter-devel@vger.kernel.org>; Wed, 14 Oct 2026 09:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791971129; cv=pass; b=tMa0Df+Y+ppWXzBLDXfx/neqhjtixgiQZDotIuRJV8OgBP8Ky7SFsZQUa+oOVlNFWRjJheoDNFCSRy/2ESibeixU5qw2cZDS0t5oCWv1re6/ZQegzgdLMeMHd677xDWsAE2+zKq0S5H/97sEg3kjpvDAak/Hbcd0/5lPnrc2NbY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791971129; c=relaxed/simple;
	bh=gusoHEwTYtpIMo9jbvB0sb5YbKOtm4Z6P3NaNg27eS0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XgA1bJD5pPqTD5L9zY0Fb6Ij9mYshAogOVv5dZg6bVipJmCp1XTBT7IzUegngKFNrQAfFm4jMZQhgxi4+3dgqkMnhUgRITjO13PDN6cc4PyvBMxAQcVyVhIqcuGLFaABpUK5fOwy/WtXhiLEU/OwrZblle37BJhU0y5mHkJdEYE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=PK1r923x; arc=pass smtp.client-ip=74.125.224.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="PK1r923x"
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-6767d92cde6so3744228d50.0
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Oct 2026 02:45:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791971126; cv=none;
        d=google.com; s=arc-20260327;
        b=BcHx7supFS5+Kar9paGYPjk+5HvXJamrwHAyIUN8WojW6+FasNsOmcYgaWhPXKAwPy
         c4kEpf9xZkaW51um5Xr3UGFekms3K8DpOY74yPPpym6rZeWEJ0zd981gcE/QUdyJyIbE
         6bec4vSKLkq3j62H3la7A+heXrUkMS8Bz2lZTYVIOzVRonxhtj9UWZhDopFcCbDqrGoU
         h/h/zmksPHaVTyTENAeQvxqKzV9wyLFdr3zbIEjLlWtcQdWW+j+IF+fimvEJxgM0+EnP
         BtibFVMTBMqvxh5nZPr1mMM1ZZchACncwfoIT/c6lyWecSDiSV253eXY+0OgGoprYynX
         /noQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=gusoHEwTYtpIMo9jbvB0sb5YbKOtm4Z6P3NaNg27eS0=;
        fh=n2uRtfCwtC+SxYDCm4xjV9HpOOutAumz/8kVXxZUgFg=;
        b=q2EdmiZhDgwas5GSnOiqrhpZAxFbAZnNxchrZKaWlc2f7P8/4Q/lzlktUCLoEKB4lT
         CXcne+GQqsmHQHd1suHFB/m2F+hax4LjzBBErpiaL58+NSlwgIxVfb4Y09XyzOnqjCQX
         YvxMcNx23Z7Jb7ysZYiHNlOjF7kl/VAaYW9z09Ktk+47V2n+enZer550x/lOd6Gtk1yF
         i93wu2SKeboEZ9xhh8vEqgtzdivAe3EQQDjaNTiNo5VwzKWWsq1+IKkAKDVP0/K1ZFhu
         3IvZuRHP2mBuvHegXKPs7WKz6S7iX7tRMhaYIgWU5SQYyXJlOlIrwgtk+VOHa6pMbVJ3
         vx1g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1791971126; x=1792575926; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gusoHEwTYtpIMo9jbvB0sb5YbKOtm4Z6P3NaNg27eS0=;
        b=PK1r923xhU7qDZUbZmXe0yFUiSBca3J8XHIHs9qS+//TYB4Fft+Qo2Ljqk3oG6sPvs
         ExQCXNC1AHfaOK+vCwWLnwkjAKTf2UBbROgtrQXr86a/xPPl6cnW8uxv3/TF1HaeunIL
         WDiDbbme6gyhDZGG95JeVXsSEylcaz4DknthCfgSWs5Ausu5ByUHgSsm7wIUQRywIF7U
         6L6dKDQwf2C+Dc83KQaib+KmDPGD3y03epzqW/Cg6zX34bmKNG+1EutwDxzYAA5TyPdM
         vvgnoK8SarlTBCqLg0ZTdzmtuFchV5igeEa4cykI2Ygktz2Ux2qUDOT2+uGnWf2ewKNE
         z44g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791971126; x=1792575926;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=gusoHEwTYtpIMo9jbvB0sb5YbKOtm4Z6P3NaNg27eS0=;
        b=uiLtNLBidV8rdRuh5HU/CoEoOVOEQIg7eH3DMUrF1v4o3sQ0jRlP6sQMJcKuwFWQWr
         vzYPfxGrXV/UgT1x/QRQ7K5FR497aD/K5eQHWX3U6CXgOKoXWkKrSfr5E3NjlPrcyvZV
         /Azi26q1Dr7B4ibFrqxC/88u3S8L6ZytycWuhsWwCjaa4wQt1EJm9pgTC1m3oi9usZ3T
         byjprnr5u2OFRs8i2LXiaUJottgjL+J/tsuv3CiKkuD2Lt3wu5zW5SOmOmuTih0CseKD
         hNy4KFm6EpHWoXWQvjgtbWdNX6warhX+uZvgi23Xo0a7VxbbdroXeh2f6cjcjnIuLybn
         qeWQ==
X-Forwarded-Encrypted: i=1; AKwUvBx1GhP0nFSknCNlYKv2aQU8h28Lrc94Ap6GTcEW2KZXzDL5O/lc8d4I4KQvjKEkhUiLJN3R5icFviFsKDKrWu8=@vger.kernel.org
X-Gm-Message-State: AFq9FYJG36cjgN3OauV7cU9HT8to9134R5V5fJsQkGR+TVvN/4YLRNxZ
	lIzZ8RUfiGYS0/MIaIv/s8GrjUMHbIufr/3f+dbWR+TXbAK1vEizVeFsgMD29RgJ0EfmNDwSoOx
	tnVDc9Tzpwd+p+CY0+y9ZLeuqMDnJCP+/kXmxr+7k
X-Gm-Gg: AYBFou2xo0QVMJvft/HsS80dbUFZJh/hUcS12FiXfKLKHLZfx26sJidMS9D4xPYBlGu
	e932SaJOhNwsmCi35BjHzC2yGKcOxoS97MapVJVtVoGgxRxkzIQ/+FT/QWQmE/kbZJrObsExz4t
	Tb1j6U0XwcGcAFb71W8Nay2yzNVLs1rrdgGvTlraICdn0zMrT9XEB07tDyxJryBf8j91EdN5iuq
	WNbQC8ObS4AOT3hYUZeSDsjLfDjIGZTieRAZ30oV2EDLjNguXO92ejCN+5TDhfmKDn5zzPDJdyp
	UyYD/uhdHh/Ckxz+pfMaav4yYb0BeRk2AgUaAHtBEEnaB3QE0BXoohjg2FUEEhgaoyimVDV48fe
	mGCy4ggavfSj4FVH0EOSd+xU1OPdQxYakgeHcFucwnVaFcOnASXVHh63jq2gDe29366TXRGGJi4
	fqVKACdNrBAiVoT9xjPGf7/O6KwzSX9PKZQ6aCMGfohDnKegGtGoJ7aF4Hwrfy67mzZicsk+kuR
	hWG/DkHLFtb3okKV8HwSFoWuHcDe7ssIj5eyI1mjTPaOZK37+0e+JgTEpaTP70LIny1Dkk0UvII
	qqhi+ycIyWqmtw==
X-Received: by 2002:a05:690c:c4e5:b0:8b0:9e22:2651 with SMTP id
 00721157ae682-8b09e22273cmr36219317b3.7.1791971126209; Wed, 14 Oct 2026
 02:45:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261004171636.3545085-1-julius@bairaktaris.de>
 <20261004171636.3545085-2-julius@bairaktaris.de> <b4aa46a5-dd8a-4520-8574-d008a3877f28@nvidia.com>
In-Reply-To: <b4aa46a5-dd8a-4520-8574-d008a3877f28@nvidia.com>
From: Julius Bairaktaris <julius@bairaktaris.de>
Date: Wed, 14 Oct 2026 09:44:49 +0000
X-Gm-Features: AclHuK_at13xJpgBNhwlZvLzlUVxJXDvkN0LGkLWSuS73Rn7U8oFN9DIXlg-t_w
Message-ID: <CAC1t37K0tEMzxmRhLeHnH-TPx61pZmCHt0xxTJ5Wq2Wxvzv8Jw@mail.gmail.com>
Subject: Re: [PATCH nf-next v3 1/3] net/mlx5e: Ignore FLOW_ACTION_PRIORITY on
 flowtable offload
To: Jianbo Liu <jianbol@nvidia.com>
Cc: pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, lorenzo@kernel.org, nbd@nbd.name, 
	matthias.bgg@gmail.com, angelogioacchino.delregno@collabora.com, 
	andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, corbet@lwn.net, 
	rdunlap@infradead.org, skhan@linuxfoundation.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mediatek@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, saeedm@nvidia.com, leon@kernel.org, 
	tariqt@nvidia.com, mbloch@nvidia.com, linux-rdma@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, Oct 14, 2026 at 03:17:00AM +0200, Jianbo Liu wrote:
> The handler is only in tc_acts_fdb[] and only accepts flowtable flows,
> so NIC mode and tc flower rules are rejected as before. Looks good.
>
> The comment says what the code does, but the consequence is worth a line
> in the commit message. Because the action is ignored, the priority only
> reaches packets still on the software fast path, where
> nf_flow_offload_forward() sets skb->priority. Once the flow is offloaded
> to the FDB, mlx5 forwards it without touching skb->priority, so the
> offloaded packets do not carry it. Refusing the flow to honor the
> priority would keep it in software, so ignoring the action and keeping
> the offload is the better tradeoff, it is just not obvious from the code.
>
> I checked this on ConnectX-7: with the series the priority-carrying
> flows stay offloaded to the FDB like plain flows, and without patch 1/3
> they fallback to software.
>
> Nit: "prio" already means flow table priority in mlx5; skbedit_prio
> would be clearer. Not a blocker.
>
> Reviewed-by: Jianbo Liu <jianbol@nvidia.com>

Hi Jianbo,

Thanks a lot for the review and for testing this on ConnectX-7!

I will send v4 with your suggestions this weekend.

Best,
Julius
