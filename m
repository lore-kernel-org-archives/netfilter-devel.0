Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB10937D107
	for <netfilter-devel@vger.kernel.org>; Wed, 27 May 2026 16:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779898500; cv=pass; b=fL85edc2+tniiOo53pW+K97InzNVG8isR+/M7fABBN2qlQXV2BqUuSgLp27FNyn6Ym3PLDDAXivw2RUrow/IbfgzyK3UrVKLjWDp6x3A2PZFk8aLfKHmDd+yeygbzD0pMSu9UHm44S1gj/74bphUDEhpuFZm4v03YDJh9QDIDTo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779898500; c=relaxed/simple;
	bh=LX68ri66pOS8OR8NoqZ2gIgBmy7YT5WotxongWFI7Ns=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GrPSc2wAeKHV5WsiWpI5Li4MIyOdAotjrM5/c4E6lN37qgEacyocznbA6+H/V//vYyL63H5S/D6aEND7rxu36M7tGPq3GVQS7AyXWLjSIQ+6+Iv9Odd4Tqjf5ZRbApgoy65a0qV1Z7bbHdETL1m2iNJr1UloZjPKcwRVTSBeLQM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YmC4G2yq; arc=pass smtp.client-ip=74.125.224.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YmC4G2yq"
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-65c5361142fso11274468d50.0
        for <netfilter-devel@vger.kernel.org>; Wed, 27 May 2026 09:14:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779898498; cv=none;
        d=google.com; s=arc-20240605;
        b=lfCB4vU0/Vtbgy38fJBcAS/H6R7S8fHoYfWFYKeaHzzG4h5zcU+m4ZZc6+WilF/jQn
         gPaMRa6latIYjNec3bdrFRWl1J/CXBPBQbOODjcD+zt8opmPY9w9ewJwu/wk9qu1nAj9
         d7ugRlghz3uO13TX+bY3SIGMOcLndd3XdsAI7yCeVYCokowndBTOElvO/qX6LwCAFYn+
         qqrrp5NnRptniKXEDGmBKvypJ2Nwj9/QZNYgveSbGdOnQD011wb5ZhMde5Xovlkp6HRo
         ni32128JYBNlN8lKGeQzd4UJsIz9aVo+ytFgU9PXrLVCK+7HWsn9QRXTSqXgImaLzCwm
         cVKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=mzeRY6sPehjEn+BPgx6Xi1es20BdfMexE0A8mncyA7U=;
        fh=QIjv56jc5TWcc4GPxunxHoEXFIRv2Djkz9Bx7Om0YPA=;
        b=YgIGconDzqohK8ESUT5gmQG4oSSSR29lplJjzvVT6R9garXN0C9SbTpSFrFpaSy8k2
         ZYQxz/ZZk9b6KVE3tcmuT0UxXHoa/fk7ooProX+Wt3jBD4Bp3bsiiQ6Dn8hktCMgdhln
         AFF3Yz/y4B8d956oHVcEa1f+eX3ui0cv1hZpqqwsRbsLxs2iZd5P06lmAm2+FW4U+lYw
         d3TSWry6U4IvMLIxczXzDfGz64E+N71TE8+u9JHJ0vEEqWUwVYxKN4KDQK6WBX8NbRNu
         mZzpyfSZ66i/eZtegwm05fjAKMaKdsEyyzzOJJFPBRp2MdwtgWrzYxtQyLtR3rBGCugw
         Es2g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779898498; x=1780503298; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mzeRY6sPehjEn+BPgx6Xi1es20BdfMexE0A8mncyA7U=;
        b=YmC4G2yqKLyYlZ1PMDjUjeSnkdDeoCDbcsnwGvKF4j5XTIDKRMVg+cQCwmHYsBiatZ
         mYQmNYlY5oIdQtphsP60348OwVHrfsr4z6d5jobXJwBM14X15nngZtOeNKTXNg8wILtL
         EA/pUBR498/h+VXwEljYAxvUXZ9vFh/g1fkZWLJzO/WSLcE9lOCakH4RBPSLP4PKlx+f
         0nxPaLExhRT93hFZcZlAYO6USTyqA9cOrbQ8/2oMJupCmVdSqcJCEC2GnMmCFlXSHNcw
         vObmb0SN6vJq0OhYGbDxpTWffL6+MVxwrcdq3haEov3hKRj8EHW8bahz903gGYpZ7gz5
         owYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779898498; x=1780503298;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mzeRY6sPehjEn+BPgx6Xi1es20BdfMexE0A8mncyA7U=;
        b=f3KxWk6iWjnx4BzBlZfszF4fBYu1cSZAhQbYlvKzVdMMLMYiINQUHZ1kWTJS0i6pqn
         m05bcSvn8IKddSnehxvAKYoxKNukFtG+HvWwISfedd7GCX8s6Sk/fvJv61b8wsb9nqZQ
         hQdIOlYgjc61WfN17R4y3xMojN3hME1ZTHzZaXx59vceEMtiS6n/cYwX9ZIQy6HxCTDi
         Z9blQ0TeShD4s0ixTaYO2kSFXDSxieObLlklWJEbP8Ad34mSGiJtFyg/ZiYnAllSNkLJ
         /WFUPsXW+aHJCqX3qF5Q9pPoBel8aAJfXFeIf5Nnt/8wQzFbxQPIFjI7TMqC0EeG9Cds
         Edfg==
