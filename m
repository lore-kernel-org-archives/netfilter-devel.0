Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9687425E445
	for <netfilter-devel@vger.kernel.org>; Mon, 24 Mar 2025 12:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742820973; cv=none; b=MMxR237GsJULyYAbj2fUetmePS4ZrPfDb8n3qTvAx043/L59zkpA0Z1QLLPD6ysQ6dDpb5o3YH0o5WYVkfbr2NfU33wdJV8KWfPjNWiq/W00Fdr+9MERRLet+oPTkB+KokdKcKAgYdGCKQT6hFTZKsEiN2mF78RGBRx5vuvP0yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742820973; c=relaxed/simple;
	bh=Bb5ashzNWlu6TPRKb3SZq8oM68pwtoH9f4wtwRqtYQc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TIREFCPX2U3B0zzrR3TThkjZJpzqs2r5L3klMrdQdkNIzhCrr5Uagoy7uNT5+hNZtEM3dsqkRAZy+BOzUi4BTfo65TINNR3QpW7dLB+T71Be8e+UxUGeASP3GEjyxAWrfKMH/dfJ/Y9R+9/tQ3JXhMpTxCYYUig080CXQolK9KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=doxrXvdx; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="doxrXvdx"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3913d129c1aso3072804f8f.0
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Mar 2025 05:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1742820970; x=1743425770; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Bb5ashzNWlu6TPRKb3SZq8oM68pwtoH9f4wtwRqtYQc=;
        b=doxrXvdxyYtGGTFF7JEWuCuWVtoQ0ZD/FKlMJu0BlMlhNPZ+t2jGrdj3lh3LGcy1Nm
         TkLRba8CUr24B9iq689xezt/BFmnrEMdce5/y+LpXyCjOO4E6xJfPNlC22s4uHf3xX0N
         boycByc/0lXny9nwjTXnAgxz7aj0EczA/Kwr0M33OUWr9SY2tjs5lwX9LSMoUwblKTRE
         jzW++xaud7iyE0+EW9YDVQ8lhvlPdeatWTpqdluLeptwiWKOM41rjH7nYk9ChcTjUDCr
         wdq0/ZN1iKGOCUfa65d3mCnAlkq4c/9I++ooSdTOPBZrMz4XKcli8nbPBgaewIlIBdJi
         ZQJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742820970; x=1743425770;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bb5ashzNWlu6TPRKb3SZq8oM68pwtoH9f4wtwRqtYQc=;
        b=KfHaJngZW2S2FZNLzhtLNe+8ynlJgcxoDHY1khFr4QDidlPlg7NNOOOtLp5cIYcQKs
         2ywm73u35QKhAy9/bS3BEAwrjI1jvR0OZaurtQrqvzPEUXgdU8VpBZQdnrV1IeDUPee5
         xD/7hClV1Z35lMwj4T6t1YvGUh/8ehRADZBWDR6OSqoehFOZztj0XBLJPZHKEYEEbbh/
         RgOvIlpwp3zCDCzY+heaFs8KNulf6FldRfHTbcbfJR6eeAEgCpky8jvFwTgMrbthDaWH
         T/JevtaiumuSpmFcK0+v2xmWyoSKlPkiodauTH7e++zhEJCgBRAfxa3UVdwYJ7xqepIr
         emzA==
X-Gm-Message-State: AOJu0YwmreJxSQVZoSBgjRDe09CBVv13/HA9ojaWiA8hdK1SvdZvB9Iw
	iQ1QiTkErTqZNb8TSAi2HPLbc0iQs0cXawTevtTKQaXStAI6xvJtGatKb7GQQ7g=
X-Gm-Gg: ASbGncsnn8Pkdhiytqa5dabSW/DxUVhnLVKFILJUowK2wGBoDPRfF9mpZZguWYFv9Cj
	oTdOIxmO+zN3NmEvCN7sKSlIStcWAzKBdJCigUiqBe95tcaifyTRWg4wDdrpQP8BKq5plpDl6xZ
	8sjQZ3BJSlm6oPCuI8EP5xVhSuQJhR74MBPMKRm+PD7DvvMEgqTSESkP6nglzxvU+NNPmJSkvwM
	XR7jhw0FJkDZdfGTi0tdw1x1dQRjVLJozSVM5qGQk0i/p1++sNNXSX8vt1Dragwrgq5GhSQhkme
	JyyyF5F7hStziHoRYB2qSZBz1QypbrIJPWW4AEFj4ITEZc8=
