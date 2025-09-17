Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 407281EEA40
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Sep 2025 03:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758078626; cv=none; b=Kczh9LxNI4Ek2kuJl3DN6m2h+XlasP/xYqPhAbP6258AQXLbPslCTuvzK1pkvFIDTOCyumZYb8+CwB+FEPKsl02NFAk+wC6uyzCWEhgwhhN7gMJghHvNu36YnUJesJCGjEkMehWWEHJJCd476PVV4yfynzzWGCOt/LvFPaXXXCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758078626; c=relaxed/simple;
	bh=qo+k8NcZTsre/ht6MSdF9SSU+7BW0nZyjkH4oBSMWuM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y4nq2/yVMlXQo0ITwZWYvH+mqW7VGYJW6MFxCBwVXIB8rTt82VG3M0YKUusrN46bB18C/ZHDWzicTIWCcvRxSBpg6k7sZ8Q0T9U0H0jBMpEK/VsukzoYKxaxFVB9VV++V72XEl9BkDMjdfctR/U1m9chsV64ORnYQs7EZEV4AxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ycno+brg; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ycno+brg"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3c68ac7e18aso3633030f8f.2
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Sep 2025 20:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758078623; x=1758683423; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qo+k8NcZTsre/ht6MSdF9SSU+7BW0nZyjkH4oBSMWuM=;
        b=Ycno+brg9GMmuW20SBgx/f2hvmZ2UcgvG+T/j0pNzBS9baci/+Rg0/0mYdr1ZF2VlB
         u8nHF2vMTZGLM2cPY6uJEqY7TDRAe6uedURzFxHRZA4nSbu1FLeghGfpBVWFmr7H6edN
         RWUK8RIKR8fhTb1jvDaITER2c0i+d2acFKC6va4UgUx0h5sQENd1OgdMIUeVAMRt0OIz
         dSHrdbaP7Q8e5TXSi7lsW3PrbtxzKPbz2/9UIjWyFoU6zmhbvmOCnn+O0qm4p2AeM8JE
         QHqMptLaWCmxnreGEeYe2TX9y2SJT/dpNK9kGaKCrrOEfnk/nWPK8ViAkddao97F4Yc1
         +WGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758078623; x=1758683423;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qo+k8NcZTsre/ht6MSdF9SSU+7BW0nZyjkH4oBSMWuM=;
        b=NhFZO7D6g+5ZZzbjaMpzf35vv0zMURlt/LzX5mHSDQh+okmdxAvK8l5x6RJ7OHRXWG
         eb8+YPpukX8ZC7Zx3CiozXY7TFCfSIM8bgafeokFRQr2eTFrdAtoH+Znm9TvUFCW0tWx
         XkHx3zrR4bC9UFqesPm1tLP1kAarABNoPQOMFRL+ewx+5I2gXpwB2JfYFw7FsfZl6+e1
         lXiN/CjbbJLejsBz6xZQZib/mTIfxxb8GGj5OijFeznmd8WnzBZ5iZaitVvwQXG5Ly2m
         sn1lqyU0UlwL6d2T0D34+Ua7TH5L3shApkyJPuclCo4TIcvQzhZK19iM/cX2jXMZV7r0
         1CZg==
X-Forwarded-Encrypted: i=1; AJvYcCV/yYKxP9Hdq38WYkQzHDZHjbdWSrddPWtu5lrbUfMZRCnLQkPsbXY+OKOnRw795wESnVVIoaswTtfRTEKag5g=@vger.kernel.org
X-Gm-Message-State: AOJu0YzYUyMUGaUzKe98V9H9op7KEeWzo1SdgL4+JbrwiLa2iX/cm2hj
	A7NWCd0WZ4trZ1xEjOTOCKvYUk3gYOR6gI6GChFBEE3KTq53qK1OitBtTVf4Gnn7bn3s2FbHu/D
	2TftpqK69D/wGW+STLzleDnaCE7hptjE=
X-Gm-Gg: ASbGncuIvYJgfzStwXTBYGw8wmbRUHB4MxRQa8nh4R+IH1NGEOGhZzjnMD8g9p96IQM
	UPREJRRiJKR2YM7EmMpPi52rfgjE3wmeYtzA93lijt07513A8QtaWlcM4fp/jzH/QDQRyAgYP/C
	wX97ciXJDlOOjNtNL1rl2sy7HEo9/9ILC8fDycQGZxgxKZHG61HhqAm4c4D0GfpMkFDXm4qsOJd
	zYH3LEn2c0B/pd+S0gFOFxhtPfH8c8nZ+3VKGiKk0i3/hfoS3HxQWSn6/7dGIPWhlMb6ppiLg==
X-Google-Smtp-Source: AGHT+IH2rAtLPqjrPkzQAgRzLtpqU6GW5KqXZk29vl3BVB2lerYk/71eQQApYbtq59ICPt5hKbYpbTG3+CYs37kW9a0=
X-Received: by 2002:a05:6000:24c1:b0:3e7:60fc:316f with SMTP id
 ffacd0b85a97d-3ecdfa357ccmr500935f8f.45.1758078623223; Tue, 16 Sep 2025
 20:10:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250912163043.329233-1-eladwf@gmail.com> <CA+SN3sp6ZidPXhZnP0E4KQyt95pp_-M9h2MMwLozObp9JH-8LQ@mail.gmail.com>
 <aMnnKsqCGw5JFVrD@calendula>
In-Reply-To: <aMnnKsqCGw5JFVrD@calendula>
From: Elad Yifee <eladwf@gmail.com>
Date: Wed, 17 Sep 2025 06:10:10 +0300
X-Gm-Features: AS18NWBRXY6QRQwpfBo0poGfWO1ILeFSm2NP9vXOGP2coW97SISUDWSiYlpGLTs
Message-ID: <CA+SN3srpbVBK10-PtOcikSphYDRf1WwWjS0d+R76-qCouAV2rQ@mail.gmail.com>
Subject: Re: [PATCH net-next RFC] netfilter: flowtable: add CT metadata action
 for nft flowtables
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 17, 2025 at 1:39=E2=80=AFAM Pablo Neira Ayuso <pablo@netfilter.=
org> wrote:
>
> May I ask, where is the software plane extension for this feature?
> Will you add it for net/sched/act_ct.c?
>
> Adding the hardware offload feature only is a deal breaker IMO.
Software plane: This doesn=E2=80=99t add a new user feature, it just surfac=
es
existing CT state to offload so the software plane already exists
today via nft/TC. In software you can already set/match ct mark/labels
(e.g., tag flows), and once offloaded the exporter snapshots that so a
driver can map the tag to a HW queue/class if it wants per-flow QoS in
hardware. Drivers that don=E2=80=99t need it can simply accept and ignore t=
he
metadata.

act_ct.c: Yes - I=E2=80=99ll include a small common helper so TC and nft
flowtable offloads produce identical CT metadata.

If there=E2=80=99s no objection to the direction, I=E2=80=99ll respin with:
- the common helper
- act_ct switched to it
- nft flowtable exporter appending CT metadata
