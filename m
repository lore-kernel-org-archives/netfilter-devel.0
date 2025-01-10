Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFADA208978
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Jan 2025 22:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736547818; cv=none; b=JgsJxHi+ql6ahd9jPL1mBZqGVpUsjf/5opGhg7zP+hV2gBkEk9JY+sfTYR/2XKT1/Q97llfXhpvKw0IccdXjfltGISBsgcwYrFmjuaGg+h2cJPfp7pzQM8vw3ISt3YWXbEhDiDkYriT94n27unnkZf5g+7IO21E87jlG5qUpCQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736547818; c=relaxed/simple;
	bh=RIKXcDmaC3fNvrvbxiEnNzJHYSIrH+lby0DENumEkMs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=GM6XmE1GSKNOMcgbTvfSQrGmhrAxRT9jUOcGTD4Uj/m+2Pvc1mWK6XP6Eq1TIRMZ565xs+Mbse9+AcG4rWZthSdmMG+wSKTLHT7Eno9DGSF+VH+8Rqp3wa5c3Z3G6PSAw01r4sywwCYSdnEMX9znopHA70H/8kQtKpjBJ6HvYXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VXAnqU8J; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VXAnqU8J"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5d3bbb0f09dso4309035a12.2
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Jan 2025 14:23:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736547814; x=1737152614; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2zvVUoEeneMw4v87L4EhpeNobEFp9p2ngiPEvA8kTE4=;
        b=VXAnqU8JvBmFbYnmHqvsaWABbyz1i9PiMNkby6cl8xxzl74UXI4xJwSdkoActlg1Pd
         j88ZIeP+GSgtrFHaQehqOfGY8Uz1kIuD7egOMKkAR1Y7wBN+c0A/1rXH7hkvfOcPdl/6
         5albyOPRqvhCL0sPiyfWw4wAP5agFlaoJqooEuXRzYuBzxs4mctatkxPmWL7xhURYCUn
         042N1Ma07okieYmxs1QOFtaWSJK1SQ3Ev63Trny+y7A7kBsmGyHTv+vzMOXORoiKVJXx
         4uqSIw1J9OkIEJt3HemdA+NhGD6eqTvHR6sKcVkzZy+rpiNpmwENjPBNUQqK7eyKg6GV
         Acgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736547814; x=1737152614;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2zvVUoEeneMw4v87L4EhpeNobEFp9p2ngiPEvA8kTE4=;
        b=pXPeBUrsKOk1KCRzWhogvb442poNq1w+8lDkbsfY6UM6DFT2BQMyyEagXsRF+sPRCJ
         H0zL30frXZeQSMi8y+M/ezJlsK2ls03qGeIptromff0NyXk71PKFmGuYOTW0F0tbJ6du
         1H7OMI3XumCP30X2gSYyuc5rtWmCq5DZBlmyYYHst3K+AsD5LHNpgE1APH20yWcEiD0j
         Ky8b4FH73VVYTe9yQ78oFIaEHqeXGnK/Z93z3CLB3A2x5bCbovjc4S1wpUzSMmaObuT/
         hbuh2DTlbG3a+7pUrde43mXdmogK/IR0x5ygJAFJKkZrP+dLt4+UdmMC5Er2xgCN3Rof
         +6aQ==
X-Gm-Message-State: AOJu0Yyim7IFPHxgIvOtOCaEWVQoqi1JjGiucmxvyk6HtemDkzQ31oB/
	af57LjSGR1Sdy8vC8rSRgOvnFK4cGdxjNVdcW/Vnw3Ox1HWbRvH08iXfrVMVvKfAhUjmHO29OWo
	siNOmErZXOv6aPVO7pKBdy3AxpS0limlH
X-Gm-Gg: ASbGncvGjtDfcAOlGXSGeGC+HPL4OUbJK8zST+sN4lNNyS/Zw9o6rGEgeLAbZzYAlr4
	TuWzO+VD7YW1OBRKr9BsIJO1Sf2SjvQCymHGCpLLA7wsC8Hx1ngHj37LlzUYEpo6XpntfKDTR
X-Google-Smtp-Source: AGHT+IHGLKU4rAgZwCNGg1cYEAueEpU7ndRcvjOnFsk1J/zuLWGLnRmEdIQTEcPxswa4idsXNK8sH2VcI3UVvOPK36Y=
X-Received: by 2002:a17:907:3f95:b0:aae:b259:ef6c with SMTP id
 a640c23a62f3a-ab2aacfbb7cmr1226571766b.0.1736547814203; Fri, 10 Jan 2025
 14:23:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHo-OozVuh4wbTHLxM2Y2+qgQqHTwcmhAfeFOM9W8thqzz6gdg@mail.gmail.com>
In-Reply-To: <CAHo-OozVuh4wbTHLxM2Y2+qgQqHTwcmhAfeFOM9W8thqzz6gdg@mail.gmail.com>
From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date: Fri, 10 Jan 2025 14:23:22 -0800
X-Gm-Features: AbW1kvb3VsFT31E305QGANKvJyjAq8dKFh6BUOEj8W_XXIYZzxboh4LS-EFvrfw
Message-ID: <CAHo-OozPA7Z9pwBgEA3whh_e3NBhVi1D7EC4EXjNJdVHYNToKg@mail.gmail.com>
Subject: Re: Android boot failure with 6.12
To: Netfilter Development Mailinglist <netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>, 
	Pablo Neira Ayuso <pablo@netfilter.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Oh, wait

.family         =3D NFPROTO_IPV4,

in the v6 section

On Fri, Jan 10, 2025 at 2:20=E2=80=AFPM Maciej =C5=BBenczykowski
<zenczykowski@gmail.com> wrote:
>
> We've had to:
>   Revert "netfilter: xtables: avoid NFPROTO_UNSPEC where needed"
>   https://android-review.googlesource.com/c/kernel/common/+/3305935/2
>
> It seems the failure is (probably related to):
> ...
> E IptablesRestoreController: -A bw_INPUT -j MARK --or-mark 0x100000
> ...
> E IptablesRestoreController: -------  ERROR -------
> E IptablesRestoreController: Warning: Extension MARK revision 0 not
> supported, missing kernel module?
> E IptablesRestoreController: ip6tables-restore v1.8.10 (legacy): MARK
> target: kernel too old for --or-mark
> E IptablesRestoreController: Error occurred at line: 27
>
> But, I don't see an obvious bug in the CL we had to revert...
