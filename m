Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B5721C9F9
	for <netfilter-devel@vger.kernel.org>; Fri, 30 May 2025 12:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748607078; cv=none; b=S2CFCDy8v/5TDnWEtmMUXPykQbhxXftgYyHIepSoOqQjTLdQPjNRruOvRGHaqCpNXTmquh1h+rtyGQl+29NZjacktJpeFY9+Eg1MIw3+lW8CC8B8/osWBDngNHyZojj2n/VAUqnBzwRwkr5pK9BYOVHDQoSxJMdRtGFXfelx0fM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748607078; c=relaxed/simple;
	bh=4uA8Lf5dy9FL0MLrZAeHcKkTD4JesLwkdwT0xA8MK4o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W9OVOK8/wSxVS0V2eRtDAfuJOetkF3zFXCkVqcfju3FI8cPKJtnLhMIQ8Z55Jz0iDyUei0IS3lik7ZikBebSv4bw0WJiLHbIoAq62APp1kMIn6JYvZWxhMwgYnO3eF9rg9+pM8sfiftDo4oTQs5LVMixjLVWBaD6GDIxEWF4/vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vz14E3/5; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vz14E3/5"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-6f0ad744811so15263356d6.1
        for <netfilter-devel@vger.kernel.org>; Fri, 30 May 2025 05:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748607074; x=1749211874; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3KRa/2n2CI0S5oUTVGjQo71hJpvtcTlHD7KSo/JCmvE=;
        b=Vz14E3/5cCOBinZwtxSXN3flGK20MEuYhfcUPcSZctGhWtlC7sLqPJnMX90CCzp0G5
         tR3yAr1p6k9RWsNg8daSXY/9RMGm+zW458Glsnnbm+mkuhNRs1UOes+2Y6RwiP5A5qkC
         ygLcBeNj8s/qNqGfHnrW35o4ACvJv1hwuGQ5ntgTMVMUf0mtajvBSNrPq5lxDzLgijIi
         OpD1UnEw8gMYgTIcyLZxlG8+v1W0Z4Mj7xG354hruKRrSr3Z/rqEPIHVaSZ9JJ8Bbk8D
         i6SMPCnpiYTgpWGfEgeTYc0oXM5cD4nNDYTdnw+hvGHFOR8ivByodll4EhNm+w7yBa/Y
         ZKyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748607074; x=1749211874;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3KRa/2n2CI0S5oUTVGjQo71hJpvtcTlHD7KSo/JCmvE=;
        b=Eg0hv13vopP3S9R+dVhHWzzgoj8gMDZzNyr3cUVpZCzDiWRypGyYfifiSuvqTWsYa/
         oH3tUf4TKSkFe390Acfc/adY6BJQEGLhGi7ikgTizuiPhN6uSACzv4snO69+D5rTrvhf
         qolweWCBmLNYtjUlx2ttiPlSpyBpDLgZxs66/QiWrRPYWIquG/nysQ4FeyhDwtXRZ1+4
         thkmQpldrTPpMXBqgvkHA/Z+UKSrEBK12m2LKOMxeSzzkGCcxmb37nqi7zgkRqCg6UKN
         hoYBrNQO1hhCHaPC7NKkXdqLxPA5S6EgQd4CVZBjujkPCyTa3zhO+UHA0JixldcUm3tf
         3diw==
X-Gm-Message-State: AOJu0YySjJz8k2I1gI224Y6Njh0+rUEfHdjmGeLUniNOOLBl6QWnJ4N7
	0DSDSjmZ4M6Vv7q5A3ZotYvUnsQ/skBRnb6bSeNaj52RM9aOOO+zMYD8jG/1b6o1cz0IeNAghQK
	W3MOgYu9kzZPEJ6+qXkgYAmHGeTMnwDA=
X-Gm-Gg: ASbGncs5d99Cqrmz1Ogfu+MiVpBbckaNvEiV96h5ATVIaDoYAAjk8bgWUfaoGVdaNs4
	EXlBUL4ReYmI7PyajbzOPLqod9XSJoITRT/Vt5663pFr/aZq5EzAZZwlpdPiC1aaRIGtmpgGBJu
	Wq2/P7E/bwH8LKEdT72uuBO7O9bGb/+FixBg==
X-Google-Smtp-Source: AGHT+IH46vfF4vsagnuKHfMnWWzy28rMCsO6x7mbai324KvipX/TQM/cZJkui6psQtjTB4uyBq+gjqRL2f7dEozlSeI=
X-Received: by 2002:a05:6214:250d:b0:6fa:c5be:dabe with SMTP id
 6a1803df08f44-6faceb99458mr61126086d6.19.1748607073567; Fri, 30 May 2025
 05:11:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250530103408.3767-1-fw@strlen.de>
