Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137822FDC30
	for <netfilter-devel@vger.kernel.org>; Sat,  4 Jul 2026 07:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783151460; cv=pass; b=f0K5Bu53tP8AowOekIpgc4S4od1vyqwCLKvbuuX9QvEbatWqdML5TtcAdfPGaAqDJ8FvU0N36LSNoxDtkvDYUs72RzVTrZjm/QFwpegBSF9oUuAOXXU+OlB6pkUUbcEo+hs/hc/+eQguZgX8RwQIPsfckY3/hDZPvGZwlQe6Mpg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783151460; c=relaxed/simple;
	bh=uNo5cOEROHeeGIhzUj73zefaYTeeNnptnF04h0RWDus=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fGqeT7DUgl6OzdQYxQQOTCsAZwxzS65ygqMz+7Ehjd3vQWP7+vhrfb21M+3AB40Icael/JuGsZRbCs02iN84vdIZL6hGl2xbjvK4G6BfRtmWMPThKEBVaV3wbriUKhWvOTnV6/sejR9BVk67p/JzFepnihaOoN/lPmR4dGgsh7M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UEf+tFPi; arc=pass smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UEf+tFPi"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8f1e274ccb9so5682966d6.2
        for <netfilter-devel@vger.kernel.org>; Sat, 04 Jul 2026 00:50:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783151451; cv=none;
        d=google.com; s=arc-20260327;
        b=nFW9LBmDZ5teXioq1E2Y9hFYQkBwffUe8N0NqyM7VNMj5zQjUSHcC3ooU6gM+ijRQN
         IZk9jSWG3XQ816ye7WRYoLY2AyfgBWXD6Vtmn7MroGJn5biC9qpWUbStXh41XuXNLAA+
         eaM9lPVo+/uk7+vF0+XucnR2cR7gpbJWCbOqUxQaxAKA4OMWh8MOqM6f9AcfvmnfRbld
         lPSne11B1kKz3e3H2xOMi5cyry522KlO/95lgSitN3Rr5CA4q+9oPREKS9wgHYWyV4l/
         IaKYmwYraGF2Cs2E79vfb9Wxbif5yL8LhRp+qOVNHaT0Z6bI1lX6Ag3T1H0bd/hTLea9
         9wwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iVfC7lKghoHO2BxeSTad/SpLmTYI1QrY4tV96exbmgY=;
        fh=O+T08zG0Jxim4NZmISGzEGj0jp+BDahwuesRR8jJrX0=;
        b=n93RzhyeqVSc2fg/5J3FFRjVUpNZhvw654Klz6pFr969/Srp/2kpD7Cd9uUnkFuw8t
         +HTJBbWWSximdkmOg/T55URmGvFH9rxkKvPNbuLVNbELar7JUVDxHGDbLqlWAr6dpJSk
         7kxY0T8RmvPhC4lE8ZeYp8sCDhZ4SjpJnYAzizoK3oobJkIKGNWrWu8Ou/6Iky/msJJf
         CeqOLSQFaAExNM9DuGMtbczgXi3HIRPK4qzoTRyUS910cR6/srSpvI8/k97jknOIszi5
         QR44BHjeg0Vy0YFbaUpoRS+HFKzMiNA6UdrfkjHD2SfS10AvP75qDzVInmmxd0eJwQpN
         mmUA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783151451; x=1783756251; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iVfC7lKghoHO2BxeSTad/SpLmTYI1QrY4tV96exbmgY=;
        b=UEf+tFPiKuiM3hq1WR5nUo8nnzofVowTN/wWSPWphn2yLbtm3erznE4LsfRy4AhwEy
         v9HCbw8kDfmJH6xFyLL7Y271Dq+abksrP7RDNn9zqQ6/KmhiWFJ1bulVcZXZXDg1tzya
         eqW5+d87NIDEF7Hg+sQkESdNr1B4EAmy0fvBQEFG+3CMIb3K0WJ1P27I9kW7tkvPya2I
         ctNEwZCcFjyO0RyLp15AV2Xlvw+igV1g05YXK2FBXKot2jSLQjKnaWq2Q2gf6uf9f4R1
         yEdC0uxcABgaCbNLWlbMA3Zn1N0yiM75ECYuMMN6XCQP7eRU94FD2vPqPsw/Y9YiVTPD
         qeGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783151451; x=1783756251;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iVfC7lKghoHO2BxeSTad/SpLmTYI1QrY4tV96exbmgY=;
        b=Mo1s3CwLva1kskYRSnZiSYquPu0JOngCryDgzSJa7ixikPBO5gCVDQDxl3wDYUtkRr
         4P+7SjjSn7uUBAJfkaTu5BG6jCfG7hk27oeXjNO7HPVnY6d2oECq0MJzlTD9AufXsknW
         TtnRUY5wpeO89EjQP0YHhQSvp81jMpsaCRMWhYSpe3hwMtA6azPZs923JgRWaLLIe8Mr
         WqgIX0gpsVMVGaTtsxL2kr5XjzP/vt4mP0DNhtJHV4bjcrd3TX4zDKr9qqJnCfrJtrU5
         FD8DiLrXH8pS6VEOhotNYCxNyJ+77Qj/qNttAwAek1swvqUVEVA4MRbOoaE2iTK1cw5n
         EkAg==
