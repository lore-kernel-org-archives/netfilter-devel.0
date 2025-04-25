Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B90D22A800
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Apr 2025 09:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745572042; cv=none; b=qA4bAH9sdYccFL/oF4zZdnnTC3EzNbIevMba3DUG7coKZ8i/NoGUOyuH6OG5u1mbur5iY3Qwj675DjBYWdyF7fHosy/lwpba+IrztXRaF+IIlW6YxCwSTzdixlgCL8zTZPxghxkRQtqEzBiTb2nzicAwUR8xpr3qUewDsXVD6Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745572042; c=relaxed/simple;
	bh=En4kD4NN+ObEO9TrfpctVRnm+yTaOgCLi7NBrozmmRc=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=sDVBWVL+6NQrkCQLpVk7XhbnjrzHsc8qbmtz8kN0B+buglRr/Rl8Ue7Rx5qi1GaoQVgXDMWxRJsl6G4+0XOpUxj7slsyhta5iZ8AiWH7VKzPuUYqQVXT4nee6MNBuaoX4rr8MjOt2yg6ouX43vzZJp+gib0SX1xLvP8cKQeXO2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z6+D3ENH; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z6+D3ENH"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3032a9c7cfeso285776a91.1
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Apr 2025 02:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745572039; x=1746176839; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hqsAB9tVDzysYsNL0ysmIqWB1Xk+jt8S/7pCIS4T728=;
        b=Z6+D3ENHm3c5FKQ9riHv041f52UWCpid11oWxVMB4+73YeKZ7JmAjfxEJMWI5Vmrn/
         nT4+NN5+DCoLirAdjT56LUYQEgmt1nZKaPpUwbetuuesg6+h4wnad24Kv/uR/V17uKHi
         W0sRgRfiN8HBWiu+Sp7xKaoK7FsN/8NLq9mnNevv22SgbTNqnzZYeHwiV+aYqLx7XRtV
         6RzweFjUGVbMS+m8cFG+ZXcJ5OMglAqTjKOuU/p2LulHuzDLmUFP/i3qnEZeEp5WOPHg
         oMe9n/mYPFGyvBQ/nYgdglscQDJKXsdP6HPlVzHPmcLictWakX//RbIfbt5SBN+5EDGd
         s+sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745572039; x=1746176839;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hqsAB9tVDzysYsNL0ysmIqWB1Xk+jt8S/7pCIS4T728=;
        b=fDw7E2/kXllUG0pb0KoW86I3ABj2DmC0xeVhgstaBfA+d91hpBphZblFpRWoHGb6ke
         yVrV3f4usJeLuqTAYW1bX9YHCh/AgSfMWzVyTbdCpHAwghd2QeQxZ5RiV9RkGwuLLCBR
         exFRJrRJZ51pkTAhuDJ0WIXP4j2HUaq0gjiq9sFVfBuOxSLw3gL3/IWQxciTyfKzm30b
         3TEfYWpufbG/LmMoO5S6PrFvron8Akv3HDzpvC9Cw9v/w/KRI6tjDbvKP/hNIEadG7tl
         XSqIMan9DvwKroXp/Dml7guMSqPJrWZWuDtzwvjXC6En/9JPzNMfFVLV00KDiu5IZXL5
         hJeg==
X-Gm-Message-State: AOJu0YxGtYvyVPTM/s7FzpJQ86jPR5/eeMiyVg3/g+kfEOvD6+89gvcp
	BRXZk4s/01DMr5vz05JiPGaZdypclms4mo8/Cjl1kirJDdXa+T4dIFIZyg==
X-Gm-Gg: ASbGncuQyS/I3nXL1gEDcMV2M9wYBauch4LgWyWIlgBEuSfmKyean3bUx6SUXSVoCiK
	w/sRAggTHFFImPZaT4/puFbBbk6sTjwrd86J0fFaNmYwC5oRUiXdHUIr3h8nFm4z6fH5xXQNy9U
	7emvLoLEUa3vungb4Qg4jB94dUDvv7pgRFe3LppAVn6CP9rFJF/S/bZPHsfhcSXXcZfkgUoyxXL
	grdGOVrnALn3QddnE2UZ83sl52SvYN65zt4EcYpIYcqOuQTiBWz0O1eJLKpKcSCCLOvcXZCKNey
	+sMJXvx5VSh8poBfOfWx1phKL0Ponlp7NIX195I5elsoIvhoRe4q