In-Reply-To: <20250530103408.3767-1-fw@strlen.de>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Fri, 30 May 2025 20:10:37 +0800
X-Gm-Features: AX0GCFt2L7CM6-Q26uQnMEGCyJ48WyjJmMdbIMxQfFeJlwuGHzpSjy0XKhpIT_Q
Message-ID: <CALOAHbAEE9aqy=72ZvU4CJ4SDg2AAG4JjnsgXB1oN5x1tajoyw@mail.gmail.com>
Subject: Re: [PATCH nf 1/2] netfilter: nf_nat: also check reverse tuple to
 obtain clashing entry
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Shaun Brady <brady.1345@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 30, 2025 at 6:34=E2=80=AFPM Florian Westphal <fw@strlen.de> wro=
te:
>
> The logic added in the blamed commit was supposed to only omit nat source
> port allocation if neither the existing nor the new entry are subject to
> NAT.
>
> However, its not enough to lookup the conntrack based on the proposed
> tuple, we must also check the reverse direction.
>
> Otherwise there are esoteric cases where the collision is in the reverse
> direction because that colliding connection has a port rewrite, but the
> new entry doesn't.  In this case, we only check the new entry and then
> erronously conclude that no clash exists anymore.
>
>  The existing (udp) tuple is:
>   a:p -> b:P, with nat translation to s:P, i.e. pure daddr rewrite,
>   reverse tuple in conntrack table is s:P -> a:p.
>
> When another UDP packet is sent directly to s, i.e. a:p->s:P, this is
> correctly detected as a colliding entry: tuple is taken by existing reply
> tuple in reverse direction.
>
> But the colliding conntrack is only searched for with unreversed
> direction, and we can't find such entry matching a:p->s:P.
>
> The incorrect conclusion is that the clashing entry has timed out and
> that no port address translation is required.
>
> Such conntrack will then be discarded at nf_confirm time because the
> proposed reverse direction clashes with an existing mapping in the
> conntrack table.
>
> Search for the reverse tuple too, this will then check the NAT bits of
> the colliding entry and triggers port reallocation.
>
> Followp patch extends nft_nat.sh selftest to cover this scenario.
>
> The IPS_SEQ_ADJUST change is also a bug fix:
> Instead of checking for SEQ_ADJ this tested for SEEN_REPLY and ASSURED
> by accident -- _BIT is only for use with the test_bit() API.
>
> This bug has little consequence in practice, because the sequence number
> adjustments are only useful for TCP which doesn't support clash resolutio=
n.
>
> The existing test case (conntrack_clash_clash.sh) exercise a race
> condition path (parallel conntrack creation on different CPUs), so
> the colliding entries have neither SEEN_REPLY nor ASSURED set.
>
> Thanks to Yafang Shao and Shaun Brady for an initial investigation
> of this bug.
>
> Fixes: d8f84a9bc7c4 ("netfilter: nf_nat: don't try nat source port reallo=
cation for reverse dir clash")
> Reported-by: Yafang Shao <laoar.shao@gmail.com>
> Reported-by: Shaun Brady <brady.1345@gmail.com>
> Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=3D1795
> Signed-off-by: Florian Westphal <fw@strlen.de>

Tested-by: Yafang Shao <laoar.shao@gmail.com>

> ---
>  net/netfilter/nf_nat_core.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
> index aad84aabd7f1..f391cd267922 100644
> --- a/net/netfilter/nf_nat_core.c
> +++ b/net/netfilter/nf_nat_core.c
> @@ -248,7 +248,7 @@ static noinline bool
>  nf_nat_used_tuple_new(const struct nf_conntrack_tuple *tuple,
>                       const struct nf_conn *ignored_ct)
>  {
> -       static const unsigned long uses_nat =3D IPS_NAT_MASK | IPS_SEQ_AD=
JUST_BIT;
> +       static const unsigned long uses_nat =3D IPS_NAT_MASK | IPS_SEQ_AD=
JUST;
>         const struct nf_conntrack_tuple_hash *thash;
>         const struct nf_conntrack_zone *zone;
>         struct nf_conn *ct;
> @@ -287,8 +287,14 @@ nf_nat_used_tuple_new(const struct nf_conntrack_tupl=
e *tuple,
>         zone =3D nf_ct_zone(ignored_ct);
>
>         thash =3D nf_conntrack_find_get(net, zone, tuple);
> -       if (unlikely(!thash)) /* clashing entry went away */
> -               return false;
> +       if (unlikely(!thash)) {
> +               struct nf_conntrack_tuple reply;
> +
> +               nf_ct_invert_tuple(&reply, tuple);
> +               thash =3D nf_conntrack_find_get(net, zone, &reply);
> +               if (!thash) /* clashing entry went away */
> +                       return false;
> +       }
>
>         ct =3D nf_ct_tuplehash_to_ctrack(thash);
>
> --
> 2.49.0
>


--=20
Regards
Yafang