X-Forwarded-Encrypted: i=1; AHgh+RqkwoVv1i1+N31TBPnZ61AdJ4InmoawF2aCA4e9yd27Wd+PS7fTheJ4+b9fg/FQu9UTLBtYVha21/eOKu9JMUE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhvnU7fpcBuAbOHGdqHZ4ubah+B5+ORdDCw8rfpi5EUak/ylmO
	Aplmf1WLimoSZl/wCNWdQ+5d5Nh+TFrGKF0R8qyT0oNbGRfE9XDJASA2vFwTFTjepuLlCh72si4
	EPfVEylr3FHomyFJ/kQ9lxvmTcsXVtMY=
X-Gm-Gg: AfdE7cmHYNq7kmSQ58dqgcVB0YEdFnIDLL2TfDZxEtDUET/F0O7R+mrVRwKDvPc8bql
	xnhnDV9j/0NAHzxrA1b6BajGcGtvx9A7sG7XBZc4uiMX+Hbl5N8TPmYt0T44fjtiqEH6HKrQZoh
	5pQzSU1IMBzD/yD+O/ScgQcY9B4+szMAHSlRWniIg18GyT7ATefuW0ES639NCHRsNXqksQOJz3I
	eR/bRdGF8dMMAcmEjDjEuWEr0M84Kj0uyFD2Y+ksdjIgPQWiLp2QXM1G9bEj7mLKOvksnaQ
X-Received: by 2002:a05:6214:5d12:b0:8f2:d87e:24be with SMTP id
 6a1803df08f44-8f74bfa0f55mr37545026d6.41.1783151450948; Sat, 04 Jul 2026
 00:50:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cb8bfe944f4afa8cec437fc15210a3d094612859.1780803571.git.royenheart@gmail.com>
 <53245eb5-baac-4e04-a632-1b722ea18972@gmail.com> <akin0oTJJ47AL432@strlen.de>
In-Reply-To: <akin0oTJJ47AL432@strlen.de>
From: Yuan Tan <yuantan098@gmail.com>
Date: Sat, 4 Jul 2026 00:50:40 -0700
X-Gm-Features: AVVi8CddsDweRcmktAS82Ier2vItIHAbSe2G91f3rFc-QkMoqFGrXvNT4tmWirI
Message-ID: <CAPuPA7+RirdtnkJ2-RLpVcO1gEDn_wiCayGWBS1gDciAe1BxwA@mail.gmail.com>
Subject: Re: [PATCH nf v5 1/1] bridge: br_netfilter: pin bridge device while
 NFQUEUE holds fake dst
To: Florian Westphal <fw@strlen.de>
Cc: Haoze Xie <royenheart@gmail.com>, pablo@netfilter.org, phil@nwl.cc, 
	yifanwucs@gmail.com, tomapufckgml@gmail.com, bird@lzu.edu.cn, 
	netfilter-devel@vger.kernel.org, Ren Wei <n05ec@lzu.edu.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 3, 2026 at 11:27=E2=80=AFPM Florian Westphal <fw@strlen.de> wro=
te:
>
> Haoze Xie <royenheart@gmail.com> wrote:
> > > --- a/net/netfilter/nfnetlink_queue.c
> > > +++ b/net/netfilter/nfnetlink_queue.c
> > > @@ -1214,6 +1214,9 @@ dev_cmp(struct nf_queue_entry *entry, unsigned =
long ifindex)
> > >
> > >     if (physinif =3D=3D ifindex || physoutif =3D=3D ifindex)
> > >             return 1;
> > > +
> > > +   if (entry->bridge_dev && entry->bridge_dev->ifindex =3D=3D ifinde=
x)
> > > +           return 1;
> > >  #endif
> > >     if (entry->skb_dev && entry->skb_dev->ifindex =3D=3D ifindex)
> > >             return 1;
> >
> > Hi, is there any follow up about this patch?
>
> What do you mean, can you elaborate?
>
> What is wrong with
>
> c9c9b37f8c55 ("netfilter: nf_queue: pin bridge device while NFQUEUE holds=
 fake dst")
>
> If the patch is not sufficient, please submit a followup.

Sorry, we thought this patch had not been reviewed or merged.

The patch is good and we just notice this patch has already been merged:
https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git/commit/?id=
=3Dc9c9b37f8c5505224e8d206184df3bb668ee00cf
