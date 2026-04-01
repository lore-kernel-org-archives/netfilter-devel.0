Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABFA13CAE7F
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Apr 2026 09:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775034901; cv=pass; b=pvJ4jwaw0eIK/61OdQEbCVVyC7gC33Y+jxiJGtltFlm3upTodQSKQzFqPvV39ZtFJ3lxnfr6+5czPhYzvlk1YcqZJcDitmo5BGZtokHLirqxon6U3s8TDAIdRrisH+xFrHYO47a74uky4CwM2XIVBRWr2k0WF6jg67Ypqz0e8n8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775034901; c=relaxed/simple;
	bh=Px8VZ/mZa/wVBiSvlhUqswxvgLPunBza8vM2mBYbtJ0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ND3vOCHk6MNKIxh0xZ/lG2DHhWD82OIq7uxy4RpSjIpUNmdgD4mMcm7PdOcLmuO2mP4OCN6mC5oOMEDlduCJHe2VrMcJ+1uAN56qgJbRzCVxdhQV/82GqzxD/wMYvENuSYrfqKSZ2t7HDoASoYux/2LRziXjuBtOvDDEMjQ1ANg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sMzYgbMz; arc=pass smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sMzYgbMz"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-506bcb23a78so56595281cf.3
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Apr 2026 02:14:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775034899; cv=none;
        d=google.com; s=arc-20240605;
        b=QECi6jBcFAgrHRy1W1DmJioRufmBuDRNgyAbCFAY/d0cYnLZ91IqCxJd3bI9hlIW6o
         WeCMv5X6Q3m/5xF4PNVJ2+wb3K0dhEo+7zuBb723znc1co7ozhNoy5PuBrltGjZ9aI/o
         Kz8l92bpHk8y7TyJcKEpyCwzYkHdxPB7dq39fbMw4gnTGHaCGHNriqZabyF07ei2wkbS
         +mbGPyIvmCNwnEPqovMzp4Yq+1gUFhWt9DYXPMGeBsQGjLKyscmwoQcJxiI4u7B7o0d9
         WP/X/ZY5tU3JErp/aRJvM8Dxw1Z8DKqvBfLd0+nXscQh+yWJLNO0bLVbEMrouuEvrtCV
         hs7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QNCKy3dqIhDpgGkChFZLtJKaP66u94+8Bb0TUa2FxLg=;
        fh=8dhfDelTrj0v0xEwdlk9qqpqbMvoh7/Bf9VxgPtejKE=;
        b=C6xiL5U9i+hNRtkLxeJODSJacHLkUURa6Xi5toIdPpMxl955rRnwhBnJLb8EAk69an
         kMwqwZWD8Tqx5r/UzxOvNdmSa6XqAsgVvp16jNfEoh5DWaX6uq4KxSWr45Or3wgLbhxn
         t9h3+peoH3oiK35L9Yd/PDwTn5GbJSW+xLIu/woZfs+LDOyXBqYfevi3+eRtDmknHins
         XO9UkQJMro0HbWzAjiUUb1u2VvNk4p+xLbWg2ePzrvH4x9Z2gOPBBeojD3TIMc5vICf9
         WYYUpCJDxqk7tD+bKmq397inkN0o9nQWy87uhhCKtD1BeaX5Exwjk8f3u2NQrm3wQ58N
         Ecrw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775034899; x=1775639699; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QNCKy3dqIhDpgGkChFZLtJKaP66u94+8Bb0TUa2FxLg=;
        b=sMzYgbMzy/XBDdx9usXDSprxn/9n70NRH7AzlJkkUEJV6+qUMsHyJUAGTbqFa8joIY
         +EVnBm3sxOV3otPh4+zawdjRPyPOCA8YmxmnN/9KP4464zrZkqwIO11i/N8+RpyHT7rT
         3n8BbQeQGfpJC2uBHWlauwhGTHplrqK8IxigbvpDuqz244ClURN22tKgupscat1wXGtM
         xMELotbCxqNgEdm1/YkEzrwECIvw2Xyak+uwfI+1hy4nJPaB7OuhwdJ9xUMyafDv+LDt
         N7jyY99/brSlB+Tqz+KGDZJByFWX3Q2aM/W/s9QaI87i54ffwpB/4nX5LbcXWtnP0D96
         6QSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775034899; x=1775639699;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QNCKy3dqIhDpgGkChFZLtJKaP66u94+8Bb0TUa2FxLg=;
        b=BYv4U9HejRTpqTmwk3w6IfGrxkZCJRUq/eSjDK74jh2oQjc189nWc9pCIx3XdouwrO
         I2ZHxIpPIKQ8nw3bgD0mFMSEB83IGQKa3Y7Wan8S6fM69bUgAIBAD4c4fqWJDph91Xc3
         yqsZsxBCeI7aP/h3MuNKZZAiPWidWaWfd/a+AReNfYB+AJfVOzPvnUCmIMXUMWS3/439
         LGkD1HyKpZWCGPHS9TaDR0OOyzwQWVFbMpl++lUnsJUjn8joR0IMuTTBX7l7AZ6urOgZ
         SeSat2biX/f8sbXB/KSioVpJKfJE7xQLVmIV0G21C+rh2ilUL11BDlMeVcaSn/VdffkR
         Vv5w==