X-Forwarded-Encrypted: i=1; AFNElJ8dpaeh1Cqo/my3vJooFMRH1vcG/WBVyj2g0fNeZeYc9I2sCM2EXvXKjPIbtaW39/F8Gydbx7ydpvTd81bv0VU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yybx4lfe5yQgSgvLxzJf2oXvukAb8+RbMMabXpFlSAan0jkS6/9
	XspKkOCasCGTXd99hSUdS/EfxyHYeRyLkwb9Q+tCBMumvSS9APo43VICS/Lew0sT8FutgzBt1f+
	yhxTeE210hUiQmjX5vVqpD7IgUOf+XaU=
X-Gm-Gg: Acq92OFypUXL2OweWytK3NRQSUtRyyem9xe800SEXrtq6gAQOf+lnvEKydwH8eOvnqZ
	apiag6LF6VxxyahHlai2C9JZ/a6tl39ycF6OxpM0w3l96noNw2dtJbI1MD69i2Z/KfKTSlpbrCV
	/utcoO1qQtV+h/0CpHfkacUoTAuLVLgZSBl2MDWlw7xPH5x2m6+/xjJPf/SKquQEbYEr9i1j6qI
	sXF5KS0Q0OkOgsQ+6Uaff/bDI8Hc4xkPPBF6FOWBOy8qgNO4/ciwSpDzEv0vg7y8Gaojxvs3W5+
	af/1BmVnBzxpBG9QEOucY/64Z7ewypmG5YDADDAPJ1axh3suKWOIikmA10Ifl3V5X/MEmZXuztE
	y2v7EPvY=
X-Received: by 2002:a05:690e:d02:b0:64e:f106:60ea with SMTP id
 956f58d0204a3-65ec9938bb6mr23186309d50.44.1779898497803; Wed, 27 May 2026
 09:14:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260526060138.3924-1-adibente@gmail.com> <ahaek23tB7D8tQUe@strlen.de>
In-Reply-To: <ahaek23tB7D8tQUe@strlen.de>
From: =?UTF-8?Q?Adrian_Ben=C8=9Be?= <adibente@gmail.com>
Date: Wed, 27 May 2026 19:14:45 +0300
X-Gm-Features: AVHnY4KoQXI1OIdlCwJpu_wAoEyKtvQ1_8Zwx8HehnmyUWKWVvT2QHSF5yMJ68c
Message-ID: <CAC2HPwt_3D7k7tYr8OqNiguc-jMF3PEKtayFKmvOp37M2=QCZA@mail.gmail.com>
Subject: Re: [RFC PATCH net] netfilter: flowtable: fix offloaded ct timeout
 never being extended
To: Florian Westphal <fw@strlen.de>
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org, phil@nwl.cc, 
	nbd@nbd.name, sean.wang@mediatek.com, lorenzo@kernel.org, 
	andrew+netdev@lunn.ch, matthias.bgg@gmail.com, 
	angelogioacchino.delregno@collabora.com, daniel@makrotopia.org, 
	coreteam@netfilter.org, linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

> I guess we need to open-code expires, something like this (not even
> compile tested). Also see https://sashiko.dev/#/patchset/20260526060138.3924-1-adibente%40gmail.com
>
> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c
> @@ -506,7 +506,12 @@ static u32 nf_flow_table_tcp_timeout(const struct nf_conn *ct)
>  static void nf_flow_table_extend_ct_timeout(struct nf_conn *ct)
>  {
>         static const u32 min_timeout = 5 * 60 * HZ;
> -       u32 expires = nf_ct_expires(ct);
> +       u32 ct_timeout = READ_ONCE(ct->timeout);
> +       s32 expires;
> +
> +       expires = ct_timeout - nfct_time_stamp;
> +       if (expires <= 0) /* already expired */
> +               return;
>
>         /* normal case: large enough timeout, nothing to do. */
>         if (likely(expires >= min_timeout))
> @@ -524,7 +529,7 @@ static void nf_flow_table_extend_ct_timeout(struct nf_conn *ct)
>         if (nf_ct_is_confirmed(ct) &&
>             test_bit(IPS_OFFLOAD_BIT, &ct->status)) {
>                 u8 l4proto = nf_ct_protonum(ct);
> -               u32 new_timeout = true;
> +               u32 new_timeout = 1;
>
>                 switch (l4proto) {
>                 case IPPROTO_UDP:
> @@ -549,7 +554,7 @@ static void nf_flow_table_extend_ct_timeout(struct nf_conn *ct)
>                  */
>                 if (new_timeout) {
>                         new_timeout += nfct_time_stamp;
> -                       cmpxchg(&ct->timeout, expires, new_timeout);
> +                       cmpxchg(&ct->timeout, ct_timeout, new_timeout);
>                 }
>         }
>

Thanks. Applied your diff to my OpenWrt 6.18 tree with one small
adjustment: changed min_timeout from u32 to s32 so the
"expires >= min_timeout" comparison has both operands signed.
Compiles clean.

Tested on MT7986 with the WED-offloaded flows that originally
reproduced the 300s drop. The flows now stay up well past 300s with
normal offloaded traffic, solution works fine.

I'll send v2 with this diff and Suggested-by: you, unless you'd
rather submit it yourself.
