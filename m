Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5730C230274
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Dec 2024 13:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733925222; cv=none; b=pVCHsBocqulDBhsRHqzo6RriBWNAwr9OOXGOCFVX3M08Vz3sYWGsolmSXSnMjhrGcmoVQSC2L11Awo+lcKdpcRb8zEVGgVHY/+NzQb0ofZbt3DgmouOPMh8e1S4UXXNwkgyef1kibPHdg5Ngjz7BvhjcBSs62GBDyhU57qD0+FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733925222; c=relaxed/simple;
	bh=1ler+6t5wwhzmcNaLGwLWs8a2MX4ASG3Zvx3gT94VPY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q8SjtTDdjnhewbTLN711qeA68+Jce5IU3zmTgzR8R7pQ2+zjKM47XiAg6iqXeNNLLGW6s3Pfxt8RW1YtqX9FfeNbQNHAwQMTs7e91L1qyzVjAA2JbvfoJmpHX2AubBDcPg3QRJEQwavIlL7tFjIzsCy+vmWGW+U5lNMEvmlX/xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=omDj3KJs; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="omDj3KJs"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-30039432861so51963211fa.2
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Dec 2024 05:53:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1733925218; x=1734530018; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jyglwL7lcLajD1vfvAC6TyqBHbq3YqYRZog/vZd+lPo=;
        b=omDj3KJsPkdP7UDkEBkr8I8BmUFjLlncQnR8U1KHRmWs4eX2Od9WNA0Ge1slgLs74D
         hYp6a4U1CyacZbInWvPD/TL56ag2IN1BQUOKGZ24bAQo1knFloHJGpw6RLyKLgMI/Ich
         FQ/eIr5U5m601YqwpLL3O61FD+9kURKiEawOMu3v9ORmtUW1sFkB3D9mopTziG+ajVix
         8e0RXBaq3HeM/bK2ndvdwgZ4lgGxZ7oVSqCK3Y6ZlazYDPlzbcUJuk9BnvualA6K12vy
         36remNoOn6ih/pluAhyQBzIt1XF6dN0GBvAskyEvdi7SBuoKVEa+r0ga5WUGsgSibr6l
         nCRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733925218; x=1734530018;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jyglwL7lcLajD1vfvAC6TyqBHbq3YqYRZog/vZd+lPo=;
        b=NA/r6LT1Sq2ddSu84gfgO6YPwkBYcYZ31oCf3uoXrUfp1jowFB5bojWNSoWwPuvWIP
         kK8FwoiSjT7cCyfEb9u1827hBjiwWlQ5h0LgOOhmo6M0S+GGA5+wGja5rTu1gsbnllud
         RD1Ge9rXAUZpshf87X+P3oVc+hBe07jF9Ih/FumhfmwY2mAQxyz07b99KvC20HNqwKyb
         myOBLMP1LEwHxveDP9WVyOGbtLLeoyKf3UseywAgIcL6cwuFD79/4y9BJDzaGil5lZoj
         rnJzDpU3pvZVBiT3d60jFwAVTXXanhzLQaZMj2uBl89JI5Xv+gHMBz7zfuc0YY1dWcB9
         Ey3A==
X-Forwarded-Encrypted: i=1; AJvYcCXaMq61orjKGbkiM3CuaVVGbZlwb40rmFvN52wkl27WsGbTEKI+GLPatMu5/Y9rYT0+LXUb81lwpft4mVFR9NA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwF71ZKnQ0lXSBmLBBlk716YGat1fRphRmTXyxotfuMbOnzkcUs
	hL8HybmaYLPzH1J9aEy/H4aypjg4csgy4IFpqsfdlkEhA9c8PU/Dy5TH56ic2PfCCS/3xJRNl+r
	/3lZF/3dw2upHB2HVbhWlOopInz51Pfdem9sfLA==
X-Gm-Gg: ASbGncu41t0DWAPyWqacgQIWi8Eh89ubcsG6OujVpSMGUMYMi5catNnAKQ4Bioxv5eq
	whL7+1MMXW1XzXRs/MFLB/uB0sAkUlEWesDBKqBOBneq4klKdjTCp0+Nx5X1ofLOw1rk=
X-Google-Smtp-Source: AGHT+IGPGpFba0wsi4op1Gj+i5/QGCDpVBGPrx3rA3uLS79Kse28wu78qqyJ+hwtxlmidsvWthwfkHUhBW/gtPRZ2IA=
X-Received: by 2002:a05:651c:1542:b0:300:33b1:f0d7 with SMTP id
 38308e7fff4ca-30240c9fc57mr9357831fa.5.1733925218339; Wed, 11 Dec 2024
 05:53:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1e0cf09d-406f-4b66-8ff5-25ddc2345e54@stanley.mountain>
In-Reply-To: <1e0cf09d-406f-4b66-8ff5-25ddc2345e54@stanley.mountain>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Wed, 11 Dec 2024 14:53:27 +0100
Message-ID: <CAMRc=McCc3G4D4rHVMfGBTdvi6z5Nbxqzg+k8iN11+vazffSnw@mail.gmail.com>
Subject: Re: [PATCH net] ipvs: Fix clamp() order in ip_vs_conn_init()
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Julian Anastasov <ja@ssi.bg>, Simon Horman <horms@verge.net.au>, 
	Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org, 
	lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, linux-kernel@vger.kernel.org, 
	David Laight <David.Laight@aculab.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 11, 2024 at 2:16=E2=80=AFPM Dan Carpenter <dan.carpenter@linaro=
.org> wrote:
>
> We recently added some build time asserts to detect incorrect calls to
> clamp and it detected this bug which breaks the build.  The variable
> in this clamp is "max_avail" and it should be the first argument.  The
> code currently is the equivalent to max =3D max(max_avail, max).
>
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> Closes: https://lore.kernel.org/all/CA+G9fYsT34UkGFKxus63H6UVpYi5GRZkezT9=
MRLfAbM3f6ke0g@mail.gmail.com/
> Fixes: 4f325e26277b ("ipvs: dynamically limit the connection hash table")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---
> I've been trying to add stable CC's to my commits but I'm not sure the
> netdev policy on this.  Do you prefer to add them yourself?
>
>  net/netfilter/ipvs/ip_vs_conn.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_c=
onn.c
> index 98d7dbe3d787..9f75ac801301 100644
> --- a/net/netfilter/ipvs/ip_vs_conn.c
> +++ b/net/netfilter/ipvs/ip_vs_conn.c
> @@ -1495,7 +1495,7 @@ int __init ip_vs_conn_init(void)
>         max_avail -=3D 2;         /* ~4 in hash row */
>         max_avail -=3D 1;         /* IPVS up to 1/2 of mem */
>         max_avail -=3D order_base_2(sizeof(struct ip_vs_conn));
> -       max =3D clamp(max, min, max_avail);
> +       max =3D clamp(max_avail, min, max);
>         ip_vs_conn_tab_bits =3D clamp_val(ip_vs_conn_tab_bits, min, max);
>         ip_vs_conn_tab_size =3D 1 << ip_vs_conn_tab_bits;
>         ip_vs_conn_tab_mask =3D ip_vs_conn_tab_size - 1;
> --
> 2.45.2
>

Tested-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
