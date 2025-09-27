Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00AF52E0B55
	for <netfilter-devel@vger.kernel.org>; Sat, 27 Sep 2025 13:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758981373; cv=none; b=rB+wDl54+c1RZ9/wPYYg2oSGqsR0eBl338kGRKQIA9AN9EiP7DkGua5uQmw3D0jBNMcibukY6IUiVeP6g0Rqbk4fDbvd6j5pBXfBIyPVjBZqYjAuhYHLEwt6IjZbxux3Rb/5CV6JGqQWY2GCD2wH6rnkUSs9Xhrv6jaxvqbRV5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758981373; c=relaxed/simple;
	bh=ureChU45nREqUmvZTTVk+SwNTIJzvHOY5zs5cEzl+t0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N6rrMsSKzRe+aW7hsm1gsiDCZmaj+rslcgMpXUIzU5WhWkrHXfUvnTr5IUxdvRvm2bWQq4zi+SiRge1/Mf/O57XYuoxunrRC/cOM3fbPF/W7tRjkttO6I7bqspNPox80WPmw9oZzjXkbeZ112gtoBNNOIh2LX0OAK0/H5nMfw0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wl8taeLZ; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wl8taeLZ"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-45b4d89217aso19090495e9.2
        for <netfilter-devel@vger.kernel.org>; Sat, 27 Sep 2025 06:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758981370; x=1759586170; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ureChU45nREqUmvZTTVk+SwNTIJzvHOY5zs5cEzl+t0=;
        b=Wl8taeLZnSuAkaYOcGiWwHKKI0GkeDjdflDaWh6frmYQL0Z+k0Xx3jt3oZUPBO2PqF
         98avA75obFkBGIjilt9vyuxg1DdCi5eiI0RN29bC1O3+2BOewamOw/Ff1Y8evzLlX5Ln
         eOI6Axl76EKmWtoitIKbIDFVB70ixzJ4AJrqQNLXYjq9degIA7/ybCmsXwt1qb6QS8tZ
         kcsqJBgXoL5Nph4MZ7ld9jxvW/lmD2u6bOU6wOGhdctGysb1alze/Ijnxyr/jcD0Phjs
         mvdJG0EDXfS9RaQYlmg7AvXfTSQFB5lDfQjcn8weyOwqNvjftEPUMqvxbcYg3uB5k4vc
         fU9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758981370; x=1759586170;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ureChU45nREqUmvZTTVk+SwNTIJzvHOY5zs5cEzl+t0=;
        b=vqvNgHfgJ8iwgA2VVexGVqYqIQbjUuOYN4Csl1doACkEpBHU93X3o0HZWgV4pdd9Jr
         +4lN/u5P4rz9R7EMtH2x80V+LAOY+8jw0S8bRoAAWis00gie1gPyz6AAkvW5Lg0CpnJ9
         zYj4D2EucS01T1YPrm7miMNqLVI2jGkY/JlpKgpMz+VDfjOna3NYu5E7RCybP1rzcC8t
         jvAbOQhBgUJzSKfI+fGV0ECg0T+Eo8tQ6V199CVEuGZ9ZIbjY4xhGAvyzUsoH7t6sowm
         VqbVMvewlkwL7todpledLmSV25WMH715KHr8PZADw0GZiIWQgPZh9mfDNUvGz+YswXro
         xMZQ==
X-Forwarded-Encrypted: i=1; AJvYcCWPjJli93TtbIXMP/UkaCZoSZOkvtrlgOb+alQMYVZnF7OKS9M+qF33ZmlvEC2eP8i7iO9jhWnWEBu94LL4Mtw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+W505Ue6GBswDSrMT7TGktav6VbnEfl9VPPFVtAnWWu0KYWwu
	s1/fr/oVtE8QwO/6QpMVX0XLEP8V2gZdrE7H4fHjTW3jRw4XlSIkgJAt4fWHwBc1I/I1llUREH3
	L5lmpeRa/g1ComuI7HU/FMv3kuX9NT2Q=
X-Gm-Gg: ASbGncs5KUVXn8SG+tpkMuk0d9b7TTRrMPWa9OZvKy/fad2B37AJIDmK+fd/DVe0NI3
	ihzdvKciQNVwJMATzzFCzXDIAlymJeSW/r2ZllYlX+PhnEAyH7V/Dx1RAJZ+LRWFwW0l1ugg9qk
	pTWVQfoQiKULcYS6lfFr5gXFTVx5Zl7ZLx9QQpXAK4/lvbOR+UerOZYsUeSJ+R5MCRqp9ohc9Kh
	PVmS8N/m5ng92X9aKujYqmIM9rkrXPCOwnxcaJdwUhzeDcdhg+vtQp1VyYIJ8LUsET8kdhr2QZe
	ZJh+GA7U
X-Google-Smtp-Source: AGHT+IGr8zOK+RC+hHIYloBf/M6OFm9CLonT2X9KL0+nRhOcgIc58bzH/HUeqmIKXIC0EyAYm8IIg0+2JgEjPzNIGIA=
X-Received: by 2002:a05:600c:3594:b0:46d:7fa2:757c with SMTP id
 5b1f17b1804b1-46e329eb02fmr105794995e9.19.1758981370031; Sat, 27 Sep 2025
 06:56:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250912163043.329233-1-eladwf@gmail.com> <CA+SN3sp6ZidPXhZnP0E4KQyt95pp_-M9h2MMwLozObp9JH-8LQ@mail.gmail.com>
 <aMnnKsqCGw5JFVrD@calendula> <CA+SN3srpbVBK10-PtOcikSphYDRf1WwWjS0d+R76-qCouAV2rQ@mail.gmail.com>
 <aMpuwRiqBtG7ps30@calendula> <CA+SN3spZ7Q4zqpgiDbdE5T7pb8PWceUf5bGH+oHLEz6XhT9H+g@mail.gmail.com>
 <aNR12z5OQzsC0yKl@calendula>
In-Reply-To: <aNR12z5OQzsC0yKl@calendula>
From: Elad Yifee <eladwf@gmail.com>
Date: Sat, 27 Sep 2025 16:55:59 +0300
X-Gm-Features: AS18NWBlYzv4rg7URg9J1v208P3mV2tQeMkzKbuflldE-TNBrvutb99r7dTcmXk
Message-ID: <CA+SN3squaSg08e=GKLZeStS3bSaKQZz_n0SWOB=Cv8cuLhO1Vw@mail.gmail.com>
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

On Thu, Sep 25, 2025 at 1:51=E2=80=AFAM Pablo Neira Ayuso <pablo@netfilter.=
org> wrote:
> You have to show me there is no mismatch.
>
> This is exposing the current ct mark/label to your hardware, the
> flowtable infrastructure (the software representation) makes no use of
> this information from the flowtable datapath, can you explain how you
> plan to use this?
>
> Thanks.

Thanks for getting back to this.

My goal is per-flow HW QoS on offloaded connections. Once a flow is
promoted to the nft flowtable fast path, nft rules that set packet
marks are bypassed, so a driver no longer has a stable tag to map to
HW queues. The conntrack mark/labels are flow-scoped and persist
across offload, which is why I=E2=80=99d like to expose them to the driver =
as
metadata at the hardware offload boundary.

To address your =E2=80=9Cno mismatch=E2=80=9D concern: this wouldn=E2=80=99=
t change the
software datapath at all, it would only surface existing CT state to
hardware. Could you advise on the best way to proceed here? Would an
offload-only exposure (drivers may use it or ignore it) be acceptable,
or would you prefer a specific software-side representation before we
add the hardware export?
