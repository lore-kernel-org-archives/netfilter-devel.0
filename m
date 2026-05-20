Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB942C325C
	for <netfilter-devel@vger.kernel.org>; Wed, 20 May 2026 13:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779284131; cv=pass; b=E/JshIgvVt07LfCoRm0D8iqq1DCjWFNY8OUqj4aA696orTaz1WhjcYUZeUV3PKjAOUKZkNgebmRiPy71f2gud7+vf0+JX9gfL7dZ+E6JjPsPecId7jIRrdI3uyLigFkGUE+cLkj0fdRPjxiQYi1Qbro4ZfBWyVVILwpcMat3tVA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779284131; c=relaxed/simple;
	bh=TaewVaaJSRTgVv7uiAvCvNN525apvixVpdwb+G50UPM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bH7M472NnuBSGlFXVkB9XfoYWroJyPse0OD9kexeJPgj7Hvexx3pTPUOxNnXi+SlneGASX2nY39jysNUZXOi/OEyz/2z+1CHCyC1i90yo21lo33HaErB+Zl8jhFNYCbB+A7Opf2hV7+QtSa04cEQFhrw0lrovO3tVIM3SnZAlgw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LGn1XMEq; arc=pass smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LGn1XMEq"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5a88db610ccso5521314e87.2
        for <netfilter-devel@vger.kernel.org>; Wed, 20 May 2026 06:35:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779284128; cv=none;
        d=google.com; s=arc-20240605;
        b=laQrkvwO9c0DHJgA2Hm1DRaDadtB8NH+H022ngH0/f2JhI/0lxb5IEnfON6V2rbcTU
         v98nxl3hR+fMwVXI/Bgs0LkaH7CH0WvtOrN1dv0X6A2v1NNOlpwDoEh80uxDK5zUxpU4
         bJHqWt1gP/uEoyrqfAgUZx4Ra0isAp31fAxFgidmnAeyLF7b/aYfeE5irzC75Hb3pYTo
         me0gkcox+t/ew1YC7aiyTf/n5jJZeNH2klrEHRF2P6GbAwH0/d2s+c8P1oWdx83+eUl1
         nYfvKtyv6PtsvtVupB7ny1rCAB4xve5CzD93K8TstNcMWP/qYBJ9AnOtQzY1KaycAPBm
         bcmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Yu0/XtO4dIfAu/cztcBneHSKuN0SeWCUAeJO4rKJAag=;
        fh=i1zdjvduu3TK15E75kek1OZT5labH4iGUMnMcMuuCyA=;
        b=k8nrkX5yRlrN5IQnBDWWXbRkrMWUtAP6Bx9nFK/7BYm54gEqIJnSZ4rX9oSI6dqd88
         pkIu8KEOfFp8Maf1nOLeiRdj+DtSAkLzC8zJZN8eCCnuKDxSUN8bSp6LpkvUSPPongox
         u7xbPG5rMEVzozIzEAvwqcN3K9aNJ4EJz4dwzRGXIOhjclB85iLfgdEjGHKPcKFT7JNr
         87LSUjgHvYzCPr5AlGhrueW8el4GE5ioa3sdtwHG0RRq/HFadnQmExsNyRbRMY2yXcoR
         TilZ8NgJd9Et/6ePmg2wSEECHULh19/T3lTfuPq+S8RUUhD5mALa8otrsZgb6je4FMIo
         QCfQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779284128; x=1779888928; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yu0/XtO4dIfAu/cztcBneHSKuN0SeWCUAeJO4rKJAag=;
        b=LGn1XMEqc7BwAhuIEoaGJz1Ki15lwdTkwh5ZqSasJbAHLIPYwItSy8PyDWIqj7TiRL
         +/tqPFnreQHSqMjI+CDSKlR5UmBY80l3eOzhsVNwsHk2hFT3IMlzAqjI0HAw2QdbQLWy
         xluVpgZ55mwkiBKrJNRzafPc5fdTSbXQfXgOIhqvjd5owAMLxTmTEYriHrHqu048yPpp
         iYwowOEwcgfbNesWsaDGvFmot3AM/WxdRjaM24e/8Ubil/X06kWrSLd6OaUIaM5S3+Aw
         skpgfWDVFbWWvacsKCsNzYkSWoI4yjb+kPgO3iPVHAv3bj2BpJuNYTXL2/xW2Cr21+8U
         BKtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779284128; x=1779888928;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Yu0/XtO4dIfAu/cztcBneHSKuN0SeWCUAeJO4rKJAag=;
        b=K12bSnPj1z7y1i1ArWsYKD+xUVoD8LAjCbDMBUXGVRnHf3uHiIgloGQ0hDcCTZl65m
         R45fWCE7ejNPeuMvNtIH6qZ+gOTQSlCoZlUwu6uYeiavZvMtgtLcth/wcN2EIwaDalSz
         8VU8cEJXLlvTpm04G7vIzoL2HyrNatgHnbIE33Mw73z2rzXZEZ/QLL72q6iKenXnL83G
         TDBm3OOlMBthq0P9AoejzJ6VoP9Qpk2jPwbCGUsU7HDsq1e689O7PtolsLtGIXJI4fPu
         pjh9HTV8rep+HLiX9QgAR8jlXgadzR/K7bKYBChaYMKjo/OkTJA+Ya6kyMDdSrzWrHqQ
         Gs7Q==
