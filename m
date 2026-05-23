Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A455119004A
	for <netfilter-devel@vger.kernel.org>; Sat, 23 May 2026 13:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779542645; cv=pass; b=Y501YDM9X7DpVa0jzj7R7HBiJtt1nId3psaZIeHBf4y5UZglRRaLw8odn5nl6n5XdqYYlGY9j/aKz+Mio8130+58zQJbTYx6B++o1MvCaPMHTvMmf0jmjBKWKCEDcIn96gjJAUMxtaUsqA/BRawc7tdwTjfljy+fbzaP1YrpLNQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779542645; c=relaxed/simple;
	bh=+DadxG5gBsxdVcQDxz0TXyWCFpH77Onrq+GfUnx0Ot8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ACQqiwe+1z30qK/sRCRAexN+gW28UIhDJ5QMlQpG9gEoz1qg0hEfh6hFWwv4KG/BsVZyHfyhqv4atIGHuTT5CGqMF1fV9TurAchN9oahK709zJdoXMk7LQQ22jGrl7wkiZifUzlLfFb4qIG0py9Kz41WQPHns/o/vAUCsd2mAok=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RNG7FUnT; arc=pass smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RNG7FUnT"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-367c26471f5so5335125a91.1
        for <netfilter-devel@vger.kernel.org>; Sat, 23 May 2026 06:24:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779542643; cv=none;
        d=google.com; s=arc-20240605;
        b=ORFXFcWcKQJ8DIEMmQB9Fm8K8W/YUJZJC4fErEwIXIIDZM0cKtns3a15QcUw/aqmPg
         XeK1B2+oBqFaVrpKvSDUDP+n7dZSU/0/ypvgSNvpIWG2yvmHI3e2fhBVEv/ozwUczWQa
         fHev/OobLWh+AXxnpwnLpnzvr+F1TP8zFTNp5/73ET7JQvzw3VgmDNcFZjXdcx8vTrF0
         Fk6+rhRZt9h+TOMh6J14qyTPdQyaNr0yK9g2s1FBWDhmMRxKKOLICol4cWoGb+VgY+XP
         O2aH1/3pJcFsdDd/LdRZFbgELOpJEBLcGR1CQS6+XXE5+ziEyEjTT1e/Cnmp1ip50TNa
         wOLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LFH5IHmkWzpb34b9Ws8n7rESSKyDsZ5NTufshzBTIio=;
        fh=+pv8JaWycMlQ0PXZxq0JRMihC66vT4b/X/6dpxVB/eA=;
        b=iQLwmMNRTd5JK/4hy5zTBqV837k5TCQE/P3t6UYqRRWGZMzIcffjk8xafBvEOYk0ml
         hE6uU7KqjnfjDc4pSxv+30d0ed+T9EmtfqJVhH2SWzaP9qc4L/n7G1DE9wTK0bLWjG2I
         xe9OQv3WrVjGZm+bMZZDVjhqpzucS1vFqPmEEe2oJLZFsakFXwoHvA8mBiyBZeKHb9mo
         kyFuPnJRFenQuEUZbdMN8sCLSTPyHW9ANrZDiOY+owGe536/fGjMI7el5mIj80qnQPkx
         mEuq7VpwBiDG6JTWjkTYt9ZT1yqnsDfqxmElXJrHU2dpGLC2/7bpk6wGLqjxTIs4ODED
         FRcg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779542643; x=1780147443; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LFH5IHmkWzpb34b9Ws8n7rESSKyDsZ5NTufshzBTIio=;
        b=RNG7FUnTtlcxiXCFglNLOoQu7nZJiMRIymnQPrFbM/bYCD7/qfHlVkXUnoARYovFXj
         x4R1MVJ0XxpQAdRObnRhPEhEJgjLvuDOA4dW1e8k18YHNJKJ360+wWdUcw2ci2VgSeKO
         452p0JA158g8pKEaNmQzbgou/UPDe/TTnrdS8+FhB7iAQaBtqNB6Khm/9lAeRKjm/CxN
         VnuWywxuCCSTg550AdCUBihFS7OXILyscN0A5WAvTUi6xatlj4aRfSOF6r+5MkNevcmF
         oSpl13NHVFssE0EPIdczsxCp7PpxaqceU1ERY9zKzGyifbkweZziDK7vh3p3Qxp/ig7/
         /sHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779542643; x=1780147443;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LFH5IHmkWzpb34b9Ws8n7rESSKyDsZ5NTufshzBTIio=;
        b=LtASZ+RZKpDrT+xbxBUO/2dykN7Kw3UuJSxMv3hS9kHdQVAjDUJWFk9eVNyt4ClCR1
         XCKnqT9+Eh1TBKwtQxEvGXXeJXICNmHKACKAKAmImiOwtQmj54IEHxfqZzXnYBfOGtts
         HO1wDuf9LD6ITMRPjh86THXfG0kPhJFQoa71j6FpwX8knOefSaSIsAIFxbDLgRoK+DPN
         hqK+Xrzi7OCDjcbYcIXP3hIWsPRRn//5ZBeZfIxrya29HadCBAnwTYKE1BCZuM0gDJoZ
         yz7KSy6YVbnC8D93mJpOgUiOOEZtFpKG77plG3cXOos/UTnrfFKTkvnN4sQiCcjwzBLz
         R2Ig==