X-Google-Smtp-Source: AGHT+IG7mSHPHnnz7MfKBanqetOTTcTXBSC7oegVB1IqGaK/gpwFE23jRLRRUen21iIrqHhgyreKDQ==
X-Received: by 2002:a17:90b:3812:b0:306:e6ec:dc82 with SMTP id 98e67ed59e1d1-309f7ea2a93mr948058a91.6.1745572039501;
        Fri, 25 Apr 2025 02:07:19 -0700 (PDT)
Received: from smtpclient.apple ([2406:4440:0:105::41:a])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-309ef061acdsm2945303a91.16.2025.04.25.02.07.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Apr 2025 02:07:18 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.500.181.1.5\))
Subject: Re: [PATCH iptables] extensions: libebt_redirect: prevent translation
From: Miao Wang <shankerwangmiao@gmail.com>
In-Reply-To: <aAtPd3QF-2v8TNCe@calendula>
Date: Fri, 25 Apr 2025 17:07:04 +0800
Cc: netfilter-devel@vger.kernel.org,
 phil@nwl.cc
Content-Transfer-Encoding: quoted-printable
Message-Id: <37E09A07-36FE-4F90-AB3E-9DB5701B86CD@gmail.com>
References: <20250425-xlat-ebt-redir-v1-1-3e11a5925569@gmail.com>
 <aAtPd3QF-2v8TNCe@calendula>
To: Pablo Neira Ayuso <pablo@netfilter.org>
X-Mailer: Apple Mail (2.3826.500.181.1.5)


> 2025=E5=B9=B44=E6=9C=8825=E6=97=A5 17:01=EF=BC=8CPablo Neira Ayuso =
<pablo@netfilter.org> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Fri, Apr 25, 2025 at 04:44:24PM +0800, Miao Wang via B4 Relay =
wrote:
>> From: Miao Wang <shankerwangmiao@gmail.com>
>>=20
>> The redirect target in ebtables do two things: 1. set skb->pkt_type =
to
>> PACKET_HOST, and 2. set the destination mac address to the address of
>> the receiving bridge device (when not used in BROUTING chain), or the
>> receiving physical device (otherwise). However, the later cannot be
>> implemented in nftables not given the translated mac address. So it =
is
>> not appropriate to give a specious translation.
>>=20
>> This patch adds xt target redirect to the translated nft rule, to =
ensure
>> it cannot be later loaded by nft, to prevent possible =
misunderstanding.
>>=20
>> Fixes: 24ce7465056ae ("ebtables-compat: add redirect match =
extension")
>> Signed-off-by: Miao Wang <shankerwangmiao@gmail.com>
>> ---
>> extensions/libebt_redirect.c      | 2 +-
>> extensions/libebt_redirect.txlate | 6 +++---
>> 2 files changed, 4 insertions(+), 4 deletions(-)
>>=20
>> diff --git a/extensions/libebt_redirect.c =
b/extensions/libebt_redirect.c
>> index =
a44dbaec6cc8b12f20acd31dcb1360ac7245e349..83d2b576cea5ae625f3bdf667ad56fc5=
7c1665d9 100644
>> --- a/extensions/libebt_redirect.c
>> +++ b/extensions/libebt_redirect.c
>> @@ -77,7 +77,7 @@ static int brredir_xlate(struct xt_xlate *xl,
>> {
>> const struct ebt_redirect_info *red =3D (const =
void*)params->target->data;
>>=20
>> - xt_xlate_add(xl, "meta pkttype set host");
>> + xt_xlate_add(xl, "meta pkttype set host xt target redirect");
>> if (red->target !=3D EBT_CONTINUE)
>> xt_xlate_add(xl, " %s ", brredir_verdict(red->target));
>> return 1;
>> diff --git a/extensions/libebt_redirect.txlate =
b/extensions/libebt_redirect.txlate
>> index =
d073ec774c4fa817e48422fb99aaf095dd9eab65..abafd8d15aef8349d29ad812a03f0ebe=
eaea118c 100644
>> --- a/extensions/libebt_redirect.txlate
>> +++ b/extensions/libebt_redirect.txlate
>> @@ -1,8 +1,8 @@
>> ebtables-translate -t nat -A PREROUTING -d de:ad:00:00:be:ef -j =
redirect
>> -nft 'add rule bridge nat PREROUTING ether daddr de:ad:00:00:be:ef =
counter meta pkttype set host accept'
>> +nft 'add rule bridge nat PREROUTING ether daddr de:ad:00:00:be:ef =
counter meta pkttype set host xt target redirect accept'
>=20
> this is not a working translation, I don't think this is leaving this
> in a better situation than before.

Or can we fully remove the translation? The translation result is
really misleading, because the result is a valid nft rule statement
but cannot work as intended.

Cheers,

Miao Wang