X-Forwarded-Encrypted: i=1; AFNElJ/o4uKBUdH23TVWg31l+azTnnFERdY74LP56QqCUQd4bLNefoxoinPHNacQLWy3j4zelIP5GL3FlC5csQpaYVA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCnDMBo4sVAjbRHhSsewsIqmV+FBETYMNngZjlkfbiAgbd4zuN
	v2e0bFFY3U7sycTLutFvY9c6ZbK+E6UGDC2KbHq5UbK7urKixw30Z9P4myx7zYLYsSsXnbujxwH
	ex37sxhEdYHXXX++hzm9hCmaSkjQWKB5YIQdJUQTIYg==
X-Gm-Gg: Acq92OFRpdZIELDwauR6u2lSRwv5V42Twf5psd5hhvPLGdaqCxwTwFd0xm6NFS4d5EV
	MVn8xFgIl3nRjWyI57hIFNDZjCtKJXfG4bGTWw/cn6cphWBOEDlPYc707RFXju5f6kpmOrYRPue
	lP2rP04FiaK9ZkRgkOVchzR+rHOk578fNDhuKWeA+FO+QaukOgqcU3SLBFvGRDH6buNEcfxoNm7
	/B2hFUeUKEnIOWwPaDliiK30Vxh88ZFRxKGsPz2ow1Ha7Aw/a6VG+MVj1p8bJ50CWGFRH5vwSwS
	R6XUv4GyPtRmriMYZ9M=
X-Received: by 2002:a05:6512:3d17:b0:5a4:1096:94e4 with SMTP id
 2adb3069b0e04-5aa0e73f375mr6835140e87.2.1779284128482; Wed, 20 May 2026
 06:35:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260515135143.259669-1-marco.crivellari@suse.com>
 <20260515135143.259669-3-marco.crivellari@suse.com> <20260519182219.0d685a27@kernel.org>
 <10173685-596f-1eb0-0903-a3d7ba4dff9b@ssi.bg>
In-Reply-To: <10173685-596f-1eb0-0903-a3d7ba4dff9b@ssi.bg>
From: Marco Crivellari <marco.crivellari@suse.com>
Date: Wed, 20 May 2026 15:35:17 +0200
X-Gm-Features: AVHnY4IeRKHo331ej-I0dmnws79oeyR-8QctDEsIk4GCUGbIHbl2IQWDS5Yw-jk
Message-ID: <CAAofZF47k3FiALNvNzaU8W=sNXXUH2Wfx==0G9qJAGM1rFOS_A@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 2/2] ipvs: Replace use of system_unbound_wq
 with system_dfl_long_wq
To: Julian Anastasov <ja@ssi.bg>
Cc: Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Michal Hocko <mhocko@suse.com>, Simon Horman <horms@verge.net.au>, Eric Dumazet <edumazet@google.com>, 
	"David S . Miller" <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>, 
	Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, 
	lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 20, 2026 at 6:11=E2=80=AFAM Julian Anastasov <ja@ssi.bg> wrote:
> [...]
> > On Fri, 15 May 2026 15:51:37 +0200 Marco Crivellari wrote:
> > > Subject: [PATCH v2 net-next 2/2] ipvs: Replace use of system_unbound_=
wq with system_dfl_long_wq
> >
> > FTR leaving this one to netfilter folks
>
>         Yep, we wait net to be merged to net-next because the patch
> depends on commit 5522d65d81a7
> ("ipvs: avoid possible loop in ip_vs_dst_event on resizing")

Thanks to both of you.

--=20

Marco Crivellari

SUSE Labs