X-Gm-Message-State: AOJu0YymMPyROEhSO3C/Nn2TI+eQxVF3aVKOjzpkHqB+0alza7Zn/Z+W
	5Ig0ehQa3na+NnxP93iL+85pyBne0uOUy0AAjbyaWFC677hpi28B4P/PYVlVYdpNl77848yRneg
	yBfUcxgzTXx/UaVCDv2MDQFZzG8myJjU=
X-Gm-Gg: Acq92OFZAcELT6RPUH2r45oVbkkggvmO0sjTxC26/rn2UnjxoyDQS8xaPevvBu0nr+N
	MBwMSLoBZfp8pz0T23vGR6vCgehf8QNgmKl2xmbfqW9a6gqoInP9Zugt775Dx0gR+wx1qQDq3/C
	IcI1j0Zp7GwEUhFw6JaBhsCCes4QuJPbvUz1z5YKjm0OeK3eMgquYdov4fLpMBEgz/KkTdieWBB
	340rQWOUJY7eP3fUR/U6/L1onYHhdtelgyOgT/SUjeWX6tCoRgnXZvprBPio3TM1EF6ZT/SZ3LB
	NeJc
X-Received: by 2002:a17:903:1ae3:b0:2ba:bfc:76a8 with SMTP id
 d9443c01a7336-2beb057f8c9mr85598745ad.16.1779542642641; Sat, 23 May 2026
 06:24:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260520080119.12627-1-fw@strlen.de>
In-Reply-To: <20260520080119.12627-1-fw@strlen.de>
From: Lain Anc <rakukuip@gmail.com>
Date: Sat, 23 May 2026 21:23:49 +0800
X-Gm-Features: AVHnY4Iu2D06lA30BNpzEVURI-w32UB99nk7d-BLszIryVsRliXyoFlh_uZygcI
Message-ID: <CANZytUxYNYR8dpjQ0eDYaY_MrvseKp0YzMft0K+ezA3mXEjyRA@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: ebtables: fix OOB read in compat_mtw_from_user
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Yuan Tan <yuantan098@gmail.com>, 
	Yifan Wu <yifanwucs@gmail.com>, Juefei Pu <tomapufckgml@gmail.com>, Xin Liu <bird@lzu.edu.cn>, 
	Ren Wei <n05ec@lzu.edu.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Florian Westphal <fw@strlen.de> =E4=BA=8E2026=E5=B9=B45=E6=9C=8820=E6=97=A5=
