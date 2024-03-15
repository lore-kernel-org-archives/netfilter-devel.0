Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627901B5B1
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 11:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710502532; cv=none; b=Enn9x00YqAg7GDZeO2MJePy2FllKIOgosGZUomlNC2dMXnKYkcz95Lz2gjftPgnC0z9LMllp3weZtRW2KOS4DMwksciD/m56qZT8pq190S5W1Mi5UAIlNwFmlhesJ/BEI/o5+8ca7s91yUMT4bsmNUp9i0yVh0E0PlOmpc5sTt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710502532; c=relaxed/simple;
	bh=lFK+bJ8f2FZtV68kyJXnFXn5Ul+zSe46dgHQE2LpB8U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=Uz7mj18I0akHt/6w+9R2dY3ofS/mIS3yXnBuxDSCFnmfKJLPpEwjaSdKvOwu4pmeIL2xRU2voEbSGMj1pjxkAeos94igP3TEJhpz5Dye3+4GwpgJnTWUOjiK6isn+EdAHfvq5RmWCkGRn1YkroL/Lp7QhgSctb2FzBAnMDeJti8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kVVnxmSo; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kVVnxmSo"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-430b74c17aaso834091cf.3
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 04:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710502529; x=1711107329; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u+FZQOFxMZbHSebaBLWsvJ2Ba34sOWdLadbl3LVDsVY=;
        b=kVVnxmSodAY/x0WAVnZztZztKH9XA0vI3E9dPiR0L5mIV9CvazpSIxGcx9dJzsW1h+
         Mzy0w1j4yZRJ3vIzB/OdLIafz4Z3i6flMVUmCakQ9fAryw/KprqWUIL12i4ayUGzvSIz
         KXEb6BEAWmjdXD8cyRZgK5DJCfG1Wg4GNKRvpn+c3WX4vRJeHSme5lUE479OF+7cAI+u
         4Um2gy78d2JMFbK8lbxJOjOS2j5JdynzXzmvCMmDbl72Ork4ttwmybTj7vk0+vlpk0FA
         jjef8dSm5gsKn8NFZactEvUVtLwxWTYcFi/09MuDlQ1H+rqIO7ALzJoS+b9dMSk5iEE5
         kXLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710502529; x=1711107329;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u+FZQOFxMZbHSebaBLWsvJ2Ba34sOWdLadbl3LVDsVY=;
        b=s4icuedzbC4QCxBVlyBsOZD9lImyqGOFZliPaUteZXOC2BjlNY4pPSD0u24CFuRrWC
         SMc9FQumf+RzBEMFeFl1Fj/UxD4+RvrJnaednGcK5s80ZWxezCRUgHcyvw799NK9W4N5
         K2cPU2X3yqc5ebil8ZfB/dlfxpcEJYv0yDFgyg0coyeAepXLY/kppLhuUo6q8cTBPEiI
         8Nv8B7FtUIhJJV2GtvLXtijfCytzbg3i2ottKNN/d4zN2qGClIGJC26xugEPwI4M4v0M
         EUkmatr6rVw4gJP2YZ9urXSw3w/wMTjDRXZhaakgydGzf9tDXcCZOFZ9u8YPo6JrLZuC
         EsRQ==
X-Gm-Message-State: AOJu0YxLKGUbDJkl5kicLqvXKYGGgYvHBfln+w1QDFjCh4O492Ntby8R
	cAGexKSkj43uMqScwql9wnCOE3T75XfPEcfxFj6BmUmyWXH8JZ/gg/usNfUmkSJCliEDkENWpBz
	xsov5p84iWoTQMuIgTpQ8s/IdhFNpKY3P
X-Google-Smtp-Source: AGHT+IFY2jqa+jiUHE2+iAAoY5wtrh8MRl/SPVyWlLnugVZzQl8COc7Ty4JdUOdm5MvTBEDJGwwseIVGQgsvxDgGkBU=
X-Received: by 2002:a0c:f912:0:b0:690:c79a:2d35 with SMTP id
 v18-20020a0cf912000000b00690c79a2d35mr3409903qvn.9.1710502529060; Fri, 15 Mar
 2024 04:35:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAPtndGC29Zc6K8V3v4LStfrcnvdCNNfTmjP-Ma9dM+21f1069w@mail.gmail.com>
In-Reply-To: <CAPtndGC29Zc6K8V3v4LStfrcnvdCNNfTmjP-Ma9dM+21f1069w@mail.gmail.com>
From: Sriram Rajagopalan <bglsriram@gmail.com>
Date: Fri, 15 Mar 2024 17:05:17 +0530
Message-ID: <CAPtndGDPYjbydQB-DcmJVcrpXY1qfCTGp+7CM0J8vdpZisuTKg@mail.gmail.com>
Subject: Re: [PATCH] iptables: Fixed the issue with combining the payload in
 case of invert filter for tcp src and dst ports
To: netfilter-devel@vger.kernel.org, Phil Sutter <phil@nwl.cc>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Phil,

Does this patch look okay?

Thanks,
Sriram

On Wed, Mar 13, 2024 at 2:38=E2=80=AFPM Sriram Rajagopalan <bglsriram@gmail=
.com> wrote:
>
> From: Sriram Rajagopalan <bglsriram@gmail.com>
> Date: Wed, 13 Mar 2024 02:04:37 -0700
> Subject: [PATCH] iptables: Fixed the issue with combining the payload in =
case
>  of invert filter for tcp src and dst ports
>
> Signed-off-by: Sriram Rajagopalan <sriramr@arista.com>
> Acked-by: Phil Sutter <phil@nwl.cc>
> ---
>  iptables/nft.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/iptables/nft.c b/iptables/nft.c
> index ee63c3dc..884cc77e 100644
> --- a/iptables/nft.c
> +++ b/iptables/nft.c
> @@ -1307,14 +1307,12 @@ static int add_nft_tcpudp(struct nft_handle
> *h,struct nftnl_rule *r,
>         uint8_t reg;
>         int ret;
>
> -       if (src[0] && src[0] =3D=3D src[1] &&
> +       if (!invert_src &&
> +           src[0] && src[0] =3D=3D src[1] &&
>             dst[0] && dst[0] =3D=3D dst[1] &&
>             invert_src =3D=3D invert_dst) {
>                 uint32_t combined =3D dst[0] | (src[0] << 16);
>
> -               if (invert_src)
> -                       op =3D NFT_CMP_NEQ;
> -
>                 expr =3D gen_payload(h, NFT_PAYLOAD_TRANSPORT_HEADER, 0, =
4, &reg);
>                 if (!expr)
>                         return -ENOMEM;
> --
> 2.41.0
