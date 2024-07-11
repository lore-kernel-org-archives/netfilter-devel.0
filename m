Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE8B76034
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Jul 2024 05:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720676419; cv=none; b=aapLJpBWfBWAIRouB2wsijA+hZ4H2QSHsqNk8JE79GKenhwkQwh79JSklQ76cpO/64PFMVYoCCOyN6JIEHQzpyYsWdB8jMtChBFXFVIy1gx8GQTGAGYWu+TBmgOjBQ7LDusr75r5vyzPJTNyBxC3O4sLYee9ecs7LChApCgx050=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720676419; c=relaxed/simple;
	bh=er2u/C0ayZ13lixi8pV/7AwVK//BH86gyj62gEdZx1I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L84KvqqaBevUSJSTpko3iXREEp15pgpzS/8C1k78od6B2Ym7Jzd62eSmei3aaqgqrHWXT9ush3ivmWeL8/4BGvJD6tkgWYO4hv9/l0Q3um9R33OxtfuqEV7caUV6/uDutgLhV8iCD/p7QzXNweGRxXezlqsROJqwJoO4BIjiIFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=smartx.com; spf=pass smtp.mailfrom=smartx.com; dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b=uNwFtapn; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=smartx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=smartx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b="uNwFtapn"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-52ea79e689eso670953e87.1
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2024 22:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20230601.gappssmtp.com; s=20230601; t=1720676415; x=1721281215; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DtQfbSYXmPmFxIghTAuaXxtKY59+oSbNVAa06oAvgE8=;
        b=uNwFtapna79wdTJKkHWqopN+thTpQZnZjgTuOPCM8QpZaYpNuSWFiosCRNIOvCBdWR
         XUfoggw+CZ+8DS4HCLGPiJVnNRFM7/Yz1HeYhON0Re3/UXVLFRzRmiE68FUNkbMBWyEL
         S01597pyjPBHeYZYnTvTY6ojpmuHeA3QwALvp7WMn70jsGebKTSs1djASJrSh2xskf1v
         HOFLKQLb8bQdiQkWAZBeDlDtlTYYNic6uGlVTj5P3FXkPsxh+MfxnEkODIFvh0ZfpKjW
         r/8O5QwKg3WDk7clFIs4FPBTx/XmmnGf8xheixKOx2fWPED+SYV9IH/Htus/XYRmCgsD
         As5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720676415; x=1721281215;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DtQfbSYXmPmFxIghTAuaXxtKY59+oSbNVAa06oAvgE8=;
        b=EqVRMc/+ZmH8UZXhXMG6bvoKclOVhE5YD6DRPaqJst3D1eNNdJlRWIO0dP59IH01aY
         tqNxc81WijglHl2NlhmXhk/1n0eWO91aqMfQNSRrPvmRtY2zhJDz2HxLeFFlWaPNIysT
         jepHdDq8fxGPTB0z4oUnbJtzV845hYco/pjrlP1GKCHWpAtBleVW+em8nUFaSrW04CCU
         I11Cb+aOR7gRrVINAo/m1KCasskf3pQqhhkLkeiWPwwDneatH3pcAdeVL70aCyuBanHu
         Q9z7IeXAnNeGxMButjK+ib1cm1kDU6Ju1U2IKsXw/3FGtQpX9J/CxGFLL9w4p2lqfp+d
         Fztg==
X-Gm-Message-State: AOJu0YwSLU22mJe6LB46+gTtywUtVKALmojF/gekNQ3QMKlJUtf3XjUg
	RY2jBoXdncYexm0Kq7ueGesLzFpyU6AsbvytTvygbc+wXpOxmrC2Do6L+ASNEMDM9B3aCv5qZQg
	QHf99rsvhwmrR0rQuPPwDQ7f0THhzU/vkKVKM2h77H23nF2yJP9I9lorL
X-Google-Smtp-Source: AGHT+IF+BKDpNJnivyTpTW415g8VRESZbb/7e56pM3pMEuHmh9WnGF7mjq0NVvmuJHBA9fsXR2GqhBai5y9XkJzcVSA=
X-Received: by 2002:ac2:5544:0:b0:52e:751a:a172 with SMTP id
 2adb3069b0e04-52eb99d288dmr5355776e87.49.1720676413776; Wed, 10 Jul 2024
 22:40:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240620113527.7789-1-changliang.wu@smartx.com>
In-Reply-To: <20240620113527.7789-1-changliang.wu@smartx.com>
From: Changliang Wu <changliang.wu@smartx.com>
Date: Thu, 11 Jul 2024 13:40:02 +0800
Message-ID: <CALHBjYFn_qB=Oo3TTg0znOnNz9rX5jP+eYSZbatAN94ys8Tzmw@mail.gmail.com>
Subject: Re: [PATCH] netfilter: ctnetlink: support CTA_FILTER for flush
To: pablo@netfilter.org, kadlec@netfilter.org, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

PING


Changliang Wu <changliang.wu@smartx.com> =E4=BA=8E2024=E5=B9=B46=E6=9C=8820=
=E6=97=A5=E5=91=A8=E5=9B=9B 19:35=E5=86=99=E9=81=93=EF=BC=9A
>
> From cb8aa9a, we can use kernel side filtering for dump, but
> this capability is not available for flush.
>
> This Patch allows advanced filter with CTA_FILTER for flush
>
> Performace
> 1048576 ct flows in total, delete 50,000 flows by origin src ip
> 3.06s -> dump all, compare and delete
> 584ms -> directly flush with filter
>
> Signed-off-by: Changliang Wu <changliang.wu@smartx.com>
> ---
>  net/netfilter/nf_conntrack_netlink.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
>
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conn=
track_netlink.c
> index 3b846cbdc..93afe57d9 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -1579,9 +1579,6 @@ static int ctnetlink_flush_conntrack(struct net *ne=
t,
>         };
>
>         if (ctnetlink_needs_filter(family, cda)) {
> -               if (cda[CTA_FILTER])
> -                       return -EOPNOTSUPP;
> -
>                 filter =3D ctnetlink_alloc_filter(cda, family);
>                 if (IS_ERR(filter))
>                         return PTR_ERR(filter);
> @@ -1610,14 +1607,14 @@ static int ctnetlink_del_conntrack(struct sk_buff=
 *skb,
>         if (err < 0)
>                 return err;
>
> -       if (cda[CTA_TUPLE_ORIG])
> +       if (cda[CTA_TUPLE_ORIG] && !cda[CTA_FILTER])
>                 err =3D ctnetlink_parse_tuple(cda, &tuple, CTA_TUPLE_ORIG=
,
>                                             family, &zone);
> -       else if (cda[CTA_TUPLE_REPLY])
> +       else if (cda[CTA_TUPLE_REPLY] && !cda[CTA_FILTER])
>                 err =3D ctnetlink_parse_tuple(cda, &tuple, CTA_TUPLE_REPL=
Y,
>                                             family, &zone);
>         else {
> -               u_int8_t u3 =3D info->nfmsg->version ? family : AF_UNSPEC=
;
> +               u8 u3 =3D info->nfmsg->version || cda[CTA_FILTER] ? famil=
y : AF_UNSPEC;
>
>                 return ctnetlink_flush_conntrack(info->net, cda,
>                                                  NETLINK_CB(skb).portid,
> --
> 2.43.0
>