=E5=91=A8=E4=B8=89 16:01=E5=86=99=E9=81=93=EF=BC=9A
>
> Luxiao Xu says:
>
>  The function compat_mtw_from_user() converts ebtables extensions from
>  32-bit user structures to kernel native structures. However, it lacks
>  proper validation of the user-supplied match_size/target_size.
>
>  When certain extensions are processed, the kernel-side translation
>  logic may perform memory accesses based on the extension's expected
>  size. If the user provides a size smaller than what the extension
>  requires, it results in an out-of-bounds read as reported by KASAN.
>
>  This fix introduces a check to ensure match_size is at least as large
>  as the extension's required compatsize. This covers matches, watchers,
>  and targets, while maintaining compatibility with standard targets.
>
> AFAIU this is relevant for matches that need to go though
> match->compat_from_user() call.  Those that use plain memcpy with the
> user-provided size are ok because the caller checks that size vs the
> start of the next rule entry offset (which itself is checked vs. total
> size copied from userspace).
>
> The ->compat_from_user() callbacks assume they can read compatsize bytes,
> so they need this extra check.
>
> Based on an earlier patch from Luxiao Xu.
>
> Fixes: 81e675c227ec ("netfilter: ebtables: add CONFIG_COMPAT support")
> Reported-by: Yuan Tan <yuantan098@gmail.com>
> Reported-by: Yifan Wu <yifanwucs@gmail.com>
> Reported-by: Juefei Pu <tomapufckgml@gmail.com>
> Reported-by: Xin Liu <bird@lzu.edu.cn>
> Signed-off-by: Luxiao Xu <rakukuip@gmail.com>
> Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  @Original authors/reporters: is my understanding correct?
>

Yes, your understanding is absolutely correct. The extra check on compatsiz=
e
successfully prevents the out-of-bounds read during the translation logic.

Acked-by: Luxiao Xu <rakukuip@gmail.com>


>  net/bridge/netfilter/ebtables.c | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
>
> diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtab=
les.c
> index b9f4daac09af..8a6a069329d2 100644
> --- a/net/bridge/netfilter/ebtables.c
> +++ b/net/bridge/netfilter/ebtables.c
> @@ -1956,6 +1956,25 @@ enum compat_mwt {
>         EBT_COMPAT_TARGET,
>  };
>
> +static bool match_size_ok(const struct xt_match *match, unsigned int mat=
ch_size)
> +{
> +       u16 csize;
> +
> +       if (match->matchsize =3D=3D -1) /* cannot validate ebt_among */
> +               return true;
> +
> +       csize =3D match->compatsize ? : match->matchsize;
> +
> +       return match_size >=3D csize;
> +}
> +
> +static bool tgt_size_ok(const struct xt_target *tgt, unsigned int tgt_si=
ze)
> +{
> +       u16 csize =3D tgt->compatsize ? : tgt->targetsize;
> +
> +       return tgt_size >=3D csize;
> +}
> +
>  static int compat_mtw_from_user(const struct compat_ebt_entry_mwt *mwt,
>                                 enum compat_mwt compat_mwt,
>                                 struct ebt_entries_buf_state *state,
> @@ -1981,6 +2000,11 @@ static int compat_mtw_from_user(const struct compa=
t_ebt_entry_mwt *mwt,
>                 if (IS_ERR(match))
>                         return PTR_ERR(match);
>
> +               if (!match_size_ok(match, match_size)) {
> +                       module_put(match->me);
> +                       return -EINVAL;
> +               }
> +
>                 off =3D ebt_compat_match_offset(match, match_size);
>                 if (dst) {
>                         if (match->compat_from_user)
> @@ -2000,6 +2024,12 @@ static int compat_mtw_from_user(const struct compa=
t_ebt_entry_mwt *mwt,
>                                             mwt->u.revision);
>                 if (IS_ERR(wt))
>                         return PTR_ERR(wt);
> +
> +               if (!tgt_size_ok(wt, match_size)) {
> +                       module_put(wt->me);
> +                       return -EINVAL;
> +               }
> +
>                 off =3D xt_compat_target_offset(wt);
>
>                 if (dst) {
> --
> 2.53.0
>
