Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C1D265626
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Apr 2025 16:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744217783; cv=none; b=b9ObnPb2XjyQT/J12/fI7f0BpTf6Iborkywf1n84H3hiDF4t+wqmH6NLPYt1KFqNW9VVuKg1vlxOYgw6NnwpYN1O7GbIPiqinl+jP5mkNwURoZoxTIHGBYxIITInO1krji2yYVTNaD8a0df5mk7yhUesEJc4sUviXeEwQLs6Zek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744217783; c=relaxed/simple;
	bh=CahJy6bgX2TLgx/3RS9Og1YqQekeZkWNYVidjSfotuY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rP5HSo7Pc8Sot/1a17uZYKB3FtYmw8tUVMxtQoOzlH0qyxw5u8GcXVOyR/zw8rkwTvvoUkkuNTLFuvwusmMYUnsqv0UIYqvVIceNp7sHnNwht2Oo0R0xpdbEVTPCdrkvf3SZiNi/xDPqTt7AQrJ/XzBKfu/35aqConZie9YPx6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Jaqj/Ea6; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Jaqj/Ea6"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-39141ffa9fcso7661030f8f.0
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Apr 2025 09:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1744217780; x=1744822580; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aCygb0R9J4//K5NBuySZGPAIajaz7uNogxidzxnmh7I=;
        b=Jaqj/Ea66noBgWIMfDMKIPnxhOd4cUYDblRJcwIHZOhXg9UN7xSrpjMUrUuI8T3MIt
         av69PYIG/o+nT38AiOIkek7OaSoE+hNmLaugqb6hYylJaG8nNXAyxVxnQM06uhOXpqp0
         g1DYGmyNKCVxAskzpxNzb2Bh6U9NNfPXtmpg+6hOYpdt57zE++6nQqRRjvagNwpfEdwT
         h133wfuS912UY1mSxcu1+u1ci8XD+iTxSifd+ggu31QHWRN/HIOa2W2sfkpkw1bJnbmq
         uDwj+ylarVlQkNr8M8i4BF/gBDHg8vbdx/Kyrd5P2R84mYViqHgkkwHyKI9whV4kbCP2
         NC3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744217780; x=1744822580;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aCygb0R9J4//K5NBuySZGPAIajaz7uNogxidzxnmh7I=;
        b=EbuKeQCjuSW5GYNG7LMadCiYnCVJJuUF84drrsU81v/S4vSpUE8ZSVowtZcfEa9iIZ
         fkDY2ElDtBf4WjddV9wQRJDGwKcT7FBLSIB9EvucaPKBcCQVT2TdDEJTWPb0OqHvvJYM
         wby4rZGdC1Z3zdhTHqbWCZ+yt7gbr1g8eBC8BFLHqqWjTXp2je2x4+/7BeYlPpYQvlyR
         02WAcwB51hSy8EhqUh+gFNq4YNdFvW26Q+JMoxqh7bCbaNGkWw1PWzDG++oTovmOSzzc
         U/ShHXq8LpFy0AYE+o59V3D+uKd+Ao+qQnAWoM54fDeYmqINJeCLGaLLWnwVmob1mwew
         oMPg==
X-Gm-Message-State: AOJu0Yxd4J18qKF8Zcq3tfDQoy8wOdu39WR+d/H8eA+hrMQHDXMXIXZ7
	dKu2aIX+wrt7BeEPEeNsHW/9VvVHKVpDgLFK9w+sf7LO8UDZP+B0l/fY79DIw1c=
X-Gm-Gg: ASbGncvv0ILAaI2XbSPyN3jAe0tZw5p6f3uMtDWctDRno6yOyC1tihOoKjUWjWqRIxW
	A1LicWp7ryYUozA6uwCFl4iIWVqpjZte3oGbn3695q8CRUtSbyjNh5Q3csFaekjfQzac8Gy7Cg1
	n5/fYqbA+m65zjyHV3x0ZZaZzR/8szU6ydy0RlvhZ9i1QZQk2UO/Ax3j6Y28Gt70P4fzEzf4olf
	wPxyk9F/xz2lqL7el47ntPnxdexNDmMfiJCNQDGtl96ClnjbqLZUwpnurnidc6VI2znjkBlr/6H
	b4uLvwZ4VYf2m7zRCjcs4U8FfK9F7kEEwdBE/TTFiHs=
X-Google-Smtp-Source: AGHT+IHPxSpc27gK9gTsJW2IMf1ahXoIOaZfnAb9plx5JSVsHQKEzviSNHHXsGI8r7rx1qPcS3QdDQ==
X-Received: by 2002:a05:6000:2901:b0:39a:c80b:8283 with SMTP id ffacd0b85a97d-39d87ab60f4mr3607872f8f.31.1744217779850;
        Wed, 09 Apr 2025 09:56:19 -0700 (PDT)
Received: from blackdock.suse.cz ([193.86.92.181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39d893fdf3bsm2083438f8f.83.2025.04.09.09.56.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Apr 2025 09:56:19 -0700 (PDT)
Date: Wed, 9 Apr 2025 18:56:17 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, coreteam@netfilter.org, netdev@vger.kernel.org, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	David Ahern <dsahern@kernel.org>, Tejun Heo <tj@kernel.org>, Eric Dumazet <edumazet@google.com>, 
	"David S. Miller" <davem@davemloft.net>, Johannes Weiner <hannes@cmpxchg.org>, 
	Jakub Kicinski <kuba@kernel.org>, Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: Re: [PATCH v3 0/3] netfilter: Make xt_cgroup independent from net_cls
Message-ID: <o4q7vxrdblnuoiqbiw6qvb52bg5kb33helpfynphbbgt4bjttq@7344qly6lv5f>
References: <20250401115736.1046942-1-mkoutny@suse.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="we4mrug4rvo3n7yf"
Content-Disposition: inline
In-Reply-To: <20250401115736.1046942-1-mkoutny@suse.com>


--we4mrug4rvo3n7yf
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v3 0/3] netfilter: Make xt_cgroup independent from net_cls
MIME-Version: 1.0

On Tue, Apr 01, 2025 at 01:57:29PM +0200, Michal Koutn=FD <mkoutny@suse.com=
> wrote:
> Changes from v2 (https://lore.kernel.org/r/20250305170935.80558-1-mkoutny=
@suse.com):
> - don't accept zero classid neither (Pablo N. A.)
> - eliminate code that might rely on comparison against zero with
>   !CONFIG_CGROUP_NET_CLASSID

Pablo, just to break possible dilemma with Tejun's routing [1], it makes
sense to me to route this series together via net(filter) git(s).

Also, let me (anyone) know should there be further remarks to this form.

Thanks,
Michal

[1] https://lore.kernel.org/all/Z-zqvmJFI3PkNl6R@slm.duckdns.org/

--we4mrug4rvo3n7yf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTd6mfF2PbEZnpdoAkt3Wney77BSQUCZ/amrQAKCRAt3Wney77B
Sc39AP99KtNaZNwm4vEZCKRSGG9ggne9YFgWlu/J/1H6QhWHhwEAlOeJU05ieaCW
NpbFj/MBd1Gk3x4gfipNegMDLyOinwA=
=mfjY
-----END PGP SIGNATURE-----

--we4mrug4rvo3n7yf--