X-Forwarded-Encrypted: i=1; AJvYcCWREzuGqATSaSkrBb69PvTHlrQLNrjwqUf24/biNyGuPsA7gmlXUsLhy8KIut+qUFWlDRcblh42ROH8eiZJvwI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRogg7xjYdVGUN06v1GRBZU1lcHWnJbV177763k15fzLobVgvO
	ufadjIDtV4prRStbb8AUK3HSjOEh/5d8bWtlWXfbGMYl+5kK539ppB9XJLeDzJ6hCgZfJJGHmID
	5BRntK7sBwz2hK9t4NUEpIl8r/WhntuP4TPccRJ83
X-Gm-Gg: ATEYQzwh7FCEH0tRk+680AIxqSYlxxJxfS6hp+eScQEptL9Zx4EgYLSd1bFHdTfpc2/
	1uRTwqA6CiYjp99O6Q+iePrLRX3wLTcOi586rkQ1zhJE3tJNu+Jz1SklXMyWw+56BZ/6Y4XUtqm
	VXtB8djp0qevHTqcKnmn86eycbjANlQmhivh6cKJF7nNwOyBQYLUGA5uVDMtA3GVs9dobPXm1Cv
	n5eDutZJ8hDQNuvvxPsY/7enpY2U1qG5x90DWSA80WaaUTxr/rIUQnPs2ZS7pOGaVsrcNuY7Ge7
	oMrYEA==
X-Received: by 2002:a05:622a:1c05:b0:509:2ef7:7034 with SMTP id
 d75a77b69052e-50d3bcf5f5dmr36705111cf.50.1775034897967; Wed, 01 Apr 2026
 02:14:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260401074509.1897527-1-dwmw2@infradead.org> <20260401074509.1897527-4-dwmw2@infradead.org>
In-Reply-To: <20260401074509.1897527-4-dwmw2@infradead.org>
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 1 Apr 2026 02:14:45 -0700
X-Gm-Features: AQROBzAoGbAvZgGI1SP1QOjEPB9AfHu4JQqffzH3Pc3uWqwtvvbxFW3VGI6Tc4w
Message-ID: <CANn89i+iRUgqtd+eirfSUM3k+keNZKzLwsHxZtwE+vHdv7H5PQ@mail.gmail.com>
Subject: Re: [PATCH 3/6] net: Guard Legacy IP entry points with CONFIG_LEGACY_IP
To: David Woodhouse <dwmw2@infradead.org>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Tariq Toukan <tariqt@nvidia.com>, 
	Mark Bloch <mbloch@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Nikolay Aleksandrov <razor@blackwall.org>, Ido Schimmel <idosch@nvidia.com>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Daniel Borkmann <daniel@iogearbox.net>, 
	John Fastabend <john.fastabend@gmail.com>, Stanislav Fomichev <sdf@fomichev.me>, 
	Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Song Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>, KP Singh <kpsingh@kernel.org>, 
	Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Willem de Bruijn <willemb@google.com>, David Ahern <dsahern@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, 
	Guillaume Nault <gnault@redhat.com>, David Woodhouse <dwmw@amazon.co.uk>, Kees Cook <kees@kernel.org>, 
	Alexei Lazar <alazar@nvidia.com>, Gal Pressman <gal@nvidia.com>, Paul Moore <paul@paul-moore.com>, 
	netdev@vger.kernel.org, linux-rdma@vger.kernel.org, 
	linux-kernel@vger.kernel.org, oss-drivers@corigine.com, 
	bridge@lists.linux.dev, bpf@vger.kernel.org, linux-wireless@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	torvalds@linux-foundation.org, jon.maddog.hall@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 1, 2026 at 12:45=E2=80=AFAM David Woodhouse <dwmw2@infradead.or=
g> wrote:
>
> From: David Woodhouse <dwmw@amazon.co.uk>
>
> Wrap the IPv4-specific registrations in inet_init() with
> CONFIG_LEGACY_IP guards. When LEGACY_IP is disabled, the kernel
> will not:
>  - Register the AF_INET socket family
>  - Register the ETH_P_IP packet handler (ip_rcv)
>  - Initialize ARP, ICMP, IGMP, or IPv4 routing
>  - Register IPv4 protocol handlers (TCP/UDP/ICMP over IPv4)
>  - Initialize IPv4 multicast routing, proc entries, or fragmentation
>
> The shared INET infrastructure (tcp_prot, udp_prot, tcp_init, etc.)
> remains initialized for use by IPv6.
>

...

>
>         /* Add UDP-Lite (RFC 3828) */
> -       udplite4_register();
> +       if (IS_ENABLED(CONFIG_LEGACY_IP))
> +               udplite4_register();

udplite has been removed in net-next.

I would think your patch series is net-next material ?