X-Google-Smtp-Source: AGHT+IEh+2cx2NjeBYko3qeni7OqGRsZaVwIGE91RRbMpXS3hmSeZB73isRPNemQZA8pSphOxB2XdQ==
X-Received: by 2002:a05:6000:1565:b0:38d:b028:d906 with SMTP id ffacd0b85a97d-3997f933816mr11122788f8f.21.1742820969725;
        Mon, 24 Mar 2025 05:56:09 -0700 (PDT)
Received: from blackdock.suse.cz ([193.86.92.181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3997f9e65besm11013603f8f.65.2025.03.24.05.56.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 05:56:09 -0700 (PDT)
Date: Mon, 24 Mar 2025 13:56:07 +0100
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jozsef Kadlecsik <kadlec@netfilter.org>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, cgroups@vger.kernel.org, 
	Jan Engelhardt <ej@inai.de>, Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v2] netfilter: Make xt_cgroup independent from net_cls
Message-ID: <rpu5hl3jyvwhbvamjykjpxdxdvfmqllj4zyh7vygwdxhkpblbz@5i2abljyp2ts>
References: <20250305170935.80558-1-mkoutny@suse.com>
 <Z9_SSuPu2TXeN2TD@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="6dgz5r7q7tf2aomx"
Content-Disposition: inline
In-Reply-To: <Z9_SSuPu2TXeN2TD@calendula>


--6dgz5r7q7tf2aomx
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2] netfilter: Make xt_cgroup independent from net_cls
MIME-Version: 1.0

Hello Pablo.

On Sun, Mar 23, 2025 at 10:20:10AM +0100, Pablo Neira Ayuso <pablo@netfilte=
r.org> wrote:
> why classid !=3D 0 is accepted for cgroup_mt_check_v0()?

It is opposite, only classid =3D=3D 0 is accepted (that should be same for
all of v0..v2). (OTOH, there should be no change in validation with
CONFIG_CGROUP_NET_CLASSID.)

> cgroup_mt_check_v0 represents revision 0 of this match, and this match
> only supports for clsid (groupsv1).
>=20
> History of revisions of cgroupsv2:
>=20
> - cgroup_mt_check_v0 added to match on clsid (initial version of this mat=
ch)
> - cgroup_mt_check_v1 is added to support cgroupsv2 matching=20
> - cgroup_mt_check_v2 is added to make cgroupsv2 matching more flexible
=20
> I mean, if !IS_ENABLED(CONFIG_CGROUP_NET_CLASSID) then xt_cgroup
> should fail for cgroup_mt_check_v0.


I considered classid =3D=3D 0 valid (regardless of CONFIG_*) as counterpart
to implementation of sock_cgroup_classid() that collapses to 0 when
!CONFIG_CGROUP_NET_CLASSID (thus at least rules with classid=3D0 remain
acceptable).

> But a more general question: why this check for classid =3D=3D 0 in
> cgroup_mt_check_v1 and cgroup_mt_check_v2?

cgroup_mt_check_v1 is for cgroupv2 OR classid matching. Similar with
cgroup_mt_check_v2.

IOW, all three versions accept classid=3D0 with !CONFIG_CGROUP_NET_CLASSID
equally because that is the value that sockets reported classid falls
back to.

But please correct me if I misunderstood the logic.

Thanks,
Michal

--6dgz5r7q7tf2aomx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTd6mfF2PbEZnpdoAkt3Wney77BSQUCZ+FWZAAKCRAt3Wney77B
SRC+AP9sgXg3/nlHJXqWYQNOLruM+2kuDLj+lHSd6Lank2sSnAEAlIfDtD+FKSEZ
igeXXdA6fXYy92Cwb3N2vY8ZfDd2SQg=
=IEko
-----END PGP SIGNATURE-----

--6dgz5r7q7tf2aomx--
